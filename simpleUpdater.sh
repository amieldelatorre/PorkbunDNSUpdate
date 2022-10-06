#!/bin/bash

. ./updater.config

current_ip=$(dig -4 +short myip.opendns.com @resolver1.opendns.com)

curl -s --header "Content-type: application/json" --request POST --data '{"secretapikey":"'$porkbun_secret_key'","apikey":"'$porkbun_api_key'","content":"'$current_ip'","name":"'*'","type":"'A'"}' $porkbun_edit_endpoint/$root_domain_name/{YOUR_RECORD_ID}
curl -s --header "Content-type: application/json" --request POST --data '{"secretapikey":"'$porkbun_secret_key'","apikey":"'$porkbun_api_key'","content":"'$current_ip'","type":"'A'"}' $porkbun_edit_endpoint/$root_domain_name/{YOUR_RECORD_ID}