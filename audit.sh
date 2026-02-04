#!/bin/bash
# Zenyatta Audit - Visual diff with Meld
# Can run from anywhere (alias handles directory)
set -e

# Check Meld
if ! command -v meld &> /dev/null; then
    echo "❌ Meld not installed"
    echo "   Install: sudo apt install meld"
    exit 1
fi

# Check project
if [ -z "$1" ]; then
    echo "Usage: zen-meld <project-name>"
    echo ""
    echo "Available:"
    ls -1 ~/ai-playground/repos/ 2>/dev/null || echo "  (none)"
    exit 1
fi

PROJECT="$1"
SOURCE="$HOME/ai-playground/repos/$PROJECT"
AIRLOCK="$HOME/ai-playground/WIP/$PROJECT"

# Validate
[ ! -d "$SOURCE" ] && echo "❌ Source not found: $SOURCE" && exit 1
[ ! -d "$AIRLOCK" ] && echo "❌ Airlock not found (run zen-push first)" && exit 1

echo "🔬 Visual Audit with Meld"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "LEFT  (source): $SOURCE"
echo "RIGHT (AI):     $AIRLOCK"
echo ""
echo "Merge approved changes: RIGHT → LEFT"
echo ""

# Launch Meld
meld "$SOURCE" "$AIRLOCK"

echo ""
echo "✅ Audit complete"
echo ""
echo "If you approved changes:"
echo "  cd ~/ai-playground/repos/$PROJECT"
echo "  git add . && git commit -m 'AI changes'"
echo ""

read -p "Stop container? (y/N): " -n 1 -r
echo
[[ $REPLY =~ ^[Yy]$ ]] && zen-down
