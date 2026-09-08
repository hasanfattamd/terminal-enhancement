# ---------------------------------------------------------------------------
# colors.zsh — a restrained palette for the tools that print in color.
#
# The default GNU `ls` palette paints roughly forty file types, which makes a
# listing look like confetti. This narrows it to the four distinctions that
# actually carry meaning while browsing — directory, link, executable,
# archive — and dims everything that is noise (backups, build output, lock
# files) instead of highlighting it.
# ---------------------------------------------------------------------------

# --- ls --------------------------------------------------------------------
# 01;34 bold blue · 36 cyan · 32 green · 35 magenta · 90 grey · 31 red
LS_COLORS='di=01;34:ln=36:so=35:pi=33:ex=32:bd=33;01:cd=33;01:su=31:sg=31:tw=01;34:ow=01;34:or=31;01:mi=31;01'
LS_COLORS+=':*.tar=35:*.tgz=35:*.zip=35:*.gz=35:*.bz2=35:*.xz=35:*.zst=35:*.7z=35:*.rar=35'
LS_COLORS+=':*.jpg=35:*.jpeg=35:*.png=35:*.gif=35:*.svg=35:*.webp=35:*.mp4=35:*.mp3=35:*.pdf=35'
LS_COLORS+=':*.o=90:*.pyc=90:*.class=90:*.lock=90:*.log=90:*.bak=90:*.swp=90:*.tmp=90:*~=90'
export LS_COLORS

# BSD `ls` on macOS reads a different, positional variable. Same intent:
# directories blue, links cyan, executables green, archives magenta.
export LSCOLORS='exgxfxdxcxdxdxhbhdacad'
export CLICOLOR=1

# --- grep ------------------------------------------------------------------
# Match in bold red, line numbers and filenames dimmed so the match is what
# your eye lands on.
export GREP_COLORS='mt=01;31:fn=36:ln=90:se=90'

# --- less / man ------------------------------------------------------------
# -R  keep colors  ·  -F  don't page output that fits  ·  -X  don't clear the
# screen on exit  ·  -i  case-insensitive search
export LESS='-RFXi'
export LESSHISTFILE=-

# man pages: headings bold, everything else plain. The default is a wall of
# reverse video on some systems.
export LESS_TERMCAP_md=$'\e[1;34m'    # bold      -> blue
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;36m'    # underline -> cyan
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_so=$'\e[7;90m'    # status line
export LESS_TERMCAP_se=$'\e[0m'
