# Redshift Schemas

Contains DDL scripts for Amazon Redshift.

## Conventions
- Always specify `DISTKEY` and `SORTKEY` for large tables
- Use `ENCODE` compression for columnar efficiency
- Prefer `VARCHAR` over `CHAR` to save storage
- Use `DISTSTYLE ALL` for small dimension/lookup tables

## Folders

| Folder | Description |
|---|---|
| `tables/` | CREATE TABLE statements |
| `views/` | CREATE VIEW statements |
