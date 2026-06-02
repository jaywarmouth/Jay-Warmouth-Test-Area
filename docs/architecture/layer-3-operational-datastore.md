# Layer 3 — Operational Data Store

## Purpose

MySQL-based system of record for all request and execution activity. Tracks the full lifecycle of every export request from submission through delivery, including errors, retries, and audit history.

## Responsibilities

- Track all incoming export requests
- Record execution status and progress
- Log retries and timeouts
- Capture errors and warnings
- Track delivery status per request
- Maintain full history and archive
- Store user and security context (IP, user, source)
- Support audit and compliance queries

## Key Data Entities

| Entity | Description |
|---|---|
| Request | Core record for each export submission |
| Execution | Tracks processing steps and outcomes |
| Retry Log | History of retry attempts and reasons |
| Error Log | Captured errors and warnings per request |
| Delivery Record | Tracks delivery channel, status, and timestamps |
| Audit Entry | Security and user activity log |

## Integration Points

- **Layer 1 (UI)** — Reads status and history for display; request written on submission
- **Layer 4 (Queue)** — Queue events update execution and status records
- **Layer 5 (Execution)** — Execution engine writes progress and outcome
- **Layer 6 (Delivery)** — Delivery confirmations written back to ODS
- **Layer 7 (Monitoring)** — ODS data feeds dashboards and audit reports

## Tech Stack

- Database: **MySQL**
- Hosting: *TBD (RDS or self-managed)*

## Open Questions / Decisions

- [ ] MySQL on RDS (managed) or self-hosted?
- [ ] What is the data retention / archive policy?
- [ ] Are there reporting or BI tools querying this directly?
- [ ] Index strategy for high-volume request lookups?
- [ ] PII handling — are any user fields sensitive?
