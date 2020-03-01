#
# User configuration sourced by interactive shells
#

# Define zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

#
# General
#

# Editor
export EDITOR=nvim

# fzf
# Solarized colors
export FZF_DEFAULT_OPTS='
 --color=fg:#b2b2b2,bg:#292b2e,hl:#4f97d7
 --color=fg+:#e5e5e5,bg+:#444155,hl+:#bc6ec5
 --color=info:#2d9574,prompt:#b2b2b2,pointer:#bc6ec5
 --color=marker:#B1951D,spinner:#43505c,header:#43505c
'

# Aliases
alias passgen='LC_ALL=C tr -dc "[:alpha:][:alnum:]" < /dev/urandom | head -c 20 | pbcopy'

#
# Homebrew
#

# Cask application directory
export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

#
# Ruby
#

# rbenv
if [ -d "$HOME/.rbenv" ]; then
  PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)";
fi

# For openssl to work when compiling ruby
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"
export PATH="/usr/local/ssl/bin:$PATH"

# chruby
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

#
# Node.js
#

# n
export N_PREFIX="$HOME/.n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

# yarn
export PATH="$PATH:`yarn global bin`"
