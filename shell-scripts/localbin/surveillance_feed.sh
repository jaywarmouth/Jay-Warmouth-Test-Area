#!/bin/bash

MIRTH_HOST="https://mirthtest20:8443"
USERNAME="mirthapi"
PASSWORD="17Pr5hOcnDQ1ecMlpKRN"

CONFIG_KEY="EnableSurveillanceFeed"
API_URL="${MIRTH_HOST}/api/server/configurationMap"

get_map() {
    curl -sk -X GET "$API_URL" \
        -u "${USERNAME}:${PASSWORD}" \
        -H "X-Requested-With: OpenAPI" \
        -H "Accept: application/xml"
}

get_status() {
    MAP_XML=$(get_map)

    VALUE=$(echo "$MAP_XML" | tr -d '\n' | sed -n \
        "s:.*<entry>[[:space:]]*<string>${CONFIG_KEY}</string>[[:space:]]*<com.mirth.connect.util.ConfigurationProperty>[[:space:]]*<value>\([^<]*\)</value>.*:\1:p")

    echo "Current value: ${VALUE}"

    [[ "$VALUE" == "1" ]] && echo "Status: ENABLED"
    [[ "$VALUE" == "0" ]] && echo "Status: DISABLED"
    [[ -z "$VALUE" ]] && echo "Status: UNKNOWN / NOT FOUND"

    return 0
}

set_value() {
    VALUE="$1"
    MAP_XML=$(get_map)

    UPDATED_XML=$(echo "$MAP_XML" | tr -d '\n' | sed \
        "s:\(<entry>[[:space:]]*<string>${CONFIG_KEY}</string>[[:space:]]*<com.mirth.connect.util.ConfigurationProperty>[[:space:]]*<value>\)[^<]*\(</value>\):\1${VALUE}\2:")

    RESPONSE=$(curl -sk -X PUT "$API_URL" \
        -u "${USERNAME}:${PASSWORD}" \
        -H "X-Requested-With: OpenAPI" \
        -H "Content-Type: application/xml" \
        -H "Accept: application/xml" \
        --data-binary "$UPDATED_XML" \
        -w "\nHTTP_STATUS:%{http_code}")

    HTTP_STATUS=$(echo "$RESPONSE" | awk -F: '/HTTP_STATUS/ {print $2}')

    if [[ "$HTTP_STATUS" == "200" || "$HTTP_STATUS" == "204" ]]; then
        [[ "$VALUE" == "1" ]] && echo "${CONFIG_KEY} ENABLED"
        [[ "$VALUE" == "0" ]] && echo "${CONFIG_KEY} DISABLED"
        exit 0
    else
        echo "Failed to update ${CONFIG_KEY}"
        echo "HTTP status: ${HTTP_STATUS}"
        echo "$RESPONSE"
        exit 2
    fi
}

case "$1" in
    enable) set_value "1" ;;
    disable) set_value "0" ;;
    status) get_status ;;
    *) echo "Usage: $0 enable|disable|status"; exit 1 ;;
esac
