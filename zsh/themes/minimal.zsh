# minimal — two lines, nothing you did not ask for.
#
#   ~/code/terminal-enhancement  main ●                              6.0s
#   ❯
#
# The full path on its own line so long paths never squeeze what you type,
# and a prompt character that turns red when the last command failed.

PROMPT='$(_te_context)%F{$TE_ACCENT}%~%f$(_te_git)$(_te_venv)
%(?.%F{green}.%F{red})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
