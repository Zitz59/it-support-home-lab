# Lab setup

## Topology

```
                    ┌──────────────────┐
                    │   Home router     │
                    │   192.168.1.1     │
                    │   (DHCP + DNS)    │
                    └────────┬─────────┘
                             │
                    ┌────────┴─────────┐
                    │   Windows host    │
                    │   (VirtualBox)    │
                    └────────┬─────────┘
                    ┌────────┴─────────┐
                    │                  │
              Windows-Lab         Ubuntu-Lab
              Windows 11          Ubuntu Desktop
              (bridged)           (bridged)
```

## Virtual machines

| VM | OS | Purpose |
|---|---|---|
| Windows-Lab | Windows 11 | "End user" machine — M365, account scenarios, software and hardware troubleshooting |
| Ubuntu-Lab | Ubuntu Desktop | Linux troubleshooting, networking scenarios, SSH practice |

## Conventions

- All adapters use **Bridged** mode unless a scenario explicitly requires isolation (note it in the ticket).
- Every VM has a snapshot named `baseline` — restore point before breaking things.
- Each practice scenario gets a ticket in `tickets/`, numbered sequentially (INC-XXXX).

## Remote access

- Windows-Lab: RDP enabled for remote troubleshooting practice
- Ubuntu-Lab: OpenSSH server for remote access practice
