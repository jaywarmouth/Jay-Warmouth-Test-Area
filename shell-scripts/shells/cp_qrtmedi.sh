#!/bin/ksh
#
# Program Name	: cp_qrtmedi.sh
# Description	: Copies new DTMS and DT files from 3525 to Raven
# Author	: Linda S. Jefferis
# Date		: 10/12/2001
# Modifications : 10/20/2005 - Changes for linux  (LSJ)
#
# Variables Used:
SHELL_DIR="/usr/lnk/shell"
RPT_DIR="/usr/pdm/rpt"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: cp_qrtmedi.sh 

ENDOFUSAGE
  exit 1
}

#
# Main routine
#

# Check command line validity

echo ""
echo "--> Start of INTER00MAS.new copy"
date
scp /fs11/INTER00MAS.new raven:/usr/lnk/medispan/INTER00MAS.new
if test $? -eq 0
then
   date
   echo "--> Copy of INTER00MAS.new is complete"
   echo ""
else
   date
   echo "-*> Error during copy of INTER00MAS.new"
   echo ""
fi

echo "--> Start of I01 copy"
date
scp /usr/lnk/dtms/I01 raven:/usr/lnk/dtms/I01.new
if test $? -eq 0
then
   date
   echo "--> Copy of I01 is complete"
   echo ""
else
   date
   echo "-*> Error during copy of I01"
   echo ""
fi

#echo "--> Start of DTDGPI.new copy"
#date
#scp /fs12/DTDGPI.new raven:/usr/lnk/dt/DTDGPI.new
#if test $? -eq 0
#then
#   date
#   echo "--> Copy of DTDGPI.new is complete"
#   echo ""
#else
#   date
#   echo "-*> Error during copy of DTDGPI.new"
#   echo ""
#fi

exit 0
