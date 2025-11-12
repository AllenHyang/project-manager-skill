# Command Reference

Complete reference for all pm commands.

## Task Management Commands

### Create Task

```bash
pm task create "实现邮件同步功能" --desc "需要支持多账户" --priority high --tags feature,urgent
```

**Parameters:**
- `title` (required) - Task title
- `--description` / `--desc` - Detailed description
- `--priority` - Priority level: low, medium, high, urgent (default: medium)
- `--tags` - Comma-separated tags

### List Tasks

```bash
pm task list                          # All tasks
pm task list --status pending         # By status
pm task list --priority high          # By priority
```

**Filters:**
- `--status` - Filter by status: todo, in-progress, paused, done
- `--priority` - Filter by priority: low, medium, high, urgent

### Show Task Details

```bash
pm task show 123
```

Display full details for a specific task including history and metadata.

### Update Task

```bash
pm task update 123 --status in_progress
pm task update 123 --priority urgent
pm task update 123 --title "New title"
pm task update 123 --description "New description"
pm task update 123 --tags "bug,critical"
pm task update 123 --notes "Additional notes"
```

**Parameters:**
- `--title` - Update task title
- `--description` / `--desc` - Update description
- `--status` - Update status (usually managed by start/pause/done commands)
- `--priority` - Update priority level
- `--tags` - Update tags (comma-separated)
- `--notes` - Add notes

### Start Task

```bash
pm task start 123
pm task start 123 --branch task/123-feature
pm task start 123 --skip-checks
```

Starts a task with pre-flight quality checks. Automatically creates a Git branch.

**Pre-flight checks:**
- Git working directory is clean
- No merge conflicts
- No other active task

**Parameters:**
- `--branch` - Custom branch name (auto-generated if not specified)
- `--skip-checks` - Skip pre-flight checks (not recommended)

### Pause Task

```bash
pm task pause
```

Pauses the currently active task.

### Resume Task

```bash
pm task resume 123
```

Resumes a previously paused task.

### Complete Task

```bash
pm task done
pm task done --merge
```

Marks the current task as complete.

**Parameters:**
- `--merge` - Automatically merge task branch to main (V3.7 feature)

### Adopt Task

```bash
pm task adopt 123
```

Adopt an existing task as the active task without running pre-flight checks.

## Core Commands

### Review Work

```bash
pm review
```

Display today's work summary including:
- Git commits
- Unprocessed events count
- Know-How drafts (if any)

**Note:** Non-interactive and safe to call automatically.

### Extract Know-How

```bash
# Extract knowledge from a specific date
pm auto-extract --date 2025-11-06

# Extract from date range
pm batch-extract --start-date 2025-11-01 --end-date 2025-11-06
```

AI-powered analysis of daily logs to extract actionable knowledge.

**Output:** Drafts in `.project-log/knowhow/drafts/`

### List Drafts

```bash
pm list-drafts
```

List all Know-How drafts awaiting review.

### Validate Draft

```bash
pm validate-draft .project-log/knowhow/drafts/debugging-001.md
```

Check draft quality before publishing.

### Initialize Project

```bash
pm init
pm init --force
```

Initialize pm structure in current project.

**Parameters:**
- `--force` - Overwrite existing configuration

## Event Management Commands

### List Events

```bash
pm events list                    # Today's events
pm events list --date 2025-11-06  # Specific date
pm events list --status unprocessed
```

**Filters:**
- `--date` - Filter by specific date (YYYY-MM-DD)
- `--status` - Filter by status: unprocessed, processed

### Show Event Details

```bash
pm events show 20251106-201530-abc123
```

Display full details for a specific event.

### Process Events

```bash
pm events process --date 2025-11-06
pm events process --ids ID1,ID2
```

Process events and generate daily log entries.

**Parameters:**
- `--date` - Process all events from a specific date
- `--ids` - Process specific event IDs (comma-separated)

### Event Statistics

```bash
pm events summary --date 2025-11-06
```

Display event statistics for a specific date.

## Hotfix Commands (V3.7)

### Create Hotfix

```bash
pm hotfix create "修复登录崩溃" --severity critical
```

Create an urgent hotfix task that bypasses normal workflow.

### Complete Hotfix

```bash
pm hotfix done
```

Mark hotfix as complete and restore previous task context.

## Refactor Commands (V3.7)

### Start Refactor

```bash
pm refactor start "重构认证模块"
```

Start a refactoring task with quality tracking.

### Complete Refactor

```bash
pm refactor done
```

Mark refactor as complete.

## Help

```bash
pm help
pm COMMAND --help
```

Display help information for commands.
