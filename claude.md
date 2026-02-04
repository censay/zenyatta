# Instructions for AI Agents in Zenyatta

**Location:**
- Host: `~/ai-playground/.container_share/zenyatta/claude.md`
- Container: `/home/developer/.local/share/zenyatta/claude.md`

---

## Startup Rule

**On session start, ONLY read these two files:**
1. This file (`claude.md`)
2. `agents.md` (same directory)

Do NOT explore the codebase, read other docs, or run broad searches until the user describes their task. This saves tokens and keeps context focused.

---

## What You Are

You are an AI coding assistant working in an isolated sandbox container called "zenyatta".
You work on **COPIES** of code without `.git` directories -- you **CANNOT accidentally commit**.

---

## File System

```
/WIP-ai/                    <- Your workspace (copies, no .git)
├── project-name/           <- Work here
└── other-projects/

/home/developer/.local/share/zenyatta/
├── claude.md               <- This file
└── agents.md               <- Project status (READ THIS)
```

---

## CAN / CANNOT

**CAN:** Read/modify files in `/WIP-ai/`, run commands, install packages, create/delete files.
**CANNOT:** Commit to git (no .git), push to remotes, access source repos or SSH keys.

If user asks to commit:
> "I can't commit -- this is a sandbox without .git. After you audit with `zen-meld`, commit in your real repo at `~/ai-playground/repos/<project>/`"

---

## Workflow

1. Read `agents.md` for project context
2. Work in `/WIP-ai/<project>/`
3. Update `agents.md` when done (timestamp, changes, status)
4. Tell user: "Done! Type 'exit' then run: zen-meld <project>"

---

## Dev Servers

The container has `HOST=0.0.0.0` set. Vite picks this up automatically.
If a dev server isn't visible from the host, add the flag explicitly:

```bash
npm run dev -- --host 0.0.0.0
```

Ports forwarded: 5173 (Vite), 3000 (Next.js), 8080 (general).

---

## What Persists

AI tools (Claude Code, opencode) use temp directories for session/conversation state.
That context is lost when the container stops. **This is why you update agents.md** —
it's on a mounted volume and survives everything.

**Container left running (normal during a work session):**
Everything stays — processes, AI context, temp files, installed packages. No reason to stop
the container between tasks. Just `exit` and re-enter with `playground`.

**zen-down → zen-up:**
Survives: /WIP-ai/ files, claude.md, agents.md, .container_config, .container_share
Lost: running processes, /tmp/, AI tool session state, npm/pip packages installed at runtime
On restart: read agents.md for where you left off.

**zen-rebuild:**
Same as zen-down/up. Also rebuilds the image, so apt-get packages not in Dockerfile are gone.
Volume-mounted files still safe.

---

## Quick Reference

```bash
whereami                          # Show location & projects
cat /home/developer/.local/share/zenyatta/agents.md   # Check status
ls -la /WIP-ai/                   # List projects
exit                              # Leave container
```

---

## Supported AI Tools

- Claude Code (`claude`)
- opencode-ai (`opencode`)
- Other OpenAI-compatible tools

All follow the same workflow and constraints.

---

**Remember:**
1. Read `agents.md` before starting
2. Work on copies in `/WIP-ai/`
3. Update `agents.md` when done
4. Tell user to `exit` then `zen-meld`
