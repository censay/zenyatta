#!/bin/bash
# Zenyatta Sync - Copy project to airlock
# Can run from anywhere (alias handles directory)
set -e

# Check project name
if [ -z "$1" ]; then
    echo "Usage: zen-push <project-name>"
    echo ""
    echo "Available projects:"
    ls -1 ~/ai-playground/repos/ 2>/dev/null || echo "  (none - add to ~/ai-playground/repos/ first)"
    exit 1
fi

PROJECT="$1"
SOURCE="$HOME/ai-playground/repos/$PROJECT"
AIRLOCK="$HOME/ai-playground/WIP/$PROJECT"

# Validate source exists
if [ ! -d "$SOURCE" ]; then
    echo "❌ Project not found: $SOURCE"
    echo ""
    echo "Available:"
    ls -1 ~/ai-playground/repos/ 2>/dev/null || echo "  (none)"
    exit 1
fi

# SAFETY CHECK: Verify .git directory exists
if [ ! -d "$SOURCE/.git" ]; then
    echo "⚠️  WARNING: $SOURCE is NOT a git repository"
    echo "   No .git directory found"
    echo ""
    echo "This is unusual. Projects should typically be git repos."
    read -p "Continue syncing anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Sync cancelled"
        echo ""
        echo "💡 To make it a git repo:"
        echo "   cd $SOURCE"
        echo "   git init"
        echo "   git add ."
        echo "   git commit -m 'Initial commit'"
        exit 1
    fi
fi

echo "🔒 Syncing to airlock"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Source:  $SOURCE"
echo "Airlock: $AIRLOCK"
echo ""

# Warn about uncommitted changes
if [ -d "$SOURCE/.git" ]; then
    cd "$SOURCE"
    if ! git diff-index --quiet HEAD -- 2>/dev/null; then
        echo "⚠️  Uncommitted changes in source:"
        git status --short
        echo ""
        read -p "Continue? (y/N): " -n 1 -r
        echo
        [[ ! $REPLY =~ ^[Yy]$ ]] && exit 1
    fi
fi

# Sync (excludes .git)
echo "📦 Syncing (excluding .git)..."
rsync -av --delete \
    --exclude=".git" \
    --exclude=".gitignore" \
    --exclude="node_modules" \
    --exclude="dist" \
    --exclude="build" \
    "$SOURCE/" "$AIRLOCK/"

echo ""
echo "✅ Synced to airlock"
echo ""
echo "Next: playground → cd /WIP-ai/$PROJECT"
