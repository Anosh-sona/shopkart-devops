#!/bin/bash
set -e

mkdir -p logs

echo "#################################################"
echo "    WELCOME TO SHOPKART DEVOPS PROJECT          "
echo "#################################################"

#Username
USERNAME=$(whoami)
echo "$USERNAME"
echo "#################################################"

#Hostname
HOSTNAME=$(hostname)
echo "$HOSTNAME"
echo "#################################################"

#Date and time
DATE=$(date)
echo "$DATE"
echo "##################################################"

#Operating system
OS_INFO=$(uname -s)
echo "$OS_INFO"
echo "###################################################"

#Disk usage
DISK_USAGE=$(df -h |awk 'NR==2 {print $6}'| tr -d '%') 
echo "$DISK_USAGE"
 
echo "Time_stamp: $(date)" >> logs/project-info.log
echo "Disk_usage: ${DISK_USAGE}%" >> logs/project-info.log

THRESHOLD=${1:-80}
echo "$THRESHOLD"

if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]]; then
     echo "Invalid Threshold"
     exit 1
fi

if [ "$THRESHOLD" -gt 100 ]; then
    echo "Error: Threshold cannot be greater than 100."
    exit 1
fi

if [ "$DISK_USAGE" -gt "$THRESHOLD" ]; then
  echo "Critical Warning: Disk usage is ${DISK_USAGE}%" >> logs/project-info.log
 elif [ "$DISK_USAGE" -ge 70 ]; then 
  echo "Early warning: Disk usage is ${DISK_USAGE}%" >> logs/project-info.log 
 else 
  echo "Healthy: Disk usage is ${DISK_USAGE}%"  >> logs/project-info.log
fi

echo "Successfully sent to the log files"
echo "######################################################"

echo "##########SYSTEM SUMMARY#########################" | tee -a logs/system-summary.log
echo "Username: $(whoami)" | tee -a logs/system-summary.log
echo "Hostname: $(hostname)" | tee -a logs/system-summary.log
echo "Date: $(date)" | tee -a logs/system-summary.log
echo "Disk Usage: ${DISK_USAGE}%" | tee -a logs/system-summary.log
echo "##################################################" | tee -a logs/system-summary.log
