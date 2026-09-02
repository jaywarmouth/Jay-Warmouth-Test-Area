#!/bin/ksh
#
# Program Name	: drug_upd.sh
# Description   : Weekly Drug Update Programs 
#                 Command Line Argument:
# Author	: Linda S. Jefferis
# Date		: 06/18/96
# Modifications : 
#		  03/06/2008 Removed the drug068 process as per Benefits  (LSJ)
#		  03/06/2008 Added the PRINT_DRUG045 to the "2nd Copy" as requested by Benefits  (LSJ)
#		  04/08/2008 Added drug017.sh -p -t "7575"  (LSJ)
#		  04/29/2008 Changed the "7575" drug017.sh run to "6262"
#		  05/28/2008 Added drug017.sh -p -t "6969" and removed ones for "0415", "3737", "6767", and "0441". Based on email request from Christina.
#		  07/08/2008 Removal of drug006 process  (LSJ)
#		  08/08/2008 Removal of DIAB-PRINT-DRUG005 report  (LSJ)
#		  08/12/2008 Request to remove the drug042 process and add drug017.sh -p -t 4242  (LSJ)
#		  09/30/2008 Addition of drug069 (SUPPNAME) update process (LSJ)
#		  11/14/2008 Added SSGEN-PRINT-DRUG005 report  (LSJ)
#		  11/14/2008 Removed 3 inactive reports and renumbered PRINT[] variables  (LSJ)
#		  01/16/2009 Added email for Troy Puse at ScriptSense as per request from Benefits  (LSJ)
#		  02/25/2009 Changed email process to use ssh to husk  (LSJ)
#		  04/17/2009 Added drug017.sh -p -t "6565" process  (LSJ)
#		  04/24/2009 Added email of new MEDD report  (LSJ)
#			Changes for switch to PDF and mutt mail program
#		  07/13/2009 Added mac004.sh procedure  (LSJ)
#		  09/11/2009 Commented lp processes and added email with list of report files created  (LSJ)
#		  11/16/2009 Added drug017.sh -p -t "6666" and removed commented lp commands  (LSJ)
#		  11/25/2009 Added drug017.sh -p -t "7070" (LSJ)
#		  04/26/2010 Added drug017.sh -p -t "7171" (LSJ)
#		  05/07/2010 Added drug017.sh -p -t "0606"  (LSJ)
#		  08/17/2010 Added drug027.sh process  (LSJ)
#		  09/09/2010 Added drug017.sh -p -t "7373"  (LSJ)
#		  10/05/2010 Added drug017.sh -p -t "7474"  (LSJ)
#		  11/05/2010 Added drug017.sh -p -t "0505"  (LSJ)
#		  11/29/2010 Add drug070 process  (LSJ)
#		  07/11/2011 Add drug017.sh -p -t "7676"
#		  10/12/2011 added drug017.sh -p -t "1414"
#		  10/19/2011 add drug017.sh -p -t "7575"
#		  10/26/2011 remove drug017.sh -p -t "7676"
#		  01/11/2012 add drug017.sh -p -t 1313
#		  01/23/2012 add drug017.sh -p -t 1818
#		  11/14/2012 add drug017.sh -p -t 1212 and drug017.sh -p -t 4040 
#		  03/08/2013 commented out the mac004.sh process for now due to issues with file locking that have been occuring. Will set this up to run manually during work hours to monitor it.
#		  03/18/2013 coding changes have been made to mac004; process has been reactivated in this script.
#		  08/20/2013 remove drug022 process
#		  12/26/2013 add drug017.sh -p -t "0909"
#		  02/05/2014 add dtms07.sh
#		  02/14/2014 removed dtms07 process
#		  03/18/2014 re-added dtms07 process
#                 01/11/2012 add drug017.sh -p -t 1515 (dme)
#		  07/17/2014 add drug017.sh -p -t "8080" (dme)
#		  11/19/2014 add drug017.sh -p -t "1111" (LSJ TT #12400-2)
#		  01/21/2015 add drug017.sh -p -t "8484" (LSJ TT #12777-4)
#		  01/23/2015 removed the MAIL_SSI logic (LSJ)
#		  02/11/2015 removed drug017.sh -p -t "8484" process (TT #12777-5)
#		  02/13/2015 add drug071.sh process (LSJ)
#		  04/09/2015 add drug017.sh -p -t "8686" (LSJ TT #13469-2)
#		  06/25/2015 add  drug017.sh -p -t "2222" (DME TT:13908-2)
#		  07/30/2015 add drug017.sh -p -t 2323 (DME TT: 14908-3)
#		  10/12/2015 add drug017.sh -p -t 1717 (LSJ TTL14502-4)
#		  03/30/2016 TT3454-34 Change the multiple drug017 processes to one that runs all updates indicated in new parameter file
#		  03/02/2017 TT3200-127; new medisp0?.sh processes (replace of Flexgen update procedures).
#		  10/23/2017 add RETVAL check logic for drug005 process.
#		  08/03/2018 updtaing emails to send to benefits and clinical support only. (TT:18754-1; DME)
#
## Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
RPT_DIR_2="/usr/lnk/misc"
RPT_DIR_3="/usr/lnk/wt/oper-wt/drugupd"
MAIL_TO="Benefits@pdmi.com ClinicalSupport@pdmi.com"
MAIL_BENEFITS="benefits@pdmi.com ClinicalSupport@pdmi.com"
MAIL_OPER="operations@pdmi.com"
MAIL_PROG="/usr/bin/mutt"
EMAIL_LOG="email_drug005"
PRINT[0]="PRINT-DRUG005"		## New GPI Listing
PRINT[1]="PRINT-DRUG007"		## GPI and NDC Report
PRINT[2]="SSGEN-PRINT-DRUG005"		## Single Source Generic Report
PRINT[3]="4X4-PRINT-DRUG005"		## Drug Log Listing
PRINT[4]="GPIC-PRINT-DRUG005"		## Drug GPI Changes
PRINT[5]="NDC-PRINT-DRUG005"		## New NDC Listing
PRINT[6]="3RD-PRINT-DRUG005"		## 3rd Party Changes Report
PRINT[7]="PRINT-DRUG008"		## MAC Changes Listing
PRINT[8]="PRINT-DRUG010"		## AAWP Weekly Pricing Changes Listing
PRINT[9]="PRINT-MAC001"			## MAC Table 1 Update Report
PRINT[10]="ZERO-PRINT-DRUG005"		## Zero Unit Price Report
PRINT[11]="PRINT-DRUG045"		## Override Report
PRINT[12]="MEDD-PRINT-DRUG005"		## MEDD Report
PRINT[13]="PRINT-DRUG070"		## NABID Report
PRINT[14]="PMI-PRINT-DRUG005"		## PMI Generic Table 6110 Report
PRINT[15]="DRUG071.csv"			## AWP Litigation Re-flag	
MAXVALUE=11
DRUG000TAP="/usr/lnk/MDDB/DRUG000TAP"
REMOTE_SYS=husk
REMOTE_DIR=/usr/lnk/shares/ftp-tmp/Benefits/Drug_Reports
DATE=`date +%Y%m%d`

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: drug_upd.sh 

ENDOFUSAGE
  exit 1
}

# Set RETVAL to 0
set_init_retval()
{
	RETVAL=0
}

# Check for bad exit code
check_retval()
{
	if [ $RETVAL -ne 0 ]
	then
		echo ""
		echo "*****************************"
		echo "Fatal Process ERROR with $RPT_FILE"
		echo "*****************************"
		exit $RETVAL
	fi
}

# Send email
send_email()
{
   if test -s ${RPT_DIR_2}/${PRINT[0]}
   then
	a2ps -1l132 -o - ${RPT_DIR_2}/${PRINT[0]} | ps2pdf - ${RPT_DIR_2}/${PRINT[0]}.pdf
	scp ${RPT_DIR_2}/${PRINT[0]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[0]}.pdf
	ssh ${REMOTE_SYS} "${MAIL_PROG} -a ${REMOTE_DIR}/${DATE}-${PRINT[0]}.pdf -s '"DRUG UPDATES - NEW GPI"' ${MAIL_TO}"
   else
	echo "There is not a NEW GPI report for this update." | ssh ${REMOTE_SYS} ${MAIL_PROG} -s '"DRUG UPDATES - NEW GPI"' ${MAIL_TO}
   fi

   if test -s ${RPT_DIR_2}/${PRINT[1]}
   then
	a2ps -1l132 -o - ${RPT_DIR_2}/${PRINT[1]} | ps2pdf - ${RPT_DIR_2}/${PRINT[1]}.pdf
        scp ${RPT_DIR_2}/${PRINT[1]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[1]}.pdf
	ssh ${REMOTE_SYS} "${MAIL_PROG} -a ${REMOTE_DIR}/${DATE}-${PRINT[1]}.pdf -s '"DRUG UPDATES - GPI-NDC"' ${MAIL_TO}"
   else
	echo "There is no GPI-NDC report for this update." | ${MAIL_PROG} -s '"DRUG UPDATES - GPI-NDC"' ${MAIL_TO}
   fi
  
   if test -s ${RPT_DIR_2}/${PRINT[2]}
   then
	a2ps -1l132 -o - ${RPT_DIR_2}/${PRINT[2]} | ps2pdf - ${RPT_DIR_2}/${PRINT[2]}.pdf
        scp ${RPT_DIR_2}/${PRINT[2]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[2]}.pdf
	ssh ${REMOTE_SYS} "${MAIL_PROG} -a ${REMOTE_DIR}/${DATE}-${PRINT[2]}.pdf -s '"DRUG UPDATES - SSGEN"' ${MAIL_TO}"
   else
	echo "There is no SSGEN report for this update." | ${MAIL_PROG} -s '"DRUG UPDATES - SSGEN"' ${MAIL_TO}
   fi	

   if test -s ${RPT_DIR_2}/${PRINT[12]}
   then
	a2ps -1l132 -o - ${RPT_DIR_2}/${PRINT[12]} | ps2pdf - ${RPT_DIR_2}/${PRINT[12]}.pdf
        scp ${RPT_DIR_2}/${PRINT[12]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[12]}.pdf
	ssh ${REMOTE_SYS} "${MAIL_PROG} -a ${REMOTE_DIR}/${DATE}-${PRINT[12]}.pdf -s '"DRUG UPDATES - MEDD"' ${MAIL_TO}"
   else
	echo "There is no MEDD report for this update." | ${MAIL_PROG} -s '"DRUG UPDATES - MEDD"' ${MAIL_TO}
   fi

   if test -s ${RPT_DIR_2}/${PRINT[13]}
   then
	a2ps -1l132 -o - ${RPT_DIR_2}/${PRINT[13]} | ps2pdf - ${RPT_DIR_2}/${PRINT[13]}.pdf
        scp ${RPT_DIR_2}/${PRINT[13]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[13]}.pdf
	ssh ${REMOTE_SYS} "${MAIL_PROG} -a ${REMOTE_DIR}/${DATE}-${PRINT[13]}.pdf -s '"DRUG UPDATES - NABID/DRUG070"' ClinicalSupport@pdmi.com"
   else
	echo "There is no NABID report for this update." | ${MAIL_PROG} -s '"DRUG UPDATES - NABID/DRUG070"' ClinicalSupport@pdmi.com
   fi
}

# Print reports
print_reports()
{
   i=3
   while [ $i -le ${MAXVALUE} ]
   do
      if test -s ${RPT_DIR_2}/${PRINT[i]}
      then
	a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR_2}/${PRINT[i]} | ps2pdf - ${RPT_DIR_2}/${PRINT[i]}.pdf
	scp ${RPT_DIR_2}/${PRINT[i]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[i]}.pdf
      fi
      let i=i+1
   done
   if test -s ${RPT_DIR_2}/${PRINT[13]}
   then
	a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR_2}/${PRINT[13]} | ps2pdf - ${RPT_DIR_2}/${PRINT[13]}.pdf
	scp ${RPT_DIR_2}/${PRINT[13]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[13]}.pdf
   fi
   if test -s ${RPT_DIR_2}/${PRINT[14]}
   then
	a2ps -1l132 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR_2}/${PRINT[14]} | ps2pdf - ${RPT_DIR_2}/${PRINT[14]}.pdf
	scp ${RPT_DIR_2}/${PRINT[14]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[14]}.pdf
   fi
   if test -s ${RPT_DIR_2}/${PRINT[15]}
   then
	scp ${RPT_DIR_2}/${PRINT[15]} ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[15]}
   fi
}

# Process rpt reports
process_rpt()
{
	a2ps -1 --print-anyway=1 --non-printable-format=blank -o - ${RPT_DIR}/${RPT_FILE} | ps2pdf - ${RPT_DIR}/${RPT_FILE}.pdf
	scp ${RPT_DIR}/${RPT_FILE}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${RPT_FILE}.pdf
}


#
# Main routine
#
# Check command line validity, call usage if incorrect

umask 000

   rm -f ${RPT_DIR_2}/*-PRINT-DRUG005 ${RPT_DIR_2}/*-PRINT-DRUG005.pdf
   rm -f ${RPT_DIR_2}/PRINT-DRUG0* ${RPT_DIR_2}/PRINT-MAC001*
   ${SHELL_DIR}/drug008.sh > ${RPT_DIR}/drug008 2>&1
   RPT_FILE=drug008
   process_rpt
   ${SHELL_DIR}/drug010.sh > ${RPT_DIR}/drug010 2>&1
   RPT_FILE=drug010
   process_rpt
   ${SHELL_DIR}/medisp01.sh -o ${RPT_DIR_3}/${DATE}-MED01CSV.csv > ${RPT_DIR}/medisp01 2>&1
   RPT_FILE=medisp01
   process_rpt
   ${SHELL_DIR}/medisp02.sh -o ${RPT_DIR_3}/${DATE}-MED02CSV.csv > ${RPT_DIR}/medisp02 2>&1
   RPT_FILE=medisp02
   process_rpt
   ${SHELL_DIR}/drug005.sh > ${RPT_DIR}/drug005 2>&1
   RETVAL=$?
   RPT_FILE=drug005
   process_rpt
   check_retval
   ${SHELL_DIR}/drug041.sh > ${RPT_DIR}/drug041 2>&1
   RPT_FILE=drug041
   process_rpt
   ${SHELL_DIR}/drug007.sh > ${RPT_DIR}/drug007 2>&1
   RPT_FILE=drug007
   process_rpt
   ${SHELL_DIR}/drug003.sh > ${RPT_DIR}/drug003 2>&1
   RPT_FILE=drug003
   process_rpt
   ${SHELL_DIR}/drug043.sh > ${RPT_DIR}/drug043 2>&1
   RPT_FILE=drug043
   process_rpt
   ${SHELL_DIR}/drug023.sh -s 111 > ${RPT_DIR}/drug023 2>&1
   RPT_FILE=drug023
   process_rpt
   ${SHELL_DIR}/gener05.sh > ${RPT_DIR}/gener05 2>&1
   RPT_FILE=gener05
   process_rpt
   ${SHELL_DIR}/gener06.sh > ${RPT_DIR}/gener06 2>&1
   RPT_FILE=gener06
   process_rpt
   ${SHELL_DIR}/drug039.sh > ${RPT_DIR}/drug039 2>&1
   RPT_FILE=drug039
   process_rpt
   ${SHELL_DIR}/mac001.sh > ${RPT_DIR}/mac001 2>&1
   RPT_FILE=mac001
   process_rpt
   ${SHELL_DIR}/mac004.sh > ${RPT_DIR}/mac004 2>&1
   RPT_FILE=mac004
   process_rpt
   ${SHELL_DIR}/drug045.sh > ${RPT_DIR}/drug045 2>&1
   RPT_FILE=drug045
   process_rpt
   ${SHELL_DIR}/drug027.sh > ${RPT_DIR}/drug027 2>&1
   RPT_FILE=drug027
   process_rpt
   ${SHELL_DIR}/drug017.sh > ${RPT_DIR}/drug017 2>&1
   RPT_FILE=drug017
   process_rpt
   rm -f ${DRUG000TAP}
  
   # SUPPNAME files update
   ${SHELL_DIR}/drug069.sh > ${RPT_DIR}/drug069 2>&1
   RPT_FILE=drug069
   process_rpt

   # Drug070/NABID files update
   ${SHELL_DIR}/drug070.sh > ${RPT_DIR}/drug070 2>&1
   RPT_FILE=drug070
   process_rpt
   
   # Drug071/AWP Litigation Flag update
   ${SHELL_DIR}/drug071.sh > ${RPT_DIR}/drug071 2>&1
   RPT_FILE=drug071
   process_rpt

   print_reports
   send_email

   # DTMS07 process
   ${SHELL_DIR}/dtms07.sh > ${RPT_DIR}/dtms07 2>&1
   RPT_FILE=dtms07
   process_rpt

   # Update/Add GENER00MAS records based on Drug Type Code 1 
   # (Previously a Flexgen process - GENERUP001)
   ${SHELL_DIR}/medisp03.sh -o ${RPT_DIR_3}/${DATE}-MED03CSV.csv > ${RPT_DIR}/medisp03 2>&1
   RPT_FILE=medisp03
   process_rpt

   scp ${RPT_DIR_3}/${DATE}-* ${REMOTE_SYS}:${REMOTE_DIR}
   if [ $? -eq 0 ]
   then
   	rm -f ${RPT_DIR_3}/${DATE}-*
   fi

   ssh ${REMOTE_SYS} "ls -got ${REMOTE_DIR}/${DATE}-* | ${MAIL_PROG} -s '"Drug Update Report Listing"' -c ${MAIL_OPER} ${MAIL_TO}"
   

exit 0
