#!/bin/ksh
#
# Program Name	: claim96.sh
# Description	: Updates audit files to CLAIM00MAS.
#                 Command line arguments:
#                 -a Type of audit to update (all, dir, 16, 40, dmr, clm, msg, rst)
#                    clm is special case if wanting to update current days CLAIM02 file on Production system; the file is CLAIM02 without a date suffix.
#                 -d Date of audit file (ccyymmdd or ccyymmdd.<sys-name>) - Required
#                 -p Audit path to read from - Required (e.g. /usr/lnk/audit)
#                 -u Assign alternate update switches (########) - Optional
#                    If this option is not used it assumes 00000010 for full update:
#                    SWITCH 1 - OVERIDE
#                    SWITCH 2 - REVERSAL
#                    SWITCH 3 - EXCEPTION/ONETM
#                    SWITCH 4 - CLAIM
#                    SWITCH 5 - LIMIT/RXLIM
#                    SWITCH 6 - CLAIM80
#                    SWITCH 7 - FULL UPDATE
#                    SWITCH 8 - CARDI
# Author	: Linda Jefferis
# Date		: 03/14/97
# Modifications : 02/24/2003 - Changes for new ssc type claims  (LSJ)
#                 05/04/2004 - Changes for new pao - prior auth overrides (JM)
#		: 10/12/2005 - Addition of updates of ONETM00MAS  (LSJ)
#		: 03/20/2006 - Added AUDIT-92 and removed AUDIT-97  (LSJ)
#		: 01/14/2010 - Changed logic for "all" option to include clm and removed AUDIT-89  (LSJ)
#		: 03/08/2012 - Add logic for new MSG audit files
#		: 02/07/2013 - Add logic for "rst" restack process
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/tst/alphagpi"
AUDIT_PATH="none"
AUDIT="none"
DATE="none"
SW="00000010"
FNAME[0]="AUDIT-400-"
FNAME[1]="AUDIT-401-"
FNAME[2]="AUDIT-300-"
FNAME[3]="AUDIT-301-"
FNAME[4]="AUDIT-200-"
FNAME[5]="AUDIT-201-"
FNAME[6]="DMR-"
FNAME[7]="CLAIM02-"
FNAME[8]="MSG-400-"
FNAME[9]="MSG-401-"
FNAME[10]="MSG-300-"
FNAME[11]="MSG-301-"
FNAME[12]="MSG-200-"
FNAME[13]="MSG-201-"
MSGFILES=13
MAXVALUE=13
RST_DIR=/usr/lnk/restack

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim96.sh [-a all|dir|16|40|dmr|clm|msg|rst] -d [yymmdd|yymmdd.<sys-name>] -p [<path>] -u [########]

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#validate -a options
validate_audit()
{  case ${AUDIT} in
     "40" | "16" | "dir" | "all" | "dmr" | "clm" | "msg" | "rst")
                          ;;
     *)  usage
         ;;
   esac
}

# Check Required options
check_options()
{
   if [ ${AUDIT} = "none" ]
   then
      usage
   fi
   if [ ${DATE} = "none" ]
     then
       usage
   fi
   if [ ${AUDIT_PATH} = "none" ]
     then
       usage
   fi
}

# Restack
restack_setup()
{
	PDECL00RST=${RST_DIR}/PDECL00RST
	CLCOB00RST=${RST_DIR}/CLCMP00RST
	CLCMP00RST=${RST_DIR}/CLCMP00RST
	CLMSG00RST=${RST_DIR}/CLMSG00RST
	RESTK00RST=${RST_DIR}/RESTK00RST
	CLMRS00RST=${RST_DIR}/CLMRS00RST
	CLWRK00RST=${RST_DIR}/CLWRK00RST
	cp ${PDECL00RST}-NULL ${PDECL00RST}
	cp ${CLCOB00RST}-NULL ${CLCOB00RST}
	cp ${CLCMP00RST}-NULL ${CLCMP00RST}
	cp ${CLMSG00RST}-NULL ${CLMSG00RST}
	cp ${RESTK00RST}-NULL ${RESTK00RST}
	cp ${CLMRS00RST}-NULL ${CLMRS00RST}
	cp ${CLWRK00RST}-NULL ${CLWRK00RST}
	PDECL00MAS=${PDECL00RST}; export PDECL00MAS
	CLCOB00MAS=${CLCOB00RST}; export CLCOB00MAS
	CLCMP00MAS=${CLCMP00RST}; export CLCMP00MAS
	CLMSG00MAS=${CLMSG00RST}; export CLMSG00MAS
	RESTK00MAS=${RESTK00RST}; export RESTK00MAS
	CLMRS00MAS=${CLMRS00RST}; export CLMRS00MAS
	CLLOC00MAS=${RST_DIR}/CLLOC00RST; export CLLOC00MAS
	AUDIT20MAS=${AUDIT_PATH}/${FNAME[1]}${DATE}; export AUDIT20MAS
	CLAIM00MAS=${CLWRK00RST}; export CLAIM00MAS
	echo "CLAIM00MAS=$CLAIM00MAS"
	echo "CLLOC00MAS=$CLLOC00MAS"
	echo "CLMRS00MAS=$CLMRS00MAS"
	echo "RESTK00MAS=$RESTK00MAS"
	echo "CLMSG00MAS=$CLMSG00MAS"
	echo "CLCMP00MAS=$CLCMP00MAS"
	echo "CLCOB00MAS=$CLCOB00MAS"
	echo "PDECL00MAS=$PDECL00MAS"
}
   
#
# Submit claim96
submit_claim96()
{
       case ${AUDIT} in
         "dir")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[0]}${DATE}
            export AUDIT20MAS
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s ${SW} 
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[1]}${DATE}
            export AUDIT20MAS
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s ${SW} 
            ;;
         "16")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[4]}${DATE}
            export AUDIT20MAS
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s ${SW}
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[5]}${DATE}
            export AUDIT20MAS
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s ${SW} 
            ;;
         "40")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[2]}${DATE}
            export AUDIT20MAS
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s ${SW}
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[3]}${DATE}
            export AUDIT20MAS
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s ${SW} 
            ;;
         "dmr")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[6]}${DATE}
            export AUDIT20MAS
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s ${SW} 
            ;;
         "clm")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[7]}${DATE}
            export AUDIT20MAS
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    echo "CLAIM00MAS=$CLAIM00MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s ${SW} 
            ;;
         "msg")
	    i=8
            while [ $i -le $MSGFILES ]
            do
		if test -f ${AUDIT_PATH}/${FNAME[i]}${DATE}
		then
            		AUDIT20MAS=${AUDIT_PATH}/${FNAME[i]}${DATE}
            		export AUDIT20MAS
	    		echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    		date
            		runcobol ${OBJ_DIR}/claim96exc -s ${SW} 
		else
                 echo "${AUDIT_PATH}/${FNAME[i]}${DATE} does not exist"
               fi
               let i=i+1
            done
            ;;
         "all")
            i=0
            while [ $i -le $MAXVALUE ]
            do
               if test -f ${AUDIT_PATH}/${FNAME[i]}${DATE}
               then
                 AUDIT20MAS=${AUDIT_PATH}/${FNAME[i]}${DATE}
                 export AUDIT20MAS
		 echo -e "\nAUDIT20MAS=$AUDIT20MAS" 
	    	 date
                 runcobol ${OBJ_DIR}/claim96exc -s ${SW} 
               else
                 echo "${AUDIT_PATH}/${FNAME[i]}${DATE} does not exist"
               fi
               let i=i+1
            done
            ;;
         "rst")
	    restack_setup
	    echo -e "\nAUDIT20MAS=$AUDIT20MAS"
	    date
            runcobol ${OBJ_DIR}/claim96exc -s 00010000 
            ;;
        esac
}
   
#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -a) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        AUDIT=$1
        validate_audit
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        AUDIT_PATH=$1
        ;;
    -u) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        SW=$1
        ;;
  esac
  shift
done

# Check required options
check_options

# Parse environment variables
parse_env

EXCEP00MAS=/usr/lnk/tst/alphagpi/NEWEXCEP
export EXCEP00MAS

date

# Submit the program
submit_claim96

date

exit 0
