#!/bin/ksh
#
# Program Name  : mac005.sh
# Description   : Update mac table table 20 from XLS macro file
#		  Command Line Arguments:
# Author        : Joe Novicky
# Date          : 04/01/2015
# Modifications : 05/06/2015 - Changes/Additions for production (LSJ)
#		: 06/18/2015 - Change email notification logic.
#                
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RPT_DIR="/tmp"
FILE_DIR="/usr/lnk/wt/pharmacy-wt/macupdates/in"
ARCH_DIR="/usr/lnk/wt/pharmacy-wt/macupdates/arch"
DATETM=`date +%Y%m%d%H%M%S`
MAIL_PROG="/usr/bin/mutt"
PHARM_MAIL="mgonzalez@pdmi.com,americle@pdmi.com"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: mac005.sh 

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


# Submit mac005 program
submit_mac005()
{

        echo ${DATE}
        runcobol ${OBJ_DIR}/mac005  

}

# Process reports
process_rpt()
{
        a2ps -1l132 -a2- --print-anyway=1 --non-printable-format=blank -o - ${PRTRPT01} | ps2pdf - ${PRTRPT01}.pdf
        a2ps -1l132 -a2- --print-anyway=1 --non-printable-format=blank -o - ${ERRRPT01} | ps2pdf - ${ERRRPT01}.pdf
}

# Move files to archive folder
arch_files()
{
	mv ${PRTRPT01}* ${ARCH_DIR}
	mv ${ERRRPT01}* ${ARCH_DIR}
	mv ${MAC20UPD01} ${ARCH_DIR}
}

#
# Main routine
#
# Check command line validity, call usage if incorrect


# Parse environment variables
parse_env

umask 000

# Assign alternate environment variables
MACUPDATES=/usr/upd/drug/MAC005_MACUPDATES;export MACUPDATES
MAC20UPD01=${FILE_DIR}/`ls -1 ${FILE_DIR}`

if test -s ${MAC20UPD01}
then
	export MAC20UPD01
else
	echo "There is an issue with the file uploaded to the macupdates/in location. The mac005 process cannot be run." | ${MAIL_PROG} -s "MAC Updates" ${PHARM_MAIL}
	exit 1
fi
PRTRPT01=${RPT_DIR}/MAC005_PRTRPT-${DATETM};export PRTRPT01
ERRRPT01=${RPT_DIR}/MAC005_ERRRPT-${DATETM};export ERRRPT01
 

echo "Update mac table 20 from csv"
echo "MAC20UPD01=$MAC20UPD01"
date
submit_mac005

process_rpt

arch_files

echo "Review reports in pharmacy-wt/macupdates/arch location. Provide IT Operations a ticket task if okay to proceed with update." | ${MAIL_PROG} -s "MAC Update" -b ljefferis@pdmi.com ${PHARM_MAIL}

date

exit 0
