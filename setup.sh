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
    echo "📝 Environment variables (.env)"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Zenyatta works without API keys for basic use."
    echo "If you use Claude Code, Ollama, OpenAI, or NVIDIA, you'll need keys."
    echo ""
    echo "A template has been created at: ~/ai-playground/.env"
    echo "Edit it anytime with: nano ~/ai-playground/.env"
    echo ""
    cp .env.example ~/ai-playground/.env
    echo "✅ Created .env from template"
fi

# Add aliases to .bashrc
echo ""
echo "🔧 Adding aliases to ~/.bashrc..."

if grep -q "# Zenyatta aliases" ~/.bashrc 2>/dev/null; then
    # Remove old aliases block and replace
    sed -i '/# Zenyatta aliases/,/^$/d' ~/.bashrc
    echo "♻️  Replacing old aliases..."
fi

cat >> ~/.bashrc << 'ALIASES'

# Zenyatta aliases
alias zen-up='cd ~/zenyatta && podman-compose up -d && cd - > /dev/null'
alias zen-down='cd ~/zenyatta && podman-compose down && cd - > /dev/null'
alias zen-rebuild='cd ~/zenyatta && podman-compose down && podman-compose up -d --build && cd - > /dev/null'
alias playground='podman exec -it zenyatta /bin/bash'
alias zen-logs='podman logs -f zenyatta'
alias zen-push='cd ~/zenyatta && ./sync.sh'
alias zen-meld='cd ~/zenyatta && ./audit.sh'

zen-help() {
  echo "Zenyatta Commands"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "  zen-up              Start container"
  echo "  zen-down            Stop container"
  echo "  zen-rebuild         Rebuild container image"
  echo "  playground          Enter container (exit to leave)"
  echo "  zen-push <project>  Copy repo → airlock (strips .git)"
  echo "  zen-meld <project>  Visual diff: airlock vs repo (Meld)"
  echo "  zen-logs            Tail container logs"
  echo "  zen-help            This list"
  echo "  zen-workflow        Recommended workflow steps"
  echo "  zen-ref             Full reference doc"
}

zen-workflow() {
  echo "Zenyatta Workflow"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo ""
  echo "1. Add project:     cd ~/ai-playground/repos && git clone <url>"
  echo "2. Start:           zen-up"
  echo "3. Push to airlock: zen-push my-project  (works while container runs)"
  echo "4. Enter sandbox:   playground"
  echo "5. Work:            cd /WIP-ai/my-project && claude"
  echo "6. Leave:           exit  (container keeps running)"
  echo "7. Review:          zen-meld my-project  (merge RIGHT→LEFT in Meld)"
  echo "8. Commit:          cd ~/ai-playground/repos/my-project && git add . && git commit"
  echo "9. Stop:            zen-down  (only when done for the day)"
  echo ""
  echo "Tip: Leave container running between tasks. zen-push adds repos live."
  echo "Env changes:  edit ~/ai-playground/.env → zen-down → zen-up"
  echo "Discard AI:   zen-push my-project  (overwrites airlock)"
  echo "Emergency:    zen-rebuild  (rebuilds image, volumes safe)"
}

zen-ref() {
  cat ~/zenyatta/REFERENCE.md
}

ALIASES
echo "✅ Added aliases to ~/.bashrc"

# Make scripts executable
chmod +x sync.sh audit.sh setup.sh 2>/dev/null || true

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ Setup Complete!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Next steps:"
echo "  1. source ~/.bashrc"
echo "  2. Edit ~/ai-playground/.env with your API keys (if needed)"
echo "  3. Add a project:  cd ~/ai-playground/repos && git clone <url>"
echo "  4. zen-up"
echo "  5. zen-push <project>"
echo "  6. playground"
echo ""
echo "Run zen-help for command list, zen-workflow for full flow."
echo ""
echo "💡 Breadcrumbs show where you are:"
echo "   Host:      your-normal-prompt$"
echo "   Container: [🧪 ZENYATTA] /WIP-ai/project$"
echo "   To leave:  type 'exit'"
echo ""
