#!/bin/sh
#
# Program Name	: startup.sh
# Description	: Startup script for system
# Author	: Anthony DePinto
# Date		: 5-12-97 
#
########################################
#
# Usage
#
#

usage()
{  cat << ENDOFUSAGE

usage: startup.sh 

ENDOFUSAGE
  exit 1
}


########################################
#
# Checks to ensure we are logged in as root.
#
#
check_for_root()
{
        c_uid=`id -u`
        if [ "$c_uid" -ne "0" ]
        then
                echo "You need to be root to run this program!"
                exit 100
        fi
}

########################################
#
# Main routine
#

# Variables
CR="
"
# Maximum number of seconds to loop trying to start envoy & NDC
MAXCOUNT="240"
STATFREQ="10"

#######################################

check_for_root

# Check command line validity, call usage if incorrect
if [ $# -ge 1 ]
then
  usage
fi


PDM_PATH=/usr/local/bin
PDM_SHELL=/usr/lnk/shell
PDM_LOG=/usr/local/logs
PDM_CONFIG=/usr/local/etc
LHOST=`/bin/hostname -s`


########################################
#
# Start of daemons
#


########################################
#
# Program: 	TRAFFIC
# Type: 	COBOL
# Description:	Primary COBOL traffic program	
#
echo "Starting TRAFFIC02"
su - pdmisvc -c "${PDM_PATH}/start_traffic02.sh"
echo "TRAFFIC02 started."
echo " "
echo "Switch traffic to system now."
echo " "
sleep 5

echo "Creating ${PDM_LOG}/linedrv and setting permissions"
if [ ! -d "${PDM_LOG}/linedrv" ]
then
        mkdir ${PDM_LOG}/linedrv
fi

chgrp pdmisvc ${PDM_LOG}/linedrv
chmod 775 ${PDM_LOG}/linedrv

########################################
#
# Program: 	WEBCLAIMS
# Type: 	C
# Description:	daemons to send webclaims to traffic
#

echo "Starting webclaims dameons."
${PDM_PATH}/webclaim_general.sh start
${PDM_PATH}/webclaim_mcet.sh start
${PDM_PATH}/webclaim_restack.sh start
${PDM_PATH}/webclaim_pricingtool.sh start
${PDM_PATH}/webclaim_medsub.sh start


########################################
#
# Program: 	ELGRT02
# Type: 	COBOL
# Description:	Primary Realtime Eligibility COBOL program
#
nohup ${PDM_PATH}/elgrt02_auto.sh >> ${PDM_LOG}/rte/elgrt02_auto.log.$$ 2>&1 &

sleep 1

########################################
#
# Program: 	ELGRT02
# Type: 	C
# Description:	Primary Realtime Eligibility C daemon
#
#echo "Starting tcpfileclaim dameon (elgrt02 C prog)."
${PDM_PATH}/tcpfileclaim2.sh start


########################################
#
# Program:      FORMULARY73
# Type:		Cobol
# Description:	Formualry Queries
#
${PDM_PATH}/formulary73_auto.sh &

########################################
#
# Program: 	FORMULARY73
# Type: 	C
# Description:	Enable queries of formularies
#
echo "Starting tcpfileclaim formulary dameon."
${PDM_PATH}/tcpfileclaim_formulary.sh start


########################################
#
# Program: 	QUEUE2POST
# Type: 	C
# Description:	Realtime Claims C daemon
#
echo "Starting queue2post dameon."

${PDM_SHELL}/queue2post.sh ${PDM_CONFIG}/rtc/queue2post_app101p1.cfg ${PDM_LOG}/rtc/queue2post_app101p1 &

# Commented out for testing,  2 lines below should be active in production
#${PDM_SHELL}/queue2post.sh ${PDM_CONFIG}/rtc/queue2post_app101p2.cfg ${PDM_LOG}/rtc/queue2post_app101p2 &
#${PDM_SHELL}/queue2post.sh ${PDM_CONFIG}/rtc/queue2post_app101p3.cfg ${PDM_LOG}/rtc/queue2post_app101p3 &


########################################
#
# Program: 	CLMRT
# Type: 	COBOL
# Description:	Realtime Claims COBOL program
#
echo "Starting clmrt01 program."
${PDM_PATH}/clmrt01_start.sh &


########################################
#
# Program: 	HELPDESK
# Type: 	C
# Description:	Helpdesk Status Screen C daemon
#
echo "Starting helpdesk status screen dameon."
${PDM_SHELL}/helpdesk.sh &
sleep 2
echo "Helpdesk dameon started."
echo " "


########################################
#
# Program: 	RxHUB ePrescribing
# Type: 	C
# Description:	ePrescribing C daemon
#
echo "Starting RxHUB C dameon."
${PDM_PATH}/tcp2queue_rxhub.sh start &
sleep 5

########################################
#
# Program: 	RxHUB ePrescribing
# Type: 	COBOL
# Description:	ePrescribing COBOL program
#
echo "Starting RxHUB COBOL program."
${PDM_PATH}/etraf01_start.sh &

#########################################
#
#             RTCJSON
# Type:         scripts
# Description: Supporting scripts for the RTCJSON process
#
#${PDM_SHELL}/rtcjson_start.sh &

########################################
#
# Program: 	LINEDRIVERS
# Type: 	C
# Description:	Switches linedrivers C daemons
#
echo "Starting Switch40 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch40.cfg >/dev/null &"

echo "Starting Switch16 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch16.cfg >/dev/null &"

echo " "

	echo "Startup completed successfully."
	RETVAL="0"
echo " "
return $RETVAL
