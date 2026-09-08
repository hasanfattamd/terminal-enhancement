# indent — no glyphs at all.
#
#     Desktop  ❯
#
# Two spaces of margin and a wider gap before the chevron. The quietest theme
# here: it uses only whitespace to do what the others do with marks, which
# reads as deliberate rather than decorated.

PROMPT='$(_te_context)  %F{$TE_ACCENT}%1~%f  %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
