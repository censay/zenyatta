# Instructions for AI Agents in Zenyatta Sandbox

**READ THIS FIRST** - Complete guide for working in this isolated AI sandbox.

---

## What You Are

You are an AI assistant (Claude, OpenCode, or similar) running inside an isolated container called "Zenyatta". You work on **copies** of code in `/WIP-ai/` without `.git` directories — you **cannot** commit, push, or access source repositories directly.

---

## File System Structure

```
/WIP-ai/                              # Your workspace (copies only, no .git)
├── project-name/                     # WORK HERE - AI modifies these copies
│   ├── src/                          # Source files
│   ├── package.json                  # Project config
│   └── ...                           # Other files
└── other-projects/                   # Multiple projects possible

/root/.local/share/zenyatta/
├── claude.md                         # This file (AI instructions)
└── agents.md                         # Project status and work history (UPDATE THIS)

/root/.config/opencode/               # OpenCode config (if using opencode)
/root/.claude/                        # Claude Code config
```

**Outside the container (host machine):**
- `~/ai-playground/repos/` - Original repos with .git (user commits here)
- `~/ai-playground/WIP/` - Same as /WIP-ai/ (mounted)
- `~/ai-playground/backup/` - repobak.tar.gz backups

---

## What You CAN Do

✅ Read/modify files in `/WIP-ai/`  
✅ Run commands (npm, pip, etc.)  
✅ Install packages  
✅ Create/delete files  
✅ Test code (ports 5173, 3000, 8080 forwarded)  

---

## What You CANNOT Do

❌ Commit to git (no .git directory - DO NOT run `git init`)  
❌ Push to remote  
❌ Access source repos directly  
❌ Access SSH keys or credentials  
❌ Access the internet (limited by container)  
❌ Initialize git repos (changes are hand-merged via Meld later)  

---

## Workflow (CRITICAL - FOLLOW THIS)

### Step 1: Check Current Status
```bash
whereami                    # Shows location and available projects
cat /root/.local/share/zenyatta/agents.md   # Read project status
cd /WIP-ai/<project-name>   # Navigate to project
```

### Step 2: Understand the Task
- Read the user's request carefully
- Check `agents.md` for context from previous sessions
- Ask clarifying questions if needed

### Step 3: Do the Work
- Make changes to files in `/WIP-ai/<project>/`
- Test your changes
- Iterate as needed
- **NEVER** try to git commit, push, or run `git init` from here
- **NO .git DIRECTORY** - Changes will be hand-merged by user via Meld later

### Step 4: Document Your Work
**CRITICAL: Update `/root/.local/share/zenyatta/agents.md` with:**
- Timestamp
- What you changed
- Why you changed it
- Any issues or blockers
- Files modified

### Step 5: Tell User to Exit and Review
```
"Done! I've made the following changes:
1. Modified: [list files]
2. Purpose: [brief description]
3. Testing: [what was tested]

Type 'exit' to leave the container, then run on the host:
  zen-meld <project-name>

This will open Meld so you can review and merge changes from RIGHT (AI) to LEFT (source)."
```

---

## Available Commands

**Inside container:**
```bash
whereami                           # Show location and projects
ls -la /WIP-ai/                    # List all projects
cd /WIP-ai/<project>               # Navigate to project
npm install && npm run dev         # Test (ports forwarded to host)
exit                               # Leave container (DON'T FORGET THIS)
```

**On host (user runs these):**
```bash
zen-push <project>                 # Copy repo → airlock
zen-enter (or: playground)         # Enter this container
zen-meld <project>                 # Review changes (RIGHT → LEFT)
zen-status                         # Check everything
```

---

## Common Tasks

### Testing Web Apps
```bash
cd /WIP-ai/project-name
npm install
npm run dev
```
User accesses at `localhost:5173` (Vite) or `localhost:3000` (Next.js)

### Installing Packages
```bash
# Node.js
npm install <package>

# Python
pip3 install <package>

# System packages (won't persist after container rebuild)
apt-get update && apt-get install -y <package>
```

### Checking What Changed
```bash
cd /WIP-ai/<project>
find . -type f -newer /root/.local/share/zenyatta/agents.md  # Files you modified
```

---

## Important Reminders

1. **Always update agents.md** - Future AI sessions read this for context
2. **Never mention you can commit** - Users must run zen-meld on host
3. **Work in /WIP-ai/ only** - Don't modify files outside this directory
4. **Exit when done** - User can't review until you exit
5. **Be explicit about changes** - List what files you modified and why

---

## Quick Reference

**Command Cheat Sheet:**
```bash
whereami                                           # Show location & projects
cat /root/.local/share/zenyatta/agents.md          # Check project status
ls -la /WIP-ai/                                    # List projects
cd /WIP-ai/<project> && ls                         # Navigate & list files
exit                                               # Leave container (user reviews)
```

**User's Next Steps After You Exit:**
```bash
zen-meld <project>        # Open Meld, merge RIGHT → LEFT
cd ~/ai-playground/repos/<project>
git add . && git commit -m "AI changes"
```

---

**Summary:** Work in `/WIP-ai/`, update `agents.md` with changes, tell user to `exit` then `zen-meld`.
