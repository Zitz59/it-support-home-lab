# INC-0004 — PC running slowly, caused by critically low free space on system drive


| Field | Value |
|---|---|
| **Ticket ID** | INC-0004 |
| **Date opened** | 2026-07-18 |
| **Date resolved** | 2026-07-18|
| **Priority** | Medium |
| **Category** | Software / Performance |
| **Affected system** | Windows-Lab            |
| **Status** | Resolved               |
| **Time to resolve** | ~10 min                |

## Summary

User reported that the PC was running slowly. Diagnosis showed the system drive was almost full (5% free), which degraded overall system performance. Resolved by cleaning up temporary files and browser cache, with user guidance on periodic maintenance.

## Environment

- Windows 11 client (Windows-Lab)
- System drive C: — 58.7 GB total

## Symptoms

- General slowness reported by the user
- Confirmed via clarifying questions (see below): slowness was constant, not tied to a specific program, and got worse over time

## Troubleshooting steps

1. **Clarifying questions to the user** (to narrow the search area before touching anything):
   - Is the PC slow all the time, or only when running specific programs or websites?
   - Anything unusual noticed: fan noise, overheating, strange pop-up windows?
   - Was anything installed recently: new program, browser extension, connected flash drive?
   - Did the slowness appear suddenly, or has it been getting worse over time?
2. Answers pointed to constant, gradually worsening slowness with no signs of malware or recent installs → checked **Task Manager** (Processes tab, CPU/RAM usage) — no single process consuming abnormal resources.
3. With CPU/RAM ruled out, checked disk capacity as the next common cause of gradual system-wide slowness:
   - Settings → System → Storage
   - PowerShell: `Get-PSDrive C`
   - cmd: `fsutil volume diskfree C:`

## Root cause

System drive C: had only **3.4 GB free out of 58.7 GB (~5%)**. Windows needs free space on the system drive for the page file, temporary files, and updates; below ~10% free, performance degrades noticeably.

## Resolution

1. Cleaned up the system drive: browser cache, Windows temporary files (Disk Cleanup / Storage settings).
2. Verified free space increased and system responsiveness returned to normal.
3. **User guidance:** politely explained that disk cleanup needs to be done periodically, and showed where to check free space, so the user can catch this early next time.

## Prevention / Notes

- Windows Storage Sense can be enabled to clean temporary files automatically on a schedule.
- Diagnostic pattern worth remembering: **constant + gradually worsening slowness** with clean Task Manager output points to disk (space or health) rather than a runaway process.
- Asking structured questions first saved time: four questions ruled out malware, overheating, and recent software changes before any hands-on diagnostics.
