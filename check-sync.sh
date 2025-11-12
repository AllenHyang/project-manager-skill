#!/bin/bash

# Check sync status with Claude Code pm skill
# Usage: ./check-sync.sh

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Paths
ORIGINAL_SKILL="/Users/allen/.claude/skills/project-manager"
PLUGIN_DIR="/Users/allen/Development/01-雅博项目/project-manager-skill"

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  PM Skill Sync Status Check${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# Function to check file difference
check_file() {
    local original="$1"
    local plugin="$2"
    local display_name="$3"

    if [ ! -f "$original" ]; then
        echo -e "${YELLOW}⚠️  $display_name: Original not found${NC}"
        return
    fi

    if [ ! -f "$plugin" ]; then
        echo -e "${RED}❌ $display_name: Plugin file missing${NC}"
        return
    fi

    if diff -q "$original" "$plugin" > /dev/null 2>&1; then
        local lines=$(wc -l < "$plugin" | tr -d ' ')
        echo -e "${GREEN}✅ $display_name: 一致 (${lines} 行)${NC}"
    else
        echo -e "${RED}❌ $display_name: 不一致${NC}"
        echo -e "${YELLOW}   运行以下命令查看差异:${NC}"
        echo -e "   diff \"$original\" \"$plugin\""
        echo ""
    fi
}

echo -e "${BLUE}核心文件:${NC}"
echo "---"
check_file "$ORIGINAL_SKILL/SKILL.md" "$PLUGIN_DIR/skills/project-manager/SKILL.md" "SKILL.md"
check_file "/Users/allen/.claude/commands/pm.md" "$PLUGIN_DIR/commands/pm.md" "pm.md"
echo ""

echo -e "${BLUE}参考文档 (references/):${NC}"
echo "---"
check_file "$ORIGINAL_SKILL/references/commands.md" "$PLUGIN_DIR/references/commands.md" "references/commands.md"
check_file "$ORIGINAL_SKILL/references/troubleshooting.md" "$PLUGIN_DIR/references/troubleshooting.md" "references/troubleshooting.md"
check_file "$ORIGINAL_SKILL/references/workflow.md" "$PLUGIN_DIR/references/workflow.md" "references/workflow.md"
echo ""

echo -e "${BLUE}提示词 (prompts/):${NC}"
echo "---"
check_file "$ORIGINAL_SKILL/prompts/task-quality-gate.md" "$PLUGIN_DIR/prompts/task-quality-gate.md" "prompts/task-quality-gate.md"
echo ""

echo -e "${BLUE}======================================${NC}"
echo -e "${GREEN}检查完成！${NC}"
echo -e "${BLUE}======================================${NC}"
