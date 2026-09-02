#!/bin/sh
#
# Program Name	: elig_fax.sh
# Description	: Notifies when eligibility is updated
#		  Command Line Arguments:
#		  -f <elig filename; e.g. xme0707> 
#		  -d <yyyymmdd> - File update date if not current date (optional)

#
# Variables Used:
#DATE=`date +%m%d%Y`
DATE=`date +%Y%m%d`
ELIG_OUT="/usr/lnk/elig_out"
LOG=/tmp/elig_fax.log
MAIL_PROG="/bin/mail"
MAIL_CC="operations@pdmi.com"
CLIENT="null"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: elig_fax.sh [-f <elig filename>] [-d <yyyymmdd>] 

ENDOFUSAGE
  exit 1
}


# Set Variables
set_variables()
{
   if [ ${CLIENT} = "null" ]
   then
     usage
   else
     case ${CLIENT} in
	"aa")
	   SYS="0075"
           MAIL_TO="astrite@ccpa.net,bwilson@ccpa.net"
           MAIL_SUBJ="Eligibility Update"
           ;;
	"ou")
	   SYS="0105"
           MAIL_TO="ITSupport@ultrabenefits.com"
           MAIL_SUBJ="APRX-UltraBenefits Eligibility Update"
           ;;
	"ta")
	   SYS="0163"
           MAIL_TO="AlliedPBMTeam@alliedbenefit.com"
           MAIL_SUBJ="TrueScripts-Allied Eligibility Update"
           ;;
	"xc")
	   SYS="0163"
           MAIL_TO="edi@wellsystems.com"
           MAIL_SUBJ="TrueScripts-WellSystems Continental Eligibility Update"
           ;;
	"xa")
	   SYS="0163"
           MAIL_TO="Beth.White@anthem.com,dit-nasco-outbound-eligibility-reports@anthem.com"
           MAIL_SUBJ="TrueScripts-Anthem Eligibility Update"
           ;;
	"xw")
	   SYS="0163"
           MAIL_TO="operations@webtpa.com"
           MAIL_SUBJ="TrueScripts-WebTPA Eligibility Update"
           ;;
	"mb")
	   SYS="0049"
	   MAIL_TO="misnotification@medben.com"
	   MAIL_SUBJ="MedBen File Update Notification"
	   ;;
	"tc")
	   SYS="0078"
	   MAIL_TO="Benefits@pdmi.com,kmicco@pdmi.com"
	   MAIL_SUBJ="Trial Card Eligibility Update - Batch ${BATCH}"
	   ;;
	"t2")
	   SYS="0078"
	   MAIL_TO="tcaccountteam@pdmi.com"
	   MAIL_SUBJ="Trial Card EOY Eligibility Update - Batch ${BATCH}"
	   ;;
	"lc")
	   SYS="0120"
	   MAIL_TO="Daniel.McNeer@lashgroup.com,Julie.Caskey@lashgroup.com"
	   MAIL_SUBJ="Lash Copay Eligibility Update"
	   ;;
	"tm")
	   SYS="0163"
	   MAIL_TO="FILECONFIRM@MERITAIN.COM"
	   MAIL_SUBJ="TrueScripts-Meritain Eligibility Update"
	   ;;
	"gp")
	   SYS="0163"
	   MAIL_TO="siho.edi@siho.org"
	   MAIL_SUBJ="Truescripts-SIHO Eligibility Update"
	   ;;
	"pt")
	   SYS="0174"
	   MAIL_TO="tuckerh@ptsmn.org,patd@ptsmn.org,gailg@ptsmn.org"
	   MAIL_SUBJ="LBRX-PTS Eligibility Update"
	   ;;
         "lv")
           SYS="0162"
           MAIL_TO="Operations@Populytics.com"
           MAIL_SUBJ="LVHN Eligibility Update"
           ;;
         "sk")
           SYS="0194"
           MAIL_TO="Robert_S.Abraham@lvhn.org,Marjorie_J.Polis@lvhn.org,Lauren.Grantz@lvhn.org,Operations@Populytics.com"
           MAIL_SUBJ="LVHN-Schuykill Eligibility Update"
           ;;
	"wc")
           SYS="0069"
           MAIL_TO="enoel@woodcountyohio.gov,jschroeder@woodcountyohio.gov,lauren.bunn@approrx.com,hannah.bouman@approrx.com"
           MAIL_SUBJ="Wood County Eligibility Update"
           ;;
	"ah")
           SYS="0168"
           MAIL_TO="pbyrnes@vbasoftware.com,scallahan@ebs-tpa.com,cpuffer@pdmi.com"
           MAIL_SUBJ="EBS-Henry County Eligibility Update"
           ;;
	"xm")
           SYS="0163"
           MAIL_TO="misnotification@medben.com"
           MAIL_SUBJ="Truescripts File Update Notification"
	   ;;
	"la")
           SYS="0163"
           MAIL_TO="tsc-business-services@ameriben.com"
           MAIL_SUBJ="Truescripts File Update Notification"
	   ;;
        "hi")
           SYS="0134"
           MAIL_TO="340breport@healthwestinc.org"
           MAIL_SUBJ="340B Health West File Update Notification"
           ;;
    esac
    CA29_RPT=${ELIG_OUT}/sys${SYS}/${DATE}-*-CA29-${FILE}.txt
   fi
}

# Separate stats
find_stats()
{
   ADDED=`grep "TOTAL ADDED" ${CA29_RPT} | cut -c 1-24`
   CHANGED=`grep "TOTAL ADDED" ${CA29_RPT} | cut -c 25-50`
   READ=`grep "TOTAL ADDED" ${CA29_RPT} | cut -c 51-75`
}

# Group File Stats
grp_info()
{
   if test -s ${GRP_RPT}
   then
        echo "Group File Update Information:" >> ${LOG}
        grep "TOTAL RECORDS READ" ${GRP_RPT} >> ${LOG}
   else
        echo "${GRP_RPT} does not exist..."
        echo "SEE SUPERVISOR TO CORRECT ISSUE BEFORE RERUNNING..."
        exit 1
   fi
   echo "" >> ${LOG}
}

# Accumulator File Stats
accum_info()
{
   if test -s ${ACCUM_RPT}
   then
        ACC_ADDED=`grep "TOTAL ADDED" ${ACCUM_RPT} | cut -c 1-24`
        ACC_CHANGED=`grep "TOTAL ADDED" ${ACCUM_RPT} | cut -c 25-49`
        ACC_READ=`grep "TOTAL ADDED" ${ACCUM_RPT} | cut -c 50-75`
        echo "Accumulator File Update Information:" >> ${LOG}
        echo ${ACC_ADDED} >> ${LOG}
        echo ${ACC_CHANGED} >> ${LOG}
        echo ${ACC_READ} >> ${LOG}
   else
        echo "${ACCUM_RPT} does not exist"
        usage
   fi
}

	
#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	FILE=$1
	;;
    -d) shift
	DATE=$1
	;;
 esac
  shift
done


umask 002

if [ ${FILE} = "null" ]
then
	usage
fi
CLIENT=${FILE:0:2}
FILE_DATE=${FILE:3:4}
set_variables

if test -s ${CA29_RPT}
then
   echo "PHARMACY DATA MANAGEMENT" > ${LOG}
   echo "ELIGIBILITY UPDATE NOTIFICATION" >> ${LOG}
   echo "SYSTEM:  ${SYS}" >> ${LOG}
   echo "" >> ${LOG}            
   echo "Date Eligibility Updated: "${DATE} >> ${LOG}
   echo "" >> ${LOG}

   find_stats

   echo ${ADDED} >> ${LOG}
   echo ${CHANGED} >> ${LOG}
   echo ${READ} >> ${LOG}
   echo "" >> ${LOG}
   case ${CLIENT} in
     "mb")
	GRP_RPT="/usr/lnk/misc/GROUP29-DONE-RPT-mb"
	grp_info
	#ACCUM_RPT="${ELIG_OUT}/sys${SYS}/${DATE}-*-ACCUM01-ERRSUM-mbl${FILE_DATE}.txt"
	#ACCUM_RPT="/usr/lnk/misc/ACCUM-01-${SYS}"
	#accum_info
	cat ${LOG} | ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_CC} ${MAIL_TO}
	;;
      *) cat ${LOG} | ${MAIL_PROG} -s "${MAIL_SUBJ}" -c ${MAIL_CC} ${MAIL_TO}
        ;;
   esac
else
   echo "${CA29_RPT} does not exist" 
   usage
fi

exit 0
