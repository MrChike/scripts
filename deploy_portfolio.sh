#!/bin/bash

LOG_FILE=/home/mrchike/code/cronjobs/cron_env.log
# Log the current date and time to the log file (overwrites previous content)
echo "Cron job ran at $(date)" > $LOG_FILE

# Change to the project directory where your portfolio code is located
cd /home/mrchike/code/projects/portfolio

# Pull the latest changes from the Git repository
git pull >> $LOG_FILE

# Create (or recreate) a virtual environment at the specified path
python3 -m venv /home/mrchike/code/cronjobs/env

# Activate the virtual environment
source /home/mrchike/code/cronjobs/env/bin/activate

# Log the current working directory into the log file (useful for debugging)
pwd >> $LOG_FILE

# Deploy the site using MkDocs and log both output and errors
mkdocs gh-deploy >> $LOG_FILE 2>&1
