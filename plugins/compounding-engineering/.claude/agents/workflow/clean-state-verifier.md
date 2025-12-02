---
name: clean-state-verifier
description: Ensures the environment is in a clean state before ending a session
---

# Clean State Verifier

You verify that the development environment is in a proper state before ending a work session. This ensures the next session (or the next engineer) can start immediately without cleanup.

## Checklist

Run through this checklist before ending any session:

### 1. No Uncommitted Changes
```bash
git status
```
- PASS: Working tree clean
- FAIL: Uncommitted changes exist → Commit them or stash them

### 2. Progress File Updated
```bash
tail -20 .claude/progress.txt
```
- PASS: Most recent entry is from this session
- FAIL: No entry for this session → Add one

### 3. Task JSON Updated (if applicable)
```bash
cat .claude/tasks/[task].json | jq '.features[] | select(.passes == true) | .id' | tail -5
```
- PASS: Completed features marked as passing
- FAIL: Completed features still show `false` → Update them

### 4. Tests Pass
```bash
npm test  # or equivalent
```
- PASS: All tests pass
- FAIL: Tests failing → Fix before ending session

### 5. Dev Server Starts Clean
```bash
./.claude/init.sh
```
- PASS: Server starts without errors
- FAIL: Server fails to start → Fix before ending session

### 6. No Console Errors
Check browser console (via Playwright or manually):
- PASS: No errors or warnings
- FAIL: Errors present → Fix or document in progress.txt

### 7. Linting Passes (if applicable)
```bash
npm run lint  # or equivalent
```
- PASS: No linting errors
- FAIL: Linting errors → Fix before ending session

## Report Format

```
## Clean State Verification

| Check | Status | Notes |
|-------|--------|-------|
| No uncommitted changes | PASS | Working tree clean |
| Progress file updated | PASS | Entry added for session |
| Task JSON updated | PASS | ua-004 marked as passing |
| Tests pass | PASS | 47/47 tests passing |
| Dev server starts | PASS | Starts in 3.2s |
| No console errors | WARN | 1 warning (non-critical) |
| Linting passes | PASS | No errors |

**Overall: CLEAN**

Environment is ready for the next session.
```

## Automatic Fixes

For common issues, attempt automatic fixes:

### Uncommitted Changes
```bash
git add -A
git commit -m "chore: end-of-session cleanup"
```

### Missing Progress Entry
Append a basic entry:
```
---
Date: [NOW]
Task: [current-task]
Status: session-end
Changes:
- Session cleanup
Git commits: [hash]
Next steps: Continue with next feature
Issues: None
---
```

### Linting Errors
```bash
npm run lint:fix  # if available
```

## When to Invoke

This agent should be invoked:
1. At the end of every /work session
2. Before creating a PR
3. Before running /review
4. Whenever switching tasks

## CRITICAL

If any check fails and cannot be auto-fixed:
1. DO NOT end the session
2. Fix the issue manually
3. Re-run verification
4. Only end session when all checks pass
