## 🛠️ Project Roadmap: The Migration Lifecycle

### ✅ Phase 1: The Hybrid Bridge (Completed)
*Focused on Co-existence and Governance during the transition period.*

* **Converged State Management:** Simultaneous orchestration of On-Prem (Dockerized PingFederate) and SaaS (PingOne) environments.
* **Identity Vending Factory:** Implemented `for_each` logic to scale from single-app scripts to an Enterprise-grade "Vending Machine."
* **Policy-as-Code (Governance):** Built-in HCL validation for strict naming conventions (`uk-*` prefix) and security guardrails (minimum secret entropy).
* **Metadata Traceability:** Linked cloud groups to legacy on-prem clients using `custom_data` blocks for 100% migration auditability.
* **Modular Architecture:** Abstracted complex IAM logic into a reusable `/modules/iam-vending-machine` directory.

### 🚀 Phase 2: The Migration Cutover (In Progress)
*Focusing on decommissioning legacy infrastructure and shifting the "Point of Truth" to the Cloud.*

* **Boolean Migration Logic:** Implementation of an `is_migrated` flag to automate the "Decommission On-Prem / Provision Cloud" cutover.
* **Dynamic Secret Orchestration:** Moving from static variable inputs to automated, zero-touch secret generation using the HashiCorp `random` provider.
* **Role & Population Sync:** Automating the assignment of `Identity Data Admin` roles and population mapping during the cutover phase.
* **CI/CD Integration:** Moving the local state to a Remote Backend (S3/Terraform Cloud) for collaborative migration workflows.

---

## 🚀 The "Principal Architect" Demo
To demonstrate the power of this framework, a single change in the `app_names` configuration triggers a multi-provider transaction:

1.  **Validation:** Terraform confirms the `client_id` follows UK Governance standards.
2.  **On-Prem:** A new OAuth Client is provisioned in the local PingFederate instance.
3.  **Cloud:** A mirrored Security Group is created in PingOne with a timestamped "Migration Bridge" tag.
4.  **Governance:** The new Cloud Group is automatically assigned administrative roles within its environment.

---

## 📈 Impact
This framework reduces the time to onboard and bridge a new application from **hours of manual GUI configuration** to **seconds of automated HCL execution**, ensuring zero configuration drift across the hybrid identity estate.

---
**Author:** Bilal Mahmood  
*Identity Architect*