#!/bin/sh

find /usr/lnk/wt -follow -type f -mtime +30 -exec rm -f {} \;

rm -rf /usr/lnk/wt/sample/*
rm -rf /usr/lnk/wt/demo-00/*

#find /usr/pdm/shares/transfers -type f -mtime +30 -exec ls -ld {} \;
