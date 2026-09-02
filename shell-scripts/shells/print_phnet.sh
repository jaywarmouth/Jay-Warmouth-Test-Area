#!/bin/ksh
#
# Program Name	: print_phnet.sh
# Description   : Print script for phnet programs 
#                 Command line arguments:
#                 -p phnet program id (01 - 15)
#                 -u username
# Author	: Linda Jefferis
# Date		: 01/08/98
# Modifications : 03/29/06 - Redirect to users home directory and add 09-15
#		: 05/18/06 - Logic changes (LSJ)
#		: 10/02/2006 - Added logic for phnet19  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PROG_ID=""
USER=""
ARGUMENT=""

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: print_phnet.sh [-p 01|02|03|04|05|06|07|08|09|10|13|15|19] [-u <username>]

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

# Print the file
print_file()
{
	mv ${PRT_FILE} ${PRT_FILE}.bak
	lp ${PRT_FILE}.bak
}

# Report file check
report_chk()
{
        if test -e ${PRT_FILE}
        then
                if test -s ${PRT_FILE}
                then
                        print_file
                else
                        echo "\nF.Y.I.: The ${PRT_FILE} report is empty and will not be printed."
                        echo "Press any Key to continue."
                        read REPLY
                fi
        else
                echo "\nPossible error with PHNET process!!"
                echo "Press any Key to end process"
                read REPLY
                exit 1
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
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	PROG_ID=$1
        ;;
    -u) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        ARGUMENT=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables

# Print procedure
#

case ${PROG_ID} in
  "01")
	PRT_FILE=${PHNET01}
	print_file
	;;	
  "02")
	PRT_FILE=${PHNET02}
	print_file
	;;	
  "03")
	PRT_FILE=${PHNET03}
	print_file
	;;	
  "04")
	PRT_FILE=${PHNET04}
	print_file
	;;	
  "05")
	PRT_FILE=${PHNET05}
	print_file
	;;	
  "06")
	PRT_FILE=${PHNET06}
	print_file
	;;	
  "07")
	PRT_FILE=${PHNET07}
	print_file
	;;	
  "08")
	PRT_FILE=${PHNET08}
	print_file
	;;	
  "09")
	PRT_FILE=${PHNET09}
        report_chk
        PRT_FILE=${PHNET09D}
	report_chk
	;;	
  "10")
	PRT_FILE=${PHNET10}
	print_file
	;;	
  "13")
	PRT_FILE=${PHNET13}
	print_file
	;;	
  "15")
	PRT_FILE=${PHNET15}
	print_file
	;;	
  "19")
	PRT_FILE=${PHNET19RPT}
	print_file
	;;	
esac

exit 0
