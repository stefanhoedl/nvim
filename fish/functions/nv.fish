# ~/.config/fish/functions/nv.fish
function nv
    # Check if the first argument ($argv[1]) is empty
    if test -z "$argv[1]"
        nvim . # Open nvim in the current directory if no argument is given
    else
        nvim "$argv[1]" # Open nvim with the provided argument
    end
end
