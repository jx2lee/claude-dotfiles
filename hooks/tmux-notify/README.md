# tmux-notify

macOS notifications for Claude Code. Click one to jump to the tmux pane that raised it.

| File | Role |
| --- | --- |
| `notify.sh` | `Stop` / `Notification` hook. Posts the notification. |
| `jump.sh` | Click handler. Switches tmux to the pane and activates the terminal. |

## Requirements

- macOS, [terminal-notifier](https://github.com/julienXX/terminal-notifier), `jq`, `tmux`

## Install

```bash
CLAUDE_DIR=~/.claude                   # global, or /path/to/project/.claude
mkdir -p "$CLAUDE_DIR/hooks"
ln -s "$(pwd)/hooks/tmux-notify" "$CLAUDE_DIR/hooks/tmux-notify"
```

Global: add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      { "hooks": [{ "type": "command", "command": "~/.claude/hooks/tmux-notify/notify.sh" }] }
    ],
    "Notification": [
      { "hooks": [{ "type": "command", "command": "~/.claude/hooks/tmux-notify/notify.sh" }] }
    ]
  }
}
```

Project: add the same block to `<project>/.claude/settings.local.json` (personal, not committed), with this command:

```
"$CLAUDE_PROJECT_DIR"/.claude/hooks/tmux-notify/notify.sh
```

## Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `CLAUDE_NOTIFY_TERMINAL` | `Ghostty` | Terminal app to activate |
| `CLAUDE_NOTIFY_NOTIFIER` | `~/Applications/terminal-notifier.app`, then `PATH` | terminal-notifier binary |
| `CLAUDE_NOTIFY_TMUX` | `tmux` in `PATH` | tmux binary |
| `CLAUDE_NOTIFY_HUB` | `abtop` | Command that marks a "hub" session. After a jump, `prefix+L` returns to it. Set empty to disable. |
| `CLAUDE_NOTIFY_LOG` | `$TMPDIR/claude-notify-jump.log` | Jump log |
