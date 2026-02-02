# Publishing Zenyatta to GitHub

## What to Commit

From `~/zenyatta/` (scaffold):
- Dockerfile, compose.yaml
- setup.sh, sync.sh, audit.sh
- claude.md, agents.md
- README.md, zen-docs/
- .env.example, .gitignore

## Initial Push

```bash
cd ~/zenyatta
git init
git add .
git commit -m "Zenyatta scaffold"
git remote add origin git@github.com:censay/zenyatta.git
git branch -M main
git push -u origin main
```

## Update After Changes

```bash
cd ~/zenyatta
git add .
git commit -m "Update scaffold"
git push
```

## Clone on Another Machine

```bash
git clone git@github.com:censay/zenyatta.git ~/zenyatta
cd ~/zenyatta
./setup.sh
source ~/.bashrc

# Add your projects
cd ~/ai-playground/repos
git clone <your-projects>

zen-up
```

## Separate Repos

- `~/zenyatta/` - Scaffold (push to censay/zenyatta)
- `~/ai-playground/repos/personal-site/` - Your project (separate repo)
- `~/ai-playground/repos/zenyatta/` - Clone of scaffold for editing

Each pushes independently.
