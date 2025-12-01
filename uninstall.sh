#!/bin/bash

# Uninstall PM CLI

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SKILL_DIR="$HOME/.claude/skills/project-manager"

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  PM CLI Uninstallation${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# Step 1: Uninstall Python package
echo -e "${BLUE}Step 1: Uninstalling Python package...${NC}"

if command -v pip &> /dev/null; then
    if pip show pm &> /dev/null; then
        pip uninstall pm -y
        echo -e "${GREEN}✅ Python package uninstalled${NC}"
    else
        echo -e "${YELLOW}pm package not found${NC}"
    fi
else
    echo -e "${YELLOW}pip not found, skipping package uninstall${NC}"
fi

# Step 2: Remove skill directory (optional)
echo -e "\n${BLUE}Step 2: Skill directory${NC}"
echo -e "${YELLOW}Skill directory: ${SKILL_DIR}${NC}"
read -p "Remove skill directory? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    if [ -d "$SKILL_DIR" ]; then
        rm -rf "$SKILL_DIR"
        echo -e "${GREEN}✅ Removed ${SKILL_DIR}${NC}"
    fi
else
    echo -e "${BLUE}Keeping skill directory${NC}"
fi

echo -e "\n${BLUE}======================================${NC}"
echo -e "${GREEN}✅ Uninstall complete${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
