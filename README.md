# ai-sandbox

Git ブランチごとに bubblewrap (bwrap) で隔離された開発環境を作成する CLI ツール。

## インストール

```bash
make install    # ~/.local/bin/ai-sandbox にインストール
make uninstall  # アンインストール
```

## 使い方

```bash
ai-sandbox [options] <branch> [claude|codex|bash] [args...]
```

### オプション

| オプション | 説明 |
|---|---|
| `--set-window-title` | tmux のウィンドウ名を `tool:branch` に設定する |
| `--recreate` | 既存の worktree を削除して作り直す |
| `--dry-run` | 実行せず設定内容を表示して終了する |

### 例

```bash
# claude でブランチ fix-bug の環境を起動
ai-sandbox fix-bug claude

# bash で入って手動作業
ai-sandbox fix-bug bash

# worktree を作り直して起動
ai-sandbox --recreate fix-bug claude

# 設定内容を確認
ai-sandbox --dry-run fix-bug claude
```

## GH_TOKEN

ホスト環境の `GH_TOKEN` がサンドボックスに渡されます。`dotenvx` 等で `.env` から読み込む想定です。

```bash
# .env
GH_TOKEN=ghp_xxxxxxxxxxxx

# dotenvx 経由で起動
dotenvx run -- ai-sandbox fix-bug claude
```

## 仕組み

1. リポジトリルートの `.git/worktrees-sandbox/{branch}` に Git worktree を作成
2. bubblewrap でシステム領域を読み取り専用マウントし、worktree と `.git` のみ書き込み可能にした隔離環境を起動
3. 指定されたツール (claude / codex / bash) をその環境内で実行

### サンドボックス内で利用可能なもの

- Python 3, Node.js 22, Go, Rust
- gh CLI, mise
- claude-code, codex
- ネットワークアクセス (共有)

### 環境変数

- `GH_TOKEN` — ホスト環境から渡される

API キー (`ANTHROPIC_API_KEY` 等) は各ツールの設定ファイル (`~/.claude`, `.claude.json` 等) 経由でサンドボックスにマウントされます。
