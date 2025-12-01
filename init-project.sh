#!/bin/bash

# Initialize Project Manager structure in current project
# Usage: ./init-project.sh

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  Project Manager V3.7 - Init${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# Check if already initialized
if [ -d ".project-log" ]; then
    echo -e "${YELLOW}⚠️  .project-log/ already exists${NC}"
    read -p "Reinitialize? This will NOT delete existing data. (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Aborted."
        exit 0
    fi
fi

echo -e "${BLUE}Creating directory structure...${NC}"

# Create main directories
mkdir -p .project-log/daily-logs
mkdir -p .project-log/decisions
mkdir -p .project-log/reports/.metadata
mkdir -p .project-log/knowhow/{debugging,optimization,decisions,drafts}
mkdir -p .project-log/tasks
mkdir -p .pm/events

echo -e "${GREEN}✅ Created .project-log/ directory structure${NC}"

# Create tasks.json if not exists
if [ ! -f ".project-log/tasks/tasks.json" ]; then
    cat > .project-log/tasks/tasks.json << 'EOF'
{
  "tasks": [],
  "nextId": 1
}
EOF
    echo -e "${GREEN}✅ Created tasks.json${NC}"
fi

# Create context.json if not exists
if [ ! -f ".pm/context.json" ]; then
    cat > .pm/context.json << 'EOF'
{
  "currentTaskId": null,
  "lastTaskId": null,
  "workSession": {
    "startTime": null,
    "taskId": null
  }
}
EOF
    echo -e "${GREEN}✅ Created context.json${NC}"
fi

# Install config.yaml if not exists
if [ ! -f ".pm/config.yaml" ]; then
    # Find the skill directory
    SKILL_DIR="$HOME/.claude/skills/project-manager"
    if [ ! -d "$SKILL_DIR/templates/.pm" ]; then
        # Try development path
        SKILL_DIR="$HOME/Development/01-雅博项目/project-manager-skill"
    fi

    if [ -f "$SKILL_DIR/templates/.pm/config.yaml" ]; then
        cp "$SKILL_DIR/templates/.pm/config.yaml" .pm/
        echo -e "${GREEN}✅ Created config.yaml${NC}"
    else
        echo -e "${YELLOW}⚠️  config.yaml template not found, creating default${NC}"
        cat > .pm/config.yaml << 'EOF'
# Project Manager Configuration
validations:
  task:
    required_fields:
      - id
      - title
      - status
      - created_at
    status_values:
      - todo
      - in-progress
      - review
      - done
      - blocked
EOF
        echo -e "${GREEN}✅ Created default config.yaml${NC}"
    fi
fi

# Create .gitignore additions
if [ ! -f ".project-log/.gitignore" ]; then
    cat > .project-log/.gitignore << 'EOF'
# Keep structure but ignore some temporary files
*.tmp
.DS_Store
EOF
    echo -e "${GREEN}✅ Created .project-log/.gitignore${NC}"
fi

if [ ! -f ".pm/.gitignore" ]; then
    cat > .pm/.gitignore << 'EOF'
# Keep events and context
events/*.json
*.log
EOF
    echo -e "${GREEN}✅ Created .pm/.gitignore${NC}"
fi

# Install slash commands
echo ""
echo -e "${BLUE}Installing slash commands...${NC}"

# Find the skill directory
SKILL_DIR="$HOME/.claude/skills/project-manager"
if [ ! -d "$SKILL_DIR/commands/pm" ]; then
    # Try development path
    SKILL_DIR="$HOME/Development/01-雅博项目/project-manager-skill"
fi

if [ -d "$SKILL_DIR/commands/pm" ]; then
    mkdir -p .claude/commands

    # Copy all pm commands
    if [ -d ".claude/commands/pm" ]; then
        echo -e "${YELLOW}⚠️  .claude/commands/pm/ already exists, backing up...${NC}"
        mv .claude/commands/pm .claude/commands/pm.backup.$(date +%Y%m%d-%H%M%S)
    fi

    cp -r "$SKILL_DIR/commands/pm" .claude/commands/
    echo -e "${GREEN}✅ Installed slash commands to .claude/commands/pm/${NC}"

    # Count installed commands
    TASK_COUNT=$(find .claude/commands/pm/task -name "*.md" | wc -l | tr -d ' ')
    ADR_COUNT=$(find .claude/commands/pm/adr -name "*.md" | wc -l | tr -d ' ')
    OTHER_COUNT=$(find .claude/commands/pm -maxdepth 1 -name "*.md" | wc -l | tr -d ' ')

    echo -e "${BLUE}  • Task commands: ${TASK_COUNT}${NC}"
    echo -e "${BLUE}  • ADR commands: ${ADR_COUNT}${NC}"
    echo -e "${BLUE}  • Other commands: ${OTHER_COUNT}${NC}"
else
    echo -e "${YELLOW}⚠️  Could not find slash commands, skipping installation${NC}"
    echo -e "${YELLOW}    You can manually copy commands from the skill directory later${NC}"
fi

echo ""
echo -e "${BLUE}======================================${NC}"
echo -e "${GREEN}✅ Project initialized successfully!${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "${BLUE}Directory structure:${NC}"
echo "  .project-log/"
echo "    ├── daily-logs/          # Daily work logs"
echo "    ├── decisions/           # ADRs"
echo "    ├── reports/             # Generated reports"
echo "    ├── knowhow/             # Extracted knowledge"
echo "    └── tasks/               # Task management"
echo "  .pm/"
echo "    ├── events/              # Event capture"
echo "    └── context.json         # Current context"
echo ""
echo -e "${BLUE}Available slash commands:${NC}"
echo "  /pm/task/create      - Create new task"
echo "  /pm/task/start       - Start working on a task"
echo "  /pm/task/done        - Complete a task"
echo "  /pm/task/list        - List all tasks"
echo "  /pm/status           - Quick status check"
echo "  /pm/review           - Daily work review"
echo "  /pm/adr/create       - Create Architecture Decision Record"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Create your first task: /pm/task/create"
echo "  2. Start working: /pm/task/start"
echo "  3. Review your work: /pm/review"
echo ""
echo -e "${YELLOW}💡 Tip: Type /pm/task/ and press Tab to see all task commands${NC}"
echo ""
