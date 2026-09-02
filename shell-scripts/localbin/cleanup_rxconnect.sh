#!/bin/sh
find /usr/local/logs/rxconnect -type f -mmin +30 -exec rm -f {} \;
