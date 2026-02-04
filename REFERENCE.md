# Zenyatta Reference

## Commands

```
zen-up              Start container
zen-down            Stop container
zen-rebuild         Rebuild image (use after Dockerfile changes)
playground          Enter container (type exit to leave)
zen-push <project>  Copy repo to airlock (strips .git)
zen-meld <project>  Visual diff airlock vs repo in Meld
zen-logs            Tail container logs
zen-help            Print command list
zen-workflow        Print workflow steps
zen-ref             Print this file
```

## Dev Server Binding

Dev servers inside the container must bind to `0.0.0.0` to be visible on the host.
The `HOST=0.0.0.0` env var is set in the Dockerfile (works for Vite automatically).
If a server still isn't visible: `npm run dev -- --host 0.0.0.0`
Ports forwarded: 5173 (Vite), 3000 (Next.js), 8080 (general).

## Persistence

AI tools create temp session data (conversation history, caches) in /tmp/ or ~/.cache.
That's lost on container stop. agents.md is on a mounted volume — always survives.

**Container running (fine to leave up):** everything stays. No reason to stop between tasks.
**zen-down → zen-up:** /WIP-ai/, claude.md, agents.md, .env survive. Processes, /tmp/, AI session state, runtime-installed packages lost.
**zen-rebuild:** same + image rebuilt (apt-get packages not in Dockerfile gone).
repos/ is never mounted into the container — always safe on host.
Wipe airlock only: `rm -rf ~/ai-playground/WIP/*` then `zen-push`

## API Keys / Ollama

Edit `~/ai-playground/.env` (NOT `~/zenyatta/.env`).
See `.env.example` for supported keys (Anthropic, OpenAI, NVIDIA, Ollama).
After editing .env: `zen-down` then `zen-up` (no rebuild needed for env-only changes).
Ollama same machine: `OLLAMA_HOST=localhost:11434`
Ollama remote: `OLLAMA_HOST=192.168.1.100:11434`

## Multi-Project

zen-push syncs to ~/ai-playground/WIP/ which is bind-mounted into the container.
You can zen-push while the container is running — files appear instantly at /WIP-ai/.

```bash
# Push multiple repos (container can be running)
zen-push project-a
zen-push project-b

# Enter once, both are there
playground
ls /WIP-ai/          # project-a/ project-b/
cd /WIP-ai/project-a && claude

# Exit, review each separately
exit
zen-meld project-a
zen-meld project-b
```

Use tmux inside the container if working on multiple projects simultaneously.

## Troubleshooting

**Container won't start:** `zen-logs`, fix .env syntax, `zen-rebuild`
**Project not in container:** did you `zen-push`? Check `ls ~/ai-playground/repos/`
**Meld shows no diff:** don't `zen-push` after working -- that overwrites airlock
**Aliases not working:** `source ~/.bashrc`
**Dev server not visible:** use `--host 0.0.0.0` flag (see Dev Server Binding above)
**Permissions:** `sudo chown -R $USER:$USER ~/ai-playground/`
**Nuclear reset:** `zen-down && rm -rf ~/ai-playground/.container_* && zen-rebuild`

## GitHub Push

```bash
cd ~/ai-playground/repos/my-project
git add . && git commit -m "AI changes" && git push
```

Scaffold itself:
```bash
cd ~/zenyatta && git add . && git commit -m "Update scaffold" && git push
```

Clone on new machine: `git clone <url> ~/zenyatta && cd ~/zenyatta && ./setup.sh`
