# Zenyatta Reference

## Commands

| Command | Description |
|---------|-------------|
| `zen-up` | Start container (`podman-compose up -d`) |
| `zen-down` | Stop container |
| `zen-rebuild` | Rebuild and restart container |
| `playground` | Enter container shell |
| `zen-logs` | Tail container logs |
| `zen-push <project>` | Copy repo to airlock (strips .git) |
| `zen-meld <project>` | Open Meld diff: source (LEFT) vs airlock (RIGHT) |
| `zen-gitfetch <repo>` | Clone `github.com/$USER/<repo>` into `~/ai-playground/repos/` |
| `zen-help` | List commands |

## Workflow

```
zen-gitfetch <repo>  →  checkout/create branch  →  zen-push <repo>
→  playground  →  work  →  exit  →  zen-meld <repo>  →  git commit
```

Meld merge direction: **RIGHT → LEFT** (AI changes into your source).

## Branch Workflow

Always check out or create a branch before pushing to airlock. AI work should happen on a dedicated branch so you can diff, review, and merge cleanly.

```bash
cd ~/ai-playground/repos/my-project
git checkout -b ai/feature-name
zen-push my-project
```

## Directory Layout

```
~/zenyatta/                          # Scaffold (clone of this repo)
~/ai-playground/repos/               # Your git repos (with .git)
~/ai-playground/WIP/                 # Airlock copies (no .git)
~/ai-playground/.container_config/   # Persisted container config
~/ai-playground/.container_share/    # Persisted container state
~/ai-playground/.zen-github-user     # GitHub username for zen-gitfetch
~/zenyatta/.env                      # API keys (optional, .gitignored)
```

## Container Paths

```
/WIP-ai/                            # Airlock workspace (your projects)
/home/developer/.local/share/zenyatta/claude.md   # AI instructions
/home/developer/.local/share/zenyatta/agents.md   # Project status
```

## Persistence

**Survives restart:** `/WIP-ai/` files, config, share, repos
**Lost on stop:** running processes, temp files
**Lost on removal (`podman rm`):** installed packages (unless in Dockerfile)

## Ports

| Port | Use |
|------|-----|
| 5173 | Vite/React |
| 3000 | Next.js |
| 8080 | General |

## .env Variables

```bash
ANTHROPIC_API_KEY=        # Claude API
OPENAI_API_KEY=           # OpenAI
NVIDIA_API_KEY=           # NVIDIA NIM
OLLAMA_HOST=              # Ollama endpoint (e.g. http://host.docker.internal:11434)
```

Edit at `~/zenyatta/.env` (.gitignored), then `zen-rebuild`.

## GitHub Push

After reviewing with `zen-meld` and committing:

```bash
cd ~/ai-playground/repos/my-project
git push origin ai/feature-name
```

All pushes happen from the host, never from the container.

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `podman-compose` not found | `pip3 install podman-compose` |
| Container won't start | `zen-rebuild` |
| Meld not installed | `sudo apt install meld` |
| Port conflict | Edit `compose.yaml` ports |
| zen-gitfetch: no username | `echo 'user' > ~/ai-playground/.zen-github-user` |
