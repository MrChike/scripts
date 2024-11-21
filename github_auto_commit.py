import os
import re
import subprocess
from datetime import datetime

# Set your GitHub repository path and GitHub remote URL
REPO_PATH = [
    "/home/mrchike/code/features/Leetcode", 
    "/home/mrchike/code/features/next13-lms-platform", 
    "/home/mrchike/code/features/next13-lms-platform-api",
    "/home/mrchike/code/projects_contributions/chikeegonu",
    "/home/mrchike/code/projects_contributions/tensorflow",
    "/home/mrchike/code/scripts"
]

GITHUB_URL = [
    "git@github.com:MrChike/Leetcode.git",
    "git@github.com:MrChike/LMS.git",
    "git@github.com:MrChike/LMS-API.git",
    "git@github.com:MrChike/chikeegonu.git",
    "git@github.com:MrChike/tensorflow.git",
    "git@github.com:MrChike/automate.git"
]

def retrieve_current_branch():
    branch_list = subprocess.run(['git', 'branch'], capture_output=True, text=True).stdout.strip()
    pattern = r"\* (\S+)"
    match = re.search(pattern, branch_list)

    if match:
        result = match.group(1).strip()
        return result

    return ""

def commit_and_push(branch):
    try:
        # Check if there are any changes (uncommitted files)
        status = subprocess.run(['git', 'status', '--porcelain'], capture_output=True, text=True)

        if status.stdout.strip():  # If there are changes
            print(f"Changes detected at {datetime.now()}. Committing and pushing...")

            # Add all changes to staging
            subprocess.run(['git', 'add', '.'], check=True)
            print('branch', branch)

            # Commit changes with a timestamp message
            commit_message = f"Automated commit: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
            subprocess.run(['git', 'commit', '-m', commit_message], check=True)

            # Push changes to GitHub
            subprocess.run(['git', 'push', 'origin', branch], check=True)

            print(f"Changes pushed to GitHub successfully...")
        else:
            print(f"No changes detected at {datetime.now()}. Nothing to commit.")
    except subprocess.CalledProcessError as e:
        print(f"Error during git operations: {e}")

# Run the commit and push function

print(len(REPO_PATH))
for i in range(len(REPO_PATH)):
    print('i', i)
    os.chdir(REPO_PATH[i])
    current_path = os.getcwd()
    branch = retrieve_current_branch()
    print(current_path)
    commit_and_push(branch)
