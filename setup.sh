#!/bin/bash
# Zenyatta Setup - Run once from ~/zenyatta/
set -e

echo "🧪 Zenyatta Setup"
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
mkdir -p ~/ai-playground/{.container_config,.container_share/zenyatta,repos,WIP}

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

# Create .env in workspace (not in scaffold)
if [ ! -f ~/ai-playground/.env ]; then
    echo ""
    read -p "Do you need Ollama or API keys? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cp .env.example ~/ai-playground/.env
        echo "✅ Created .env at ~/ai-playground/.env"
        echo "   Edit it with: nano ~/ai-playground/.env"
    else
        touch ~/ai-playground/.env
        echo "✅ Created empty .env (not needed for basic use)"
    fi
fi

# Add aliases to .bashrc
echo ""
echo "🔧 Adding aliases to ~/.bashrc..."

if grep -q "# Zenyatta aliases" ~/.bashrc 2>/dev/null; then
    echo "✅ Aliases already exist"
else
    cat >> ~/.bashrc << 'ALIASES'

# Zenyatta aliases
alias zen-up='cd ~/zenyatta && podman-compose up -d'
alias zen-down='cd ~/zenyatta && podman-compose down'
alias zen-rebuild='cd ~/zenyatta && podman-compose down && podman-compose up -d --build'
alias playground='podman exec -it zenyatta /bin/bash'
alias zen-logs='podman logs -f zenyatta'
alias zen-push='cd ~/zenyatta && ./sync.sh'
alias zen-safe-pull='cd ~/zenyatta && ./audit.sh'
ALIASES
    echo "✅ Added aliases to ~/.bashrc"
fi

# Make scripts executable
chmod +x sync.sh audit.sh setup.sh 2>/dev/null || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📍 Structure:"
echo "   ~/zenyatta/           - Scaffold files (you are here)"
echo "   ~/ai-playground/      - Workspace (repos, WIP, state)"
echo ""
echo "Next steps:"
echo "  1. source ~/.bashrc          # Activate aliases"
echo ""
echo "  2. Add your projects to ~/ai-playground/repos/:"
echo ""
echo "     # Clone from GitHub (recommended)"
echo "     cd ~/ai-playground/repos"
echo "     git clone <url> my-project"
echo ""
echo "     # To work on zenyatta scaffold itself:"
echo "     git clone git@github.com:censay/zenyatta.git"
echo ""
echo "     # Copy existing (for testing)"
echo "     cp -r ~/my-project ~/ai-playground/repos/"
echo ""
echo "     # Move existing (permanent)"
echo "     mv ~/my-project ~/ai-playground/repos/"
echo ""
echo "  3. zen-up                    # Build & start"
echo "  4. zen-push <project>        # Push to airlock"
echo "  5. playground                # Enter container"
echo "  6. (work, then type 'exit' to leave)"
echo "  7. zen-safe-pull <project>   # Review with Meld"
echo ""
echo "📖 See README.md for full workflow"
echo "📖 See zen-docs/ for detailed guides"
echo ""
echo "💡 Breadcrumbs show where you are:"
echo "   Host:      your-normal-prompt$"
echo "   Container: [🧪 ZENYATTA] /WIP-ai/project$"
echo "   To leave:  type 'exit'"
echo ""
