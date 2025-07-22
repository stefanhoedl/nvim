function log
    if test -n "$argv[1]"
        # set -l jobs_arg (math "$argv[1]")
        dvc queue logs $argv[1] --follow
    else
        dvclog
    end
end
