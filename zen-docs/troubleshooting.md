# Troubleshooting

## Container won't start

```bash
zen-logs           # Check errors
nano ~/ai-playground/.env  # Fix syntax
zen-rebuild
```

## Project not found

```bash
ls ~/ai-playground/repos/  # See what's there
cd ~/ai-playground/repos
git clone <url> my-project
```

## Meld shows no differences

Check order:
```bash
# Wrong: playground → work → zen-push → zen-safe-pull  (overwrote changes!)
# Right: playground → work → exit → zen-safe-pull
```

## Aliases not working

```bash
source ~/.bashrc
alias | grep zen
```

## .git safety check fails

```bash
cd ~/ai-playground/repos/my-project
git init
git add .
git commit -m "Initial"
```

## Can't enter container

```bash
podman ps | grep zenyatta  # Running?
zen-up                     # Start if not
playground                 # Enter
```

## Permission denied

```bash
ls -la ~/ai-playground/repos/
sudo chown -R $USER:$USER ~/ai-playground/
```

## When all else fails

```bash
zen-down
rm -rf ~/ai-playground/.container_*
zen-rebuild
# Your repos/ are safe
```
