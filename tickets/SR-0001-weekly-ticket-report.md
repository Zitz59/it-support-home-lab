# SR-0001 — Weekly ticket report

| Field            | Value                |
|------------------|----------------------|
| **Ticket ID**    | SR-0001              |
| **Type**         | Service Request      |
| **Category**     | SQL                  |
| **Priority**     | Medium               |
| **Status**       | Resolved             |
| **Date**         | 2026-07-25           |
| **Requested by** | Service Desk Lead    |
| **Fulfilled by** | Aleksandr Zaitsev L1 |

## Request

Pull ticket stats from the DB ahead of the weekly review meeting.

## Business Justification / Context

Needed for weekly Service Desk review; wants unresolved count, category
breakdown, and open high-priority items with affected users.

## Environment

- PostgreSQL, helpdesk_practice , Ubuntu-Lab VM

## Actions / Queries
1.command to access the database
```bash
sudo -u postgres psql helpdesk_practice
```


2.commands to create review
```sql
SELECT t.ticket_id, t.summary, u.full_name, u.department
FROM tickets t JOIN users u ON t.user_id=u.user_id
WHERE t.priority = 'High' AND t.status != 'Solved';
```
for fast copy
```sql
SELECT t.ticket_id, t.summary, u.full_name, u.department FROM tickets t JOIN users u ON t.user_id = u.user_id WHERE t.priority = 'High' AND t.status != 'Solved';
```
## Result / Deliverable


```
| ticket_id | summary                   | full_name        | department  |
|-----------|---------------------------|------------------|-------------|
| 47        | IP conflict detected      | Vuk Jovanovic    | Engineering |
| 31        | Shared mailbox request    | Vuk Ilic         | Operations  |
| 4         | Printer offline           | Vuk Ilic         | Operations  |
| 8         | BSOD on startup           | Marko Zivkovic   | Finance     |
| 62        | Can't reach internal site | Jovana Vasic     | Finance     |
| 87        | Disk almost full          | Jelena Ilic      | Engineering |
| 59        | BSOD on startup           | Stefan Kovacevic | Marketing   |
| 26        | Unauthorized login alert  | Stefan Kovacevic | Marketing   |
```




##  Notes

if neccessary in future for more fastest reusability we can create view

```sql
CREATE VIEW unresolved_high_priority_tickets AS
SELECT t.ticket_id, t.summary, u.full_name, u.department
FROM tickets t JOIN users u ON t.user_id=u.user_id
WHERE t.priority = 'High' AND t.status != 'Solved';
```
or 

```sql
CREATE VIEW unresolved_high_priority_tickets AS SELECT t.ticket_id, t.summary, u.full_name, u.department FROM tickets t JOIN users u ON t.user_id = u.user_id WHERE t.priority = 'High' AND t.status != 'Solved';
```