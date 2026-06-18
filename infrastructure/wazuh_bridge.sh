#!/bin/bash
# Custom log-forwarding bridge for Wazuh-to-n8n automation
# Tracks live JSON logs and forwards them to the n8n webhook

tail -f /var/ossec/logs/alerts/alerts.json | while read -r line; do
    curl -X POST -H "Content-Type: application/json" -d "$line" http://localhost:5678/webhook/your-webhook-id-here
done
