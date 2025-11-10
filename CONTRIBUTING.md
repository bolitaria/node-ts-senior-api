# Contributing Guide

## Workflow

### 1. For new features
```bash
./scripts/git-feature-start.sh feature-name
# Make your changes
npm run commit # For interactive commits
./scripts/git-feature-finish.sh
```

### For bug fixes+
```bash
git checkout -b bugfix/bug-description
# Make the fixes
npm run commit
git checkout develop
git merge --no-ff bugfix/bug-description
```

### For releases
```bash
./scripts/git-release-start.sh 1.2.0
# Perform final tests
git checkout main
git merge --no-ff release/v1.2.0
git tag v1.2.0
git push origin v1.2.0
```

### Commit Conventions
# feat: New feature
# fix: Bug fix
# docs: Documentation
# style: Formatting, semicolons, etc.
# refactor: Code refactoring
# test: Adding tests
# chore: Build changes, tools
# Code Standards
# Run npm run lint before committing
# Ensure all tests pass
# Maintain high test coverage

🚀 COMPLETE INSTALLATION SCRIPT
```bash
scripts/setup-complete.sh
```
