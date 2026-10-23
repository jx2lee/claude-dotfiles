# claude-dotfiles

Personal [Claude Code](https://claude.com/claude-code) skills and hooks.

## Contents

| Name | Type | Description |
| --- | --- | --- |
| [`work-item`](skills/work-item/SKILL.md) | Skill | Drafts and creates Jira tickets in a short, consistent format. Fills empty start/due dates, adds AI work details as a comment, links the GitHub PR, and keeps the PR body concise. |
| [`tmux-notify`](hooks/tmux-notify/README.md) | Hook | macOS notification on `Stop` / `Notification`. Click to jump to the tmux pane that raised it. |

## Install

Clone the repo, then symlink what you need into a Claude config directory.

```bash
git clone https://github.com/jx2lee/claude-dotfiles.git ~/claude-dotfiles
```

Global (all projects):

```bash
mkdir -p ~/.claude/skills ~/.claude/hooks
ln -sfn ~/claude-dotfiles/skills/work-item ~/.claude/skills/work-item
ln -sfn ~/claude-dotfiles/hooks/tmux-notify ~/.claude/hooks/tmux-notify
```

Project (one directory only, run from the project root):

```bash
mkdir -p .claude/skills .claude/hooks
ln -sfn ~/claude-dotfiles/skills/work-item .claude/skills/work-item
ln -sfn ~/claude-dotfiles/hooks/tmux-notify .claude/hooks/tmux-notify
```

The project symlinks point to your local clone, so add them to `.gitignore`.

Hooks also need an entry in `settings.json`. See [tmux-notify](hooks/tmux-notify/README.md#setup).

## Requirements

| Name | Needs |
| --- | --- |
| `work-item` | Atlassian MCP server (Jira), `gh` CLI |
| `tmux-notify` | macOS, [terminal-notifier](https://github.com/julienXX/terminal-notifier), `jq`, `tmux` |

## License

[MIT](LICENSE)
