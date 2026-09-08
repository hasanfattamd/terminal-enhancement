# rule — a dim divider across the terminal, then the prompt.
#
#   ────────────────────────────────────────────────────────
#   Desktop ❯
#
# The most emphatic separation of the set: every command gets a ruled line
# above it, so scrolling back through a long session you can see exactly where
# each one began. Costs the same one line as the blank line in `path`, and
# makes a stronger break.
#
# The rule is redrawn each prompt from $COLUMNS, so it stays the width of the
# window after a resize.

# Padding with the (l:...) flag counts bytes, not characters, so it splits the
# three-byte ─ and leaves mojibake. Building the rule by repetition is correct
# for any multibyte glyph. The result is cached and rebuilt only when the
# window width actually changes, so a resize is the only thing that costs
# anything.
typeset -g _te_rule_cache='' _te_rule_width=0

_te_rule() {
  local w=${COLUMNS:-80}
  if (( w != _te_rule_width )); then
    _te_rule_cache=''
    repeat $w _te_rule_cache+='─'
    _te_rule_width=$w
  fi
  print -n "%F{8}${_te_rule_cache}%f"
}

PROMPT='$(_te_rule)
$(_te_context)%B%F{$TE_ACCENT}%1~%f%b %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
