# ================================
#      $ type <alias>
# ================================

# apps
alias cat="bat"
alias rng="ranger"
alias showinfo="neofetch"
alias md="frogmouth"
alias lgit="lazygit"
alias gst="git status"

# navigation
alias dotfiles="cd $HOME/.dotfiles"

# basics
alias ls="eza --icons"
alias l="eza -lah --sort=modified --reverse --total-size" # total size of a directory (recursive)
alias ll="eza -all --long --icons --tree --level=2 --total-size"
alias llg="eza --all --long --icons --tree --level=2 --total-size --git-ignore"
alias la="eza --all --icons"
alias e="exit"

# chained commands
alias lsf="grep '()' ~/.oh-my-zsh/custom/function.zsh" # list custom functions
alias myalias="grep --color=always -E '^(alias\s|#)' ~/.oh-my-zsh/custom/alias.zsh" # -E extends the regex, no need to escape the parentheses 

