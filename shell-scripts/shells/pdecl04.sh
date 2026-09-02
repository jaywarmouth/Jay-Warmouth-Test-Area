#!/bin/ksh
#       
# Program Name	: pdecl04.sh
# Description   : PDE File Creation
#                 Command line arguments:
#                 -f input file name 
#			/usr/lnk/pde/in/RPT.DDPS_TRANS_VALIDATION.<????????>
#                 -t test mode
# Author	: Peggy Voytilla
# Date		: 09/21/2011
# Modifications : 

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FILE="null"
TEST_MODE=0
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
RPT_DIR=/usr/lnk/misc

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl04.sh [-t] [-f <input-file>] 
	-t	test mode 	 optional
		(error report writes to alternate directory)
	-f <input file>		Required
		/usr/lnk/pde/in/RPT.DDPS_TRANS_VALIDATION.<????????>

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


# Submit pdecl04 program
submit_pdecl04()
{
     runcobol ${OBJ_DIR}/pdecl04 -s ${TEST_MODE} 
}

# Convert and email output report
send_report()
{
	RPT_FILE=`ls ${RPT_DIR}/PDECL04-TOTALS-*`
	enscript -rlg -a2- -f Courier9 --non-printable-format=space -o - ${RPT_FILE} | ps2pdf - ${RPT_FILE}.pdf
	echo "Output from pdecl04 process" | ${MAIL_PROG} -s "PDE Processes" ${MAIL_TO} -a ${RPT_FILE}.pdf
	rm -f ${RPT_FILE}.pdf
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
        usage
        exit 1
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
        if [ $# -le 0 ]
        then 
          usage
        fi
        FILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${FILE} = "null" ]
then
  usage
else
  PDERETURN=${FILE}
    export PDERETURN
fi


echo "PDE Return File Totals - pdecl04"
date
echo "EXPORT PATH:"
echo "   PDERETURN=$PDERETURN"
submit_pdecl04 

send_report

date

exit 0
