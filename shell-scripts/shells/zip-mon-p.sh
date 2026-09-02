#!/bin/ksh
#
# Program Name	: zip-mon.sh
# Description	: Zipping mon-cycle files to rptarch
#		  Command Line Arguments:
#		  -d <ccyymmdd> - m/e date
# Author	: Linda S. Jefferis
# Date		: 02/08/2005
# Modifications : 04/29/2005 - Addition of D2H claim109 files  (LSJ)
#		: 07/05/2005 - Move of card emboss files to zip-calmon.sh  (LSJ)
#		: 10/28/2005 - Changes for Linux  (LSJ)
#		: 04/03/2006 - Addition of additional claim109 files  (LSJ)
#		: 05/03/2006 - Added CLAIM109KEY-M  (LSJ)
#		: 05/30/2006 - Added GPATEXT and removed files associated with SummaCare and claim71  (LSJ)
#		: 06/28/2006 - Added ROSTEXT  (LSJ)
#		: 07/14/2006 - Added CL106-W-SXCTEXT  (LSJ)
#		: 09/28/2006 - Added "-follow" to find sys?? commands  (LSJ)
#		: 09/28/2006 - Added GBG and BMR TEXT files  (LSJ)
#		: 09/28/2006 - Changed sys?? to sys????  (LSJ)
#		: 12/07/2006 - Added zip of CL39-W and CL57-W  (LSJ)
#		: 03/30/2007 - Addition of ???SGSTEXT and ???CAPTEXT  (LSJ)
#		: 05/15/2007 - Addition of ???GABTEXT  (LSJ)
#		: 05/29/2007 - Addition of ???PLUMTEXT  (LSJ)
#		: 07/24/2007 - Addition of ???HENTEXT  (LSJ)
#		: 04/25/2008 - Addition of ???HYLTEXT  (LSJ)
#		: 05/22/2008 - Addition of ???MMHTEXT and ???NGSTEXT  (LSJ)
#		: 09/26/2008 - Addition of ???KFMTEXT  (LSJ)
#		: 10/22/2008 - Addition of ???AGHTEXT  (LSJ)
#		: 03/26/2009 - Added claim109nmd related files  (LSJ)
#		: 03/02/2010 - Added ???NCMCTEXT  (LSJ)
#		: 03/02/2010 - Removed termed HYL and MMH files  (LSJ)
#		: 03/10/2010 - Add ???PHUTEXT
#		: 06/04/2010 - Changed AGMCTEXT to AGABTEXT and misc cleanup
#		: 12/22/2010 - Add SMK file(s)
#		: 04/15/2011 - Add MKF files
#		: 09/07/2011 - Removed "reports"
#		: 1/27/2012 - Removed claim109 referenced files
#		: 11/17/2014 - Old logic cleanup.
#		: 01/19/2015 - Remove terminated client processes (TT #12718-2, TT #12708-3).
#
# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
RPTARCH="/usr/lnk/rptarch"
TAPE_DIR="/usr/lnk/tapes"
KEY_DIR="/usr/lnk/keys"
RPT_DIR="/usr/lnk/rpt"
CYCLE="mon"
ZIP_PROG="/usr/bin/zip"

#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage: zip-mon.sh [-d <m/e date(ccyymmdd)>]

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



# TAPE FILES
zip_tapes()
{
	find ${TAPE_DIR} -follow -name "*CL109D0-M-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-p-tapes-${DATE}.zip -@
}

# KEY FILES
zip_keys()
{
	find ${KEY_DIR} -follow -name "CLAIM109D0KEY-M" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-p-keys-${DATE}.zip -@
}


# RPT FILES
zip_rpt()
{
        find ${RPT_DIR} -follow -name "mon-p-*" -print | ${ZIP_PROG} -j ${RPTARCH}/${CYCLE}/${CYCLE}-p-rpt-${DATE}.zip -@
}

#
# Main routine
#

# Check command line validity, call usage if incorrect
while [ $# -gt 0 ]
do
  case "$1"
  in
    -d) shift
        if [ $# -le 0 ]
        then
          usage
        fi
        DATE=$1
        ;;
  esac
  shift
done

# Parse environment variables
#parse_env


  zip_tapes

  zip_keys

  zip_rpt

exit 0
