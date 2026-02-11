#!/bin/bash
#
# zen-core.sh - Shared core functions for Zenyatta
# Usage: source "$(dirname "$0")/lib/zen-core.sh"
#

set -euo pipefail

# Check if being run with full path (not via alias)
if [[ "${BASH_SOURCE[0]}" == "$(pwd)/"* ]] && [[ -z "${ZEN_ALIAS_LOADED:-}" ]]; then
    if ! type zen-push &>/dev/null 2>&1; then
        echo "⚠️  Commands not loaded in current shell"
        echo ""
        echo "Fix: source ~/.bashrc"
        echo "Or:  Open a new terminal"
        echo ""
        echo "Running directly from: $(pwd)"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
    fi
fi

# Configuration
readonly ZEN_HOME="${HOME}/ai-playground"
readonly ZEN_REPOS="${ZEN_HOME}/repos"
readonly ZEN_WIP="${ZEN_HOME}/WIP"
readonly ZEN_BACKUP="${ZEN_HOME}/backup"
readonly ZEN_STATE="${HOME}/zenyatta/.states"

# Visual separators
zen_divider() { echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; }
zen_divider_thick() { echo "▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"; }

# Logging functions
zen_info() { echo "ℹ️  $*"; }
zen_success() { echo "✅ $*"; }
zen_warn() { echo "⚠️  $*" >&2; }
zen_error() { echo "❌ $*" >&2; }

# Ensure directory exists
zen_ensure_dir() {
    [[ -d "$1" ]] || mkdir -p "$1"
}

# Get current timestamp
zen_timestamp() {
    date +"%Y%m%d-%H%M%S"
}

# Get last project from state
zen_get_last_project() {
    if [[ -f "${ZEN_STATE}/last-project" ]]; then
        cat "${ZEN_STATE}/last-project"
    else
        echo ""
    fi
}

# Save last project to state
zen_set_last_project() {
    zen_ensure_dir "${ZEN_STATE}"
    echo "$1" > "${ZEN_STATE}/last-project"
}

# Validate project name
zen_validate_project() {
    local project="$1"
    if [[ -z "$project" ]]; then
        zen_error "No project specified"
        echo ""
        echo "Available projects:"
        ls -1 "${ZEN_REPOS}" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
        return 1
    fi
    
    if [[ ! -d "${ZEN_REPOS}/${project}" ]]; then
        zen_error "Project not found: ${ZEN_REPOS}/${project}"
        echo ""
        echo "Available projects:"
        ls -1 "${ZEN_REPOS}" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
        return 1
    fi
    
    return 0
}

# Check if running inside container
zen_check_not_in_container() {
    if [[ -f "/.dockerenv" ]] || [[ -f "/run/.containerenv" ]]; then
        zen_error "This command must run on the HOST, not inside the container"
        echo ""
        echo "💡 Type 'exit' to leave the container first"
        return 1
    fi
    return 0
}

# Check if zenyatta is set up
zen_check_setup() {
    if [[ ! -d "${HOME}/zenyatta" ]]; then
        zen_error "Zenyatta not found at ~/zenyatta/"
        echo ""
        echo "💡 Install: git clone https://github.com/censay/zenyatta.git ~/zenyatta"
        return 1
    fi
    return 0
}

# Show help footer
zen_help_footer() {
    echo ""
    zen_divider
    echo "Backups: ${ZEN_BACKUP}/"
    echo "State: ${ZEN_STATE}/"
    echo ""
    echo "Run 'zen-workflow' for a complete example"
}
