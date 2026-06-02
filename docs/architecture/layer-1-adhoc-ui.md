# Layer 1 — Ad Hoc Export Center

## Purpose

Self-service UI that allows users to initiate export and extract requests without engineering involvement. This is the primary entry point for all ad hoc data requests. The UI is designed to be **embedded into existing client portals** (e.g. `mypbmportal.com`) rather than hosted as a standalone application.

All UI elements, available reports, and access controls are **driven by metadata** configured by the Ops team — no code changes are required to add or modify what a user sees.

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
| **Authentication** | **Amazon Cognito + MFA** | ✅ Confirmed — all portals use Cognito |
| **Hosting** | **AWS S3 + CloudFront** | Static React app, fast and cost-efficient |

> **KeyCloak** was considered as a federated identity broker but is **not needed** — all current and planned client portals use Amazon Cognito. This decision is closed.

---

## Authentication — Amazon Cognito + MFA

All client portals (e.g. `mypbmportal.com`) use **Amazon Cognito with MFA**. The Export Center integrates directly with Cognito — users authenticate as they normally would on the portal with no separate login.

**Flow:**
```
User logs into client portal via Amazon Cognito (with MFA)
  → Cognito issues tokens (ID token + Access token)
  → Portal passes Cognito ID token to embedded Export Center on load
  → Export Center validates the Cognito token
  → Export Center issues a scoped JWT with metadata-driven entitlements
  → UI renders based on entitlements; API enforces them on every call
```

The scoped JWT includes:
```json
{
  "client_id": "mypbmportal",
  "user_id": "jsmith@example.com",
  "user_roles": ["export_viewer", "export_submitter"],
  "allowed_reports": ["report_001", "report_005", "report_012"],
  "ui_metadata": {
    "visible_sections": ["catalog", "history"],
    "allowed_formats": ["CSV", "Excel"],
    "features": {}
  }
}
```

---

## Security & Access Control Model

Security operates at **two levels** — UI and API. The API always enforces entitlements independently; the UI reflects them for user experience only.

| Rule | Description |
|---|---|
| **Report Filtering** | UI only renders reports the user is entitled to — unlisted reports are never shown |
| **Section Visibility** | UI sections shown/hidden based on metadata-configured roles |
| **API Enforcement** | Backend validates JWT claims on every request — UI entitlements are never trusted alone |
| **Client Isolation** | `client_id` ensures users only see data and reports belonging to their portal |
| **MFA** | Enforced at Cognito layer — Export Center inherits MFA compliance from portal login |

### Role Definitions (Draft)

| Role | Capabilities |
|---|---|
| `export_viewer` | View report catalog and request history only |
| `export_submitter` | Submit new export requests |
| `export_admin` | View all client history |

---

## Metadata-Driven UI

All UI elements are driven by **metadata configured by the Ops team** in Layer 2 (MongoDB). There are no hardcoded report lists, form fields, or UI sections. This means:

- Adding a new report for a client = **Ops config change**, not a code deploy
- Changing what fields appear on a form = **metadata update**
- Enabling or disabling a UI section for a client = **metadata flag**

**Metadata controls:**
- Which reports appear in the catalog
- What input fields and parameters each report requires
- Allowed output formats per report / per client
- File naming token rules
- Which UI sections are visible (catalog, history, bulk submit, etc.)

---

## Key Features

| Feature | Description |
|---|---|
| Export / Extract Catalog | Filtered card or list view of reports the user is entitled to |
| Parameter Entry | Dynamic form driven by Layer 2 metadata configuration |
| Date Picker | Flexible date range selection |
| Format Selection | Allowed formats per report, driven by metadata |
| File Naming | Token-based naming rules configured in metadata |
| Submit Request | Triggers pipeline via API; returns request ID |
| Status & History | Table of past and in-progress requests with status and download links |

---

## UI Screens (Planned)

### 1. Export Catalog
- Card or list view of all available exports for the authenticated user
- Filtered by `allowed_reports` from JWT / metadata
- Search / filter by category or keyword

### 2. Request Form
- Dynamically rendered from report definition metadata (Layer 2)
- Fields: parameters, date range, output format, file naming
- Client-side validation before submission

### 3. Submission Confirmation
- Displays request ID
- Estimated processing time
- Link to Status & History

### 4. Status & History
- Table of all requests for the user
- Columns: Request ID, Report Name, Submitted, Status, Delivery, Download
- Polling or websocket for live status updates

---

## Integration Points

- **Layer 2 (Configuration)** — Source of all metadata; drives report catalog, form fields, UI sections, and entitlements
- **Layer 3 (ODS)** — Writes request records on submission; reads status and history
- **Layer 7 (Monitoring)** — User activity surfaced in dashboards and audit logs

---

## Decisions Locked

- ✅ **Authentication** — Amazon Cognito with MFA; all portals confirmed on Cognito
- ✅ **KeyCloak** — Not needed; decision closed
- ✅ **Entitlement management** — Ops-managed config process; no admin UI needed
- ✅ **UI is fully metadata-driven** — report lists, forms, sections all from Layer 2 config
- ✅ **Phase 1 hosting** — iFrame embed via S3 + CloudFront

---

## Open Questions / Decisions

- [ ] iFrame vs. micro-frontend — confirm Phase 1 approach with client portal teams
- [ ] Should the UI support bulk request submission?
- [ ] What does the file naming token system look like? (e.g. `{client}_{report}_{date}`)
- [ ] Mobile / responsive requirements?
- [ ] How are new clients onboarded — what does the Ops config process look like end-to-end?
