#!/bin/sh
#
# Program Name	: gentb07.sh 
# Description   : add, update, or delete records in the GENTB00MAS master file  
#                 
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
TEST=0
DEBUG=0
DELIM=","

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: gentb07.sh -i <GENTB07PRM input file> -o <GENTBU07CSV output file> -r <GENTBE07CSV error file>

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

	
# Submit gentb07 program
submit_gentb07()
{
       runcobol ${OBJ_DIR}/gentb07 -a ${DELIM}${TEST}${DEBUG}
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
        GENTB07PRM=$INFILE
else
	usage
fi
export GENTB07PRM

if [ ${OUTFILE_FLG} = 1 ]
then
        GENTBU07CSV=$OUTFILE
else
        GENTBU07CSV=/usr/lnk/wt/oper-wt/GENTBU07CSV-${DATETM}.csv
fi
export GENTBU07CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        GENTBE07CSV=$RPTFILE
else
        GENTBE07CSV=/usr/lnk/wt/oper-wt/GENTBE07CSV-${DATETM}.csv
fi
export GENTBE07CSV

FG4AUD=$FG4AUD
   export FG4AUD

date
echo "EXPORT PATHS:"
echo "   GENTB00MAS=$GENTB00MAS "
echo "   GENTB07PRM=$GENTB07PRM "
echo "   FG4AUD=$FG4AUD "
echo "   GENTBU07CSV=$GENTBU07CSV "
echo "   GENTBE07CSV=$GENTBE07CSV "
submit_gentb07
echo  "   RET_CODE=$RETVAL "
date

exit $RETVAL
