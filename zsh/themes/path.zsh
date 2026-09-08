# path — where you are, then where you type.
#
#   Desktop ❯
#
# Three things do the work here, and none of them add information:
#
#   A blank line before each prompt. Costs one line per command and buys more
#   than anything else on this list: each command and its output becomes a
#   visually distinct block instead of one continuous wall of text.
#
#   The directory in bold. It is the only thing on the line worth reading, so
#   it gets the weight; the chevron stays light.
#
#   A softened pair for the chevron — sage rather than terminal green, dusty
#   rose rather than alarm red. Still unmistakably different from each other,
#   which is the whole job, but neither shouts at you between every command.
#
# ---------------------------------------------------------------------------
# Prefer a different treatment? Replace the PROMPT line below with one of
# these. Each is a complete, self-contained alternative.
#
#   no blank line, otherwise identical:
#     PROMPT='%B%F{$TE_ACCENT}%1~%f%b %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '
#
#   a thin accent rule down the left, instead of the blank line:
#     PROMPT='%F{$TE_ACCENT}▍%f%B%1~%b %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '
#
#   a diamond instead of the rule:
#     PROMPT='%F{$TE_ACCENT}◆%f %B%1~%b %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '
#
#   no glyphs at all, just margin and a wider gap:
#     PROMPT='  %F{$TE_ACCENT}%1~%f  %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '
#
# For the fully muted look, pair any of them with a desaturated accent:
# `accent 110` gives a soft blue-grey, `accent 108` a sage that matches the
# chevron. Run `accent list` to pick by eye.
#
# Two more edits worth knowing:
#   %1~  ->  %~          the full home-relative path instead of the name alone
#   add $(_te_git)       put the branch and dirty dot back, after the name
# ---------------------------------------------------------------------------

PROMPT=$'\n''%B%F{$TE_ACCENT}%1~%f%b %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
