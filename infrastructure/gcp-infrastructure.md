# GCP Infrastructure

## Project
- Project ID: project-bc03c6f6-df54-4b54-a7b
- Region: asia-south2
- Zone: asia-south2-a

## Network
- VPC: default
- Subnet: default (10.190.0.0/20)

## Virtual Machines
### vm-wazuh
- Internal IP: 10.190.0.2
- External IP: 34.131.229.104
- OS: Ubuntu 22.04
- Purpose: Wazuh Manager + Indexer + Dashboard

### vm-attacker
- Internal IP: 10.190.0.3
- External IP: 34.131.26.46
- OS: Ubuntu 22.04
- Purpose: Wazuh Agent + n8n + Groq AI

## Firewall Rules
- siem-allow-external-default: ports 22, 443, 1514, 1515, 5601, 55000
