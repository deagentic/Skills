---
name: Repository Synchronization
description: Instructions for AI agents on how to synchronize the deagentic organization repositories found in the ACERO folder.
---

# Repository Synchronization Skill

This skill allows any AI agent to keep the local `ACERO` folder synchronized with the remote GitHub repositories of the `deagentic` organization.

## Context

The `ACERO` folder serves as a central hub for all `deagentic` repositories (`knowledge-base`, `.github`, `Skills`). It is crucial that these are kept up-to-date before starting any new task.

## Instructions

### 1. Identify the Operating System

Determine the OS of the environment you are running in.

### 2. Execute the Sync Script

Navigate to the root `ACERO` directory and execute the appropriate script.

#### For Windows (PowerShell)

Execute the PowerShell script:

```powershell
.\sync_repos.ps1
```

#### For Linux / MacOS (Bash)

Execute the Bash script:

```bash
./sync_repos.sh
```

### 3. Handle Output

- **Success**: If the output indicates "Successfully synced", proceed with your task.
- **Error**: If an error occurs (e.g., merge conflict), **STOP** and notify the user immediately. Do not attempt to resolve merge conflicts automatically unless explicitly instructed.

## Example Usage

"I will now sync the repositories to ensure I have the latest artifacts."
*Agent runs `.\sync_repos.ps1`*
"Repositories synced successfully. Proceeding to update the `knowledge-base`..."
