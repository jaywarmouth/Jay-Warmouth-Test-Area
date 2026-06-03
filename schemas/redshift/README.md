# Redshift Schemas

Contains DDL scripts for Amazon Redshift.

## Conventions
- Always specify `DISTKEY` and `SORTKEY` for large tables
- Use `ENCODE` compression for columnar efficiency
- Prefer `VARCHAR` over `CHAR` to save storage
- Use `DISTSTYLE ALL` for small dimension/lookup tables

## Schema

All production tables live in the `cloud_data_warehouse` schema on the Enterprise Data Warehouse Redshift cluster.

## Folders

| Folder | Description |
|---|---|
| `tables/` | CREATE TABLE statements |
| `views/` | CREATE VIEW statements |
| `exports/` | Raw CSV schema exports from Redshift (`information_schema.columns`) |
