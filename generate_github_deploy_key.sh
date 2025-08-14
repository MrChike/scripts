#!/bin/bash

yes | ssh-keygen -t rsa -b 4096 -C "$(whoami)@$(hostname)" -f ~/.ssh/id_deploy -N ""

# Set permissions
chmod 600 ~/.ssh/id_deploy

# Create SSH config
touch ~/.ssh/config

if ! grep -q "Host github.com" ~/.ssh/config 2>/dev/null; then
  cat <<EOF >> ~/.ssh/config

Host github.com
    HostName github.com
    IdentityFile ~/.ssh/id_deploy
    User git
    IdentitiesOnly yes

EOF
else
  echo "Entry for 'Host github.com' already exists in ~/.ssh/config"
fi

echo "------------------------DEPLOY SSH KEY---------------------------------------"
cat ~/.ssh/id_deploy.pub
