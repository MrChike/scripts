## Step 1: Edit cron jobs using crontab

```bash
crontab -e

```

Add the below to you crontab file

```bash
# Edit this file to introduce tasks to be run by cron.
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# Format:
#   m h dom mon dow command
# or
#   * h dom  *  dow command
# */30 * * * * /path/to/script --> Where */30 == every 30 minutes
#
# The two cron jobs below:
# Run script at midnight:
#   00 00 * * * /path/to/executable/script_name.extension
#
# Run script at noon:
#   00 12 * * * /path/to/executable/script_name.extension
#
# Real Example Below

# * * * * /usr/bin/python3 /path/to/script.py > /path/to//log_file.log 2>&1

# Executes commands daily at 3am
# 00 03 * * * /usr/bin/python3 ~/code/scripts/github_auto_commit.py > ~/code/cronjobs/cron_jobs.log 2>&1
# 00 03 * * * ~/code/scripts/deploy_portfolio.sh >> ~/code/cronjobs/cron_jobs.log 2>&1

# Executes commands daily at 9am
# 00 09 * * * /usr/bin/python3 ~/code/scripts/github_auto_commit.py > ~/code/cronjobs/cron_jobs.log 2>&1
# 00 09 * * * ~/code/scripts/deploy_portfolio.sh >> ~/code/cronjobs/cron_jobs.log 2>&1

# Executes commands daily at 12pm
# 00 12 * * * /usr/bin/python3 ~/code/scripts/github_auto_commit.py > ~/code/cronjobs/cron_jobs.log 2>&1
# 00 12 * * * ~/code/scripts/deploy_portfolio.sh >> ~/code/cronjobs/cron_jobs.log 2>&1

# Executes commands daily at 3pm
# 00 15 * * * /usr/bin/python3 ~/code/scripts/github_auto_commit.py > ~/code/cronjobs/cron_jobs.log 2>&1
# 00 15 * * * ~/code/scripts/deploy_portfolio.sh >> ~/code/cronjobs/cron_jobs.log 2>&1

# Executes commands daily at 6pm
# 00 18 * * * /usr/bin/python3 ~/code/scripts/github_auto_commit.py > ~/code/cronjobs/cron_jobs.log 2>&1
# 00 18 * * * ~/code/scripts/deploy_portfolio.sh >> ~/code/cronjobs/cron_jobs.log 2>&1

# Executes commands every minute
# * * * * *  ~/code/cronjobs/cron_jobs.sh >> ~/code/cronjobs/cron_jobs.log 2>&1

# Executes commands every 30 minute
# */30 * * * *  ~/code/cronjobs/cron_jobs.sh >> ~/code/cronjobs/cron_jobs.log 2>&1

* * * * * echo "Cron job ran at $(date)" >> ~/cron_jobs.log 2>&1
```

# NB!: You must save and exit before crontab registers changes.

## Step 2: Troubleshoot crontab issues (if any)
If you see the following error when running 'crontab -e', don't worry: This error is often harmless but check to ensure that the crontab file saved correctly.

```bash
E1187: Failed to source defaults.vim
Press ENTER or type command to continue
crontab: installing new crontab
```

## Step 3: Check and update system timezone
Checking your system timezone

```bash
timedatectl

# Example output:
Local time: Sun 2025-07-13 20:41:29 AEST
Universal time: Sun 2025-07-13 10:41:29 UTC
Time zone: Australia/Hobart (AEST, +1000)
```

## Step 4: Update timezone if needed
If your timezone is incorrect, you can update it using the following command:

```bash
# Set timezone
sudo timedatectl set-timezone Africa/Lagos  # Replace with your correct timezone

# Restart cron service after updating timezone
sudo systemctl restart cron
```

## Step 5: Verify cron is in sync with the system time
```bash
grep CRON /var/log/syslog | grep 'script_name.extension'

# Example output:
Jul 13 20:39:01 system-name CRON[44674]: (your-username) CMD (/path/to/executable/script_name.extension)
```

## Step 5: Inspect CRON Logs for debugging 
```bash
grep cron /var/log/syslog > /tmp/cronlog.txt && code /tmp/cronlog.txt

```

# 🎉 Congrats! You've successfully set up your cron automation ✅