# 🚨 AI-Driven SOAR Platform for Automated Incident Triage

An enterprise-grade, cloud-native **SOAR (Security Orchestration, Automation, and Response)** platform that orchestrates real-time log ingestion, filters alert noise via dynamic custom logic gates, enriches threat intelligence data, and leverages Generative AI to deliver automated triage briefings.

**Developer:** Puneesh Gulati  
**University Registration ID:** 23BCI0168  
**Institution:** VIT Vellore University  

---

## 🏗️ System Architecture & Data Flow

* **Centralized SIEM Hub (`vm-wazuh`):** Deployed on Google Cloud Platform to aggregate real-time terminal inputs, authentication logs, and endpoint telemetry.
* **Log Ingestion Daemon (`wazuh_bridge.sh`):** A custom Linux background daemon monitoring local JSON outputs (`alerts.json`) and streaming payloads forward to orchestration endpoints.
* **Orchestration Core (n8n Engine):** Evaluates stream metadata dynamically using structural switch blocks (`{{ $json["rule"]["level"] }}`) to manage alert fatigue.
* **Threat Intelligence (AbuseIPDB API):** Uses dynamic regex fallback variables to capture target IPs and fetch real-time global threat reputation metrics.
* **Gen-AI Triage Engine (Llama-3 via Groq):** Ingests raw security telemetry to compile operational threat briefs and actionable step-by-step mitigation playbooks in <3 seconds.
* **Secure Enterprise Dispatch (Gmail API):** Implements a secure GCP OAuth 2.0 cryptographic token loop to route styled HTML incident alerts straight to mobile device endpoints.

---

## 📁 Repository Directory Layout

```text
ai-soc-platform/
├── README.md                  <-- Platform documentation and architectural brief
├── n8n-workflows/
│   └── wazuh_ai_soar.json     <-- Exported production n8n automation pipeline
└── infrastructure/
    ├── wazuh_bridge.sh        <-- Continuous stream log-forwarding engine
    └── wazuh-n8n-bridge.service <-- Linux systemd background daemon configuration
