#!/bin/bash

LOG_FILE="$HOME/Desktop/project/system_check.log"
DATE=$(date "+%Y-%m-%d %H:%M:%S")

log() {
    echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

separator() {
    echo "--------------------------------------------------" | tee -a "$LOG_FILE"
}

log "Starting system readiness check"
separator

# OS information 
log "Collecting OS information"

if [[ -f /etc/os-release ]]; then
    source /etc/os-release
    log "OS Name    : $NAME"
    log "OS Version : $VERSION"
else
    log "Unable to detect OS version"
fi

separator


# System Uptime
log "System uptime:"
uptime | tee -a "$LOG_FILE"

separator

# Disk Usage Check
log "Checking disk usage"

ROOT_USAGE=$(df -h / | awk 'NR==2 {print $5}')
log "Root (/) usage: $ROOT_USAGE"

case "$ROOT_USAGE" in
    *9[0-9]%)
        log "CRITICAL: Disk usage extremely high"
        ;;
    *8[0-9]%)
        log "WARNING: Disk usage above 80%"
        ;;
    *)
        log "Disk usage within safe limits"
        ;;
esac

separator

# Memory Usage Check
log "Checking memory usage"

free -h | tee -a "$LOG_FILE"

separator


# Network Check
log "Checking network connectivity"

if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
    log "Network reachable"
else
    log "Network unreachable"
fi

separator


# Tool Checks
check_tool() {
    TOOL="$1"

    if command -v "$TOOL" >/dev/null 2>&1; then
        log "Tool '$TOOL' is installed"
    else
        log "Tool '$TOOL' NOT found. Installing..."
        sudo apt update && sudo apt install -y "$TOOL"
    fi
}

log "Checking required tools"
check_tool curl
check_tool git
check_tool htop

separator

log "System readiness check completed"
log "Log file saved at: $LOG_FILE"
separator

exit 0
