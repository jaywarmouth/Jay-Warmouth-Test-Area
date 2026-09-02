#!/bin/sh
#
# Program Name	: spcfg01.sh 
# Description   : CREATING RECORDS IN SPCFG00MAS FROM TEXT PARAMETER FILE

#                 Switches:
#                 -t Test mode (no file or audit writes)

#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLG=0
OUTFILE_FLG=0
RPTFILE_FLG=0
TEST_MODE=0
DATETM=`date +%Y%m%d%H%M%S`
RETVAL=0

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: spcfg01.sh -i <input filename> -o <output filename [-t]
	-i <filename> is required to provide input filename
	-o <filename> is optional to provide output filename
	-r <filename> is optional to provide output filename

ENDOFUSAGE
  exit 1
}


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

	
# Submit spcfg01 program
submit_prog()
{
      	runcobol ${OBJ_DIR}/spcfg01 -s ${TEST_MODE} 
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
    -t) TEST_MODE=1
        ;;
  
  esac
  shift
done


# Parse environment variables
parse_env
  
if [ ${INFILE_FLG} = 1 ]
then
	SPCFG01PRM=$INFILE
else
	usage
fi
export SPCFG01PRM

if [ $OUTFILE_FLG = 1 ]
then
        SPCFGU01CSV=${OUTFILE}
else
	SPCFGU01CSV=/usr/lnk/wt/oper-wt/SPCFGU01CSV-${DATETM}.csv
fi
export SPCFGU01CSV
if [ ${RPTFILE_FLG} = 1 ]
then
        SPCFGE01CSV=$RPTFILE
else
        SPCFGE01CSV=/usr/lnk/wt/oper-wt/SPCFGE01CSV-${DATETM}.csv
fi
export SPCFGE01CSV

FG4AUD=$FG4AUD
   export FG4AUD

   echo "UPDATE FIELDS ON SPCFG00MAS MASTER FILE"
   date
   echo "EXPORT PATHS:"
   echo "   SPCFG00MAS=$SPCFG00MAS"
   echo "   SPCFG01PRM=$SPCFG01PRM"
   echo "   SPCFGU01CSV=$SPCFGU01CSV"
   echo "   SPCFGE01CSV=$SPCFGE01CSV "
   echo "   FG4AUD=${FG4AUD}" 
   submit_prog
   date

exit $RETVAL
