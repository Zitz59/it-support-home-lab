# INC-0003 — Client has no network access, self-assigned 169.254.x.x address

| Field | Value |
|---|---|
| **Ticket ID** | INC-0003 |
| **Date opened** | 2026-05-20 |
| **Date resolved** | 2026-05-20 |
| **Priority** | Medium |
| **Category** | Network |
| **Affected system** | Ubuntu-Lab |
| **Status** | Resolved |

## Summary

Ubuntu client lost all network access after a VM restart. Interface showed a 169.254.x.x (APIPA/link-local) address, indicating it never received a DHCP lease.

## Environment

- Ubuntu Desktop VM (VirtualBox)
- DHCP expected from lab router

## Symptoms

- No internet, no LAN access
- `ip addr` → interface up, but address `169.254.44.17/16` (link-local, self-assigned)
- Other VMs on the same virtual network receiving leases normally

## Troubleshooting steps

1. `ip addr` and `ip route` → link-local address, no default route: the client never got a DHCP answer, so the question is *why the DHCP exchange failed for this VM specifically*.
2. Compared VirtualBox network settings against a working VM → the affected VM's adapter was set to **Internal Network** while working clients used **Bridged Adapter**, so the DHCP server was simply unreachable from that segment.
3. To confirm before changing anything: `sudo dhclient -v` → DHCPDISCOVER sent repeatedly, no offers received — consistent with "no DHCP server on this segment".

## Root cause

VM network adapter attached to the wrong VirtualBox network type (Internal Network with no DHCP service) after lab reconfiguration.

## Resolution

Reattached the adapter to Bridged mode, then renewed the lease: `sudo dhclient -r && sudo dhclient`. Verified with `ip addr` (proper 192.168.1.x address), `ip route` (default gateway present), and `ping` to gateway and external host.

## Prevention / Notes

- A **169.254.x.x address is a symptom, not a cause** — it always means "DHCP failed", and the real question is where the exchange broke: client, network path, or server.
- Documented the intended VirtualBox network layout in `docs/lab-setup.md` so adapter modes don't silently drift during reconfiguration.
