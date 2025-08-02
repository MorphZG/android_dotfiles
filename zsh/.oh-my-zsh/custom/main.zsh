# Files in the custom/ directory will be
# automatically loaded by the init script
# in alphabetical order.

# ================================
#      environment variables
# ================================

# environment variables
export EDITOR=nvim
export GIT_CLONES="$HOME/git_clones"
export DOTFILES="$HOME/.dotfiles"
export MANPAGER="nvim +Man!"  # pager, neovim instead of default less or more
#export PAGER="stdout"
export GREP_COLORS=auto
export GEM_HOME="$HOME/gems"  # ruby gems install directory
export GEMS="$HOME/gems/bin"
export RANGER_LOAD_DEFAULT_RC=false

# ================================
#
# ================================

# Start tmux if it is installd and if it's not already running
# `command -v tmux` is a reliable way to check for a command's existence
# `[ -z "$TMUX ]` if tmux is NOT running $TMUX variable will be empty
if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
  tmux
fi
