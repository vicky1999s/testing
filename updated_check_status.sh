#!/bin/sh

current_date=$(date +"%Y-%m-%d")
filename_prefix="status_check_output"
output_log="${filename_prefix}_${current_date}.log"

#get nodes status
get_nodes="oc get nodes"
echo "checking node status" >> "$output_log"
$get_nodes >> "$output_log" 2>&1

#get clusteroperator status
get_co="oc get co"
echo "checking clusteroperator status" >> "$output_log"
$get_co >> "$output_log" 2>&1

#get pods status
get_pods="oc get pods -A | egrep -v 'Running|Completed'"
echo "checking pods status" >> "$output_log"
eval "$get_pods" >> "$output_log" 2>&1

echo "Commands executed. Output saved to '$output_log'"

#increment the counterfile value, indicating that the cronjob is completed 
increment_counter_file(){
  counter_file="counterfile"
  counter=$(cat "$counter_file")
  max_count=8

  #check if the counter has reached the maximum limit
  if ["$counter" -eq "$max_count"]; then
    echo "All cronjobs have completed"

    #sending output to external system
    ## WIP ##

    #reset the counterfile to 0 to keep track of next cronjob execution
    echo "0" > "$counter_file"
  else
    counter=$((counter+1))
    #update the shared counter
    echo "#counter" > "$counter_file"

    echo "cronjob completed. counter value: $counter"
}

#move older files(2 days) from current directory to tmp directory
delete_old_files(){
  #local directory="/home/student/myapp/mygit/testing"
  local filename_prefix="$1"
  find . -type f -name "${filename_prefix}*" -mtime +2 -exec mv {} /tmp/ \;
  echo "moved files older than 2 days with prefix '${filename_prefix}' in current directory"
}

###uncomment the below function calls to test

#increment_counter_file
#delete_old_files "${filename_prefix}"
