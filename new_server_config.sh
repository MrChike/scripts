#!/bin/bash

echo "-------------------------SET UP LINUX SERVER--------------------------------------------"

# Exit immediately if a command exits with a non-zero status
set -e

# Update package lists and upgrade existing packages
sudo apt -y update && sudo apt -y upgrade

# Install Docker, Docker Compose, and add current user to docker group for non-root access
sudo apt -y install docker.io
sudo apt install -y docker-compose
sudo usermod -aG docker $USER 

# Install useful dependencies
sudo apt -y install tree
sudo apt -y install vim

# Install Python 3.10 virtual environment package
sudo apt -y install python3.10-venv

# Install pip for Python 3
sudo apt -y install python3-pip

# Install OpenSSH server and enable/start the SSH service
sudo apt -y install openssh-server
sudo systemctl enable ssh
sudo systemctl start ssh

# Allow SSH through the firewall and enable UFW (Uncomplicated Firewall)
sudo ufw allow ssh
sudo ufw enable

# Generate a new RSA SSH key pair with no passphrase and a comment for identification
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" -C "ssh-key"

# Scaffold Project Directory Structure
mkdir ~/code
cd ~/code && mkdir -p cronjobs/playground education open_source projects scripts && touch cronjobs/cron_jobs.log cronjobs/cron_jobs.sh projects/Journal.md 
cd ~/code/cronjobs && chmod +x cron_jobs.log cron_jobs.sh

echo 'export EDITOR=vim' >> ~/.bashrc

cat <<EOF > ~/code/projects/Journal.md
# 📝 Journal

## TODO
- Placeholder for future tasks

## Commands

```bash

```

## Error Logs & Fixes

```bash

```

## Resource Findings
- https://

EOF

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