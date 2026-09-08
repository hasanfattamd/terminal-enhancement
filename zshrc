# ---------------------------------------------------------------------------
# .zshrc — loads the pieces in zsh/ and gets out of the way.
#
# Order matters: colors.zsh exports LS_COLORS, which options.zsh feeds to the
# completion menu so both use the same palette.
# ---------------------------------------------------------------------------

# Where this configuration lives. Override by exporting TERMINAL_ENHANCEMENT
# before your shell starts if you cloned it somewhere unusual.
: ${TERMINAL_ENHANCEMENT:=${${(%):-%N}:A:h}}
export TERMINAL_ENHANCEMENT

for _part in colors options aliases prompt; do
  _file=$TERMINAL_ENHANCEMENT/zsh/$_part.zsh
  [[ -r $_file ]] && source $_file
done
unset _part _file

# ---------------------------------------------------------------------------
# Your own settings. ~/.zshrc.local is never touched by this repo, so put
# machine-specific PATH entries, secrets and one-off aliases there.
# ---------------------------------------------------------------------------
[[ -r ~/.zshrc.local ]] && source ~/.zshrc.local
