#!/bin/bash

echo "-------------------------SET UP LINUX SERVER--------------------------------------------"

# Exit immediately if a command exits with a non-zero status
set -e

# Update package lists and upgrade existing packages
sudo apt update && sudo apt upgrade -y

# Install Docker, Docker Compose, and add current user to docker group for non-root access
sudo apt install -y docker.io docker-compose openssh-server
sudo usermod -aG docker $USER 

# Install useful dependencies
sudo apt install -y tree vim ufw

# Enable/start the SSH service
sudo systemctl enable ssh
sudo systemctl start ssh

# Allow SSH through the firewall and enable UFW (Uncomplicated Firewall)
sudo ufw allow ssh
sudo ufw enable

# Generate a new RSA SSH key pair with no passphrase and a comment for identification
yes | ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" -C "ssh-key"

# Scaffold Project Directory Structure
mkdir ~/code
cd ~/code && mkdir -p cronjobs/playground education open_source projects scripts && touch cronjobs/cron_jobs.log cronjobs/cron_jobs.sh projects/Journal.md 
cd ~/code/cronjobs && chmod +x cron_jobs.log cron_jobs.sh

echo 'export EDITOR=vim' >> ~/.bashrc

# Create Journal.md
cat <<'EOF' > ~/code/Journal.md
# 📝 Journal

## 🧭 Table of Contents
- ✅ [TODO](#todo)
- 🧠 [Notes & Learnings](#notes--learnings)
- 🔗 [Resource Findings](#resource-findings)
- 💻 [Commands](#commands)
- 🐞 [Error Logs & Fixes](#error-logs--fixes)

## ✅ TODO
- Placeholder Task (Start-End ⟶ Duration) • Date
- Refactored core module for clarity (00:00-00:00 ⟶ 24Hrs) • 01-01-1900
- Conclude MKDocs Portfolio Setup (03:00-07:00 ⟶ 4Hrs) • 17-07-2025 ✅

---
### 📅 17-07-2025

- **Progress:** Conclude MKDocs Portfolio Setup
- **Focus:** Improve Online Visibility
- **Blockers:** Github Actions Setup
- **Next:** [TO BE UPDATED]

---
### 📅 01-01-1900

- **Progress:** Refactored core module for clarity
- **Focus:** Improve maintainability
- **Blockers:** Unclear API docs slowed down integration  
- **Next:** Conclude MKDocs Portfolio Setup

---

## 🧠 Notes and Learnings
- Markdown supports collapsible sections using `<details>`
- Use `kill -9 $(lsof -t -i:<port>)` to free up ports

---

## 🔗 Resource Findings
- [ChatGPT](https://chatgpt.com/)

---

<details>
<summary>💻 Commands</summary>

\`\`\`bash
# List all files including hidden ones
ls -la

# Print current directory file structure
tree -L 1
\`\`\`

</details>

---

<details>
<summary>🐞 Error Logs & Fixes</summary>

\`\`\`bash
# Error: ModuleNotFoundError: No module named 'requests'
# Fix:
pip install requests

# Error: EADDRINUSE: address already in use
# Fix:
kill -9 \$(lsof -t -i:3000)
\`\`\`

</details>
EOF

# Generate SSH keys
yes | ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_ccr -N ""
yes | ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_mrc -N ""

# Set permissions
chmod 600 ~/.ssh/id_ccr
chmod 600 ~/.ssh/id_mrc

# Create SSH config
touch ~/.ssh/config

cat <<EOF > ~/.ssh/config
Host github-ccr
    HostName github.com
    IdentityFile ~/.ssh/id_ccr
    User git
    IdentitiesOnly yes

Host github-mrc
    HostName github.com
    IdentityFile ~/.ssh/id_mrc
    User git
    IdentitiesOnly yes
EOF


echo "------------------------MRC SSH KEY---------------------------------------"
cat ~/.ssh/id_mrc.pub

echo "------------------------CCR SSH KEY---------------------------------------"
cat ~/.ssh/id_ccr.pub

echo "--------------------------------------------------------------------------"
echo "👉 REGISTER YOUR SSH-KEY FOR USER-WIDE OR REPO-SPECIFIC ACCESS ON GITHUB"

# Reboot the system to apply changes such as docker group membership
sudo shutdown -r now

# (Post-reboot commands, to be run manually or scripted after reboot)

# Display the system’s IP address on the network
hostname -I

# Securely copy a file to a remote server via SSH (replace placeholders with actual values)
scp 'file' hostname@hostIP:/path/to/directory/


echo "-------------------------SET UP WSL ON WINDOWS--------------------------------------------"
# Remove wsl distro on windows
wsl --unregister Ubuntu-22.04

$ wsl --list --online # list all distros on windows
The following is a list of valid distributions that can be installed.
Install using 'wsl.exe --install <Distro>'.

NAME                            FRIENDLY NAME
AlmaLinux-8                     AlmaLinux OS 8
AlmaLinux-9                     AlmaLinux OS 9
AlmaLinux-Kitten-10             AlmaLinux OS Kitten 10
AlmaLinux-10                    AlmaLinux OS 10
Debian                          Debian GNU/Linux
FedoraLinux-42                  Fedora Linux 42
SUSE-Linux-Enterprise-15-SP6    SUSE Linux Enterprise 15 SP6
SUSE-Linux-Enterprise-15-SP7    SUSE Linux Enterprise 15 SP7
Ubuntu                          Ubuntu
Ubuntu-24.04                    Ubuntu 24.04 LTS
archlinux                       Arch Linux
kali-linux                      Kali Linux Rolling
openSUSE-Tumbleweed             openSUSE Tumbleweed
openSUSE-Leap-15.6              openSUSE Leap 15.6
Ubuntu-18.04                    Ubuntu 18.04 LTS
Ubuntu-20.04                    Ubuntu 20.04 LTS
Ubuntu-22.04                    Ubuntu 22.04 LTS
OracleLinux_7_9                 Oracle Linux 7.9
OracleLinux_8_10                Oracle Linux 8.10
OracleLinux_9_5                 Oracle Linux 9.5

wsl --install <Distro> # Install Distro
wsl -d <Distro> # Launch/Start Distro