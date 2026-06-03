# Redshift CSV Exports

This folder stores raw CSV exports of schema metadata pulled from Redshift.

All exports come from the `cloud_data_warehouse` schema in the Enterprise Data Warehouse.

## CSV Column Layout

Exported files use the following column structure (matches `information_schema.columns`):

| Column | Description |
|---|---|
| `table_schema` | Schema name (e.g. `cloud_data_warehouse`) |
| `table_name` | Table name |
| `column_name` | Column name |
| `ordinal_position` | Column order position |
| `data_type` | Redshift data type |
| `character_maximum_length` | Max length for `character varying` columns |
| `numeric_precision` | Precision for numeric/integer columns |
| `numeric_scale` | Scale for numeric columns |
| `is_nullable` | `YES` or `NO` |
| `column_default` | Default value expression, if any |

## File Naming Convention

```
<schema>__<table>__<YYYY-MM-DD>.csv
```

Examples:
- `cloud_data_warehouse__claims__2026-06-03.csv`
- `cloud_data_warehouse__cardholder_data__2026-06-03.csv`

For full-schema exports (all tables), use:
```
<schema>__ALL_TABLES__<YYYY-MM-DD>.csv
```

Example:
- `cloud_data_warehouse__ALL_TABLES__2026-06-03.csv` _(this is the `Enterprise Data Warehouse Data Schema.csv` file)_

## Folder Structure

```
exports/
├── cloud_data_warehouse/     # Per-table exports for cloud_data_warehouse schema
└── Enterprise Data Warehouse Data Schema.csv   # Full schema export (all tables)
```

## How to Export

Run the following query against your Redshift cluster and save the output as CSV:

```sql
SELECT
    table_schema,
    table_name,
    column_name,
    ordinal_position,
    data_type,
    character_maximum_length,
    numeric_precision,
    numeric_scale,
    is_nullable,
    column_default
FROM information_schema.columns
WHERE table_schema = 'cloud_data_warehouse'
ORDER BY table_name, ordinal_position;
```
