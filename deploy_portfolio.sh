#!/bin/bash

LOG_FILE=/home/mrchike/code/cronjobs/cron_jobs.log

cd /home/mrchike/code/projects/portfolio

# Use full paths
/usr/bin/git pull >> $LOG_FILE
/usr/bin/python3 -m venv /home/mrchike/code/cronjobs/env

# Activate the virtual environment
source /home/mrchike/code/cronjobs/env/bin/activate

echo "/home/mrchike/code/scripts/deploy_portfolio.sh ran @ $(date)" >> $LOG_FILE
# Use full path to mkdocs
/home/mrchike/.local/bin/mkdocs gh-deploy >> $LOG_FILE
