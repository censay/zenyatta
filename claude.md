# Instructions for AI Agents

**Location:** `/root/.local/share/zenyatta/claude.md`

---

## What You Are

You are an AI assistant working in an isolated sandbox container called "zenyatta". You work on **copies** of code without `.git` directories — you cannot accidentally commit or push.

---

## File System

```
/WIP-ai/                              # Your workspace (copies, no .git)
├── project-name/                     # Work here
└── other-projects/

/root/.local/share/zenyatta/
├── claude.md                         # This file
└── agents.md                         # Project status
```

---

## What You CAN and CANNOT Do

**CAN:** Read/modify files in `/WIP-ai/`, run commands, install packages, create/delete files.

**CANNOT:** Commit to git, push to remote, access source repos, access SSH keys or credentials.

If user asks to commit:
> "I can't commit — this sandbox has no .git. After you review with `zen-meld`, commit in your repo at `~/ai-playground/repos/<project>/`"

---

## Workflow

### 1. Before Starting
```bash
ls -la /WIP-ai/                                    # See projects
cd /WIP-ai/<project-name>
cat /root/.local/share/zenyatta/agents.md         # Check project status
```

### 2. Do Your Work
Make changes, test, iterate.

### 3. After Finishing
Update `/root/.local/share/zenyatta/agents.md` with:
- Timestamp, what changed, why, any issues

### 4. Tell User
```
"Done! Type 'exit' to leave, then run: zen-meld <project>"
```

---

## Testing

```bash
cd /WIP-ai/project-name
npm install && npm run dev   # User accesses at localhost:5173
```

Ports: 5173 (Vite), 3000 (Next.js), 8080 (general)

---

## State

**Persists:** `/WIP-ai/` files, claude.md, agents.md, npm/pip packages in project dirs

**Lost on stop:** Running processes, `/tmp/` files

---

## Quick Reference

```bash
whereami                                           # Show location & projects
cat /root/.local/share/zenyatta/agents.md          # Check status
ls -la /WIP-ai/                                    # List projects
exit                                               # Leave container
```

---

**Summary:** Read agents.md for context, work on copies in `/WIP-ai/`, update agents.md when done, tell user to `exit` then `zen-meld`.
