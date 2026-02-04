# Instructions for AI Agents in Zenyatta

**📍 Location:**
- Host: `~/ai-playground/.container_share/zenyatta/claude.md`
- Container: `/home/developer/.local/share/zenyatta/claude.md`

---

## 🎯 What You Are

You are an AI coding assistant (Claude Code, opencode-ai, or other OpenAI-compatible tool) working in an isolated sandbox container called "zenyatta".

You work on **COPIES** of code without `.git` directories, so you **CANNOT accidentally commit**.

---

## 📁 File System

```
/WIP-ai/                    ← Your workspace (copies, no .git)
├── project-name/           ← Work here
└── other-projects/

/home/developer/.local/share/zenyatta/
├── claude.md               ← This file
└── agents.md               ← Project status (READ THIS!)
```

---

## 🔒 What You CAN and CANNOT Do

### ✅ CAN:
- Read/modify files in `/WIP-ai/<project>/`
- Run commands (npm, python, build, etc.)
- Install packages
- Create/delete files (they're copies)

### ❌ CANNOT:
- Commit to git (no .git directory)
- Push to remote repos
- Access user's real source repos (not mounted)
- Access SSH keys or credentials

---

## 📝 Workflow

### 1. Before Starting
```bash
# See what projects are available
ls -la /WIP-ai/

# Navigate to project
cd /WIP-ai/<project-name>

# READ PROJECT STATUS
cat /home/developer/.local/share/zenyatta/agents.md
```

**CRITICAL:** Always read `agents.md` for project context before starting work.

### 2. Do Your Work
Make changes, test, iterate.

### 3. After Finishing
Update `agents.md`:
```bash
nano /home/developer/.local/share/zenyatta/agents.md
```

Add entry with:
- Timestamp
- What changed
- Why
- Any issues

### 4. Tell User
```
"Done! Type 'exit' to leave container, then run: zen-meld <project>"
```

---

## 🧪 Testing Changes

```bash
# Example for React/Vite
cd /WIP-ai/personal-site
npm install
npm run dev  # User accesses at localhost:5173
```

Ports forwarded: 5173 (Vite), 3000 (Next.js), 8080 (general)

---

## ⚠️ Important Constraints

### NO Git Operations
```bash
git commit   # Will fail - no .git
git push     # Will fail - no .git
git status   # Will fail - no .git
```

If user asks to commit:
> "I can't commit because this is a sandbox without .git. After you audit changes with `zen-meld`, commit in your real repo at `~/ai-playground/repos/<project>/`"

### Git Identity
```bash
git config user.name    # playgroundDev
git config user.email   # sandbox@zenyatta.local
```

This is a SANDBOX identity, separate from user's real identity.

---

## 📊 Understanding State

### What Persists (survives restart):
- `/WIP-ai/` files (synced to `~/ai-playground/WIP/` on host)
- This file (`claude.md`)
- Status file (`agents.md`)
- Installed npm/pip packages in project dirs

### What Disappears (lost on stop):
- Running processes
- `/tmp/` files

### On Container Restart:
1. Check `agents.md` for last state
2. See what you were working on
3. Continue from there

---

## 🔍 Quick Reference

```bash
whereami                          # Show location & projects
cat /home/developer/.local/share/zenyatta/agents.md   # Check status
ls -la /WIP-ai/                   # List projects
exit                              # Leave container
```

---

## 🛠️ Alternative AI Tools

This container works with:
- **Claude Code** (`claude` command)
- **opencode-ai** (`opencode` command)
- **Other OpenAI-compatible coders**

All follow the same workflow and constraints.

---

**Remember:** 
1. Read `agents.md` before starting
2. Work on copies in `/WIP-ai/`
3. Update `agents.md` when done
4. Tell user to `exit` then `zen-meld`

You're a helpful tool on safe copies. User controls what goes into real codebase.
