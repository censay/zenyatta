# Zenyatta - Zero-Trust AI Sandbox

Secure development environment where AI works on copies of your code, and you manually approve every change.

**Repository:** github.com/censay/zenyatta

---

## Quick Start

```bash
# 1. Clone scaffold
git clone https://github.com/censay/zenyatta.git ~/zenyatta
cd ~/zenyatta

# 2. Run setup (creates ~/ai-playground/ workspace)
chmod +x setup.sh && ./setup.sh
source ~/.bashrc

# 3. (Optional) Edit API keys
nano ~/ai-playground/.env

# 4. Add your project
cd ~/ai-playground/repos
git clone <your-repo-url> my-project

# 5. Start and work
zen-up
zen-push my-project
playground
cd /WIP-ai/my-project
claude  # or opencode, or code manually
exit    # leave container

# 6. Review and commit
zen-meld my-project            # visual diff in Meld (merge RIGHT -> LEFT)
cd ~/ai-playground/repos/my-project
git add . && git commit -m "AI changes"
```

---

## Security Model

**Airlock Pattern:**
1. Your source repos in `~/ai-playground/repos/` (pristine, with .git)
2. Sync copies to `~/ai-playground/WIP/` (no .git directory)
3. AI works in container on `WIP/` copies
4. You review ALL changes in Meld
5. You manually merge approved changes back
6. Only YOU commit with YOUR git identity

**Container CANNOT:** commit to git, access your repos, access SSH keys or credentials.

---

## Structure

```
~/zenyatta/              # Scaffold installation
├── Dockerfile
├── compose.yaml
├── setup.sh, sync.sh, audit.sh
├── claude.md, agents.md
├── REFERENCE.md         # Full reference doc
└── .env.example

~/ai-playground/         # Workspace (created by setup)
├── repos/               # Your git repos
├── WIP/                 # Airlock (copies without .git)
├── .container_config/   # Settings
├── .container_share/    # State
└── .env                 # API keys
```

---

## Commands

All work from anywhere after `source ~/.bashrc`:

```bash
zen-up              # Start container
zen-down            # Stop container
zen-rebuild         # Rebuild container image
playground          # Enter container (type exit to leave)
zen-push <project>  # Copy repo to airlock (strips .git)
zen-meld <project>  # Visual diff airlock vs repo in Meld
zen-logs            # Tail container logs
zen-help            # Print command list
zen-workflow        # Print recommended workflow
zen-ref             # Print full REFERENCE.md to terminal
```

**Breadcrumbs:** Your prompt shows where you are:
- Host: `your-normal-prompt$`
- Container: `[ZENYATTA] /WIP-ai/project$`
- To leave container: type `exit`

---

## Documentation

Run `zen-ref` or read `REFERENCE.md` for the full reference covering:
dev server binding, persistence, API keys/Ollama, multi-project, troubleshooting, GitHub push.

---

## AI Tools Supported

- Claude Code (`claude`)
- opencode-ai (`opencode`)
- Other OpenAI-compatible tools

All follow same workflow and safety constraints.

---

## API Keys / Env

Zenyatta works without API keys for basic use. If you need them:

```bash
nano ~/ai-playground/.env    # Edit keys (see .env.example for options)
zen-down && zen-up           # Restart to pick up changes (no rebuild needed)
```

---

## What Persists

**Container running:** everything stays (leave it running between tasks — it's fine).
**zen-down → zen-up:** repos/, WIP/, config, state, .env survive. Processes, AI session context, temp files lost.
**zen-rebuild:** same + image rebuilt.

Your repos/ are never touched by the container.

---

## Contributing

```bash
cd ~/zenyatta
git add . && git commit -m "Update scaffold" && git push
```

---

**Questions?** Run `zen-help` or read `REFERENCE.md`.
