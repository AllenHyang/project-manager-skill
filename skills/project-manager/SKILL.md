---
name: project-manager
description: This skill should be used when users want to manage tasks with quality gates, review work progress, or use natural language task commands. It provides V3.7 event-driven project management with automatic work capture via Hooks, progressive quality checks, and Know-How extraction. Supports slash commands and natural language patterns like "创建任务", "开始任务N", "给任务N添加描述".
license: MIT
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
---

# Project Manager V3.7

**Event-Driven Project Management**: Automatic work capture, intelligent event processing, and Know-How extraction.

## Overview

Project Manager V3.7 uses a **Hook-based event system** to automatically capture every AI interaction. No manual logging required. At the end of a work session, run `pm review` to organize events and extract actionable knowledge.

### Key Features

- **Automatic Work Capture**: PostToolUse + Stop Hooks capture every tool use
- **Intelligent Event Processing**: Smart grouping and daily-log generation
- **Know-How Extraction**: AI-powered analysis of work patterns
- **Git Branch Integration**: Auto-infers Task IDs from branch names (`task/123`)
- **Quality Gates**: Pre-flight checks before task start, post-validation on completion

## Quick Start

### Check Status

When user types `/pm status` or `/pm:status`, execute:

```bash
/Users/allen/.claude/skills/project-manager/pm status
```

Displays: Current branch, in-progress tasks, today's activity summary.

### Review Work

When user types `/pm review` or `/pm:review`, execute:

```bash
/Users/allen/.claude/skills/project-manager/pm review
```

Displays: Git commits, daily logs, completed tasks, Know-How captured.

### Common Commands

```bash
# Task management
pm task create "Title" --priority high --tags feature
pm task start 123              # Auto-creates branch, runs quality checks
pm task pause                  # Pause current task
pm task done                   # Complete task

# Review and extraction
pm review                      # Today's work summary
pm auto-extract --date DATE    # Extract knowledge
pm list-drafts                 # List Know-How drafts

# Event management
pm events list                 # List today's events
pm events process --date DATE  # Process events
```

For complete command reference, see `references/commands.md`.

## When to Use This Skill

### Use this skill when user mentions:

- **Task workflow**: "开始任务 N", "暂停任务", "完成任务"
- **Review work**: "/pm review", "回顾工作", "整理工作"
- **Extract knowledge**: "提取经验", "保存经验"
- **Check events**: "查看事件", "检查事件"
- **Natural language commands**: "创建任务", "给任务N添加描述", "任务N优先级改成urgent"

### Bundled Resources

- **`references/commands.md`** - Complete command reference
- **`references/troubleshooting.md`** - Common issues and solutions
- **`references/workflow.md`** - Detailed workflow documentation

Load these references when users need detailed documentation or troubleshooting help.

### Project-Level Task Rules

When creating tasks, ALWAYS check for project-specific rules:

- **`.task-context.md`** (project root) - Current development context and temporary rules
  - Quick notes and recent findings
  - Temporary focus areas
  - Read this FIRST when creating tasks

- **`.pm/task-rules.yaml`** (project) - Stable, structured task creation rules
  - Project-specific requirements by task type
  - Templates and validation rules
  - Common mistakes to avoid

**Usage**: Load these files when:
- Creating tasks (read both files to apply relevant rules)
- User asks about task creation guidelines
- User says "记一下" or "添加规则" (append to .task-context.md)

### Task Quality Gate (V3.7+)

When starting tasks or checking task quality, use the intelligent quality gate system:

- **`prompts/task-quality-gate.md`** - AI-guided quality check framework
  - 6-dimensional quality assessment (60 points total)
  - Smart analysis based on task type and project rules
  - Generates detailed reports with actionable suggestions

**Trigger scenarios**:
1. **`pm task start`** or `/pm:task:start` - Automatically check before starting
2. **`pm task check`** or `/pm:task:check` - Explicitly check task quality
3. Natural language: "检查任务 123", "这个任务可以开始了吗"

**Check process**:
1. Load task from `.project-log/tasks/tasks.json` or task file
2. Read `prompts/task-quality-gate.md` for check framework
3. Read `.task-context.md` and `.pm/task-rules.yaml` for project rules
4. Perform 6-dimensional intelligent analysis:
   - Basic completeness (10 pts)
   - Purpose clarity (10 pts)
   - Type-specific requirements (10 pts)
   - Acceptance criteria (10 pts)
   - Project rule compliance (10 pts)
   - Latest focus alignment (10 pts)
5. Generate detailed report with score and suggestions
6. Provide actionable improvement commands

**Quality levels**:
- 🟢 Excellent (50-60): Ready to start
- 🟡 Good (40-49): Suggest improvements
- 🟠 Passing (30-39): Needs improvement
- 🔴 Insufficient (<30): Strongly recommend improvement

## Natural Language Command Translation

Automatically recognize user's natural language intentions and execute corresponding pm commands.

### Task Creation

**Patterns:**
- "创建任务：{title}"
- "新建任务 {title}"
- "新建一个 {priority} 任务：{title}"

**Execute:** `pm task create "{title}" [--priority {priority}] [--tags "{tags}"]`

**⭐ IMPORTANT - Quality Check After Creation:**
After creating a task, you MUST immediately perform a quality check:

1. **Read the created task** from `.project-log/tasks/tasks.json`
2. **Read project rules FIRST** (这是检查的基础):
   - `.task-context.md` - 最新关注点和临时规则（含 TDD 要求）
   - `.pm/task-rules.yaml` - 稳定的项目规范
3. **Load quality gate prompt**: `prompts/task-quality-gate.md`
4. **Perform 6-dimensional analysis** based on project rules:
   - Check if task includes test design (TDD requirement)
   - Check if task complies with project standards
   - Generate quality report
5. **Provide recommendations** based on score:
   - 🟢 Excellent (50-60): Suggest starting the task
   - 🟡 Good (40-49): Suggest improvements before starting
   - 🟠 Passing (30-39): Needs improvement
   - 🔴 Insufficient (<30): Strongly recommend improvements

**Complete workflow:**
```
User: "创建任务：修复邮件bug"
  ↓
AI: Execute pm task create "修复邮件bug"
  ↓
AI: ✅ Task #5 created
  ↓
AI: 🔍 Performing quality check...
  ↓
AI: [Read task, load prompts, analyze]
  ↓
AI: 📊 Quality Score: XX/60
  ↓
AI: [Provide specific recommendations]
```

**Examples:**
- User: "创建任务：修复邮件bug"
  → Execute: `pm task create "修复邮件bug"`
  → **Then automatically check quality and provide feedback**

- User: "新建一个 urgent 任务：紧急修复"
  → Execute: `pm task create "紧急修复" --priority urgent`
  → **Then automatically check quality and provide feedback**

### Task Update

**Patterns:**

**方式 1：直接指定更新内容（简单更新）**
- "给任务 {id} 添加描述：{description}"
- "任务 {id} 优先级改成 {priority}"
- "任务 {id} 加标签 {tags}"
- "任务 {id} 改名为 {title}"

**方式 2：基于上下文的智能更新（推荐）⭐**
- "更新任务 {id}，{上下文描述}"
- "完善任务 {id}"
- "按照建议更新任务 {id}"
- "补充任务 {id} 的信息"
- "改进任务 {id}"

**Execute:**
- 方式 1：`pm task update {id} --{field} "{value}"`
- 方式 2：**AI 智能生成内容** → `pm task update {id} --{field} "{generated_value}"`

**智能更新工作流（方式 2）**：
1. **触发 pm skill**：识别到上下文更新意图
2. **分析上下文**：
   - 回顾最近的对话（质量检查报告、改进建议）
   - 读取当前任务内容
   - 理解用户意图（补充什么信息）
3. **智能生成内容**：
   - 根据上下文和改进建议生成完整内容
   - 遵循项目规则和模板
   - 确保信息完整性
4. **执行更新**：`pm task update {id} --description "{完整的生成内容}"`
5. **确认结果**：显示更新后的内容供用户确认

**Field mapping:**
- "添加描述"/"加描述" → `--description`
- "优先级"/"改优先级" → `--priority`
- "加标签"/"添加标签" → `--tags`
- "改名"/"重命名" → `--title`
- "备注"/"添加备注" → `--notes`

**Examples:**

**方式 1 示例（直接指定）**：
- User: "给任务 1 添加描述：yellow"
  → Execute: `pm task update 1 --description "yellow"`

- User: "任务 123 优先级改成 urgent"
  → Execute: `pm task update 123 --priority urgent`

**方式 2 示例（智能更新）**：
- User: "更新任务 5，补充完整的 Bug 信息和验收标准"
  → AI 分析：刚才做过质量检查，有具体的改进建议
  → AI 生成：包含复现步骤、错误日志、影响范围、验收标准的完整描述
  → Execute: `pm task update 5 --description "{生成的完整内容}"`

- User: "按照建议完善任务 5"
  → AI 分析：质量检查报告中的所有改进建议
  → AI 生成：完整的描述，包括所有必需信息
  → Execute: `pm task update 5 --description "{生成的完整内容}"`

- User: "改进任务 3 的标题"
  → AI 分析：当前标题不规范
  → AI 生成：符合项目规范的标题
  → Execute: `pm task update 3 --title "[Bug] {改进后的标题}"`

**重要提示**：
- 方式 2 需要 AI 有足够的上下文（如刚完成质量检查）
- 如果上下文不足，AI 应该询问具体要更新什么内容
- 生成内容后建议让用户确认再执行

### Task Start

**Patterns:**
- "开始任务 {id}"
- "启动任务 {id}"
- "开工任务 {id}"

**Execute:** `pm task start {id}`

**Example:**
- User: "开始任务 1"
  → Execute: `pm task start 1`

### Task Pause

**Patterns:**
- "暂停"
- "暂停任务"
- "暂停当前任务"

**Execute:** `pm task pause`

### Task Done

**Patterns:**
- "完成任务"
- "任务完成"
- "完工"
- "结束任务"

**Execute:** `pm task done`

### Task List

**Patterns:**
- "列出任务"
- "查看任务"
- "查看 {status} 任务" (e.g., "查看进行中的任务")
- "列出 {priority} 优先级任务"

**Execute:** `pm task list [--status {status}] [--priority {priority}]`

**Status mapping:**
- "进行中"/"正在做" → `in-progress`
- "待办"/"未开始" → `todo`
- "暂停"/"已暂停" → `paused`
- "完成"/"已完成" → `done`

**Priority mapping:**
- "紧急"/"urgent" → `urgent`
- "高优先级"/"high" → `high`
- "中等"/"medium" → `medium`
- "低优先级"/"low" → `low`

**Examples:**
- User: "列出任务"
  → Execute: `pm task list`

- User: "查看进行中的任务"
  → Execute: `pm task list --status in-progress`

### Task Show

**Patterns:**
- "查看任务 {id}"
- "任务 {id} 详情"
- "显示任务 {id}"

**Execute:** `pm task show {id}`

**Example:**
- User: "查看任务 1"
  → Execute: `pm task show 1`

### Task Resume

**Patterns:**
- "恢复任务 {id}"
- "继续任务 {id}"
- "继续做任务 {id}"

**Execute:** `pm task resume {id}`

**Example:**
- User: "恢复任务 5"
  → Execute: `pm task resume 5`

### Hotfix Create

**Patterns:**
- "创建 hotfix：{title}"
- "紧急修复：{title}"

**Execute:** `pm hotfix create "{title}" --severity critical`

**Example:**
- User: "创建 hotfix：修复登录崩溃"
  → Execute: `pm hotfix create "修复登录崩溃" --severity critical`

### Hotfix Done

**Patterns:**
- "完成 hotfix"
- "hotfix 完成"
- "紧急修复完成"

**Execute:** `pm hotfix done`

### Review Work

**Patterns:**
- "回顾工作"
- "查看今天的工作"
- "工作总结"
- "review"

**Execute:** `/Users/allen/.claude/skills/project-manager/pm review`

**Example:**
- User: "回顾今天的工作"
  → Execute: `/Users/allen/.claude/skills/project-manager/pm review`

### Execution Rules

1. **Execute immediately**: When recognizing a pattern, run the pm command without explaining first
2. **Parse accurately**: Extract task IDs (integers) and values carefully from user input
3. **Quote strings**: Always quote descriptions, titles, and tags in command arguments
4. **Confirm briefly**: After execution, provide concise confirmation without verbose explanation
5. **Choose common interpretation**: If multiple interpretations are possible, select the most common use case
6. **Extract from context**: Identify task IDs, priority levels, and status keywords in user's message

## Project Structure

```
.project-log/
├── daily-logs/           # Generated from processed events
│   └── 2025-11/
│       └── 2025-11-06.md
├── knowhow/              # Extracted knowledge
│   ├── debugging/
│   ├── optimization/
│   ├── decisions/
│   └── drafts/           # AI-generated drafts awaiting review
└── reports/              # Generated reports (future)

.pm/
├── events/               # Unprocessed work events
│   └── 20251106-*.json
└── context.json          # Active task context
```

## How It Works

### Automatic Event Capture

1. **PostToolUse Hook** captures every tool use to buffer
2. **Stop Hook** processes buffer when response completes
3. Events saved to `.pm/events/` with task context
4. Daily logs auto-generated in `.project-log/daily-logs/`

### Task ID Inference (3-Layer Strategy)

Task IDs are automatically inferred, no manual `pm workon` needed:

1. **Git Branch** (highest priority)
   - Patterns: `task/123`, `fix/456`, `feature/789`

2. **Conversation Content**
   - Pattern: `Task #123` mentioned in AI responses

3. **.task File** (fallback)
   - Read from project root `.task` file

**Example:**
```bash
git checkout -b task/888-implement-auth
# Task ID automatically set to: 888
```

## Troubleshooting

For common issues and detailed solutions, see `references/troubleshooting.md`.

**Quick checks:**
- Events not captured? Check `~/.claude/skills/project-manager/logs/hook-$(date +%Y-%m-%d).log`
- Task ID not inferred? Use proper branch naming: `task/123-description`
- Pre-flight checks failing? See error suggestions for commit/stash/force options
- View all logs: `ls ~/.claude/skills/project-manager/logs/`

## See Also

- **Command Reference**: `references/commands.md` - Complete command documentation
- **Troubleshooting**: `references/troubleshooting.md` - Common issues and solutions
- **Workflow Details**: `references/workflow.md` - Detailed workflow documentation
- **Hook Implementation**: `hooks/HOOK_SETUP.md` - Hook system setup and internals
