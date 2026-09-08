# path — the whole prompt is where you are and where you type.
#
#   ~/code/api-server ❯
#
# No branch, no timer on the line, nothing conditional. The one thing it keeps
# from the other themes is the prompt character turning red when the last
# command failed, because that costs no space and is the signal most worth
# having.
#
# Two edits worth knowing:
#   %~  ->  %1~          show only the current directory's name, not the path
#   add $(_te_git)       put the branch and dirty dot back, after the path

PROMPT='$(_te_context)%F{$TE_ACCENT}%~%f %(?.%F{green}.%F{red})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
