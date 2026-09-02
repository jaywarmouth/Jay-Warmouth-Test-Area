#!/bin/ksh
#
# Program Name	: Response Screen Viewer
# Description	: Reads from daily response screen files and pulls up
#		appropriate information.
# Author	: Anthony DePinto
# Date		: 1-5-95
# Modifications : 3-25-96 Formatted into standards and added system selection
#		  3-18-97 AD Removed proc_audit lines
#		  5-12-97 AD Check for existance of files before tailing
#		: 08/23/2006 - LSJ - Changes for 4-digit system numbers
#		: 04/24/2007 - Changes for new line drivers
#		: 08/15/2011 - DATE format change and change SEARCH= commands
# Variables Used:
DATE=`date +%Y%m%d`
FILE="/usr/lnk/rsp/resp"
LINE="ALL"
SYSTEM="0000"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: resp.sh {-l sw16|sw40|dir} {-s SystemNumber} {-d Date}

ENDOFUSAGE
  exit 1
}

# 
# Validate line parameters
validate_line()
{  case ${LINE} in 
	"sw40") SEARCH="^40"
	       ;;
	"sw16") SEARCH="^16"
	       ;;
	"dir") SEARCH="^1|^2|^3|^4|^5|^6|^7|^8|^9|^10"
	       EGREPOPT="-v"
	       ;;
        *)	usage
	       ;;
   esac 
}

#
# Trap break signal for audit trail
trap_break()
{
  exit 0
}

#
# Main routine
#
trap "trap_break" 2

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
		-s) shift
		    if [ $# -le 0 ]
		    then
		      usage
		    fi
		    SYSTEM=$1
		   ;;
		-d) shift
		    if [ $# -le 0 ]
		    then
		      usage
		    fi
		    DATE=$1
		    ;;
		-?) usage
		   ;;
	esac
	shift
done

FILE=${FILE}-0000-${DATE}
 
if [ -f ${FILE} ]   
then
  /usr/local/bin/resp ${SYSTEM} ${LINE} ${FILE}
else
  echo "-*> Response file does not exist."
fi

exit 0
