#!/bin/ksh
# NOTE: CARDH29V2_PARM now includes trailing ";B" for the new parameter value.
#
# Program Name	: cardh29.sh
# Description   : cardh29 Eligibility 
#                 Command line arguments:
#                   -c Client Abbrev. (2 characters)
#                   -d date of file (mmdd or mmdd.###)
#		    -f <directory/filename> Assign alternate CARDH29TAP
#			default is $CARDH29_DIR/$CLIENTe$DATE
# Author	: Linda S. Jefferis
# Date		: 08/20/97
# Modifications : 11/14/2006 - Removed all extraneous logic that is now in process_elig.sh or other scripts  (LSJ)
#                 T02920 - 05/12/2026 - SG - EXTRONETM00MAS,extronetm00mas,EXTRCATAB00MAS,extrcatab00mas,EXTRCAWCA00MAS,extrcawca00mas,EXTRCARDH00MAS,extrcardh00mas,CARDH29,ELGRT03,cardh29,elgrt03 - Parallel testing for Eligibility batch / RTE load in RDS (Phase 1) -(TD-14954) - 581
#		 
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
FG4AUD_DIR=/usr/lnk/audit
AUDNAME="CRDAUD"
CARDH29_DIR="/usr/lnk/elig_in"
DATE="null"
DATETM=`date +%Y%m%d%h%m`
CLIENT="null"
RPT_DIR="/usr/lnk/elig_out"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cardh29.sh -c <client abbrev.> -d <mmdd> -f <filename> 
	-c <2-character client abbreviation>	required
	-d <mmdd>				required
	-f <full directory and filename>	optional
		Default name is $CARDH29_DIR/$CLIENTe$DATE

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


#
#transfer report files
transfer_report_files()
{
  export CLIENT                            # Client identifier
  export SYS                               # System identifier
  export PRINT29_FILE="${PRINT29_REPORT}"  # Absolute path to PRINT29 file
  export CA29_FILE="${CA29_REPORT}"        # Absolute path to CA29 file

  # Path to transfer system
  TRANSFER_SYSTEM_PATH="/usr/lnk/shell"

  # Call the transfer system
  if [[ -f "$TRANSFER_SYSTEM_PATH/multi_report_transfer.sh" ]]; then
      "$TRANSFER_SYSTEM_PATH/multi_report_transfer.sh"
      if [[ $? -eq 0 ]]; then
          echo "Transfer System called successfully"
      else
          echo "Transfer failed"
          exit 1
      fi
  else
      echo "Transfer system not found at: $TRANSFER_SYSTEM_PATH"
      exit 1
  fi
}



#
# Submit cardh29v2 program
submit_cardh29()
{
     echo $CARDH29V2PARAM
     echo $CHGFILEFLAG
     runcobol ${OBJ_DIR}/cardh29 -a ${CLIENT}e${DATE}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
if [ $# -lt 4 ]
then
	usage
	exit 0
fi

while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLIENT=$1
        ;;
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
    -f) shift
	if [ $# -le 0 ]
	then
	  usage
	fi
	FILE_FLG=1
	FILE=$1
	;;
    -s) shift
	if [ $# -le 0 ]
	then
	  usage
	fi
	SYS=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env


batch_number=`shuf -i 00000001-999999999 -n 1 |xargs printf "%08d\n"`

# Below variable is for providing required input to program
# Format is 4 fields separated by a ";" and the order/description of the 4 fields are:
#    System number (4-digits)
#    Batch number - random generated number from above
#    Path and name of the CA29 detail output report
#    Path and name of the error/summary output report
CARDH29V2_PARM="${SYS};${batch_number};${RPT_DIR}/sys${SYS}/CA29-${CLIENT}e${DATE}.txt;${RPT_DIR}/sys${SYS}/PRINT-29-${CLIENT}e${DATE}.txt;B"
export CARDH29V2_PARM

PRINT29_REPORT=${RPT_DIR}/sys${SYS}/PRINT-29-${CLIENT}e${DATE}.txt
CA29_REPORT=${RPT_DIR}/sys${SYS}/CA29-${CLIENT}e${DATE}.txt


umask 002

# Set Internal Variables
FG4AUD=${FG4AUD_DIR}/${AUDNAME};export FG4AUD
if [ $FILE_FLG = 1 ]
then
	CARDH29TAP=$FILE
	export CARDH29TAP
else
	CARDH29TAP=${CARDH29_DIR}/${CLIENT}e${DATE}
	export CARDH29TAP
fi


# Submit Cardh29v2
submit_cardh29 

transfer_report_files

exit 0
