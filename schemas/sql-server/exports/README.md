# SQL Server CSV Exports

This folder stores raw CSV exports of schema metadata pulled from SQL Server.

## File Naming Convention

```
<schema>__<table>__<YYYY-MM-DD>.csv
```

Examples:
- `dbo__customers__2026-06-03.csv`
- `dbo__orders__2026-06-03.csv`

## How to Export

Run the queries in `/schemas/queries/sql-server/` against your SQL Server instance and save the output as CSV here.
