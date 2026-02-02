---
name: Create Data Science Project
description: Instructions for AI agents on how to create a new Data Science project using Kedro standards.
---

# Create Data Science Project Skill

This skill allows agents to bootstrap a new Data Science project following the `deagentic` organization standards.

## Prerequisites

- Python installed (3.10+ recommended).
- `kedro` installed (`pip install kedro`).

## Instructions

### 1. Identify Project Details

Ask the user for:

- **Project Name**: (e.g., "Demand Forecasting")
- **Repo Name**: (e.g., "demand-forecasting")

### 2. Run Kedro New

Execute the creation command using the `spaceflights` starter (or 'pandas-iris' for simple demos):

```bash
kedro new --starter=spaceflights --config=pyproject.toml --name="<Project Name>" --tools=lint,test,docs,data,viz
```

*Note: Pass the arguments explicitly to avoid interactive prompts if possible, or guide the user.*

### 3. Post-Creation Setup

After the folder is created:

1. `cd <repo-name>`
2. `git init`
3. `git add .`
4. `git commit -m "feat: initial commit from kedro starter"`
5. **(IMPORTANT)** Notify the user to create the remote repository on GitHub and link it.

## Example Usage

"I will create the 'Sales Predictor' project for you."
*Agent runs kedro new command*
"Project created in `ACERO/sales-predictor`. I have initialized git. Please create the repo on GitHub so I can push."
