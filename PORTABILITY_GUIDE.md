# Threat Orchestration Loop — Portability & Re-Execution Guide

This document provides a step-by-step procedure to replicate and deploy the complete threat orchestration pipeline inside a controlled laboratory environment or sandbox.

The workflow consists of:

* **Wazuh** — Security event monitoring and alert generation
* **n8n** — SOAR automation and workflow orchestration
* **AbuseIPDB** — Threat intelligence enrichment
* **Gmail API (OAuth 2.0)** — Automated alert notification delivery

---

# 1. Configure Wazuh Webhook Forwarding Integration

The Wazuh Manager must be configured to forward high-severity security alerts to the n8n webhook endpoint.

## 1.1 Connect to Wazuh Manager

SSH into the Wazuh Manager node:

```bash
ssh <username>@<wazuh-manager-ip>
```

---

## 1.2 Modify Wazuh Configuration

Open the configuration file:

```bash
sudo nano /var/ossec/etc/ossec.conf
```

Locate the `<ossec_config>` section and add the following integration block before the closing tag:

```xml
<integration>
  <name>custom-webhook</name>
  <hook_url>http://<YOUR_N8N_INSTANCE_IP>:5678/webhook/wazuh-alerts-receiver</hook_url>
  <level>7</level>
  <alert_format>json</alert_format>
</integration>
```

Replace:

```
<YOUR_N8N_INSTANCE_IP>
```

with the IP address or hostname where n8n is deployed.

---

## 1.3 Validate Configuration

Run:

```bash
sudo /var/ossec/bin/wazuh-logtest-k
```

If the configuration is valid, restart the Wazuh Manager service:

```bash
sudo systemctl restart wazuh-manager
```

Wazuh will now forward matching alerts to the n8n automation workflow.

---

# 2. Import n8n SOAR Workflow Template

## 2.1 Open n8n Dashboard

Access your n8n instance:

```
http://<YOUR_N8N_INSTANCE_IP>:5678
```

Login to the workspace.

---

## 2.2 Import Workflow

Navigate:

```
Workflows
   → New Workflow
   → Menu (...)
   → Import from File
```

Select:

```
n8n_workflow_template.json
```

from the project repository.

---

## 2.3 Workflow Components

The imported workflow contains:

* Webhook trigger node
* Alert severity filtering logic
* Threat intelligence API lookup
* JavaScript processing node
* Gmail notification node

---

# 3. Configure Sandbox Credentials

## 3.1 AbuseIPDB API Configuration

The workflow uses AbuseIPDB to check the reputation of suspicious IP addresses.

Inside n8n:

```
AbuseIPDB HTTP Node
        ↓
Credentials
        ↓
Create New Credential
```

Select:

```
Header Auth
```

Configure:

| Parameter   | Value               |
| ----------- | ------------------- |
| Name        | Key                 |
| Header Name | Key                 |
| Value       | AbuseIPDB API Token |

Example:

```
Header Name:
Key

Value:
YOUR_ABUSEIPDB_API_TOKEN
```

The API token will be passed through the `Key` request header.

---

# 3.2 Gmail OAuth 2.0 Configuration

The notification system uses Gmail API authentication through OAuth 2.0.

## Create Google Cloud Project

Open Google Cloud Console and create a new project.

Example:

```
SOAR-Lab-Project
```

---

## Enable Gmail API

Navigate:

```
APIs & Services
        ↓
Library
        ↓
Search Gmail API
        ↓
Enable
```

---

## Configure OAuth Consent Screen

Navigate:

```
OAuth Consent Screen
```

Set:

```
User Type:
External
```

Add required application details.

Add the Gmail send permission scope:

```
https://www.googleapis.com/auth/gmail.send
```

Save the configuration.

---

## Create OAuth Client

Navigate:

```
Credentials
        ↓
Create Credentials
        ↓
OAuth Client ID
```

Select:

```
Application Type:
Web Application
```

---

## Configure Redirect URI

Copy the OAuth redirect URI provided by the n8n Gmail credential setup.

Example:

```
http://localhost:5678/rest/oauth2-credential/callback
```

Add it under:

```
Authorized Redirect URIs
```

Generate:

* Client ID
* Client Secret

---

## Connect Gmail Credential in n8n

Inside n8n:

```
Gmail Node
       ↓
Create Credential
       ↓
OAuth2
```

Enter:

```
Client ID
Client Secret
```

Complete authentication using:

```
Sign in with Google
```

---

# 4. Validate Pipeline Execution

## 4.1 Webhook Simulation Test

Send a test security alert payload:

```bash
curl -X POST \
http://<YOUR_N8N_INSTANCE_IP>:5678/webhook/wazuh-alerts-receiver \
-H "Content-Type: application/json" \
-d '
{
 "rule":{
   "id":"5710",
   "level":10,
   "description":"sshd: Brute force attack simulation"
 },
 "agent":{
   "name":"vm-sandbox-attacker"
 },
 "data":{
   "srcip":"8.8.8.8"
 }
}'
```

Expected execution flow:

```
Webhook Trigger
        ↓
Alert Severity Validation
        ↓
Source IP Extraction
        ↓
AbuseIPDB Reputation Check
        ↓
Risk Calculation
        ↓
Email Notification
```

---

# 4.2 Live Endpoint Detection Test

Generate a controlled user creation event:

```bash
sudo useradd -m -s /bin/bash sandbox_hacker_test
```

Add user to sudo group:

```bash
sudo usermod -aG sudo sandbox_hacker_test
```

Expected detection chain:

```
Endpoint Activity
        ↓
Wazuh Agent
        ↓
Wazuh Manager
        ↓
Webhook Forwarding
        ↓
n8n SOAR Workflow
        ↓
Threat Intelligence Enrichment
        ↓
Automated Notification
```

---

# Deployment Verification Checklist

| Component                           | Status    |
| ----------------------------------- | --------- |
| Wazuh webhook integration           | Completed |
| n8n workflow imported               | Completed |
| AbuseIPDB authentication configured | Completed |
| Gmail OAuth configured              | Completed |
| Webhook simulation tested           | Completed |
| Live detection tested               | Completed |

---

# Repository Setup

Navigate to the project directory:

```bash
cd ai-soc-platform
```

Create the documentation file:

```bash
nano PORTABILITY_GUIDE.md
```

Paste this content.

Save:

```
CTRL + O
ENTER
CTRL + X
```

The SOAR pipeline is now ready to be replicated inside a controlled sandbox environment.

