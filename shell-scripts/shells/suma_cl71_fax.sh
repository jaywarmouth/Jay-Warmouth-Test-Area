#!/bin/ksh
#
# Program Name	: suma_cl71_fax.sh
# Description	: Notification via fax of Summa Medicaid(claim71) tape send.
#		  Command Line Arguments:
#		  -t tape number
#		  -n number of claims
#		  -d <mmddccyy> - date tape sent
# Author	: Linda Jefferis	
# Date		: 11/19/1998
# Modifications : 08/04/99 - Added '-d' option and associated logic  (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TAPE="null"
CLAIMS="null"
DATE=`date +%m%d%Y`
LOG="/usr/lnk/tapes/suma_fax.log"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: suma_cl71_fax.sh [-t <#####>] [-n <#####>] [-d <mmddccyy>]

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    OLDIFS=${IFS}
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
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        TAPE=$1
        ;;
    -n) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        CLAIMS=$1
        ;;
    -d) shift
	if [ $# -le 0 ]
	then
	  usage
	fi
	DATE=$1
	;;
  esac
  shift
done

# Parse environment variables
#parse_env

if [ ${TAPE} = "null" -o ${CLAIMS} = "null" ]
then
   usage
else
   echo > ${LOG}
   echo >> ${LOG}
   echo "A Medicaid claims tape has been sent from PDM to ODOHS" >> ${LOG}
   echo "---------------------------------------------------------" >> ${LOG}
   echo >> ${LOG}
   echo "Tape Number:  "${TAPE} >> ${LOG}
   echo "Number of claims:  "${CLAIMS} >> ${LOG}
   echo "Date Sent:  "${DATE} >> ${LOG}
   FAXFROM="PDM: Operations"
   fax "Ruth Tallman" ${LOG} 13309968415
fi
exit 0
