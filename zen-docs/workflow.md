# Complete Workflow Guide

## Daily Workflow

### Morning: Start Fresh

```bash
zen-up                       # Start container
zen-push my-project          # Push to airlock
playground                   # Enter container
```

### Working in Container

```bash
cd /WIP-ai/my-project
whereami                     # Check location

# Read project status
cat /home/developer/.local/share/zenyatta/agents.md

# Use AI assistant
claude                       # Claude Code
# OR
opencode                     # opencode-ai
# OR
# Manually code/edit

# Test your changes
npm install
npm run dev                  # Access at localhost:5173

# Update status when done
nano /home/developer/.local/share/zenyatta/agents.md

# Leave container
exit
```

### Evening: Audit and Commit

```bash
# You're back on host after 'exit'
zen-safe-pull my-project     # Visual diff in Meld

# In Meld: merge RIGHT → LEFT for approved changes

# Commit in real repo
cd ~/ai-playground/repos/my-project
git status
git diff
git add .
git commit -m "Applied AI suggestions"
git push

zen-down                     # Stop container
```

## Feature Branch Workflow

```bash
# Create feature branch in source
cd ~/ai-playground/repos/my-project
git checkout -b feature/new-component

# Sync to airlock
zen-push my-project

# Work in container
playground
cd /WIP-ai/my-project
# ... make changes ...
exit

# Audit
zen-safe-pull my-project

# Commit to feature branch
cd ~/ai-playground/repos/my-project
git add . && git commit -m "Add component"

# Test
npm run build && npm run test

# Merge to main
git checkout main
git merge feature/new-component
git push origin main

# Clean up
git branch -d feature/new-component
```

## Quick Iteration Loop

For rapid changes:

```bash
# 1. Sync once
zen-push my-project

# 2. Work → audit → work → audit (repeat)
playground
# ... work ...
exit
zen-safe-pull my-project  # Don't commit yet

# More changes needed?
playground
# ... more work ...
exit
zen-safe-pull my-project

# Satisfied? Commit all changes
cd ~/ai-playground/repos/my-project
git add . && git commit -m "Complete feature"
```

## Working on Multiple Files

The airlock syncs entire project:

```bash
# In container, work across multiple files
cd /WIP-ai/my-project
vim src/components/Header.jsx
vim src/styles/theme.css
vim src/utils/helpers.js

# All changes visible in audit
exit
zen-safe-pull my-project
# Meld shows all modified files
```

## Emergency: Discard All Changes

```bash
# If AI made bad changes, just re-sync
zen-push my-project
# This overwrites WIP/ with fresh copy from repos/
# All AI changes in airlock are lost
# Your source repo is untouched
```

## Working on Zenyatta Scaffold Itself

```bash
# Clone zenyatta into repos
cd ~/ai-playground/repos
git clone git@github.com:censay/zenyatta.git

# Sync it to airlock
zen-push zenyatta

# Work on scaffold with AI
playground
cd /WIP-ai/zenyatta
claude  # Edit Dockerfile, compose.yaml, docs, etc.
exit

# Audit changes
zen-safe-pull zenyatta

# Commit scaffold changes
cd ~/ai-playground/repos/zenyatta
git add .
git commit -m "Update scaffold"
git push

# Apply changes to your installation (optional)
cp -r ~/ai-playground/repos/zenyatta/* ~/zenyatta/
zen-rebuild
```
