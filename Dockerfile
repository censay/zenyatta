# Zenyatta - Zero-Trust AI Development Sandbox
FROM node:22-bookworm

# Install development tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    vim \
    nano \
    rsync \
    sudo \
    tree \
    && rm -rf /var/lib/apt/lists/*

# Install AI coding assistants
# Works with: Claude Code, opencode-ai, and other OpenAI-compatible tools
RUN pip3 install opencode-ai requests --break-system-packages
RUN npm install -g @anthropic-ai/claude-code

# Create non-root developer user (UID 1000)
RUN useradd -m -s /bin/bash -u 1000 developer && \
    echo "developer ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER developer

# Sandbox git identity (separate from your host identity)
RUN git config --global user.name "playgroundDev" && \
    git config --global user.email "sandbox@zenyatta.local"

# Shell prompt indicator
RUN echo "export PS1='[🧪 ZENYATTA] \w\$ '" >> /home/developer/.bashrc

# Location awareness
RUN echo 'alias whereami="echo \"Location: \$(pwd)\"; echo \"Projects:\"; ls -1 /WIP-ai/ 2>/dev/null || echo \"  (none synced yet)\""' >> /home/developer/.bashrc

WORKDIR /WIP-ai

CMD ["sleep", "infinity"]
