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

if grep -q "# Zenyatta aliases" ~/.bashrc 2>/dev/null; then
    # Update existing aliases: zen-safe-pull → zen-meld
    if grep -q "zen-safe-pull" ~/.bashrc 2>/dev/null; then
        sed -i 's/zen-safe-pull/zen-meld/g' ~/.bashrc
        echo "✅ Updated aliases (zen-safe-pull → zen-meld)"
    else
        echo "✅ Aliases already exist"
    fi
else
    cat >> ~/.bashrc << 'ALIASES'

# Zenyatta aliases
alias zen-up='cd ~/zenyatta && podman-compose up -d && cd - > /dev/null'
alias zen-down='cd ~/zenyatta && podman-compose down && cd - > /dev/null'
alias zen-rebuild='cd ~/zenyatta && podman-compose down && podman-compose up -d --build && cd - > /dev/null'
alias playground='podman exec -it zenyatta /bin/bash'
alias zen-logs='podman logs -f zenyatta'
alias zen-push='cd ~/zenyatta && ./sync.sh'
alias zen-meld='cd ~/zenyatta && ./audit.sh'
alias zen-help='echo ""; echo "🧘 Zenyatta Commands"; echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"; echo "  zen-up              Start container"; echo "  zen-down            Stop container"; echo "  zen-rebuild         Rebuild container"; echo "  playground          Enter container"; echo "  zen-logs            View logs"; echo "  zen-push <project>  Push repo to airlock"; echo "  zen-meld <project>  Visual diff (Meld)"; echo "  zen-gitfetch <repo> Clone from GitHub into sandbox"; echo "  zen-help            This list"; echo ""'

zen-gitfetch() {
  local GITHUB_USER_FILE="$HOME/ai-playground/.zen-github-user"
  if [ ! -f "$GITHUB_USER_FILE" ]; then
    echo "❌ No sandbox GitHub username configured"
    echo ""
    echo "Re-run setup:  cd ~/zenyatta && ./setup.sh"
    echo "Or set manually: echo 'yourusername' > ~/ai-playground/.zen-github-user"
    return 1
  fi
  local SANDBOX_USER
  SANDBOX_USER=$(cat "$GITHUB_USER_FILE")
  if [ -z "$1" ]; then
    echo "Usage: zen-gitfetch <repo-name>"
    echo ""
    echo "Clones https://github.com/$SANDBOX_USER/<repo> into ~/ai-playground/repos/"
    echo "Only works for public repos unless you configure SSH keys in the sandbox."
    echo ""
    echo "Current repos:"
    ls -1 ~/ai-playground/repos/ 2>/dev/null || echo "  (none)"
    return 0
  fi
  if [ -d "$HOME/ai-playground/repos/$1" ]; then
    echo "⚠️  ~/ai-playground/repos/$1 already exists"
    return 1
  fi
  cd ~/ai-playground/repos && git clone "https://github.com/$SANDBOX_USER/$1.git"
  cd - > /dev/null
  echo ""
  echo "Next: Check out the branch you want (or create one), then: zen-push $1"
}
ALIASES
    echo "✅ Added aliases to ~/.bashrc"
fi

# Make scripts executable
chmod +x sync.sh audit.sh setup.sh 2>/dev/null || true

# GitHub username for zen-gitfetch
echo ""
echo "🔧 GitHub username for zen-gitfetch"
echo "   This lets you clone repos with: zen-gitfetch <repo-name>"
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
echo "Clone your project repos here, then check out (or create) the branch you want AI to work on."
echo ""
echo "  git clone <url>"
echo "  cd <project> && git checkout -b ai/feature-name"
echo ""
echo "Run zen-help for commands."
echo ""

cd ~/ai-playground && exec $SHELL
