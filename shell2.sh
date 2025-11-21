#!/bin/bash
# ============================================================
# Script Name : monitor_system.sh
# Purpose     : Log CPU and memory usage to a file at regular
#               intervals.
# Author      : Apurvam Arya
# Date        : 2025-11-20
# Usage       : ./monitor_system.sh <interval_seconds> <log_file>
# Example     : ./monitor_system.sh 5 system_usage.log
# ============================================================

# Exit on error
set -e

# ----------- Input Validation --------------------------------

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <interval_seconds> <log_file>"
    exit 1
fi

INTERVAL_SECONDS="$1"
LOG_FILE="$2"

# Check if interval is a positive integer
if ! [[ "$INTERVAL_SECONDS" =~ ^[0-9]+$ ]] || [ "$INTERVAL_SECONDS" -le 0 ]; then
    echo "Error: Interval must be a positive integer (in seconds)."
    exit 1
fi

# Create the log file if it doesn't exist
touch "$LOG_FILE"

echo "Logging CPU and memory usage every $INTERVAL_SECONDS seconds..."
echo "Log file: $LOG_FILE"
echo "Press Ctrl+C to stop."

# ----------- Monitoring Loop ---------------------------------

while true; do
    # Current timestamp
    CURRENT_TIME="$(date +'%Y-%m-%d %H:%M:%S')"

    # Get CPU usage using 'top' (user + system)
    # 'top -bn1' -> batch mode, one iteration
    # grep 'Cpu(s)' to find CPU line
    # awk to calculate total active CPU usage (user + system)
    CPU_USAGE="$(top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}')"

    # Get memory usage using 'free -m'
    # NR==2 refers to the second line with physical memory stats
    # $3 used, $2 total -> (used/total)*100
    MEM_USAGE="$(free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }')"

    # Append formatted line to log file
    echo "$CURRENT_TIME | CPU: ${CPU_USAGE}% | MEM: ${MEM_USAGE}%" >> "$LOG_FILE"

    # Wait for the specified interval before next measurement
    sleep "$INTERVAL_SECONDS"
done
