#!/bin/sh

## POST file to server
# version 1.0



http_code=`curl -s  -w ';%{http_code}; %{time_namelookup}; %{time_connect}s; %{time_appconnect}s; %{time_pretransfer}s; %{time_redirect}s; %{time_starttransfer}s; %{speed_download}s; %{speed_upload}s; %{time_total}s' -X  'POST' 'https://th6eopgzg4-vpce-0129c4cb1fbe9a3b2.execute-api.us-east-1.amazonaws.com/prod/evaluateDrugRules' -H 'accept: application/json' -H 'Authorization: Bearer F6BF6B1C-4633-4DA3-A047-50CBFE8CA1E8' -H 'Content-Type: application/json'  --connect-timeout 0.05 --max-time 5.0 -d '{"NDC":"65862069730","DateOfBirth":"1971-01-24","Gender":"F","DateOfService":"2022-09-22","MetricQty":300.000,"DaysSupply":1,"System":105,"Sponsor":1205,"Group":85052001}'`

echo ${http_code}
exit 0
