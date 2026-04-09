#!/bin/bash

# =========================================================
# PROJECT: Vigilante_awar
# DESCRIPTION: Automated Security Monitor & Threat Reporter
# AUTHOR: Anuar Javid Martinez Gomez
# =========================================================

# --- STEP 2: CONFIGURATION ---
# IMPORTANT: Enter your credentials below. 
# DO NOT push your real tokens to public repositories.
TOKEN=""  # Telegram Bot Token
ID=""     # Telegram Chat ID
REPORT_PATH="/home/$(whoami)/Network_report.txt"

# Clear previous report
> "$REPORT_PATH"

echo "SYSTEM MONITORING INITIALIZED..."
echo "Welcome, $(whoami)"
echo "----------------------------------------"

# 1. FIREWALL STATUS CHECK
echo "[+] STAGE 1: CHECKING FIREWALL STATUS"
echo "----------------------------------------"
sudo /usr/sbin/ufw status | tee -a "$REPORT_PATH"

echo "----------------------------------------"

# 2. FAIL2BAN JAIL ANALYSIS
echo "[+] STAGE 2: ANALYZING ACTIVE JAILS (SSHD)"
echo "----------------------------------------"

# Extracting the number of currently banned IPs
BANNED_COUNT=$(sudo /usr/bin/fail2ban-client status sshd | grep -i "currently banned" | awk '{print $4}')
echo "Currently Banned IPs: $BANNED_COUNT"

if [ "$BANNED_COUNT" -gt 0 ] 2>/dev/null; then
    # Extracting the list of IPs and selecting the most recent one for intelligence
    IPS_LIST=$(sudo /usr/bin/fail2ban-client status sshd | grep -i "banned ip list" | awk -F: '{print $2}')
    TARGET_IP=$(echo $IPS_LIST | awk '{print $1}')
    TRACKING_LINK="https://ip-api.com/#$TARGET_IP"
    
    # Telegram Message Construction (HTML Format)
    MSG="<b>🚨 SECURITY ALERT: INTRUSION DETECTED</b>
----------------------------------------
<b>🔢 Total Banned IPs:</b> $BANNED_COUNT
<b>🔎 Latest Target:</b> $TARGET_IP
<b>🌍 Intelligence Link:</b> $TRACKING_LINK
----------------------------------------
<i>Action: Firewall rules updated automatically.</i>"

    # Send Notification to Telegram
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
         -d chat_id="$ID" \
         -d parse_mode="HTML" \
         -d text="$MSG" > /dev/null
         
    echo "(!) ALERT: $BANNED_COUNT intruders detected and contained." | tee -a "$REPORT_PATH"
else
    echo "🛡️  SYSTEM SECURE: No active bans detected." | tee -a "$REPORT_PATH"
fi

echo "----------------------------------------"

# 3. STORAGE & SYSTEM HEALTH
echo "[+] STAGE 3: SYSTEM RESOURCE CHECK"
echo "----------------------------------------"
# Monitor disk usage on physical partitions
df -h | grep '^/dev/' | tee -a "$REPORT_PATH"

echo "----------------------------------------"
echo "REPORT COMPLETED: $(date)"
echo "Summary saved at: $REPORT_PATH"
