# Executive Summary: Claim111 Script Review

Repository reviewed: `jaywarmouth/Jay-Warmouth-Test-Area`
Folder reviewed: `shell-scripts`
Reference: https://github.com/jaywarmouth/Jay-Warmouth-Test-Area/tree/main/shell-scripts

## Purpose

We reviewed the shell scripts related to `claim111` to identify the business rules currently embedded in automation so they can be migrated into a more formal, configuration-driven process.

## Overall Conclusion

The scripts contain enough information to identify several important `claim111` workflows, including:
- client or trading partner context
- file naming conventions
- cycle/timing indicators
- packaging behavior
- some special handling rules
- transfer profile identifiers

However, the scripts do **not** fully define every delivery detail. In particular, the final destination settings and some client mappings are abstracted behind shared configuration and downstream programs.

## Key Workflows Identified

### 1. MedBen bi-weekly D.0 claims process
We identified a MedBen claims workflow that appears to:
- use the D.0 `claim111` format
- run on a pay/bi-weekly cycle
- generate a claims output associated with `HRMB`
- rename and zip the file
- include an invoice file in the transfer
- apply record formatting before transfer

This is one of the clearest examples of a business process that can be converted into a structured configuration entry.

### 2. MedBen weekly D.0 claims process for sponsor 2204
We identified a second MedBen workflow that appears to:
- use the D.0 `claim111` format
- run weekly
- be associated with sponsor `2204`
- use feed code `RTC`
- convert the source file and transfer it without visible zipping in the wrapper

### 3. MedBen pay-cycle D.0 claims process for sponsor 0361
We identified another MedBen workflow that appears to:
- use the D.0 `claim111` format
- run on a pay cycle
- be associated with sponsor `0361`
- use feed code `GHC`
- apply fixed record formatting and transfer the result

### 4. RXEOB operational workflows
We identified `claim111rx` processes that support:
- a daily operational run
- a twice-cycle operational run

These scripts clearly show scheduling/orchestration behavior, but not the full downstream delivery details.

## Deep Scan Update: Additional Client/Business Variants Beyond MedBen

A follow-up, deeper scan of `shell-scripts/` (including `env_var`) surfaced several additional `claim111`-family workflows not captured above. All paths are relative to the `shell-scripts/` folder unless noted.

### Core `claim111` engines (COBOL wrappers)
- `shells/claim111.sh` — original base-format wrapper; builds `CLAIM111KEY` suffixes (`-P/-D/-T/-W/-M/-Q`) per cycle (lines 169–192); calls `runcobol .../claim111`.
- `shells/claim111d0.sh` — D.0 (NCPDP D.0) variant; adds a `tweek` cycle; suffixes `CLAIM111KEY` with `-D0-P/D/T/W/M/Q/X` (lines 171–198); calls `runcobol .../claim111d0`. This is the variant used by nearly all active client wrappers below.
- `shells/claim111rx.sh` — RXEOB-specific variant; uses `CLAIM111RXKEY` (suffixed `-P/D/T/W/M/Q/X`, lines 152–181); calls `runcobol .../claim111rx`.
- `env_var:393` defines `CLAIM111KEY`, `env_var:394` defines `CLM111SUKEY` (a SummaCare-variant key), and `env_var:440` defines `CLAIM111RXKEY`. The `CLM111SUKEY` entry indicates a fourth variant, `claim111su.sh`, that is **not present** in this repository — it is only referenced by callers (see SummaCare row below).

### Client/business-specific variants beyond MedBen

| Client / Context | Script(s) | Key evidence |
|---|---|---|
| SummaCare | `shells/pay-week2.sh` (calls `claim111su.sh -c week`), `shells/pay2.sh` (changelog: "11/20/2003 - Added the claim111su procedure"), `shells/zip-week-suma.sh` (line 99: `zip ... ???CL111SU-P-SUMA ???SUMATEXT-SU-P`), `shells/rm-week-suma.sh` (line 97 cleanup) | A SummaCare-specific `claim111` variant (`su` = SummaCare), parallel to `claim111d0`/`claim111rx`. `claim111su.sh` and `tr-week-suma.sh` are referenced but not present in-repo. |
| RXEOB / ApproRx (twice cycle) | `shells/twice-files.sh`, `shells/twice-files.rxeob.sh` | Changelog line 19 of both: "01/22/2013 - Added claim111rx (for ApproRx)" — ApproRx is a business context served through the `claim111rx` pipeline on the twice cycle. |
| JHS | `shells/zip-twice.sh` line 26: "06/02/2008 - Added claim111 file for JHS" | JHS-specific claim111 output bundled into the twice-cycle zip archive via generic glob `???CL111*-T-*`; no dedicated wrapper script found in-repo. |
| LASH (daily D.0, sub-feeds LCOP/LSUN) | `shells/daily_lash.sh` (`EXTRACT_FILE_2="CL111DAYD0-?-LCOP"`, `EXTRACT_FILE_4="CL111DAYD0-?-LSUN"`); `shells/clms_lsun.sh` also exists | LASH is an umbrella client with named sub-feeds (LCOP, LSUN) drawn from the daily `claim111d0` output. |
| Retired daily D.0 clients | `shells/daily_claims_files.sh` line 57 (`cleanup()`) archives `???CL111DAYD0-?-CDB`, `-CKM`, `-MRTN`, `-LRBS`, `-VTX`, `-P-HSMT`, `-?-LASH`, `-?-AHF`, `-P-LVID`, `-P-ACR` | Ten client/feed codes historically tied to the daily `claim111d0` run, now moved to an "inactive" archive. |
| TrueRx (130-1177) | `shells/clms_trx_php.sh` | Changelog line 9: "03/26/2013 - Change from claim111d0 to clmrt01 format" — TrueRx/PHP was originally a `claim111d0` consumer but migrated off the claim111 family; `TR_ID="PHP"`. |
| Sisco (sponsor 1384) / TrueRx D.0 export | `shells/wkclms_spo1384.sh` | `CLM_FILE="TrueRxClaim111DZeroClaimsData_????????.xls"`, `TR_ID="SISCO"` — uploads a Reporting-Services-generated Excel export of `claim111d0` data (not the raw COBOL output); distinct from `clms_trx_php.sh`. |
| RXEOB (Georgia) | `shells/rxeob_bimon_clms.sh`, `shells/rxeob_biwkly_clms.sh`, `shells/rxeob_biwkly_revs.sh`, `shells/rxeob_twice_revs.sh`, `shells/rxeob.sh` | All use `TR_ID="RXEOB-GA"`; source files `???CL111RX-T-RXEOB`, `???CL111RX-P-RXEOB` (claim111rx output). |
| RXEOB (base) weekly/tweek | `shells/rxeob_wkly_clms.sh` (`TAPE_FILE=???CL111RX-W-RXEOB`, `TR_ID="RXEOB"`), `shells/rxeob_tweek_clms.sh` (`TAPE_FILE=???CL111RX-X-RXEOB`, `TR_ID="RXEOB"`) | Distinct transfer profile `RXEOB` vs `RXEOB-GA` — two separate destinations for the same client family. |
| MedBen (sponsor 2204, feed RTC) | `shells/clms_2204_claim111d0.sh` and near-duplicate `shells/clms_trx_medb_claim111d0.sh` | Both scripts are near-identical, suggesting a rename/duplication during a "TRX" (feed) renaming project. |

### Cycle-orchestration wrappers
- `shells/daily_claims_files.sh` / `shells/daily_proc.sh` — call `claim111d0.sh -c day` and `claim111rx.sh -c day`.
- `shells/pay-files.sh` — calls `claim111rx.sh -c pay` and `claim111d0.sh -c pay`.
- `shells/week-files.sh` — calls `claim111d0.sh -c week`.
- `shells/twice-files.sh` / `twice-files.rxeob.sh` — call `claim111d0.sh -c twice` and `claim111rx.sh -c twice`.
- `shells/tweek-files.sh` — historically called `claim111d0.sh` for the tweek cycle (removed 01/24/2020 per its changelog).
- `shells/pay-week2.sh` — calls `claim111su.sh -c week` (SummaCare-only pipeline).
- Cleanup/archival counterparts `shells/rm-pay.sh`, `rm-tweek.sh`, `rm-twice.sh`, `rm-week.sh`, `rm-week-suma.sh` and `shells/zip-pay.sh`, `zip-tweek.sh`, `zip-twice.sh`, `zip-week.sh`, `zip-week-suma.sh` all reference `CLAIM111KEY`, `CLAIM111RXKEY`, and `???CL111*` tape-file globs to purge/archive each cycle's claim111 artifacts and key files.

### Additional shared utilities/config
- `env_var` — defines `CLAIM111KEY` (line 393), `CLM111SUKEY` (394), `CLAIM111RXKEY` (440); sourced by every `claim111*.sh` wrapper via `ENV_FILE=/usr/lnk/shell/env_var`.
- `shells/secure_transfer.sh` — shared transfer engine invoked by nearly every client wrapper. It reads transfer-profile records from an **external** config file, `/usr/local/pub/secure_transfer.cfg` (line 7), not present in this repository. Distinct `TR_ID` values found: `MEDBEN`, `MEDB`, `PHP`, `SISCO`, `RXEOB`, `RXEOB-GA` — note `RXEOB` and `RXEOB-GA` are two separate destinations for the same client family.
- `/usr/local/bin/addlf` — shared fixed-record-length conversion utility used by several MedBen/TrueRx wrappers to reformat raw claim111(d0) tape output before transfer.

## What the Scripts Tell Us Reliably

From the scripts alone, we can confidently extract:
- `claim111` variants:
  - base
  - D.0
  - RXEOB
  - SummaCare (`claim111su`, referenced only; source not in-repo)
- cycle types:
  - pay
  - day
  - week
  - month
  - quarter
  - twice
  - tweek
- output naming conventions for several MedBen, RXEOB, LASH, and Sisco/TrueRx workflows
- file preparation rules such as:
  - line/record conversion
  - fixed record lengths
  - zipping in some flows
  - invoice bundling in at least one flow
- transfer profile IDs: `MEDBEN`, `MEDB`, `PHP`, `SISCO`, `RXEOB`, `RXEOB-GA`

## What the Scripts Do Not Fully Tell Us

The review also showed that some critical delivery details are not embedded directly in the scripts, including:
- exact remote destination paths
- host and protocol details for each transfer profile
- all client mappings behind shared key variables
- full file layout/business content rules inside the downstream programs
- the SummaCare `claim111su.sh`/`tr-week-suma.sh` script bodies (referenced but not present in this repository)
- the COBOL source for `claim111`, `claim111d0`, `claim111rx`, and `claim111su` (only compiled objects invoked via `runcobol`)

## Important Architecture Finding

The actual transfer destinations are not hardcoded in most wrappers. Instead, the scripts call a shared transfer utility that reads an external configuration file. This means the current process is already partly configuration-driven, but the configuration is split across:
- wrapper scripts
- transfer configuration
- environment variables
- underlying processing programs

## Business Recommendation

A modern replacement should treat each `claim111` workflow as a configuration record with fields such as:
- client
- sponsor/feed
- format/variant
- cycle
- source file pattern
- transformation rules
- output naming
- packaging rules
- transfer profile
- notification rules

## Recommended Next Steps

To complete the migration design, the next review should focus on:
1. the shared secure transfer configuration
2. environment variables used by `claim111` wrappers
3. the underlying `claim111` processing programs

## Current Bottom Line

The repository already provides enough evidence to define several initial configuration-driven `claim111` tasks, especially for MedBen-related D.0 workflows. Additional review of shared transfer/config layers will be needed to fully reconstruct destination and delivery behavior.
