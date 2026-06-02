# Layer 5 — EKS Execution Layer

## Purpose

Kubernetes-based execution engine running on AWS EKS. Consumes messages from the RabbitMQ queues and performs the core work: data retrieval, transformation, file generation, compression, and encryption.

## Responsibilities

- Consume export requests from RabbitMQ queues
- Retrieve source data from upstream systems
- Apply transformations and layout mappings
- Generate output files in the requested format
- Compress files as configured
- Encrypt files (PGP) where required
- Report execution status back to ODS

## Processing Steps

| Step | Description |
|---|---|
| Data Retrieval | Fetch data from source systems (DB, API, etc.) |
| Transformation | Apply field mapping, formatting, and filtering |
| File Generation | Produce output file (CSV, Excel, JSON, etc.) |
| Compression | Zip or gzip as configured |
| Encryption (PGP) | Encrypt file with recipient PGP key if required |
| Status Reporting | Write execution outcome to ODS (Layer 3) |

## Integration Points

- **Layer 4 (RabbitMQ)** — Consumes work messages from queues
- **Layer 2 (Configuration)** — Reads report config and layout definitions
- **Layer 3 (ODS)** — Writes execution status and outcomes
- **Layer 6 (Delivery)** — Passes completed files to delivery layer
- **Layer 7 (Monitoring)** — Execution metrics and errors surfaced in dashboards

## Tech Stack

- Container Orchestration: **AWS EKS (Kubernetes)**
- Language / Runtime: *TBD*
- Encryption: **PGP**

## Open Questions / Decisions

- [ ] What language/runtime are execution workers written in?
- [ ] Autoscaling strategy — HPA, KEDA (queue-depth based)?
- [ ] How are data source connections managed (connection pooling, secrets)?
- [ ] What output formats are supported at launch?
- [ ] How are large file splits handled?
