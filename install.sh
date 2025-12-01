#!/bin/bash

# Install PM CLI globally
# This installs the Python package to ~/.claude/skills/project-manager

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$HOME/.claude/skills/project-manager"

echo -e "${BLUE}======================================${NC}"
echo -e "${BLUE}  PM CLI Installation${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# Step 1: Copy files to skill directory
echo -e "${BLUE}Step 1: Setting up skill directory...${NC}"

if [ -d "$SKILL_DIR" ]; then
    echo -e "${YELLOW}Skill directory exists, updating...${NC}"
else
    echo -e "${BLUE}Creating skill directory...${NC}"
    mkdir -p "$SKILL_DIR"
fi

# Copy Python package
echo -e "${BLUE}Copying Python package...${NC}"
cp -r "${SCRIPT_DIR}/skills/project-manager/pm" "$SKILL_DIR/" 2>/dev/null || {
    # If not in skills/, create from current directory structure
    if [ -d "${SCRIPT_DIR}/pm" ]; then
        cp -r "${SCRIPT_DIR}/pm" "$SKILL_DIR/"
    else
        echo -e "${YELLOW}Creating pm package from ~/.claude/skills/project-manager/pm${NC}"
    fi
}

# Copy setup.py
if [ -f "${SCRIPT_DIR}/skills/project-manager/setup.py" ]; then
    cp "${SCRIPT_DIR}/skills/project-manager/setup.py" "$SKILL_DIR/"
elif [ -f "${SCRIPT_DIR}/setup.py" ]; then
    cp "${SCRIPT_DIR}/setup.py" "$SKILL_DIR/"
fi

# Copy SKILL.md
if [ -f "${SCRIPT_DIR}/skills/project-manager/SKILL.md" ]; then
    cp "${SCRIPT_DIR}/skills/project-manager/SKILL.md" "$SKILL_DIR/"
fi

echo -e "${GREEN}✅ Files copied to ${SKILL_DIR}${NC}"

# Step 2: Install Python package
echo -e "\n${BLUE}Step 2: Installing Python package...${NC}"

if command -v pip &> /dev/null; then
    cd "$SKILL_DIR"
    pip install -e . --quiet
    echo -e "${GREEN}✅ Python package installed${NC}"
else
    echo -e "${RED}Error: pip not found${NC}"
    echo -e "${YELLOW}Please install Python and pip first${NC}"
    exit 1
fi

# Step 3: Verify installation
echo -e "\n${BLUE}Step 3: Verifying installation...${NC}"

if command -v pm &> /dev/null; then
    echo -e "${GREEN}✅ pm command available${NC}"
    PM_VERSION=$(pm --version 2>&1 || pm help | head -1)
    echo -e "${GREEN}   ${PM_VERSION}${NC}"
else
    echo -e "${RED}❌ pm command not found${NC}"
    echo -e "${YELLOW}You may need to restart your shell or add Python bin to PATH${NC}"
    exit 1
fi

echo -e "\n${BLUE}======================================${NC}"
echo -e "${GREEN}✅ Installation complete!${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""
echo -e "${BLUE}Usage:${NC}"
echo "  pm init              # Initialize a project"
echo "  pm status            # Check project status"
echo "  pm task list         # List tasks"
echo "  pm help              # Show help"
echo ""
echo -e "${BLUE}Installed to:${NC} ${SKILL_DIR}"
echo ""
