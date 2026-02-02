# Working on Multiple Projects

## Adding Projects

```bash
cd ~/ai-playground/repos

# Clone
git clone <url> project-name

# Or copy
cp -r ~/existing ./

# Or move
mv ~/existing ./
```

## Switching Between

```bash
zen-push project-1
playground
# ... work ...
exit
zen-safe-pull project-1

zen-push project-2
playground
# ... work ...
exit
zen-safe-pull project-2
```

## Multiple Simultaneously

```bash
# Sync all
zen-push project-1
zen-push project-2

# Enter once
playground

# Use tmux for split screen
tmux
# Ctrl+B then " (split horizontal)
# Ctrl+B then arrow keys (navigate)

# Work on both
exit

# Audit both
zen-safe-pull project-1
zen-safe-pull project-2
```
