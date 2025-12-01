#!/usr/bin/env python3
"""
PM - Project Manager CLI Tool
Main entry point for the command-line interface
"""

import os
import sys
import subprocess
import re
from pathlib import Path
from urllib.request import urlopen
from urllib.error import URLError

VERSION = "4.0.0"
GITHUB_REPO = "AllenHyang/project-manager-skill"
GITHUB_RAW_URL = f"https://raw.githubusercontent.com/{GITHUB_REPO}/main/skills/project-manager/setup.py"


def get_skill_dir():
    """Get the project-manager-skill directory"""
    # The skill is installed at ~/.claude/skills/project-manager
    # We need to find the project-manager-skill repo
    skill_dir = Path(__file__).parent.parent.parent
    return skill_dir


def run_bash_script(script_name, args=None):
    """Run a bash script from the skills directory"""
    skill_dir = get_skill_dir()
    
    # Try to find the script in common locations
    possible_paths = [
        skill_dir / script_name,
        skill_dir.parent.parent / "project-manager-skill" / script_name,
        Path.home() / "Development" / "01-雅博项目" / "project-manager-skill" / script_name,
    ]
    
    script_path = None
    for path in possible_paths:
        if path.exists():
            script_path = path
            break
    
    if not script_path:
        print(f"Error: Could not find {script_name}")
        print(f"Searched in:")
        for path in possible_paths:
            print(f"  - {path}")
        return 1
    
    cmd = ["bash", str(script_path)]
    if args:
        cmd.extend(args)
    
    result = subprocess.run(cmd, cwd=os.getcwd())
    return result.returncode


def get_remote_version():
    """Fetch the latest version from GitHub"""
    try:
        with urlopen(GITHUB_RAW_URL, timeout=10) as response:
            content = response.read().decode('utf-8')
            match = re.search(r'version\s*=\s*["\']([^"\']+)["\']', content)
            if match:
                return match.group(1)
    except URLError as e:
        print(f"Error fetching remote version: {e}")
    except Exception as e:
        print(f"Error: {e}")
    return None


def compare_versions(v1, v2):
    """Compare two version strings. Returns: -1 if v1 < v2, 0 if equal, 1 if v1 > v2"""
    def parse(v):
        return [int(x) for x in v.split('.')]
    p1, p2 = parse(v1), parse(v2)
    for a, b in zip(p1, p2):
        if a < b:
            return -1
        if a > b:
            return 1
    return len(p1) - len(p2)


def cmd_upgrade():
    """Check for updates and upgrade if available"""
    print(f"Current version: {VERSION}")
    print("Checking for updates...")

    remote_version = get_remote_version()
    if not remote_version:
        print("❌ Could not check remote version")
        return 1

    print(f"Remote version: {remote_version}")

    cmp = compare_versions(VERSION, remote_version)
    if cmp >= 0:
        print("✅ Already up to date")
        return 0

    print(f"\n🆕 New version available: {remote_version}")

    # Find the repo directory
    skill_dir = get_skill_dir()
    repo_dir = None

    # Check if we're in the repo or need to find it
    possible_repos = [
        skill_dir.parent.parent / "project-manager-skill",
        Path.home() / "Development" / "01-雅博项目" / "project-manager-skill",
    ]

    for path in possible_repos:
        if (path / ".git").exists():
            repo_dir = path
            break

    if not repo_dir:
        print(f"\n⚠️  Cannot auto-upgrade. Please run manually:")
        print(f"   cd <project-manager-skill-repo>")
        print(f"   git pull && ./install.sh")
        return 1

    print(f"\nUpgrading from {repo_dir}...")

    # Git pull
    result = subprocess.run(
        ["git", "pull", "origin", "main"],
        cwd=repo_dir,
        capture_output=True,
        text=True
    )

    if result.returncode != 0:
        print(f"❌ Git pull failed: {result.stderr}")
        return 1

    print(result.stdout)

    # Run install.sh
    install_script = repo_dir / "install.sh"
    if install_script.exists():
        print("\nRunning install.sh...")
        result = subprocess.run(["bash", str(install_script)], cwd=repo_dir)
        if result.returncode != 0:
            print("❌ Install failed")
            return 1

    print(f"\n✅ Upgraded to version {remote_version}")
    print("")
    print("💡 If you have projects using pm, run 'pm init' in each project")
    print("   to update the slash commands.")
    return 0


def show_usage():
    """Show usage information"""
    print(f"""PM - Project Manager CLI Tool v{VERSION}

Usage: pm <command> [options]

Commands:
  init                    Initialize project structure
  task <action> [args]    Task management
    list                  List all tasks
  status                  Show project status
  upgrade                 Check and install updates
  version                 Show version
  help                    Show this help

Examples:
  pm init
  pm task list
  pm upgrade

For full documentation, see: ~/.claude/skills/project-manager/SKILL.md
Or visit: https://github.com/{GITHUB_REPO}
""")


def main():
    """Main entry point"""
    if len(sys.argv) < 2:
        show_usage()
        return 0
    
    command = sys.argv[1]
    args = sys.argv[2:] if len(sys.argv) > 2 else []
    
    if command == "init":
        return run_bash_script("init-project.sh")
    
    elif command == "task":
        if not args:
            print("Error: task action required")
            print("Available actions: list")
            return 1
        
        action = args[0]
        if action == "list":
            tasks_file = Path(".project-log/tasks/tasks.json")
            if tasks_file.exists():
                print("📋 Tasks")
                try:
                    import json
                    with open(tasks_file) as f:
                        data = json.load(f)
                        for task in data.get("tasks", []):
                            print(f"#{task['id']} [{task['status']}] {task['title']}")
                except Exception as e:
                    print(f"Error reading tasks: {e}")
                    return 1
            else:
                print("Error: Run 'pm init' first")
                return 1
        else:
            print(f"Unknown task action: {action}")
            return 1
    
    elif command == "status":
        if not Path(".project-log").exists():
            print("❌ Not initialized. Run: pm init")
            return 1
        
        print("📊 Project Status\n")
        
        # Count files
        log_count = len(list(Path(".project-log/daily-logs").glob("*.md"))) if Path(".project-log/daily-logs").exists() else 0
        adr_count = len(list(Path(".project-log/decisions").glob("*.md"))) if Path(".project-log/decisions").exists() else 0
        
        print(f"📝 Daily Logs: {log_count}")
        print(f"🏗️  ADRs: {adr_count}")
        
        # Task stats
        tasks_file = Path(".project-log/tasks/tasks.json")
        if tasks_file.exists():
            try:
                import json
                with open(tasks_file) as f:
                    data = json.load(f)
                    total = len(data.get("tasks", []))
                    print(f"✅ Tasks: {total}")
            except:
                pass
        
        return 0
    
    elif command in ("help", "--help", "-h"):
        show_usage()
        return 0

    elif command in ("version", "--version", "-v"):
        print(f"pm version {VERSION}")
        return 0

    elif command == "upgrade":
        return cmd_upgrade()

    else:
        print(f"Unknown command: {command}")
        show_usage()
        return 1


if __name__ == "__main__":
    sys.exit(main())
