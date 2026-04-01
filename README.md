# CyberWomen Systems Architecture - Active Directory Identity & Access Management Lab
> Designing the Technical "Brain" for a Training & Mentorship Ecosystem

---

## Table of Contents

- [Project Vision](#project-vision)
- [Architectural Structure](#architectural-structure)
  - [Identity Segregation (OUs)](#identity-segregation-ous)
  - [Role-Based Access Control (RBAC)](#role-based-access-control-rbac)
  - [Delegated Administration & Least-Privilege](#delegated-administration--least-privilege)
  - [Automation Pipeline](#automation-pipeline)
- [Technologies & Tools](#technologies--tools)
- [Core Skills Demonstrated](#core-skills-demonstrated)
- [Troubleshooting & Lab Notes](#troubleshooting--lab-notes)
  - [VirtualBox Boot Priority](#virtualbox-boot-priority)
  - [Kerberos Time Drift](#kerberos-time-drift)
  - [RSAT DNS Resolution](#rsat-dns-resolution)
  - [Guest Additions & Shared Folders](#guest-additions--shared-folders)
- [Portfolio & Future Vision](#portfolio--future-vision)

---

## Project Vision

This project is the **foundational blueprint** for a future organization dedicated to **breaking female graduates into cybersecurity**.  

The goal is to **design a centralized management system** that automates the relationships between:

- **Students**: Onboarded and tracked through intake-based Cohorts (2026, 2027, etc.)
- **Mentors**: Assigned oversight roles via group-based access
- **Resources**: Labs, software, and data gated by specialized Program Tracks (Red-Team, Blue-Team, GRC)

> This isn’t just an Active Directory lab — it is a **scalable enterprise workflow** for a mission-driven organization.

---

## Architectural Structure

The AD lab acts as the organization’s **central "source of truth"**:

### Identity Segregation (OUs)

- Hierarchical OU design for **student lifecycle management**:
  - `CyberWomen-Users` (Created Manually)
    - `Students`
      - `Cohort-2026`
      - `Cohort-2027`
      - `Alumni`
    - `Groups`
      - `GG-Students_All`
      - `GG-Cohort-2026`
      - `GG-Cohort-2027`
      - `GG-Mentors`
      - `GG-Helpdesk-Tier2`
  - `Cybersecurity-Programs` (Red-Team, Blue-Team, GRC - Created Manually)
    - `Red-Team`
    - `Blue-Team`
    - `GRC`
    - `Groups`
      - `GG-Blue-Team` 
      - `GG-Red-Team`
      - `GG-GRC`
  - `Admin-Accounts` (Created Manually)
    - `x`
    - `y`
    - `z`
  - `Managed-Computers` (Created Manually)
    - `a`
    - `b`
    - `c`
    
    

<!-- Screenshot: OU structure diagram -->
![OU Structure](screenshots/top-level-ous-creation.png)

> **Note:** Manual creation was done to understand enterprise design before applying automation.

---

### Role-Based Access Control (RBAC)

- Security groups act as **keys for access to resources**:
  - Cohort groups: `GG-Cohort-2026`, `GG-Cohort-2027`
  - Program tracks: `GG-Blue-Team`, `GG-Red-Team`, `GG-GRC`

> RBAC ensures students only access relevant learning materials while keeping sensitive resources secure.

<!-- Screenshot: Group membership example -->
![Group Assignment](screenshots/group-membership.png)

---

### Delegated Administration & Least-Privilege

- Created **Helpdesk Tier** for daily support (password resets, account unlocks)
- Founder/Admin accounts retain full rights
- Ensures **security and operational efficiency**

---

### Automation Pipeline

- **Script A**: AD structure setup
  - Creates parent OUs if missing
  - Creates track groups in `Cybersecurity-Programs\Groups` automatically
  - Logs actions with timestamps

- **Script B**: Bulk student onboarding
  - Reads CSV file for 100 students
  - Creates cohort OUs if missing
  - Creates user accounts with secure, temporary passwords
  - Assigns users to cohort and program track groups
  - Logs all actions for audit and troubleshooting

<!-- Screenshot: PowerShell automation log -->
![Automation Log](screenshots/automation-log.png)

> Automation reduces manual work by **~95%**, simulating a realistic Day 1 cohort onboarding.

---

## Technologies & Tools

- **Directory Services:** Windows Server 2022 (AD DS, DNS)
- **Management Layer:** RSAT (Remote Server Administration Tools) on Windows 11 Pro domain-joined Client
- **Automation Engine:** PowerShell (CSV ingestion, data normalization, username standardization, logging, bulk provisioning)
- **Hypervisor:** Oracle VM VirtualBox (Shared Folders, Guest Additions, Snapshots)
- **Network Configuration:** Static IPv4 addressing for domain stability

---

## Core Skills Demonstrated

- **Systems Architecture:** Designed a hierarchical Active Directory structure aligned to a future training organization, separating cohorts, users, groups,domain-joined clients and cybersecurity program tracks into scalable Organizational Units (OUs).

- **Organizational Unit (OU) Design:** Created structured OUs manually to understand directory design before introducing automation, including student cohorts, user containers, and cybersecurity specialization groups.

- **Identity & Access Management (IAM):** Implemented group-based access control using security groups for cohort membership and specialization tracks (Blue-Team, Red-Team, GRC), demonstrating practical Role-Based Access Control (RBAC).

- **Manual Identity Provisioning:** Performed manual creation of users, groups, and memberships to understand foundational directory administration before scaling through automation.

- **Bulk User Provisioning:** Automated student onboarding through CSV-driven account creation, cohort assignment, password initialization, and group membership allocation.

- **PowerShell Automation:** Built repeatable provisioning workflows using PowerShell for OU creation, security group creation, and bulk account deployment.

- **Data Normalization:** Processed onboarding datasets by cleaning CSV records, standardizing usernames, enforcing naming consistency, trimming formatting issues, and preparing records for Active Directory compatibility.

- **Administrative Logging:** Implemented PowerShell logging to capture provisioning actions, timestamps, successful account creation, and execution feedback for traceability and troubleshooting.

- **Group Policy Administration (GPO):** Configured password policies and account policies including password complexity, minimum password length, lockout thresholds, password history, and account lockout duration.

- **Password Policy Security:** Tested and observed password policy behavior to understand how domain password enforcement affects user authentication and account protection.

- **Delegated Administration:** Applied least-privilege principles by separating helpdesk permissions from domain administrative privileges.

- **Account Management:** Performed password resets, account unlock operations, and permission verification within delegated administration boundaries.

- **Domain Controller Network Configuration:** Configured static IPv4 addressing to ensure reliable DNS resolution and stable domain services.

- **DNS Administration:** Verified name resolution, configured DNS dependencies, and resolved internal/external DNS behavior required for domain operations.

- **Connectivity Testing:** Used ping and related network checks to validate host communication between domain controller and client systems.

- **Domain Join Operations:** Joined a Windows 11 Pro client to the domain and validated domain authentication workflows.

- **Remote Administration:** Managed the environment from a Windows 11 Pro domain-joined client using RSAT administrative consoles.

- **Virtualization Operations:** Managed Oracle VM VirtualBox environment including snapshots, shared folders, Guest Additions installation, and VM boot configuration.

- **Shared Folder Configuration:** Configured file transfer between host and guest systems to support scripts, CSV imports, logs, and documentation workflow.

- **Authentication Reliability:** Resolved Kerberos-related time drift issues through clock synchronization to maintain secure domain authentication.

- **Infrastructure Troubleshooting:** Resolved VirtualBox boot errors, RSAT installation failures, DNS issues, feature installation blockers, and permissions conflicts.

- **Operational Documentation:** Produced technical documentation for architecture, automation workflow, troubleshooting records, and future scalability planning.

## Troubleshooting & Lab Notes

### VirtualBox Boot Priority

- Issue: VM failed with ROM/DDM error  
- Fix: Hard Disk moved to top of boot order; Network boot disabled  
- Lesson: Correct boot order ensures VM boots directly from installed OS

<!-- Screenshot: VM boot settings -->
![VM Boot Priority](screenshots/vm-boot.png)

---

### Kerberos Time Drift

- Issue: Local CMOS time mismatch causing authentication failures  
- Fix: Configured DC to sync with NTP servers  
- Lesson: Kerberos requires accurate time to prevent replay attacks

<!-- Screenshot: NTP sync configuration -->
![Kerberos Time Sync](screenshots/kerberos-sync.png)

---

### RSAT DNS Resolution

- Issue: RSAT feature installation failed on client  
- Fix: Added alternate DNS (`8.8.8.8`) while preserving internal AD DNS  
- Lesson: Internal AD works separately from outbound internet DNS; troubleshooting logs included

<!-- Screenshot: DNS resolution log -->
![RSAT DNS Fix](screenshots/dns-fix.png)

---

### Guest Additions & Shared Folders

- Installed VirtualBox Guest Additions for file transfer and clipboard sharing  
- Configured shared folder (`Z:\`) for CSV ingestion and logging  
- Lesson: Simplifies data flow between host and VM

---

## Portfolio & Future Vision

This lab demonstrates **founder-level systems thinking**:

- Solves a **real business problem**: managing cohorts, mentors, and resources efficiently  
- Scalable design: can handle growth from 10 → 1000+ students  
- Audit-ready: Logs, IDs, and group-based assignments ensure **traceability**  
- Provides foundation for **training programs**, **resource management**, and **future mentorship platform**

> This lab is the **technical brain** for the future organization: CyberWomen, empowering female graduates in cybersecurity.

<!-- Screenshot: High-level architecture diagram -->
![Future Vision Architecture](screenshots/future-vision.png)

---
