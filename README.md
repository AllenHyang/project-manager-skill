# Project Manager V3.7 - Claude Code Plugin

> Event-Driven Project Management with automatic work capture, quality gates, and enforced workflows

**严格同步自 Claude Code pm skill** - 仅按 plugin 要求重新组织结构。

## 🎯 核心特性

### Event-Driven Project Management
- **自动工作捕获**: Hook-based 系统自动记录每次工具使用
- **智能事件处理**: 智能分组和日志生成
- **Know-How 提取**: AI 驱动的工作模式分析
- **Git 分支集成**: 从分支名自动推断任务 ID (`task/123`)

### 任务管理 + 质量门控
- **自然语言命令**: "创建任务：修复Bug"、"开始任务 123"
- **质量检查系统**: 6 维度评估（60 分制）
- **项目规则遵循**: 自动检查 `.task-context.md` 和 `.pm/task-rules.yaml`
- **Pre-flight 检查**: 任务启动前的质量保证

### 强制工作流 + 标准格式
- **对话式输入**: AI 自然提问收集信息
- **强制验证**: 保存前自动验证格式
- **状态机**: 可追溯的工作流转换
- **零容忍**: 不可能产生低质量输出

## 📦 安装

### 方式 1: 通过 Plugin 系统安装（推荐）

在 Claude Code 中运行：

```bash
# 1. 添加 marketplace
/plugin marketplace add AllenHyang/project-manager-skill

# 2. 安装 plugin
/plugin install project-manager@AllenHyang/project-manager-skill

# 3. 重启 Claude Code 以加载 plugin
```

或者使用交互式菜单：
```bash
/plugin
# 选择 "Browse Plugins" 并安装 project-manager
```

### 方式 2: 手动安装（高级用户）

如果你想手动管理 skill 和 command：

```bash
# Clone 仓库
git clone https://github.com/AllenHyang/project-manager-skill.git
cd project-manager-skill

# 安装 skill
mkdir -p ~/.claude/skills
cp -r skills/project-manager ~/.claude/skills/

# 安装 command
mkdir -p ~/.claude/commands
cp commands/pm.md ~/.claude/commands/

# 安装参考文档和提示词（推荐）
cp -r references ~/.claude/skills/project-manager/
cp -r prompts ~/.claude/skills/project-manager/
```

### 初始化项目

在你的项目目录下：

```bash
# 方式 1: 运行初始化脚本
/path/to/project-manager-skill/init-project.sh

# 方式 2: 手动创建结构
mkdir -p .project-log/{daily-logs,decisions,reports,knowhow,tasks}
mkdir -p .pm/events
```

初始化后会创建：
```
your-project/
├── .project-log/
│   ├── daily-logs/          # 自动生成的日志
│   ├── decisions/           # ADR 决策记录
│   ├── reports/             # 生成的报告
│   ├── knowhow/             # 提取的经验
│   └── tasks/               # 任务管理
│       └── tasks.json
└── .pm/
    ├── events/              # 事件捕获
    └── context.json         # 当前上下文
```

## 🚀 快速开始

### 方式 1: 任务管理工作流（推荐）

```bash
# 在 Claude Code 中使用自然语言
"创建任务：修复邮件同步超时"
→ AI 创建任务并自动进行质量检查

"开始任务 5"
→ AI 启动任务，创建 Git 分支，运行 pre-flight 检查

"暂停任务"
→ AI 暂停当前任务

"完成任务"
→ AI 完成任务并记录

# 或使用命令行
pm task create "修复Bug"
pm task start 5
pm task pause
pm task done
```

### 方式 2: 工作日志 + ADR 工作流

在 Claude Code 中输入 `/pm`:

```
📊 Project Manager - Enforced Workflow

Available actions:
1. 📝 Log today's work        (/pm log)
2. 🏗️ Document a decision    (/pm decide)
3. 📊 Generate report         (/pm report)
4. 🔍 Check project status    (/pm status)
5. ✅ Validate project data   (/pm validate)
```

### 工作回顾

```bash
# 在 Claude Code 中
"回顾今天的工作"

# 或使用命令
pm review
```

显示：
- Git commits
- 完成的任务
- Daily logs
- 捕获的 Know-How

## 📋 主要命令

### 任务管理

| 自然语言 | 命令 | 说明 |
|---------|------|------|
| "创建任务：{title}" | `pm task create "{title}"` | 创建并自动质量检查 |
| "开始任务 123" | `pm task start 123` | 启动任务 + Git 分支 |
| "暂停任务" | `pm task pause` | 暂停当前任务 |
| "完成任务" | `pm task done` | 完成当前任务 |
| "查看任务 123" | `pm task show 123` | 查看任务详情 |
| "列出任务" | `pm task list` | 列出所有任务 |

### 工作记录

| 命令 | 说明 |
|------|------|
| `/pm log` | 对话式工作日志（Bug/Task/Refactor） |
| `/pm decide` | 创建 ADR 决策记录 |
| `/pm report` | 生成报告（日报/周报/月报）|
| `/pm status` | 项目健康仪表板 |
| `/pm validate` | 手动运行验证套件 |

### 回顾与提取

| 命令 | 说明 |
|------|------|
| `pm review` | 查看今天的工作总结 |
| `pm auto-extract` | 提取 Know-How |
| `pm list-drafts` | 列出 Know-How 草稿 |

## 🎯 工作流示例

### 完整的任务工作流

```bash
# 1. 创建任务
"创建一个 urgent 任务：修复登录崩溃"
→ ✅ 任务 #5 已创建
→ 🔍 自动质量检查：45/60 分（良好）
→ 💡 建议：补充复现步骤和验收标准

# 2. 完善任务
"更新任务 5，补充 Bug 信息"
→ AI 智能生成完整的描述（基于上下文）

# 3. 启动任务
"开始任务 5"
→ ✅ Git 分支创建: task/5-fix-login-crash
→ ✅ Pre-flight 检查通过
→ ✅ 任务 #5 已启动

# 4. 开发过程（自动捕获）
[编辑代码、运行测试...]
→ Hook 自动捕获所有工具使用

# 5. 完成任务
"完成任务"
→ ✅ 任务 #5 已完成
→ 📝 工作已记录到 daily-logs

# 6. 回顾工作
"回顾今天的工作"
→ 显示完整的工作总结和 Know-How
```

## 🔒 质量门控

### 任务质量检查（6 维度）

创建任务后自动检查：

1. **基本完整性** (10 分): 标题、描述、优先级
2. **目的清晰度** (10 分): 明确的目标和背景
3. **类型特定要求** (10 分): Bug 需要复现步骤，Feature 需要用户故事
4. **验收标准** (10 分): 清晰的完成标准
5. **项目规则遵循** (10 分): 符合 `.pm/task-rules.yaml`
6. **最新关注对齐** (10 分): 符合 `.task-context.md` 的要求

**评分等级：**
- 🟢 优秀 (50-60): 可以开始
- 🟡 良好 (40-49): 建议改进
- 🟠 及格 (30-39): 需要改进
- 🔴 不足 (<30): 强烈建议改进

### 工作日志强制要求

- ✅ 必须包含: type, title, details, impact
- ✅ 类型: task, bug, refactor, optimization
- ✅ 必须描述: 做了什么、为什么、挑战、影响

### ADR 强制要求

- ✅ 必须有 4 个部分: Context, Decision, Alternatives, Consequences
- ✅ 必须比较 2+ 个方案及其优缺点
- ✅ 必须记录正面和负面影响

### 报告强制验证

- ✅ 生成前必须运行验证
- ✅ 验证失败则阻止生成
- ✅ 使用状态机: DRAFT → VALIDATING → GENERATING → PUBLISHED

## 🛠️ 工具脚本

### check-sync.sh - 同步检查

验证 plugin 与 Claude Code pm skill 的一致性：

```bash
./check-sync.sh
```

显示所有文件的同步状态（一致/不一致/缺失）。

### init-project.sh - 项目初始化

在新项目中初始化目录结构：

```bash
./init-project.sh
```

创建 `.project-log/` 和 `.pm/` 完整结构。

## 📖 文档

- **[SKILL.md](skills/project-manager/SKILL.md)**: 完整的 Skill 定义（466 行）
- **[commands/pm.md](commands/pm.md)**: /pm 命令文档（349 行）
- **[references/commands.md](references/commands.md)**: 完整命令参考
- **[references/troubleshooting.md](references/troubleshooting.md)**: 故障排查指南
- **[references/workflow.md](references/workflow.md)**: 详细工作流文档
- **[prompts/task-quality-gate.md](prompts/task-quality-gate.md)**: 质量检查框架

## 🔄 与原始 Skill 的关系

这个 plugin 是 **严格复制** Claude Code 的 pm skill：

```bash
# 原始位置
~/.claude/skills/project-manager/  # Skill
~/.claude/commands/pm.md            # Command

# Plugin 结构
skills/project-manager/SKILL.md    # 100% 相同
commands/pm.md                      # 100% 相同
references/                         # Bundled resources
prompts/                            # Bundled resources
```

使用 `./check-sync.sh` 验证一致性。

## 🚧 系统要求

- **Claude Code**: 支持 Skills 和 Commands
- **Git**: 用于分支管理和任务 ID 推断
- **Bash**: 用于运行脚本

## 📝 License

MIT License - see [LICENSE](LICENSE) for details

## 🆘 Support

- **Issues**: https://github.com/AllenHyang/project-manager-skill/issues
- **原始 Skill**: https://github.com/your-org/project-manager

---

**Version:** 3.7.0
**Last Updated:** 2025-11-12
**Sync Status:** ✅ 100% 与 Claude Code pm skill 同步
