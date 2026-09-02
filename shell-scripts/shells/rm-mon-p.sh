#!/bin/ksh
#
# Program Name	: rm-mon-p.sh
# Description	: Remove mon-cycle files
#                 Command line arguments:
#                 -p <p/e prefix> (e.g. I30)
# Author	: Linda S. Jefferis
# Date		: 
# Modifications : 04/29/2005 - Addition of D2H claim109 and claim129 files  (LSJ)
#		: 07/05/2005 - Deleted Removal of card emboss files  (LSJ)
#		: 04/03/2006 - Addition of addtional claim109 files  (LSJ)
#		: 05/03/2006 - Added CLAIM109KEY-M  (LSJ)
#		: 05/30/2006 - Added GPATEXT and removed SummaCare/claim71 related files  (LSJ)
#		: 06/28/2006 - Added ROSTEXT  (LSJ)
#		: 07/14/2006 - Added CL106-W-SXCTEXT  (LSJ)
#		: 09/28/2006 - Removed CL106-W-SXCTEXT  (LSJ)
#		: 09/28/2006 - Added "-follow" to find commands  (LSJ)
#		: 09/28/2006 - Added GBGTEXT abd BMRTEXT  (LSJ)
#		: 12/07/2006 - Added remove of CL39-W and CL57-W  (LSJ)
#		: 03/30/3007 - Added ???SGSTEXT and ???CAPTEXT  (LSJ)
#		: 05/15/2007 - Added ???GABTEXT  (LSJ)
#		: 05/29/2007 - Added ???PLUMTEXT  (LSJ)
#		: 07/24/2007 - Added ???HENTEXT  (LSJ)
#		: 04/25/2008 - Added ???HYLTEXT  (LSJ)
#		: 05/22/2008 - Added ???MMHTEXT and ???NGSTEXT  (LSJ)
#		: 09/26/2008 - Added ???KFMTEXT  (LSJ)
#		: 10/22/2008 - Added ???AGHTEXT  (LSJ)
#		: 03/26/2009 - Added claim109nmd and QCP files and removed some inactive files  (LSJ)
#		: 03/10/2010 - Added ???NCMCTEXT and ???PHUTEXT
#		: 04/19/2010 - Files for claim109agmc
#		: 06/04/2010 - Misc cleanup
#		: 12/22/2010 - Add SMK file(s)
#		: 04/15/2011 - Add MKF, claim109d0 files
#		: 09/23/2011 - Remove unused logic
#		: 11/17/2014 - Old logic cleanup.
#               : 01/19/2015 - Remove terminated client processes (TT #12718-2, TT #12708-3).
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
PO_DIR="/usr/lnk/po"
RPT_DIR="/usr/lnk/rpt"
KEY_DIR="/usr/lnk/keys"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: rm-mon-p.sh -p <p/e prefix>

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
  esac
  shift
done


# Parse environment variables
parse_env


rm ${KEY_DIR}/CLAIM109D0KEY-M
rm /usr/lnk/tapes/???CL109D0-M-*

rm ${RPT_DIR}/mon-p-*

exit 0
