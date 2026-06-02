# Layer 1 — Ad Hoc Export Center

## Purpose

Self-service UI that allows users to initiate export and extract requests without engineering involvement. This is the primary entry point for all ad hoc data requests. The UI is designed to be **embedded into existing client portals** (e.g. `mypbmportal.com`) rather than hosted as a standalone application.

---

## Responsibilities

- Allow users to select an Export or Extract type (filtered by entitlements)
- Accept and validate input parameters dynamically
- Support date range selection
- Support output format selection
- Configure file naming options
- Submit requests to the backend pipeline
- Display request status and history

---

## Hosting Model

The Export Center is hosted on **our infrastructure** and embedded into client portals via an `<iframe>` or Web Component. Clients do not need to build or maintain the UI — they simply embed it.

| Approach | Description | Status |
|---|---|---|
| **iFrame Embed** | Self-contained app embedded in client portal via `<iframe>` | ✅ Recommended for Phase 1 |
| **Micro-frontend SDK** | JS bundle clients drop into their portal for seamless UX | 🔵 Future / Phase 2 |

**Static assets hosted on AWS S3 + CloudFront** for speed, low cost, and cloud-agnostic delivery.

---

## Tech Stack

| Concern | Technology | Notes |
|---|---|---|
| **UI Framework** | **React** | Widely adopted, easy to embed, strong ecosystem |
| **Component Library** | **MUI (Material UI)** or **Ant Design** | Enterprise-ready; data tables, forms, date pickers built-in |
| **API Layer** | **REST API** (Node.js / Express or .NET) | Simple, well-understood, easy to secure |
| **Authentication** | **OAuth 2.0 / JWT** | Standard, works cross-domain, supports SSO |
| **Hosting** | **AWS S3 + CloudFront** | Static React app, fast and cost-efficient |

---

## Security & Access Control Model

Security operates at **two levels** — UI and API. The API always enforces entitlements independently; the UI reflects them for user experience only.

### JWT Token Claims

Each authenticated user carries a JWT token with the following claims:

```json
{
  "client_id": "mypbmportal",
  "user_id": "jsmith@example.com",
  "user_roles": ["export_viewer", "export_submitter"],
  "allowed_reports": ["report_001", "report_005", "report_012"]
}
```

### Access Control Rules

| Rule | Description |
|---|---|
| **Report Filtering** | UI only renders reports the user is entitled to — unlisted reports are never shown |
| **Section Visibility** | UI sections (e.g. admin tools, bulk submit) shown/hidden based on `user_roles` |
| **API Enforcement** | Backend validates JWT claims on every request — UI entitlements are never trusted alone |
| **Client Isolation** | `client_id` ensures users only see data and reports belonging to their portal |

### Role Definitions (Draft)

| Role | Capabilities |
|---|---|
| `export_viewer` | View report catalog and request history only |
| `export_submitter` | Submit new export requests |
| `export_admin` | Manage report access, view all client history |

---

## Key Features

| Feature | Description |
|---|---|
| Export / Extract Catalog | Filtered card or list view of reports the user is entitled to |
| Parameter Entry | Dynamic form driven by Layer 2 configuration |
| Date Picker | Flexible date range selection |
| Format Selection | CSV, Excel, JSON, etc. |
| File Naming | Custom naming rules and tokens |
| Submit Request | Triggers pipeline via API; returns request ID |
| Status & History | Table of past and in-progress requests with status and download links |

---

## UI Screens (Planned)

### 1. Export Catalog
- Card or list view of all available exports for the authenticated user
- Filtered by `allowed_reports` from JWT
- Search / filter by category or keyword

### 2. Request Form
- Dynamically rendered based on report definition from Layer 2
- Fields: parameters, date range, output format, file naming
- Client-side validation before submission

### 3. Submission Confirmation
- Displays request ID
- Estimated processing time
- Link to Status & History

### 4. Status & History
- Table of all requests for the user (or client if admin)
- Columns: Request ID, Report Name, Submitted, Status, Delivery, Download
- Polling or websocket for live status updates

---

## Integration Points

- **Layer 2 (Configuration)** — Pulls report definitions and parameter schemas to build the catalog and forms dynamically
- **Layer 3 (ODS)** — Writes request records on submission; reads status and history
- **Layer 7 (Monitoring)** — User activity surfaced in dashboards and audit logs

---

## Open Questions / Decisions

- [ ] iFrame vs. micro-frontend — confirm Phase 1 approach with client portal teams
- [ ] SSO integration — does each client portal have an existing identity provider (SAML, OIDC)?
- [ ] Who manages user entitlements? (admin UI needed, or managed via config?)
- [ ] Should the UI support bulk request submission?
- [ ] What does the file naming token system look like? (e.g. `{client}_{report}_{date}`)
- [ ] Mobile / responsive requirements?
- [ ] How are new clients onboarded — self-service or ops-managed?
