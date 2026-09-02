#!/bin/sh

#echo "`date`: running $0" >>/tmp/zerto.log
#exit 0

# Shell used to start up quieted COBOL programs for the snapshot process


PDM_PATH=/usr/local/bin
PDM_SHELL=/usr/lnk/shell
PDM_LOG=/usr/local/logs
PDM_CONFIG=/usr/local/etc
LHOST=`/bin/hostname -s`

echo "Starting claims processing"

# Clear queues, with very short outages (<10sec) this may cause
# unnecessary claim processing failures
# Queue numbers found in:
# 	/usr/local/etc/claimprocessing/switch16.cfg
#	/usr/local/etc/claimprocessing/switch40.cfg
#	/usr/local/etc/claimprocessing/webclaim_general.cfg
#	/usr/local/etc/claimprocessing/webclaim_mcet.cfg
#	/usr/local/etc/claimprocessing/webclaim_pricingtool.cfg
#	/usr/local/etc/claimprocessing/webclaim_medsub.cfg
#	

# switch16
/usr/lnk/shell/range_clrmsg.sh 200 201 >>/tmp/.startup-zerto.log.$$
/usr/lnk/shell/range_clrmsg.sh 250 299 >>/tmp/.startup-zerto.log.$$

# switch40
/usr/lnk/shell/range_clrmsg.sh 300 301 >>/tmp/.startup-zerto.log.$$
/usr/lnk/shell/range_clrmsg.sh 350 399 >>/tmp/.startup-zerto.log.$$

# webclaim_general
/usr/lnk/shell/range_clrmsg.sh 400 400 >>/tmp/.startup-zerto.log.$$
/usr/lnk/shell/range_clrmsg.sh 500 504 >>/tmp/.startup-zerto.log.$$

# webclaim_mcet
/usr/lnk/shell/range_clrmsg.sh 402 402 >>/tmp/.startup-zerto.log.$$
/usr/lnk/shell/range_clrmsg.sh 505 509 >>/tmp/.startup-zerto.log.$$

# webclaim_pricingtool
/usr/lnk/shell/range_clrmsg.sh 406 406 >>/tmp/.startup-zerto.log.$$
/usr/lnk/shell/range_clrmsg.sh 515 519 >>/tmp/.startup-zerto.log.$$

# webclaim_medsub
/usr/lnk/shell/range_clrmsg.sh 408 408 >>/tmp/.startup-zerto.log.$$
/usr/lnk/shell/range_clrmsg.sh 520 524 >>/tmp/.startup-zerto.log.$$

su - pdmisvc -c "${PDM_PATH}/start_traffic02.sh" &
echo "TRAFFIC02 started."



echo "Starting RTE"

# Clean queues
# Queue number found in /usr/local/etc/rte/realtime_tcpfileclaim2.cfg

/usr/lnk/shell/range_clrmsg.sh 80 80 >>/tmp/.startup-zerto.log.$$
/usr/lnk/shell/range_clrmsg.sh 550 599 >>/tmp/.startup-zerto.log.$$

nohup ${PDM_PATH}/elgrt02_auto.sh >> ${PDM_LOG}/rte/elgrt02_auto.log.$$ 2>&1 &


echo "Starting RxHUB COBOL program."

# Clean queues
# Queue numbers found in /usr/local/etc/epres/tcp2queue_rxhub.cfg

/usr/lnk/shell/range_clrmsg.sh 800 805 >>/tmp/.startup-zerto.log.$$

${PDM_PATH}/etraf01_start.sh &


echo "Starting Formulary73"
${PDM_PATH}/formulary73_auto.sh &



echo "Startup complete"
exit 0
