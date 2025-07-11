# Define a fish shell function to get DVC queue logs for running, failed, or successful tasks.
# It can specifically target the most recent failed or successful task using flags.
function dvclog --description "Follow logs of the first running DVC experiment, or the first failed one if no tasks are running. Use --failed to target the most recent failed task specifically. Use --success to target the most recent successful task."
    set -l target_failed_only false
    set -l target_success_only false

    # Parse arguments
    for arg in $argv
        switch "$arg"
            case "--failed"
                set target_failed_only true
            case "--success"
                set target_success_only true
            case "*"
                echo "Unknown argument: $arg" >&2
                return 1
        end
    end

    # Ensure only one target flag is set
    if $target_failed_only; and $target_success_only
        echo "Error: Cannot use --failed and --success together." >&2
        return 1
    end

    echo "Checking DVC queue status..."

    # Get the DVC queue status, skipping the header line.
    set -l dvc_status_output (dvc queue status | tail -n +2)

    set -l experiments # Array to store parsed experiment data (format: "ID Name Status")
    # Parse each line of the status output
    for line in $dvc_status_output
        # Extract the experiment ID (first column) and Name (second column).
        # These are generally consistent in DVC queue status output.
        set -l exp_id (echo "$line" | awk '{print $1}')
        set -l exp_name (echo "$line" | awk '{print $2}')
        set -l detected_status "" # Variable to hold the detected status (Running, Failed, Success)

        # Robustly detect the status by checking for keywords within the line
        if echo "$line" | grep -q "Running"
            set detected_status "Running"
        else if echo "$line" | grep -q "Failed"
            set detected_status "Failed"
        else if echo "$line" | grep -q "Success"
            set detected_status "Success"
        end

        # Add to array if parsing was successful for the core fields
        if test -n "$exp_id" -a -n "$exp_name" -a -n "$detected_status"
            set -a experiments "$exp_id $exp_name $detected_status"
        end
    end

    set -l expid_to_log ""
    set -l exp_name_to_log ""

    if $target_failed_only
        echo "Searching for the most recent failed task..."
        set -l failed_tasks # Array to hold all failed tasks
        for exp_entry in $experiments
            set -l current_entry_status (echo "$exp_entry" | awk '{print $3}') # Get status from parsed entry
            if test "$current_entry_status" = "Failed"
                set -a failed_tasks "$exp_entry"
            end
        end

        if test (count $failed_tasks) -gt 0
            # The last element in the array is the most recent (assuming dvc queue status lists oldest first)
            set -l most_recent_failed_task (echo "$failed_tasks" | tail -n 1)
            set expid_to_log (echo "$most_recent_failed_task" | awk '{print $1}')
            set exp_name_to_log (echo "$most_recent_failed_task" | awk '{print $2}')
            echo "Found most recent failed task: $expid_to_log (Name: $exp_name_to_log). Showing logs..."
        else
            echo "No failed DVC queue tasks found." >&2
            return 1
        end
    else if $target_success_only
        echo "Searching for the most recent successful task..."
        set -l successful_tasks # Array to hold all successful tasks
        for exp_entry in $experiments
            set -l current_entry_status (echo "$exp_entry" | awk '{print $3}') # Get status from parsed entry
            if test "$current_entry_status" = "Success"
                set -a successful_tasks "$exp_entry"
            end
        end

        if test (count $successful_tasks) -gt 0
            # The last element in the array is the most recent
            set -l most_recent_successful_task (echo "$successful_tasks" | tail -n 1)
            set expid_to_log (echo "$most_recent_successful_task" | awk '{print $1}')
            set exp_name_to_log (echo "$most_recent_successful_task" | awk '{print $2}')
            echo "Found most recent successful task: $expid_to_log (Name: $exp_name_to_log). Showing logs..."
        else
            echo "No successful DVC queue tasks found." >&2
            return 1
        end
    else
        # Default behavior: Try to find a running task first.
        set -l task_found false
        for exp_entry in $experiments
            set -l current_entry_status (echo "$exp_entry" | awk '{print $3}') # Get status from parsed entry
            if test "$current_entry_status" = "Running"
                set expid_to_log (echo "$exp_entry" | awk '{print $1}')
                set exp_name_to_log (echo "$exp_entry" | awk '{print $2}')
                echo "Found running task: $expid_to_log (Name: $exp_name_to_log). Following logs..."
                set task_found true
                break # Found the first running task
            end
        end

        if not $task_found
            # If no running task, try to find the first failed task.
            for exp_entry in $experiments
                set -l current_entry_status (echo "$exp_entry" | awk '{print $3}') # Get status from parsed entry
                if test "$current_entry_status" = "Failed"
                    set expid_to_log (echo "$exp_entry" | awk '{print $1}')
                    set exp_name_to_log (echo "$exp_entry" | awk '{print $2}')
                    echo "No running tasks found. Found first failed task: $expid_to_log (Name: $exp_name_to_log). Showing logs..."
                    set task_found true
                    break # Found the first failed task
                end
            end
        end

        if not $task_found
            echo "No running or failed DVC queue tasks found." >&2
            return 1 # Exit with an error code
        end
    end

    # If an experiment ID was found, follow its logs.
    if test -n "$expid_to_log"
        sleep 2 # Wait for 2 seconds before following logs to ensure logs are ready
        dvc queue logs "$expid_to_log" --follow
    else
        echo "Could not determine an experiment to log. This should not happen if a task was reported as found." >&2
        return 1
    end
end

# Add abbreviations for convenience
alias -s dlog "dvclog"
alias -s qlog "dvclog"
alias -s flog "dvclog --failed"
alias -s dlogf "dvclog --failed"
alias -s dlogs "dvclog --success"
