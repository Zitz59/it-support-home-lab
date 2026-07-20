# INC-0001 — Websites unreachable by name, reachable by IP (DNS resolution failure)

| Field | Value |
|---|---|
| **Ticket ID** | INC-0001 |
| **Date opened** | 2026-03-04 |
| **Date resolved** | 2026-03-04 |
| **Priority** | Medium |
| **Category** | Network |
| **Affected system** | Windows-Lab |
| **Status** | Resolved |

## Summary

Windows client could not open any websites in the browser ("This site can't be reached"), while other machines on the same network worked normally.

## Environment

- Windows 11 VM (VirtualBox, bridged adapter)
- Network: DHCP from lab router, gateway 192.168.1.1

## Symptoms

- Browser error `DNS_PROBE_FINISHED_NXDOMAIN` on all sites
- `ping 8.8.8.8` — successful (internet connectivity OK)
- `ping google.com` — "Ping request could not find host" (name resolution failing)

## Troubleshooting steps

1. Verified physical/virtual connectivity: `ping` gateway and external IP → both OK, so the problem is isolated to name resolution, not connectivity.
2. Checked configured DNS servers: `ipconfig /all` → DNS server was set manually to a non-existent address `192.168.1.53` instead of being obtained via DHCP.
3. `nslookup google.com 8.8.8.8` → resolved correctly, confirming external DNS works and only the client config is wrong.
4. Flushed resolver cache as a precaution: `ipconfig /flushdns`.

## Root cause

Static (incorrect) DNS server address manually configured on the network adapter, overriding DHCP-provided DNS.

## Resolution

Set the adapter's DNS settings back to "Obtain DNS server address automatically" (Control Panel → Network Connections → adapter → IPv4 properties). Confirmed with `ipconfig /all` that DNS was received from DHCP, then verified `ping google.com` and browsing worked.

## Prevention / Notes

- Isolation pattern worth remembering: **ping by IP vs ping by name** immediately splits "connectivity problem" from "DNS problem".
- `nslookup <host> <server>` lets you test a specific DNS server independently of client settings.
