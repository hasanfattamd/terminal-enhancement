# terminal-enhancement

A clean, minimal zsh setup. No frameworks, no plugin manager, no external
binaries — just zsh's own features, so it starts fast and there is nothing to
keep updated.

```
~/code/terminal-enhancement  main ●                                      6.0s
❯ git commit
```

**Line one** tells you where you are: the directory, the git branch (dimmed,
because you usually already know it), and a dot when the working tree is
dirty. On the right, how long the last command took — but only when it took
long enough to matter.

**Line two** is just the character you type after. It is green normally and
**red when the last command failed**, so a failure is visible even when the
output above scrolled past.

Colors come from your terminal's own 16-color ANSI palette rather than fixed
hex values, so the prompt adopts whatever scheme you already use instead of
clashing with it.

## Install

```sh
git clone https://github.com/hasanfattamd/terminal-enhancement.git ~/.terminal-enhancement
cd ~/.terminal-enhancement
./install.sh
exec zsh
```

`install.sh` symlinks `~/.zshrc` to this repo, moving any existing file to
`~/.zshrc.backup-<timestamp>` first — nothing is overwritten.

| | |
|---|---|
| `./install.sh` | symlink `~/.zshrc` (backs up the old one) |
| `./install.sh --append` | keep your `~/.zshrc`, just add a `source` line to it |
| `./install.sh --dry-run` | print what would happen, change nothing |
| `./install.sh --uninstall` | undo either mode and restore the backup |

## What's in it

| File | |
|---|---|
| `zsh/prompt.zsh` | the two-line prompt, git status, command timer |
| `zsh/options.zsh` | history, completion, key bindings, `cd` behaviour |
| `zsh/colors.zsh` | `ls`, `grep`, `less` and man-page coloring |
| `zsh/aliases.zsh` | a deliberately short list of daily shortcuts |
| `zshrc` | loads the four files above |

Each file is commented with *why*, not just what, so it is meant to be edited
rather than treated as a black box.

### Beyond the prompt

The parts you will notice within a day of using it:

- **↑ searches.** Type `git` and press ↑ to walk only through commands that
  started with `git`, instead of your whole history.
- **50k lines of shared history**, deduplicated, synced live between open
  terminals. A command typed with a leading space is not recorded.
- **Case-insensitive completion with an arrow-key menu**, colored to match
  `ls`.
- **`cd` is optional** — typing `..` or `~/code` goes there.
- **`ls` output stops shouting.** The default GNU palette colors about forty
  file types; this narrows it to the four distinctions that mean something —
  directory, symlink, executable, archive — and *dims* build output, logs and
  backups rather than highlighting them.
- **Safer defaults.** `rm`/`mv`/`cp` ask before destroying something, and `>`
  will not silently overwrite an existing file (use `>|` when you mean it).

## Configuring

Put anything machine-specific in `~/.zshrc.local` — `PATH` entries, work
aliases, tokens. It is sourced last and this repo never touches it.

Two knobs, set before the prompt loads:

```sh
MINIMAL_PROMPT_GIT_DIRTY=0      # skip the dirty check in very large repos
MINIMAL_PROMPT_SLOW_SECONDS=10  # only time commands slower than this
```

The dirty-tree check is the only part of the prompt that touches the disk. It
is imperceptible in a normal repo; turn it off if you work in one with
hundreds of thousands of files.

## Speed

Measured on Linux with zsh 5.9, median of 10 interactive startups:

| | |
|---|---|
| `zsh -f`, no config at all | 2 ms |
| an empty `~/.zshrc` | 22 ms |
| **this config** | **39 ms** |

About 17 ms of that is ours. The completion cache is rebuilt once a day rather
than on every shell, which is what usually makes zsh feel slow to start.

## Requirements

zsh 5.3 or newer, and a font with a couple of common glyphs (`❯` and `●`) —
any modern terminal font has them. No Nerd Font, no patched font, no
Powerline.
