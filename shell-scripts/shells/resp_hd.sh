#!/bin/ksh
#
# Program Name	: Response Screen Viewer
# Description	: Reads from daily response screen files and pulls up
#		appropriate information.
# Author	: Steven Randlett
# Date		: 12/04/01 
# Modifications : 

# Variables Used:
DATE=`date +%m%d%y`
FILE="/usr/lnk/rsp/resp"
TMPAWK="/tmp/resp_hd.awk.$USER.$$"
#TMPAWK="./resp_hd.awk"
LINE="ALL"
SYSTEM="00"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: resp_hd.sh  NABP_NUM

ENDOFUSAGE
  exit 1
}

# 
# Validate line parameters

# Trap break signal for audit trail
trap_break()
{
  rm -f $TMPFILE $TMPCLAIMS $TMPAWK
#  rm -f $TMPFILE $TMPCLAIMS 
  exit 0
}

gen_awk()
{

echo ' {
SYS=substr($0,9,2)
GRP=substr($0,91,8)
SPO=substr($0,12,3)
CRD= substr($0,78,10)
MN=substr($0,88,3)
RXD=substr($0,41,4)
CPD=substr($0,117,8)
REJ1=substr($0,109,4)
REJ2=substr($0,113,4)
PCN=substr($0,99,10)
TME1=substr($0,4,2)
TME2=substr($0,6,2)
BAT=substr($0,125,14)
LN=substr($0,1,2)

if (int(REJ1) == 0)
	OUTREJ="NONE"
else
	OUTREJ=int(REJ1)

if (int(REJ2) == 0)
	REJ2=""
else
	OUTREJ=OUTREJ "," int(REJ2)

while (length(OUTREJ) < 7)
	OUTREJ=OUTREJ " "

while (substr(PCN,length(PCN),1) == " ")
	PCN=substr(PCN,1,length(PCN)-1)

LN=int(LN)

OLN="?"

if (LN==1||LN==2||LN==3||LN==4||LN==5||LN==6||LN==7||LN==8||LN==9||LN==10)
	OLN="D"

if (LN==25||LN==26||LN==27||LN==28||LN==29||LN==30||LN==31||LN==32||LN==33||LN==34||LN==35||LN==36)
	OLN="E"

if (LN==49||LN==50||LN==51||LN==52||LN==53||LN==54||LN==55||LN==56||LN==57||LN==58||LN==59||LN==60)
	OLN="N"

printf("%s-%s %s %s %s %s %s %s %s %s %s%s %s\\n",SYS,SPO,GRP,BAT,CRD,MN,RXD,CPD,OUTREJ,OLN,TME1,TME2,PCN)

}' >$TMPAWK

}


#
# Main routine
#
trap "trap_break" 0
gen_awk

# Check command line validity, call usage if incorrect

CR="
"
FILE=${FILE}-00-${DATE}
TMPFILE="/tmp/resp_hd.$USER.$$"
TMPCLAIMS="/tmp/resp_hd_claims.$USER.$$"
 
if [ -f ${FILE} ]   
then

# LASTNABP="365315"

while [ "1" -eq "1" ]
do

echo 
echo -n "Enter NABP number or Q to quit [${LASTNABP}]: "
read SEARCH


if [ "$SEARCH" = "" ]
then
	SEARCH=${LASTNABP}
else
	LASTNABP=${SEARCH}
fi

if [ "$SEARCH" = "" ]
then
	continue
fi

case $SEARCH in 
E* | X | Q* | e* | q* | x) 
		break
		;;
esac

OIFS="$IFS"
IFS=$CR

	echo "SYS-SP GROUP#   BATCH#         CARDHOLDER MN  RXDT     COST REJECT  L TIME PCN" >$TMPFILE
	echo "-------------------------------------------------------------------------------" >>$TMPFILE
	tail -5000 $FILE |grep ${SEARCH} | sort +1 -nr | head -5 >$TMPCLAIMS


	awk -f $TMPAWK $TMPCLAIMS >>$TMPFILE
		
	cat $TMPFILE 

done
  
else
  echo "-*> Response file does not exist."
fi


exit 0
