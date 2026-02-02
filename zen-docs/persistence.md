# What Persists vs What Disappears

## Always Persists (on host)

```
~/zenyatta/                      Scaffold files
~/ai-playground/repos/           Your source repos
~/ai-playground/WIP/             Airlock copies
~/ai-playground/.container_config/    Settings
~/ai-playground/.container_share/     State (claude.md, agents.md)
```

## Disappears on `zen-down`

- Running processes
- /tmp/ files

## Disappears on `podman rm zenyatta`

- Same as above, plus:
- Packages installed with apt-get (unless in Dockerfile)

## Disappears on `zen-rebuild`

- Nothing additional (volumes separate from images)

## Starting Fresh

```bash
# Wipe AI workspace only
rm -rf ~/ai-playground/WIP/*
zen-push my-project

# Wipe container state
rm -rf ~/ai-playground/.container_*
zen-rebuild

# Your repos/ are always safe
```
