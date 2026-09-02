#!/bin/ksh
#
# Program Name	: audit-cmp-colo.sh
# Description	: Compares AUDIT files and compresses when equal or runs claim96 if not.
#		: Difference between this and regular audit-cmp is the switch seetings on the claim96 process.  This runs a full update.
# Author	: Linda S. Jefferis
# Date		: 10/14/2008
# Modifications : 01/26/2010 - Changes for 3-digit queue numbers
#		: 08/16/2011 - date format change

# Variables Used:
umask 002
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR=/usr/lnk/obj
DATE=`date -d "yesterday" +%Y%m%d`
PROD_DIR="/usr/lnk/audit"
AUD_DIR="/usr/lnk/audit"
FNAME[0]="AUDIT-400-${DATE}"
FNAME[1]="AUDIT-401-${DATE}"
FNAME[2]="AUDIT-300-${DATE}"
FNAME[3]="AUDIT-301-${DATE}"
FNAME[4]="AUDIT-200-${DATE}"
FNAME[5]="AUDIT-201-${DATE}"
FNAME[6]="DMR-${DATE}"
FNAME[8]="CLAIM02"
MAXVALUE=6
PROD_SYS="prod10"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: audit-cmp-colo.sh 

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

#
# Main routine
#

# Parse environment variables
parse_env

echo ""
echo "*** AUDIT-CMP Procedure ***"
echo ""
date
i=0
while [ $i -le $MAXVALUE ]
do
    if test -a ${AUD_DIR}/${FNAME[i]}.cmp
    then
      cmp -s ${AUD_DIR}/${FNAME[i]}.cmp ${AUD_DIR}/${FNAME[i]}.${PROD_SYS}
      if test $? -ne 0
      then 
        echo "Files not equal"
        mv ${AUD_DIR}/${FNAME[i]}.cmp ${AUD_DIR}/${FNAME[i]}.${PROD_SYS}
        AUDIT20MAS=${AUD_DIR}/${FNAME[i]}.${PROD_SYS}
        export AUDIT20MAS
        echo $AUDIT20MAS
        runcobol ${OBJ_DIR}/claim96 -s 00000010
      else
        echo "Files were equal"
        rm ${AUD_DIR}/${FNAME[i]}.cmp
      fi
    else
      echo "Could not compare ${AUD_DIR}/${FNAME[i]}.cmp --- File did not exist"
    fi
    gzip ${AUD_DIR}/${FNAME[i]}.${PROD_SYS}
    echo "${AUD_DIR}/${FNAME[i]}.${PROD_SYS} - COMPRESSED"
    let i=i+1
done

if test -a ${AUD_DIR}/${FNAME[8]}.cmp
then
   cmp -s ${AUD_DIR}/${FNAME[8]}.cmp ${AUD_DIR}/${FNAME[8]}-${DATE}.${PROD_SYS}
   if test $? -ne 0
   then
     mv ${AUD_DIR}/${FNAME[8]}.cmp ${AUD_DIR}/${FNAME[8]}-${DATE}.${PROD_SYS}
     AUDIT20MAS=${AUD_DIR}/${FNAME[8]}-${DATE}.${PROD_SYS}
     export AUDIT20MAS
     runcobol ${OBJ_DIR}/claim96 -s 00000010
   else
     rm ${AUD_DIR}/${FNAME[8]}.cmp
   fi
else
   echo "Could not compare ${AUD_DIR}/${FNAME[8]}.cmp --- File did not exist"
fi
gzip ${AUD_DIR}/${FNAME[8]}-${DATE}.${PROD_SYS}
echo "${AUD_DIR}/${FNAME[8]}-${DATE}.${PROD_SYS} - COMPRESSED"

date

exit 0
