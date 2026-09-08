# pill — the directory in a single filled block.
#
#   ▐ Desktop ▌ ❯
#
# What `blocks` looks like stripped to one segment. The fill carries the
# color, so the chevron outside it is the only other thing on the line and
# still reads as the status signal it is.

# Bold white on the fill: a mid-tone accent leaves plain white too close to
# its background to read comfortably.
PROMPT='$(_te_context)%K{$TE_ACCENT}%B%F{white} %1~ %f%b%k %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
