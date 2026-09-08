# classic — the familiar bash shape, with git added and the noise removed.
#
#   you@laptop:~/code/terminal-enhancement (main●)$
#
# One line, always shows user and host. Ends in $ as a normal user and # as
# root, the convention every shell tutorial assumes.

PROMPT='%F{green}%n@%m%f:%F{$TE_ACCENT}%~%f$(_te_git_paren)$(_te_venv)%(?..%F{red})%(!.#.$)%f '

RPROMPT='%F{8}${_te_elapsed}%f'
PROMPT2='%F{8}>%f '
