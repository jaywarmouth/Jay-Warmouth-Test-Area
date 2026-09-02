#!/bin/ksh
#
# Program Name	: drug_upd.sh
# Description   : Weekly Drug Update Programs 
#                 Command Line Argument:
#                 -d <current date - yymmdd>
# Author	: Linda S. Jefferis
# Date		: 05/22/2002
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/lnk/rpt"
RPT_DIR_2="/usr/lnk/misc"
MAIL_TO="Benefits@pdmi.com gneel@pdmi.com"
EMAIL_LOG="email_drug005"
PRINT[0]="PRINT-DRUG005"
PRINT[1]="PRINT-DRUG007"
PRINT[2]="BC-PRINT-DRUG005"
PRINT[3]="4X4-PRINT-DRUG005"
PRINT[4]="GPIC-PRINT-DRUG005"
PRINT[5]="DIAB-PRINT-DRUG005"
PRINT[6]="TC26-PRINT-DRUG005"
PRINT[7]="SCND-PRINT-DRUG005"
PRINT[8]="NDC-PRINT-DRUG005"
PRINT[9]="3RD-PRINT-DRUG005"
PRINT[10]="PRINT-DRUG008"
PRINT[11]="PRINT-DRUG010"
PRINT[12]="PRINT-MAC001"
MAXVALUE=12

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
      cat ${RPT_DIR_2}/${PRINT[0]} | mail ${MAIL_TO}
      cat ${RPT_DIR_2}/${PRINT[1]} | mail ${MAIL_TO}
   fi
}

# Print reports
print_reports()
{
   i=2
   while [ $i -le ${MAXVALUE} ]
   do
      if test -s ${RPT_DIR_2}/${PRINT[i]}
      then
         lp ${RPT_DIR_2}/${PRINT[i]} 
      fi
      let i=i+1
   done
}

#
# Print 2nd Copies
print_2()
{
   /usr/lnk/po/ban-drugrpts | lp
   lp ${RPT_DIR_2}/${PRINT[3]}
   lp ${RPT_DIR_2}/${PRINT[8]}
   lp ${RPT_DIR_2}/${PRINT[10]}
   lp ${RPT_DIR_2}/${PRINT[11]}
}


#
# Main routine
#
# Check command line validity, call usage if incorrect

   #rm ${RPT_DIR_2}/*-PRINT-DRUG005
   #rm ${RPT_DIR_2}/PRINT-DRUG0*
   #${SHELL_DIR}/drug008.sh > ${RPT_DIR}/drug008 2>&1
   #lpp ${RPT_DIR}/drug008
   #${SHELL_DIR}/drug010.sh > ${RPT_DIR}/drug010 2>&1
   #lpp ${RPT_DIR}/drug010
   #${SHELL_DIR}/drug005.sh > ${RPT_DIR}/drug005 2>&1
   #lpp ${RPT_DIR}/drug005
   ${SHELL_DIR}/drug006.sh > ${RPT_DIR}/drug006 2>&1
   lp ${RPT_DIR}/drug006
   ${SHELL_DIR}/drug007.sh > ${RPT_DIR}/drug007 2>&1
   lp ${RPT_DIR}/drug007
   ${SHELL_DIR}/drug003.sh > ${RPT_DIR}/drug003 2>&1
   lp ${RPT_DIR}/drug003
   ${SHELL_DIR}/drug025.sh > ${RPT_DIR}/drug025 2>&1
   lp ${RPT_DIR}/drug025
   ${SHELL_DIR}/drug017.sh -p -t "0415" > ${RPT_DIR}/drug017.0415p 2>&1
   lp ${RPT_DIR}/drug017.0415p
   ${SHELL_DIR}/drug017.sh -p -t "5050" > ${RPT_DIR}/drug017.5050 2>&1
   lp ${RPT_DIR}/drug017.5050
   ${SHELL_DIR}/drug017.sh -p -t "3737" > ${RPT_DIR}/drug017.3737 2>&1
   lp ${RPT_DIR}/drug017.3737
   ${SHELL_DIR}/drug022.sh > ${RPT_DIR}/drug022 2>&1
   lp ${RPT_DIR}/drug022
   ${SHELL_DIR}/drug023.sh -s 111 > ${RPT_DIR}/drug023 2>&1
   lp ${RPT_DIR}/drug023
   ${SHELL_DIR}/gener05.sh > ${RPT_DIR}/gener05 2>&1
   lp ${RPT_DIR}/gener05
   ${SHELL_DIR}/gener06.sh > ${RPT_DIR}/gener06 2>&1
   lp ${RPT_DIR}/gener06
   ${SHELL_DIR}/drug039.sh > ${RPT_DIR}/drug039 2>&1
   lp ${RPT_DIR}/drug039
   ${SHELL_DIR}/mac001.sh > ${RPT_DIR}/mac001 2>&1
   lp ${RPT_DIR}/mac001
   #send_email
   #print_reports
   #print_2

exit 0
