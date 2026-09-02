#!/bin/sh
#
# Program Name	: traffic02.sh
# Description	: Submits traffic02 based on queue/option in command line
#	Command line arguments:
#		-l Type of line to read from (dir, 40, 16, tst)
#		-q queue number to read from
#		-r resubmission flag
# Author	: Linda Jefferis
# Date		: 06/03/2011
# Modifications : 10/30/2012 - Add logic for 450 (pricingtool) queue
#		: 02/26/2013 - Add logic for 401 (restack) queue
#               : 05/30/2022 - logic for new line 10/410 queue
#		: 03/2024 - logic for new switch company (70/700/701)
#		: 03/2024 - logic for new switch company (90/900/901)
#		: 06/2024 - New sw40 queues/processes
#		: 09/2024 - New sw60 logic
#
# Variables Used:
RPTDIR="/usr/lnk/traflog"
DATE=`date +%Y%m%d`
MIN_QUEUE=200
MAX_QUEUE=901
LINE="none"
QUEUE=0
SHELL_PATH="/usr/local/bin"
PDMBIN="/usr/local/bin"
RESUBMIT=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: traffic02.sh [-l 10|16|40|60|70|90|dir|tst] | [-q ##] [-r]

ENDOFUSAGE
  exit 1
}

#
# Validate -l options
validate_line()
{  case ${LINE} in
     "40" | "16" | "10" | "60" | "70" | "90" | "dir" | "tst")
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
# Submit traffic02.scr to launch COBOL runtime
submit_traffic02()
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
       nohup ${SHELL_PATH}/traffic02.scr -q ${QUEUE} > ${RPTDIR}/traffic02_${QUEUE}_$$_${DATE} & 
     fi
   else
     case ${LINE} in
       "40")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 300 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 301 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 302 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 303 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 304 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 305 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 306 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 307 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 308 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 309 90 1 512
          else
	    nohup ${SHELL_PATH}/traffic02.scr -q 300 > ${RPTDIR}/traffic02_300_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 301 > ${RPTDIR}/traffic02_301_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 302 > ${RPTDIR}/traffic02_302_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 303 > ${RPTDIR}/traffic02_303_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 304 > ${RPTDIR}/traffic02_304_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 305 > ${RPTDIR}/traffic02_305_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 306 > ${RPTDIR}/traffic02_306_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 307 > ${RPTDIR}/traffic02_307_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 308 > ${RPTDIR}/traffic02_308_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 309 > ${RPTDIR}/traffic02_309_$$_${DATE} & 
          fi
	  ;;
       "16")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 200 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 201 90 1 512
          else
	    nohup ${SHELL_PATH}/traffic02.scr -q 200 > ${RPTDIR}/traffic02_200_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 201 > ${RPTDIR}/traffic02_201_$$_${DATE} & 
          fi
	  ;;
       "60")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 601 90 1 512
            ${PDMBIN}/sndmsg 600 90 1 512
          else
	    nohup ${SHELL_PATH}/traffic02.scr -q 600 > ${RPTDIR}/traffic02_600_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 601 > ${RPTDIR}/traffic02_601_$$_${DATE} & 
          fi
	  ;;
       "70")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 701 90 1 512
            ${PDMBIN}/sndmsg 700 90 1 512
          else
	    nohup ${SHELL_PATH}/traffic02.scr -q 700 > ${RPTDIR}/traffic02_700_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 701 > ${RPTDIR}/traffic02_701_$$_${DATE} & 
          fi
	  ;;
       "90")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 901 90 1 512
            ${PDMBIN}/sndmsg 900 90 1 512
          else
	    nohup ${SHELL_PATH}/traffic02.scr -q 900 > ${RPTDIR}/traffic02_900_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 901 > ${RPTDIR}/traffic02_901_$$_${DATE} & 
          fi
	  ;;
       "dir")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 400 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 402 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 406 90 1 512
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 408 90 1 512
          else
	    nohup ${SHELL_PATH}/traffic02.scr -q 400 > ${RPTDIR}/traffic02_400_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 402 > ${RPTDIR}/traffic02_402_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 406 > ${RPTDIR}/traffic02_406_$$_${DATE} & 
	    nohup ${SHELL_PATH}/traffic02.scr -q 408 > ${RPTDIR}/traffic02_408_$$_${DATE} & 
          fi
	  ;;
       "10")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 410 90 1 512
          else
            nohup ${SHELL_PATH}/traffic02.scr -q 410 > ${RPTDIR}/traffic02_410_$$_${DATE} 2>&1 &
          fi
          ;;
       "tst")
          if [ ${RESUBMIT} = 1 ]
          then
            ${PDMBIN}/sndmsg 90 x 1 512
            ${PDMBIN}/sndmsg 99 90 1 512
          else
	    nohup ${SHELL_PATH}/traffic02.scr -q 99 > ${RPTDIR}/traffic02_99_$$_${DATE} &
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

submit_traffic02

exit 0
