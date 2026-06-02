# Layer 2 — Export / Extract Configuration

## Purpose

MongoDB-driven configuration store that defines all reusable export and extract definitions. Acts as the "source of truth" for what exports exist, how they behave, and who can access them.

## Responsibilities

- Store and manage report definitions
- Define parameter schemas for each export type
- Manage data mapping and layout configurations
- Maintain aliases for report identifiers
- Store delivery profiles (where/how files are sent)
- Define file naming rules
- Manage export options and flags
- Enforce security and access roles

## Key Configuration Objects

| Object | Description |
|---|---|
| Report Definitions | Describes the export type, query, and output format |
| Parameter Schemas | Defines input fields, types, validations, and defaults |
| Data Mapping / Layouts | Maps source fields to output columns |
| Aliases | Friendly names and alternate identifiers for reports |
| Delivery Profiles | Destination configs (S3 path, SFTP target, email list) |
| File Naming Rules | Token-based rules for output file names |
| Export Options | Flags for compression, encryption, splitting, etc. |
| Security & Access Roles | Client and user-level entitlements |

## Integration Points

- **Layer 1 (UI)** — Provides dynamic form definitions and available export catalog
- **Layer 5 (Execution)** — Execution engine reads config to know how to process a request
- **Layer 6 (Delivery)** — Delivery profiles drive destination routing

## Tech Stack

- Database: **MongoDB**
- Access Pattern: Read-heavy; configuration changes are infrequent

## Open Questions / Decisions

- [ ] Is MongoDB hosted (Atlas) or self-managed?
- [ ] How are configuration changes versioned/audited?
- [ ] Who can create/edit report definitions? Admin UI needed?
- [ ] How are new client onboardings handled in config?
- [ ] Should configs support environment promotion (dev → prod)?
