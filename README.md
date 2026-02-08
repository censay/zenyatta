# Zenyatta - Zero-Trust AI Sandbox

Isolated container where AI works on copies of your code. You review every change in Meld before merging.

**Repository:** github.com/censay/zenyatta

---

## Quick Start

```bash
# Clone scaffold
git clone https://github.com/censay/zenyatta.git ~/zenyatta
cd ~/zenyatta && chmod +x setup.sh && ./setup.sh

# Get your project
zen-gitfetch my-project                        # or: cd ~/ai-playground/repos && git clone <url>
cd ~/ai-playground/repos/my-project
git checkout -b ai/feature-name                # check out or create a branch

# Work
zen-up                                         # start container
zen-push my-project                            # copy to airlock (strips .git)
playground                                     # enter container
cd /WIP-ai/my-project && claude                # work
exit                                           # leave container

# Review (RIGHT → LEFT in Meld)
zen-meld my-project                            # visual diff, merge what you approve
cd ~/ai-playground/repos/my-project
git add . && git commit -m "AI changes"
```

---

## Security Model

**Airlock pattern:**
1. Source repos in `~/ai-playground/repos/` (with .git)
2. `zen-push` copies to `~/ai-playground/WIP/` (no .git)
3. AI works on copies in container
4. `zen-meld` opens Meld — you merge approved changes back
5. Only you commit with your git identity

**Container cannot:** commit, push, access source repos, access SSH keys or credentials.

---

## Structure

```
~/zenyatta/              # Scaffold
├── Dockerfile
├── compose.yaml
├── setup.sh / sync.sh / audit.sh
├── claude.md / agents.md
├── REFERENCE.md
├── SECURITY.txt
└── .env                 # API keys (.gitignored)

~/ai-playground/         # Workspace (created by setup)
├── repos/               # Your git repos
├── WIP/                 # Airlock (no .git)
├── .container_config/   # App settings (persists)
├── .container_share/    # Session state (persists)
├── .container_claude/   # Claude Code auth (persists)
└── .zen-github-user
```

---

## AI Tools

- Claude Code (`claude`)
- opencode-ai (`opencode`)
- Other OpenAI-compatible tools

All follow the same airlock workflow.

---

## More Info

See [REFERENCE.md](REFERENCE.md) for commands, ports, .env variables, clipboard, and troubleshooting.

See [SECURITY.txt](SECURITY.txt) for container hardening details.
