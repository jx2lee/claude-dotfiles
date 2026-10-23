# claude-dotfiles

Personal [Claude Code](https://claude.com/claude-code) skills.

## Skills

| Skill | Description |
| --- | --- |
| [`work-item`](skills/work-item/SKILL.md) | Drafts and creates Jira tickets in a short, consistent format. Fills empty start/due dates, adds AI work details as a comment, links the GitHub PR, and keeps the PR body concise. |

## Hooks

| Hook | Description |
| --- | --- |
| [`tmux-notify`](hooks/tmux-notify/README.md) | macOS notification on `Stop` / `Notification`. Click to jump to the tmux pane that raised it. |

## Install

```bash
git clone https://github.com/jx2lee/claude-dotfiles.git
REPO="$(pwd)/claude-dotfiles"

# Pick one
CLAUDE_DIR=~/.claude                   # global: every project
CLAUDE_DIR=/path/to/project/.claude    # project: that directory only

# Skills
mkdir -p "$CLAUDE_DIR/skills"
ln -s "$REPO/skills/work-item" "$CLAUDE_DIR/skills/work-item"

# Hooks
mkdir -p "$CLAUDE_DIR/hooks"
ln -s "$REPO/hooks/tmux-notify" "$CLAUDE_DIR/hooks/tmux-notify"
```

Then register the hook in `$CLAUDE_DIR/settings.json`. See [tmux-notify](hooks/tmux-notify/README.md#install).

For a project install, the symlinks point to your local clone. Add them to `.gitignore` instead of committing them.

## Usage

Ask Claude Code in natural language:

```
지라 올려줘
```

## Requirements

- Atlassian MCP server (Jira)
- `gh` CLI (for PR links)

## License

[MIT](LICENSE)
