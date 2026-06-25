# SSRS Reporting Upgrade Project Plan: 2008 → 2026

**Project:** Upgrade all SSRS reports from SQL Server Reporting Services 2008 to SSRS 2026  
**Location:** `SSRS 2008/updated2025/`  
**Date Created:** June 2026  
**Status:** In Progress

---

## Overview

This project covers the systematic upgrade of all legacy SSRS 2008 `.rdl` report files to be fully compatible with SSRS 2026 (SQL Server Reporting Services 2022/2026). The reports already updated and stored in the `updated2025` folder serve as the baseline and template for this migration. The upgrade approach follows the method previously used to modernize these reports.

---

## Goals

- Migrate all `.rdl` files from SSRS 2008 schema to SSRS 2026 schema
- Remove deprecated elements (e.g., legacy `<rd:ReportID>`, `<rd:DesignerVersion>`, old namespace declarations)
- Update XML namespaces from `2008/01` to current supported versions
- Ensure reports render correctly in the new Report Server environment
- Validate parameter handling, data sources, and subreport references
- Maintain existing report output/behavior (no functional regression)

---

## Upgrade Method (Used for Updated2025 Reports)

Each report was upgraded using the following steps:

1. **XML Namespace Update**  
   Update the root `<Report>` element namespace from:  
   `xmlns="http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition"`  
   to:  
   `xmlns="http://schemas.microsoft.com/sqlserver/reporting/2016/01/reportdefinition"`

2. **Remove Deprecated Designer Metadata**  
   Strip out `<rd:ReportID>`, `<rd:DesignerVersion>`, `<rd:Subjects>` and other legacy Report Designer tags that are unsupported or cause warnings in newer versions.

3. **DataSource Compatibility**  
   Review and update embedded `<DataSource>` connection strings or references to match the new Report Server data source paths.

4. **Parameter Modernization**  
   Review `<ReportParameter>` definitions — ensure `<ValidValues>`, `<DefaultValue>`, and multi-value params follow the updated schema.

5. **Expression Syntax Review**  
   Scan for any deprecated VB expressions or functions (e.g., legacy aggregate syntax) and update to supported equivalents.

6. **Subreport Reference Check**  
   For reports with subreport references, confirm subreport names/paths match those deployed on the target 2026 server.

7. **Rendering Extension Updates**  
   Update any hardcoded references to old rendering formats (e.g., `EXCEL` → `EXCELOPENXML`, `WORD` → `WORDOPENXML`).

8. **Test & Validate**  
   Deploy to test Report Server, run each report, verify output matches legacy baseline.

---

## Report Inventory

The following report categories exist in the `updated2025` folder and require upgrade validation:

| Category | Example Reports | Count (approx.) |
|----------|----------------|-----------------|
| ADT | ADT_004.001 | 1 |
| BETTY / Membership | BETTY_PLAY_MEMB_007 | 1 |
| CLPK / CLSP (ABC, ARX, BLRX, EVO, MEDB, TSC, TRCD, URXS, PAYSN) | CLSP_EVO_*, CLSP_ABC_* | ~20 |
| Claims Surveillance (PDM) | PDM_Claims_Surveillance_* | ~40 |
| Financial (FIN, Admin Fees) | FIN_001.*, FIN_Admin_Fees_* | ~6 |
| Group Reports (GRP) | GRP_001.*, GRP_003.* | ~7 |
| PDM Core Reports | PDM_BENEFITS_DATA, PDM_CLAIMS_111, PDM_FIN, etc. | ~30 |
| GoodRx Pricing | GoodRxPricingFile_* | 2 |
| Header Templates | Header013, Header014, Header013NS, Header014NS | 4 |
| URXS Reports | URXS_BROKER_*, URXS_Benchmark, URXS_TopDrug* | ~6 |
| Quarterly Executive Package | QTR_EXEC_PKG_001.001_COMPLETE | 1 |
| RxEOB | RxEOB_PlanExtract_S | 1 |
| Misc / Other | ProcessorPlanFileReport, WHSE_013, LVHN_FirstFill, etc. | ~6 |

**Total Reports in updated2025:** ~130+

---

## Phases

### Phase 1 — Assessment & Environment Setup
- [ ] Confirm target SSRS 2026 server is available and accessible
- [ ] Document current data source names/paths on legacy server
- [ ] Map legacy data source references to new 2026 server equivalents
- [ ] Set up a test/dev Report Server for validation
- [ ] Identify any reports with subreport dependencies (cross-reference list)

### Phase 2 — Namespace & Schema Upgrade (Batch)
- [ ] Write/run script to update XML namespace across all `.rdl` files in `updated2025`
- [ ] Strip deprecated `<rd:*>` metadata elements
- [ ] Commit upgraded files back to repo under a new folder (e.g., `updated2026`) or version tag

### Phase 3 — Data Source & Parameter Review
- [ ] Review all unique `<DataSourceName>` values across reports
- [ ] Update or remap connection strings for 2026 environment
- [ ] Validate multi-value parameters and cascading dropdowns

### Phase 4 — Expression & Rendering Compatibility
- [ ] Scan for deprecated expression syntax
- [ ] Update rendering extension names (Excel, Word)
- [ ] Fix any custom code blocks that use unsupported VB APIs

### Phase 5 — Subreport & Header Template Validation
- [ ] Confirm `Header013`, `Header014`, `Header013NS`, `Header014NS` deploy correctly
- [ ] Validate all subreport references resolve on the new server
- [ ] Test reports that embed the header templates: ensure rendering is correct

### Phase 6 — Deployment to Test Server
- [ ] Deploy all upgraded reports to test Report Server
- [ ] Run each report and compare output to legacy baseline
- [ ] Document any rendering differences or errors
- [ ] Fix identified issues and redeploy

### Phase 7 — Production Deployment
- [ ] Schedule production cutover window
- [ ] Deploy all validated reports to production SSRS 2026 server
- [ ] Update any report subscriptions / delivery schedules on new server
- [ ] Decommission legacy SSRS 2008 reports (archive, do not delete)
- [ ] Notify stakeholders of completion

---

## Risk & Mitigation

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| Data source paths differ between servers | High | Document and map all DSN references in Phase 1 |
| Large reports (>1MB RDL) may have rendering issues | Medium | Test QTR_EXEC_PKG and large Surveillance reports first |
| Subreport references break on new server | Medium | Validate header templates and subreport list early (Phase 5) |
| Parameter default value behavior changes | Low | Review each parameterized report during Phase 3 |
| Subscription schedules lost in migration | Medium | Export and re-create subscriptions during Phase 7 |

---

## Success Criteria

- All ~130+ reports in `updated2025` render without errors on SSRS 2026
- Report output matches legacy baseline (no data or formatting regression)
- All subscriptions and scheduled deliveries are functional on new server
- Legacy SSRS 2008 server is safely archived and decommissioned

---

## Notes

- Reports already in `updated2025` were previously upgraded using the method described above — these serve as the starting point, not the original 2008 source files.
- The `SSRS 2008/` root folder contains the original legacy `.rdl` files for reference.
- For very large reports (e.g., `PDM_Claims_Surveillance_4324MaxClaim_001NS.rdl` at ~2MB, `QTR_EXEC_PKG_001.001_COMPLETE.rdl` at ~2.4MB), extra validation time should be budgeted.
