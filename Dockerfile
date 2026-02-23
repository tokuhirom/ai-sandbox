FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# 基本ツール + Python + Go
RUN apt-get update && apt-get install -y \
    curl git openssh-client ca-certificates build-essential pkg-config \
    libssl-dev zlib1g-dev \
    python3 python3-pip python3-venv \
    golang-go \
    && rm -rf /var/lib/apt/lists/*

# Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g @anthropic-ai/claude-code @openai/codex

# gh CLI
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    > /etc/apt/sources.list.d/github-cli.list \
    && apt-get update && apt-get install -y gh && apt-get clean

# 非rootユーザー作成
ARG UID=1000
RUN userdel -r ubuntu 2>/dev/null || true \
    && useradd -m -s /bin/bash -u "${UID}" sandbox
USER sandbox
WORKDIR /home/sandbox

# mise
RUN curl https://mise.run | sh
ENV PATH="/home/sandbox/.local/bin:${PATH}"

# Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/home/sandbox/.cargo/bin:${PATH}"

ENTRYPOINT ["bash"]
