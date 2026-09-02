#!/bin/ksh
#
# Program Name	: claim96.sh
# Description	: Updates audit files to CLAIM00MAS.
#                 Command line arguments:
#                 -a Type of audit to update (all, dir, 16, 40, dmr, clm)
#                    clm is special case if wanting to update current days CLAIM02 file on Production system; the file is CLAIM02 without a date suffix.
#                 -d Date of audit file (yymmdd or yymmdd.<sys-name>) - Required
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
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
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
MAXVALUE=7

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: claim96.sh [-a all|dir|16|40|dmr|clm] -d [yymmdd|yymmdd.<sys-name>] -p [<path>] -u [########]

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
     "40" | "16" | "dir" | "all" | "dmr" | "clm")
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
   
#
# Submit claim96
submit_claim96()
{
       case ${AUDIT} in
         "dir")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[0]}${DATE}
            export AUDIT20MAS
	    echo "AUDIT20MAS=$AUDIT20MAS"
            runcobol ${OBJ_DIR}/claim96 -s ${SW} 
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[1]}${DATE}
            export AUDIT20MAS
	    echo "AUDIT20MAS=$AUDIT20MAS"
            runcobol ${OBJ_DIR}/claim96 -s ${SW} 
            ;;
         "16")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[4]}${DATE}
            export AUDIT20MAS
	    echo "AUDIT20MAS=$AUDIT20MAS"
            runcobol ${OBJ_DIR}/claim96 -s ${SW}
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[5]}${DATE}
            export AUDIT20MAS
	    echo "AUDIT20MAS=$AUDIT20MAS"
            runcobol ${OBJ_DIR}/claim96 -s ${SW} 
            ;;
         "40")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[2]}${DATE}
            export AUDIT20MAS
	    echo "AUDIT20MAS=$AUDIT20MAS"
            runcobol ${OBJ_DIR}/claim96 -s ${SW}
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[3]}${DATE}
            export AUDIT20MAS
	    echo "AUDIT20MAS=$AUDIT20MAS"
            runcobol ${OBJ_DIR}/claim96 -s ${SW} 
            ;;
         "dmr")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[6]}${DATE}
            export AUDIT20MAS
	    echo "AUDIT20MAS=$AUDIT20MAS"
            runcobol ${OBJ_DIR}/claim96 -s ${SW} 
            ;;
         "clm")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[7]}${DATE}
            export AUDIT20MAS
	    echo "AUDIT20MAS=$AUDIT20MAS"
            runcobol ${OBJ_DIR}/claim96 -s ${SW} 
            ;;
         "all")
            i=0
            while [ $i -le $MAXVALUE ]
            do
               if test -f ${AUDIT_PATH}/${FNAME[i]}${DATE}
               then
                 AUDIT20MAS=${AUDIT_PATH}/${FNAME[i]}${DATE}
                 export AUDIT20MAS
                 runcobol ${OBJ_DIR}/claim96 -s ${SW} 
               else
                 echo "${AUDIT_PATH}/${FNAME[i]}${DATE} does not exist"
               fi
               let i=i+1
            done
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

CLAIM00MAS=/usr/lnk/clm_01/CLAIM00MAS-512
export CLAIM00MAS
REVER00MAS=/usr/lnk/claims/REVER00MAS-512
export REVER00MAS

# Submit the program
submit_claim96

exit 0
