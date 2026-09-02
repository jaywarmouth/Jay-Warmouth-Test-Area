#!/bin/sh
#
# Program Name	: overi04.sh 
# Description   : add, update, or delete records in the OVERI00MAS master file  
#                 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
RETVAL=0
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
DATETM=`date +%Y%m%d-%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: overi04.sh -i <OVERI04PRM input file> -o <OVERIU04CSV output file> -r <OVERIE04CSV error file>

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

	
# Submit overi04 program
submit_overi04()
{
       runcobol ${OBJ_DIR}/overi04
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
        INFILE_FLG=1
        INFILE=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        OUTFILE_FLG=1
        OUTFILE=$1
        ;;
    -r) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        RPTFILE_FLG=1
        RPTFILE=$1
        ;;
  esac
  shift
done
 

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
        OVERI04PRM=$INFILE
else
	usage
fi
export OVERI04PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        OVERIU04CSV=$OUTFILE
else
        OVERIU04CSV=/usr/lnk/wt/oper-wt/OVERIU04CSV-${DATETM}.csv
fi
export OVERIU04CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        OVERIE04CSV=$RPTFILE
else
        OVERIE04CSV=/usr/lnk/wt/oper-wt/OVERIE04CSV-${DATETM}.csv
fi
export OVERIE04CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   OVERI00MAS=$OVERI00MAS "
echo "   OVERI04PRM=$OVERI04PRM "
echo "   FG4AUD=$FG4AUD "
echo "   OVERIU04CSV=$OVERIU04CSV "
echo "   OVERIE04CSV=$OVERIE04CSV "
submit_overi04
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
