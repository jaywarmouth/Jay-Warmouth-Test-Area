#!/bin/ksh
#
# Program Name	: compu04.sh
# Description	: Submits compu04 based on queue/option in command line
#	Command line arguments:
#		-l Type of line to read from (direct, ndc, envoy)
#		-q queue number to read from
#		-r resubmission flag
# Author	: Anthony DePinto
# Date		: 4-16-96
# Modifications : 10-6-97 AD Changed message queues snd to comply with new code
#
# Variables Used:
RPTDIR="/usr/lnk/daily/compu04"
DATE=`date +%m%d`
MIN_QUEUE=91
MAX_QUEUE=99
LINE="none"
QUEUE=0
SHELL_PATH="/usr/lnk/shell"
PDMBIN="/usr/pdm/bin"
RESUBMIT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: compu04.sh [-l env|ndc|dir] | [-q ##] [-r]

ENDOFUSAGE
  exit 1
}

#
# Validate -l options
validate_line()
{  case ${LINE} in
     "ndc" | "env" | "dir" | "tst")
			  ;;
     *)  usage
	 ;;
   esac
}

#
# Validate -q options
validate_queue()
{  if [ ${QUEUE} -lt ${MIN_QUEUE} ] 
   then
     usage
   elif [ ${QUEUE} -gt ${MAX_QUEUE} ]
   then
     usage
   fi
}

#
# Submit compu04.scr to launch COBOL runtime
submit_compu04()
{ 
   if [ ${LINE} = "none" ]
   then
     if [ ${QUEUE} = 0 ] 
     then
       usage
     fi
     if [ ${RESUBMIT} = 1 ]
     then
       ${PDMBIN}/sndmsg 90 x 1 512
       ${PDMBIN}/sndmsg ${QUEUE} 90 1 512
     else
       nice --10 nohup ${SHELL_PATH}/compu04.scr -q ${QUEUE} > ${RPTDIR}/compu04${QUEUE}_$$_${DATE} & 
     fi
   else
     case ${LINE} in
       "ndc")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 94 90 1 512
            ${PDMBIN}/sndmsg 93 90 1 512
          else
	    nice --10 nohup ${SHELL_PATH}/compu04.scr -q 93 > ${RPTDIR}/compu0493_$$_${DATE} & 
	    nice --10 nohup ${SHELL_PATH}/compu04.scr -q 94 > ${RPTDIR}/compu0494_$$_${DATE} & 
          fi
	  ;;
       "env")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 95 90 1 512
            ${PDMBIN}/sndmsg 96 90 1 512
          else
	    nice --10 nohup ${SHELL_PATH}/compu04.scr -q 95 > ${RPTDIR}/compu0495_$$_${DATE} & 
	    nice --10 nohup ${SHELL_PATH}/compu04.scr -q 96 > ${RPTDIR}/compu0496_$$_${DATE} & 
          fi
	  ;;
       "dir")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 91 90 1 512
          else
	    nice --10 nohup ${SHELL_PATH}/compu04.scr -q 91 > ${RPTDIR}/compu0491_$$_${DATE} & 
          fi
	  ;;
       "tst")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 99 90 1 512
          else
	    nice --10 nohup ${SHELL_PATH}/compu04.scr -q 99 > ${RPTDIR}/compu0499_$$_${DATE} &
          fi
	  ;;
     esac
   fi
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -l) shift
	if [ $# -le 0 ]
	then
	  usage
        fi
	LINE=$1 
	validate_line
	;;
    -q) shift
	if [ $# -le 0 ]
	then
	  usage
        fi
	QUEUE=$1
	validate_queue
	;;
    -r) RESUBMIT=1
	;;
  esac
  shift
done

submit_compu04

exit 0
