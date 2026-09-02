#!/bin/sh

tail -f /usr/local/logs/rte/elgrt02.`date +%Y%m%d`.log | grep -a --line-buffered "^RECEIVED FILE:"
