## Bash auto copy file to each machine

#!/bin/bash

# === CONFIGURATION ===
FILE_TO_COPY="autoaddsubdomain.sh"
REMOTE_DIR="/home/first-project/"
INVENTORY="scp-inventory.ini"

# Ensure file exists
if [ ! -f "$FILE_TO_COPY" ]; then
    echo "❌ File $FILE_TO_COPY not found!"
    exit 1
fi

# Function to copy file to each host in a group
copy_to_group() {
    GROUP=$1
    echo "📤 Copying $FILE_TO_COPY to group [$GROUP]..."

    # Extract ansible_host (IP) and ansible_user for each host
    awk -v grp="[$GROUP]" '
        $0==grp {ingrp=1; next}
        /^\[/ {ingrp=0}
        ingrp && NF>0 {
            ip=""; user="first-project"
            for(i=1;i<=NF;i++){
                if($i ~ /^ansible_host=/){split($i,a,"="); ip=a[2]}
                if($i ~ /^ansible_user=/){split($i,a,"="); user=a[2]}
            }
            if(ip=="") ip=$1
            print user "@" ip
        }
    ' "$INVENTORY" | while read TARGET; do
        echo "   -> $TARGET"
        ssh "$TARGET" "mkdir -p $REMOTE_DIR"
        scp "$FILE_TO_COPY" "$TARGET:$REMOTE_DIR"
    done
}

# === RUN ===
copy_to_group "jenkins"
copy_to_group "sonarqube"
copy_to_group "nexus"

echo "✅ $FILE_TO_COPY copied to all servers!"