# Schema Extraction Queries

This folder contains SQL queries used to extract schema metadata from each database server. Run these queries and save the output as CSV files into the corresponding `exports/` folder.

## Structure

```
queries/
├── redshift/
│   ├── extract_tables_and_columns.sql
│   ├── extract_dist_sort_keys.sql
│   └── extract_constraints.sql
├── sql-server/
│   ├── extract_tables_and_columns.sql
│   ├── extract_constraints.sql
│   └── extract_indexes.sql
└── mysql/
    ├── extract_tables_and_columns.sql
    └── extract_constraints.sql
```

## Workflow

1. Run the relevant query against your database
2. Export results as CSV
3. Save CSV to `schemas/<server>/exports/` using the naming convention:
   ```
   <schema>__<table>__<YYYY-MM-DD>.csv
   ```
4. Use the CSV to update or generate DDL files in `schemas/<server>/tables/`
