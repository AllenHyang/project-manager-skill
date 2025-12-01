# PM CLI 安装指南

## 快速安装

```bash
# 1. Clone 仓库
git clone https://github.com/AllenHyang/project-manager-skill.git
cd project-manager-skill

# 2. 运行安装脚本
./install.sh

# 3. 验证安装
pm help
```

## 安装说明

安装脚本会：
1. 复制 Python 包到 `~/.claude/skills/project-manager`
2. 使用 pip 安装为可编辑模式（editable install）
3. `pm` 命令将自动添加到 PATH

## 系统要求

- Python 3.7+
- pip
- bash
- Git（用于任务分支管理）

## 使用

安装完成后，在任意项目目录：

```bash
# 初始化项目结构
pm init

# 查看项目状态
pm status

# 列出任务
pm task list

# 查看帮助
pm help
```

## 完整功能

在 Claude Code 中使用自然语言：
- "创建任务：修复Bug"
- "开始任务 5"
- "完成任务"

或使用 `/pm` 命令访问完整工作流。

## 卸载

```bash
./uninstall.sh
```

## 故障排查

### pm 命令找不到

如果安装后 `pm` 命令找不到，可能需要：

1. 重启终端
2. 确认 Python bin 目录在 PATH 中：
   ```bash
   echo $PATH | grep python
   ```
3. 手动检查安装位置：
   ```bash
   which pm
   pip show pm
   ```

### 权限问题

如果遇到权限问题，确保：
- 不需要 sudo（使用用户级 pip 安装）
- `~/.claude/skills` 目录可写

### Python 版本

检查 Python 版本：
```bash
python --version  # 应该是 3.7+
pip --version
```

## 开发模式

如果你想修改 pm 代码：

```bash
cd ~/.claude/skills/project-manager
# 编辑 pm/ 目录下的文件
# 修改会立即生效（editable install）
```

## 更多信息

- 完整文档: [README.md](README.md)
- Skill 定义: [skills/project-manager/SKILL.md](skills/project-manager/SKILL.md)
- Commands: [commands/pm.md](commands/pm.md)
