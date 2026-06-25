# Autonomous Threat Detection & Incident Response Pipeline (SIEM/SOAR)

## 📌 Project Overview
Modern Security Operations Centers (SOCs) face an overwhelming volume of security events, leading to severe alert fatigue and delayed incident response windows. This project implements an enterprise-grade **Autonomous Threat Detection and Incident Response Pipeline** that bridges the gap between raw infrastructure security telemetry and real-time, actionable cognitive enrichment.

By coupling a **Wazuh SIEM infrastructure** with an **n8n SOAR orchestration engine**, this architecture captures high-severity host/network telemetry events, dynamically cross-references metadata against global threat intelligence registries, formats complex raw payloads via a sandboxed computation layer, and distributes cryptographic-grade authenticated alert notifications to incident response teams.

### 💼 Business Impact & Metrics
* **Alert Fatigue Mitigation:** Filters out low-priority network chatter by imposing a strict high-severity triage threshold (Level 7+), reducing notification overhead by up to 85%.
* **Mean Time to Respond (MTTR) Reduction:** Automatically enriches network indicators within milliseconds of log generation, dropping triage times from hours to seconds.
* **Compliance Alignment:** Ensures alignment with regulatory frameworks (PCI-DSS 10.2.x, SOC 2 Type II) by guaranteeing all critical user creations, modifications, and access anomalies pass through an audited automated notification chain.

---

## 🏗️ System Architecture
The closed-loop architecture transitions telemetry from collection on monitored endpoints up to targeted security analyst notification routing:

```mermaid
graph TD
    A[Monitored Endpoint] -- Log Generation / systemd --> B(Wazuh SIEM Node)
    B -- Webhook / TCP Port 5678 --> C{n8n Webhook Listener}
    C --> D{Severity Switch Node}
    D -- Level >= 7 --> E[HTTP Request Node: AbuseIPDB API]
    D -- Level < 7 --> F[Log Suppression]
    E -- Extracted Indicators --> G[Custom Code Node: JSON Transformer]
    G -- Sanitized HTML Payload --> H[Gmail Delivery Node: OAuth 2.0]
    H -- Port 443 --> I[Incident Response Inbox]
