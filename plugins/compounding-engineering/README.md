# Compounding Engineering

A workflow system for Claude Code that enables long-running, multi-session development. Each unit of work makes the next one easier.

## The Problem

AI agents working on complex tasks face real challenges:

- **Context limits** force work to span multiple sessions
- **No memory** between sessions means starting over each time
- **One-shot attempts** at complex features leave half-implemented code
- **Premature victory** declarations leave bugs undiscovered

## The Solution

A structured workflow with persistent state:

```
your-project/
├── .claude/
│   ├── progress.txt       # Append-only session log
│   ├── init.sh            # Dev environment startup
│   └── tasks/
│       └── feature.json   # Feature breakdown with pass/fail tracking
```

## Quick Start

### 1. Copy the Workflow Files

Clone or copy the `commands/workflows/` directory into your project:

```bash
# From this repo
cp -r commands/workflows/ /path/to/your-project/.claude/commands/workflows/
```

### 2. Initialize Your Project

```bash
cd /path/to/your-project
claude
```

Then run:
```
/workflows:work-init
```

This creates:
- `.claude/progress.txt` - Session log for continuity
- `.claude/init.sh` - Environment startup script
- `.claude/tasks/` - Directory for task tracking

### 3. Plan a Feature

```
/workflows:plan Add user authentication with OAuth
```

Creates a structured task file with sub-features, priorities, and acceptance criteria.

### 4. Work Incrementally

```
/workflows:work user-authentication
```

Each session:
1. Reads progress to understand context
2. Picks ONE sub-feature to implement
3. Tests end-to-end before marking complete
4. Commits and updates progress

### 5. Review When Done

```
/workflows:review
```

Multi-agent code review with architecture, security, and pattern analysis.

## Core Workflow Commands

| Command | Purpose |
|---------|---------|
| `/workflows:work-init` | Initialize project for long-running work |
| `/workflows:plan` | Create structured task plans |
| `/workflows:work` | Make incremental progress on tasks |
| `/workflows:review` | Comprehensive code review |
| `/workflows:compound` | Document solved problems |

## How It Works

### Session Continuity

Every session appends to `progress.txt`:

```
---
Date: 2025-12-01T14:00:00Z
Task: user-auth
Feature: auth-003 - Add OAuth callback handler
Status: completed
Changes:
- Implemented OAuth callback endpoint
- Added session token generation
- Tested with Google OAuth
Git commits: abc123
Next steps: auth-004 - Add logout endpoint
Issues: None
---
```

The next session reads this log and picks up exactly where you left off.

### Task Tracking

Features are tracked in JSON with pass/fail status:

```json
{
  "task": "user-auth",
  "features": [
    {
      "id": "auth-001",
      "description": "Add login button to header",
      "priority": 1,
      "passes": true
    },
    {
      "id": "auth-002",
      "description": "Create OAuth redirect endpoint",
      "priority": 2,
      "passes": false
    }
  ]
}
```

### Key Principles

**Incremental Progress**: One feature at a time prevents half-implemented chaos.

**Forced Verification**: Features must be tested E2E before marking complete.

**Clean State**: Every session ends with committed, working code.

**Structured Handoff**: JSON + progress file enables seamless transitions.

## Additional Components

This repo also includes agents, skills, and MCP server configs that enhance the workflow:

### Agents (26)

Specialized agents for code review, research, and automation. See `agents/` for the full list.

### Skills (11)

Domain-specific knowledge including Ruby gem patterns, frontend design, and style guides. See `skills/` for details.

### MCP Servers (2)

Browser automation (Playwright) and documentation lookup (Context7). Add to your `.claude/settings.json`:

```json
{
  "mcpServers": {
    "playwright": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@playwright/mcp@latest"]
    },
    "context7": {
      "type": "http",
      "url": "https://mcp.context7.com/mcp"
    }
  }
}
```

## Directory Structure

```
compounding-engineering/
├── commands/
│   └── workflows/      # Core workflow commands (copy these)
│       ├── work-init.md
│       ├── plan.md
│       ├── work.md
│       ├── review.md
│       └── compound.md
├── agents/             # Specialized agents
├── skills/             # Domain knowledge
└── templates/          # Task templates
```

## Philosophy

**Compounding Engineering**: Each unit of work should make subsequent work easier, not harder.

When you solve a problem, document it. When you find a pattern, codify it. The `/compound` command captures solutions so you never solve the same problem twice.

## License

MIT
