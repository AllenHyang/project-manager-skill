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
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Start using: Type /pm in Claude Code"
echo "  2. Create task: pm task create \"Your task title\""
echo "  3. Review work: pm review"
echo ""
