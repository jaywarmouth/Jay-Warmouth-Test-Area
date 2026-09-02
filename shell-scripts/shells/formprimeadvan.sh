#!/bin/sh
#
# Process to create Prime/Advantage formulary files
#

# Program Name  : formulary10, formulary11, formulary13 
# Description   : Prime and Advantage - Create formulary files
#                 Command line arguments:
#                 -e <ESI Formulary File> 
#                 -p Parameter input file
#                 -x <ExclusionFile> Name of ESI Exclusion CSV input file
#                    Include exclusion logic (only use exclusion logic for advantage formularies)
# Author        : Peggy Voytilla
# Date          : 04/10/2018
# Modifications	: 12/27/2018 - TT18988-6; add FORMQL logic
#		: 01/21/2019 - TT18988-7
#		: 06/30/2020 - Add progress email notifications.
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
TPATH=/usr/lnk/wt/oper-wt/ESIFormulary/In
DATETM=`date +%Y%m%d-%H%M%S`
MAIL_PROG=/usr/bin/mutt
MAIL_CC="operations@pdmi.com"
MAIL_TO="clinicalsupport@pdmi.com"
RETVAL=0
EXCL_FLG=0
OUT_DIR=/usr/lnk/wt/oper-wt/ESIFormulary/Out
MSG_DIR=/usr/lnk/wt/oper-wt/ESIFormulary/Out/MSGFILES

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: formprimeadvan.sh [-p <parmfile>] [-y <yyyy>] [-t <tier value>] [-e <ESIFile>] [-g <generictable>] [-x <Exlusion Filename>]

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

# Parse input parameter file
parse_parmfile()
{
	YR_PATH=`cat ${PARM_FILE} | cut -c1-4`
	GEN_TAB=`cat ${PARM_FILE} | cut -c15-18`
	TIER=`cat ${PARM_FILE} | cut -c9`
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -e) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ESI_FILE=$1
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        PARM_FILE=$1
        ;;
    -x) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        EXCL_FILE=$1
	EXCL_FLG=1
        ;;
  esac
  shift
done

FORM_FNAME=`basename ${ESI_FILE}`

# Parse environment variables
parse_env

# Parse PARM_FILE
parse_parmfile

# Assign alternate environment variables

 FORMPARM=${PARM_FILE}
   export FORMPARM

 DRUGFRMMAS=${TPATH}/DRUGFRMMAS.${YR_PATH}.${TIER}TIER
   export DRUGFRMMAS

 F10MSGFILE=${MSG_DIR}/FORMULARY10-MSG-${TIER}TIER-${GEN_TAB}-${DATETM}.csv
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
echo "Process formulary10 is starting." | ${MAIL_PROG} -s "Formulary Procedure Status for ${FORM_FNAME}" -c ${MAIL_CC} ${MAIL_TO}
runcobol ${OBJ_DIR}/formulary10
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
	echo "-*> Error with formulary10 program. Review $F10MSGFILE."
	exit $RETVAL
fi
echo "End formulary10"
echo "Process formulary10 is completed. Process formulary11 is starting." | ${MAIL_PROG} -s "Formulary Procedure Status for ${FORM_FNAME}" -c ${MAIL_CC} ${MAIL_TO}
date

#########################################################################################


# Assign alternate environment variables

 SORTPRIME=${TPATH}/SORTPRIME
   export SORTPRIME
 
 FORMQL=`ls -1 ${TPATH}/FORMQL_????????.txt`
   export FORMQL

 FORMPRIME=${OUT_DIR}/FORMULARY11-${YR_PATH}-${TIER}TIER-${GEN_TAB}-${DATETM}.txt
   export FORMPRIME

 F11MSGFILE=${MSG_DIR}/FORMULARY11-MSG-${TIER}TIER-${GEN_TAB}-${DATETM}.csv
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
echo "   FORMQL=$FORMQL"
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
echo "Process formulary11 is completed. Process formulary13 is starting." | ${MAIL_PROG} -s "Formulary Procedure Status for ${FORM_FNAME}" -c ${MAIL_CC} ${MAIL_TO}

#########################################################################################


# Assign alternate environment variables

  IDXESI=${TPATH}/FORMIDXESI
    export IDXESI

  IDXPDM=${TPATH}/FORMIDXPDM
    export IDXPDM

  FORMEXCL=${EXCL_FILE}
    export FORMEXCL

  FORMESI=${ESI_FILE}
  export FORMESI

  CHGOUT=${OUT_DIR}/FORMULARY13-${YR_PATH}-DIFF-${TIER}TIER-${GEN_TAB}-${DATETM}.txt
    export CHGOUT

  ADDDEL=${OUT_DIR}/FORMULARY13-${YR_PATH}-ADD-DEL-${TIER}TIER-${GEN_TAB}-${DATETM}.txt
    export ADDDEL

  F13MSGFILE=${MSG_DIR}/FORMULARY13-MSG-${TIER}TIER-${GEN_TAB}-${DATETM}.csv
    export F13MSGFILE

echo " "
date
echo " "

echo "formulary13 - Compare ESI formulary vs Prime/Advantage Formulary "
echo "   DRUG000MAS=$DRUG000MAS"
echo "   FORMEXCL=$FORMEXCL"
echo "   FORMESI=$FORMESI"
echo "   FORMPRIME=$FORMPRIME"

echo "   IDXESI=$IDXESI"
echo "   IDXPDM=$IDXPDM"

echo "   F13MSGFILE=$F13MSGFILE"
echo "   ADDDEL=$ADDDEL"
echo "   CHGOUT=$CHGOUT"

runcobol ${OBJ_DIR}/formulary13 -s ${EXCL_FLG}
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
        echo "-*> Error with formulary13 program. Review $F13MSGFILE."
        exit $RETVAL
fi
echo " "

echo "End formulary13"
echo "Process formulary13 is completed." | ${MAIL_PROG} -s "Formulary Procedure Status for ${FORM_FNAME}" -c ${MAIL_CC} ${MAIL_TO}

 rm -f $IDXESI
 rm -f $IDXPDM
 rm -f $FORMQL


##################################################################################################


date

exit $RETVAL


