<#
.SYNOPSIS
    Clone or update all repos in the deagentic GitHub org.

.DESCRIPTION
    PowerShell equivalent of sync_repos.sh.
    Requires the GitHub CLI (gh) to be installed and authenticated.

.PARAMETER TargetDir
    Directory where repositories will be cloned/pulled.
    Defaults to the current directory.

.EXAMPLE
    .\sync_repos.ps1
    .\sync_repos.ps1 -TargetDir "C:\repos\deagentic"
#>

[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$TargetDir = "."
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
$Org = "deagentic"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
function Write-Info  { param([string]$Msg) Write-Host "[INFO]  $Msg" -ForegroundColor Cyan }
function Write-Ok    { param([string]$Msg) Write-Host "[OK]    $Msg" -ForegroundColor Green }
function Write-Err   { param([string]$Msg) Write-Host "[ERR]   $Msg" -ForegroundColor Red }

# ---------------------------------------------------------------------------
# Pre-flight checks
# ---------------------------------------------------------------------------
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    Write-Err "GitHub CLI (gh) is not installed. See https://cli.github.com/"
    exit 1
}

try {
    gh auth status 2>&1 | Out-Null
}
catch {
    Write-Err "GitHub CLI is not authenticated. Run 'gh auth login' first."
    exit 1
}

# Ensure the target directory exists and resolve to absolute path
if (-not (Test-Path -Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}
$TargetDir = (Resolve-Path -Path $TargetDir).Path
Write-Info "Target directory: $TargetDir"

# ---------------------------------------------------------------------------
# Fetch repo list
# ---------------------------------------------------------------------------
Write-Info "Fetching repository list for org '$Org' ..."

$ReposRaw = gh repo list $Org --json name,sshUrl --limit 100
$Repos    = $ReposRaw | ConvertFrom-Json

if ($Repos.Count -eq 0) {
    Write-Err "No repositories found for org '$Org'."
    exit 1
}

Write-Info "Found $($Repos.Count) repositories."

# ---------------------------------------------------------------------------
# Clone or pull each repository
# ---------------------------------------------------------------------------
$Success = 0
$Fail    = 0

foreach ($Repo in $Repos) {
    $Name    = $Repo.name
    $SshUrl  = $Repo.sshUrl
    $RepoPath = Join-Path -Path $TargetDir -ChildPath $Name

    if (Test-Path -Path (Join-Path -Path $RepoPath -ChildPath ".git")) {
        # Repository already cloned — pull latest changes
        Write-Info "Pulling $Name ..."
        try {
            git -C $RepoPath pull --ff-only
            Write-Ok "Pulled $Name"
            $Success++
        }
        catch {
            Write-Err "Failed to pull ${Name}: $_"
            $Fail++
        }
    }
    else {
        # Repository not present — clone it
        Write-Info "Cloning $Name ..."
        try {
            git clone $SshUrl $RepoPath
            Write-Ok "Cloned $Name"
            $Success++
        }
        catch {
            Write-Err "Failed to clone ${Name}: $_"
            $Fail++
        }
    }
}

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
Write-Host ""
Write-Info "===== Sync complete ====="
Write-Info "Success: $Success  |  Failed: $Fail  |  Total: $($Repos.Count)"

if ($Fail -gt 0) {
    Write-Err "Some repositories failed to sync."
    exit 1
}

Write-Ok "All repositories synced successfully."
exit 0
