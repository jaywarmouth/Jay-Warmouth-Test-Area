# Layer 4 — RabbitMQ Report Exchange Broker

## Purpose

RabbitMQ message broker that receives submitted export requests and routes them to the appropriate execution queues. Provides fault tolerance, priority handling, and retry logic between request submission and execution.

## Responsibilities

- Accept export requests from the submission API
- Route messages to the correct queue based on request type/size
- Support prioritized processing
- Handle retries for failed executions
- Manage dead letter queue for unrecoverable failures

## Queue Types

| Queue | Purpose |
|---|---|
| Standard Queue | Default queue for normal-sized export requests |
| Large Export Queue | Dedicated queue for large or long-running exports |
| Priority Queue | High-priority requests that bypass standard ordering |
| Retry Queue | Requests that failed and are pending retry |
| Dead Letter Queue | Requests that exceeded retry limits; routed for investigation |

## Integration Points

- **Layer 3 (ODS)** — Queue events trigger status updates in the ODS
- **Layer 5 (Execution)** — EKS workers consume messages from queues
- **Layer 7 (Monitoring)** — Queue depth and failure rates feed monitoring dashboards

## Tech Stack

- Message Broker: **RabbitMQ**
- Hosting: *TBD (managed service or self-hosted on EKS)*

## Open Questions / Decisions

- [ ] Self-hosted RabbitMQ on EKS or managed (e.g., Amazon MQ)?
- [ ] What triggers promotion to Priority Queue?
- [ ] What is the retry limit before dead-lettering?
- [ ] Dead letter queue — manual review process or automated alerting?
- [ ] Message TTL and queue size limits?
