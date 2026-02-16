#!/usr/bin/env bash
# sync_repos.sh — Clone or update all repos in the deagentic GitHub org.
#
# Usage:
#   ./sync_repos.sh [target_directory]
#
# If no target directory is given the current working directory is used.
# Requires the GitHub CLI (gh) to be installed and authenticated.

set -euo pipefail

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------
ORG="deagentic"
TARGET_DIR="${1:-.}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
log_info()  { printf "\033[0;36m[INFO]\033[0m  %s\n" "$1"; }
log_ok()    { printf "\033[0;32m[OK]\033[0m    %s\n" "$1"; }
log_err()   { printf "\033[0;31m[ERR]\033[0m   %s\n" "$1"; }

# ---------------------------------------------------------------------------
# Pre-flight checks
# ---------------------------------------------------------------------------
if ! command -v gh &>/dev/null; then
  log_err "GitHub CLI (gh) is not installed. See https://cli.github.com/"
  exit 1
fi

if ! gh auth status &>/dev/null; then
  log_err "GitHub CLI is not authenticated. Run 'gh auth login' first."
  exit 1
fi

# Ensure the target directory exists
mkdir -p "${TARGET_DIR}"
TARGET_DIR="$(cd "${TARGET_DIR}" && pwd)"   # resolve to absolute path
log_info "Target directory: ${TARGET_DIR}"

# ---------------------------------------------------------------------------
# Fetch repo list
# ---------------------------------------------------------------------------
log_info "Fetching repository list for org '${ORG}' …"

REPOS_JSON="$(gh repo list "${ORG}" --json name,sshUrl --limit 100)"
REPO_COUNT="$(echo "${REPOS_JSON}" | jq length)"

if [[ "${REPO_COUNT}" -eq 0 ]]; then
  log_err "No repositories found for org '${ORG}'."
  exit 1
fi

log_info "Found ${REPO_COUNT} repositories."

# ---------------------------------------------------------------------------
# Clone or pull each repository
# ---------------------------------------------------------------------------
SUCCESS=0
FAIL=0

for row in $(echo "${REPOS_JSON}" | jq -r '.[] | @base64'); do
  _jq() { echo "${row}" | base64 --decode | jq -r "${1}"; }

  NAME="$(_jq '.name')"
  SSH_URL="$(_jq '.sshUrl')"
  REPO_PATH="${TARGET_DIR}/${NAME}"

  if [[ -d "${REPO_PATH}/.git" ]]; then
    # Repository already cloned — pull latest changes
    log_info "Pulling ${NAME} …"
    if git -C "${REPO_PATH}" pull --ff-only; then
      log_ok "Pulled ${NAME}"
      ((SUCCESS++))
    else
      log_err "Failed to pull ${NAME}"
      ((FAIL++))
    fi
  else
    # Repository not present — clone it
    log_info "Cloning ${NAME} …"
    if git clone "${SSH_URL}" "${REPO_PATH}"; then
      log_ok "Cloned ${NAME}"
      ((SUCCESS++))
    else
      log_err "Failed to clone ${NAME}"
      ((FAIL++))
    fi
  fi
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
log_info "===== Sync complete ====="
log_info "Success: ${SUCCESS}  |  Failed: ${FAIL}  |  Total: ${REPO_COUNT}"

if [[ "${FAIL}" -gt 0 ]]; then
  log_err "Some repositories failed to sync."
  exit 1
fi

log_ok "All repositories synced successfully."
exit 0
