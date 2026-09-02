#!/bin/ksh
#
# Program Name	: lddea.sh
# Description	: Copies the dea file from CD puts it on the production machine for updating. 
# Author	: Linda S. Jefferis
# Date		: 04/19/2001
# Modifications : 11/30/2005 - Changes for system names  (LSJ)
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
DEST_DIR="/usr/lnk/sort"
LOAD_PATH="/usr/lnk/sort"
CD_PATH="/opt/cdrom"
CD_FILE="dea??????.txt"
MOUNT_PROG="/usr/local/bin/mountcd"
REMOTE="rook"
DEA_INP="DEA000TAP"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: lddea.sh 

ENDOFUSAGE
  exit 1
}

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
	  echo "-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}

#
# Mount CD
mount_cd()
{
        echo "Mounting CD"
        ${MOUNT_PROG}
        if test $? -ne 0
        then
           echo ""
           echo "-*> MOUNT OF CD WAS UNSUCCESSFUL -- EXITING SCRIPT"
           echo "-*> PLEASE SEE SUPERVISOR"
           exit 1
        else
           echo ""
           echo "-=> CD is mounted"
        fi
}

#
# Get file from CD
get_files()
{
	cp ${CD_PATH}/${CD_FILE} ${LOAD_PATH}
}

#
# Copy files
copy_files()
{
	rcp ${LOAD_PATH}/${CD_FILE} ${REMOTE}:${DEST_DIR}/${DEA_INP}
}

#
# Unmount CD
unmount_cd()
{
        echo ""
        echo "--> Unmounting CD"
        ${MOUNT_PROG} -u
        if test $? -ne 0
        then
           echo ""
           echo "-*> The unmount of the CD was unsuccessful - exiting script"
           echo "-*> You will not be able remove the CD until it has been unmoun
ted"
           echo "-*> Please see your supervisor"
           exit 1
        else
           echo ""
           echo "--> The CD is unmounted"
        fi
}

#
# Main routine
#
# Check command line validity, call usage if incorrect

date

mount_cd

echo 
echo "--> Getting file from CD"
get_files

date

echo
echo "--> Copying files to ${REMOTE}"
echo
copy_files

unmount_cd

date

# Parse environment variables
#parse_env

exit 0
