# Zenyatta - Zero-Trust AI Sandbox

Isolated container where AI works on copies of your code. You review every change in Meld before merging.

**Repository:** github.com/censay/zenyatta

---

## Why Zenyatta?

> *I think about the developer at 11pm, coffee cold, trying to fix a bug before tomorrow's demo. They've heard about AI coding assistants but don't trust them with their production codebase. They find Zenyatta.*
>
> *The first time they run `zen-meld`, they see the backup message, the cleanup warning, the meld window with clear LEFT/RIGHT labels. They merge two files, close meld, and commit. It took 30 seconds longer than running Claude directly, but they didn't accidentally commit an API key or lose their refactoring.*
>
> *That's who this is for. Not the developer who runs `claude` in their repo root and hopes for the best. The one who treats AI like a junior dev who needs supervision. The one who values "I reviewed every change" over "it was faster."*

---

## Quick Start

```bash
# 1. Install
 git clone https://github.com/censay/zenyatta.git ~/zenyatta
 cd ~/zenyatta && chmod +x setup.sh && ./setup.sh

# 2. Get your project
zen-clone my-project                             # Clone from your GitHub
# OR: cd ~/ai-playground/repos && git clone <url>

cd ~/ai-playground/repos/my-project
git checkout -b ai/feature-name                  # Always work on a branch

# 3. Work
zen-start                                        # Start container (once per session)
zen-push my-project                              # Push to airlock (strips .git)
zen-enter                                        # Enter container (or: playground)

# Inside container:
cd /WIP-ai/my-project && claude                  # Work with AI
exit                                             # Leave when done

# 4. Review
zen-meld my-project                              # Backup + Meld diff
# In Meld: Review changes, merge RIGHT → LEFT

# 5. Commit
cd ~/ai-playground/repos/my-project
git add . && git commit -m "AI: feature description"
```

---

## Commands

```
WORKFLOW
  zen-push [proj]     Push repos/ → WIP/airlock
  zen-meld [proj]     Backup + compare in Meld
  zen-restore [proj]  Restore WIP from backup
  zen-backup [proj]   Create explicit backup
  zen-nuke [proj]     Discard WIP and start fresh

CONTAINER
  zen-start           Start container
  zen-stop            Stop container
  zen-enter           Enter container (also: playground)
  zen-logs            View container logs

REPOS
  zen-clone <repo>    Clone from GitHub
  zen-status          Show status of everything

HELP
  zen-help            Show all commands
  zen-workflow        Show complete workflow example
```

All commands support `[project]` argument. If omitted, uses the last project you worked on.

---

## Security Model & Limitations

**What Zenyatta protects against:**
- Accidental commits from AI (no .git in container)
- Direct access to source repos (airlock pattern)
- SSH key exfiltration (keys stay on host)

**What it does NOT protect against:**
- AI reading API keys inside container (keys in .env are accessible)
- Container escape exploits (podman/Docker vulnerabilities)
- X11 clipboard exfiltration (malicious AI could read clipboard)
- Network-based exfiltration (AI can access internet)
- User error in Meld (merging wrong direction, missing malicious changes)

**This is "review gate" security, not "zero-trust" security.** You are trusting the AI not to be malicious, but enforcing human review before changes reach your repo.

For production secrets, consider:
- Running AI tools locally without API keys in container
- Using network-isolated containers
- Adding custom review hooks

---

## Security Model

**Airlock pattern:**
1. Source repos in `~/ai-playground/repos/` (with .git)
2. `zen-push` copies to `~/ai-playground/WIP/` (no .git, excludes node_modules/dist/build)
3. AI works on copies in container at `/WIP-ai/`
4. `zen-meld` opens Meld — you merge approved changes back
5. Only you commit with your git identity

**Container cannot:** commit, push, access source repos, access SSH keys or credentials.

**Backups:** Auto-created before each `zen-meld` as `repobak.tar.gz` in `~/ai-playground/backup/`

---

## Structure

```
~/zenyatta/              # Scaffold
├── lib/                 # Shared functions
│   ├── zen-core.sh
│   └── zen-backup.sh
├── zen-*                # Command scripts
├── setup.sh             # Installation
├── Dockerfile
├── compose.yaml
├── claude.md            # AI instructions
├── agents.md            # Project status
└── .env                 # API keys (.gitignored)

~/ai-playground/         # Workspace (created by setup)
├── repos/               # Your git repos (with .git)
├── WIP/                 # Airlock copies (no .git)
├── backup/              # repobak.tar.gz backups
├── .container_config/   # Settings persistence
├── .container_share/    # Session state
├── .container_claude/   # Claude Code auth
└── .zen-github-user     # For zen-clone
```

---

## AI Tools

- Claude Code (`claude`)
- opencode-ai (`opencode`)
- Other OpenAI-compatible tools

All follow the same airlock workflow.

---

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

---

## Enhancement Ideas

**Workflow Improvements:**
- `zen work <project>` - Single command combining start+push+enter
- Resume support: `zen resume` to jump back where you left off
- Pre-commit hooks integration for automated validation

**Security Enhancements:**
- Configurable file patterns (e.g., "AI cannot touch *.key files")
- Audit logging of all AI file changes
- Diff size limits to prevent massive unwanted changes
- Cryptographic signatures for verified AI sessions

**Developer Experience:**
- VSCode extension to reduce context switching
- Progress indicators for long operations
- GUI dashboard showing all projects and status
- Integration with CI/CD pipelines

---

## License

MIT License - see [LICENSE](LICENSE)
