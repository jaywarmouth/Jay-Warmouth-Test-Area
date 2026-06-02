# Layer 1 — Ad Hoc Export Center

## Purpose

Self-service UI that allows users to initiate export and extract requests without engineering involvement. This is the primary entry point for all ad hoc data requests.

## Responsibilities

- Allow users to select an Export or Extract type
- Accept and validate input parameters
- Support date range selection
- Support output format selection
- Configure file naming options
- Submit requests to the backend pipeline
- Display request status and history

## Key Features

| Feature | Description |
|---|---|
| Export / Extract Selection | Browse and select from available report definitions |
| Parameter Entry | Dynamic form driven by configuration (Layer 2) |
| Date Picker | Flexible date range selection |
| Format Selection | CSV, Excel, JSON, etc. |
| File Naming | Custom naming rules and tokens |
| Submit Request | Triggers pipeline via API |
| Status & History | View current and past request results |

## Integration Points

- **Layer 2 (Configuration)** — Pulls report definitions and parameter schemas to build the UI dynamically
- **Layer 3 (ODS)** — Writes request records on submission; reads status and history
- **Layer 7 (Monitoring)** — User activity surfaced in dashboards

## Tech Stack (TBD)

- Frontend Framework: *TBD*
- API Layer: *TBD*
- Auth / SSO: *TBD*

## Open Questions / Decisions

- [ ] What UI framework will be used? (React, Angular, Vue?)
- [ ] Role-based access — who can see which exports?
- [ ] Should the UI support bulk request submission?
- [ ] What does the file naming token system look like?
- [ ] Mobile / responsive requirements?
