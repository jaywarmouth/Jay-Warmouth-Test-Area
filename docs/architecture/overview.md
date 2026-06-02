# Architecture Overview

## Purpose

This document provides a high-level summary of the full 7-layer architecture that powers the Enterprise Export & Extract Platform. Each layer has a distinct responsibility and together they form an end-to-end pipeline from user request to delivery.

## Architecture Diagram

> *(Insert architecture diagram image here)*

## Layer Summary

### Layer 1 — Ad Hoc Export Center
Self-service UI where users initiate export and extract requests. Entry point for all ad hoc activity.

### Layer 2 — Export / Extract Configuration
MongoDB-backed configuration store. Defines report definitions, parameter schemas, delivery profiles, and access roles.

### Layer 3 — Operational Data Store
MySQL system of record. Tracks request lifecycle, execution status, retries, errors, and audit history.

### Layer 4 — RabbitMQ Report Exchange Broker
Message queue broker that routes export requests to the appropriate execution queues. Supports priority, retry, and dead letter queues.

### Layer 5 — EKS Execution Layer
Kubernetes-based execution engine running on AWS EKS. Handles data retrieval, transformation, file generation, compression, and encryption.

### Layer 6 — Delivery & Archive Layer
S3-based archive and multi-channel delivery. Supports SFTP, on-demand download, customer exchange, and email notifications.

### Layer 7 — Monitoring & Visibility Layer
Real-time dashboards, alerting, audit reports, and CloudWatch integrations for full operational observability.

## Data Flow

```
User Request (Layer 1)
  → Configuration Lookup (Layer 2)
  → Request Logged (Layer 3)
  → Queued for Processing (Layer 4)
  → Executed & File Generated (Layer 5)
  → Delivered & Archived (Layer 6)
  → Monitored & Alerted (Layer 7)
```

## Open Questions / Decisions

- [ ] What is the primary UI framework for Layer 1?
- [ ] Is the MySQL instance managed (RDS) or self-hosted?
- [ ] What EKS node sizing / autoscaling strategy is planned?
- [ ] Multi-region or single-region deployment?
- [ ] Authentication / SSO strategy across layers?
