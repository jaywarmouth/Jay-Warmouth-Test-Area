#!/bin/ksh
# to run: igrpgrpxmas.pm
#     I ran script without parameters as these are in RUNCOBOL statement
# modify rmcobol command with -a TEST-MODE(Y OR N) FIRST-PASS (Y OR NO) BEGBATCH & ENDBATCH to execute at runtime
#  will take length of linkage of:
#    2 - test-mode, first-pass
#    10 - test-mode, first-pass, begbatch
#    16 - test-mode, first-pass, begbatch
#    any other length will cause an error and stop program.
#    if no begbatch or end batch or the value is spaces - it will process the full file.
#
# Program Name  : igrpgrpxmas.pm
# Description   : Initializes new fields in GRPGRPXMAS SNAP SHOT file
#                 Command Line Arguments:
#                  -a
#
# Author        : Patrick Murphy
# Date          : 04/13/2026
# Modifications :

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var

OBJ_DIR=/usr/lnk/obj

TEST_MODE=0
FIRST_PASS=1
DEBUG=" "
#
# Usage routine
usage()
{  cat << ENDOFUSAGE

usage igrpgrpxmas.pm [-t] [-D]

ENDOFUSAGE
  exit 1
}

#

#rse environment variables file
parse_env()
{
    echo
    echo "--> Parsing environment file..."

    IFS=${OLDIFS}
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
          echo "^G-*> Parse Error on Line: "${VAR}
        fi
      IFS=${CR}
    done
    IFS=${OLDIFS}

    echo "-=> Finished."

}


# Submit igrpgrpxmas program
submit_igrpgrpxmas()
{
     runcobol ${OBJ_DIR}/IGRPGRPXMAS -a NY  


}
# Main routine#
# Check command line validity, call usage if incorrect

while [ $# -gt 0 ]
do
  case "$1"
  in
    -t) TEST_MODE=1
        ;;
    -r) FIRST_PASS=1
        ;;
    -D) DEBUG="D"
        ;;
  esac
  shift
done

# Parse environment variables
parse_env

# Assign alternate environment variables
 GRPGRPXMASR=${GRPGRPXMAS}
 GRPGRPXMASI=${GRPGRPXMAS}

export GRPGRPXMASI GRPGRPXMASR
GRPGRPXUPDTI=/tmp/GRPGRPXUPDTI; export GRPGRPXUPDTI
GRPGRPXUPDTO=/tmp/GRPGRPXUPDTO; export GRPGRPXUPDTO



echo "Initialize GRPGRPXMAS new fields"
date
echo "GRPGRPXMASR=${GRPGRPXMASR}"
echo "GRPGRPXMASI=${GRPGRPXMASI}"
echo "GRPGRPXUPDTI=${GRPGRPXUPDTI}"
echo "GRPGRPXUPDTO=${GRPGRPXUPDTO}"
submit_igrpgrpxmas
echo  "   RET_CODE=$? "
date

exit 0
