cd ~/phd/

if status is-interactive
    # Commands to run in interactive sessions can go here
end

alias phd "cd ~/phd/"
 

# Aliases
alias nvv "$HOME/.config/nvim/nvim.appimage ~/.config/nvim/init.lua"
alias nvb "$HOME/.config/nvim/nvim.appimage ~/.config/fish/"
alias ds "docker start mmb"
alias dd "docker stop mmb"
alias cex "conda deactivate"
alias dql "dvc queue log \$argv[1]" # Fish uses $argv for arguments
alias dqs "dvc queue status"

alias ll "ls -alF"
alias la "ls -A"
alias l "ls -CF"
alias alert 'notify-send --urgency=low -i "(test \$status -eq 0 && echo terminal || echo error)" "(history | tail -n1 | sed -e "s/^\\s*[0-9]\\+\\s*//;s/[;&|]\\s*alert\$//")"'
# alias ll "ls -lh" # This is a duplicate, keep one
# alias la "ls -lhA" # This is a duplicate, keep one
alias py "python3"

# conda init

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/conda/bin/conda
    eval /opt/conda/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/opt/conda/etc/fish/conf.d/conda.fish"
        . "/opt/conda/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/opt/conda/bin" $PATH
    end
end
# <<< conda initialize <<<

# conda activate surfpro
