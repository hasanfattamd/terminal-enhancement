# blocks — filled segments with a pointed end, the powerline shape.
#
#   ▐ ~/code/terminal-enhancement ▶▐ main ● ▶ ❯
#
# Each segment tapers to a point on the right. The cap is drawn as a
# foreground glyph in that segment's own color, so it reads as part of the
# block rather than as a character after it.
#
# The cap character comes from $TE_BLOCK_CAP. The default is a plain Unicode
# triangle that renders in any font; if you have a Nerd Font or Powerline font
# installed, set TE_BLOCK_CAP=$'' for the seamless arrow whose point
# fills the full height of the block.
#
# The prompt character stays outside the blocks so it keeps its own color —
# green normally, red when the last command failed.

PROMPT='$(_te_context)$(_te_block $TE_ACCENT white "%~")$(_te_git_block)$(_te_venv) %(?.%F{green}.%F{red})${TE_PROMPT_CHAR}%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}·%f '
