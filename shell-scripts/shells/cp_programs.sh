#!/bin/ksh
#
# Program Name	: cp_programs.sh
# Description	: Copies *.cob and *.cbl from y2k on 3525 to obj & src on falcon
# Author	: Linda S. Jefferis
# Date		: 10/06/98
# Modifications :  
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
### THE FOLLOWING LINE NEEDS CHANGED FOR EACH DIFFERENT FILE CONVERSION ###
COPY_DIR="/usr/y2k/flexgen/cl80/tst"
DEST_DIR="/usr/programs"
SHELL="shell"
RPT_DIR="/usr/pdm/rpt"
RUN_DIR="/usr/pdm"
DEST_HOST="falcon"
FLIST=/tmp/lsj.lst

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_programs.sh 

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

# Parse environment variables
#parse_env

#Make permission of files created: rw-rw-r--
umask 002

date

# rcp of *.cob from y2k-3525 to falcon
echo "Copy of *.cob to falcon"
cd ${COPY_DIR}
ls *.cob > ${FLIST}
for FNAME in `cat ${FLIST}`
do
   rcp -p ${COPY_DIR}/${FNAME} ${DEST_HOST}:${DEST_DIR}/obj
   if test $? -eq 0
   then
      echo "${FNAME} copy complete"
   else
      echo "${FNAME} copy incomplete"
   fi
done
date
echo "Copy of *.cbl to falcon" 
ls *.cbl > ${FLIST}
for FNAME in `cat ${FLIST}`
do
   rcp -p ${COPY_DIR}/${FNAME} ${DEST_HOST}:${DEST_DIR}/src
   if test $? -eq 0
   then
      echo "${FNAME} copy complete"
   else
      echo "${FNAME} copy incomplete"
   fi
done

date

echo "Finished"
date

exit 0
