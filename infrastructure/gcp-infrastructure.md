# GCP Infrastructure

## Project
- Project ID: project-bc03c6f6-df54-4b54-a7b
- Region: asia-south1
- Zone: asia-south1-a

## Network
- VPC: siem-network
- Subnet: siem-subnet (10.0.1.0/24)

## Virtual Machines
### vm-wazuh
- Internal IP: 10.0.1.2
- External IP: 34.47.252.80
- OS: Ubuntu 22.04
- Purpose: Wazuh Manager + Indexer + Dashboard

### vm-attacker
- Internal IP: 10.0.1.3
- External IP: 8.231.117.238
- OS: Ubuntu 22.04
- Purpose: Wazuh Agent + Atomic Red Team

## Firewall Rules
- siem-allow-internal: all traffic within 10.0.1.0/24
- siem-allow-external: ports 22, 443, 1514, 1515, 5601, 55000
