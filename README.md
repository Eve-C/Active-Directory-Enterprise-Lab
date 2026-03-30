# CyberWomen Systems Architecture
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
  - `CyberWomen-Users`
    - `Students`
      - `Cohort-2026`
      - `Cohort-2027`
      - `Alumni`
    - `Groups`
  - `Cybersecurity-Programs`
    - `Groups` *(manually created)*
      - `GG-Blue-Team` *(manual creation)*
      - `GG-Red-Team` *(manual creation)*
      - `GG-GRC` *(manual creation)*

<!-- Screenshot: OU structure diagram -->
![OU Structure](screenshots/ou-structure.png)

> **Note:** The `Cybersecurity-Programs` Groups OU and its track groups were manually created to understand enterprise design before applying automation.

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
  - Reads CSV file for 100+ students
  - Creates cohort OUs if missing
  - Creates user accounts with secure, temporary passwords
  - Assigns users to cohort and program track groups
  - Logs all actions for audit and troubleshooting

<!-- Screenshot: PowerShell automation log -->
![Automation Log](screenshots/automation-log.png)

> Automation reduces manual work by **~95%**, simulating a realistic Day 1 cohort onboarding.

---

## Technologies & Tools

- **Directory Services**: Windows Server 2022 (ADDS, DNS, DHCP)  
- **Management Layer**: RSAT (Remote Server Administration Tools) on Windows Client  
- **Automation Engine**: PowerShell (Splatting, CSV ingestion, logging)  
- **Hypervisor**: Oracle VM VirtualBox (with Shared Folders & Guest Additions)

---

## Core Skills Demonstrated

- **Systems Architecture**: Designing an AD structure that reflects real-world business workflows  
- **Identity & Access Management**: Cohort-based and program-based RBAC  
- **Automation**: Bulk onboarding with CSV + PowerShell  
- **Operational Security**: Time synchronization, tiered admin model, least-privilege delegation  
- **Troubleshooting**: VirtualBox boot errors, DNS resolution, Kerberos time drift, RSAT feature fixes

---

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
