#!/bin/bash

# ASCII Banner
cat << "EOF"
 ___       ________ 
|\  \     |\  _____\ File Name: log-filter.sh
\ \  \    \ \  \__/  File Ver:  2.0
 \ \  \    \ \   __\ Author: @iyonr
  \ \  \____\ \  \_| Email: mrr@isecuritylab.com
   \ \_______\ \__\ 
    \|_______|\|__| 
                    
                    
EOF

# ---------------------------------------------------------------
# Script Name: log-filter.sh
# Author: Marion Renaldo Rotensulu (@iyonr)
# Email: mrr@isecuritylab.com
# Version: 2.0
# Copyright: (C) 2024 Marion Renaldo Rotensulu. All rights Reserved.
# Description:
# This script filters logs from FortiAnalyzer, tailored for logs
# downloaded via LogView >> Log Browser function, suitable for
# FortiAnalyzer version 7.4.2 build 2397.
# Usage:
# ./log-filter.sh -f <log_file> -s <start_date_time> -e <end_date_time> [-v <vd>] [-p <policyid>] [--debug]
# Parameters:
# -f Log file path (mandatory)
# -s Start date and time in format YYYY-MM-DD HH:MM:SS (mandatory)
# -e End date and time in format YYYY-MM-DD HH:MM:SS (mandatory)
# -v Virtual Domain (optional)
# -p Policy ID (optional)
# --debug Activate debug mode (optional)
# ---------------------------------------------------------------

# Initialize variables
log_file=""
start_datetime=""
end_datetime=""
vd=""
policyid=""
debug_mode=0

# Function to display help
show_help() {
    echo "Usage: $0 -f <log_file> -s <start_date_time> -e <end_date_time> [-v <vd>] [-p <policyid>] [--debug]"
    echo -e "\t-f Log file path"
    echo -e "\t-s Start date and time in format YYYY-MM-DD HH:MM:SS"
    echo -e "\t-e End date and time in format YYYY-MM-DD HH:MM:SS"
    echo -e "\t-v Virtual Domain (optional)"
    echo -e "\t-p Policy ID (optional)"
    echo -e "\t--debug Activate debug mode"
    echo
}

# Parse command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -f) log_file="$2"; shift ;;
        -s) start_datetime="$2"; shift ;;
        -e) end_datetime="$2"; shift ;;
        -v) vd="$2"; shift ;;
        -p) policyid="$2"; shift ;;
        --debug) debug_mode=1 ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown option: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Check for mandatory options
if [[ -z "$log_file" || -z "$start_datetime" || -z "$end_datetime" ]]; then
    echo "Error: Missing required arguments"
    show_help
    exit 1
fi

# Convert input dates to UTC timestamps for comparison
start_timestamp=$(date -u -d "$start_datetime" +%s)
end_timestamp=$(date -u -d "$end_datetime" +%s)

# Process logs with or without debug mode
awk -v start="$start_timestamp" -v end="$end_timestamp" -v vd="$vd" -v policyid="$policyid" -v debug="$debug_mode" '
BEGIN {
    FS=" ";
}

{
    date = ""; time = ""; # Reset for each line
    for (i = 1; i <= NF; i++) {
        if ($i ~ /^date=/) {
            split($i, arr, "=");
            gsub(/"/, "", arr[2]);
            date = arr[2];
        }
        if ($i ~ /^time=/) {
            split($i, arr, "=");
            gsub(/"/, "", arr[2]);
            time = arr[2];
        }
    }
    
    if (date && time) {
        datetimeStr = date " " time;
        gsub(/-|:/, " ", datetimeStr);
        logTimestamp = mktime(datetimeStr " 0"); # Assumes UTC timezone
        
        if (logTimestamp >= start && logTimestamp <= end) {
            if (debug) {
                print "DEBUG: MATCH FOUND:", $0;
            } else {
                print $0;
            }
        } else if (debug) {
            print "DEBUG: No match for this line.";
        }
    } else if (debug) {
        print "DEBUG: Failed to extract date and time for line:", $0;
    }
}
' "$log_file" > "${log_file%.log}_filtered_$(date +%Y%m%d_%H%M%S).log"

if [[ $debug_mode -eq 0 ]]; then
    echo "Filtered logs saved to ${log_file%.log}_filtered_$(date +%Y%m%d_%H%M%S).log"
fi
