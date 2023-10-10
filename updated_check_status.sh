#!/bin/sh

current_date=$(date +"%Y-%m-%d")
output_log="status_check_output_${current_date}.log"
get_nodes="oc get nodes"
get_co="oc get co"
get_pods="oc get pods -A | egrep -v 'Running|Completed'"

$get_nodes >> "$output_log" 2>&1

$get_co >> "$output_log" 2>&1

eval "$get_pods" >> "$output_log" 2>&1

echo "Commands executed. Output saved to '$output_log'"
