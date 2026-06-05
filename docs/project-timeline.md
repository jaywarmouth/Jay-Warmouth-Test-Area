# Project Timeline — Enterprise Export & Extract Platform

## Overview

This document outlines a realistic delivery timeline across all 7 architecture layers. Estimates account for current team capabilities, confirmed accelerators, and known risk areas.

---

## Accelerators & Risk Factors

| Factor | Impact |
|---|---|
| Layer 2 — MongoDB config already exists | ✅ Saves ~3 weeks; read-only integration only |
| Layer 1 — UI is AI-driven (Copilot / Cursor) | ✅ Saves ~2 weeks on scaffold and component generation |
| Layer 6 — Delivery team has deep experience | ✅ Parallel track; minimal risk |
| Layer 4 — RabbitMQ: limited team experience | ⚠️ +2 week buffer; use Amazon MQ (managed) to reduce ops burden |
| Layer 5 — EKS: limited team experience | ⚠️ +2 week buffer; simplify node design, use KEDA for autoscaling |
| Layer 3 — ODS: greenfield MySQL schema | Neutral — well-understood tech, needs upfront design completeness |

---

## Timeline Summary

**Total Duration:** 18 Weeks (~4.5 Months)

```
Layer                      W1  W2  W3  W4  W5  W6  W7  W8  W9  W10 W11 W12 W13 W14 W15 W16 W17 W18
────────────────────────────────────────────────────────────────────────────────────────────────────
Infra / DevOps             [===][===]
L2 Config Read API              [===][===]
L3 ODS Schema + Deploy     [===][===]
L3 ODS API (status/write)            [===][===]
L4 RabbitMQ — Learn + PoC       [===][===]
L4 Queue Topology + Sub API               [===][===]
L5 EKS — Learn + Skeleton                      [===][===]
L5 Execution Engine                                 [===][===][===]
L5 File Gen + Encrypt                                         [===][===]
L6 S3 Archive + SFTP           [===]=========================[===]   (parallel, low dependency)
L6 Email + Exchange                                               [===][===]
L1 UI Scaffold (AI-driven)                              [===][===]
L1 UI Integration                                                     [===][===]
L7 CloudWatch + Alerts                                          [===][===]
L7 Grafana Dashboards                                                      [===][===]
Integration Testing                                                              [===][===]
Hardening + Soft Launch                                                               [===][===]
```

---

## Phase Detail

---

### Phase 0 — Foundation `Weeks 1–2`

**Goal:** All infrastructure is running in development. Every engineer can connect to every service.

**Tasks:**
- Provision: RDS MySQL (Layer 3), Amazon MQ — RabbitMQ (Layer 4), EKS cluster (Layer 5), S3 buckets (Layer 6)
- Set up CI/CD pipeline: GitHub Actions → ECR → EKS
- Confirm MongoDB read connectivity from application services
- Establish secrets management: AWS Secrets Manager for DB credentials, SFTP keys, PGP keys
- **Decide and lock:** EKS worker runtime language (Python or Node.js — decide by end of Week 1)

**Deliverable:** Dev infrastructure online. Connectivity to all services verified.

---

### Phase 1 — Layer 3 ODS + Layer 2 Config API `Weeks 1–6`

#### Layer 3 — Operational Data Store `Weeks 1–4`

**Key tables:**
- `export_requests` — core lifecycle record per submission
- `execution_records` — one row per attempt (supports retries)
- `retry_log` — history of retry attempts and reasons
- `error_log` — errors and warnings per request/execution
- `delivery_records` — one row per delivery channel per request
- `audit_log` — append-only security and activity log
- `scheduled_run_log` — scheduler execution tracking and dedup

**Tasks:**
- Week 1–2: Schema design review, migration scripts, deploy to RDS dev
- Week 3–4: Build REST API for Layer 1 (submit request, read status/history) and Layer 5 (write execution outcome)

**Deliverable:** ODS live with real schema. Submission and status APIs respond correctly.

> ⚠️ **Note:** Schema completeness here pays dividends across all later layers. Do not rush the data model.

---

#### Layer 2 — Config Read API `Weeks 2–5`

**Goal:** Thin REST service exposing existing MongoDB config to other layers. No writes to MongoDB — it remains the source of truth.

**Key endpoints:**
- `GET /config/subscriptions/:reportKey` — full subscription definition for execution
- `GET /config/catalog?customerId=X` — filtered report list for the UI
- `GET /config/customers/:customerId` — customer entitlements and application access
- `GET /config/parameter-schema/:reportKey` — dynamic form schema for UI rendering

**Deliverable:** Config API returns real data from MongoDB. Layer 1 and Layer 5 can call it.

---

### Phase 2 — Layer 4 RabbitMQ Broker `Weeks 3–8`

#### Week 3–5: Learn + Proof of Concept

- Use **Amazon MQ for RabbitMQ** — eliminates broker operations overhead
- Build minimal producer/consumer PoC: publish a message, consume it, ack it
- Understand core concepts: exchanges, queues, routing keys, bindings, consumer prefetch
- Understand error path: `x-dead-letter-exchange`, `x-message-ttl`, manual ack vs. auto ack

> ⚠️ **RabbitMQ learning note:** The happy path is straightforward. The complexity is in dead-letter routing, retry TTL, and message deduplication. Reserve one full week for failure path testing.

#### Week 6–8: Full Queue Topology

**Exchange and queue design:**

```
Exchange: export.requests  (topic, durable)
  export.standard   →  q.standard      (standard exports)
  export.large      →  q.large         (long-running / large row counts)
  export.priority   →  q.priority      (high-priority, bypasses ordering)

All queues → DLX: export.dlx  →  q.dead_letter  (exceeded retry limit)

q.retry  (TTL-based delay → republish to original queue on expiry)
```

**Tasks:**
- Deploy queue topology to Amazon MQ dev
- Build submission API: Layer 1 POST → Layer 3 write → RabbitMQ publish
- Layer 3 status updated on queue lifecycle events (queued, acked, nacked, dead-lettered)
- Define retry limit (recommended: 3 attempts before DLQ)

**Deliverable:** Submit a request via API → appears in RabbitMQ queue → Layer 3 status updates correctly. DLQ receives messages after retry exhaustion.

---

### Phase 3 — Layer 5 EKS Execution Engine `Weeks 5–14`

#### Week 5–8: EKS Fundamentals + Worker Skeleton

**EKS learning areas (limited experience — allocate time here):**
- Kubernetes core: Pods, Deployments, ConfigMaps, Secrets
- AWS EKS specifics: IAM Roles for Service Accounts (IRSA), node groups, ECR image pull
- **KEDA** (Kubernetes Event-Driven Autoscaling) — scales worker replicas based on RabbitMQ queue depth
  - Recommended: start with 1 replica per queue, scale to max 10 based on queue depth > 5
- AWS Load Balancer Controller for any external-facing services

**Skeleton worker tasks:**
- Container: connects to RabbitMQ, reads message, calls Layer 2 config API
- Writes `execution_started` to Layer 3 ODS
- Sends ack on success, nack (requeue=false) on unrecoverable failure
- Logs structured JSON to CloudWatch Logs

> ⚠️ **EKS note:** IRSA (IAM roles per pod) is the right pattern for accessing RDS, S3, Secrets Manager, and RabbitMQ credentials without hardcoded keys. Plan this from the start — retrofitting is painful.

#### Week 9–12: Execution Logic

**Processing pipeline (in order):**

1. **Data retrieval** — connect to Redshift or MSSQL via connection pool; credentials from Secrets Manager
2. **Transformation** — apply column mapping and field formatting from Layer 2 layout config
3. **File generation** — produce output in requested format:
   - CSV / pipe-delimited: straightforward streaming write
   - Excel (.xlsx): use `openpyxl` (Python) or `exceljs` (Node)
   - PDF: most complex — evaluate `WeasyPrint` (Python) or `Puppeteer` (Node) in Week 9
4. **Compression** — GZIP or ZIP as configured per subscription
5. **PGP encryption** — encrypt with recipient public key where required (`python-gnupg` or `openpgp`)
6. **Write to S3 staging prefix** — `s3://[bucket]/staging/[request_uuid]/[filename]`

> ⚠️ **PDF generation decision:** Lock the library by end of Week 9. PDF is the hardest format. Build a standalone spike before integrating into the worker.

#### Week 13–14: Status Reporting + Layer 6 Handoff

- Write `execution_completed` record to Layer 3 with `output_s3_key` and `file_size_bytes`
- Write `execution_failed` with error details on failure
- Emit delivery trigger event: either a direct call to Layer 6 service or a delivery queue message

**Deliverable:** Full end-to-end path — message consumed → source data queried → file written to S3 → Layer 3 shows `completed`.

---

### Phase 4 — Layer 6 Delivery & Archive `Weeks 2–14` *(Parallel Track)*

> ✅ **Team has deep delivery experience.** This layer runs mostly in parallel with minimal dependencies until Layer 5 produces a real file (Week 12+).

**Tasks (can start early):**
- Week 2–4: S3 bucket structure decision and bucket policies
  - Recommended: `s3://[bucket]/archive/{client_name}/{year}/{month}/{request_uuid}/{filename}`
- Week 4–6: S3 archive move (staging → archive on execution complete)
- Week 6–8: Pre-signed URL generation for on-demand download; expiry policy (recommended: 7 days)
- Week 8–10: SES email notification with download link and delivery summary
- Week 10–12: SFTP delivery — recommended: **AWS Transfer Family** (S3-backed, no server to manage)
- Week 12–14: Customer Exchange routing (PBM portal file push API integration)
- Write `delivery_record` to Layer 3 on each delivery channel outcome

**Deliverable:** Generated file reaches the correct destination channel. Layer 3 `delivery_records` fully populated.

---

### Phase 5 — Layer 1 UI `Weeks 9–14`

> Layer 1 can begin once the Layer 2 Config API (Week 5) and Layer 3 Submission API (Week 4) are stable.

#### Week 9–11: AI-Scaffolded React App

Use GitHub Copilot / Cursor to generate:
- Project structure: React + Vite + TypeScript
- Component library: MUI (Material UI) — data tables, date pickers, forms built-in
- Cognito auth hook: token retrieval, silent refresh, token pass-through from host portal
- Routing: React Router v6

**Screens to scaffold:**
1. **Export Catalog** — card/list view, filtered by `allowed_reports` from Layer 2
2. **Request Form** — dynamically rendered from parameter schema (Layer 2 config API)
3. **Submission Confirmation** — request UUID, estimated time, link to history
4. **Status & History** — table with polling or WebSocket for live status

#### Week 12–13: Integration

- Submit form → Layer 3 submission API → RabbitMQ queued confirmation
- Status/history table polling Layer 3 `export_requests`
- Download button → Layer 6 pre-signed S3 URL
- Error states: failed requests, expired download links, form validation

#### Week 14: iFrame Packaging + Deploy

- Production build → S3 + CloudFront
- Cognito token pass-through from host portal (postMessage or URL param)
- CORS and CSP policy review

> ⚠️ **AI-generated UI note:** AI scaffolding accelerates boilerplate significantly. Plan for 1 week of human review and cleanup per major screen. Do not skip code review on AI output.

**Deliverable:** Embeddable UI where a user selects a report, fills parameters, submits, watches live status, and downloads the completed file.

---

### Phase 6 — Layer 7 Monitoring `Weeks 11–16`

#### Week 11–13: CloudWatch Instrumentation

- Structured JSON logging from all services → CloudWatch Log Groups
- CloudWatch Metrics: request volume, execution duration, error rate, queue depth, delivery success rate
- Log Insights queries for audit and support use cases

#### Week 14–16: Grafana Dashboards + Alerting

**Recommended stack:** Grafana OSS + CloudWatch datasource plugin (free, no DataDog cost)

**Dashboard panels:**
- Requests submitted / hour (by client, by type)
- Queue depth: `q.standard`, `q.large`, `q.priority`, `q.dead_letter`
- Execution success rate and p95 duration
- Delivery success rate by channel (email, SFTP, download, exchange)
- Error rate and top error codes
- DLQ depth (should always be 0)

**Alerting (SNS → Email/Slack):**
- DLQ depth > 0 → immediate ops alert
- Execution error rate > 5% in 15 min window → ops alert
- Queue depth > 100 for > 10 min → capacity alert
- Delivery failure > 3 consecutive → client notification + ops alert

**Deliverable:** Ops team has a live dashboard. Alerts fire correctly on injected failures.

---

### Phase 7 — Integration Testing & Go-Live `Weeks 15–18`

#### Week 15–16: Integration Testing

- End-to-end test: UI submit → queued → executed → delivered → UI shows download link
- Cross-layer contract tests: confirm Layer 3 status transitions are correct at each handoff
- DLQ test: force a worker failure, confirm dead-lettering, confirm ops alert fires
- Retry test: force transient failure, confirm retry succeeds on attempt 2
- Load test: 50 concurrent large export requests — confirm KEDA scales workers, queue doesn't back up indefinitely
- Security test: JWT claims enforced at API layer; no cross-client data access

#### Week 17–18: Hardening + Soft Launch

- Fix issues from integration test
- Run with 1–2 pilot clients on real data (non-production)
- Confirm delivery SLAs are met end-to-end
- Documentation: runbook for ops, DLQ review process, manual retry procedure
- Go / No-Go review

**Deliverable:** Platform ready for production onboarding.

---

## Decisions to Lock Before Development Starts

> Leaving these open will block work or cause expensive rework.

| # | Decision | Blocks | Recommendation |
|---|---|---|---|
| 1 | EKS worker runtime language | Layer 5 start | **Python** — fastest for data processing, file gen libs mature |
| 2 | RabbitMQ: Amazon MQ vs self-hosted | Layer 4 complexity | **Amazon MQ** — removes ops burden, same AMQP protocol |
| 3 | MySQL: RDS vs self-hosted | Layer 3 reliability | **RDS MySQL** — automated backups, Multi-AZ failover |
| 4 | PDF library selection | Layer 5 Week 9 | Spike `WeasyPrint` (Python) in Week 1 alongside EKS setup |
| 5 | SFTP: AWS Transfer Family vs self-hosted | Layer 6 | **AWS Transfer Family** — S3-native, no server to manage |
| 6 | Monitoring dashboard | Layer 7 | **Grafana + CloudWatch datasource** — free, best UX |
| 7 | iFrame vs Micro-frontend (Phase 1) | Layer 1 packaging | **iFrame** for Phase 1 — fastest path, revisit Phase 2 |

---

## Timeline Summary by Layer

| Layer | Name | Weeks | Duration | Key Risk |
|---|---|---|---|---|
| Infra | Foundation | 1–2 | 2 wks | Provisioning delays |
| L2 | Config Read API | 2–5 | 3 wks | MongoDB schema changes |
| L3 | ODS Schema + APIs | 1–6 | 5 wks | Schema completeness upfront |
| L4 | RabbitMQ Broker | 3–8 | 5 wks | ⚠️ Learning curve — DLQ/retry |
| L5 | EKS Execution Engine | 5–14 | 9 wks | ⚠️ Learning curve — EKS + PDF |
| L6 | Delivery & Archive | 2–14 | Parallel | Low — team has experience |
| L1 | Ad Hoc UI | 9–14 | 5 wks | AI output quality review |
| L7 | Monitoring | 11–16 | 5 wks | Alert threshold tuning |
| — | Integration + Launch | 15–18 | 4 wks | Cross-layer integration gaps |

**Total: 18 weeks**

---

## Open Questions

- [ ] Is there a hard go-live deadline driving the 18-week estimate?
- [ ] How many pilot clients are expected at soft launch?
- [ ] Are subscription (scheduled) exports in scope for Phase 1 or Phase 2?
- [ ] What is the maximum expected file size for a single export? (Drives S3 multipart, streaming design)
- [ ] Is there a compliance requirement for audit log retention duration?
