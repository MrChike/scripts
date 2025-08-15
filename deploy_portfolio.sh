#!/bin/bash

echo " " 
LOG_FILE=~/code/cronjobs/cron_jobs.log

cd ~/code/projects/portfolio

# Use full paths
/usr/bin/git pull >> $LOG_FILE
/usr/bin/python3 -m venv ~/code/projects/portfolio/env

# Activate the virtual environment
source ~/code/projects/portfolio/env/bin/activate

# Use full path to mkdocs
~/code/projects/portfolio/env/bin/mkdocs gh-deploy --remote-name git@github.com:MrChike/portfolio.git --remote-branch gh-pages --force >> $LOG_FILE

echo " " 
echo "/home/mrchike/code/scripts/deploy_portfolio.sh ran @ $(date)" >> $LOG_FILE