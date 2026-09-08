#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# install.sh — link this configuration into place.
#
#   ./install.sh            symlink ~/.zshrc to this repo (backs up any existing
#                           file first)
#   ./install.sh --append   leave your ~/.zshrc alone and add a single source
#                           line to the end of it
#   ./install.sh --dry-run  print what would happen and change nothing
#   ./install.sh --uninstall  remove the link (or the source line) and restore
#                           the most recent backup
# ---------------------------------------------------------------------------
set -euo pipefail

REPO=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
TARGET=$HOME/.zshrc
SOURCE=$REPO/zshrc
MARKER='# >>> terminal-enhancement >>>'

MODE=link
DRY_RUN=0

for arg in "$@"; do
  case $arg in
    --append)    MODE=append ;;
    --uninstall) MODE=uninstall ;;
    --dry-run)   DRY_RUN=1 ;;
    -h|--help)   sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *)           printf 'unknown option: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

say() { printf '  %s\n' "$*"; }
run() { if [[ $DRY_RUN == 1 ]]; then say "would: $*"; else "$@"; fi; }

# Move an existing file aside rather than destroying it. Timestamped so
# repeated installs never overwrite an earlier backup.
backup() {
  local file=$1
  [[ -e $file || -L $file ]] || return 0
  [[ -L $file && $(readlink "$file") == "$SOURCE" ]] && return 0  # already ours
  local dest="$file.backup-$(date +%Y%m%d%H%M%S)"
  say "backing up $file -> $dest"
  run mv -- "$file" "$dest"
}

case $MODE in
  link)
    say "linking $TARGET -> $SOURCE"
    backup "$TARGET"
    run ln -sfn -- "$SOURCE" "$TARGET"
    ;;

  append)
    if [[ -f $TARGET ]] && grep -qF "$MARKER" "$TARGET"; then
      say "already appended to $TARGET — nothing to do"
    else
      say "appending a source line to $TARGET"
      # Copy rather than move: the original stays in place and keeps working.
      if [[ -f $TARGET && $DRY_RUN == 0 ]]; then
        cp -- "$TARGET" "$TARGET.backup-$(date +%Y%m%d%H%M%S)"
      fi
      if [[ $DRY_RUN == 0 ]]; then
        {
          printf '\n%s\n' "$MARKER"
          printf 'source %s\n' "$SOURCE"
          printf '# <<< terminal-enhancement <<<\n'
        } >> "$TARGET"
      else
        say "would: append 'source $SOURCE' to $TARGET"
      fi
    fi
    ;;

  uninstall)
    if [[ -L $TARGET && $(readlink "$TARGET") == "$SOURCE" ]]; then
      say "removing symlink $TARGET"
      run rm -- "$TARGET"
    elif [[ -f $TARGET ]] && grep -qF "$MARKER" "$TARGET"; then
      say "removing the source line from $TARGET"
      run sed -i.tmp "\|$MARKER|,\|<<< terminal-enhancement <<<|d" "$TARGET"
      run rm -f -- "$TARGET.tmp"
    else
      say "$TARGET is not managed by this repo — leaving it alone"
    fi

    restore=$(ls -1dt "$TARGET".backup-* 2>/dev/null | head -1 || true)
    if [[ -n $restore && ! -e $TARGET ]]; then
      say "restoring $restore -> $TARGET"
      run mv -- "$restore" "$TARGET"
    fi
    ;;
esac

if [[ $MODE != uninstall && $DRY_RUN == 0 ]]; then
  printf '\nDone. Start a new shell, or run: exec zsh\n'
fi
