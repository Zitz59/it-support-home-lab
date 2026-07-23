# INC-0006 —  Website not accessible from one workstation

| Field | Value                                       |
|---|---------------------------------------------|
| **Ticket ID** | INC-0006                                    |
| **Date opened** | 2026-07-23                                  |
| **Date resolved** | 2026-07-23                                  |
| **Reported by** | End user |
| **Priority** | Low                          |
| **Category** |   Network   |
| **Affected system** | DESKTOP-CCFT1G0 — Windows 11                          |
| **Status** | Resolved                                    |

## Summary

Single website not accessible from one workstation, others work normally.

## Environment

- DESKTOP-CCFT1G0 Windows 11
- Standard corporate network, DHCP-assigned addressing

## Symptoms

- User reports example.com does not load. Other sites work. Same site opens fine from a different machine.
- The same site opens without issue from a different machine on the same network.

## Troubleshooting steps

1. `ping example.com` → resolved to 127.0.0.1 (loopback), replies returned from the local machine.
2. `nslookup example.com` → returned valid public addresses: A records 104.20.23.154 and 172.66.147.243, plus corresponding AAAA records in the Cloudflare range.
3. Inspected `C:\Windows\System32\drivers\etc\hosts` — found a static entry mapping example.com to 127.0.0.1.


## Root cause

Opened `C:\Windows\System32\drivers\etc\hosts` redirecting the domain to loopback.

The mismatch between `ping` and `nslookup` confirmed the problem was local rather than DNS-side: `nslookup` queries the DNS server directly, while `ping` uses the system resolver, which reads the hosts file before making a DNS query.

## Resolution

1.Opened `C:\Windows\System32\drivers\etc\hosts` in an elevated editor and removed the line `127.0.0.1 example.com`.  
2.Clear the resolver `ipconfig /flushdns`  
3.Verified: `ping example.com` now returns 104.20.23.154.  
4.Confirmed with the user that the site loads normally.

## Prevention / Notes

- Hosts file entries silently override DNS and persist indefinitely — worth checking early when a single domain fails while other sites work.
- If the entry was not added intentionally by the user, treat it as a possible security incident: malware and unwanted software commonly modify the hosts file to redirect or block domains. Run a malware scan before closing.
- Antivirus products (e.g. Dr.Web) legitimately add blocking entries — verify the source before removing anything.
- Editing the hosts file requires administrator rights. Notepad launched without elevation fails silently and appends a `.txt` extension, so the file appears edited when it is not.