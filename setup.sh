#!/bin/bash
# Zenyatta Setup - Run once from ~/zenyatta/
set -e

echo "🧘 Zenyatta Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check we're in right directory
REQUIRED_DIR="$HOME/zenyatta"
if [ "$(pwd)" != "$REQUIRED_DIR" ]; then
    echo "⚠️  Not in ~/zenyatta/"
    echo "Current: $(pwd)"
    echo "Expected: $REQUIRED_DIR"
    echo ""
    read -p "Create ~/zenyatta/ and move files there? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mkdir -p "$REQUIRED_DIR"
        echo "📁 Created $REQUIRED_DIR"
        echo ""
        echo "Move all zenyatta files there and run:"
        echo "  cd ~/zenyatta && ./setup.sh"
        exit 1
    else
        exit 1
    fi
fi

# Create workspace directory structure (separate from scaffold)
echo "📁 Creating workspace at ~/ai-playground/..."
mkdir -p ~/ai-playground/{.container_config,.container_share/zenyatta,.container_claude,repos,WIP}

echo "✅ Directories created:"
echo "   ~/zenyatta/                       - Scaffold (you are here)"
echo "   ~/ai-playground/repos/            - Your git repos"
echo "   ~/ai-playground/WIP/              - Airlock staging"
echo "   ~/ai-playground/.container_config/   - Settings"
echo "   ~/ai-playground/.container_share/    - State"
echo ""

# Check Podman
if ! command -v podman &> /dev/null; then
    echo "⚠️  Podman not found"
    read -p "Install? (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && sudo apt-get update && sudo apt-get install -y podman podman-compose || exit 1
fi

# Check Meld
if ! command -v meld &> /dev/null; then
    echo "⚠️  Meld not found (needed for visual diff)"
    read -p "Install? (y/N): " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && sudo apt-get install -y meld
fi

# Initialize state files
[ ! -f ~/ai-playground/.container_share/zenyatta/claude.md ] && cp claude.md ~/ai-playground/.container_share/zenyatta/
[ ! -f ~/ai-playground/.container_share/zenyatta/agents.md ] && cp agents.md ~/ai-playground/.container_share/zenyatta/

# Create local state directory
mkdir -p ~/zenyatta/.states

# Create .env in scaffold dir (gitignored, read by compose.yaml)
if [ ! -f ~/zenyatta/.env ]; then
    echo ""
    read -p "Do you need Ollama or API keys? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp .env.example ~/zenyatta/.env
        echo "✅ Created .env at ~/zenyatta/.env"
        echo "   Edit it with: nano ~/zenyatta/.env"
    else
        touch ~/zenyatta/.env
        echo "✅ Created empty .env (not needed for basic use)"
    fi
fi

# Add aliases to .bashrc
echo ""
echo "🔧 Adding aliases to ~/.bashrc..."

# Remove existing Zenyatta block if present
sed -i '/^# >>> ZENYATTA START >>>/,/^# <<< ZENYATTA END <<</d' ~/.bashrc

# Append fresh block with markers
cat >> ~/.bashrc << 'ALIASES'

# >>> ZENYATTA START >>>
# Zenyatta aliases - managed by setup.sh (do not edit manually)
alias zen-start='cd ~/zenyatta && ./zen-start'
alias zen-stop='cd ~/zenyatta && ./zen-stop'
alias zen-rebuild='cd ~/zenyatta && podman-compose down && podman-compose up -d --build && cd - > /dev/null'

alias playground='cd ~/zenyatta && ./zen-enter'
alias zen-enter='cd ~/zenyatta && ./zen-enter'
alias zen-logs='cd ~/zenyatta && ./zen-logs'

alias zen-push='cd ~/zenyatta && ./zen-push'
alias zen-meld='cd ~/zenyatta && ./zen-meld'
alias zen-restore='cd ~/zenyatta && ./zen-restore'
alias zen-backup='cd ~/zenyatta && ./zen-backup'
alias zen-nuke='cd ~/zenyatta && ./zen-nuke'
alias zen-clone='cd ~/zenyatta && ./zen-clone'
alias zen-status='cd ~/zenyatta && ./zen-status'
alias zen-doctor='cd ~/zenyatta && ./zen-doctor'
alias zen-help='cd ~/zenyatta && ./zen-help'
alias zen-workflow='cd ~/zenyatta && ./zen-workflow'
# <<< ZENYATTA END <<<



ALIASES
echo "✅ Updated aliases in ~/.bashrc"

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x setup.sh zen-* 2>/dev/null || true
chmod +x lib/*.sh 2>/dev/null || true

# GitHub username for zen-clone
echo ""
echo "🔧 GitHub username for zen-clone"
echo "   This lets you clone repos with: zen-clone <repo-name>"
echo ""
if [ -f ~/ai-playground/.zen-github-user ]; then
    EXISTING_USER=$(cat ~/ai-playground/.zen-github-user)
    echo "   Currently set to: $EXISTING_USER"
    read -p "   Change it? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "   GitHub username: " GITHUB_USER
        if [ -n "$GITHUB_USER" ]; then
            echo "$GITHUB_USER" > ~/ai-playground/.zen-github-user
            echo "   ✅ Updated to: $GITHUB_USER"
        fi
    fi
else
    read -p "   GitHub username (Enter to skip): " GITHUB_USER
    if [ -n "$GITHUB_USER" ]; then
        echo "$GITHUB_USER" > ~/ai-playground/.zen-github-user
        echo "   ✅ Saved: $GITHUB_USER"
    else
        echo "   Skipped. Set later with:"
        echo "   echo 'yourusername' > ~/ai-playground/.zen-github-user"
    fi
fi

echo ""
echo "▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
echo "✅ Setup Complete!"
echo "▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔"
echo ""
echo "⚠️  IMPORTANT: Activate the new commands"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "The commands have been added to your shell, but you need to reload it."
echo ""
echo "Choose one:"
echo "  1. Run: source ~/.bashrc    (fastest - keeps this terminal)"
echo "  2. Open a new terminal      (cleanest - fresh start)"
echo ""
read -p "Source ~/.bashrc now? (Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    echo "🔄 Sourcing ~/.bashrc..."
    source ~/.bashrc
    echo "✅ Commands activated!"
else
    echo ""
    echo "💡 Remember: Run 'source ~/.bashrc' before using zen-* commands"
fi

echo ""
echo "Clone your project repos here, then check out (or create) the branch you want AI to work on."
echo ""
echo "  git clone <url>"
echo "  cd <project> && git checkout -b ai/feature-name"
echo ""
echo "Quick start:"
echo "  zen-help           # Show all commands"
echo "  zen-doctor         # Check setup health"
echo "  zen-workflow       # See complete example"
echo ""
