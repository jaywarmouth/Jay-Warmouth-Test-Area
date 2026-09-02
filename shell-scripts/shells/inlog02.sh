#!/bin/sh
#
# Program Name	: inlog02.sh 
# Description   : Update the inlog00mas, using a parameter file, creating a csv file
#                 listing changes and errors.
#                 Command line arguments:
#                 -i <INLOG02PRM> (Required)
#                 -o <INLOG00CSV> (Optional) - Default is /usr/lnk/wt/oper-wt/misc/INLOG00CSV-yyyymmddhhmmss.csv
# Author	: Debbe Adgate 
# Date		: 06/16/2016
# Modifications :           
#		: 
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLG=0
OUTFILE_FLG=0
RETVAL=0
TESTMODE=0
DATETM=`date +%Y%m%d%H%M%S`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: inlog02.sh -t ${TESTMODE} -i <INLOG02PRM> -o <INLOG00CSV>
	-i <INLOG02PRM>		required
	-o <INLOG00CSV>  optional; 
	Default is /usr/lnk/wt/oper-wt/misc/INLOG00CSV-yyyymmddhhmmss.csv

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

	
# Submit inlog02 program
submit_inlog02()
{
      runcobol ${OBJ_DIR}/inlog02 -s $TESTMODE           
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
    -t) TESTMODE=1     
	;;
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
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
FG4AUD=$GRPAUD
  export FG4AUD
if [ $INFILE_FLG = 1 ]
then
	INLOG02PRM=${INFILE}
else
	usage
fi
if [ $OUTFILE_FLG = 1 ]
then
	INLOG00CSV=${OUTFILE}
else
	INLOG00CSV=/usr/lnk/wt/oper-wt/misc/INLOG00CSV-${DATETM}.csv
fi

export INLOG00CSV INLOG02PRM
	

echo UNLOAD INLOG00MAS TO A SEQ FILE
date
echo "EXPORT PATHS:"
echo "   INLOG00MAS=$INLOG00MAS "
echo "   INLOG02PRM=$INLOG02PRM "
echo "   FG4AUD=$FG4AUD "
echo "   INLOG00CSV=$INLOG00CSV "

submit_inlog02
echo ""
echo  "RETVAL=$RETVAL"
date

exit $RETVAL
