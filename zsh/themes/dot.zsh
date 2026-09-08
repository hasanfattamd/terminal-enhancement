# dot — a small diamond, then the directory.
#
#   ◆ Desktop ❯
#
# The same idea as `bar` with a more decorative mark. The diamond is a
# standard Unicode glyph, so it needs no particular font.

PROMPT='$(_te_context)%F{$TE_ACCENT}◆%f %B%1~%b %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
