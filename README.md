# claude-dotfiles

Personal [Claude Code](https://claude.com/claude-code) skills.

## Skills

| Skill | Description |
| --- | --- |
| [`work-item`](skills/work-item/SKILL.md) | Drafts and creates Jira tickets in a short, consistent format. Fills empty start/due dates, adds AI work details as a comment, links the GitHub PR, and keeps the PR body concise. |

## Install

```bash
git clone https://github.com/jx2lee/claude-dotfiles.git
mkdir -p ~/.claude/skills
ln -s "$(pwd)/claude-dotfiles/skills/work-item" ~/.claude/skills/work-item
```

## Usage

Ask Claude Code in natural language:

```
지라 올려줘
```

## Requirements

- Atlassian MCP server (Jira)
- `gh` CLI (for PR links)

## License

MIT
