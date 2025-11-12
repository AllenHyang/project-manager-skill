# Project Manager Plugin V3.7

> Simple interface, rigorous process - Claude Code plugin for enforced project management workflows

## 🎯 Core Principle

**Easy to use, impossible to produce low-quality output**

- ✅ Conversational input (AI asks questions naturally)
- ✅ Enforced standards (all outputs follow formats)
- ✅ Quality gates (validation before critical operations)
- ✅ State machines (traceable workflows)

## ⚡ Quick Start

### Installation

1. Clone or download this repository
2. Copy to Claude Code plugins directory:

```bash
# Copy the entire plugin directory
cp -r project-manager-skill ~/.claude-code/plugins/project-manager
```

3. The plugin will be automatically loaded by Claude Code

### First Use

Just type `/pm` in Claude Code:

```
📊 Project Manager - Enforced Workflow

Current Status:
- 📝 Last log: (none yet)
- 🏗️ Recent ADRs: 0 documented decisions
- 📊 Last report: (none yet)
- ⚠️ Validation status: Pass

Available actions:
1. 📝 Log today's work        (/pm log)
2. 🏗️ Document a decision    (/pm decide)
3. 📊 Generate report         (/pm report)
4. 🔍 Check project status    (/pm status)
5. ✅ Validate project data   (/pm validate)

What would you like to do?
```

## 📋 Commands

### `/pm` - Interactive Menu
Shows project status and available actions.

### `/pm log` - Log Work
Conversational work logging with enforced standards.

**Example:**
```
You: /pm log

AI: 今天完成了什么？类型是：
    1. 完成任务 (task)
    2. 修复bug (bug)
    3. 代码重构 (refactor)
    4. 性能优化 (optimization)

You: 修复bug

AI: 具体是什么bug？

You: 邮件同步超时

AI: 怎么解决的？遇到了什么挑战？

You: 添加了30s超时和重试机制，挑战是要兼容不同邮箱

AI: ✅ 工作已记录！
    类型: Bug修复
    标题: 修复邮件同步超时bug
    位置: .project-log/daily-logs/2025-11/2025-11-05.md
    标准格式验证: ✅ 通过
```

### `/pm decide` - Document Decision
Create Architecture Decision Records with enforced completeness.

**Example:**
```
You: /pm decide

AI: 要记录什么技术决策？

You: 选择数据库

AI: 决定用什么？

You: PostgreSQL

AI: 考虑过哪些其他方案？优缺点是什么？

You: 考虑过MongoDB，但需要事务支持

AI: ✅ ADR created and validated!
    ADR-0001: Choose PostgreSQL for database
    Location: .project-log/decisions/0001-choose-postgresql-for-database.md
    Standard compliance: ✅ All required sections present
```

### `/pm report` - Generate Report
Generate progress reports with mandatory validation.

**Key Feature:** Cannot generate reports if validation fails.

```
You: /pm report

AI: 生成什么类型的报告？
    1. 日报 (daily)
    2. 周报 (weekly)
    3. 月报 (monthly)

You: 周报

AI: 🔒 Quality Gate: Pre-report Validation
    Running comprehensive validation...
    📝 Daily Logs: ✅ No gaps in last 7 days
    🏗️ ADRs: ✅ All have required sections
    ✅ Validation passed! Proceeding to report generation.

    ✅ 周报已生成！
    Location: .project-log/reports/weekly-2025-11-05.md
```

### `/pm status` - Check Status
Display project health dashboard with quality metrics.

### `/pm validate` - Validate Data
Run comprehensive validation suite manually.

## 📁 Directory Structure

All project data is stored in `.project-log/`:

```
project-root/
└── .project-log/
    ├── daily-logs/              # Work logs by date
    │   └── 2025-11/
    │       └── 2025-11-05.md
    ├── decisions/               # ADRs (sequential)
    │   ├── 0001-decision-title.md
    │   └── 0002-another-decision.md
    ├── reports/                 # Generated reports
    │   ├── weekly-2025-11-05.md
    │   └── .metadata/           # State machine data
    └── .validation/             # Validation results
```

## 🔒 Enforced Quality Gates

### For Logs
- ✅ Must have: type, title, details, impact
- ✅ Type must be: task, bug, refactor, or optimization
- ✅ Must describe: what, why, challenges, impact

### For ADRs
- ✅ Must have: all 4 sections (Context, Decision, Alternatives, Consequences)
- ✅ Must compare: 2+ alternatives with pros/cons
- ✅ Must document: BOTH positive AND negative consequences
- ✅ Cannot save incomplete ADRs

### For Reports
- ✅ MANDATORY: Run validation before generating
- ✅ BLOCK: If validation fails
- ✅ Must use: Report state machine (no bypassing)
- ✅ Must save: metadata with state transitions

## 💡 Key Features

### 1. Conversational BUT Structured
- User inputs naturally in conversation
- AI structures data internally to standard format
- Enforced validation before saving

### 2. Never Bypass Quality Gates
```
❌ DO NOT:
- Skip validation "to save time"
- Generate reports without validation
- Create ADRs without all sections
- Save incomplete logs

✅ ALWAYS:
- Run validation before reports
- Block if validation fails
- Require all standard sections
- Enforce state machine transitions
```

### 3. State Machines
Reports follow strict state transitions:
```
DRAFT → VALIDATING → GENERATING → PUBLISHED
           ↓
        INVALID (if validation fails)
```

## 🔧 Configuration

The plugin works out of the box with sensible defaults. No configuration required.

## 📖 Documentation

- **SKILL.md**: Complete skill definition for Claude Code
- **commands/pm.md**: Detailed command documentation with workflows

## 🤝 Integration

This plugin is based on the full [Project Manager Skill](https://github.com/your-org/project-manager) and adapted for Claude Code plugin architecture.

For the complete skill with Python scripts, hooks, and advanced features, see the original repository.

## 📝 License

MIT License - see LICENSE file for details

## 🆘 Support

For issues or questions, please open an issue in the repository.

---

**Version:** 3.7.0
**Last Updated:** 2025-11-12
