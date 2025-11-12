# Complete Workflow Guide

Detailed workflow documentation for Project Manager V3.7.

## V3.7 Event-Driven Workflow

### Daily Work Cycle

```
📅 During Work: Automatic Capture
   AI works on project
   ↓
   PostToolUse Hook captures each tool use
   ↓
   Appends to buffer: ~/.claude/skills/project-manager/.tool-buffer/{session}.jsonl
   ↓
   Stop Hook triggers at response end
   ↓
   Analyzes buffered tools
   ↓
   Generates Event → .pm/events/{event-id}.json
   ↓
   Directly writes to daily-log in real-time
   ✅ Work automatically recorded!
```

### End of Day: Review & Extract

```
🤖 Quick Review
   User: /pm review (or "回顾工作")
   ↓
   Claude runs: /Users/allen/.claude/skills/project-manager/pm review
   ↓
   ReviewManager collects:
   - Git commits (today's commits from git log)
   - Daily-log entries (from .project-log/daily-logs/)
   - Completed tasks (from task system)
   ↓
   Output:
   - 📊 Summary (commits, log entries, tasks count)
   - 📝 Git Commits list
   - ✅ Tasks Completed list
   - 📋 Log Entries list with timestamps
   - 💡 Know-How drafts count (if any)
```

### Knowledge Extraction

```
💡 Extract Knowledge (AI-Powered)
   User: pm auto-extract --date YYYY-MM-DD
   ↓
   AI analyzes daily-log content
   ↓
   Generates drafts in .project-log/knowhow/drafts/
   ↓
   User reviews and edits drafts
   ↓
   Changes status: draft → verified
   ↓
   Published to respective knowhow categories
```

## Task Workflow with Quality Gates

### Starting a Task

```
1. Create Task (optional - can adopt existing)
   pm task create "实现功能X" --priority high --tags feature

2. Start Task (with pre-flight checks)
   pm task start 123
   ↓
   🔍 Pre-flight Quality Gates:
   - ✅ Git working directory clean?
   - ✅ No merge conflicts?
   - ✅ No other active task?
   ↓
   Pass → Continue
   Fail → Show actionable suggestions
   ↓
   🌿 Auto-create branch: task/123-实现功能x
   ↓
   📝 Set task context
   ↓
   🚀 Task now active
```

### Working on Task

```
3. Work on Task
   All AI work automatically tracked
   ↓
   Events capture:
   - Files modified
   - Commands run
   - Git operations
   - Test results
   ↓
   Events linked to task #123
```

### Completing Task

```
4. Complete Task
   pm task done
   ↓
   Update task status → done
   ↓
   Clear active context
   ↓
   Optional: Merge branch (V3.7)
   pm task done --merge
```

## Task ID Inference Strategy

Three-layer automatic inference (no manual `pm workon` needed):

### Layer 1: Git Branch (Highest Priority)

```
Patterns recognized:
- task/123
- task/123-description
- fix/456
- fix/456-description
- feature/789
- feature/789-description
- 123-description

Example:
$ git checkout -b task/888-implement-auth
→ Task ID automatically set to: 888
```

### Layer 2: Conversation Content

```
Pattern: "Task #123" in AI responses

Example:
AI: "I'll help with Task #123..."
→ Task ID inferred: 123
```

### Layer 3: .task File (Fallback)

```
$ cat .task
123

→ Task ID: 123
```

## Daily-Log Structure

### Automatic Generation

Events are processed into daily logs with this structure:

```markdown
# Daily Log - 2025-11-06

## 📊 今日摘要

- 🐛 Bug修复: 2 个 (🤖 AI辅助: 2)
- 📝 代码修改: 5 个 (🤖 AI辅助: 5)

**重点工作**:
1. [14:30] 修复邮件同步超时问题 🤖
2. [15:45] 重构项目管理器Hook系统 🤖

## 📋 详细记录

### 🐛 Bug修复 (2)

#### [14:30] 修复邮件同步超时问题 🤖

**Task**: #123
**Files**: src/sync.ts, tests/sync.spec.ts
**Commands**: npm test, git commit
**Branch**: task/123-fix-sync

**Description**:
修复了邮件同步过程中的超时问题...

### 📝 代码修改 (5)

#### [16:20] 重构认证模块 🤖

**Task**: #125
**Files**: src/auth/index.ts
**Commands**: npm run build
**Branch**: task/125-refactor-auth

**Description**:
重构认证模块以支持多因素认证...
```

## Hook System Details

### PostToolUse Hook Flow

```
1. Tool used (Read, Write, Edit, Bash, etc.)
   ↓
2. PostToolUse hook triggers
   ↓
3. Hook script executes:
   ~/.claude/skills/project-manager/hooks/post-tool-use.sh
   ↓
4. Captures tool metadata:
   - Tool name
   - Parameters
   - Timestamp
   - Session ID
   ↓
5. Appends to buffer:
   ~/.claude/skills/project-manager/.tool-buffer/{session}.jsonl
```

### Stop Hook Flow

```
1. AI response completes
   ↓
2. Stop hook triggers
   ↓
3. Hook script executes:
   ~/.claude/skills/project-manager/hooks/stop-auto-log-v2.sh
   ↓
4. Reads tool buffer for this session
   ↓
5. Analyzes tools:
   - Files modified (Read/Write/Edit)
   - Commands run (Bash)
   - Type of work (bug fix, feature, refactor)
   ↓
6. Infers task ID (Git branch → Conversation → .task file)
   ↓
7. Generates event:
   .pm/events/{timestamp}-{random}.json
   ↓
8. Writes to daily log:
   .project-log/daily-logs/{YYYY-MM}/{YYYY-MM-DD}.md
   ↓
9. Clears buffer for this session
```

## Event Processing

### Event Structure

```json
{
  "id": "20251106-143052-abc123",
  "timestamp": "2025-11-06T14:30:52",
  "session_id": "session-xyz",
  "task_id": 123,
  "event_type": "bug_fix",
  "files_modified": ["src/sync.ts", "tests/sync.spec.ts"],
  "commands_run": ["npm test", "git commit -m 'fix: sync timeout'"],
  "branch": "task/123-fix-sync",
  "ai_assisted": true,
  "status": "processed",
  "processed_at": "2025-11-06T14:31:00"
}
```

### Event Types

- `bug_fix` - Bug fixes
- `feature` - New features
- `refactor` - Code refactoring
- `test` - Test additions/updates
- `docs` - Documentation updates
- `config` - Configuration changes
- `other` - Miscellaneous work

### Event Lifecycle

```
1. Created (status: unprocessed)
   .pm/events/{id}.json
   ↓
2. Processed (status: processed)
   Analyzed and added to daily log
   ↓
3. Archived (optional)
   Moved to .pm/archive/{YYYY-MM}/
```

## Quality Gates

### Pre-flight Checks (Task Start)

```python
def preflight_checks():
    checks = [
        check_git_clean(),           # No uncommitted changes
        check_no_conflicts(),        # No merge conflicts
        check_valid_branch(),        # On valid branch
        check_no_active_task(),      # No other task active
    ]

    if all_passed(checks):
        proceed()
    else:
        show_actionable_suggestions()
```

### Post-completion Validation (Task Done)

```python
def post_completion_checks():
    validations = [
        check_tests_passing(),       # All tests pass
        check_no_uncommitted(),      # Changes committed
        check_branch_pushed(),       # Branch pushed to remote
    ]

    if all_passed(validations):
        mark_complete()
    else:
        warn_and_suggest()
```

## Hotfix Workflow (V3.7)

Emergency fixes that bypass normal workflow:

```
1. Create Hotfix
   pm hotfix create "Critical bug in auth" --severity critical
   ↓
2. Auto-creates hotfix branch
   Branch: hotfix/{timestamp}-{title}
   ↓
3. Work on fix
   All events tagged as hotfix
   ↓
4. Complete Hotfix
   pm hotfix done
   ↓
5. Auto-merge to main + develop
   Restore previous task context
```

## Version History

- **V3.7** (2025-11-06): Quality gates, auto-branch creation, task workflows
- **V3.6** (2025-11-06): Event-driven architecture, removed manual task management, Hook-based capture
- **V3.5** (2025-11-05): Know-How auto-extraction, dual-format tasks
- **V3.0** (2025-11-04): Initial release with Hook system
