FROM node:22-bookworm

RUN apt-get update && apt-get install -y \
    python3 python3-pip git vim rsync nano tree sudo \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install opencode-ai requests --break-system-packages
RUN npm install -g @anthropic-ai/claude-code

RUN git config --global user.name "playgroundDev" && \
    git config --global user.email "sandbox@zenyatta.local"

RUN echo "export PS1='[🧘 ZENYATTA] \w\$ '" >> /root/.bashrc
RUN echo 'alias whereami="pwd; ls -1 /WIP-ai/"' >> /root/.bashrc

WORKDIR /WIP-ai
CMD ["sleep", "infinity"]
