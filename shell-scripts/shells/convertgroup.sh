#!/bin/sh
#
# Program Name  : convertgroup.sh
# Author        : j novicky    
# Date          : 04/23/2020
#
OBJ_DIR="/usr/lnk/obj"

#
# Main routine
#
GROUP00MAS=/usr/lnk/grp/GROUP00MAS-NEW
OLDGROUP00MAS=/usr/lnk/grp/GROUP00MAS

export GROUP00MAS OLDGROUP00MAS


LOADTIMES=/usr/lnk/wrk/loadtimes
  export LOADTIMES

runcobol ${OBJ_DIR}/convertgroup


exit 0
