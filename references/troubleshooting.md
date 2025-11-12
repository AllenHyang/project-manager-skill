# Troubleshooting Guide

Common issues and solutions for Project Manager V3.7.

## Events Not Being Captured

### Symptom
No events are being generated in `.pm/events/` directory.

### Check Hook Debug Log

```bash
tail -50 ~/.claude/skills/project-manager/hook-debug.log
```

Look for errors or warnings in the hook execution log.

### Verify Hooks Are Configured

```bash
cat .claude/settings.json | grep -A 10 hooks
```

Expected configuration:

```json
{
  "hooks": {
    "PostToolUse": [{
      "matcher": "*",
      "hooks": [{
        "type": "command",
        "command": "/Users/allen/.claude/skills/project-manager/hooks/post-tool-use.sh"
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "command",
        "command": "/Users/allen/.claude/skills/project-manager/hooks/stop-auto-log-v2.sh"
      }]
    }]
  }
}
```

### Check Hook Script Permissions

```bash
ls -la ~/.claude/skills/project-manager/hooks/
```

Scripts should be executable (`-rwxr-xr-x`). If not:

```bash
chmod +x ~/.claude/skills/project-manager/hooks/post-tool-use.sh
chmod +x ~/.claude/skills/project-manager/hooks/stop-auto-log-v2.sh
```

### Verify Tool Buffer

```bash
ls -la ~/.claude/skills/project-manager/.tool-buffer/
```

Check if buffer files are being created during sessions.

## Task ID Not Inferred

### Symptom
Events are not associated with any task ID.

### Solution: Use Proper Branch Naming

Task IDs are automatically inferred from Git branch names. Use these patterns:

✅ **Patterns that work:**
```bash
git checkout -b task/123-fix-auth
git checkout -b fix/456-sync-issue
git checkout -b feature/789-new-api
git checkout -b 123-description
```

❌ **Patterns that won't work:**
```bash
git checkout -b my-branch
git checkout -b fix-stuff
git checkout -b random-name
```

### Manual Task ID Setting (Fallback)

Create a `.task` file in project root:

```bash
echo "123" > .task
```

**Note:** Git branch naming is preferred over `.task` file.

### Verify Current Branch

```bash
git branch --show-current
```

Check if the branch name matches expected patterns.

## Too Many Events Generated

### Symptom
Hundreds of events generated per day.

### This is Expected Behavior

Stop Hook triggers after every AI response, generating 100+ events per day. This is intentional.

### How Events Are Managed

1. **Automatic grouping**: `pm review` intelligently groups related events
2. **Smart filtering**: Only significant events become daily-log entries
3. **Batch processing**: `pm events process` handles bulk event processing

### Don't Worry About Event Count

The system is designed to handle high event volumes. Focus on:
- Regular `pm review` to process events
- Using `pm auto-extract` to generate knowledge from processed events

## Pre-flight Checks Failing

### Uncommitted Changes

**Error:**
```
❌ Pre-flight checks failed
You have uncommitted changes
```

**Solutions:**

**Option 1: Commit changes**
```bash
git add .
git commit -m "your message"
pm task start 123
```

**Option 2: Stash changes**
```bash
git stash push -m "WIP: temporary work"
pm task start 123
```

**Option 3: Force start (not recommended)**
```bash
pm task start 123 --skip-checks
```

### Another Task Already Active

**Error:**
```
❌ Task #125 is already active
Please pause or complete it first
```

**Solutions:**

```bash
# Pause current task
pm task pause

# Or complete current task
pm task done

# Then start new task
pm task start 123
```

### Merge Conflicts Detected

**Error:**
```
❌ Merge conflicts detected
```

**Solution:**

Resolve conflicts before starting task:

```bash
# Check conflicted files
git status

# Resolve conflicts manually, then
git add .
git commit -m "Resolve merge conflicts"

# Now start task
pm task start 123
```

## Know-How Extraction Issues

### No Drafts Generated

**Check daily logs exist:**
```bash
ls .project-log/daily-logs/2025-11/
```

**Verify events were processed:**
```bash
pm events list --date 2025-11-06 --status processed
```

**Try manual extraction:**
```bash
pm auto-extract --date 2025-11-06
```

### Draft Quality Issues

**Validate draft:**
```bash
pm validate-draft .project-log/knowhow/drafts/debugging-001.md
```

**Common issues:**
- Missing context (add more details to daily logs)
- Too generic (be specific in commit messages and notes)
- Incomplete analysis (ensure full event context is captured)

## Git Branch Issues

### Branch Already Exists

**Error when starting task:**
```
⚠️  Failed to create/checkout branch
```

**Solution:**

The system automatically tries to checkout existing branch. If that fails:

```bash
# Manually checkout branch
git checkout task/123-description

# Or delete and recreate
git branch -d task/123-description
pm task start 123
```

### Branch Name Sanitization

Task titles are automatically sanitized for branch names:
- Special characters removed
- Spaces converted to hyphens
- Lowercase
- Max 50 characters

**Example:**
```
Task: "修复 Bug #123 - Email 同步问题!!!"
Branch: "task/123-修复-bug-123-email-同步问题"
```

## Permission Issues

### Hook Scripts Not Executable

```bash
chmod +x ~/.claude/skills/project-manager/hooks/*.sh
```

### Cannot Write to .pm/ Directory

```bash
# Check directory permissions
ls -la .pm/

# Fix if needed
chmod 755 .pm/
chmod 755 .pm/events/
```

## Performance Issues

### Slow Hook Execution

Check hook debug log for long-running operations:

```bash
tail -100 ~/.claude/skills/project-manager/hook-debug.log | grep "elapsed"
```

### Large Event Files

Events accumulate over time. Archive old events:

```bash
# Move old events to archive
mkdir -p .pm/archive/2025-10
mv .pm/events/20251001-* .pm/archive/2025-10/
```

## Getting Help

### Enable Debug Mode

Set environment variable for verbose logging:

```bash
export PM_DEBUG=1
```

### Check System Info

```bash
pm version
python3 --version
git --version
```

### Common Log Locations

- Hook debug log: `~/.claude/skills/project-manager/hook-debug.log`
- Tool buffer: `~/.claude/skills/project-manager/.tool-buffer/`
- Events: `.pm/events/`
- Daily logs: `.project-log/daily-logs/`

### Report Issues

Include in issue report:
1. Error message (full text)
2. Relevant log excerpts
3. System info (`pm version`)
4. Steps to reproduce
