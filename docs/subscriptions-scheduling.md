# Extra Credit Layer — Subscriptions & Scheduling

## Purpose

Leverages the same 7-layer architecture for scheduled and recurring exports. Instead of a user submitting a request manually through the UI, the subscription engine auto-submits requests on a defined schedule.

## Responsibilities

- Define and manage subscriptions per client/report
- Enforce security and entitlement rules for scheduled exports
- Configure schedule frequency, timing, and buffer logic
- Auto-submit requests through the standard execution pipeline
- Manage promotion of subscriptions to production
- Expose APIs for subscription management and status

## Key Components

| Component | Description |
|---|---|
| Subscription Definitions | Manage exports, clients, parameters and delivery preferences |
| Security Structure | Role-based access and client entitlements |
| Schedule Configuration | Frequency, execution date/time, buffer days and delays |
| Execution Process | Automated submissions flow through the same backend layers |
| Promotion to Production | Controlled process for compliance and activations |
| API Access | APIs for subscription management, request and delivery status |

## Integration Points

- **Layer 2 (Configuration)** — Subscription definitions stored alongside report configs
- **Layer 3 (ODS)** — Scheduled request records created and tracked the same as ad hoc
- **Layer 4 (RabbitMQ)** — Scheduled submissions enter the same queues
- **Layer 7 (Monitoring)** — Subscription runs visible in dashboards

## Tech Stack

- Scheduler: *TBD (cron, AWS EventBridge, Quartz?)*
- API: *TBD*

## Open Questions / Decisions

- [ ] What scheduling engine will be used? (EventBridge, cron, Quartz Scheduler?)
- [ ] How are missed schedules (downtime windows) handled?
- [ ] What does the "Promotion to Production" workflow look like?
- [ ] Is there a self-service UI for managing subscriptions?
- [ ] How are subscription conflicts (overlapping runs) handled?
