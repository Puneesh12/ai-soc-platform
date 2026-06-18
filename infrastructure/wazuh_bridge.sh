#!/bin/bash
# ==============================================================================
# Wazuh SIEM to n8n SOAR Platform Log Ingestion Bridge
# Developer: Puneesh Gulati (Reg No: 23BCI0168)
# Institution: VIT Vellore
# ==============================================================================

# Path to the live enterprise alert telemetry log buffer
ALERTS_LOG="/var/ossec/logs/alerts/alerts.json"

# High-speed remote cloud orchestration endpoint hook
N8N_WEBHOOK_URL="http://34.131.26.46:5678/webhook/wazuh-alerts-ingest"

echo "[*] Initializing automated log-ingestion engine monitoring pipeline..."

# Continuously tail log data buffers and transmit high-severity events
tail -f "$ALERTS_LOG" | while read -r alert_line; do
    # Pipe the raw JSON log line payload straight to the cloud SOAR hook via HTTP POST
    curl -s -X POST \
         -H "Content-Type: application/json" \
         -d "$alert_line" \
         "$N8N_WEBHOOK_URL" > /dev/null
done
