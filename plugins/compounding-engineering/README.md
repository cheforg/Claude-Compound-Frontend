# Compounding Engineering Workflow

A Claude Code workflow system for long-running, multi-session development. Clone it, use it.

## Quick Start

```bash
git clone https://github.com/YOUR_ORG/compounding-engineering-workflow.git
cd compounding-engineering-workflow
claude
```

Then type `/workflows:` and you'll see all available commands.

## Core Commands

| Command | Purpose |
|---------|---------|
| `/workflows:plan` | Create structured task plans |
| `/workflows:work` | Make incremental progress on tasks |
| `/workflows:work-init` | Initialize long-running task support |
| `/workflows:review` | Multi-agent code review |
| `/workflows:compound` | Document solved problems |

## How It Works

### Session Continuity

The `/workflows:work-init` command creates:

```
.claude/
├── progress.txt    # Append-only session log
├── init.sh         # Dev environment startup
└── tasks/          # Task tracking files
```

Each session appends to `progress.txt`, so the next session picks up where you left off.

### Incremental Work

The `/workflows:work` command:

1. Reads progress to understand context
2. Picks ONE sub-feature to implement
3. Tests end-to-end before marking complete
4. Commits and updates progress

No more half-implemented features or broken builds between sessions.

## What's Included

### Commands (21)

All in `.claude/commands/`:

- **Workflow**: plan, work, work-init, review, compound, task-status
- **Parallel resolution**: resolve_parallel, resolve_pr_parallel, resolve_todo_parallel
- **Utilities**: changelog, triage, report-bug, reproduce-bug, and more

### Agents (26)

Specialized agents in `.claude/agents/` for:

- **Review**: architecture, security, performance, Rails/Python/TypeScript conventions
- **Research**: best practices, framework docs, git history analysis
- **Design**: Figma sync, design iteration, implementation review
- **Workflow**: bug reproduction, PR comment resolution, spec analysis

### Skills (11)

Domain knowledge in `.claude/skills/`:

- Ruby gem patterns (Andrew Kane style, DHH style)
- Frontend design
- DSPy.rb for LLM applications
- Image generation (Gemini)
- Git worktree management

### MCP Servers (2)

Pre-configured in `.claude/settings.json`:

- **Playwright**: Browser automation for E2E testing
- **Context7**: Framework documentation lookup

## Philosophy

**Compounding Engineering**: Each unit of work should make subsequent work easier.

When you solve a problem, document it with `/workflows:compound`. When you find a pattern, codify it. Never solve the same problem twice.

## Directory Structure

```
.claude/
├── commands/           # Slash commands
│   ├── workflows/      # Core workflow commands
│   └── *.md            # Utility commands
├── agents/             # Specialized agents
│   ├── review/
│   ├── research/
│   ├── design/
│   ├── workflow/
│   └── docs/
├── skills/             # Domain knowledge
├── settings.json       # MCP server config
├── progress.txt        # Session log (created by work-init)
└── tasks/              # Task files (created by plan)
```

## License

MIT
