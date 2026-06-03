# MySQL CSV Exports

This folder stores raw CSV exports of schema metadata pulled from MySQL.

## File Naming Convention

```
<schema>__<table>__<YYYY-MM-DD>.csv
```

Examples:
- `mydb__customers__2026-06-03.csv`
- `mydb__orders__2026-06-03.csv`

## How to Export

Run the queries in `/schemas/queries/mysql/` against your MySQL instance and save the output as CSV here.
