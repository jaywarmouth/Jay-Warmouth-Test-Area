#!/bin/ksh
#
# Program Name	: arch_realtime_elig.sh
# Description	: Automatic archiving procedure for Real Time elig. files
# Author	: Linda S. Jefferis
# Date		: 10/05/05
# Modifications : 10/28/2005 - Changes for Linux  (LSJ)
#		: 01/31/2006 - Addition of sys073  (LSJ)
#		: 03/28/2006 - Addition of sys054  (LSJ)
#		: 08/23/2006 - Changes for 4-digit system number  (LSJ)
#		: 04/30/2007 - Addition of jj (sys0088) files  (LSJ)
#		: 06/24/2008 - Addition of lp (sys0109) files  (LSJ)
#		: 12/10/2008 - Addition of lt (sys0114) and ln (sys0115)
#		: 02/13/2009 - Addition of pg (sys0075); replaced gd logic
#		: 11/18/2009 - Addition of lc (sys0120)
#		: 11/18/2009 - Combined selection of D and R files
#		: 12/21/2009 - Addition of oh (sys0125)
#		: 12/27/2009 - Changed CLIENT_ID_[D,R]_* to CLIENT_ID_[D,R]_??????
#		: 12/29/2009 - Added process for LIMRT01-* files
#		: 05/17/2010 - Added logic for lr (sys0126)
#		: 12/30/2010 - Added logic for hc (sys0073)
#		: 12/30/2010 - Added logic for p2 (sys0075)
#		: 01/24/2011 - Added logic for ls (sys0132)
#		: 07/11/2011 - Added logc for p3 (sys0075)
#		: 12/29/2011 - Added logic for ch (sys0118)
#		: 09/18/2012 - Added logic for tl (sys0152
#		: 10/10/2012 - Added logic for ar (sys0123)
#		: 03/29/2013 - Added logic for hb (sys0073)
#		: 04/01/2013 - Added logic for ????CLCD01 files (sys0078)
#               : 04/29/2013 - Added logic for ????CDRT files (sys0075)
#		: 04/29/2013 - Changed logic to use tcpfileclaim.client config file instead of adding logic for each new client code.
#		Changes for new zippass.sh process. Eliminate zipping in this script.
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
RPT_DIR="/usr/lnk/misc"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: arch_realtime_elig.sh 

ENDOFUSAGE
  exit 1
}

#
# Parse environment variables file 
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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Archive process
arch_proc()
{
	cd ${ELIG_DIR}
	find . -name "${CLIENT}_[D,R]_??????" -daystart -mtime +3 -print > /tmp/elig-filelist

	for FILE in `cat /tmp/elig-filelist`
	do
  	 	mv $FILE ${ARCH_DIR}
   		if test $? -ne 0
   		then
   	   		echo "-*> Error with elig file copy"
   	   		exit 1
   		fi
	done
	find . -name "${SYS}ELRT*" -daystart -mtime +3 -print > /tmp/elig-filelist2
	for FILE2 in `cat /tmp/elig-filelist2`
	do
   		mv $FILE2 ${ARCH_DIR}
   		if test $? -ne 0
   		then
  			echo "-*> Error with elig out file copy"
      			exit 1
   		fi
	done

	find . -name "ELG??-${SYS}-*" -daystart -mtime +3 -print > /tmp/elig-filelist3
	for FILE3 in `cat /tmp/elig-filelist3`
	do
   		mv $FILE3 ${ARCH_DIR}
   		if test $? -ne 0
   		then
   		   echo "-*> Error with error report file copy"
   		fi
	done

	find . -name "LIMRT01-*" -daystart -mtime +3 -print > /tmp/elig-filelist4
	for FILE4 in `cat /tmp/elig-filelist4`
	do
   		mv $FILE4 ${ARCH_DIR}
   		if test $? -ne 0
   		then
   		   echo "-*> Error with limit report file copy"
   		fi
	done

	find . -name "${CLIENT}_form_[D,R]_??????" -daystart -mtime +3 -print > /tmp/elig-filelist5
	for FILE5 in `cat /tmp/elig-filelist5`
	do
  	 	mv $FILE5 ${ARCH_DIR}
   		if test $? -ne 0
   		then
   	   	   echo "-*> Error with elig file copy"
   	   	   exit 1
   		fi
	done

	find . -name "${SYS}CLCD*" -daystart -mtime +3 -print > /tmp/elig-filelist6
	for FILE6 in `cat /tmp/elig-filelist6`
	do
   		mv $FILE6 ${ARCH_DIR}
   		if test $? -ne 0
   		then
  		    echo "-*> Error with elig out file copy"
      		    exit 1
   		fi
	done

}


#
# Main routine
#

DATAFILE="/usr/local/etc/rte/tcpfileclaim.clients"


echo "Client Data Archived:"
OIFS="$IFS"
IFS="$CR"
for line in `cat $DATAFILE | grep -v "^#"`
do
        IFS="$OIFS"
        CLIENT=`echo $line | awk '{ print $1 }'`
        ELIG_DIR=`echo $line | awk '{ print $2 }'`
	SYS_DIR=`echo ${ELIG_DIR} | awk -F/ '{ print $5 }'`
	SYS=`echo ${SYS_DIR} | cut -c4-8`
	ARCH_DIR="/usr/lnk/elig_out/${SYS_DIR}"
	echo "$CLIENT, $ELIG_DIR, $ARCH_DIR"
	arch_proc
done

rm /tmp/elig-filelist
rm /tmp/elig-filelist2
rm /tmp/elig-filelist3
rm /tmp/elig-filelist4
rm /tmp/elig-filelist5
   
exit 0
