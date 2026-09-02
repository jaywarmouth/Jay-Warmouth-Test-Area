#!/bin/ksh
#
# Program Name	: resp_audit.sh
# Description	: Get counts for various 600 series rejects
#		  Command Line Arguments:
#		  -t <all|607|609|610|614|615|616|617|618|619|699>
#		  -d <mmddyy>  alternate date of file
# Author	: Linda S. Jefferis
# Date		: 02/17/99
# Modifications : 12/20/1999 - Removed 608 and added 610 reject  (LSJ) 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%y`
RSP_DIR="/usr/lnk/rsp"
REJ[0]=" 607 "
REJ[1]=" 609 "
REJ[2]=" 610 "
REJ[3]=" 614 "
REJ[4]=" 615 "
REJ[5]=" 616 "
REJ[6]=" 617 "
REJ[7]=" 618 "
REJ[8]=" 619 "
REJ[9]=" 620 "
REJ[10]=" 699 "
REJ_NUM="null"
MAXVALUE=10

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: resp_audit.sh -t [<all|607|609|610|614|615|616|617|618|619|620|699>]

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
# Grep count
grepit()
{
  NUM=`grep "${GREPTHIS}" ${FILE} | wc -l`
}
  
#
# Submit resp_audit
submit_audit()
{
  echo "COUNT OF 600 SERIES REJECT CLAIMS"
  echo "--------------------------------------"
  echo ""
  FILE=${RSP_DIR}/resp-00-${DATE}
  case ${REJ_NUM} in
    "all")
	i=0
	while [ $i -le ${MAXVALUE} ]
	do
	  GREPTHIS=${REJ[i]}
	  grepit
	  echo "Reject ${REJ[i]} count = "${NUM}
	  echo ""
	  let i=i+1
	done
	;;
    "607" | "609" | "610" | "614" | "615" | "616" | "617" | "618" | "619" | "620" | "699")
	GREPTHIS=" ${REJ_NUM} "
	grepit
	echo "Reject ${REJ_NUM} count = "${NUM}
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
    -t) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        REJ_NUM=$1
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

echo "DATE = "${DATE}
echo ""
submit_audit

# Parse environment variables
#parse_env

exit 0
