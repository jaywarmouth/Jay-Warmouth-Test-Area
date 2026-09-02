#!/bin/ksh
#
# Program Name	: copy_clconvert.sh
# Description	: Copies a claims file from 3550 to Raven and starts the conversion program.  Needs to run from 3550.
#		  Command Line Arguments:
#		  -f <filename> - Claims filename to be converted
#		  -l <directory> - Directory on 3550 of claims file to be converted
#		  -p <pathname> - Directory where claims file is put on Raven
#		  -n <path&filename> - path and filename of new converted file
# Author	: Linda S. Jefferis
# Date		: 03/26/99
# Modifications : 06/03/99 - Changed where 3550 file gets permissions changed back to 664  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
REMOTE="raven"
PROG="/usr/pdm/shell/convclaim.sh"
RPT_DIR="/usr/pdm/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: copy_clconvert.sh [-f <filename>] [-l <file path>] [-p <remote path>] [-n<path&filename>]

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
	CL_FILE=$1
	;;
    -l) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	CL_DIR=$1
	;;
    -p) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	PNAME=$1
	;;
    -n) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	NEW_FILE=$1
	;;
  esac
  shift
done


# Parse environment variables
parse_env

# Assign alternate variables

echo "ASSIGNED VARIABLES:"
echo "   CL_DIR=${CL_DIR}"
echo "   CL_FILE=${CL_FILE}"
echo "   PNAME=${PNAME}"
echo "   NEW_FILE=${NEW_FILE}"

date
echo "--> Taking write permissions off file and removing file on ${REMOTE}"
echo ""
chmod -w ${CL_DIR}/${CL_FILE}
rsh ${REMOTE} "rm -f ${PNAME}/${CL_FILE}"

date
echo "--> Starting rcp of the claims file"
echo ""
rcp ${CL_DIR}/${CL_FILE} ${REMOTE}:${PNAME}
if test $? -eq 0
then
   echo "-=> The rcp is completed -- changing permissions back to -rw-rw-r-- on file"
   chmod 664 ${CL_DIR}/${CL_FILE}
   date
   echo "--> Starting convclaim on ${REMOTE}"
   echo ""
   rsh ${REMOTE} "${PROG} -f ${PNAME}/${CL_FILE} -n ${NEW_FILE} > ${RPT_DIR}/convclaim"
else
   echo "-*> RCP failed"
   echo "--> Changing permissions back to -rw-rw-r-- on file"
   chmod 664 ${CL_DIR}/${CL_FILE}
fi
date
echo "-=> Conversion finished"

exit 0
