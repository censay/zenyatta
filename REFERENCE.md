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
~/ai-playground/.container_claude/   # Claude Code auth (persists across rebuilds)
~/ai-playground/.zen-github-user     # GitHub username for zen-gitfetch
~/zenyatta/.env                      # API keys (optional, .gitignored)
```

## Container Paths

```
/WIP-ai/                             # Airlock workspace (your projects)
/root/.local/share/zenyatta/claude.md    # AI instructions
/root/.local/share/zenyatta/agents.md    # Project status
/root/.claude/                           # Claude Code config & auth
```

## Persistence

**Survives restart:** `/WIP-ai/` files, config, share, repos, Claude auth
**Lost on stop:** running processes, temp files
**Lost on removal (`podman rm`):** installed packages (unless in Dockerfile)

## Ports

| Port | Use |
|------|-----|
| 5173 | Vite/React |
| 3000 | Next.js |
| 8080 | General |

## .env Variables

See `.env.example` for all supported providers:
- **AI APIs:** Anthropic, OpenAI, Google, Groq, Together, Mistral, Azure
- **Local/Network:** Ollama (supports `192.168.x.x` or `host.docker.internal`)
- **Other:** NVIDIA NIM, X11 display overrides

Edit at `~/zenyatta/.env` (.gitignored), then `zen-rebuild`.

## Clipboard

Container includes `xclip` for X11 clipboard access:

```bash
echo "text" | xclip -selection clipboard   # copy
xclip -selection clipboard -o              # paste
```

Works on native Linux, WSLg (Windows 11), and WSL2+VcXsrv.

## Security

See [SECURITY.txt](SECURITY.txt) for container hardening details:
- Capability restrictions (least privilege)
- X11 authentication (XAUTHORITY vs xhost)
- Airlock security model

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
