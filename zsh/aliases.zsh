# ---------------------------------------------------------------------------
# aliases.zsh — a short list on purpose. Every alias here is one you will
# reach for daily; anything rarer is faster to type out than to remember.
# ---------------------------------------------------------------------------

# --- listing ---------------------------------------------------------------
# GNU and BSD `ls` spell the color flag differently, so pick once at startup.
if ls --color=auto . >/dev/null 2>&1; then
  alias ls='ls --color=auto --group-directories-first'
else
  alias ls='ls -G'
fi

alias l='ls -lh'          # the one you will actually use
alias ll='ls -lhA'        # ...including dotfiles
alias la='ls -A'
alias lt='ls -lhAt'       # newest first

# --- navigation ------------------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'         # back to the previous directory

# --- safety ----------------------------------------------------------------
# Prompt before clobbering, and show what was moved or removed.
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -p'

# --- git -------------------------------------------------------------------
alias g='git'
alias gs='git status --short --branch'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate -20'
alias gb='git branch'
alias gco='git checkout'

# --- misc ------------------------------------------------------------------
alias grep='grep --color=auto'
alias df='df -h'
alias du='du -h'
alias path='print -l $path'          # $PATH, one entry per line
alias reload='exec zsh'              # pick up config changes

# `mkcd new-dir` — make a directory and step into it.
mkcd() { mkdir -p -- "$1" && cd -- "$1" }
