#!/bin/ksh
#
# Program Name	: bunchk10.sh
# Description   : Create "BINCHK0MAS Update" BIN records to update BINCHK0MAS file
#                 Command line arguments
#                 -i <filename> - assign PARMFILE
#		  
# Date		: 03/03/25
# Author        : 
# Date          : 03/03/2025
# ModIFICATIONS : 03/03/2025 - INITIAL VERISON FOR BINCHK PROJECT.
#
# Variables Used:
PATH=/opt/rmcobol:/usr/local/bin:$PATH
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
INFILE_FLAG=0
OBJ_DIR=/usr/lnk/obj
HOSTNAME=`/usr/lnk/shell/get_hostname.sh`
DATE=`date +%Y%m%d`
SHELL_PATH=/usr/lnk/shell
TYPE="INC"
CHNGREPORT=/usr/lnk/audit/binchk/CHNGREPORT
#================================================
DEST_LOC="/tmp"
#================================================
BUCKET_NAME="ga-internal-transfers"
FILE_PATH="PDMI/DATA-ENGINEERING/misc/BINCHK"
REMOTE_LOC_PROD="${BUCKET_NAME}/${FILE_PATH}"
REMOTE_LOC_NON_PROD="${BUCKET_NAME}-dev/${FILE_PATH}"
AWS_CP="/usr/local/bin/aws s3 mv"
#================================================
MAIL_PROG="/usr/bin/mutt"
MAIL_SUBJ="BINCHK FILE, also known as erx-processor-file, is not received for ${DATE}."
MAIL_TO="operations@pdmi.com"

###############
#
# Usage routine
#
###############
usage()
{  cat << ENDOFUSAGE

usage: binchk10.sh 

ENDOFUSAGE
  exit 1
}

##################################
#
# Parse environment variables file
#
##################################
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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."
}

####################
#
# Set File Name
#
####################
set_filename()
{
#### DATE=20250507
 BINCHK_FILE=erx-processor-plan-file_BINCHK_${DATE}
}

####################
#
# Copy file from AWS
#
####################
transfer_file()
{
        if aws s3api head-object --bucket "$BUCKET_NAME" --key "$FILE_PATH/$BINCHK_FILE" > /dev/null 2>&1 
        then
          aws s3 mv "s3://${SOURCE_LOC}/${BINCHK_FILE}" "${DEST_LOC}/${BINCHK_FILE}"
          LOOP_COUNT=6
        else
          echo "-*> BINCHK file does not exist... s3://${SOURCE_LOC}/${BINCHK_FILE}"
          windup_loop
          sleep 60m
        fi
}

####################
#
# Submit  program
#
####################
submit_binchk10()
{
        runcobol ${OBJ_DIR}/binchk10  
	RETVAL=$?
        MAIL_SUBJ="BINCHK FILE, also known as erx-processor-file, is received for ${DATE}.Process completed successfully with RETVAL=${RETVAL}"
        send_email        
}

############
#
#windup_loop
#
############
windup_loop ()
{

	if [ "${LOOP_COUNT}" -eq 5 ]
	then
	    	send_email
#               ${SHELL_PATH}/create_halo_ticket.sh ${TYPE} 
        fi
}

###########
#
#send email
#
###########
send_email()
{
        echo "email - success"
	echo " ${PROGNAME}  " | ${MAIL_PROG} -s "${MAIL_SUBJ}" ${MAIL_TO}
####    exit 0
}

###############
#
# Main routine
#
##############

#============================
# Parse environment variables
#============================
parse_env

#===========================
#Identify correct AWS bucket
#===========================
if [ "${HOSTNAME}" = 'prod10' ]
then
      SOURCE_LOC=${REMOTE_LOC_PROD}
else
      SOURCE_LOC=${REMOTE_LOC_NON_PROD}
      BUCKET_NAME=${BUCKET_NAME}-dev
fi

#===========================
#set_filename
#===========================
set_filename

#===========================
#transfer file
#===========================
for ((LOOP_COUNT=1; LOOP_COUNT<=5; LOOP_COUNT++))
do
  echo $LOOP_COUNT
  transfer_file
done

BININPUT=${DEST_LOC}/${BINCHK_FILE}
export BININPUT

CHNGREPORT=${CHNGREPORT}
export CHNGREPORT

echo "BUILD OR UPDATE BINCHK0MAS RECORDS"
echo "HOSTNAME   =$HOSTNAME"
echo "RETRY COUNT = $LOOP_COUNT"
echo "ASSIGNED FILES:"
echo "BININPUT   =${BININPUT}"
echo "CHNGREPORT =${CHNGREPORT}"
echo "BINCHK0MAS =${BINCHK0MAS}"
submit_binchk10
echo "   RET_CODE =$RETVAL "

rm -f "${DEST_LOC}/${BINCHK_FILE}" 


date

exit $RETVAL 
