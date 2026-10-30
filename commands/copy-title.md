---
description: Copy the current session name (set by /rename) to the clipboard
allowed-tools: Bash
---

Session name: !`t=$(grep -h '"custom-title"' ~/.claude/projects/*/"$CLAUDE_CODE_SESSION_ID".jsonl 2>/dev/null | tail -1 | jq -r .customTitle); printf %s "$t" | pbcopy; echo "${t:-<none>}"`

If the session name above is `<none>`, reply only: "No session name set. Run /rename first."
Otherwise reply only: "Copied: <session name>". Do not run any tools.
