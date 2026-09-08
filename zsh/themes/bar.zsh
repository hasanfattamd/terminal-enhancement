# bar — a thin accent rule down the left edge.
#
#   ▍Desktop ❯
#
# Gives the prompt an identity without spending a line on it, which is the
# trade the `path` theme makes. The rule is the only colored thing, so the
# directory can stay in plain bold and still read first.

PROMPT='$(_te_context)%F{$TE_ACCENT}▍%f%B%1~%b %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
