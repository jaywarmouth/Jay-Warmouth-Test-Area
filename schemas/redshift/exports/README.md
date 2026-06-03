# Redshift CSV Exports

This folder stores raw CSV exports of schema metadata pulled from Redshift.

## File Naming Convention

```
<schema>__<table>__<YYYY-MM-DD>.csv
```

Examples:
- `public__customers__2026-06-03.csv`
- `public__orders__2026-06-03.csv`

## How to Export

Run the queries in `/schemas/queries/redshift/` against your Redshift cluster and save the output as CSV here.
