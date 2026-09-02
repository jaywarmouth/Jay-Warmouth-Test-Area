#!/bin/sh
#
#
########################################
#
# Usage
#
#

usage()
{  cat << ENDOFUSAGE

usage: replica-startup.sh 

ENDOFUSAGE
  RETVAL=99
  exit 99
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
RETVAL=0

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
su - pdmisvc -c "${PDM_PATH}/replica_start_traffic02.sh"
echo "TRAFFIC02 started."
echo " "
echo "Switch traffic to system now."
echo " "
#sleep 5


########################################
#
# Program: 	WEBCLAIMS
# Type: 	C
# Description:	daemons to send webclaims to traffic
#

echo "Starting webclaims dameons."
${PDM_PATH}/webclaim_general.sh start
${PDM_PATH}/webclaim_mcet.sh start
${PDM_PATH}/webclaim_pricingtool.sh start
${PDM_PATH}/webclaim_medsub.sh start



echo " "

########################################
#
# Program:      LINEDRIVERS
# Type:         C
# Description:  Switches linedrivers C daemons
#
echo "Starting Switch40 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch40.cfg >/dev/null &"

echo "Starting Switch16 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch16.cfg >/dev/null &"

echo "Starting Switch10 linedriver daemon"
su - pdmisvc -c "${PDM_PATH}/tcplinedrv -f ${PDM_CONFIG}/claimprocessing/switch10.cfg >/dev/null &"

echo " "


########################################
#
# Program:      CLMRT
# Type:         COBOL
# Description:  Realtime Claims COBOL program
#
echo "Starting clmrt01 program."
${PDM_PATH}/clmrt01_auto.sh &


########################################
#
# Program:      QUEUE2POST
# Type:         C
# Description:  Realtime Claims C daemon
#
echo "Starting queue2post dameon."

# New RTC to loadbalancer
${PDM_PATH}/queue2post.sh ${PDM_CONFIG}/rtc/queue2post_rtc-lb-1.cfg ${PDM_LOG}/rtc/queue2post_rtc-lb-1 &
${PDM_PATH}/queue2post.sh ${PDM_CONFIG}/rtc/queue2post_rtc-lb-2.cfg ${PDM_LOG}/rtc/queue2post_rtc-lb-2 &


########################################
#
# Program:      ELGRT02
# Type:         COBOL
# Description:  Primary Realtime Eligibility COBOL program
#
nohup ${PDM_PATH}/elgrt02_auto.sh >> ${PDM_LOG}/rte/elgrt02_auto.log.$$ 2>&1 &

sleep 1

########################################
#
# Program:      ELGRT02
# Type:         C
# Description:  Primary Realtime Eligibility C daemon
#
#echo "Starting tcpfileclaim dameon (elgrt02 C prog)."
${PDM_PATH}/tcpfileclaim2.sh start


###########################################
#
# Program:	CRERXCONNECTREC
# TYPE:		COBOL
# Description:	Create new RXConnect Records
#
su - pdmisvc -c "${PDM_PATH}/start_rxconnect.sh"



exit $RETVAL
