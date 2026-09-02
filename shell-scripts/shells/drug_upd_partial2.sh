#!/bin/ksh
#
# Program Name	: drug_upd_partial2.sh
# Description   : Select Weekly Drug Update Programs 
#                 Command Line Argument:
# Author	: Linda S. Jefferis
# Date		: 09/29/2009
# Modifications : 
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
RPT_DIR_2="/usr/lnk/misc"
MAIL_TO="Benefits@pdmi.com pharmacist@pdmi.com"
MAIL_SSI="troy.puse@scriptsense.com"
MAIL_BENEFITS="benefits@pdmi.com"
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

# Send email
send_email()
{
   if test -s ${RPT_DIR_2}/${PRINT[0]}
   then
	a2ps -1l132 -o - ${RPT_DIR_2}/${PRINT[0]} | ps2pdf - ${RPT_DIR_2}/${PRINT[0]}.pdf
	scp ${RPT_DIR_2}/${PRINT[0]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[0]}.pdf
	ssh ${REMOTE_SYS} "${MAIL_PROG} -a ${REMOTE_DIR}/${DATE}-${PRINT[0]}.pdf -s '"DRUG UPDATES - NEW GPI"' -b ljefferis@pdmi.com ${MAIL_TO} ${MAIL_SSI}"
   else
	echo "There is not a NEW GPI report for this update." | ssh ${REMOTE_SYS} ${MAIL_PROG} -s '"DRUG UPDATES - NEW GPI"' -b ljefferis@pdmi.com ${MAIL_TO} ${MAIL_SSI}
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
	ssh ${REMOTE_SYS} "${MAIL_PROG} -a ${REMOTE_DIR}/${DATE}-${PRINT[12]}.pdf -s '"DRUG UPDATES - MEDD"' ${MAIL_TO} cthornton@pdmi.com"
   else
	echo "There is no MEDD report for this update." | ${MAIL_PROG} -s '"DRUG UPDATES - MEDD"' ${MAIL_TO} cthornton@pdmi.com
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
	a2ps -1l132 -o - ${RPT_DIR_2}/${PRINT[i]} | ps2pdf - ${RPT_DIR_2}/${PRINT[i]}.pdf
	scp ${RPT_DIR_2}/${PRINT[i]}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${PRINT[i]}.pdf
	#lp ${RPT_DIR_2}/${PRINT[i]}
      fi
      let i=i+1
   done
}

# Process rpt reports
process_rpt()
{
	a2ps -1 -o - ${RPT_DIR}/${RPT_FILE} | ps2pdf - ${RPT_DIR}/${RPT_FILE}.pdf
	scp ${RPT_DIR}/${RPT_FILE}.pdf ${REMOTE_SYS}:${REMOTE_DIR}/${DATE}-${RPT_FILE}.pdf
}



#
# Main routine
#
# Check command line validity, call usage if incorrect

umask 000

   ${SHELL_DIR}/drug041.sh > ${RPT_DIR}/drug041 2>&1
   #lp ${RPT_DIR}/drug041
   RPT_FILE=drug041
   process_rpt
   ${SHELL_DIR}/drug007.sh > ${RPT_DIR}/drug007 2>&1
   #lp ${RPT_DIR}/drug007
   RPT_FILE=drug007
   process_rpt
   ${SHELL_DIR}/drug003.sh > ${RPT_DIR}/drug003 2>&1
   #lp ${RPT_DIR}/drug003
   RPT_FILE=drug003
   process_rpt
   ${SHELL_DIR}/drug022.sh > ${RPT_DIR}/drug022 2>&1
   #lp ${RPT_DIR}/drug022
   RPT_FILE=drug022
   process_rpt
   ${SHELL_DIR}/drug043.sh > ${RPT_DIR}/drug043 2>&1
   #lp ${RPT_DIR}/drug043
   RPT_FILE=drug043
   process_rpt
   ${SHELL_DIR}/drug023.sh -s 111 > ${RPT_DIR}/drug023 2>&1
   #lp ${RPT_DIR}/drug023
   RPT_FILE=drug023
   process_rpt
   ${SHELL_DIR}/gener05.sh > ${RPT_DIR}/gener05 2>&1
   #lp ${RPT_DIR}/gener05
   RPT_FILE=gener05
   process_rpt
   ${SHELL_DIR}/gener06.sh > ${RPT_DIR}/gener06 2>&1
   #lp ${RPT_DIR}/gener06
   RPT_FILE=gener06
   process_rpt
   ${SHELL_DIR}/drug039.sh > ${RPT_DIR}/drug039 2>&1
   #lp ${RPT_DIR}/drug039
   RPT_FILE=drug039
   process_rpt
   ${SHELL_DIR}/mac001.sh > ${RPT_DIR}/mac001 2>&1
   #lp ${RPT_DIR}/mac001
   RPT_FILE=mac001
   process_rpt
   ${SHELL_DIR}/mac004.sh > ${RPT_DIR}/mac004 2>&1
   #lp ${RPT_DIR}/mac004
   RPT_FILE=mac004
   process_rpt
   ${SHELL_DIR}/drug045.sh > ${RPT_DIR}/drug045 2>&1
   #lp ${RPT_DIR}/drug045
   RPT_FILE=drug045
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "4242" > ${RPT_DIR}/drug017.4242 2>&1
   #lp ${RPT_DIR}/drug017.4242
   RPT_FILE=drug017.4242
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "4545" > ${RPT_DIR}/drug017.4545 2>&1
   #lp ${RPT_DIR}/drug017.4545
   RPT_FILE=drug017.4545
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "4646" > ${RPT_DIR}/drug017.4646 2>&1
   #lp ${RPT_DIR}/drug017.4646
   RPT_FILE=drug017.4646
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "4747" > ${RPT_DIR}/drug017.4747 2>&1
   #lp ${RPT_DIR}/drug017.4747
   RPT_FILE=drug017.4747
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "4949" > ${RPT_DIR}/drug017.4949 2>&1
   #lp ${RPT_DIR}/drug017.4949
   RPT_FILE=drug017.4949
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "5050" > ${RPT_DIR}/drug017.5050 2>&1
   #lp ${RPT_DIR}/drug017.5050
   RPT_FILE=drug017.5050
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "5252" > ${RPT_DIR}/drug017.5252 2>&1
   #lp ${RPT_DIR}/drug017.5252
   RPT_FILE=drug017.5252
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "5353" > ${RPT_DIR}/drug017.5353 2>&1
   #lp ${RPT_DIR}/drug017.5353
   RPT_FILE=drug017.5353
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "6161" > ${RPT_DIR}/drug017.6161 2>&1
   #lp ${RPT_DIR}/drug017.6161
   RPT_FILE=drug017.6161
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "6262" > ${RPT_DIR}/drug017.6262 2>&1
   #lp ${RPT_DIR}/drug017.6262
   RPT_FILE=drug017.6262
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "6565" > ${RPT_DIR}/drug017.6565 2>&1
   #lp ${RPT_DIR}/drug017.6565   
   RPT_FILE=drug017.6565
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "6969" > ${RPT_DIR}/drug017.6969 2>&1
   #lp ${RPT_DIR}/drug017.6969
   RPT_FILE=drug017.6969
   process_rpt
   ${SHELL_DIR}/drug017.sh -p -t "8888" > ${RPT_DIR}/drug017.8888 2>&1
   #lp ${RPT_DIR}/drug017.8888
   RPT_FILE=drug017.8888
   process_rpt
   rm -f ${DRUG000TAP}
   send_email
   print_reports
   ssh ${REMOTE_SYS} "ls -got ${REMOTE_DIR}/${DATE}-* | ${MAIL_PROG} -s "Drug Update Report Listing" -c ${MAIL_OPER} ${MAIL_BENEFITS}


exit 0
