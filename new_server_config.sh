#!/bin/bash

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


echo "-------------------------SET UP SERVER--------------------------------------------"

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