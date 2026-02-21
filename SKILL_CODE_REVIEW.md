---
name: Code Review
description: Instructions for AI agents on how to review code following deagentic standards.
---

# Code Review Skill

This skill teaches agents how to perform thorough code reviews following `deagentic` organization standards.

## Prerequisites

- Access to the repository being reviewed
- `ruff` installed (`pip install ruff`)
- `mypy` or type checker installed (`pip install mypy`)
- `pytest` installed for test coverage analysis

## Instructions

### 1. Run Automated Checks

Before manual review, run automated tools:

#### Linting with Ruff

```bash
ruff check . --output-format=concise
```

Report any issues found. Common categories:
- Import sorting (I001, I002)
- Unused imports/variables (F401, F841)
- Code complexity (C901)

#### Type Hint Validation

```bash
mypy . --ignore-missing-imports
```

Check for:
- Missing type hints on public functions
- Type mismatches
- `Any` overuse

### 2. Test Coverage Analysis

```bash
pytest --cov=src --cov-report=term-missing
```

Evaluate:
- Overall coverage percentage (target: >80%)
- Uncovered critical paths
- Missing edge case tests

### 3. Manual Review Checklist

After automated checks, review manually:

#### Code Quality
- [ ] Functions are small and focused (single responsibility)
- [ ] Variable names are descriptive
- [ ] No hardcoded values (use constants or config)
- [ ] Error handling is appropriate

#### Documentation
- [ ] Public functions have docstrings
- [ ] Complex logic has inline comments
- [ ] README is updated if needed

#### Security
- [ ] No secrets in code
- [ ] Input validation present
- [ ] SQL injection / XSS prevention (if applicable)

#### Performance
- [ ] No obvious N+1 queries
- [ ] Appropriate data structures used
- [ ] No unnecessary loops or redundant operations

### 4. Provide Feedback

Structure feedback as:

```markdown
## Summary
[Overall assessment: Approved / Changes Requested / Needs Discussion]

## Automated Check Results
- Ruff: X issues found
- Mypy: X type errors
- Coverage: X%

## Findings

### Critical (Must Fix)
- [List blocking issues]

### Suggestions (Nice to Have)
- [List improvements]

### Praise
- [Highlight good patterns observed]
```

## Example Usage

"I will review the changes in PR #42."

*Agent runs ruff, mypy, pytest*

"Automated checks complete:
- Ruff: 2 issues (unused import in utils.py, line too long in main.py)
- Mypy: Clean
- Coverage: 85%

Manual review findings:
- The new `calculate_metrics` function is well-structured
- Suggestion: Consider extracting the validation logic into a separate function
- Critical: Missing error handling for API timeout in line 145"

## References

- [deagentic coding standards](https://github.com/deagentic/agentic-engineering/blob/main/docs/wiki.md)
- [Ruff documentation](https://docs.astral.sh/ruff/)
- [Python type hints guide](https://docs.python.org/3/library/typing.html)
