# INC-0002 — User locked out of Windows account after password change

| Field | Value |
|---|---|
| **Ticket ID** | INC-0002 |
| **Date opened** | 2026-04-12 |
| **Date resolved** | 2026-04-12 |
| **Priority** | High |
| **Category** | Account |
| **Affected system** | Windows-Lab |
| **Status** | Resolved |

## Summary

Simulated end-user scenario: user cannot sign in after a password change — "The account is locked out" message at the logon screen.

## Environment

- Windows 11 VM, local accounts
- Account lockout policy configured deliberately: threshold 5 invalid attempts, lockout duration 30 min

## Symptoms

- Logon rejected with account lockout message
- User (simulated) reports having tried the old password several times after the change

## Troubleshooting steps

1. Confirmed the lockout from an admin account: `net user testuser` → `Account active: Locked`.
2. Checked Security event log (Event Viewer → Windows Logs → Security) for Event ID 4740 (account lockout) to confirm source and time of the failed attempts.
3. Verified the lockout policy in `secpol.msc` (Account Policies → Account Lockout Policy) to understand the threshold that was hit.

## Root cause

Repeated sign-in attempts with the old password after a password change exceeded the lockout threshold — classic post-password-change lockout, no malicious activity (confirmed via event log timing).

## Resolution

1. Unlocked the account as admin: `net user testuser /active:yes` and cleared the lockout flag via Computer Management → Local Users and Groups → user properties → uncheck "Account is locked out".
2. Verified sign-in with the new password.
3. (User guidance) Explained the cause and advised updating any saved credentials (mapped drives, saved sessions) that could retry the old password automatically.

## Prevention / Notes

- Event ID **4740** is the go-to for lockout investigations; the `Caller Computer Name` field shows where the bad attempts came from — useful when a background service keeps locking an account.
- Communication matters as much as the fix: the "resolution" for the user includes understanding *why* it happened, or the ticket comes back tomorrow.
