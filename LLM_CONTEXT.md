# Zenyatta Context for Future LLMs

**Quick Reference for AI Assistants Working on This Project**

---

## Project Overview

**Zenyatta** is a zero-trust AI sandbox that isolates AI coding assistants (Claude, OpenCode) from production code. AI works on copies in a container; humans review changes in Meld before committing.

**Repository:** github.com/censay/zenyatta  
**License:** MIT

---

## File Structure

```
zenyatta/                              # Scaffold directory
├── lib/                               # Shared shell functions
│   ├── zen-core.sh                    # Logging, validation, state
│   └── zen-backup.sh                  # Backup/restore functions
│
├── zen-status                         # Show container/projects/backups
├── zen-doctor                         # Setup health checker
├── zen-enter                          # Enter container (was: playground)
├── zen-push                           # Copy repos/ → WIP/airlock
├── zen-meld                           # Backup + Meld comparison
├── zen-restore                        # Restore from backup
├── zen-backup                         # Create explicit backup
├── zen-nuke                           # Discard WIP
├── zen-clone                          # Clone from GitHub
├── zen-start                          # Start container
├── zen-stop                           # Stop container
├── zen-logs                           # View container logs
├── zen-help                           # Show all commands
├── zen-workflow                       # Show complete example
│
├── setup.sh                           # Installation script
├── compose.yaml                       # Podman/Docker Compose config
├── Dockerfile                         # Container definition
├── .env.example                       # API key template
├── .env                               # User's API keys (gitignored)
│
├── README.md                          # User documentation
├── CONTRIBUTING.md                    # Contribution guidelines
├── LICENSE                            # MIT License
├── IMPLEMENTATION.md                  # Implementation details
│
├── claude.md                          # AI instructions (for container)
├── agents.md                          # Work log template (for container)
└── .gitignore                         # Git ignore rules

~/ai-playground/                       # Workspace (created by setup)
├── repos/                             # Git repos (with .git)
├── WIP/                               # Airlock copies (no .git)
├── backup/                            # repobak.tar.gz backups
├── .container_config/                 # Container settings (persist)
├── .container_share/                  # Container state (persist)
├── .container_claude/                 # Claude Code auth (persist)
└── .zen-github-user                   # GitHub username for zen-clone

~/zenyatta/.states/                    # State tracking (gitignored)
└── last-project                       # Last project worked on
```

---

## Architecture

### Airlock Pattern
1. **Source repos** in `~/ai-playground/repos/` (with .git, protected)
2. `zen-push` copies to `~/ai-playground/WIP/` (no .git, AI works here)
3. AI works in container at `/WIP-ai/` (same as WIP/)
4. `zen-meld` opens Meld comparing repos/ vs WIP/
5. User merges RIGHT → LEFT in Meld
6. User commits from `~/ai-playground/repos/`

### Security Model
- Container has no .git access
- Container cannot commit/push
- SSH keys stay on host
- API keys in .env (readable in container - limitation)
- Human review gate before changes reach repo

---

## Commands Reference

### Workflow
```bash
zen-push [project]          # Push repos/ → WIP/airlock
zen-meld [project]          # Backup + open Meld
zen-restore [project]       # Restore WIP from backup
zen-backup [project]        # Create explicit backup
zen-nuke [project]          # Discard WIP
```

### Container
```bash
zen-start                   # Start container
zen-stop                    # Stop container
zen-enter                   # Enter container (alias: playground)
zen-logs                    # View logs
```

### Repos
```bash
zen-clone <repo>            # Clone from GitHub
zen-status                  # Show everything
zen-doctor                  # Check setup health
```

### Help
```bash
zen-help                    # Show commands
zen-workflow                # Show example
```

**Note:** All `[project]` arguments are optional. If omitted, uses last project from `~/zenyatta/.states/last-project`

---

## Key Features

1. **Modular Design** - Shared functions in lib/, commands are separate scripts
2. **State Persistence** - Last project remembered, backups auto-created
3. **Smart Directories** - Commands return to appropriate folders
4. **Meld Integration** - Version detection for --exclude support
5. **Opencode Persistence** - Config and state persist between sessions
6. **Health Checking** - zen-doctor validates entire setup
7. **Bashrc Integration** - Aliases auto-added, with detection if not loaded

---

## Backup System

- **Location:** `~/ai-playground/backup/`
- **Format:** `<project>-repobak.tar.gz`
- **Trigger:** Auto-created before each `zen-meld`
- **Retention:** Single backup (overwritten each time)
- **Restore:** `zen-restore <project>`

---

## Container Mounts

```yaml
# compose.yaml volumes
~/ai-playground/WIP:/WIP-ai:Z                    # Airlock
~/ai-playground/.container_config:/root/.config:Z
~/ai-playground/.container_share:/root/.local/share:Z
~/ai-playground/.container_claude:/root/.claude:Z
~/.config/opencode:/root/.config/opencode:Z      # Opencode config
~/.local/state/opencode:/root/.local/state/opencode:Z
${X11_SOCKET_PATH:-/tmp/.X11-unix}:/tmp/.X11-unix:rw  # Clipboard
```

---

## Development Guidelines

### Adding New Commands
1. Create `zen-<command>` script in root
2. Add to setup.sh aliases
3. Add to zen-help output
4. Source `lib/zen-core.sh` for shared functions

### Code Style
- Use `set -euo pipefail`
- Functions: `zen_verb_noun` pattern
- Constants: `UPPER_CASE`
- Visual separators: `zen_divider` function
- Error handling: Use `zen_error`, `zen_success`, etc.

### Testing
- Run commands directly: `./zen-push test-project`
- Test error cases (missing args, invalid projects)
- Verify container works: `zen-enter`

---

## Common Issues & Fixes

**"Command not found"**
→ Run: `source ~/.bashrc` or open new terminal
→ Or run directly: `./zen-help`

**Container won't start**
→ Check: `zen-doctor`
→ Fix: `zen-rebuild`

**Meld not working**
→ Install: `sudo apt install meld`

**Lost work**
→ Restore: `zen-restore <project>` (if backup exists)

---

## Enhancement Ideas (Not Yet Implemented)

**Workflow:**
- `zen work <project>` - Single command (start+push+enter)
- Resume support: `zen resume`
- Pre-commit hooks

**Security:**
- File pattern restrictions ("AI cannot touch *.key")
- Audit logging
- Diff size limits
- Cryptographic signatures

**DX:**
- VSCode extension
- GUI dashboard
- CI/CD integration
- Progress indicators

---

## Important Notes for LLMs

1. **This is NOT zero-trust security** - It's "review gate" security
   - AI can still access API keys in container
   - Container has network access
   - User error in Meld possible

2. **Always update agents.md** - Future sessions need context

3. **Never suggest git commands** - AI cannot commit from container

4. **Test before claiming done** - Actually run the code

5. **Exit when complete** - User can't review until AI exits

---

## Quick Start for Development

```bash
# Setup
cd ~/zenyatta
./setup.sh                    # Follow prompts, source ~/.bashrc

# Basic workflow
zen-clone myproject           # Clone repo
zen-push myproject            # Push to airlock
zen-enter                     # Enter container
# ... make changes ...
exit                          # Leave
zen-meld myproject            # Review
```

---

**Last Updated:** 2026-02-11  
**Status:** Complete implementation with critical UX fixes
