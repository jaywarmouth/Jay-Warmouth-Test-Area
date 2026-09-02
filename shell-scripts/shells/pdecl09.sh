#!/bin/sh
#
# Program Name	: pdecl09.sh   
# Description   : Correct PBP on PDE Master   
#                 Command line arguments:
#                   none 
#                 Switches:
#                 -t Test Mode - PDECL00MAS and FG4AUD are not updated 
#		  -i <filename> - Assign alternate input PDECL09PARM
#			Default is /usr/lnk/tmp/PDECL09-PARM.txt
#		  -o <filename> - Assigne alternate output REPORTFILE
#			Default is /usr/lnk/tmp/PDECL09-REPORTFILE-<datetime>.csv
# Author	: Peggy Voytilla
# Date		: 02/03/2016
# Modifications : 02/10/2016 - changes for production version
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
TEST_MODE=0
MAIL_PROG=/usr/bin/mutt
RETVAL=0
INFLG=0
OUTFLG=0
DATETM=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl09.sh -t -i <filename> -o <filename>
	-t	test flag		optional
	-i <input PDECL09PARM>		optional
	-o <output REPORTFILE>		optional

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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

	
# Submit pdecl09 program
submit_pdecl09()
{
      runcobol ${OBJ_DIR}/pdecl09 -s ${TEST_MODE} 
	RETVAL=$?
}

#
# Main routine
#
#Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	INFLG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	OUTFLG=1
        OUTFILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

FG4AUD=${PDEAUD}
 export FG4AUD

if [ $INFLG = 1 ]
then
	PDECL09PARM=${INFILE}
else
	PDECL09PARM=/usr/lnk/tmp/PDECL09-PARM.txt
fi
 export PDECL09PARM

if [ $OUTFLG = 1 ]
then
	REPORTFILE=${OUTFILE}
else
	REPORTFILE=/usr/lnk/tmp/PDECL09-REPORTFILE-${DATETM}.csv
fi
 export REPORTFILE

date
echo "PDE UPDATE OF PBP:"
echo "   FG4AUD=$FG4AUD"
echo "   CLAIM00MAS=$CLAIM00MAS"
echo "   PLAN000MAS=$PLAN000MAS"
echo "   PDECL00MAS=$PDECL00MAS"
echo "   PDECL09PARM=$PDECL09PARM"
echo "   REPORTFILE=$REPORTFILE"
submit_pdecl09
date

echo "Attached is the pdecl09 PBP update report" | ${MAIL_PROG} -s "pdecl09 PBP Update" -a ${REPORTFILE} -c pvoytilla@pdmi.com

exit ${RETVAL}
