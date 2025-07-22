function dqs
    if test -n "$argv[1]"
        set -l jobs_arg (math "$argv[1]")
        dvc queue start --jobs $jobs_arg
    else
        dvc queue start
    end
end

