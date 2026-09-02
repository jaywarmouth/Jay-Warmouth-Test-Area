#!/bin/ksh
#
# Program Name	: cp_programs.sh
# Description	: Copies *.cob, *.cbl, and *.sh from specified COPY_DIR on Crow to shell, obj & src on raven
# Author	: Linda S. Jefferis
# Date		: 10/06/98
# Modifications : 06/14/99 - Added rcp of *.sh files  (LSJ) 
#		: 10/05/2004 - Updates of code  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
### THE FOLLOWING LINE NEEDS CHANGED FOR EACH DIFFERENT FILE CONVERSION ###
COPY_DIR="/usr/lnk/programs/conv"
DEST_DIR="/usr/lnk"
SHELL="shell"
RPT_DIR="/usr/lnk/rpt"
RUN_DIR="/usr/pdm"
DEST_HOST="raven"
FLIST=/tmp/raven.lst

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_programs_raven.sh 

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

# rcp of *.cob from Crow to raven
echo "Copy of *.cob to raven"
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
echo "Copy of *.cbl to raven" 
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
echo "Copy of *.sh to raven"
cd ${COPY_DIR}
ls *.sh > ${FLIST}
for FNAME in `cat ${FLIST}`
do
   rcp ${COPY_DIR}/${FNAME} ${DEST_HOST}:${DEST_DIR}/shell
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
