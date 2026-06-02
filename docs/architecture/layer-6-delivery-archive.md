# Layer 6 — Delivery & Archive Layer

## Purpose

Handles the final delivery of generated files to their intended destinations and archives all output to S3 for retrieval and compliance. Supports multiple delivery channels.

## Responsibilities

- Archive all generated files to S3
- Deliver files to customers via SFTP
- Support on-demand download by users
- Route files to customer exchange systems (PBM clients)
- Send email notifications on delivery
- Update delivery status in ODS

## Delivery Channels

| Channel | Description |
|---|---|
| S3 Archive Storage | All files stored in S3 regardless of delivery method |
| Customer Exchange (PBM) | File routing to PBM client exchange systems |
| SFTP Automated Delivery | Push delivery to configured SFTP destinations |
| On-Demand Download | User-initiated download via UI (Layer 1) |
| Email Notifications | Notify recipients when a file is ready or delivered |

## Integration Points

- **Layer 5 (Execution)** — Receives completed files from execution workers
- **Layer 3 (ODS)** — Writes delivery status and confirmation records
- **Layer 1 (UI)** — Provides download links for on-demand access
- **Layer 7 (Monitoring)** — Delivery success/failure feeds dashboards and alerts

## Tech Stack

- Archive Storage: **AWS S3**
- Delivery: **SFTP**, **Email**, **Customer Exchange APIs**

## Open Questions / Decisions

- [ ] S3 bucket structure — per client, per report type, per date?
- [ ] S3 lifecycle policies — how long are files retained?
- [ ] SFTP — managed service or self-hosted?
- [ ] How are SFTP credentials managed and rotated securely?
- [ ] Email delivery — SES or third-party service?
- [ ] What triggers a delivery failure alert vs. a retry?
