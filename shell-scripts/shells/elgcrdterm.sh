#!/bin/sh
#
#
# Program Name	: elgcrdterm.sh

# Description   : Term CARDH00MAS records that are meet the criteria - pulled from the tpm file
#                 Command line arguments:
#                 
#                 
# Author	: Debbe Kitzmiller
# Date		: 12/10/2019
# Modifications :           
#		: 
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
#      elgcrdterm.sh  no linkage - the TEST MODE WILL BE OFF AND THE DEBUG MODE WILL BE OFF AND A PARM FILE WILL BE
#                                  READ.
#      elgcrdterm.sh -a {TEST_MODE}{DEBUG_MODE} - TEST MODE AND DEBUG MODE WILL BE SET TO WHAT IS PASSED AND A 
#                                  PARM FILE WILL BE READ.
#      elgcrdterm.sh -a {TEST_MODE}{DEBUG_MODE}{TPA}{SYS_PULL}{FILE_DATE}{MAX_AMT} - WILL PULL ALL VALUES FROM LINKAGE
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
MAIL_PROG="/usr/bin/mutt"
MAIL_TO="${CS_MAIL}"
MAIL_CC="operations@pdmi.com"
REMOTEDIR="/usr/lnk/wt/oper-wt/EligReports"
RETVAL=0
ELIGTERM="/usr/lnk/tmp/elig_term.txt"

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
	  echo " -*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}
	
# Submit spcfg01 program
submit_program()
{
#      runcobol ${OBJ_DIR}/elgcrdterm -a ${TEST_MODE}${DEBUG_MODE}${TPA}${SYS_PULL}${FILE_DATE}${MAX_AMT}        
      runcobol ${OBJ_DIR}/elgcrdterm 
			RETVAL=$?     
}      

#
# Archive and removal of files
clean_up()
{
if [ ${RETVAL} == 0 ]
then
echo "RUNNING CLEANUP"
	# copy file to benefit-wt for easy review access for Client Services.
		cp	${CRDLISTTTTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv
		cp	${CRDLISTTDTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv

	# copy files for review and archiving
		cp ${CRDLISTTTTL} ${REMOTEDIR}/${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv
		cp ${CRDLISTTDTL} ${REMOTEDIR}/${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv
	
	# Move file to elig_in_1/system folder for archive of files
		mv	${CRDLISTTTTL} /usr/lnk/elig_in_1/sys${SYS_NUM}/${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv
		mv	${CRDLISTTDTL} /usr/lnk/elig_in_1/sys${SYS_NUM}/${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv

else

 # copy file to benefit-wt for easy review access for Client Services.
		cp	${CRDLISTTTTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv
		cp	${CRDLISTTDTL} /usr/lnk/wt/benefit-wt/Elig_Terms_Pulls/${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv
	
 # copy files for review and archiving
		cp ${CRDLISTTTTL} ${REMOTEDIR}/${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv
		cp ${CRDLISTTDTL} ${REMOTEDIR}/${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv
	
 # Move file to elig_in_1/system folder for archive of files
		mv	${CRDLISTTTTL} /usr/lnk/elig_in_1/sys${SYS_NUM}/${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv
		mv	${CRDLISTTDTL} /usr/lnk/elig_in_1/sys${SYS_NUM}/${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv

#email notification term failure due to mismatch totals
	echo " *** REVIEW REQUIRED ***" > ${ELIGTERM}
	echo " *** Operations does not require response.***" >> ${ELIGTERM}
echo " " >> ${ELIGTERM}
	echo " Term Process failed for ${SYS_TPA}." >> ${ELIGTERM}
	echo " " >> ${ELIGTERM}
	echo "Review and compare for record mismatches, ${SYS_TPA}-${CLIENT_ID}e-Pull-Totals-${DATETM}.csv,  ${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv,  ${SYS_TPA}-${CLIENT_ID}e-Pull-Details-${DATETM}.csv, and  ${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv, files available in \\\\file30\ClientFiles\Benefit-wt\Elig_Terms_Pulls " >> ${ELIGTERM}
	echo " "  >> ${ELIGTERM}
	echo " Details reports MESSAGE field may contain the following: " >> ${ELIGTERM}
	echo " " >> ${ELIGTERM}
	echo "		A. RECORD NOT TERMED - the record was not termed due to a manual change entry with Today's date." >> ${ELIGTERM}
	echo "		B. CONT99 NOT TERM - Record was not termed due to being locked by another user during eligibility processing" >> ${ELIGTERM}
	echo "		C. RECORD TERMED - the record was termed by exclusion with Today's date." >> ${ELIGTERM}
	echo " "  >> ${ELIGTERM}
	echo "			** Operations does not require notification.**" >> ${ELIGTERM}
	echo "	 **** Any other MESSAGES may require review from the Transaction Team ****" >> ${ELIGTERM}

cat ${ELIGTERM} | ${MAIL_PROG} -s "${SYS_TPA} - Term Process Failure" -c ${MAIL_CC} ${MAIL_TO}
cp ${ELIGTERM} /usr/lnk/wt/oper-wt/misc/elig/TermEmail-${SYS_TPA}-${SYS_TPA}.txt
fi
}            

#
# Main routine
#
# Check command line validity, call usage if incorrect

# Parse environment variables
parse_env

# Assign alternate environment variables
date
echo "EXPORT PATHS:"
echo "  CARDH00MAS=$CARDH00MAS "

# Set ELGTERMPRM based on environment
if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
    ELGTERMPRM=/usr/lnk/wt/oper-wt/elig/ELIG_PROC_PARM/${PARM_FILE}
else
    ELGTERMPRM=/usr/lnk/tmp/${PARM_FILE}
fi
export ELGTERMPRM
 echo "   ELGTERMPRM=$ELGTERMPRM "

ELGCRDKEY=/usr/lnk/tmp/ELGCRDKEY-${SYS_TPA}
export ELGCRDKEY
echo "   ELGCRDKEY=$ELGCRDKEY "

CRDLISTTDTL=/usr/lnk/tmp/${SYS_TPA}-${CLIENT_ID}e-Term-Details-${DATETM}.csv
 export CRDLISTTDTL
echo "   CRDLISTTDTL=$CRDLISTTDTL "

CRDLISTTTTL=/usr/lnk/tmp/${SYS_TPA}-${CLIENT_ID}e-Term-Totals-${DATETM}.csv
 export CRDLISTTTTL
echo "   CRDLISTTTTL=$CRDLISTTTTL "

MAXTERM=$(cat ${ELGTERMPRM} | cut -c 17-29| sed 's/^0*//')
#Run Terming process
echo "Running Terms for ${SYS_TPA}"
submit_program

# Call cleanup only for prod10 environment
if [[ "$HOSTNAME" == "prod10.pdmboardman.local" ]]; then
    clean_up
else
    echo "Non-production environment - skipping cleanup"
fi

date

exit ${RETVAL}
