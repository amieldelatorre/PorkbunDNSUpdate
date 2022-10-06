#!/bin/bash

# Loading the updater.config file
. ./updater.config

# Declare function that converts date and accepts a log message before echoing
echodate() {
    echo `date +%y/%m/%d_%H:%M:%S`:: $*
}

# Create a log file and folder if it hasn't been created
log_folder=$(find logs)
if [[ log_folder != "logs" ]]; then
    mkdir logs
    echodate "Logs folder created -> /logs" >> logs/update.log
    echo >> logs/update.log
fi


# Get the number of domains to change
number_of_records=${#record_ids[@]}
current_ip=$(dig -4 +short myip.opendns.com @resolver1.opendns.com)

# Loop through each record
for ((i=0;i<$number_of_records;i++)); do 
    # Check if each domain name is a wildcard or a blank domain and assign that as the name to query
    if [ "${all_domain_names[$i]}" = "*" ]; then
        name="*.$root_domain_name"

    elif [ "${all_domain_names[$i]}" = "" ]; then
        name=$root_domain_name
    else
        name="${all_domain_names[$i]}.$root_domain_name"
    fi

    # Query a DNS server to get the IP of that domain
    ip_in_dns_server=$(dig -4 +short $name)      

    # Check if current IP address is the same as the record in the DNS Servers
    if [[ $current_ip == $ip_in_dns_server ]] 
    then
        # Log if it is
        echodate "Current IP Address ($current_ip) is the same as the IP ($ip_in_dns_server) in the DNS Server for the domain $name" >> logs/update.log
    else
        # Log if it is not
        echodate "IP is currently different after checking a DNS query, checking if Porkbun DNS Servers have been updated already" >> logs/update.log

        # Get the current stored IP address for the record in Porkbun
        echodate "(curl -s --header \"Content-type: application/json\" --request POST --data '{\"secretapikey\":"'$porkbun_secret_key'",\"apikey\":"'$porkbun_api_key'"}' $porkbun_retrieve_endpoint/$root_domain_name/${record_ids[$i]} | tac | tac | jq ".records[0].content")" >> logs/update.log
        ip_in_porkbun=$(curl -s --header "Content-type: application/json" --request POST --data '{"secretapikey":"'$porkbun_secret_key'","apikey":"'$porkbun_api_key'"}' $porkbun_retrieve_endpoint/$root_domain_name/${record_ids[$i]} | tac | tac | jq ".records[0].content")

        # Check if they match
        if [ "$ip_in_porkbun" =  "\"$current_ip\"" ]; then
            # If they match then no update is required. Just need to wait for that to propagate to other DNS Servers
            echodate "No Update Required: Current IP Address ($current_ip) is the same as the IP ($ip_in_porkbun) in Porkbun for the domain $name. It is currently propagating through the different DNS servers." >> logs/update.log
        else
            # Else update the record
            echodate "Update Required: Current IP Address ($current_ip), IP ($ip_in_porkbun) in Porkbun, domain $name" >> logs/update.log
            echodate "(curl --header \"Content-type: application/json\" --request POST --data '{\"secretapikey\":"'$porkbun_secret_key'",\"apikey\":"'$porkbun_api_key'",\"content\":\"'$current_ip'\",\"name\":\"'${all_domain_names[$i]}'\",\"type\":\"'A'\"}' $porkbun_edit_endpoint/$root_domain_name/${record_ids[$i]})" >> logs/update.log
            result=$(curl -s --header "Content-type: application/json" --request POST --data '{"secretapikey":"'$porkbun_secret_key'","apikey":"'$porkbun_api_key'","content":"'$current_ip'","name":"'${all_domain_names[$i]}'","type":"'A'"}' $porkbun_edit_endpoint/$root_domain_name/${record_ids[$i]})
            echodate $result >> logs/update.log
        fi
    fi
    echo >> logs/update.log
done 

echo >> logs/update.log
