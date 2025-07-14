import os
import re
import subprocess
from datetime import datetime

# Set your GitHub repository folder path
REPO_PATH = [
    # "/path/to/repo/folder",
    "/home/mrchike/code/scripts",
    "/home/mrchike/code/open_source/cal.com",
    "/home/mrchike/code/open_source/scikit-learn"
]

# Set your GitHub remote URL
GITHUB_URL = [
    # "repo git url",
    "git@github.com:MrChike/automate.git",
    "git@github.com:MrChike/cal.com.git",
    "git@github.com:MrChike/scikit-learn.git"
]

print(f"/home/mrchike/code/scripts/github_auto_commit.py ran @ {datetime.now()}")

def retrieve_current_branch():
    branch_list = subprocess.run(['git', 'branch'], capture_output=True, text=True).stdout.strip()
    pattern = r"\* (\S+)"
    match = re.search(pattern, branch_list)

    if match:
        result = match.group(1).strip()
        return result
    return ""

def is_ahead_of_remote(branch):
    """Check if local branch is ahead of remote"""
    try:
        # Fetch the latest changes from the remote without merging them
        subprocess.run(['git', 'fetch'], check=True)

        # Compare the local branch with the remote (check if there are commits on local not on remote)
        result = subprocess.run(
            ['git', 'log', f'origin/{branch}..{branch}', '--oneline'],
            capture_output=True,
            text=True
        )

        # If there are any commits, it means the local branch is ahead
        if result.stdout.strip():
            return True
        return False
    except subprocess.CalledProcessError as e:
        print(f"Error checking if branch is ahead of remote: {e}")
        return False

def commit_and_push(branch):
    try:
        # Check if there are any changes (uncommitted files)
        status = subprocess.run(['git', 'status', '--porcelain'], capture_output=True, text=True)

        if status.stdout.strip():  # If there are changes
            print(f"Changes detected at {datetime.now()}. Committing and pushing...")

            # Add all changes to staging
            subprocess.run(['git', 'add', '.'], check=True)

            # Commit changes with a timestamp message
            commit_message = f"daily_commit: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}"
            subprocess.run(['git', 'commit', '-m', commit_message], check=True)

        # Check if the branch is ahead of the remote (even if not detected by `git status`)
        if is_ahead_of_remote(branch):
            print(f"Your local branch {branch} is ahead of the remote branch. Pushing changes...")
            # Push changes to GitHub
            subprocess.run(['git', 'push', 'origin', branch], check=True)

            print(f"Changes pushed to GitHub successfully...")
        else:
            print(f"Your local branch {branch} is up to date with the remote or nothing to commit.")
            print("-------------------------------------------------------------------------------")

    except subprocess.CalledProcessError as e:
        print(f"Error during git operations: {e}")

for i in range(len(REPO_PATH)):
    os.chdir(REPO_PATH[i])
    current_path = os.getcwd()
    branch = retrieve_current_branch()
    print(f"Working in repository: {current_path}")
    commit_and_push(branch)
