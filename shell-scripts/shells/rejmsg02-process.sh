#!/bin/sh

INDIR=/usr/lnk/wt/oper-wt/QATesting
OUTDIR=/usr/lnk/wt/oper-wt/misc
RPTDIR=/usr/lnk/rpt

/usr/lnk/shell/rejmsg02.sh -i ${INDIR}/SPO4650-occ3-rejmsg.txt -o ${OUTDIR}/Prod-SPO4650-occ3-rejmsg02.csv -r ${OUTDIR}/Prod-SPO4650-occ3-errorrpt.csv >> ${RPTDIR}/prod-rejmsg02-20240827 2>&1
/usr/lnk/shell/rejmsg02.sh -i ${INDIR}/SPO4650-occ8-rejmsg.txt -o ${OUTDIR}/Prod-SPO4650-occ8-rejmsg02.csv -r ${OUTDIR}/Prod-SPO4650-occ8-errorrpt.csv >> ${RPTDIR}/prod-rejmsg02-20240827 2>&1
/usr/lnk/shell/rejmsg02.sh -i ${INDIR}/SPO4651-occ3-rejmsg.txt -o ${OUTDIR}/Prod-SPO4651-occ3-rejmsg02.csv -r ${OUTDIR}/Prod-SPO4651-occ3-errorrpt.csv >> ${RPTDIR}/prod-rejmsg02-20240827 2>&1
/usr/lnk/shell/rejmsg02.sh -i ${INDIR}/SPO4651-occ8-rejmsg.txt -o ${OUTDIR}/Prod-SPO4651-occ8-rejmsg02.csv -r ${OUTDIR}/Prod-SPO4651-occ8-errorrpt.csv >> ${RPTDIR}/prod-rejmsg02-20240827 2>&1
/usr/lnk/shell/rejmsg02.sh -i ${INDIR}/SPO4657-occ3-pd-msg.txt -o ${OUTDIR}/Prod-SPO4657-occ3-rejmsg02.csv -r ${OUTDIR}/Prod-SPO4657-occ3-errorrpt.csv >> ${RPTDIR}/prod-rejmsg02-20240827 2>&1
