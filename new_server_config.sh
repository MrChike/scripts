#!/bin/bash
set -e

sudo apt -y update && sudo apt -y upgrade
sudo apt -y install docker.io && sudo apt install -y docker-compose && sudo usermod -aG docker $USER 
sudo apt -y install python3.10-venv
sudo apt install -y openssh-server && sudo systemctl enable ssh && sudo systemctl start ssh
sudo ufw allow ssh && sudo ufw enable
ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" -C "ssh-key created"

sudo shutdown -r now

hostname -I # Display's host's IP
scp 'file' hostname@hostIP:/path/to/directory/ # Copy's file to host server