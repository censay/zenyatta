#!/bin/bash
#
# zen-backup.sh - Backup and restore functions for Zenyatta
# Usage: source "$(dirname "$0")/lib/zen-core.sh" first
#

# Create backup of project
# Returns: backup file path on success, empty on failure
zen_backup_create() {
    local project="$1"
    local source_dir="${ZEN_REPOS}/${project}"
    local backup_file="${ZEN_BACKUP}/${project}-repobak.tar.gz"
    
    # Ensure backup directory exists
    zen_ensure_dir "${ZEN_BACKUP}"
    
    # Create backup
    if tar -czf "${backup_file}" \
        --exclude=".git" \
        --exclude="node_modules" \
        --exclude="dist" \
        --exclude="build" \
        -C "$(dirname "${source_dir}")" "$(basename "${source_dir}")" 2>/dev/null; then
        echo "${backup_file}"
        return 0
    else
        return 1
    fi
}

# Restore project from backup
zen_backup_restore() {
    local project="$1"
    local backup_file="${ZEN_BACKUP}/${project}-repobak.tar.gz"
    local wip_dir="${ZEN_WIP}/${project}"
    
    if [[ ! -f "${backup_file}" ]]; then
        zen_error "Backup not found: ${backup_file}"
        return 1
    fi
    
    # Remove current WIP if exists
    if [[ -d "${wip_dir}" ]]; then
        rm -rf "${wip_dir}"
    fi
    
    # Extract backup to WIP
    zen_ensure_dir "${ZEN_WIP}"
    if tar -xzf "${backup_file}" -C "${ZEN_WIP}"; then
        # The tar extracts to project/ directory, move contents up
        if [[ -d "${ZEN_WIP}/${project}/${project}" ]]; then
            mv "${ZEN_WIP}/${project}/${project}" "${ZEN_WIP}/${project}.tmp"
            rm -rf "${ZEN_WIP}/${project}"
            mv "${ZEN_WIP}/${project}.tmp" "${wip_dir}"
        fi
        zen_success "Restored from backup: ${backup_file}"
        return 0
    else
        zen_error "Failed to restore from backup"
        return 1
    fi
}

# Check if meld supports --exclude
zen_meld_has_exclude() {
    meld --help 2>&1 | grep -q -- '--exclude'
}
