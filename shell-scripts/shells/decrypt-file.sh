#!/bin/ksh
#
# Program Name	: decrypt-file.sh
# Description	: Decrypts specified file
# Author	: Linda S. Jefferis
# Date		: 04/20/2009
# Modifications : 
#
# Variables Used:

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: decrypt-file.sh <encrypted file> <output file>

ENDOFUSAGE
  exit 1
}


#
# Main routine
#

# Check command line validity, call usage if incorrect
if [ $# -lt 2 ]
then
   usage
   exit 2
fi

ENCRYPTED_FILE=$1
OUTPUT_FILE=$2

gpg -q -o ${OUTPUT_FILE} -d ${ENCRYPTED_FILE}

exit 0
