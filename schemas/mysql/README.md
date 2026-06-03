# MySQL Schemas

Contains DDL scripts for MySQL.

## Conventions
- Use `ENGINE=InnoDB` for all tables (supports transactions and foreign keys)
- Use `CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci` for full Unicode support
- Use `BIGINT UNSIGNED AUTO_INCREMENT` for primary keys
- Use backticks around identifiers to avoid reserved word conflicts

## Folders

| Folder | Description |
|---|---|
| `tables/` | CREATE TABLE statements |
| `views/` | CREATE VIEW statements |
