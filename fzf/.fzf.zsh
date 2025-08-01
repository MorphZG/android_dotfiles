#
# https://github.com/junegunn/fzf/wiki
# don't forget to read the man pages
#
# clone the github repo than run ./install script
# fzf list can scroll with ctl+j ctrl+k
# select multiple files with tab, deselect with shift+tab
# press CTRL + / to toggle line wrapping
# white space will create separate search patterns
#
# Setup fzf
# ---------
if [[ ! "$PATH" == *$DOTFILES/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$DOTFILES/.fzf/bin"
fi

# Auto-completion
# ---------------
#source "$DOTFILES/fzf/shell/completion.zsh"

# Key bindings
# ------------
#source "$DOTFILES/fzf/shell/key-bindings.zsh"
 

# personal configuration
# ----------------------
# fzf use `fdfind` to search for files or directories.
# https://github.com/sharkdp/fd
# fdfind also have it's own man pages
# can use basic regex operators like: ^prefix suffix$ !exclude 'exact

export FZF_DEFAULT_COMMAND="fdfind --type file --type directory --hidden --exclude '.{cache,DS_Store,gem,git,npm,Trash}'"
export FZF_DEFAULT_OPTS="--ansi"
#
## --- ctrl-t modification
# find everything of type file
export FZF_CTRL_T_COMMAND="fdfind --type file --color=always --hidden --exclude '.{cache,DS_Store,gem,git,npm,Trash}'"
# preview selected file
export FZF_CTRL_T_OPTS="--header 'search for files' --tmux 80% --preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"

## --- ctrl-r modification
# disable sort by relevance, set chronological order
export FZF_CTRL_R_OPTS="--header 'commands history' --no-sort --tmux 80%" 

## --- alt-c modification
# find everything of type directory
export FZF_ALT_C_COMMAND="fdfind . --type directory --hidden"
# use tree command for preview (can scroll with arrow keys)
export FZF_ALT_C_OPTS="--header 'search for directories' --tmux 80% --preview 'tree -C {}'"

# positioned at the bottom of the file
#source <(fzf --zsh)
