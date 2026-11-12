# Glossary

Acronyms and terms used throughout this lab guide. Bookmark or keep this tab
open - new terms appear across almost every step.

| Term | What it means |
|---|---|
| NaC | Network as Code - Cisco's Terraform-based declarative automation framework. This lab covers two flavors of it: Meraki and IOS XE. |
| IaC | Infrastructure as Code - the broader category of "manage infrastructure by editing files, not clicking buttons." Network as Code is IaC for networking. |
| YAML | A human-readable data format (indentation-based). All your Network as Code "intent" files are YAML. |
| YANG | A standardized modeling language for network device configuration and state. IOS XE's configuration surface is described in YANG modules; the IOS XE track of Network as Code ultimately produces YANG data to push to devices. Not used by the Meraki track. |
| NETCONF | A standards-based network management protocol (RFC 6241). Runs over SSH on TCP/830. Uses YANG models and a candidate/running datastore pair - the IOS XE track uses it for all configuration push. The Meraki track uses the Dashboard's REST API instead. |
| Terraform | HashiCorp's declarative infrastructure engine. Reads `.tf` files + state, produces a plan, applies it. This lab uses Terraform as the orchestrator under Network as Code, for both tracks. |
| HCL | HashiCorp Configuration Language - the syntax `.tf` files are written in (braces, key = value). You'll write very little of this directly; the Network as Code modules abstract it. |
| CML | Cisco Modeling Labs - the virtualized network simulation platform that hosts the lab's IOS XE devices. |
| ACL | Access Control List - used in the IOS XE device-group step. |
| CI/CD | Continuous Integration / Continuous Deployment - the automation that runs your code/config through build/test/deploy stages on every change. This lab uses GitLab CI. |
| GitOps | The practice of using Git as the source of truth for infrastructure state, with CI/CD as the delivery mechanism. The "Applying" steps at the end of each part demonstrate it. |
| MR / PR | Merge Request (GitLab) / Pull Request (GitHub) - the code-review workflow for proposing a change to a branch. This lab's GitLab CI/CD pipeline runs different stages depending on whether a push is to an MR or to `main`. |
| WSL | Windows Subsystem for Linux - the Linux environment running inside the lab's Windows jump machine, where you'll run Terraform. |
| Declarative vs imperative | Declarative: describe what you want (e.g. "VLAN 10 exists with name DATA"). Imperative: describe the steps (`vlan 10`, `name DATA`). Network as Code is declarative - you describe state, the module figures out the steps. |
| candidate / running | NETCONF's two main datastores (IOS XE track only). Changes go to candidate, and a commit applies them to running (live config). |
| BYOA | Bring Your Own Account - the model used for Meraki Dashboard access in this lab: you use your own Dashboard account and API key, shared one organization per two participants. See [Lab access](Intro01_overview.md#lab-access-byoa-model). |
| dCloud | Cisco's demo / lab cloud environment - where this lab is hosted. |

---

**← Back to:** [Overview](Intro01_overview.md)
