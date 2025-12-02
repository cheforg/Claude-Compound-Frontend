# Compounding Engineering Workflow

This is a Claude Code workflow system. Clone and use directly.

## Structure

```
.claude/
├── commands/       # Slash commands (type / to see them)
│   └── workflows/  # Core: plan, work, review, compound
├── agents/         # Specialized agents
├── skills/         # Domain knowledge
├── settings.json   # MCP servers (Playwright, Context7)
├── progress.txt    # Session log
└── tasks/          # Task tracking
```

## Core Workflow

1. **Plan**: `/workflows:plan <feature>` - Create structured task
2. **Work**: `/workflows:work <task>` - Implement one feature at a time
3. **Review**: `/workflows:review` - Multi-agent code review
4. **Compound**: `/workflows:compound` - Document solved problems

## Philosophy

Each unit of work makes the next one easier. Document solutions. Codify patterns. Never solve the same problem twice.
