---
name: work
description: Make incremental progress on a task, one feature at a time
argument-hint: "[task slug or path to task JSON file]"
---

# Incremental Work Session

You are a coding agent working on a long-running task. Your job is to make INCREMENTAL progress - completing exactly ONE sub-feature per work session, then leaving the environment in a clean state for the next session.

## Input

<task_input> #$ARGUMENTS </task_input>

If the input is empty, list available tasks:
```bash
ls .claude/tasks/*.json 2>/dev/null || echo "No tasks found. Run /plan first to create a task."
```

## CRITICAL RULES

1. **ONE FEATURE AT A TIME**: You MUST only work on a single sub-feature per session. Do not attempt multiple features.

2. **VERIFY BEFORE MARKING COMPLETE**: Never mark a feature as `"passes": true` without end-to-end testing. Use Playwright/browser automation for UI features.

3. **CLEAN STATE**: Before ending, ensure:
   - All changes are committed with descriptive messages
   - Progress file is updated
   - Task JSON is updated (only the `passes` field)
   - Tests pass
   - Dev server runs cleanly

4. **NEVER MODIFY FEATURE DESCRIPTIONS**: You may ONLY change the `passes` field from `false` to `true`. Never edit descriptions, steps, or delete features.

## Session Flow

### Phase 1: Orientation (ALWAYS DO THIS FIRST)

Run these commands in order:

```bash
# 1. Confirm working directory
pwd

# 2. Read recent progress
cat .claude/progress.txt | tail -50

# 3. Read the task file
cat .claude/tasks/$TASK.json

# 4. Find the next incomplete feature
cat .claude/tasks/$TASK.json | jq -r '.features[] | select(.passes == false) | "\(.priority): \(.id) - \(.description)"' | head -5

# 5. Check recent git history
git log --oneline -10

# 6. Start the development environment
./.claude/init.sh

# 7. Run smoke test to verify app works
# (customize based on project - e.g., curl health endpoint, run basic test)
```

### Phase 2: Select ONE Feature

From the incomplete features, select the one with the LOWEST priority number (highest priority).

Announce your selection:
```
Working on: [feature-id] - [description]
Priority: [N]
Category: [category]
```

### Phase 3: Implement the Feature

1. Read any relevant existing code first
2. Implement the feature following project conventions
3. Write or update tests as needed
4. Keep changes focused - don't refactor unrelated code

### Phase 4: Verify the Feature

**For backend/API features:**
```bash
# Run relevant tests
npm test -- --grep "[feature-name]"

# Test the endpoint manually
curl -X POST http://localhost:3000/api/...
```

**For UI features - USE PLAYWRIGHT MCP:**
```
Use the Playwright MCP to:
1. Navigate to the relevant page
2. Perform each step listed in the feature's "steps" array
3. Take screenshots as evidence
4. Verify the expected behavior occurs
```

**IMPORTANT**: Only mark as passing if ALL verification steps succeed.

### Phase 5: Update State and Commit

1. **Commit the changes:**
```bash
git add -A
git commit -m "feat([task-slug]): [description] ([feature-id])

- [Bullet point of what was implemented]
- [Another bullet point]

Closes [feature-id]"
```

2. **Update the task JSON:**
Change ONLY the `passes` field for the completed feature:
```json
{
  "id": "[feature-id]",
  "passes": true,  // ← Change this from false to true
  ...
}
```

3. **Update progress.txt:**
Append a new entry:
```
---
Date: [CURRENT_TIMESTAMP]
Task: [task-slug]
Feature: [feature-id] - [description]
Status: completed
Changes:
- [What you implemented]
- [What you tested]
Git commits: [commit-hash]
Next steps: [Next feature-id] - [Next description]
Issues: [Any bugs or concerns discovered, or "None"]
---
```

4. **Commit the state updates:**
```bash
git add .claude/
git commit -m "chore: update progress for [feature-id]"
```

### Phase 6: End Session or Continue

Check if there are more features:
```bash
cat .claude/tasks/$TASK.json | jq '[.features[] | select(.passes == false)] | length'
```

- If 0 remaining: Announce "All features complete! Ready for /review"
- If >0 remaining: Either continue to next feature OR end session cleanly

If ending the session, summarize:
```
Session complete.
- Completed: [feature-id]
- Remaining: [N] features
- Next up: [next-feature-id] - [description]
```

## Handling Broken State

If the smoke test fails during orientation:

1. **DO NOT start a new feature**
2. Read the last progress entry to understand what happened
3. Check git log for recent changes
4. Fix the broken state first
5. Commit the fix: `git commit -m "fix: [description of what was broken]"`
6. Update progress.txt noting the fix
7. THEN proceed to the next feature

## Handling Blocked Features

If you cannot complete a feature due to external dependencies or unclear requirements:

1. Update progress.txt with status "blocked" and explain why
2. Skip to the next feature by priority
3. Do NOT mark the blocked feature as passing

## Example Session

```
[Agent] Running orientation sequence...

> pwd
/home/user/my-app

> cat .claude/progress.txt | tail -20
---
Date: 2025-11-30T14:00:00Z
Task: user-avatars
Feature: ua-003 - Create upload endpoint
Status: completed
Next steps: ua-004 - Add image resizing
---

> cat .claude/tasks/user-avatars.json | jq '...'
Next incomplete: ua-004 (priority 4)

> ./.claude/init.sh
✅ Development environment ready

> curl http://localhost:3000/health
{"status": "ok"}

[Agent] Working on: ua-004 - Add image resizing with Sharp
Priority: 4
Category: api

<implements image resizing>
<tests with sample images>
<verifies resized images are correct dimensions>

> git commit -m "feat(user-avatars): add image resizing with Sharp (ua-004)"
> # Updates task JSON and progress.txt

[Agent] Session complete.
- Completed: ua-004
- Remaining: 8 features
- Next up: ua-005 - Store resized images in S3
```

## Quality Checklist

Before ending any session:

- [ ] Feature implementation complete
- [ ] All tests pass
- [ ] Changes committed with descriptive message
- [ ] Task JSON updated (passes: true)
- [ ] Progress file updated with session entry
- [ ] State updates committed
- [ ] Dev server runs cleanly

## Key Principles

### Incremental Progress
One feature at a time prevents half-implemented chaos. Complete, test, commit, repeat.

### Structured Handoff
JSON + progress file enables seamless session transitions. The next session picks up exactly where this one left off.

### Forced Verification
Features must be tested E2E before marking complete. Code inspection is not verification.

### Clean State
Every session ends with committed, working code. No dangling changes, no broken builds.
