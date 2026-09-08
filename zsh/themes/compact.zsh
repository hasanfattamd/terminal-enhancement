# compact — one line, for narrow terminals and split panes.
#
#   terminal-enhancement main ● ❯
#
# Only the current directory's name rather than the whole path (%1~), since in
# a narrow pane the last component is the part you actually needed.

PROMPT='$(_te_context)%F{$TE_ACCENT}%1~%f$(_te_git)$(_te_venv) %(?.%F{green}.%F{red})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
