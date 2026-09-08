# info — the same shape as minimal, but it tells you more.
#
#   14:32:07 ~/code/terminal-enhancement  main ● (venv) 2&
#   127 ❯
#
# Adds the wall-clock time each command was started (useful when scrolling
# back through a long session), a count of background jobs, and the actual
# exit code on failure rather than only a color change — the difference
# between 1 and 127 is usually the whole diagnosis.

PROMPT='%F{8}%*%f $(_te_context)%F{$TE_ACCENT}%~%f$(_te_git)$(_te_venv)%(1j. %F{8}%j&%f.)
%(?..%F{red}%? )%(?.%F{green}.%F{red})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
