#!/bin/sh
#
# Program Name	: rxeob_gentb.sh
# Description	: Extract of Generic Table data for RXEOB
# Author	: Linda S. Jefferis
# Date		: 01/17/2002
# Modifications : 03/12/2004 - Added procedures for SOVS file  (LSJ) 
#		: 10/29/2004 - Added procedures for AGMS(sys52) file  (LSJ)
#		: 11/30/2004 - Added procedures for ENNI(sys76) (LSJ)
#		: 05/23/2005 - Added procedures for AHF(sys48;select sponsors)
#               : 09/09/2005 - Added procedures for NEWERA(sys81) (CMH)
#		: 09/29/2005 - Added procedures for MEDB(sys49)  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 01/09/2006 - Removed run for Summacare(sys35)  (LSJ)
#		: 01/09/2006 - Added procedures for WSBS(sys82)  (LSJ)
#		: 10/31/2006 - Added procedures for KCON(sys69)  (LSJ)
#		: 02/12/2007 - Removed logic for ENNIS  (LSJ)
#		: 07/09/2007 - Removed logic for sys0066  (LSJ)
#		: 07/31/2007 - Added procedures for FDAV (sys0070)  (LSJ)
#		: 12/29/2008 - Added logic for sys0113 (PNPS)
#		: 12/29/2008 - Removed sys0081 logic
#		: 07/25/2012 - Add logic for sys0075 (TT #1545-10)
#		: 07/25/2012 - Removed inactive sys82 logic
#		: 08/08/2012 - Added sys82 logic back; they are not inactive; instead removed inactive sys81
#		: 01/22/2013 - Added "process_sys105" (TT #4929-4)
#		: 12/26/2013 - Added "process_sys71" (TT #9001-11)
#		: 03/19-2014 - Added "process_sys162" (TT#10080-1)
#		: 06/10/2014 - Add "process_sys163"  (TT #11192-1)
#		: 12/16/2014 - Add "process_sys130" (TT #12535-2)
#		: 03/18/2015 - Remove termed system process.
#		"process_sys52", "process_sys71", "process_sys70"
#		: 08/29/2016 - Removal of APRX logic (TT15056-7)
#		: 04/5/2018 - TT17486-54; remove AHF logic.
#		: 05/28/2020 - TT13915-90; removal of logic for TRRX/PNPS
#		: 10/30/2020 - TT20329-34; removal of TSC
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
EXTRACT_MEDB="GENTB-MEDB"
EXTRACT_WSBS="GENTB-WSBS"
EXTRACT_KCON="GENTB-KCON"
EXTRACT_LVHN="GENTB-LVHN"
NETWRK_DIR="/usr/lnk/shares/rxeob"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rxeob_gentb.sh 

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
	echo "      --> Extracting ${EXTRACT_MEDB} - gentb01.sh"
	${SHELL}/gentb01.sh -a MEDB >> ${RPT}/gentb01 2>&1
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
	echo "      --> Extracting ${EXTRACT_KCON} - gentb01.sh"
	${SHELL}/gentb01.sh -a KCON >> ${RPT}/gentb01 2>&1
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
# Process WSBS 
process_sys82()
{
	echo "      --> Extracting ${EXTRACT_WSBS} - gentb01.sh"
	${SHELL}/gentb01.sh -a WSBS >> ${RPT}/gentb01 2>&1
	date

	echo "      --> Zipping ${EXTRACT_WSBS} to Network Directory"
	mv ${FILE_PATH}/${EXTRACT_WSBS} ${FILE_PATH}/${EXTRACT_WSBS}_${DATE}.txt
	${ZIP_PROG} -jm ${NETWRK_DIR}/${DATE}.zip ${FILE_PATH}/${EXTRACT_WSBS}_${DATE}.txt
	if test $? -ne 0
	then
   	   echo "-*> zip of ${EXTRACT_WSBS} failed"
           exit 1
	fi
}

#
# Process LVHN
process_sys162()
{
        echo "      --> Extracting ${EXTRACT_LVHN} - gentb01.sh"
        ${SHELL}/gentb01.sh -a LVHN >> ${RPT}/gentb01 2>&1
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
# Main routine
#

# Check command line validity, call usage if incorrect

# Parse environment variables
#parse_env

umask 002

rm -f ${RPT}/gentb01

date

process_sys82

date

process_sys49

date

process_sys69

date

process_sys162

date

exit 0
