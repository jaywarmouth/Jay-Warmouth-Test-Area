#!/bin/ksh
#
# Program Name	: convcl01.sh
# Description	: Updates NON-Y2K audit files to Y2K CLAIM00MAS files.
#                 Command line arguments:
#                 -a Type of audit to update (all, dir, env, ndc, dmr, clm)
#                    all - includes dir,env,ndc,dmr. Not clm.
#                    clm is special case since name on Prod. machine is CLAIM02 without a date suffix.
#                 -d Date of audit file (yymmdd) - Required
#                 -p Audit path to read from - Required (e.g. /usr/ncr3550/audit)
# Author	: Linda Jefferis
# Date		: 03/26/99
# Modifications : 
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
FNAME[0]="AUDIT-91-"
FNAME[1]="AUDIT-93-"
FNAME[2]="AUDIT-94-"
FNAME[3]="AUDIT-95-"
FNAME[4]="AUDIT-96-"
FNAME[5]="DMR-"
FNAME[6]="CLAIM02-"
MAXVALUE=5

# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: convcl01.sh [-a all|dir|env|ndc|dmr|clm] -d [yymmdd] -p [<path>]

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
     "ndc" | "env" | "dir" | "all" | "dmr" | "clm")
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
# Submit convcl01
submit_convcl01()
{
       case ${AUDIT} in
         "dir")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[0]}${DATE}
            export AUDIT20MAS
	    echo ""
	    echo "AUDIT20MAS=${AUDIT20MAS}"
	    echo ""
            runcobol ${OBJ_DIR}/convcl01
            ;;
         "env")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[3]}${DATE}
            export AUDIT20MAS
	    echo ""
	    echo "AUDIT20MAS=${AUDIT20MAS}"
	    echo ""
            runcobol ${OBJ_DIR}/convcl01
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[4]}${DATE}
            export AUDIT20MAS
	    echo ""
	    echo "AUDIT20MAS=${AUDIT20MAS}"
	    echo ""
            runcobol ${OBJ_DIR}/convcl01
            ;;
         "ndc")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[1]}${DATE}
            export AUDIT20MAS
	    echo ""
	    echo "AUDIT20MAS=${AUDIT20MAS}"
	    echo ""
            runcobol ${OBJ_DIR}/convcl01
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[2]}${DATE}
            export AUDIT20MAS
	    echo ""
	    echo "AUDIT20MAS=${AUDIT20MAS}"
	    echo ""
            runcobol ${OBJ_DIR}/convcl01
            ;;
         "dmr")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[5]}${DATE}
            export AUDIT20MAS
	    echo ""
	    echo "AUDIT20MAS=${AUDIT20MAS}"
	    echo ""
            runcobol ${OBJ_DIR}/convcl01
            ;;
         "clm")
            AUDIT20MAS=${AUDIT_PATH}/${FNAME[6]}${DATE}
            export AUDIT20MAS
	    echo ""
	    echo "AUDIT20MAS=${AUDIT20MAS}"
	    echo ""
            runcobol ${OBJ_DIR}/convcl01
            ;;
         "all")
            i=0
            while [ $i -le $MAXVALUE ]
            do
               if test -f ${AUDIT_PATH}/${FNAME[i]}${DATE}
               then
                 AUDIT20MAS=${AUDIT_PATH}/${FNAME[i]}${DATE}
                 export AUDIT20MAS
	    	 echo ""
	    	 echo "AUDIT20MAS=${AUDIT20MAS}"
	    	 echo ""
                 runcobol ${OBJ_DIR}/convcl01
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
  esac
  shift
done

# Check required options
check_options

# Parse environment variables
parse_env

# Set alternate variables


# Submit the program
submit_convcl01

exit 0
