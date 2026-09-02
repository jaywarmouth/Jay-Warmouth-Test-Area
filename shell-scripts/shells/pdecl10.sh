#!/bin/sh
#
# This program is designed to convert the PDE EXCLUSION file to Excel.
# 
# Program Name	: pdecl10.sh
# Description   : PDE EXCLUSION File Convert to EXCEL
#                 Command line arguments:
#                 -f input file name (optional)
#		  -o output file name (optional)
# Author	: Peggy Voytilla
# Date		: 06/02/2016
# Modifications : 07/01/2016 - Changes for production version.

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
INFILE_FLG=0
OUTFILE_FLG=0
DATE=`date +%Y%m%d`
DATETM=`date +%Y%m%d%H%M%S`
IN_DIR=/usr/lnk/wt/medd-wt/PDEExclusion/ToPDMI
OUT_DIR=/usr/lnk/wt/medd-wt/PDEExclusion/FromPDMI

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: pdecl10.sh [-f <filename>] [-o <filename>]
	both are optional command line arguments

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


# Submit pdecl10 program
submit_pdecl10()
{
     runcobol ${OBJ_DIR}/pdecl10  
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
    -f) shift
        if [ $# -le 0 ]
        then 
          usage
        fi
	INFILE_FLG=1
        FILE_IN=$1
        ;;
    -o) shift
        if [ $# -le 0 ]
        then 
          usage
        fi
	OUTFILE_FLG=1
        FILE_OUT=$1
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
if [ ${INFILE_FLG} = 1 ]
then
	PDEEX00MAS=${FILE_IN}
else
	cd ${IN_DIR}
	file=`ls -1 PDE-Exclusion-Report-${DATE}`
	mv ${IN_DIR}/$file ${OUT_DIR}
	PDEEX00MAS=${OUT_DIR}/$file
fi
export PDEEX00MAS
if [ ${OUTFILE_FLG} = 1 ]
then
	PDEEXCLUDE=${FILE_OUT}
else
	PDEEXCLUDE=${OUT_DIR}/Converted-PDE-Exclusion-Report-${DATETM}.csv
fi
export PDEEXCLUDE


echo "PDE Exclusion File Convert to EXCEL"
date
echo "   PDEEX00MAS=$PDEEX00MAS"
echo "   PDEEXCLUDE=$PDEEXCLUDE"
submit_pdecl10 
date

exit ${RETVAL}
