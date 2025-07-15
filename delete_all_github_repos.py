import requests

# (use environment variables for better security)
# Replace with your GitHub username and PAT 
USERNAME = 'Your GitHub Username'

# Replace with your PAT 
# https://github.com/settings/personal-access-tokens
TOKEN = 'Your GitHub Personal Access Token'

# Get list of repos
response = requests.get(
    'https://api.github.com/user/repos?per_page=100',
    auth=(USERNAME, TOKEN)
)

repos = response.json()

# Loop and delete
for repo in repos:
    repo_name = repo['name']
    delete_url = f"https://api.github.com/repos/{USERNAME}/{repo_name}"
    del_response = requests.delete(delete_url, auth=(USERNAME, TOKEN))
    
    if del_response.status_code == 204:
        print(f"Deleted: {repo_name}")
    else:
        print(f"Failed to delete: {repo_name} - {del_response.status_code}")
