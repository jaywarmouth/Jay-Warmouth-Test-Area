#!/bin/ksh
#
# Program Name  : dly_pmsi_pharm.sh
# Description   : PMSI Pharmacy File Update
#                 Command line arguments:
#		  -d date of file (mmdd)
#		  -t test flag
# Author        : Mike Paulus
# Date          : 09/27/2007
# Modifications : 03/20/2008 - Updated logic  (LSJ)
#		: 04/10/2008 - Added logic for .lin file  (LSJ)
#		: 04/18/2008 - Added missing "exit 1" under run_ncpdppmsi when input file is not found  (LSJ)
#		: 06/05/2008 - Removed logic that checked and stopped processing if ERRORs in ncpdppmsi or phnet20 processes.  (LSJ)
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
ELIG_DIR="/usr/lnk/elig_in"
ELIG_OUT="/usr/lnk/elig_in_1"
PHARM_DIR="/usr/upd/pharm/pmsi"
DATE="null"
SYS="0103"
CLIENT="ps"
SHELL="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
AUDIT_DIR="/usr/lnk/audit"
REMOTE_SYS="husk"
REMOTE_DIR="/usr/lnk/shares/ftp-tmp"
PMSIREPORT="PMSIREPORT"
TR_PROG="/usr/lnk/shell/pmsi_pharm_files.sh"
TMP_DIR=/tmp
TEST=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dly_pmsi_pharm.sh -d <mmdd> -t
	-d <mmdd> - <mmdd> is date of psn file	(required)
	-t        - test flag	(optional)

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
    IFS=${CR}
    for VAR in `cat ${ENV_FILE}`
    do
        eval ${VAR} 2> /dev/null
        IFS=${EQUAL}
        set $VAR
        NVAR=$1
        export ${NVAR}
        if [ $? -ne 0 ]
        then
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Process Reports
process_rpts()
{
	lp ${RPT_DIR}/ncpdppmsi
	lp ${PMSIADDRPT}-${DATE}
	lp ${PMSICHGRPT}-${DATE}
	lp ${PMSIERROR}-${DATE}
	lp ${RPT_DIR}/phnet20
	lp ${PHNET20RPT}-${DATE}
	scp -q ${PMSIREPORT}-${DATE} ${REMOTE_SYS}:${REMOTE_DIR}/PMSIREPORT
	if test $? -eq 0
	then
		transfer_rpt
	else
		echo "-*> scp of PMSIREPORT failed"
		echo "-*> will need to fix and run /usr/lnk/shell/pmsi_pharm_files.sh"
	fi		
	echo "Report files are available in /usr/upd/pharm/pmsi"
}	
	

#
# Transfer load report to PMSI
transfer_rpt()
{
	echo "--> Encrypting and transferring file"
	if [ $TEST = 1 ]
	then
		ssh -q ${REMOTE_SYS} "${TR_PROG} -t"
	else
		ssh -q ${REMOTE_SYS} "${TR_PROG}"
	fi
}

#
# Cleanup
cleanup()
{
	rm -f ${ELIG_DIR}/${CLIENT}n${DATE}
	rm -f ${ELIG_DIR}/${CLIENT}n${DATE}.lin
	mv ${ELIG_OUT}/${CLIENT}n${DATE} ${ELIG_OUT}/sys${SYS}
}

# Submit ncpdppmsi program
run_ncpdppmsi()
{
     if test -s ${ELIG_DIR}/${CLIENT}n${DATE}.lin
     then
	${SHELL}/ncpdppmsi.sh -d ${DATE} > ${RPT_DIR}/ncpdppmsi 2>&1
	#grep " ERROR" ${RPT_DIR}/ncpdppmsi > ${TMP_DIR}/ncpdppmsi-errors
	#if test -s ${TMP_DIR}/ncpdppmsi-errors
	#then
	#	echo "** The run of ncpdppmsi.sh had the following errors."
	#	echo "** This process is stopping abnormally."
	#	cat ${TMP_DIR}/ncpdppmsi-errors
	#	exit 1
	#fi
     else
	echo "-*> The input file for ncpdppmis is zero or does not exist..."
	echo "-*> This procedure is aborting. This needs resolved to continue."
	exit 1
     fi
}

# Submit phnet20 program
run_phnet20()
{
	${SHELL}/phnet20.sh -f > ${RPT_DIR}/phnet20 2>&1
	#grep "ERROR" ${RPT_DIR}/phnet20 > ${TMP_DIR}/phnet20-errors
        #if test -s ${TMP_DIR}/phnet20-errors
        #then
        #        echo "** The run of phnet20.sh had the following errors."
        #        echo "** Let supervisor or programming know."
        #        cat ${TMP_DIR}/phnet20-errors
	#	exit 1
        #fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	DATE=$1
	;;
    -t) TEST=1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

#umask 000

echo "--> Running ncpdppmsi - Updating PHDEM"
run_ncpdppmsi

echo "--> Running phnet20 - Updating PHNET"
run_phnet20

# Handle reports
echo ""
echo "--> Processing Reports..."
process_rpts


# Cleanup
echo ""
echo "--> Doing Cleanup..."
cleanup

# Zip Archive Files
echo ""
echo "--> Archive NPI file..."
${SHELL}/zip_arch_elig.sh -t npi -c ${CLIENT} -d ${DATE} -s ${SYS}

exit 0
