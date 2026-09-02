#!/bin/sh
#
# to run: CRERXCONNECTREC
#
# Program Name  : CRXCONNECTREC 
# Author        : SGUPTA
# DESCRIPTION   : This shell execute CRECONNECTREC program,which create JSON document with request, response and process json.
# FREQUENCY     : Restarted using in every n Secs.
#
#
#===========================================================================
#DATE              PROGRAMMER                            DESCRIPTION
#===========================================================================
#
#06/21/2021        SGUPTA                                INITIAL VERSION
#
#===========================================================================
#
#================
#
# Variables Used:
#
#================
#
PROGNAME=${0##*/}
VERSION="1.0"
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
#==
OBJ_DIR="/usr/lnk/obj"
RUNPATH="/usr/lnk/obj"
#==
DATETM=`date -d "1 day ago" +%Y%m%d`
RETVAL=0
#==
MAIL_PROG="/usr/bin/mutt"
MAIL_SUBJ="${PROGNAME} Exited Abnormally."
MAIL_CC="sgupta@pdmi.com"
MAIL_TO="sgupta@pdmi.com"
#==
#
SPLIT_FILE_TEMP_LOC="/usr/lnk/audit/rxconnect/ip"
CONTROL_FILE="/usr/lnk/audit/rxconnect/"
RXC_CONFIG_FILE="/usr/local/etc/rxconnect/"
NOHUP_LOG="/usr/local/logs/rxconnect/"
REVIEW_FILE="/usr/lnk/apilog/rxconnect/"
#
#
echo ${PROGNAME}
#
#
FRESH_CONTROL_FILE="N"
#
#=====
#
# usage                              
#
#=====
#
usage()
{  cat << ENDOFUSAGE

usage: ${PROGNAME} [-r <RUNTYPE>] [-f <FILE>]

ENDOFUSAGE
  exit 1
}
#
#===========================
#
# FUNCTION:   Error Handling         
#
#===========================
#
error_exit()
{
   local error_message="$1"
   printf "%s\n   ${PROGNAME}: ${error_message}"
   exit 1
}

#
#==================================
#
# FUNCTION:   Submit regroup program
#
#===================================
#
submit_extractchgfile()
{
   /usr/rmcobol/runcobol ${OBJ_DIR}/CRERXCONNECTREC
   RETVAL=$?
   echo "RETVAL:-" ${RETVAL}
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
#========================
#
# FUNCTION:   validate -r            
#
#========================
#
validate_runtype ()
{  case ${RUNTYPE} in
     "switch16"         | \
     "switch40"         | \
     "switch70"         | \
     "switch90"         | \
      "webclaim_mcet"    | \
      "webclaim_general" | \
      "webclaim_medsub") 
         ;;
     *)  usage
          ;;
    esac
}

#
#========================
#
# FUNCTION:   validate -f            
#
#========================
#
validate_file ()
{  case ${FILE} in
     "/usr/local/logs/linedrv/switch16/"  | \
     "/usr/local/logs/linedrv/switch40/"  | \
     "/usr/local/logs/linedrv/switch10/"  | \
     "/usr/local/logs/linedrv/switch70/"  | \
     "/usr/local/logs/linedrv/switch90/"  | \
     "/usr/local/logs/linedrv/webclaim/")
        ;;
    *)  usage
         ;;
   esac
}

#
#============
#
# Main routine
#
#=============
#

while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RUNTYPE=$1
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE=$1
        ;;
  esac
  shift
done

#validate_runtype
#validate_file
#
export RUNTYPE
#
#
#============================================
#
#CONTROL FILE CONTAINS POSITION TO SPLIT FILE 
#
#============================================
#
CONTROLFILE=${CONTROL_FILE}CTLFILE-${RUNTYPE}-${DATETM}

if  ! test -f ${CONTROLFILE} ; then
      echo "0000000000" >${CONTROLFILE}
      FRESH_CONTROL_FILE="Y"
fi   
export CONTROLFILE

#
#=========================
#
#LINEDRIVE / WEBCLAIM FILE
#
#=========================
#
if [[ ${RUNTYPE} == *"switch"* ]]; then
   TCPFILE=${FILE}${RUNTYPE}-${DATETM}
   if ! test -f ${TCPFILE} ; then
      exit 0 
   fi
   export TCPFILE
else
   TCPFILE=${FILE}${RUNTYPE}
   export TCPFILE
   CLAIM00MAS=/usr/lnk/clm_01/CLAIM00MAS
   export CLAIM00MAS
fi
#
#=========================
#
#REVIEWFILE
#
#=========================
#
REVIEWFILE=${REVIEW_FILE}REVIEW-FILE-${RUNTYPE}-${DATETM}

if ! test -f ${REVIEWFILE} ; then
     echo " " >${REVIEWFILE}
fi

export REVIEWFILE
#
#
#================================
#
#SPLIT TCPFILE FILE INTO 2 PARTS
#
#===============================
#
if [ ${FRESH_CONTROL_FILE} = "N" ]; then
   start_pos=`cat ${CONTROLFILE}` 

   tail -c +${start_pos} ${TCPFILE} >${SPLIT_FILE_TEMP_LOC}-${RUNTYPE}-UPDT-${DATETM}

   export TCPFILE=${SPLIT_FILE_TEMP_LOC}-${RUNTYPE}-UPDT-${DATETM}
fi 


#
#============================
#INPUT PARAMETERS:-
#1. DEBUG FLAG
#2. FLAG - THAT CONTROL READ OF CLAIM00MAS
#3. PROCESS JSON FOLDER
#4. FOLDER LOCATION : OUTPUT JSON
#5. FOLDER LOCATION : WHERE TO MOVE RXCONNECT JSON AFTER PROCESSING
#
#==========================
#
INPARM=`cat ${RXC_CONFIG_FILE}/RXC-CFG-${RUNTYPE}`
export INPARM

echo CREATE EXTRACT FILE FOR CHGFILE
date
echo ""
echo "        TCPFILE=${TCPFILE}"
echo "        RUNPATH=${RUNPATH}"
echo "    CONTROLFILE=${CONTROLFILE}"
echo "        RUNTYPE=${RUNTYPE}"
echo "     REVIEWFILE=${REVIEWFILE}"
echo "         INPARM=${INPARM}"
echo "RXC_CONFIG_FILE=${RXC_CONFIG_FILE}"
echo ""

submit_extractchgfile

date

#
#=================
#
#REMOVE FILE SPLIT
#
#=================
##
rm -f  ${CONTROLFILE} 
rm -f  ${SPLIT_FILE_TEMP_LOC}-${RUNTYPE}-UPDT-${DATETM}

if [[ ${RETVAL} -gt 0 ]]; then
   echo " ${PROGNAME}  Errored Out. ${FILE} ${RUNTYPE}" | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_TO} 
fi 

exit 0
