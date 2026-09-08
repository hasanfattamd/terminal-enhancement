# ---------------------------------------------------------------------------
# prompt.zsh — a minimal two-line prompt
#
#   ~/code/project  main ●                                   1.4s
#   ❯
#
# Line 1: current directory, git branch, a dot when the tree is dirty, and
#         (on the right) how long the last command took, if it was slow.
# Line 2: a single character you type after. It turns red when the previous
#         command failed.
#
# Colors are the terminal's own ANSI palette, so the prompt inherits whatever
# color scheme you already use instead of fighting it.
# ---------------------------------------------------------------------------

autoload -Uz vcs_info add-zsh-hook
setopt PROMPT_SUBST

# --- git status ------------------------------------------------------------
# vcs_info ships with zsh, so there is no plugin to install and nothing to
# fork a subshell for on every prompt.

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats       '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

# Scanning for uncommitted changes is the only slow part of the prompt. It is
# imperceptible in a normal repo and painful in a very large one, so it can be
# turned off with MINIMAL_PROMPT_GIT_DIRTY=0 in your ~/.zshrc.
: ${MINIMAL_PROMPT_GIT_DIRTY:=1}
if [[ $MINIMAL_PROMPT_GIT_DIRTY == 1 ]]; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' unstagedstr  '*'
  zstyle ':vcs_info:git:*' stagedstr    '+'
  zstyle ':vcs_info:git:*' formats      '%b%u%c'
fi

# --- command timing --------------------------------------------------------
# Only surfaced past a threshold; a prompt that reports "0s" on every line is
# noise, not information.
: ${MINIMAL_PROMPT_SLOW_SECONDS:=5}

_minimal_timer_start() { _minimal_timer=$EPOCHREALTIME }

_minimal_timer_stop() {
  _minimal_elapsed=""
  [[ -z $_minimal_timer ]] && return
  local elapsed=$(( EPOCHREALTIME - _minimal_timer ))
  unset _minimal_timer
  (( elapsed < MINIMAL_PROMPT_SLOW_SECONDS )) && return
  if (( elapsed < 60 )); then
    _minimal_elapsed=$(printf '%.1fs' $elapsed)
  else
    _minimal_elapsed=$(printf '%dm%ds' $(( elapsed / 60 )) $(( elapsed % 60 )))
  fi
}

zmodload zsh/datetime 2>/dev/null || {
  # Without zsh/datetime there is no sub-second clock, so drop the timer
  # rather than print something wrong.
  _minimal_timer_start() { : }
  _minimal_timer_stop()  { _minimal_elapsed="" }
}

# --- assembly --------------------------------------------------------------

_minimal_precmd() {
  _minimal_timer_stop
  vcs_info
}

add-zsh-hook preexec _minimal_timer_start
add-zsh-hook precmd  _minimal_precmd

# The branch, dimmed, with a dot when there is uncommitted work. Building it in
# a function keeps the PROMPT string itself readable.
_minimal_git() {
  [[ -z $vcs_info_msg_0_ ]] && return
  local branch=${vcs_info_msg_0_%%[*+]*}
  local dirty=${vcs_info_msg_0_#$branch}
  print -n " %F{8}${branch}%f"
  [[ -n $dirty ]] && print -n " %F{yellow}●%f"
}

# %~  home-relative path        %(?..)  only when the last command failed
PROMPT='%F{blue}%~%f$(_minimal_git)
%(?.%F{green}.%F{red})❯%f '

RPROMPT='%F{8}${_minimal_elapsed}%f'

# Continuation and select prompts, kept in the same visual language.
PROMPT2='%F{8}·%f '
PROMPT3='%F{8}?%f '

# Show the user and host only when they are not the usual ones — over SSH, or
# as root — so local prompts stay short.
if [[ -n $SSH_CONNECTION || $EUID -eq 0 ]]; then
  PROMPT="%F{8}%n@%m%f ${PROMPT}"
fi
