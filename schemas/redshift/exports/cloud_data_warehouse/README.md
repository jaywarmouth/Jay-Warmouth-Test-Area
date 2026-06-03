# cloud_data_warehouse — Per-Table Exports

This folder holds individual CSV exports scoped to a single table in the `cloud_data_warehouse` schema.

## Naming Convention

```
cloud_data_warehouse__<table_name>__<YYYY-MM-DD>.csv
```

Examples:
- `cloud_data_warehouse__claims__2026-06-03.csv`
- `cloud_data_warehouse__cardholder_data__2026-06-03.csv`
- `cloud_data_warehouse__claim_accumulation__2026-06-03.csv`

## Column Layout

All files share the same column structure:

```
table_schema, table_name, column_name, ordinal_position, data_type,
character_maximum_length, numeric_precision, numeric_scale, is_nullable, column_default
```

## Key Tables in cloud_data_warehouse

Based on the full schema export, notable tables include:

| Table | Description |
|---|---|
| `claims` | Core claims records (357 columns) |
| `claims_accum` | Claims accumulator detail |
| `claim_accumulation` | Claim accumulation summary |
| `cardholder_data` | Cardholder/member records |
| `card_range` | Card ID range configuration |
| `card_table` | Card table records |
| `admin` | Admin fee configuration |
| `bin_config` | BIN configuration |
| `brand_benefit` | Brand benefit rules |
| `chain_data` | Pharmacy chain data |
| `claimcompound` | Compound claim ingredients |
| `claim_fix_history_report` | Claim fix history |
| `activity_audit` | ETL activity audit log |
| `accumulator_missing_rxconnect_claims` | Missing RxConnect accumulator claims |
| `abc_account_description` | ABC account descriptions |

For the complete table and column list, see the full export: `../Enterprise Data Warehouse Data Schema.csv`
