# plain — the directory and the character, on one line, with nothing above it.
#
#   Desktop ›
#
# The smallest thing in this set. No blank line, no divider, no mark: one line
# per prompt and nothing else on screen. Take this one if every other theme
# feels like it is adding something you did not ask for.
#
# The prompt character still turns red when the last command failed. It costs
# no space, and it is the only reason to look at the prompt after you have
# read the directory.

PROMPT='$(_te_context)%B%F{$TE_ACCENT}%1~%f%b %(?.%F{108}.%F{174})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
