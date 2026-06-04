# Redshift Schemas

Contains DDL scripts and documentation for Amazon Redshift schema assets.

## Schema

Primary warehouse schema in this repo: `cloud_data_warehouse`.

## Folder Structure

```
schemas/redshift/
├── README.md
├── exports/
├── tables/
│   ├── README.md
│   └── cloud_data_warehouse/
├── views/
│   ├── README.md
│   └── cloud_data_warehouse/
└── data-dictionary/
    ├── README.md
    └── cloud_data_warehouse/
```

## Folders

| Folder | Description |
|---|---|
| `exports/` | Raw CSV schema exports from Redshift (`information_schema.columns`) |
| `tables/` | Generated `CREATE TABLE` DDL grouped by schema |
| `views/` | View DDL grouped by schema (currently placeholders) |
| `data-dictionary/` | Generated table-level data dictionary markdown files |
