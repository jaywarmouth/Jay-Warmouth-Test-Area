#!/bin/sh
#

PDM_PATH=/usr/local/bin
PDM_LOG=/usr/local/logs

nohup ${PDM_PATH}/create_rxconnect_record.sh -r switch10 -f "${PDM_LOG}/linedrv/switch10/" > /dev/null 2>&1 &
nohup ${PDM_PATH}/create_rxconnect_record.sh -r switch16 -f "${PDM_LOG}/linedrv/switch16/" > /dev/null 2>&1 &
nohup ${PDM_PATH}/create_rxconnect_record.sh -r switch40 -f "${PDM_LOG}/linedrv/switch40/" > /dev/null 2>&1 &
nohup ${PDM_PATH}/create_rxconnect_record.sh -r switch60 -f "${PDM_LOG}/linedrv/switch60/" > /dev/null 2>&1 &
nohup ${PDM_PATH}/create_rxconnect_record.sh -r switch70 -f "${PDM_LOG}/linedrv/switch70/" > /dev/null 2>&1 &
nohup ${PDM_PATH}/create_rxconnect_record.sh -r switch90 -f "${PDM_LOG}/linedrv/switch90/" > /dev/null 2>&1 &
nohup ${PDM_PATH}/create_rxconnect_record.sh -r webclaim_mcet -f "${PDM_LOG}/linedrv/webclaim/" > /dev/null 2>&1 &
nohup ${PDM_PATH}/create_rxconnect_record.sh -r webclaim_general -f "${PDM_LOG}/linedrv/webclaim/" > /dev/null 2>&1 &
nohup ${PDM_PATH}/create_rxconnect_record.sh -r switch_medsub -f "${PDM_LOG}/linedrv/switch_medsub/" > /dev/null 2>&1 &
