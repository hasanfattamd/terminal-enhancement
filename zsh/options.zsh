# ---------------------------------------------------------------------------
# options.zsh — shell behaviour. Nothing here changes how the terminal looks;
# it is the part that makes a clean prompt pleasant to actually use.
# ---------------------------------------------------------------------------

# --- history ---------------------------------------------------------------
HISTFILE=${HISTFILE:-$HOME/.zsh_history}
HISTSIZE=50000
SAVEHIST=50000

setopt EXTENDED_HISTORY          # record timestamps
setopt INC_APPEND_HISTORY        # write as you go, not only on exit
setopt SHARE_HISTORY             # new commands are visible in other shells
setopt HIST_IGNORE_ALL_DUPS      # keep only the most recent copy of a command
setopt HIST_IGNORE_SPACE         # a leading space keeps a command out of history
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY               # expand !! into the line instead of running it

# --- navigation ------------------------------------------------------------
setopt AUTO_CD                   # `..` and `/etc` cd there
setopt AUTO_PUSHD                # every cd pushes onto the directory stack
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT              # ...without printing the stack every time

# --- globbing --------------------------------------------------------------
setopt EXTENDED_GLOB
setopt NUMERIC_GLOB_SORT         # file10 sorts after file9
unsetopt CASE_GLOB

# --- quality of life -------------------------------------------------------
setopt INTERACTIVE_COMMENTS      # allow `# comments` when typing
setopt NO_BEEP
setopt NO_FLOW_CONTROL           # free up ctrl-s / ctrl-q
setopt NO_CLOBBER                # `>` refuses to overwrite; use `>|` on purpose

# --- completion ------------------------------------------------------------
autoload -Uz compinit

# compinit's security check stats every directory in $fpath and is the single
# largest cost in most zsh startups. Run the full check once a day and take the
# fast path otherwise.
_minimal_zcompdump=${ZDOTDIR:-$HOME}/.zcompdump
if [[ -n ${_minimal_zcompdump}(#qN.mh-24) ]]; then
  compinit -C -d "$_minimal_zcompdump"
else
  compinit -d "$_minimal_zcompdump"
fi
unset _minimal_zcompdump

zstyle ':completion:*' menu select                        # arrow-key selection
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'    # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}     # match `ls` coloring
zstyle ':completion:*' group-name ''                      # group by kind
zstyle ':completion:*:descriptions' format '%F{8}%d%f'    # dim group headings
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
zstyle ':completion:*' special-dirs true                  # complete . and ..

# --- keys ------------------------------------------------------------------
bindkey -e                                                # emacs-style keys

# Up/Down search history for what has already been typed rather than walking
# every command blindly.
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search
bindkey '^P'   up-line-or-beginning-search
bindkey '^N'   down-line-or-beginning-search

bindkey '^[[1;5C' forward-word        # ctrl-right
bindkey '^[[1;5D' backward-word       # ctrl-left
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[3~'   delete-char
