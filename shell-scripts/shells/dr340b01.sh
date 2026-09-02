#!/bin/ksh
#
# Program Name	: dr340b01.sh  
# Description   : UPDATE DR340B0MAS file.    
#                 Command line arguments:
#		  -f <file name> - alternate DR340B0MAS
#		  -i <file name> - input DR340B0TAP
# Author	: William Kohuth
# Date		: 11/17/2013
# Modifications : 02/11/2014 (LSJ) For TT #6806-37                                                            
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FILE_DIR=/usr/lnk/tmp
FILE_FLAG=0
INP_FLAG=0


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: dr340b01.sh -i <input fname> -f <filename>
	-i (optional)
	-f (optional)

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

# Check and set input file
check_file()
{
	if test -s $INP_FILE
	then
		DR340B0TAP=$INP_FILE
		export DR340B0TAP
	else
		echo "-*> File, $INP_FILE, is zero or does not exist."
		exit 2
	fi
}

# Submit dr340b01 program
submit_dr340b01( )
{
     runcobol ${OBJ_DIR}/dr340b01
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -i) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	INP_FLAG=1
	INP_FILE=$1
	check_file
	;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE_FLAG=1
	FILE=$1
	;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ $FILE_FLAG = 1 ]
then
	DR340B0MAS=$FILE
	export DR340B0MAS
fi
if [ $INP_FLAG = 1 ]
then
	DR340B0TAP=$INP_FILE
	export DR340B0TAP
fi


echo "Update DR304B0MAS from DR340B0TAP file"
date
echo "EXPORT PATHS:"
echo "   DR340B0TAP=$DR340B0TAP"
echo "   DR340B0MAS=$DR340B0MAS"
echo "   DR340B0CSV=$DR340B0CSV"

submit_dr340b01

date

exit 0
