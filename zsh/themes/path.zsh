# path — where you are, then where you type.
#
#   Desktop ❯
#
# Just the current directory's name (%1~), not the whole path. No branch, no
# timer on the line, nothing conditional. The one thing it keeps is the prompt
# character turning red when the last command failed, because that costs no
# space and is the signal most worth having.
#
# Two edits worth knowing:
#   %1~  ->  %~          show the full home-relative path instead
#   add $(_te_git)       put the branch and dirty dot back, after the name

PROMPT='$(_te_context)%F{$TE_ACCENT}%1~%f %(?.%F{green}.%F{red})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
