#!/bin/bash
DISK_USAGE=$(df -hT | grep -v Filesystem)
DISK_THRESHOLD=2  # in real project keep 75
IP_ADDRESS=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)
MESSAGE=""

while IFS= read -r line
do
    USAGE=$(echo $line | awk '{print $6}' | cut -d "%" -f1)
    PARTITION=$(echo $line | awk '{print $7}')
    if [ $USAGE -ge $DISK_THRESHOLD ]; then
        MESSAGE+="High Disk usage on $PARTITION: $USAGE % <br>"
    fi
done <<< "$DISK_USAGE"

echo -e "Message Body: $MESSAGE"

sh mail.sh "shanmukhathota21@gmail.com" "High Disk Usage Alert" "High Disk Usage" "$MESSAGE" "$IP_ADDRESS" "DevOps Team"