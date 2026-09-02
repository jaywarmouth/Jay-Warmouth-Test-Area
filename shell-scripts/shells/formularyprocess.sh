#!/bin/sh
#
# New 1/1/2024 formulary process
#

# Program Name  : formulary10, formulary11 
#                 Command line arguments:
#                 -p Parameter input file
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TPATH=/usr/lnk/wt/oper-wt/Formulary/In
DATETM=`date +%Y%m%d-%H%M%S`
MAIL_PROG=/usr/bin/mutt
MAIL_CC="operations@pdmi.com"
MAIL_TO="clinicalsupport@pdmi.com"
RETVAL=0
OUT_DIR=/usr/lnk/wt/oper-wt/Formulary/Out
MSG_DIR=/usr/lnk/wt/oper-wt/Formulary/Out/MSGFILES

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: formularyprocess.sh [-p <parmfile>] 

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

# Parse input parameter file (This section needs changed addressed).
parse_parmfile()
{
	YR_PATH=`cat ${PARM_FILE} | cut -c1-4`
	TIER=`cat ${PARM_FILE} | cut -c9`
	TMPTBL=`cat ${PARM_FILE} | cut -c11-18`
# Remove preceding zeros from table number provided in inout parameter file
	FORMTBL=$(echo "$TMPTBL" | sed 's/^0*//')
	TMPNAME=`cat ${PARM_FILE} | cut -c35-44`
# Remove spaces from formulary name provided in the input parameter file
	FORMNAME=$(echo "$TMPNAME" | sed 's/ //g')
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PARM_FILE=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Parse PARM_FILE
parse_parmfile

# Assign alternate environment variables

 FORMPARM=${PARM_FILE}
   export FORMPARM

 DRUGFRMMAS=${TPATH}/DRUGFRMMAS.${YR_PATH}.${TIER}TIER
   export DRUGFRMMAS

 F10MSGFILE=${MSG_DIR}/FORMULARY10-MSG-${FORMNAME}-${DATETM}.csv
 #F10MSGFILE=${MSG_DIR}/FORMULARY10-MSG-${TIER}TIER-${GEN_TAB}-${DATETM}.csv
   export F10MSGFILE

date
echo "formulary10 - Assign tiers and create drug work file"
echo "   TIER=${TIER}"
echo "   YEAR=${YR_PATH}"
echo "   FORMPARM=$FORMPARM"
echo "   DRUG000MAS=$DRUG000MAS"
echo "   DRUGFRMMAS=$DRUGFRMMAS"
echo "   GENTB00MAS=$GENTB00MAS"
echo "   F10MSGFILE=$F10MSGFILE"
echo "   NDCOM00MAS=$NDCOM00MAS"
echo ""
echo "Process formulary10 is starting." | ${MAIL_PROG} -s "Formulary Procedure Status for ${FORMNAME}" -c ${MAIL_CC} ${MAIL_TO}
runcobol ${OBJ_DIR}/formulary10
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
	echo "-*> Error with formulary10 program. Review $F10MSGFILE."
	exit $RETVAL
fi
echo "End formulary10"
echo "Process formulary10 is completed. Process formulary11 is starting." | ${MAIL_PROG} -s "Formulary Procedure Status for ${FORMNAME}" -c ${MAIL_CC} ${MAIL_TO}
date

#########################################################################################


# Assign alternate environment variables

 SORTPRIME=${TPATH}/SORTPRIME
   export SORTPRIME
 
# A static FORMQL file is now required (May 2024 - Ticket 21324) 
 FORMQL=/usr/lnk/log/FORMQL_20181201.txt; export FORMQL

 FORMPRIME=${OUT_DIR}/FORMULARY11-${YR_PATH}-${TIER}TIER-${FORMNAME}-${FORMTBL}-${DATETM}.txt
   export FORMPRIME

 F11MSGFILE=${MSG_DIR}/FORMULARY11-MSG-${FORMNAME}-${DATETM}.csv
 #F11MSGFILE=${MSG_DIR}/FORMULARY11-MSG-${TIER}TIER-${GEN_TAB}-${DATETM}.csv
   export F11MSGFILE

echo " "
echo "formulary11 - Create formulary file"
echo ""
echo "   TIER=${TIER}"
echo "   YEAR=${YR_PATH}"
echo "   FORMPARM=$FORMPARM"
echo "   DRUGFRMMAS=$DRUGFRMMAS"
echo "   GENTB00MAS=$GENTB00MAS"
echo "   STPTG00MAS=$STPTG00MAS"
echo "   SORTPRIME=$SORTPRIME"
echo "   FORMPRIME=$FORMPRIME"
echo "   F11MSGFILE=$F11MSGFILE"

date
runcobol ${OBJ_DIR}/formulary11
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
        echo "-*> Error with formulary11 program. Review $F11MSGFILE."
        exit $RETVAL
fi

 rm -f $DRUGFRMMAS
 rm -f $SORTPRIME

echo "End formulary11"
echo "Process formulary11 is completed." | ${MAIL_PROG} -s "Formulary Procedure Status for ${FORMNAME}" -c ${MAIL_CC} ${MAIL_TO}

#########################################################################################

date

exit $RETVAL


