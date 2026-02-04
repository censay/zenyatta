FROM node:22-bookworm

RUN apt-get update && apt-get install -y \
    python3 python3-pip git vim rsync nano tree sudo \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install opencode-ai requests --break-system-packages
RUN npm install -g @anthropic-ai/claude-code

RUN git config --global user.name "playgroundDev" && \
    git config --global user.email "sandbox@zenyatta.local"

# Make Vite/dev servers bind to all interfaces (visible from host)
ENV HOST=0.0.0.0

RUN echo "export PS1='[🧪 ZENYATTA] \w\$ '" >> /root/.bashrc
RUN echo 'alias whereami="pwd; ls -1 /WIP-ai/"' >> /root/.bashrc
RUN echo 'alias dev-host="echo Use: npm run dev -- --host 0.0.0.0"' >> /root/.bashrc

WORKDIR /WIP-ai
CMD ["sleep", "infinity"]
