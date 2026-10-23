# tmux-notify

macOS notifications for Claude Code. Click one to jump to the tmux pane that raised it.

| File | Role |
| --- | --- |
| `notify.sh` | `Stop` / `Notification` hook. Posts the notification. |
| `jump.sh` | Click handler. Switches tmux to the pane and activates the terminal. |

## Requirements

```bash
brew install terminal-notifier jq tmux
```

Then allow notifications for terminal-notifier in System Settings > Notifications. The first notification triggers the prompt.

## Setup

1. Symlink this directory (see the [top-level README](../../README.md#install)).
2. Register the hook.

Global, in `~/.claude/settings.json`:

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

Project, in `<project>/.claude/settings.local.json`: same block, with this command:

```json
"command": "\"$CLAUDE_PROJECT_DIR\"/.claude/hooks/tmux-notify/notify.sh"
```

3. Test it:

```bash
echo '{"message":"hello"}' | ~/.claude/hooks/tmux-notify/notify.sh
```

## Configuration

The defaults match the author's setup. Override them with environment variables, for example in the `env` block of `settings.json`.

| Variable | Default | Description |
| --- | --- | --- |
| `CLAUDE_NOTIFY_TERMINAL` | `Ghostty` | Terminal app to activate (e.g. `iTerm`, `Terminal`) |
| `CLAUDE_NOTIFY_NOTIFIER` | `~/Applications/terminal-notifier.app`, then `PATH` | terminal-notifier binary |
| `CLAUDE_NOTIFY_TMUX` | `tmux` in `PATH` | tmux binary |
| `CLAUDE_NOTIFY_HUB` | `abtop` | Command that marks a "hub" session. After a jump, `prefix+L` returns to it. Set empty to disable. |
| `CLAUDE_NOTIFY_LOG` | `$TMPDIR/claude-notify-jump.log` | Jump log |
