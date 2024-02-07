#!/bin/bash

# ASCII Banner
cat << "EOF"
 ___       ________ 
|\  \     |\  _____\ File Name: log-filter.sh
\ \  \    \ \  \__/  File Ver:  1.0
 \ \  \    \ \   __\ Author: @iyonr
  \ \  \____\ \  \_| Email: mrr@isecuritylab.com
   \ \_______\ \__\ 
    \|_______|\|__| 
                    
                    
EOF

# ---------------------------------------------------------------
# Script Name: log-filter.sh
# Author: Marion Renaldo Rotensulu (@iyonr)
# Email: mrr@isecuritylab.com
# Version: 1.0
# Copyright: (C) 2024 Marion Renaldo Rotensulu. All rights Reserved.
# Description:
# This script filters logs from FortiAnalyzer, tailored for logs
# downloaded via LogView >> Log Browser function, suitable for
# FortiAnalyzer version 7.4.2 build 2397.
# Usage:
# ./log-filter.sh -f <log_file> -s <start_date_time> -e <end_date_time> [-v <vd>] [-p <policyid>]
# Parameters:
# -f Log file path (mandatory)
# -s Start date and time in format YYYY-MM-DD HH:MM:SS (mandatory)
# -e End date and time in format YYYY-MM-DD HH:MM:SS (mandatory)
# -v Virtual Domain (optional)
# -p Policy ID (optional)
# Note: The script displays help if executed without any parameters.
# ---------------------------------------------------------------

# Function to display help
show_help() {
    echo "Usage: $0 -f <log_file> -s <start_date_time> -e <end_date_time> [-v <vd>] [-p <policyid>]"
    echo -e "\t-f Log file path"
    echo -e "\t-s Start date and time in format YYYY-MM-DD HH:MM:SS"
    echo -e "\t-e End date and time in format YYYY-MM-DD HH:MM:SS"
    echo -e "\t-v Virtual Domain (optional)"
    echo -e "\t-p Policy ID (optional)"
    echo
}

# Check if no arguments were provided
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

# Initialize variables
log_file=""
start_datetime=""
end_datetime=""
vd=""
policyid=""

# Parse command line options
while getopts ":hf:s:e:v:p:" opt; do
    case ${opt} in
        h )
            show_help
            exit 0
            ;;
        f )
            log_file=$OPTARG
            ;;
        s )
            start_datetime=$OPTARG
            ;;
        e )
            end_datetime=$OPTARG
            ;;
        v )
            vd=$OPTARG
            ;;
        p )
            policyid=$OPTARG
            ;;
        \? )
            echo "Invalid Option: -$OPTARG" 1>&2
            show_help
            exit 1
            ;;
        : )
            echo "Invalid Option: -$OPTARG requires an argument" 1>&2
            show_help
            exit 1
            ;;
    esac
done
shift $((OPTIND -1))

# Check for mandatory options
if [ -z "${log_file}" ] || [ -z "${start_datetime}" ] || [ -z "${end_datetime}" ]; then
    echo "Error: Missing required arguments"
    show_help
    exit 1
fi

# Format input dates for comparison
start_timestamp=$(date -d "$start_datetime" +%s)
end_timestamp=$(date -d "$end_datetime" +%s)

# Run the filtering
awk -v start="$start_timestamp" -v end="$end_timestamp" -v vd="$vd" -v policyid="$policyid" '
function check_conditions(date, time, vd_field, policyid_field) {
    # Convert log date and time to timestamp
    gsub(/"/, "", date);
    gsub(/"/, "", time);
    datetime = date " " time;
    timestamp = mktime(gensub(/-/, " ", "G", gensub(/:/, " ", "G", datetime)));

    # Check date and time range
    if (timestamp < start || timestamp > end) {
        return 0;
    }

    # Check vd and policyid if provided
    if (vd != "" && vd_field != "vd=\"" vd "\"") {
        return 0;
    }
    if (policyid != "" && policyid_field != "policyid=" policyid) {
        return 0;
    }

    return 1;
}

{
    # Extract necessary fields
    match($0, /date="[^"]+"/);
    date = substr($0, RSTART, RLENGTH);
    match($0, /time="[^"]+"/);
    time = substr($0, RSTART, RLENGTH);
    match($0, /vd="[^"]+"/);
    vd_field = substr($0, RSTART, RLENGTH);
    match($0, /policyid=[^ ]+/);
    policyid_field = substr($0, RSTART, RLENGTH);
    
    # Print line if it meets conditions
    if (check_conditions(date, time, vd_field, policyid_field)) {
        print $0;
    }
}' "$log_file"

# Save output to a file with a timestamp
output_file="filtered_logs_$(date +%Y%m%d_%H%M%S).txt"
awk -v start="$start_timestamp" -v end="$end_timestamp" -v vd="$vd" -v policyid="$policyid" '...' "$log_file" > "$output_file"
echo "Filtered logs saved to $output_file"
