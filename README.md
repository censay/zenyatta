# 🧘 Zenyatta - Zero-Trust AI Sandbox

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
└── .env                 # API keys (.gitignored)

~/ai-playground/         # Workspace (created by setup)
├── repos/               # Your git repos
├── WIP/                 # Airlock (no .git)
├── .container_config/
├── .container_share/
└── .zen-github-user
```

---

## Commands

```
zen-up              Start container
zen-down            Stop container
zen-rebuild         Rebuild container
playground          Enter container (exit to leave)
zen-logs            View logs
zen-push <project>  Push repo to airlock
zen-meld <project>  Visual diff with Meld
zen-gitfetch <repo> Clone from your GitHub into repos/
zen-help            Command list
```

**Prompt breadcrumbs:**
- Host: `your-normal-prompt$`
- Container: `[🧘 ZENYATTA] /WIP-ai/project$`

---

## AI Tools

- Claude Code (`claude`)
- opencode-ai (`opencode`)
- Other OpenAI-compatible tools

All follow the same airlock workflow.

---

## Optional: API Keys

Only needed for Ollama, NVIDIA API, or other services.

```bash
nano ~/zenyatta/.env
zen-rebuild
```

See REFERENCE.md for details.
