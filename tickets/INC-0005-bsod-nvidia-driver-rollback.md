# INC-0005 — BSOD loop (DRIVER_IRQL_NOT_LESS_OR_EQUAL) caused by faulty NVIDIA display driver

| Field | Value                              |
|---|------------------------------------|
| **Ticket ID** | INC-0005                           |
| **Date opened** | 2026-07-20                         |
| **Date resolved** | 2026-07-20                         |
| **Priority** | High                               |
| **Category** | Hardware / Drivers                 |
| **Affected system** | Physical Windows PC (host machine) |
| **Status** | Resolved                           |
| **Time to resolve** | ~15 min                            |

## Summary

PC crashed with a blue screen (Stop Code: `DRIVER_IRQL_NOT_LESS_OR_EQUAL`). Diagnosis in Safe Mode traced the crash to the NVIDIA display driver (`nvlddmkm.sys`), likely introduced by a recent driver update. Resolved by rolling back the driver; system stable after multiple reboots.

## Environment

- Physical PC, Windows 11
- NVIDIA discrete GPU, driver recently updated

## Symptoms

- Blue Screen of Death on boot with Stop Code `DRIVER_IRQL_NOT_LESS_OR_EQUAL`
- Normal boot not possible

## Troubleshooting steps

1. Recorded the **Stop Code** displayed on the BSOD screen — the starting point for any BSOD diagnosis.
2. Forced the PC into **Windows Recovery Environment** by interrupting boot 2–3 times.
3. Navigated: Troubleshoot → Advanced Options → Startup Settings → restarted into **Safe Mode** (loads minimal drivers, so the faulty one is bypassed).
4. In Safe Mode, opened **Event Viewer** (Windows Logs → System) — found a **Critical** event at the time of the crash pointing to `nvlddmkm.sys` (NVIDIA display driver module).
5. Opened **Device Manager** → Display adapters → NVIDIA GPU → Driver tab → **Roll Back Driver** to the previous version.
6. Rebooted normally and monitored for recurrence.

## Root cause

Faulty NVIDIA display driver (`nvlddmkm.sys`) causing `DRIVER_IRQL_NOT_LESS_OR_EQUAL` — the driver accessed memory at an invalid IRQL. Confirmed via Event Viewer (Critical event in the System log at crash time referencing this module). Most likely introduced by a recent driver update.

## Resolution

Rolled back the video driver via Device Manager. PC rebooted successfully; **no further BSOD after 3 restarts** — considered stable and ticket closed.

## Prevention / Notes

- `nvlddmkm.sys` in a BSOD almost always means the NVIDIA display driver; the Stop Code + module name together usually identify the culprit before any deep debugging.
- Diagnostic pattern: **Stop Code → Safe Mode → Event Viewer → offending module → roll back / update driver.** Works for most driver-related BSODs.
- When the rolled-back driver is old, the longer-term fix is installing a known-stable newer version (e.g., NVIDIA Studio driver) rather than staying on the outdated one indefinitely.
- For recurring BSODs where Event Viewer is inconclusive, memory dump analysis (`C:\Windows\Minidump` + WinDbg) is the next step.
