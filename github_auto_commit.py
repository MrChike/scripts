import os
import re
import subprocess
from datetime import datetime

# Set your GitHub repository folder path
REPO_PATH = [
    # "/path/to/repo/folder", 
    "/home/mrchike/code/features/Leetcode", 
    "/home/mrchike/code/features/next13-lms-platform", 
    "/home/mrchike/code/features/next13-lms-platform-api",
    "/home/mrchike/code/projects_contributions/chikeegonu",
    "/home/mrchike/code/projects_contributions/tensorflow",
    "/home/mrchike/code/scripts"
]

# Set your GitHub remote URL
GITHUB_URL = [
    # "repo git url", 
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
        print('status', status)

        if "Your branch is ahead of" in status.stdout:
            print(f"merge_detect_commit {datetime.now()}. Pushing changes...")

            subprocess.run(['git', 'push', 'origin', branch], check=True)
            print(f"Branch Merge pushed to GitHub successfully...")

        if status.stdout.strip():  # If there are changes
            print(f"Changes detected at {datetime.now()}. Committing and pushing...")

            # Add all changes to staging
            subprocess.run(['git', 'add', '.'], check=True)

            # Commit changes with a timestamp message
            commit_message = f"daily_commit: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
            subprocess.run(['git', 'commit', '-m', commit_message], check=True)

            # Push changes to GitHub
            subprocess.run(['git', 'push', 'origin', branch], check=True)

            print(f"Changes pushed to GitHub successfully...")
        else:
            print(f"No changes detected at {datetime.now()}. Nothing to commit.")
    except subprocess.CalledProcessError as e:
        print(f"Error during git operations: {e}")


for i in range(len(REPO_PATH)):
    os.chdir(REPO_PATH[i])
    current_path = os.getcwd()
    branch = retrieve_current_branch()
    print(current_path)
    commit_and_push(branch)

