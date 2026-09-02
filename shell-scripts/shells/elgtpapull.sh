#!/bin/sh
#
#
# Program Name	: elgtpapull.sh

# Description   : Pull TPM00MAS records that meet the criteria - tpa and date
#                 Command line arguments (updated parameter order):
#                 $1 - CLIENT_ID
#                 $2 - SYS_NUM (System number)
#                 $3 - TPA (4 characters)
#                 $4 - PROCESS_DATE (CCYYMMDD)
#                 $5 - CS_MAIL (optional, defaults to operations@pdmi.com)
#                 
# Author	: Debbe Kitzmiller
# Date		: 12/10/2019
# Modifications :           
#		: 2025-11-07 - Updated parameter order for consistency
# 
#     This can be run with either linkage or a file.
#     The values are:
#          TEST_MODE Y - TEST MODE IS ON, N - TEST MODE IS OFF DEFAULT IS OFF
#          DEBUG_MODE Y - DEBUG MODE IS ON, N DEBUG MODE IS OFF DEFAULT IS OFF
#          IF USING LINKAGE ALL THE FIELDS ARE REQUIRED
#          TPA - PIC X(4) - THE TPA USED TO PULL RECORDS FROM THE TPM00MAS FILE
#          SYS_PULL PIC 9(4) - THE SYSTEM USED TO PULL RECORDS FROM THE TPM00MAS FILE
#          FILE_DATE PIC 9(8) - CCYYMMDD - THE DATE USED TO CHECK EFFECTIVE AND TERMINATION DATES ON TPM00MAS
#          MAX-AMT NUMERIC VALUE UP TO A LENGTH OF 9(13), NOT USED IN THE PULL FOR TPM00MAS RECORDS
#                                                         BUT USED WHEN PULLLING CARDHOLDER RECORDS.
#                                                         THE VALUE IS IN 0 - 9999999999999. 
#                      NOTE DO NOT NEED TO HAVE LEADING ZEROES.
#     COMMAND LINES:
#      elgtpapull.sh  no linkage - the TEST MODE WILL BE OFF AND THE DEBUG MODE WILL BE OFF AND A PARM FILE WILL BE
#                                  READ.
#      elgtpapull.sh -a {TEST_MODE}{DEBUG_MODE} - TEST MODE AND DEBUG MODE WILL BE SET TO WHAT IS PASSED AND A 
#                                  PARM FILE WILL BE READ.
#      elgtpapull.sh -a {TEST_MODE}{DEBUG_MODE}{TPA}{SYS_PULL}{FILE_DATE}{MAX_AMT} - WILL PULL ALL VALUES FROM LINKAGE
#                                  NO PARM FILE WILL BE READ
#         
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="

OBJ_DIR="/usr/lnk/obj"
DATETM=`date +%Y%m%d-%H%M%S`
CLIENT_ID="${1}"
SYS_NUM="${2}"
TPA="${3}"
PROCESS_DATE="${4}"
CS_MAIL="${5:-operations@pdmi.com}"
PARM_FILE="${SYS_NUM}${TPA}-${PROCESS_DATE}.txt"
SYS_TPA="${SYS_NUM}${TPA}"
RETVAL=0
MAIL_TXT="/usr/lnk/tmp/elig_term.txt"
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="${CS_MAIL}"
MAIL_CC="operations@pdmi.com"

# Determine REMOTEDIR based on environment
if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
    REMOTEDIR="/usr/lnk/wt/oper-wt/EligReports"
else
    REMOTEDIR="/usr/lnk/wt/oper-wt/EligReports-Test"
fi

ELIGTERM="/usr/lnk/tmp/EligTerm.txt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elgtpapull.sh -a [${TEST_MODE}${DEBUG_MODE}${TPA}${SYS_PULL}${FILE_DATE}${MAX_AMT}]

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

	
# Submit spcfg01 program
submit_program()
{
    # Pull TPA00MAS Information

			runcobol ${OBJ_DIR}/elgtpapull       
#      runcobol ${OBJ_DIR}/elgtpapull -a ${TEST_MODE}${DEBUG_MODE} D     
#			runcobol ${OBJ_DIR}/elgtpapull -a ${TEST_MODE}${DEBUG_MODE}${TR_FROM}${SYS_PULL}${FILE_DATE}${MAX_AMT}  
			RETVAL=$?
	echo "TPA PULL RETURN VALUE IS ${RETVAL}"
      
if [ ${RETVAL} == 0 ]
then
    # Pull Card List
    
      runcobol ${OBJ_DIR}/elgcrdpull       
#      runcobol ${OBJ_DIR}/elgcrdpull -a ${TEST_MODE}${DEBUG_MODE}      
#		  runcobol ${OBJ_DIR}/elgcrdpull -a ${TEST_MODE}${DEBUG_MODE}${TR_FROM}${SYS_PULL}${FILE_DATE}${MAX_AMT}  
	RETVAL=$?  
echo "CARD Pull RETURN VALUE IS ${RETVAL}"
else
	echo "Issue with TPA Pull Please review and rerun if approved"
	exit ${RETVAL}
fi

}      

#
# Archive and removal of files
clean_up()
{
	# copy file to benefit-wt for easy review access for Client Services.
	cp	${CRDLISTPTTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv
	cp	${CRDLISTPDTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv
	
	# Move file to elig_in_1/system folder for archive of files
	mv	${CRDLISTPTTL} /usr/lnk/elig_in_1/sys${SYS_NUM}/${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv
	mv	${CRDLISTPDTL} /usr/lnk/elig_in_1/sys${SYS_NUM}/${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv
}

#
# Handle results processing (prod10 only)
handle_results()
{
	if [ ${RETVAL} == 0 ]
	then
		clean_up
	elif [ ${RETVAL} == 79 ]
	then
		clean_up

		#send email that terms are 0 to operations
		echo	" *** 0 TERMS TO PROCESS *** " > ${ELIGTERM}
		echo " " >> ${ELIGTERM}
		echo " 0 terms are set to process. " >> ${ELIGTERM}
		echo " " >> ${ELIGTERM}
		echo " Please review ${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv and ${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv files available in \\\\file30\ClientFiles\Benefit-wt\Elig_Terms_Pulls" >> ${ELIGTERM}

		cat ${ELIGTERM} | ${MAIL_PROG} -s "${SYS_TPA} - No Terms" ${MAIL_CC} 
		
		#copy Files to Benefit Direcotry for review
		cp	${CRDLISTPTTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv
		cp	${CRDLISTPDTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv
		
		#Copy Output Reports for Review and archive
		cp /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv ${REMOTEDIR}/${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv
		cp /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv ${REMOTEDIR}/${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv

		# Move file to elig_in_1/system folder for archive of files
		mv	${CRDLISTPTTL} /usr/lnk/elig_in_1/sys${SYS_NUM}/${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv
		mv	${CRDLISTPDTL} /usr/lnk/elig_in_1/sys${SYS_NUM}/${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv

	elif [ ${RETVAL} == 89 ]
	then
		clean_up
		#email that Max term is exceeded and approval is needed
		echo " *** REVIEW AND APPROVAL REQUIRED ***" > ${ELIGTERM}
		echo " " >> ${ELIGTERM}
		echo " Term total exceeds allowable maximum threshold of ${MAXTERM}." >> ${ELIGTERM}
		echo " " >> ${ELIGTERM}
		echo "Review ${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv and ${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv files available in \\\\file30\ClientFiles\Benefit-wt\Elig_Terms_Pulls" >> ${ELIGTERM}
		echo " " >> ${ELIGTERM}
		echo "What to do:" >> ${ELIGTERM}
		echo "	1.	Follow link in email and review CSV files" >> ${ELIGTERM}
		echo "	2.	Contact client If it is needed and respond ALL to email that you have done so." >> ${ELIGTERM}
		echo "	3.	After receiving response from Client Respond to operations of How to handle terming." >> ${ELIGTERM}
		echo "			a.	Send notification to Not Term and if We should be expecting a corrected file to be uploaded." >> ${ELIGTERM}
		echo "			b.	Send Notification to term and include the total number of terms from the Pull-Totals csv file so that operations Knows what to reset the Maximum number of terms to for processing." >> ${ELIGTERM}

	cat ${ELIGTERM} | ${MAIL_PROG} -s "${SYS_TPA} - Term Maximum Exceeded" -c ${MAIL_CC} ${MAIL_TO}
	cp ${ELIGTERM} /usr/lnk/wt/oper-wt/misc/elig/PullEmail-${SYS_TPA}-${SYS_TPA}.txt

	else
		# copy file to benefit-wt for easy review access for Client Services.
		cp	${CRDLISTPDTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv
		cp	${CRDLISTPTTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv

		# copy files for review and archiving
		cp	${CRDLISTPDTL} ${REMOTEDIR}/${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv
		cp	${CRDLISTPTTL} ${REMOTEDIR}/${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv

		echo "Issue Processing Card and TPA pulls FOR ${SYS_TPA}. Please Review and rerun process if necessary."
	fi
}      

#
# Main routine
#
#Check command line validity, call usage if incorrect

 
#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env


# THE FOLLOWING VARIABLES ARE USED TO 
#     TURN ON DEBUG AND TEST FUNCTIONS
# USE "Y" ON EITHER ONE TO ACTIVE


# END OF TEST AND DEBUG SWITCHES


# Assign alternate environment variables
ELGCRDALTKEY=/usr/lnk/tmp/ELGCRDALTKEY-${SYS_TPA}
export ELGCRDALTKEY

ELGCRDKEY=/usr/lnk/tmp/ELGCRDKEY-${SYS_TPA}
export ELGCRDKEY

# Set ELGTERMPRM based on environment
if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
    ELGTERMPRM=/usr/lnk/wt/oper-wt/elig/ELIG_PROC_PARM/${PARM_FILE}
else
    ELGTERMPRM=/usr/lnk/tmp/${PARM_FILE}
fi
export ELGTERMPRM 

CRDLISTPDTL=/usr/lnk/tmp/${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv
  export CRDLISTPDTL 

CRDLISTPTTL=/usr/lnk/tmp/${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv
  export CRDLISTPTTL



date
echo "EXPORT PATHS:"
echo "	TPM00MAS=$TPM00MAS "
echo "	ELGTERMPRM=$ELGTERMPRM "
echo "	ELGCRDALTKEY=$ELGCRDALTKEY "
echo "	ELGCRDKEY=$ELGCRDKEY "
echo "	CRDLISTPTTL=$CRDLISTPTTL "
echo "	CRDLISTPDTL=$CRDLISTPDTL "
 MAXTERM=$(cat ${ELGTERMPRM} | cut -c 17-29| sed 's/^0*//') 
         

submit_program

# Handle results only for prod10 environment
if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
    handle_results
else
    echo "Non-production environment - skipping result processing"
fi

date

exit ${RETVAL}
