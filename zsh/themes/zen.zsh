# zen — the quietest one. Just a character to type after.
#
#   ❯                                    ~/code/terminal-enhancement main●
#
# Everything informational moves to the right, dimmed, where it stays out of
# your way while reading command output. The right side is also dropped
# automatically when you type a long line, so it never collides with input.

PROMPT='%(?.%F{$TE_ACCENT}.%F{red})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}%~$(_te_git_plain)${_te_elapsed:+ $_te_elapsed}%f'
PROMPT2='%F{8}·%f '
