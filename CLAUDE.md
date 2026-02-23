# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build Commands

```bash
make build      # Build Docker image (ai-sandbox)
make install    # Build image and install script to ~/.local/bin/ai-sandbox
make uninstall  # Remove installed script
```

## Architecture

ai-sandbox is a CLI tool that creates isolated, containerized development environments per Git branch using worktrees.

**Components:**
- `ai-sandbox` — Bash script that manages Git worktrees and launches Docker containers. Takes a branch name and optional tool (`claude`, `codex`, or `bash`). Worktrees are created at `.git/worktrees-sandbox/{branch}`.
- `Dockerfile` — Ubuntu 24.04 image with Python 3, Node.js 22, Go, Rust, and AI tools (claude-code, codex). Includes gh CLI, mise, and standard build tooling.
- `Makefile` — Build and install targets for the Docker image and script.

**Runtime behavior:** The script finds the repo root, creates/reuses a worktree, then runs a Docker container mounting the worktree, Git config, and SSH keys. API keys (ANTHROPIC_API_KEY, OPENAI_API_KEY) are passed via environment variables.
