#!/bin/sh

current_date=$(date +"%Y-%m-%d")
filename_prefix="status_check_output"
output_log="${filename_prefix}_${current_date}.log"

(
    #flock is a file locking command to ensure only one process is updating the file
    flock -x 200

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
    
) 200>"$output_log.lock"

echo "Commands executed. Output and Errors saved to '$output_log'"

#using shared counterfile to track the cronjob executions
#increment the counterfile value, indicating that the cronjob is completed 
increment_counter_file(){
    counter_file="counterfile"

    (
        #flock is a file locking command to ensure only one process is updating the file
        flock -x 201
        max_count=8
        
        #To check if counterfile is present, else creates one and updated the value to 1
        if [ -e "$counter_file" ]; then
            counter=$(cat "$counter_file")
        else
            counter=1
        fi
        
        #check if the counter has reached the maximum limit
        if [ "$counter" -eq "$max_count" ]; then
            echo "All cronjobs have completed"

            #sending output to external system
            ## WIP ##

            #reset the counterfile to 0 to keep track of next cronjob execution
            counter=0
        else
            counter=$((counter+1))
            #update the shared counter

            echo "cronjob completed. counter value: $counter"
        fi
        echo "$counter" > "$counter_file"
    ) 201>"$counter_file.lock" 
}

#move older files(2 days) from current directory to tmp directory
delete_old_files(){
  #local directory="/home/student/myapp/mygit/testing"
  local filename_prefix="$1"
  find . -type f -name "${filename_prefix}*" -mtime +2 -exec mv {} /tmp/ \;
  echo "moved  the files that are older than 2 days with prefix '${filename_prefix}' in current directory"
}

###uncomment the below function calls for testing

#increment_counter_file
#delete_old_files "${filename_prefix}"
