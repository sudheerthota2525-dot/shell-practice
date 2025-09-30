#!/bin/bash
# Disk Usage Monitoring Script
# Author: Sudheer / DevOps Team

# Threshold (in %). In real project keep it 75
DISK_THRESHOLD=75  

# Get private IP of EC2 instance
IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Get disk usage (excluding header)
DISK_USAGE=$(df -hT | grep -vE '^Filesystem')

MESSAGE=""

# Loop through each line of df output
while IFS= read -r line
do
    USAGE=$(echo $line | awk '{print $6}' | tr -d '%')
    PARTITION=$(echo $line | awk '{print $7}')

    if [ "$USAGE" -ge "$DISK_THRESHOLD" ]; then
        MESSAGE+="High Disk usage on $PARTITION: $USAGE% <br>"
    fi
done <<< "$DISK_USAGE"

# Debug print
echo -e "Message Body: $MESSAGE"

# If message is not empty, send mail
if [ -n "$MESSAGE" ]; then
    sh mail.sh "shanmukhathota21@gmail.com" \
               "High Disk Usage Alert" \
               "High Disk Usage" \
               "$MESSAGE" \
               "$IP_ADDRESS" \
               "DevOps Team"
fi