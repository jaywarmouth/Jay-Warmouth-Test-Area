#!/bin/bash

# Variables Used:
ENV_FILE=/usr/lnk/shell/env_var
CR="
"
EQUAL="="
OBJ_DIR="/usr/lnk/obj"
AUDIT_PATH="/usr/lnk/audit"
LINETYPE="all"
DATE="none"
SW="NNNNNNYN"

# Load the configuration file
CONFIG_FILE="/usr/local/etc/claim96.conf"
if [[ -f $CONFIG_FILE ]]; then
    source $CONFIG_FILE
else
    echo "Configuration file $CONFIG_FILE not found."
    exit 1
fi

# Usage routine
usage() {
    cat << ENDOFUSAGE

usage: claim96.sh -d [yyyymmdd|yyyymmdd.<sys-name>] -p [<path>] -u [xxxxxxxx] [-l dir|10|16|40|70|90]
#                 -d REQUIRED - Date of audit file (ccyymmdd or ccyymmdd.<sys-name>)
#                 -l OPTIONAL - Default is all; Type of audit to update (dir|16|40|70|90)  
#                 -p OPTIONAL - Default is /usr/lnk/audit; directory location for input audit files 
#                 -u OPTIONAL - Assign alternate update switches 
#                    Default is NNNNNNYN for full update:
#                    SWITCH 1 - OVERIDE
#                    SWITCH 2 - REVERSAL
#                    SWITCH 3 - EXCEPTION/ONETM
#                    SWITCH 4 - CLAIM
#                    SWITCH 5 - LIMIT/RXLIM
#                    SWITCH 6 - CLAIM80
#                    SWITCH 7 - FULL UPDATE
#                    SWITCH 8 - CARDI

ENDOFUSAGE
    exit 1
}

#
# Parse environment variables file
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


# Check Required options
check_options() {
    if [[ ${DATE} == "none" ]]; then
        usage
    fi
}

# Submit claim96
submit_claim96() {
    local prefix=$1
    local numbers=("${!2}")
    local count=$3
    for ((i=0; i<count; i++)); do
        if [[ -f ${AUDIT_PATH}/${prefix}-${numbers[i]}-${DATE} ]]; then
            AUDIT20MAS=${AUDIT_PATH}/${prefix}-${numbers[i]}-${DATE}
            export AUDIT20MAS
            echo -e "\nAUDIT20MAS=$AUDIT20MAS"
            date
            runcobol ${OBJ_DIR}/claim96 -a ${SW}
        else
            echo "${AUDIT_PATH}/${prefix}-${numbers[i]}-${DATE} does not exist"
        fi
    done
}

# Submit dmr claim96
submit_dmr_claim96() {
    if [[ -f ${AUDIT_PATH}/DMR-${DATE} ]]; then
	AUDIT20MAS=${AUDIT_PATH}/DMR-${DATE}
        export AUDIT20MAS
        echo -e "\nAUDIT20MAS=$AUDIT20MAS"
        date
        runcobol ${OBJ_DIR}/claim96 -a ${SW}
    else
        echo "${AUDIT_PATH}/DMR-${DATE} does not exist"
    fi
}

# Submit claim02 claim96
submit_claim02_claim96() {
    if [[ -f ${AUDIT_PATH}/CLAIM02-${DATE} ]]; then
	AUDIT20MAS=${AUDIT_PATH}/CLAIM02-${DATE}
        export AUDIT20MAS
        echo -e "\nAUDIT20MAS=$AUDIT20MAS"
        date
        runcobol ${OBJ_DIR}/claim96 -a ${SW}
    else
        echo "${AUDIT_PATH}/CLAIM02-${DATE} does not exist"
    fi
}


# Main routine
while [[ $# -gt 0 ]]; do
    case "$1" in
        -l) LINETYPE="$2"; shift ;;
        -d) DATE="$2"; shift ;;
        -p) AUDIT_PATH="$2"; shift ;;
        -u) SW="$2"; shift ;;
        *) usage ;;
    esac
    shift
done

#validate_linetype
check_options
parse_env

case ${LINETYPE} in
    "dir") 
	submit_claim96 "AUDIT" "DIR_NUMBERS[@]" $DIR_COUNT
	submit_claim96 "CLMSS" "DIR_NUMBERS[@]" $DIR_COUNT
	submit_claim96 "MSG" "DIR_NUMBERS[@]" $DIR_COUNT
	;;
    "10") 
	submit_claim96 "AUDIT" "SW10_NUMBERS[@]" $SW10_COUNT
	submit_claim96 "CLMSS" "SW10_NUMBERS[@]" $SW10_COUNT
	submit_claim96 "MSG" "SW10_NUMBERS[@]" $SW10_COUNT
	;;
    "16") 
	submit_claim96 "AUDIT" "SW16_NUMBERS[@]" $SW16_COUNT
	submit_claim96 "CLMSS" "SW16_NUMBERS[@]" $SW16_COUNT
	submit_claim96 "MSG" "SW16_NUMBERS[@]" $SW16_COUNT
	;;
    "40") 
	submit_claim96 "AUDIT" "SW40_NUMBERS[@]" $SW40_COUNT
        submit_claim96 "CLMSS" "SW40_NUMBERS[@]" $SW40_COUNT
        submit_claim96 "MSG" "SW40_NUMBERS[@]" $SW40_COUNT
        ;;
    "60") 
	submit_claim96 "AUDIT" "SW60_NUMBERS[@]" $SW60_COUNT
        submit_claim96 "CLMSS" "SW60_NUMBERS[@]" $SW60_COUNT
        submit_claim96 "MSG" "SW60_NUMBERS[@]" $SW60_COUNT
        ;;
    "70") 
	submit_claim96 "AUDIT" "SW70_NUMBERS[@]" $SW70_COUNT
        submit_claim96 "CLMSS" "SW70_NUMBERS[@]" $SW70_COUNT
        submit_claim96 "MSG" "SW70_NUMBERS[@]" $SW70_COUNT
        ;;
    "90") 
	submit_claim96 "AUDIT" "SW90_NUMBERS[@]" $SW90_COUNT
        submit_claim96 "CLMSS" "SW90_NUMBERS[@]" $SW90_COUNT
        submit_claim96 "MSG" "SW90_NUMBERS[@]" $SW90_COUNT
        ;;
    "all") 
	submit_claim96 "AUDIT" "DIR_NUMBERS[@]" $DIR_COUNT
        submit_claim96 "AUDIT" "SW10_NUMBERS[@]" $SW10_COUNT
        submit_claim96 "AUDIT" "SW40_NUMBERS[@]" $SW40_COUNT
        submit_claim96 "AUDIT" "SW16_NUMBERS[@]" $SW16_COUNT
        submit_claim96 "AUDIT" "SW60_NUMBERS[@]" $SW60_COUNT
        submit_claim96 "AUDIT" "SW70_NUMBERS[@]" $SW70_COUNT
        submit_claim96 "AUDIT" "SW90_NUMBERS[@]" $SW90_COUNT
        submit_dmr_claim96
        submit_claim02_claim96
        submit_claim96 "CLMSS" "DIR_NUMBERS[@]" $DIR_COUNT
        submit_claim96 "CLMSS" "SW10_NUMBERS[@]" $SW10_COUNT
        submit_claim96 "CLMSS" "SW40_NUMBERS[@]" $SW40_COUNT
        submit_claim96 "CLMSS" "SW16_NUMBERS[@]" $SW16_COUNT
        submit_claim96 "CLMSS" "SW60_NUMBERS[@]" $SW60_COUNT
        submit_claim96 "CLMSS" "SW70_NUMBERS[@]" $SW70_COUNT
        submit_claim96 "CLMSS" "SW90_NUMBERS[@]" $SW90_COUNT
        submit_claim96 "MSG" "DIR_NUMBERS[@]" $DIR_COUNT
        submit_claim96 "MSG" "SW10_NUMBERS[@]" $SW10_COUNT
        submit_claim96 "MSG" "SW40_NUMBERS[@]" $SW40_COUNT
        submit_claim96 "MSG" "SW16_NUMBERS[@]" $SW16_COUNT
        submit_claim96 "MSG" "SW60_NUMBERS[@]" $SW60_COUNT
        submit_claim96 "MSG" "SW70_NUMBERS[@]" $SW70_COUNT
        submit_claim96 "MSG" "SW90_NUMBERS[@]" $SW90_COUNT
        ;;
esac

