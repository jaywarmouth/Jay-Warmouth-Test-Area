#!/bin/ksh
#
# Program Name  : recover_files.sh
# Description   : Runs recover1 on indicated files
#		  Command Line Arguments:
#		  -r <system name> 
# Author        : Linda S. Jefferis
# Date          : 09/20/2012
# Modifications	: 10/23/2012 - Removed all logic for CLCOB00MAS file
#		: 08/20/2013 - Add CARDH00MAS for prod20
#		: 09/10/2013 - Added EXCEP00MAS for prodtest10
#		: 01/15/2014 - Added LIMIT00MAS for prodtest10
#		: 04/11/2014 - Removed CARDH00MAS for prod20
#		: 02/25/2015 - add logic for testprod11
#		: 05/31/2016 - TT5525-7 add CARDH00MAS for Testprod11
#		: 05/31/2016 - TT13990-22 add logic for Testprod12,Testprod21
#		: 06/30/2016 - Added CATAB00MAS to TestProd11 file list.
#		: 10/20/2016 - Change TESTPROD21 to UATTrans20.
#		: 01/10/2019 - Add back logic for CobolQA20
#
# Variables Used:
PATH=$PATH:/usr/local/bin
OUTPUT_DIR="/usr/lnk/backup"
OUT_LOG="${OUTPUT_DIR}/daily_recover.log"
SHELL="/usr/lnk/shell"
MAIL_TO="operations@pdmi.com"
MAIL_PROG="/bin/mail"
RECOVER_PROG="/usr/rmcobol/recover1"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: recover_files.sh [-r <system name>]

ENDOFUSAGE
  exit 1
}

#
# Recover files
recover_file()
{
	date >> ${OUT_LOG}
        echo "" >> ${OUT_LOG}
	echo "Running recover1 on ${FNAME}" >> ${OUT_LOG}
        ${RECOVER_PROG} ${FNAME} /usr/lnk/wrk/drop-${FCODE} -L /usr/lnk/wrk/log-${FCODE} -Q -Y
        if test $? -eq 0
        then
                echo "Recovery of ${FNAME} is completed" >> ${OUT_LOG}
        else
                echo "Error with recovery of ${FNAME}" >> ${OUT_LOG}
        fi
        echo "" >> ${OUT_LOG}
        echo "LOG INFORMATION FROM RECOVER1" >> ${OUT_LOG}
        cat /usr/lnk/wrk/log-${FCODE} >> ${OUT_LOG}
        rm -f /usr/lnk/wrk/log-${FCODE}
        date >> ${OUT_LOG}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -r) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	SYSTEM=$1
	;;
     *) usage
	;;
  esac
  shift
done

rm -f ${OUT_LOG}

if [ ${SYSTEM} = "prod11" ]
then
        FNAME=/usr/lnk/crd_01/ONETM00MAS
	FCODE=onetm
	recover_file
	
        FNAME=/usr/lnk/claims/REVER00MAS
	FCODE=rev
	recover_file
	
        FNAME=/usr/lnk/claims/PDECL00MAS
	FCODE=pde
	recover_file

	FNAME=/usr/lnk/claims/CLAIM80MAS
        FCODE=claim80
        recover_file

        FNAME=/usr/lnk/crd_01/CARDI00MAS
	FCODE=cardi
	recover_file

	#FNAME=/usr/lnk/clmsg/CLDEM00MAS
        #FCODE=cldem
        #recover_file

        #FNAME=/usr/lnk/crd_02/CARDH00MAS
	#FCODE=card
	#recover_file

fi	

if [ ${SYSTEM} = "prod20" ]
then
        FNAME=/usr/lnk/crd_01/ONETM00MAS
	FCODE=onetm
	recover_file
	
        FNAME=/usr/lnk/claims/REVER00MAS
	FCODE=rev
	recover_file
	
        FNAME=/usr/lnk/claims/PDECL00MAS
	FCODE=pde
	recover_file

        FNAME=/usr/lnk/crd_01/CARDI00MAS
	FCODE=cardi
	recover_file

fi	


if [ ${SYSTEM} = "prodtest10" ]
then
	FNAME=/usr/lnk/crd_02/CARDH00MAS
        FCODE=card
        recover_file

	FNAME=/usr/lnk/crd_01/CATAB00MAS
        FCODE=catab
        recover_file

	FNAME=/usr/lnk/crd_01/EXCEP00MAS
        FCODE=excep
        recover_file

	FNAME=/usr/lnk/crd_01/LIMIT00MAS
        FCODE=limit
        recover_file
fi

if [ ${SYSTEM} = "TestProd11" ]
then
        FNAME=/usr/lnk/claims/REVER00MAS
        FCODE=rever
        recover_file

        FNAME=/usr/lnk/crd_01/EXCEP00MAS
        FCODE=excep
        recover_file

        FNAME=/usr/lnk/crd_01/LIMIT00MAS
        FCODE=limit
        recover_file

        FNAME=/usr/lnk/crd_01/CATAB00MAS
        FCODE=catab
        recover_file

        FNAME=/usr/lnk/crd_02/CARDH00MAS
        FCODE=card
        recover_file

        FNAME=/usr/lnk/crd_01/ONETM00MAS
        FCODE=onetm
        recover_file

fi

if [ ${SYSTEM} = "CobolQA20" ]
then
        FNAME=/usr/lnk/claims/REVER00MAS
        FCODE=rev
        recover_file

        FNAME=/usr/lnk/crd_01/EXCEP00MAS
        FCODE=excep
        recover_file

        FNAME=/usr/lnk/crd_01/LIMIT00MAS
        FCODE=limit
        recover_file

        FNAME=/usr/lnk/crd_01/CATAB00MAS
        FCODE=catab
        recover_file

        FNAME=/usr/lnk/crd_02/CARDH00MAS
        FCODE=card
        recover_file

fi
if [ ${SYSTEM} = "TESTPROD12" ]
then
        FNAME=/usr/lnk/crd_01/EXCEP00MAS
        FCODE=excep
        recover_file

        FNAME=/usr/lnk/crd_01/LIMIT00MAS
        FCODE=limit
        recover_file

        FNAME=/usr/lnk/crd_02/CARDH00MAS
        FCODE=card
        recover_file

fi

if [ ${SYSTEM} = "UATTrans20" ]
then
        FNAME=/usr/lnk/crd_01/EXCEP00MAS
        FCODE=excep
        recover_file

        FNAME=/usr/lnk/crd_01/LIMIT00MAS
        FCODE=limit
        recover_file

        FNAME=/usr/lnk/crd_02/CARDH00MAS
        FCODE=card
        recover_file

fi

if [ ${SYSTEM} = "husk" ]
then
        FNAME=/usr/lnk/claims/REVER00MAS
        FCODE=rev
        recover_file

        FNAME=/usr/lnk/crd_02/CARDH00MAS
        FCODE=card
        recover_file

        FNAME=/usr/lnk/crd_01/CATAB00MAS
        FCODE=catab
        recover_file

fi

${MAIL_PROG} -s "Recover Files for ${SYSTEM}" ${MAIL_TO} < ${OUT_LOG}

exit 0
