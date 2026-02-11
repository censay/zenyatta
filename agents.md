# Agent Work Log & Project Status

**Location:** `/root/.local/share/zenyatta/agents.md`  
**Purpose:** Track AI work sessions, changes, and project status  
**Last Updated:** Initial setup (update after each session)

---

## ⚠️ CRITICAL REMINDER

**NO GIT OPERATIONS IN THIS CONTAINER**

- This workspace has **NO .git directory** (intentionally stripped)
- Do **NOT** run `git init`, `git commit`, `git push`, or any git commands
- Do **NOT** try to recreate the git repo
- Changes are **hand-merged by the user** via Meld after you exit
- User commits from `~/ai-playground/repos/<project>/` on the host

---

## Current Session Info

**Container Started:** [Will be populated by system]  
**Active Project:** [Update when you start working]  
**Current Task:** [Update with brief description]  
**Status:** [Not started / In progress / Blocked / Complete]

---

## Project Structure

### Available Projects in /WIP-ai/

List active projects here. Check with: `ls -la /WIP-ai/`

| Project | Source Location | Tech Stack | Last Modified | Status |
|---------|----------------|------------|---------------|--------|
| [example-project] | ~/ai-playground/repos/example-project/ | React/Vite | [date] | [status] |
| [add more...] | | | | |

---

## Work History

**Template for logging work:**

```
### YYYY-MM-DD HH:MM - Project Name
- **AI:** [Claude/OpenCode/Other]
- **Task:** [What was requested by user]
- **Files Modified:**
  - path/to/file1 - [what changed and why]
  - path/to/file2 - [what changed and why]
- **Testing:** [What was tested, results]
- **Issues:** [Any blockers or problems]
- **Next Steps:** [What remains to be done]
- **Status:** [Complete / In Progress / Blocked]
```

---

## Recent Work Sessions

### [Date] - [Project Name]
- **AI:** [Name]
- **Task:** [Description]
- **Files Modified:**
  - [ ] None yet
- **Status:** [Status]

[Add new entries above this line, newest first]

---

## Current Blockers

**List any issues preventing progress:**

- [ ] None currently

---

## Project-Specific Notes

### [Project Name]
**Location:** `/WIP-ai/[project-name]/`  
**Source:** `~/ai-playground/repos/[project-name]/`

**Context:**
- Tech stack: [e.g., React, Node.js, Python]
- Main files: [e.g., src/App.jsx, server.py]
- Special considerations: [e.g., Uses specific API, has tests]

**Recent Changes:**
- [Date]: [What was done]

**Known Issues:**
- [Any known problems or technical debt]

---

## Quick Links & References

**Inside Container:**
- Work directory: `/WIP-ai/`
- This file: `/root/.local/share/zenyatta/agents.md`
- AI Instructions: `/root/.local/share/zenyatta/claude.md`
- Home: `/root/`

**On Host (for reference):**
- Repos: `~/ai-playground/repos/`
- Airlock: `~/ai-playground/WIP/` (same as /WIP-ai/)
- Backups: `~/ai-playground/backup/`
- Commands: `zen-push`, `zen-meld`, `zen-status`, `zen-help`

---

## How to Update This File

**After each work session, add entry above in "Recent Work Sessions":**

1. Copy template from "Work History" section
2. Fill in actual details
3. Move to "Recent Work Sessions" section (newest first)
4. Update "Current Session Info" at top

**Keep it concise but informative** - Future AI sessions read this first.

---

## Status Legend

- 🟢 **Complete** - Task finished, user approved, committed
- 🟡 **In Progress** - Currently working, may have partial changes
- 🔴 **Blocked** - Cannot proceed without user input or fix
- ⚪ **Not Started** - No work done yet

---

**IMPORTANT:** Always check this file when starting a new session. Read the most recent entries to understand context before making changes.
