#!/bin/sh

current_date=$(date +"%Y-%m-%d")
filename_prefix="status_check_output"
output_log="${filename_prefix}_${current_date}.log"

get_nodes="oc get nodes"
echo "checking node status" >> "$output_log"
$get_nodes >> "$output_log" 2>&1

get_co="oc get co"
echo "checking clusteroperator status" >> "$output_log"
$get_co >> "$output_log" 2>&1

get_pods="oc get pods -A | egrep -v 'Running|Completed'"
echo "checking pods status" >> "$output_log"
eval "$get_pods" >> "$output_log" 2>&1

echo "Commands executed. Output saved to '$output_log'"

delete_old_files(){
  #local directory="/home/student/myapp/mygit/testing"
  local filename_prefix="$1"
  find . -type f -name "${filename_prefix}*" -mtime +2 -exec rm -f {} \;
  echo "Deleted files older than 2 days with prefix '${filename_prefix}' in current directory"
}

#delete_old_files "${filename_prefix}"
