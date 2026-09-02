#!/bin/sh
#
# Program Name	: rxeob_gentb06.sh
#
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DATE=`date +%m%d%Y`
SHELL="/usr/lnk/shell"
RPT="/usr/lnk/rpt"
FILE_PATH="/usr/lnk/rxeob"
EXTRACT_MEDB="GENTB06-MEDB"
EXTRACT_KCON="GENTB06-KCON"
EXTRACT_LVHN="GENTB06-LVHN"
EXTRACT_EVO="GENTB06-EVO"
EXTRACT_APRX="GENTB06-APRX"
NETWRK_DIR="/usr/lnk/wt/oper-wt/RxEOB"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_gentb06.sh 

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
# Process MEDB 
process_sys49()
{
	echo "      --> Extracting ${EXTRACT_MEDB} - gentb06.sh"
	${SHELL}/gentb06.sh -l MEDB -f ${FILE_PATH}/${EXTRACT_MEDB} >> ${RPT}/gentb06 2>&1
	date

	echo "      --> Zipping ${EXTRACT_MEDB} to Network Directory"
	mv ${FILE_PATH}/${EXTRACT_MEDB} ${FILE_PATH}/${EXTRACT_MEDB}_${DATE}.txt
	${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/${EXTRACT_MEDB}_${DATE}.txt
	if test $? -ne 0
	then
   	   echo "-*> zip of ${EXTRACT_MEDB} failed"
           exit 1
	fi
}

#
# Process KCON 
process_sys69()
{
	echo "      --> Extracting ${EXTRACT_KCON} - gentb06.sh"
	${SHELL}/gentb06.sh -l KCON -f ${FILE_PATH}/${EXTRACT_KCON} >> ${RPT}/gentb06 2>&1
	date

	echo "      --> Zipping ${EXTRACT_KCON} to Network Directory"
	mv ${FILE_PATH}/${EXTRACT_KCON} ${FILE_PATH}/${EXTRACT_KCON}_${DATE}.txt
	${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/${EXTRACT_KCON}_${DATE}.txt
	if test $? -ne 0
	then
   	   echo "-*> zip of ${EXTRACT_KCON} failed"
           exit 1
	fi
}
 

#
# Process LVHN
process_sys162()
{
        echo "      --> Extracting ${EXTRACT_LVHN} - gentb06.sh"
        ${SHELL}/gentb06.sh -l LVHN -f ${FILE_PATH}/${EXTRACT_LVHN} >> ${RPT}/gentb06 2>&1
        date

        echo "      --> Zipping ${EXTRACT_LVHN} to Network Directory"
        mv ${FILE_PATH}/${EXTRACT_LVHN} ${FILE_PATH}/${EXTRACT_LVHN}_${DATE}.txt
        ${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/${EXTRACT_LVHN}_${DATE}.txt
        if test $? -ne 0
        then
           echo "-*> zip of ${EXTRACT_LVHN} failed"
           exit 1
        fi
}

#
# Process EVO
process_evo()
{
        echo "      --> Extracting ${EXTRACT_EVO} - gentb06.sh"
        ${SHELL}/gentb06.sh -l EVO -f ${FILE_PATH}/${EXTRACT_EVO} >> ${RPT}/gentb06 2>&1
        date

        echo "      --> Zipping ${EXTRACT_EVO} to Network Directory"
        mv ${FILE_PATH}/${EXTRACT_EVO} ${FILE_PATH}/${EXTRACT_EVO}_${DATE}.txt
        ${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/${EXTRACT_EVO}_${DATE}.txt
        if test $? -ne 0
        then
           echo "-*> zip of ${EXTRACT_EVO} failed"
           exit 1
        fi
}

#
# Process APRX
process_aprx()
{
        echo "      --> Extracting ${EXTRACT_APRX} - gentb06.sh"
        ${SHELL}/gentb06.sh -l APRX -f ${FILE_PATH}/${EXTRACT_APRX} >> ${RPT}/gentb06 2>&1
        date

        echo "      --> Zipping ${EXTRACT_APRX} to Network Directory"
        mv ${FILE_PATH}/${EXTRACT_APRX} ${FILE_PATH}/${EXTRACT_APRX}_${DATE}.txt
        ${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/${EXTRACT_APRX}_${DATE}.txt
        if test $? -ne 0
        then
           echo "-*> zip of ${EXTRACT_APRX} failed"
           exit 1
        fi
}

#
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

umask 002

rm -f ${RPT}/gentb06

date

process_sys49

date

process_sys69

date

process_sys162

date

process_evo

date

process_aprx

date

exit 0
