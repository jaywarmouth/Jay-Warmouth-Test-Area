# Enterprise Export & Extract Platform

> **Scalable • Secure • Reliable • Cloud Agnostic.**

## Overview

The Enterprise Export & Extract Platform (EEEP) is a scalable, cloud-agnostic system designed to handle ad hoc and scheduled data exports and extracts across enterprise clients. It is built for reliability, observability, and flexibility — supporting standard and non-standard requests through a configuration-driven architecture.

## Core Principles

- **Scalable** — Elastic architecture to grow with demand.
- **Secure** — Enterprise-grade security and access controls.
- **Configuration Driven** — Flexible, reusable and client adaptable.
- **Reliable & Resilient** — Queue-based, fault tolerant and retry enabled.
- **Observable** — Full visibility across requests, runs and deliveries.
- **Auditable** — Complete audit trail for compliance and traceability.
- **Cost Efficient** — Optimized cloud resources and operational efficiency.
- **Cloud Agnostic** — Designed to run on any cloud platform.

## Architecture Summary

The platform is organized into **7 core layers** plus an **Extra Credit Layer** for subscriptions and scheduling.

| Layer | Name | Technology |
|---|---|---|
| 1 | Ad Hoc Export Center | UI / Web App |
| 2 | Export / Extract Configuration | MongoDB |
| 3 | Operational Data Store | MySQL |
| 4 | RabbitMQ Report Exchange Broker | RabbitMQ |
| 5 | EKS Execution Layer | AWS EKS / Kubernetes |
| 6 | Delivery & Archive Layer | AWS S3, SFTP, Email |
| 7 | Monitoring & Visibility Layer | CloudWatch, Dashboards |
| + | Subscriptions & Scheduling | Cross-layer |

## Documentation Index

- [Architecture Overview](architecture/overview.md)
- [Layer 1 — Ad Hoc Export Center](architecture/layer-1-adhoc-ui.md)
- [Layer 2 — Export / Extract Configuration](architecture/layer-2-configuration.md)
- [Layer 3 — Operational Data Store](architecture/layer-3-operational-datastore.md)
- [Layer 4 — RabbitMQ Report Exchange Broker](architecture/layer-4-rabbitmq-broker.md)
- [Layer 5 — EKS Execution Layer](architecture/layer-5-eks-execution.md)
- [Layer 6 — Delivery & Archive Layer](architecture/layer-6-delivery-archive.md)
- [Layer 7 — Monitoring & Visibility Layer](architecture/layer-7-monitoring.md)
- [Subscriptions & Scheduling](subscriptions-scheduling.md)
- [Business Value](business-value.md)

---

> *Built for Enterprise. Designed for Scale. Trusted for Delivery.*
