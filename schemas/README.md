# Data Schemas

This directory contains DDL schema definitions for all supported databases.

## Structure

```
schemas/
├── sql-server/       # Microsoft SQL Server schemas
├── redshift/         # Amazon Redshift schemas
├── mysql/            # MySQL schemas
└── migrations/       # Versioned migration scripts (all databases)
```

## Guidelines

- One object (table, view, procedure) per file
- Use descriptive file names matching the object name
- Never commit credentials or connection strings
- Document all changes via migration scripts in `/migrations`
