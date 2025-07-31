# ========================================
# Custom function definitions
# ========================================
# Using custom Bash functions can significantly speed up your workflow by automating repetitive tasks.

# --- Navigation shortcuts ---
# 
# use fzf to select directory inside $HOME/coding/ and cd into it
# usage: type "learn" will launch fzf inside coding dir
coding() { # Search coding directory
  local dir
  dir=$(find "$HOME/coding" -mindepth 1 -maxdepth 2 -type d | fzf) && cd "$dir"
}

# cd into one of public projects, input first argument
# usage: type "project project_name"
project() { # Search public_projects directory
  local dir
  dir=$(find "$HOME/coding/public_projects" -mindepth 1 -maxdepth 1 -type d | fzf) && cd "$dir"
}

doc() { # Search Documents directory
  local dir
  dir=$(find "$HOME/Documents" -mindepth 1 -maxdepth 1 -type d | fzf --header="select a directory inside ~/Documents") && cd "$dir"
}

# reload shell configuration by sourcing .zshrc
# usage: type "reload"
reload() { # Source ~/.zshrc
  source ~/.zshrc
  echo "ZSH configuration reloaded! 🎉"
} 

