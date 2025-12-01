---
name: task-status
description: Show progress on a task
argument-hint: "[optional: task slug]"
---

# Task Status

Display the current progress on tasks.

## Input

<task_input> #$ARGUMENTS </task_input>

## If No Task Specified

List all tasks with summary:

```bash
for f in .claude/tasks/*.json; do
  echo "$(basename $f .json):"
  total=$(cat $f | jq '.features | length')
  done=$(cat $f | jq '[.features[] | select(.passes == true)] | length')
  echo "  Progress: $done / $total"
  echo "  Status: $(cat $f | jq -r '.status')"
done
```

Output format:
```
## Task Overview

| Task | Progress | Status |
|------|----------|--------|
| user-avatars | 8/12 (67%) | in-progress |
| billing | 0/24 (0%) | not-started |
| team-permissions | 24/24 (100%) | complete |
```

## If Task Specified

Show detailed status:

```bash
cat .claude/tasks/$TASK.json | jq '.'
```

Output format:
```
## Task: user-avatars

**Title:** Add user profile avatars with S3 upload
**GitHub Issue:** #142
**Status:** in-progress
**Progress:** 8/12 features (67%)

### Completed
- [ua-001] Set up S3 bucket and IAM permissions
- [ua-002] Create avatar upload endpoint
- [ua-003] Add file type validation
- [ua-004] Implement image resizing
- [ua-005] Store resized images in S3
- [ua-006] Display avatar in header
- [ua-007] Display avatar on profile page
- [ua-008] Add avatar to comment threads

### Remaining
- [ua-009] Add avatar cropping UI (priority 9)
- [ua-010] Implement avatar deletion (priority 10)
- [ua-011] Add E2E tests for avatar flow (priority 11)
- [ua-012] Update API documentation (priority 12)

### Next Up
**[ua-009]** Add avatar cropping UI
> Allow users to crop their avatar after upload using a modal with crop controls.

To continue:
\`\`\`
claude /compounding-engineering:work user-avatars
\`\`\`
```

## Recent Activity

Also show recent progress entries for this task:

```bash
grep -A 10 "Task: $TASK" .claude/progress.txt | tail -20
```

## No Tasks Found

If `.claude/tasks/` doesn't exist or is empty:

```
No tasks found.

To create a task, run:
  claude /compounding-engineering:plan "Your feature description"

To initialize the project for long-running agent work:
  claude /compounding-engineering:work-init
```
