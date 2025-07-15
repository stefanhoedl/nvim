function svim
    # Check if the first argument ($argv[1]) is empty
    if test -z "$argv[1]"
        sudo /opt/nvim/nvim . # Open nvim in the current directory if no argument is given
    else
        sudo /opt/nvim/nvim "$argv[1]" # Open nvim with the provided argument
    end
end
