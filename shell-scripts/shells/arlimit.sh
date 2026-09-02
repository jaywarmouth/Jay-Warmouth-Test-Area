#!/bin/ksh
#
# Program Name  : arlimit.sh
# Description   : LIMIT00MAS Archive/Extract    
# 		Command Line Arguments:
#                 -c A|E - function code; A-Archive, E-Extract
#     A - writes records to a LIMITARMAS file and DELETES records from LIMIT00MAS. Writes records to audit file FG4AUD.
#     E - writes records to a LIMITARMAS file (opened output). No updates done to LIMIT00MAS and FG4AUD is not opened.
#		  -f <LIMITARMAS filename>
#		  -p <LIMARCHP parameter filename>
#			optional - default is /usr/lnk/log/LIMARCHP.txt
#		  -g <GRPLIFELIM parameter filename>
#                       optional - default is /usr/lnk/log/GRPLIFELIM.txt
#			created in group41.sh process
#                 -t test mode            
# Author        : John Shrigley
# Date          : 03/20/06
# Modifications : 05/03/2016 - Changes for production version (LSJ) 
#		: 07/05/2017 - TT17283-1; add GRPLIFELIM logic.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
FUNC_CODE="null"
TEST_MODE=0
LIMITARMAS="null"
PFILE_FLG=0
GFILE_FLG=0
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: arlimit.sh [-t test_mode] [-c <A|E>] [-f <LIMITARMAS filename>] [-p <LIMARCHP filename] [-g GRPLIFELIM filename]
	The -c and -f options are REQUIRED
	The -t, -g, and -p options are optional

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

#
# Validate -c options
validate_code()
{  case ${FUNC_CODE} in
     "A" | "E")
         ;;
     *)  usage
         ;;
   esac
}


# Submit arlimit program
submit_arlimit()
{
        runcobol ${OBJ_DIR}/arlimit -a ${FUNC_CODE}${TEST_MODE}
	RETVAL=$?
}

#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -c) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        FUNC_CODE=$1
	validate_code
        ;;
    -f) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        LIMITARMAS=$1
	export LIMITARMAS
        ;;
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	PFILE_FLG=1
        FILE=$1
        ;;
    -g) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	GFILE_FLG=1
        GFILE=$1
        ;;
    -t) TEST_MODE=1
        ;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate environment variables

if [ ${FUNC_CODE} = "null" ]
then
        usage
fi

# The "-f" input to script is required. No default LIMITARMAS is assigned.
# If 'A' archive option, the LIMITARMAS must exist.
if [ ${LIMITARMAS} = "null" ]
then
        usage
fi

# This is ONLY opened if doing running as A-Archive option
FG4AUD=/usr/files/misc/LIMAUD-arlimit-${DATE}
   export  FG4AUD

if [ $PFILE_FLG = 1 ]
then
	LIMARCHP=$FILE
else
	LIMARCHP=/usr/lnk/log/LIMARCHP.txt
fi
export LIMARCHP

if [ $GFILE_FLG = 1 ]
then
	GRPLIFELIM=$GFILE
else
	GRPLIFELIM=/usr/lnk/log/GRPLIFELIM.txt
fi
export GRPLIFELIM

date
echo "ARCHIVE / EXTRACT LIMIT00MAS RECORDS"
echo ""
echo "EXPORT FILES:"
echo "     FG4AUD=$FG4AUD"
echo "     LIMIT00MAS=$LIMIT00MAS"
echo "     LIMITARMAS=$LIMITARMAS"
echo "     LIMARCHP=$LIMARCHP"
echo "     GRPLIFELIM=$GRPLIFELIM"
echo ""
submit_arlimit
date

exit ${RETVAL}
