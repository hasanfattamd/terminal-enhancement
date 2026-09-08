# terminal-enhancement

A clean, minimal zsh setup. No frameworks, no plugin manager, no external
binaries — just zsh's own features, so it starts fast and there is nothing to
keep updated.
## Seven looks, switchable live

Run `theme preview` to see them all rendered with your own directory and
branch, then `theme <name>` to switch. The change is instant — no reload, no
new shell — and it is remembered for next time.

**minimal** *(default)* — two lines, so a long path never squeezes what you type.

```
~/code/terminal-enhancement  main ●                              6.0s
❯
```

**path** — where you are, then where you type. Nothing else.

```

Desktop ❯
```

Just the current directory's name, in bold, after a blank line — so each
command and its output reads as its own block rather than one continuous wall.
The chevron uses a sage/rose pair instead of terminal green and red: still
unmistakably different, without shouting between every command.

The theme file carries four complete alternatives as comments — a left accent
rule, a diamond, a plain indent, and the same thing without the blank line —
so changing the treatment is swapping one line. Pair any of them with
`accent 110` or `accent 108` for a fully desaturated look.

**compact** — one line, for narrow terminals and split panes.

```
terminal-enhancement main ● ❯
```

**zen** — the quietest. Everything informational moves right, dimmed, and gets
out of the way while you read output.

```
❯                                    ~/code/terminal-enhancement main●
```

**classic** — the familiar bash shape, with git added and the noise removed.

```
you@laptop:~/code/terminal-enhancement (main●)$
```

**blocks** — the powerline look: filled segments that taper to a point on the
right. The cap is drawn in each segment's own color, so it reads as the block
tapering off rather than as a character sitting after it.

```
▐ ~/code/terminal-enhancement ▶▐ main ● ▶ ❯
```

The seamless powerline arrow is U+E0B0, which only exists in patched fonts. So
the default cap is a plain Unicode triangle that renders in *any* font — the
point is a little shorter than the block, but nothing shows up as a
missing-glyph box. If you have a Nerd Font or Powerline font installed, put
this in `~/.zshrc.local` for the exact full-height arrow:

```sh
TE_BLOCK_CAP=$'\ue0b0'
```

**info** — the same shape as minimal, but it tells you more: the time each
command started (useful when scrolling back through a long session), a
background job count, and the actual exit code on failure. The difference
between `1` and `127` is usually the whole diagnosis.

```
14:32:07 ~/code/terminal-enhancement  main ● (venv) 2&
127 ❯
```

### Picking a color

Every theme leans on one accent color, and `accent` changes it independently
of the theme — so seven shapes times any color you like.

```sh
accent list        # swatches, to pick by eye rather than by guessing a name
accent magenta     # a name...
accent 141         # ...or any 256-color number
```

To live with one for a while before committing to it, use `theme try <name>`.
That applies to the current shell only and is deliberately not written to
disk, so your other shells and your next session keep the theme you actually
chose.

Both `theme` and `accent` tab-complete, print the current setting when run
with no arguments, and remember your choice in
`~/.config/terminal-enhancement/`.

### What every theme shows

The prompt character turns **red when the last command failed**, so a failure
stays visible after its output has scrolled away. A dot appears next to the
branch when the working tree is dirty. Command duration appears only past a
threshold — a prompt that reports "0s" on every line is noise, not
information.

Colors reference your terminal's own ANSI palette rather than fixed hex
values, so the prompt adopts whatever scheme you already use instead of
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
| `zsh/prompt.zsh` | the prompt engine: git state, timing, `theme` and `accent` |
| `zsh/themes/*.zsh` | one short file per look — copy one to make your own |
| `zsh/options.zsh` | history, completion, key bindings, `cd` behaviour |
| `zsh/colors.zsh` | `ls`, `grep`, `less` and man-page coloring |
| `zsh/aliases.zsh` | a deliberately short list of daily shortcuts |
| `zshrc` | loads the files above |

Each file is commented with *why*, not just what, so it is meant to be edited
rather than treated as a black box. A theme is about six lines; the quickest
way to your own look is to copy the closest one and change it.

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

Anything set in your environment overrides a remembered choice:

```sh
TE_THEME=zen             # theme for this shell only
TE_ACCENT=141            # accent for this shell only
TE_PROMPT_CHAR='λ'       # the character you type after
TE_BLOCK_CAP=$'\ue0b0'   # the pointed cap in the blocks theme
TE_GIT_DIRTY=0           # skip the dirty check in very large repos
TE_SLOW_SECONDS=10       # only report commands slower than this
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
| **this config** | **37 ms** |

About 16 ms of that is ours. The completion cache is rebuilt once a day rather
than on every shell, which is what usually makes zsh feel slow to start.

## Requirements

zsh 5.3 or newer, and a font with a couple of common glyphs (`❯` and `●`) —
any modern terminal font has them. No Nerd Font, no patched font, no
Powerline.
