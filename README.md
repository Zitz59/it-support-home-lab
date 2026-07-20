# IT Support Home Lab

Hands-on IT support practice environment I built and maintain to develop real Help Desk / Service Desk skills. Every issue I create or encounter in the lab is handled as a structured support ticket — from first report to documented resolution.

**Author:** Aleksandr Zaitsev — [LinkedIn](https://www.linkedin.com/in/aleksandr-zaitsev-322354235/) · Belgrade, Serbia

---

## What's in this repo

| Folder | Contents |
|---|---|
| [`tickets/`](tickets/) | Resolved cases documented in a consistent incident-ticket format (problem → diagnosis → resolution → prevention) |
| [`docs/`](docs/) | Lab setup, network topology, and configuration notes |
| [`scripts/`](scripts/) | Small automation scripts used for routine tasks in the lab |

## Lab environment

- **Hypervisor:** VirtualBox on a Windows host
- **VMs:** Windows 11 client (Windows-Lab), Ubuntu Desktop (Ubuntu-Lab)
- **Networking:** DNS, DHCP, static IP addressing, VPN, remote access (RDP / SSH)
- **Services & tools:** Microsoft 365, Active Directory basics, Jira (ticketing), Git, Postman, remote desktop tools

## Skills practiced

- Structured troubleshooting of hardware, software, and network issues
- User account management, software installation, system configuration
- Incident management and ticket documentation (Jira workflow)
- Remote troubleshooting over RDP and SSH
- Writing clear resolution notes for technical and non-technical audiences

## Why this exists

Coming from several years of customer-facing support work, I'm transitioning into IT support and believe the best way to learn is to break things, fix them, and write down how. This repo is my public logbook of that process.

Currently completing CompTIA/Google IT Support fundamentals and the IBM Technical Support curriculum.

## Ticket format

Each ticket in [`tickets/`](tickets/) follows the same template ([`tickets/TEMPLATE.md`](tickets/TEMPLATE.md)):

```
Summary → Environment → Symptoms → Troubleshooting steps → Root cause → Resolution → Prevention / Notes
```

This mirrors real service desk documentation practice: reproducible steps, clear root cause, and a resolution someone else could follow.
