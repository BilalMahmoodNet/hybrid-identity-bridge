# 🤖 Multi-Cloud Identity Vending Machine
**Architecting Automated OAuth Lifecycle Management across SaaS (PingOne) and On-Prem (PingFederate)**

---

## 🏛️ Architectural Overview
This framework automates the "Identity Bridge" bottleneck. It provides a standardized, **Policy-as-Code** approach to vending OAuth clients and machine identities across hybrid environments. 

By leveraging **Terraform** and **GitHub Actions**, this project eliminates manual configuration drift and enforces security guardrails at the PR level.

### 🤖 CI/CD & Automated Governance
* **Zero-Artifact Injection:** Uses `TF_VAR_` environment mapping to inject secrets directly into process memory, bypassing insecure disk-based `.tfvars` files.
* **Static Analysis:** Mandatory `terraform validate` and `fmt` checks integrated into the CI pipeline.
* **Plan Transparency:** Automated execution plans generated on every Pull Request for architectural review.
* **Identity Scoping:** Leverages GitHub Environments (`DEV`/`PROD`) for strict credential separation.

---

## ✅ Phase 1: The Hybrid Bridge (Completed)
* **Dual-Provider Orchestration:** Unified state management for **PingFederate** (On-Prem) and **PingOne** (SaaS).
* **Scalable Vending:** Utilizes `for_each` and dynamic blocks to provision diverse client types (Chatbots, Web Portals, Machine-to-Machine).
* **Naming Standards:** Enforces UK-standardized naming conventions and entropy requirements via HCL validation rules.
* **CI/CD Foundation:** Established the "Setup-Init-Plan" workflow for ephemeral GitHub Runners.

## 🚀 Phase 2: Migration & Lifecycle (In Progress)
* **Boolean Cutover Logic:** Implementation of `is_migrated` flags to trigger automated decommissioning of legacy clients during cloud migration.
* **Secrets Orchestration:** Integration with **HashiCorp Vault** for dynamic, short-lived credential rotation.
* **Private Networking:** Configuring **Self-Hosted Runners** to bridge the gap between GitHub Cloud and private-network PingFederate APIs.

---

## 🔑 Prerequisites for Deployment
To run this in your own GitHub Action, configure the following **Environment Secrets**:
| Name | Scope | Description |
| :--- | :--- | :--- |
| `PINGONE_CLIENT_ID` | Variable | Worker App ID for PingOne API access. |
| `PINGONE_CLIENT_SECRET` | Secret | Worker App Secret (Sensitive). |
| `PINGONE_ENVIRONMENT_ID` | Variable | Target PingOne Environment UUID. |
| `PINGFEDERATE_ADMIN_PASSWORD`| Secret | Admin password for the PF Admin API. |
| `CLIENT_CREDENTIALS_SECRET`  | Secret | The secret to be vended to the OAuth clients. |

---

### 🛡️ Security Disclaimer
This repository follows **Zero-Trust** principles. No sensitive credentials or state files are committed to version control. All secrets are managed via GitHub encrypted storage and injected at runtime.

**Author:** Bilal Mahmood  
*Identity Architect*