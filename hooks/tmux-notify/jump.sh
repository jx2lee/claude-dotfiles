#!/usr/bin/env bash
#
# jump.sh - Switch tmux to the pane that raised a Claude Code notification.
#
# Run by terminal-notifier when a notification from notify.sh is clicked.
#
# Usage: jump.sh <pane-id>    (e.g. %12)
#
# Behavior:
#   1. Pick the tmux client to move: the most recently active client whose
#      current or previous session runs the hub command. If none, the most
#      recently active client.
#   2. Switch that client to the target session, window and pane.
#   3. Leave the hub session as the client's last session, so prefix+L
#      returns to it.
#   4. Activate the terminal app.
#
# Environment:
#   CLAUDE_NOTIFY_TERMINAL  terminal app to activate          (default: Ghostty)
#   CLAUDE_NOTIFY_TMUX      tmux binary
#   CLAUDE_NOTIFY_HUB       command identifying hub sessions  (default: abtop, empty to disable)
#   CLAUDE_NOTIFY_LOG       log file                          (default: $TMPDIR/claude-notify-jump.log)

set -uo pipefail

readonly TERMINAL="${CLAUDE_NOTIFY_TERMINAL:-Ghostty}"
readonly TMUX_BIN="${CLAUDE_NOTIFY_TMUX:-$(command -v tmux || echo /opt/homebrew/bin/tmux)}"
readonly HUB="${CLAUDE_NOTIFY_HUB-abtop}"
readonly LOG="${CLAUDE_NOTIFY_LOG:-${TMPDIR:-/tmp}/claude-notify-jump.log}"
readonly TAB=$'\t'

# The click runs outside tmux; behave the same even if launched from inside.
unset TMUX TMUX_PANE
# Under the C locale tmux replaces tabs and non-ASCII with '_', breaking parsing.
export LC_ALL=en_US.UTF-8

HUB_SESSIONS=""

log() {
  echo "$(date '+%F %T') $*" >> "$LOG"
}

tmux_() {
  "$TMUX_BIN" "$@"
}

activate_terminal() {
  open -a "$TERMINAL"
}

load_hub_sessions() {
  [[ -z "$HUB" ]] && return
  HUB_SESSIONS="$(tmux_ list-panes -a -F "#{pane_current_command}${TAB}#{session_name}" \
    | awk -F"$TAB" -v hub="$HUB" '$1 == hub { print $2 }')"
}

is_hub() {
  [[ -n "$1" && -n "$HUB_SESSIONS" ]] && grep -qxF -- "$1" <<< "$HUB_SESSIONS"
}

# Sets CLIENT_TTY, CLIENT_SESSION, CLIENT_LAST.
pick_client() {
  local _activity tty session last
  local first_tty="" first_session="" first_last=""
  CLIENT_TTY="" CLIENT_SESSION="" CLIENT_LAST=""

  while IFS="$TAB" read -r _activity tty session last; do
    [[ -z "$tty" ]] && continue
    if [[ -z "$first_tty" ]]; then
      first_tty="$tty" first_session="$session" first_last="$last"
    fi
    if is_hub "$session" || is_hub "$last"; then
      CLIENT_TTY="$tty" CLIENT_SESSION="$session" CLIENT_LAST="$last"
      return
    fi
  done < <(tmux_ list-clients \
    -F "#{client_activity}${TAB}#{client_tty}${TAB}#{session_name}${TAB}#{client_last_session}" \
    | sort -rn)

  CLIENT_TTY="$first_tty" CLIENT_SESSION="$first_session" CLIENT_LAST="$first_last"
}

main() {
  local pane="${1:-}" target

  if [[ -z "$pane" ]]; then
    echo "usage: $(basename "$0") <pane-id>" >&2
    return 2
  fi

  target="$(tmux_ display-message -p -t "$pane" '#{session_name}' 2>/dev/null)"
  if [[ -z "$target" ]]; then
    log "pane $pane not found (session closed?)"
    activate_terminal
    return
  fi

  load_hub_sessions
  pick_client

  tmux_ select-window -t "$pane"
  tmux_ select-pane -t "$pane"

  if [[ -z "$CLIENT_TTY" ]]; then
    log "no attached client; activating $TERMINAL only"
  elif [[ "$CLIENT_SESSION" == "$target" ]]; then
    log "$CLIENT_TTY already on '$target'; selected $pane"
  else
    # Visit the hub first so it becomes the last session (prefix+L target).
    if ! is_hub "$CLIENT_SESSION" && is_hub "$CLIENT_LAST"; then
      tmux_ switch-client -c "$CLIENT_TTY" -t "=$CLIENT_LAST"
    fi
    tmux_ switch-client -c "$CLIENT_TTY" -t "=$target"
    log "$CLIENT_TTY: '$CLIENT_SESSION' -> '$target' ($pane)," \
      "last=$(tmux_ display-message -p -c "$CLIENT_TTY" '#{client_last_session}')"
  fi

  activate_terminal
}

main "$@"
