#!/bin/ksh
#
# Program Name	: zip-cl113.sh
# Description	: Creates password zip file(s) from claim113 data files
#				  Command Line Arguments:
#		  			-d <mmyy> Period Ending month and day for filename
#					-c <ahf|aca> 
# Author		: Linda S. Jefferis
# Date			: 01/25/2001
# Modifications : 02/23/2001 - Added -c option and added zip of ???CL113ACA to separate file  (LSJ) 
#				: 02/28/2001 - Added set password for ahf zip file  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
USER=`/usr/bin/logname`
ZIP_OPTS="-j"
FILE_LOC="/usr/lnk/tapes"
ZIP_LOC="/tmp"
AHF_FILE="???CL113AHF"
CAS_FILE="???CL113CAS"
ACA_FILE="???CL113ACA"
AHF_PASSWORD="ha081696"
ACA_PASSWORD="aca12345"
ZIP_PROG="/usr/local/bin/zipit.sh"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-cl113.sh [-d <mmdd>] [-c <ahf|aca>]

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
# Validate -c options
validate_client()
{
	case ${CLIENT} in
		"ahf" | "aca")
			;;
		*)	usage
			;;
	esac
}

#
set_filenames()
{
	case ${CLIENT} in 
		"ahf")
   			if [ ${FILE_DATE} = "null" ]
   			then
      			usage
   			else
      			ZIP_FILE=ahf${FILE_DATE}.zip      # Zip file name
   			fi
			;;
		"aca")
			if [ ${FILE_DATE} = "null" ]
            then
                usage
            else
                ZIP_FILE=aca${FILE_DATE}.zip      # Zip file name
			fi
			;;
	esac
}

#
# Zip Files
zip_files()
{
	case ${CLIENT} in
		"ahf")
			if test -s ${FILE_LOC}/${AHF_FILE}
			then
				if test -s ${FILE_LOC}/${CAS_FILE}
				then
					${ZIP_PROG} +e ${AHF_PASSWORD} +m ${USER} +o "${ZIP_OPTS}" ${ZIP_LOC}/${ZIP_FILE} ${FILE_LOC}/${AHF_FILE} ${FILE_LOC}/${CAS_FILE}
				else
					echo ""
					echo "-*> ${FILE_LOC}/${CAS_FILE} does not exist..."
					exit 1
				fi
			else
				echo ""
				echo "-*> ${FILE_LOC}/${AHF_FILE} does not exist..."
				exit 1
			fi
			;;
		"aca")
			if test -s ${FILE_LOC}/${ACA_FILE}
			then
				${ZIP_PROG} +e ${ACA_PASSWORD} +m ${USER} +o "${ZIP_OPTS}" ${ZIP_LOC}/${ZIP_FILE} ${FILE_LOC}/${ACA_FILE}
			else
				echo ""
        		echo "-*> ${FILE_LOC}/${ACA_FILE} does not exist..."
        		exit 1
    		fi
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
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FILE_DATE=$1
        ;;
	-c) shift
		if [ $# -le 0 ]
        then
          usage
        fi
		CLIENT=$1
		validate_client
		;;
  esac
  shift
done

date

set_filenames

echo
echo "--> Zipping current files..."
echo

zip_files

date

# Parse environment variables
#parse_env

exit 0
