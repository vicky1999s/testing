#!/bin/sh

output_log="status_check_output.log"
#error_log="status_check_error.log"

# Command 1
get_nodes=$(oc get nodes)
echo "Running Command 1: get_nodes"
$get_nodes >> "$output_log"

# Command 2
get_co=$(oc get co)
echo "Running Command 2: get_co" 
$get_co >> "$output_log"

# Command 3
get_pods=$(oc get pods -A | egrep -v 'Running|Completed')
echo "Running Command 3: get_pods"
$get_pods >> "$output_log" 

echo "Commands executed. Output saved to '$output_log'"
