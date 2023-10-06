#!/bin/sh

timestamp=$(date +'%Y%m%d_%H%M%S')

output_log="status_check_${timestamp}_output.log"
error_log="status_check_${timestamp}_error.log"

# Command 1
get_nodes="oc get nodes"
echo "Running Command 1: $get_nodes"
$get_nodes >> "$output_log" 2>> "$error_log"

# Command 2
get_co="oc get co'"
echo "Running Command 2: $get_co"
$get_co >> "$output_log" 2>> "$error_log"

# Command 3
get_pods="oc get pods -A | egrep -v 'Running|Completed"
echo "Running Command 3: $get_pods"
$get_pods >> "$output_log" 2>> "$error_log"

echo "Commands executed. Output saved to '$output_log' and errors saved to '$error_log'"
