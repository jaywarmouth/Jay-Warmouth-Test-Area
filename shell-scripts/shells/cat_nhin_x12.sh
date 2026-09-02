#!/bin/ksh
#
# Program Name	: cat_nhin_x12.sh
# Description	: Concatenates individual payment tapes
#		  Command Line Arguments:
#		  -p <p/e Prefix>  e.g. J15
#		  -f <Alternate tape path>
# Author	: Linda S. Jefferis
# Date		: 10/16/2000
# Modifications : 04/04/2006 - Changes for new DEST_DIR logic  (LSJ)
#		: 04/23/2006 - Changes for new output directories  (LSJ)
#		: 05/02/2006 - Added copy of NHIN file to /usr/lnk/tapes  (LSJ)
#		: 05/17/2006 - Added rm of associated TEXT files  (LSJ)
#		: 03/02/2007 - Changed files to go to NHIN sub-directory  (LSJ)
#		: 08/21/2007 - Fixed rm statement for the TEXT files  (LSJ)
#		: 04/28/2009 - Reading CONFIG_FILE instead of nhin-list for list of chains  (LSJ)
#		: 09/24/2009 - Changes for switch to new check run process
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TAPE_DIR="/usr/lnk/tapes"
DEST_DIR=/usr/lnk/shares/ftp-tmp/X12
UID="NHIN"
CONFIG_FILE="/usr/local/pub/835_transfer.cfg"
LET="C"
CYCLE="chk"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cat_nhin_x12.sh [-p <p/e prefix>] [-f <directory>]

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


# Find record
find_record()
{
        IFS="$CR"
        FOUND=0
        for line in `cat $CONFIG_FILE | grep -v "^#"`
        do
                IFS="$OIFS"
                parse_record
                if [ "$UID" = "$FID" ]
                then
                       	FOUND=1
			parse_chains
                fi
        done
        if [ $FOUND = 0 ]
        then
                echo "*-> ID $UID is not found in database"
                exit 1
        fi
}

#
# Parse configuration record
parse_record()
{
        FID=`echo $line | awk -F: '{ print $1 }'`
        CHAIN_LIST=`echo $line | awk -F: '{ print $8 }'`
}

#
# Parse chain list
parse_chains()
{
	IFS=","
	for CHAIN in $CHAIN_LIST
	do
		if test -s ${DEST_DIR}/${CYCLE}/${PREFIX}${CHAIN}-${LET}-X12SEQ
  then
        		cat ${DEST_DIR}/${CYCLE}/${PREFIX}${CHAIN}-${LET}-X12SEQ >> ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-${LET}-X12
        		rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${CHAIN}-${LET}-X12SEQ
        		rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${CHAIN}TEXT-${LET}-X12
  		else
        		echo "-*> No payment tape file found for ${PREFIX}${CHAIN}-${LET}-X12SEQ"
  		fi
	done
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -p) shift
        if [ $# -le 0 ]
        then
          usage
        fi
	PREFIX=$1
	;;
    -f) shift
	if [ $# -le 0 ]
        then
          usage
        fi
	TAPE_DIR=$1
	;;
  esac
  shift
done

if test -a ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-${LET}-X12
then
   rm ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-${LET}-X12
fi

find_record

if test -s ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-${LET}-X12
then
	cp ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-${LET}-X12 ${TAPE_DIR}
else
	echo "-*> Problem creating ${PREFIX}NHIN-${LET}-X12"
	exit 1
fi

exit 0
