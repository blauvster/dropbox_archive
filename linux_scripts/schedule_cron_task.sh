#!/bin/bash

# Relative path to the target script (relative to the script's directory)
TARGET_SCRIPT="./run.sh"

# Cron schedule (e.g., every day at 2 AM)
CRON_SCHEDULE="0 2 * * *"

# Get the absolute directory of the current script
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Full path to the target script
FULL_TARGET_SCRIPT="$SCRIPT_DIR/$TARGET_SCRIPT"

# Check if the target script exists
if [ ! -f "$FULL_TARGET_SCRIPT" ]; then
  echo "Error: Target script not found at $FULL_TARGET_SCRIPT"
  exit 1
fi

# Ensure the script is executable
chmod +x "$FULL_TARGET_SCRIPT"

# Create the cron job string
CRON_JOB="$CRON_SCHEDULE cd $SCRIPT_DIR && $FULL_TARGET_SCRIPT"

# Get the current crontab
CURRENT_CRONTAB=$(crontab -l 2>/dev/null)

# Remove any existing cron jobs related to the target script
UPDATED_CRONTAB=$(echo "$CURRENT_CRONTAB" | grep -vF "$TARGET_SCRIPT")

# Add the new cron job
UPDATED_CRONTAB="$UPDATED_CRONTAB
$CRON_JOB"

# Apply the updated crontab
echo "$UPDATED_CRONTAB" | crontab -

echo "Cron job replaced or added: $CRON_JOB"
