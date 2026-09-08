# ---------------------------------------------------------------------------
# prompt.zsh — the prompt engine.
#
# This file gathers the state a prompt might want (git branch, whether the
# tree is dirty, how long the last command took) and exposes it through small
# formatter functions. It does not decide how anything looks — that is a
# theme's job. Themes live in zsh/themes/ and are one short file each.
#
#   theme            show the current theme
#   theme list       list what is available
#   theme preview    render every theme using your real directory and branch
#   theme <name>     switch now, and remember it for future shells
# ---------------------------------------------------------------------------

autoload -Uz vcs_info add-zsh-hook
setopt PROMPT_SUBST

# --- settings --------------------------------------------------------------

: ${TE_STATE_DIR:=${XDG_CONFIG_HOME:-$HOME/.config}/terminal-enhancement}

# The one color a theme leans on. Any zsh color name or 0-255 number:
#   blue magenta cyan green yellow red white — or e.g. 39, 141, 208
#
# Precedence, highest first: TE_ACCENT set in your environment, then whatever
# `accent <color>` last remembered, then the default. Reading the remembered
# value before applying the default is what keeps that order correct.
[[ -z $TE_ACCENT && -r $TE_STATE_DIR/accent ]] && TE_ACCENT=$(<$TE_STATE_DIR/accent)
: ${TE_ACCENT:=blue}

# The character you type after. Themes that use one read it from here.
: ${TE_PROMPT_CHAR:=❯}

# The pointed cap on a filled block, used by the `blocks` theme.
#
# The seamless powerline arrow is U+E0B0, which exists only in patched fonts
# (Nerd Font, Powerline). If you have one installed, this gives the exact
# shape, the point filling the full height of the block:
#
#   TE_BLOCK_CAP=$'\ue0b0'
#
# The default is a plain Unicode triangle that every font has. The point is a
# little shorter than the block, but nothing renders as a missing-glyph box.
: ${TE_BLOCK_CAP:=▶}

# Scanning for uncommitted changes is the only part of the prompt that touches
# the disk. Imperceptible in a normal repo, slow in one with hundreds of
# thousands of files — set to 0 there.
: ${TE_GIT_DIRTY:=${MINIMAL_PROMPT_GIT_DIRTY:-1}}

# Command duration is shown only past this many seconds. A prompt that reports
# "0s" on every line is noise, not information.
: ${TE_SLOW_SECONDS:=${MINIMAL_PROMPT_SLOW_SECONDS:-5}}

: ${TE_THEME_DIR:=${TERMINAL_ENHANCEMENT:-${${(%):-%N}:A:h:h}}/zsh/themes}

# --- git state -------------------------------------------------------------
# vcs_info ships with zsh, so there is no plugin to install and no subshell
# forked on every prompt.

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats       '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

if [[ $TE_GIT_DIRTY == 1 ]]; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' unstagedstr  '*'
  zstyle ':vcs_info:git:*' stagedstr    '+'
  zstyle ':vcs_info:git:*' formats      '%b%u%c'
fi

# Split what vcs_info reports into the two things a theme actually renders.
_te_branch=''
_te_dirty=''
_te_git_state() {
  _te_branch=''
  _te_dirty=''
  [[ -z $vcs_info_msg_0_ ]] && return
  local raw=${vcs_info_msg_0_%%[*+]*}
  [[ $vcs_info_msg_0_ != $raw ]] && _te_dirty=1
  # A branch name may legally contain '%', which would otherwise be read as a
  # prompt escape when the formatters below are expanded. Doubling it escapes it.
  _te_branch=${raw//\%/%%}
}

# --- command timing --------------------------------------------------------

_te_elapsed=''

_te_timer_start() { _te_timer=$EPOCHREALTIME }

_te_timer_stop() {
  _te_elapsed=''
  [[ -z $_te_timer ]] && return
  local elapsed=$(( EPOCHREALTIME - _te_timer ))
  unset _te_timer
  (( elapsed < TE_SLOW_SECONDS )) && return
  if (( elapsed < 60 )); then
    _te_elapsed=$(printf '%.1fs' $elapsed)
  else
    _te_elapsed=$(printf '%dm%ds' $(( elapsed / 60 )) $(( elapsed % 60 )))
  fi
}

zmodload zsh/datetime 2>/dev/null || {
  # Without zsh/datetime there is no sub-second clock, so drop the timer
  # rather than print something wrong.
  _te_timer_start() { : }
  _te_timer_stop()  { _te_elapsed='' }
}

_te_precmd() { _te_timer_stop; vcs_info; _te_git_state }
add-zsh-hook preexec _te_timer_start
add-zsh-hook precmd  _te_precmd

# ---------------------------------------------------------------------------
# Formatters. Themes call these; each prints nothing at all outside a repo, so
# a theme never has to guard against it.
# ---------------------------------------------------------------------------

# ` main ●` — branch dimmed, dot when dirty. The everyday form.
_te_git() {
  [[ -z $_te_branch ]] && return
  print -n " %F{8}${_te_branch}%f"
  [[ -n $_te_dirty ]] && print -n " %F{yellow}●%f"
}

# ` main●` — no color of its own, for themes that dim a whole region at once.
_te_git_plain() {
  [[ -z $_te_branch ]] && return
  print -n " ${_te_branch}${_te_dirty:+●}"
}

# ` (main●)` — for themes in the traditional bash idiom.
_te_git_paren() {
  [[ -z $_te_branch ]] && return
  print -n " %F{8}(${_te_branch}${_te_dirty:+●})%f"
}

# A filled segment ending in a point — the powerline shape.
#
# The trick is that the cap is not part of the fill. It is printed as a
# foreground glyph in the block's own color against the default background, so
# it reads as the block tapering off rather than as a separate character.
#
#   _te_block <background> <foreground> <text>
#
# The text is emitted rather than printed, so prompt escapes inside it (%~ and
# friends) are still expanded afterwards by zsh.
_te_block() {
  print -n "%K{$1}%F{$2} $3 %f%k%F{$1}${TE_BLOCK_CAP}%f"
}

# The git segment as a capped block, for themes built out of them.
_te_git_block() {
  [[ -z $_te_branch ]] && return
  _te_block 8 white "${_te_branch}${_te_dirty:+ ●}"
}

# ` (venv)` — the active Python environment, if any.
_te_venv() {
  local env=${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}
  [[ -z $env ]] && return
  print -n " %F{8}(${env:t})%f"
}

# `user@host ` — shown only over SSH or as root, so local prompts stay short
# and the one time you are somewhere unexpected actually stands out.
_te_context() {
  [[ -n $SSH_CONNECTION || $EUID -eq 0 ]] || return
  print -n "%F{8}%n@%m%f "
}

# ---------------------------------------------------------------------------
# Theme loading
# ---------------------------------------------------------------------------

_te_themes() { print -l -- $TE_THEME_DIR/*.zsh(N:t:r) }

_te_load_theme() {
  local name=$1
  local file=$TE_THEME_DIR/$name.zsh
  if [[ ! -r $file ]]; then
    print -u2 "theme: no such theme '$name'. Available: $(_te_themes | paste -sd' ' -)"
    return 1
  fi
  # Themes are additive, so clear what a previous one set before loading the
  # next. Otherwise switching from a theme with an RPROMPT to one without
  # would leave the old right-hand side stranded on screen.
  PROMPT='' RPROMPT='' PROMPT2='' RPROMPT2=''
  source $file
  TE_THEME=$name
}

theme() {
  local cmd=${1:-current}
  case $cmd in
    current|'')
      print -- $TE_THEME
      ;;
    list|-l)
      local t
      for t in $(_te_themes); do
        [[ $t == $TE_THEME ]] && print -- "* $t" || print -- "  $t"
      done
      ;;
    preview|-p)
      # Render each theme against the real directory and branch, so the
      # preview shows what you would actually get here rather than a mock-up.
      setopt local_options extended_glob
      local saved=$TE_THEME t right bare
      for t in $(_te_themes); do
        print -- "\n\e[1m$t\e[0m"
        _te_load_theme $t
        print -P -- "$PROMPT"
        # A theme's RPROMPT is usually a timer that is empty right now, so
        # strip the color escapes and only mention the right side if anything
        # visible survives.
        right=$(print -P -- "$RPROMPT")
        bare=${${right//$'\e'\[[0-9;]#m/}// /}
        [[ -n $bare ]] && print -- "   right side: $right"
      done
      print
      _te_load_theme $saved
      ;;
    help|-h|--help)
      print -- "theme            show the current theme"
      print -- "theme list       list available themes"
      print -- "theme preview    render every theme with your real state"
      print -- "theme <name>     switch now and remember the choice"
      ;;
    *)
      _te_load_theme $cmd || return 1
      # Overwrite deliberately with >| : options.zsh sets NO_CLOBBER, under
      # which a plain > refuses to replace an existing choice, so switching
      # theme a second time would fail to stick.
      mkdir -p $TE_STATE_DIR && print -- $cmd >| $TE_STATE_DIR/theme
      ;;
  esac
}

# ---------------------------------------------------------------------------
# Accent color
#
# The second axis of the look. Themes reference $TE_ACCENT at render time, so
# a change takes effect on the very next prompt with nothing to reload.
# ---------------------------------------------------------------------------

accent() {
  local arg=${1:-current}
  case $arg in
    current|'')
      print -- $TE_ACCENT
      ;;
    list|-l)
      # Swatches, so you can pick by eye instead of by guessing at a name.
      local c
      print -- "named:"
      for c in red green yellow blue magenta cyan white; do
        print -Pn -- "  %F{$c}${(r:10:)c}%f"
        print -P -- "%F{$c}████████%f"
      done
      print -- "\n256-color, e.g. 'accent 141' — a few that read well on both light and dark:"
      for c in 24 31 60 66 67 68 97 103 108 109 132 138 141 168 173 180; do
        print -Pn -- "%F{$c}███ $c%f  "
      done
      print
      ;;
    help|-h|--help)
      print -- "accent           show the current accent color"
      print -- "accent list      show color swatches to pick from"
      print -- "accent <color>   set it now and remember the choice"
      ;;
    *)
      TE_ACCENT=$arg
      mkdir -p $TE_STATE_DIR && print -- $arg >| $TE_STATE_DIR/accent
      ;;
  esac
}

# --- tab completion for both commands --------------------------------------
_te_complete_theme() {
  local -a names
  names=( $(_te_themes) list preview current help )
  _describe 'theme' names
}
_te_complete_accent() {
  local -a names
  names=( red green yellow blue magenta cyan white list current help )
  _describe 'accent' names
}
if (( $+functions[compdef] )); then
  compdef _te_complete_theme theme
  compdef _te_complete_accent accent
fi

# Pick the theme for this shell: an explicit TE_THEME wins, then a remembered
# choice, then the default.
if [[ -z $TE_THEME && -r $TE_STATE_DIR/theme ]]; then
  TE_THEME=$(<$TE_STATE_DIR/theme)
fi
_te_load_theme ${TE_THEME:-minimal} || _te_load_theme minimal
