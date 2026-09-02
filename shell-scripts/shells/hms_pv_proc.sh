#!/bin/ksh
#
# Program Name  : hms_pv_proc.sh
# Description   : Process to run additional scripts for hms files processing
#			pvadd01.sh
#			pvdea01.sh
#			pvnpi01.sh                 
#			pvsan01.sh
#			pvosan01.sh
#			pvonpi01.sh
#			pvorgpro01.sh
#                 
#       
#      
# Author        : Dawn M. Engler
# Date          : 01/13/2014
# Modifications : 01/20/2014 Correct error with the check for the zip file 
#		: 02/10/2015 Add pvsan01 process
#		: 04/13/2015 add pvonpi01, pvosan01, and pvorgpro01 processes
#		   Tasks - 2244-51, 2244-52, 2244-53
#		: 05/26/2015 Add second run of pvdea01 TT:2244-54
#		: 07/06/2016 - TT5342-24 (Add "PATH=/usr/rmcobol:$PATH") to fix unzip of large files issue until this process can get put into JAMS.
#
# Variables Used:
PATH=/usr/rmcobol:$PATH
TMP_DIR="/usr/lnk/tmp"
FILE_DATE=`date -d last-friday +%Y%m%d`
HMS_FILE="/usr/lnk/wt/sqlimports/misc/${FILE_DATE}_HMS_FULL_PDMI.zip"
SHL_DIR="/usr/lnk/shell"
ADD_SHL="${SHL_DIR}/pvadd01.sh"
DEA_SHL="${SHL_DIR}/pvdea01.sh"
NPI_SHL="${SHL_DIR}/pvnpi01.sh"
SAN_SHL="${SHL_DIR}/pvsan01.sh"
OSAN_SHL="${SHL_DIR}/pvosan01.sh"
ONPI_SHL="${SHL_DIR}/pvonpi01.sh"
OPRO_SHL="${SHL_DIR}/pvorgpro01.sh"
ADD_FILE="HMS_Address.txt"
DEA_FILE="HMS_DEA.txt"
NPI_FILE="HMS_Practitioner_Profile.txt"
SAN_FILE="HMS_Sanction.txt"
ONPI_FILE="HMS_ORGANIZATION_NPI.txt"
OSAN_FILE="HMS_ORGANIZATION_SANCTIONS.txt"
OPRO_FILE="HMS_ORGANIZATION_PROFILE.txt"
ODEA_FILE="HMS_ORGANIZATION_DEA.txt"


#
#Main routine
#
#
date
echo "--> Process Starting..."

#Check for zip file
if [ ! -f ${HMS_FILE} ] ;
then
	echo "${HMS_FILE} file not found!"
	echo Ending process
	exit 0

else

	#Process Address file
	echo "--> Processing Address file..."
	unzip -j "${HMS_FILE}" "${ADD_FILE}" -d ${TMP_DIR}

	if [ ! -f ${TMP_DIR}/${ADD_FILE} ];
	then
		echo "${ADD_FILE} file not found!"
	else
		${ADD_SHL}
		rm -f ${TMP_DIR}/${ADD_FILE}
	fi


	#Process DEA and Organization DEA file
	echo "--> Processing DEA and ORGANIZATION_DEA file..."
	unzip -j "${HMS_FILE}" "${DEA_FILE}" -d ${TMP_DIR}

	if [ ! -f ${TMP_DIR}/${DEA_FILE} ] ;
	then
        	echo "${DEA_FILE} file not found!"
	else
        	${DEA_SHL} -i ${TMP_DIR}/${DEA_FILE}
		rm -f ${TMP_DIR}/${DEA_FILE}
	fi

	unzip -j "${HMS_FILE}" "${ODEA_FILE}" -d ${TMP_DIR}

	if [ ! -f ${TMP_DIR}/${ODEA_FILE} ] ;
	then
        	echo "${ODEA_FILE} file not found!"
	else
        	${DEA_SHL} -i ${TMP_DIR}/${ODEA_FILE}
		rm -f ${TMP_DIR}/${ODEA_FILE}
	fi

	#Process NPI file
	echo "--> Processing NPI file..."
	unzip -j "${HMS_FILE}" "${NPI_FILE}" -d ${TMP_DIR}

	if [ ! -f ${TMP_DIR}/${NPI_FILE} ] ;
	then
        	echo "${NPI_FILE} file not found!"
	else
        	${NPI_SHL}
		rm -f ${TMP_DIR}/${NPI_FILE}
	fi

	#Process Organization NPI file
	echo "--> Processing Organization NPI file..."
	unzip -j "${HMS_FILE}" "${ONPI_FILE}" -d ${TMP_DIR}

	if [ ! -f ${TMP_DIR}/${ONPI_FILE} ] ;
	then
        	echo "${ONPI_FILE} file not found!"
	else
        	${ONPI_SHL}
		rm -f ${TMP_DIR}/${ONPI_FILE}
	fi

	#Process Sanction file
	echo "--> Processing Sanction file..."
	unzip -j "${HMS_FILE}" "${SAN_FILE}" -d ${TMP_DIR}

	if [ ! -f ${TMP_DIR}/${SAN_FILE} ] ;
	then
        	echo "${SAN_FILE} file not found!"
	else
        	${SAN_SHL}
		rm -f ${TMP_DIR}/${SAN_FILE}
	fi

	#Process Organization Sanction file
	echo "--> Processing Organization Sanction file..."
	unzip -j "${HMS_FILE}" "${OSAN_FILE}" -d ${TMP_DIR}

	if [ ! -f ${TMP_DIR}/${OSAN_FILE} ] ;
	then
        	echo "${OSAN_FILE} file not found!"
	else
        	${OSAN_SHL}
		rm -f ${TMP_DIR}/${OSAN_FILE}
	fi

	#Process Organization Profile
	echo "--> Processing Organization Profile..."
	unzip -j "${HMS_FILE}" "${OPRO_FILE}" -d ${TMP_DIR}

	if [ ! -f ${TMP_DIR}/${OPRO_FILE} ] ;
	then
        	echo "${OPRO_FILE} file not found!"
	else
        	${OPRO_SHL}
		rm -f ${TMP_DIR}/${OPRO_FILE}
	fi

fi
echo "Process completed."
date

exit 0

