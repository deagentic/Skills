# Skills

Agent Skills for the deagentic organization. These skills teach AI coding agents how to perform specific tasks following deagentic standards.

## What are Skills?

Skills are markdown files that provide structured instructions for AI agents. They help agents:
- Follow consistent conventions and standards
- Execute complex workflows step-by-step
- Produce high-quality, auditable outputs

## Available Skills

| Skill | Description |
|-------|-------------|
| [SKILL_CREATE_PROJECT.md](./SKILL_CREATE_PROJECT.md) | Create new Data Science projects using Kedro standards |
| [SKILL_REPO_SYNC.md](./SKILL_REPO_SYNC.md) | Sync repositories across environments |
| [SKILL_CODE_REVIEW.md](./SKILL_CODE_REVIEW.md) | Review code following deagentic standards |

## Skill Structure

Each skill follows this format:

```markdown
---
name: Skill Name
description: Brief description of what the skill teaches
---

# Skill Name

## Prerequisites
- Required tools and setup

## Instructions
1. Step-by-step guide
2. Clear actions
3. Expected outputs

## Example Usage
Concrete examples of the skill in action
```

## Contributing

### Adding a New Skill

1. Create a new file: `SKILL_YOUR_SKILL_NAME.md`
2. Follow the structure above
3. Include:
   - Clear prerequisites
   - Step-by-step instructions
   - Concrete examples
   - References to relevant documentation
4. Submit a Pull Request

### Guidelines

- **Be specific**: Agents work best with clear, unambiguous instructions
- **Include examples**: Show exactly what good output looks like
- **Reference standards**: Link to relevant org documentation
- **Test your skill**: Verify an AI agent can follow the instructions successfully

## Helper Scripts

- `sync_repos.sh` / `sync_repos.ps1` — Repository synchronization scripts

## License

MIT
