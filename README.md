# 🧪 Zenyatta - Zero-Trust AI Sandbox

Secure development environment where AI works on copies of your code, and you manually approve every change.

**Repository:** github.com/censay/zenyatta

---

## 🚀 Quick Start

```bash
# 1. Clone to ~/zenyatta/ (scaffold location)
git clone https://github.com/censay/zenyatta.git ~/zenyatta
cd ~/zenyatta

# 2. Run setup (creates ~/ai-playground/ workspace)
chmod +x setup.sh && ./setup.sh
source ~/.bashrc

# 3. Add your project (choose one):
cd ~/ai-playground/repos

# Option A: Clone from GitHub (recommended)
git clone <your-repo-url> my-project

# Option B: Clone zenyatta itself to work on scaffold
git clone git@github.com:censay/zenyatta.git

# Option C: Copy existing (for testing)
cp -r ~/existing-project ./my-project

# Option D: Move existing (permanent)
mv ~/existing-project ./my-project

# 4. Start zenyatta
zen-up

# 5. Sync project to airlock
zen-push my-project

# 6. Enter and work
playground
cd /WIP-ai/my-project
claude  # or opencode, or code manually
# When done: type 'exit' to leave container

# 7. Exit and audit
exit  # Leaves container, returns to host
zen-safe-pull my-project

# 8. Commit approved changes
cd ~/ai-playground/repos/my-project
git add . && git commit -m "AI changes"
```

---

## 🔒 Security Model

**Airlock Pattern:**
1. Your source repos in `~/ai-playground/repos/` (pristine, with .git)
2. Sync copies to `~/ai-playground/WIP/` (no .git directory)
3. AI works in container on `WIP/` copies
4. You review ALL changes in Meld
5. You manually merge approved changes back
6. Only YOU commit with YOUR git identity

**Container CANNOT:**
- Commit to git (no .git in airlock)
- Access your source repos (not mounted)
- Access your SSH keys
- Access your credentials

---

## 📁 Structure

```
~/zenyatta/              # Scaffold installation
├── Dockerfile
├── compose.yaml
├── setup.sh            # Run from here
├── sync.sh
├── audit.sh
├── claude.md
├── agents.md
└── zen-docs/

~/ai-playground/        # Workspace (created by setup)
├── repos/              # Your git repos
│   ├── zenyatta/      # (optional) work on scaffold
│   └── my-projects/
├── WIP/                # Airlock
├── .container_config/  # Settings
├── .container_share/   # State
└── .env                # API keys
```

---

## 🎮 Commands

All work from anywhere after `source ~/.bashrc`:

```bash
zen-up              # Start container
zen-down            # Stop container
zen-rebuild         # Rebuild container
playground          # Enter container (type 'exit' to leave)
zen-logs            # View logs
zen-push <project>  # Push to airlock
zen-safe-pull <project>  # Visual diff with Meld
```

**💡 Breadcrumbs:** Your prompt shows where you are:
- Host: `your-normal-prompt$`
- Container: `[🧪 ZENYATTA] /WIP-ai/project$`
- To leave container: type `exit`

---

## 📚 Documentation

See `zen-docs/` for detailed guides:

- **workflow.md** - Complete daily workflow
- **persistence.md** - What survives restarts
- **ollama-setup.md** - Configuring Ollama
- **multi-project.md** - Working on multiple repos
- **troubleshooting.md** - Common issues
- **github-push.md** - Publishing to GitHub

---

## 🛠️ AI Tools Supported

- Claude Code (`claude`)
- opencode-ai (`opencode`)
- Other OpenAI-compatible tools

All follow same workflow and safety constraints.

---

## ⚙️ Optional: Ollama / API Keys

Zenyatta works fine without .env file.

Only needed if you use:
- Ollama (local LLM)
- NVIDIA API
- Other API services

To configure:
```bash
# .env is in ~/ai-playground/ (not ~/zenyatta/)
nano ~/ai-playground/.env
zen-rebuild
```

See `zen-docs/ollama-setup.md` for details.

---

## 🎯 What Persists vs What Disappears

**Persists:**
- `~/ai-playground/repos/` (your source code)
- `~/ai-playground/WIP/` (airlock copies)
- `~/ai-playground/.container_config/` (settings)
- `~/ai-playground/.container_share/` (state)

**Disappears on stop:**
- Running processes
- Temp files

See `zen-docs/persistence.md` for complete details.

---

## 🤝 Contributing

This is for personal/small team use. Adjust as needed.

Push scaffold to GitHub:
```bash
cd ~/zenyatta
git init
git add .
git commit -m "Zenyatta scaffold"
git remote add origin git@github.com:censay/zenyatta.git
git push -u origin main
```

---

**Questions?** Check `zen-docs/` or open an issue.
