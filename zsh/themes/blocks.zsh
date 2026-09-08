# blocks — filled segments, the powerline look without a patched font.
#
#   ▐ ~/code/terminal-enhancement ▌▐ main ● ▌ ❯
#
# Real powerline themes need a Nerd Font for the arrow glyphs. This uses
# background color and padding instead, so it renders correctly in any
# terminal with any font.
#
# One line, with the prompt character sitting at the right end of the blocks.
# It stays outside the filled segments so it keeps its own color — green
# normally, red when the last command failed — which is the one signal worth
# not burying inside a background fill.

PROMPT='$(_te_context)%K{$TE_ACCENT}%F{white} %~ %f%k$(_te_git_block)$(_te_venv) %(?.%F{green}.%F{red})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
