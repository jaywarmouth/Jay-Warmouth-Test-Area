#!/bin/sh
#
# Program Name	: cat_nhin_5010.sh
# Description	: Combine 5010 NHIN files
#		  Command Line Arguments:
#		  -p <p/e Prefix>  e.g. J15
#		  -f <Alternate tape path>
# Author	: Linda S. Jefferis
# Date		: 10/24/2011
# Modifications : 12/13/2011 - name of CONFIG_FILE
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
TAPE_DIR="/usr/lnk/tapes"
DEST_DIR=/usr/lnk/wt/pdm/reconx12
PUID="NHIN"
CONFIG_FILE="/usr/local/etc/835_transfer.cfg"
CYCLE="chk"


#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cat_nhin_5010.sh [-p <p/e prefix>] [-f <directory>]

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
                if [ "$PUID" = "$FID" ]
                then
                       	FOUND=1
			parse_chains
                fi
        done
        if [ $FOUND = 0 ]
        then
                echo "*-> ID $PUID is not found in database"
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
		if test -s ${DEST_DIR}/${CYCLE}/${PREFIX}${CHAIN}-V5010
  then
        		cat ${DEST_DIR}/${CYCLE}/${PREFIX}${CHAIN}-V5010 >> ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-V5010
        		rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${CHAIN}-V5010
        		rm -f ${DEST_DIR}/${CYCLE}/${PREFIX}${CHAIN}-V5010-TEXT
  		else
        		echo "-*> No payment tape file found for ${PREFIX}${CHAIN}-V5010"
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

if test -a ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-V5010
then
   rm ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-V5010
fi

find_record

if test -s ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-V5010
then
	cp ${DEST_DIR}/${CYCLE}/NHIN/${PREFIX}NHIN-V5010 ${TAPE_DIR}
	FOUND_FILE=1
fi

if [ ${FOUND_FILE} = 0 ]
then
	echo "-*> Problem creating NHIN File"
	exit 1
fi

exit 0
