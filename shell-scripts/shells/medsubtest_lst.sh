#!/bin/sh
#
# Program Name	: medsub_lst.sh
# Description	: Takes medsub files from oper-wt/MEDSUB/HMS/ToPDMI and moves to Prod10 location for processing. 
# Author	: Linda Jefferis
# Date		: 4/11/2013
# Modifications : 10/22/2015 - Changes for new file location and no longer PGP
#		: 1/31/2016 - add check of software certification
#		: 2/23/2016 - add rejected logic
#		: 04/18/2018 - File location changes
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
INDIR="/usr/lnk/wt/oper-wt/MEDSUB/HMS/ToPDMI/Test"
DEST_LOC="/usr/lnk/wt/oper-wt/MEDSUB/HMS/TEST/In"
REJ_LOC="/usr/lnk/wt/oper-wt/MEDSUB/HMS/TEST/Rejected"
LOG="/tmp/medsub.log"
MAIL_PROG="/usr/bin/mutt"
HOST=`/usr/lnk/shell/get_hostname.sh`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: medsubtest_lst.sh 

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
parse_env

echo "Medicaid Subrogation Files" > ${LOG}
echo "" >> ${LOG}
cd ${INDIR}
ls -1 PDMICLAIMS.RXDMI.TRB???.*.*.TXT > /tmp/medsubhmsfiles-list.txt
for file in `cat /tmp/medsubhmsfiles-list.txt`
do
	SOFTCERT=`head -1 $file | cut -c5-8`
	if [ $SOFTCERT = "HMS" ]
	then
		AGENCY_CODE=`echo $file | awk -F. '{ print $3 }'`
		DATETM=`echo $file | awk -F. '{ print $5 }'`
		mv $file ${DEST_LOC}/${AGENCY_CODE}.${DATETM}.txt
		wc -l ${DEST_LOC}/${AGENCY_CODE}.${DATETM}.txt >> ${LOG}
	else
		mv $file ${REJ_LOC}
	fi
done

echo "" >> ${LOG}
echo "Rejected Files:" >> ${LOG}
echo "----------------" >> ${LOG}
ls -1 ${REJ_LOC} >> ${LOG}
	
cat ${LOG} | ${MAIL_PROG} -s "TEST - ${HOST} - Medicaid Subrogation" ljefferis@pdmi.com

exit 0
