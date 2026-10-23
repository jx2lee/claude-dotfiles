#!/usr/bin/env bash
#
# notify.sh - Claude Code hook that posts a macOS notification.
#
# Clicking the notification runs jump.sh, which switches tmux to the pane
# that raised it. Outside tmux, the click just activates the terminal app.
#
# Hook events: Stop, Notification
# Input:       hook JSON on stdin (.message, .cwd)
#
# Environment:
#   CLAUDE_NOTIFY_NOTIFIER  terminal-notifier binary
#   CLAUDE_NOTIFY_TERMINAL  terminal app to activate     (default: Ghostty)
#   CLAUDE_NOTIFY_TMUX      tmux binary
#   CLAUDE_NOTIFY_HUB       command of the "hub" pane    (default: abtop, see jump.sh)
#
# Requires: jq, terminal-notifier, tmux

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_DIR
readonly JUMP="$SCRIPT_DIR/jump.sh"

# Prefer the LaunchServices-registered app bundle: macOS grants notification
# permission to that bundle, not to the Homebrew wrapper.
default_notifier() {
  local app="$HOME/Applications/terminal-notifier.app/Contents/MacOS/terminal-notifier"
  if [[ -x "$app" ]]; then
    echo "$app"
  else
    command -v terminal-notifier
  fi
}

readonly NOTIFIER="${CLAUDE_NOTIFY_NOTIFIER:-$(default_notifier)}"
readonly TERMINAL="${CLAUDE_NOTIFY_TERMINAL:-Ghostty}"
readonly TMUX_BIN="${CLAUDE_NOTIFY_TMUX:-$(command -v tmux || echo /opt/homebrew/bin/tmux)}"
readonly HUB="${CLAUDE_NOTIFY_HUB-abtop}"

main() {
  local input msg project pane session
  input="$(cat)"
  msg="$(jq -r '.message // "Response complete"' <<< "$input")"
  project="$(basename "$(jq -r '.cwd // "."' <<< "$input")")"
  pane="${TMUX_PANE:-}"

  if [[ -z "$NOTIFIER" ]]; then
    echo "notify.sh: terminal-notifier not found" >&2
    return
  fi

  if [[ -n "$pane" ]]; then
    session="$(LC_ALL=en_US.UTF-8 "$TMUX_BIN" display-message -p -t "$pane" '#{session_name}' 2>/dev/null)"
    # The click handler runs outside this hook's environment, so pass the
    # config through explicitly.
    "$NOTIFIER" \
      -title "Claude · $project" \
      -subtitle "tmux: ${session:-$pane}" \
      -message "$msg" \
      -group "claude-$pane" \
      -execute "CLAUDE_NOTIFY_TERMINAL='$TERMINAL' CLAUDE_NOTIFY_TMUX='$TMUX_BIN' CLAUDE_NOTIFY_HUB='$HUB' '$JUMP' '$pane'" \
      >/dev/null 2>&1 &
  else
    "$NOTIFIER" \
      -title "Claude · $project" \
      -subtitle "outside tmux" \
      -message "$msg" \
      -execute "open -a '$TERMINAL'" \
      >/dev/null 2>&1 &
  fi
}

main "$@"
# Never block Claude Code on a notification failure.
exit 0
