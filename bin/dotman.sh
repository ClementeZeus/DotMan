#!/usr/bin/env bash
set -euo pipefail

readonly GREEN="\033[0;32m"
readonly RED="\033[0;31m"
readonly YELLOW="\033[1;33m"
readonly NC="\033[0m" 

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

DRY_RUN=false
FORCE=false

while get-opts "dfh" opt; do
  case ${opt} in
    d) DRY_RUN=true ;;
    f) FORCE=true ;;
    h|*)
      echo "Usage: dotman [-d] [-f] [-h]"
      echo "  -d : Dry run (no changes made)"
      echo "  -f : Force overwrite existing files"
      exit 0
      ;;
  esac
done

link_file() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    log_error "Source file does not exist: $src"
  fi

  local dest_dir
  dest_dir=$(dirname "$dest")
  
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    if [ "$FORCE" = true ]; then
      log_warn "Overwriting existing non-symlink: $dest"
      if [ "$DRY_RUN" = false ]; then
        mv "$dest" "${dest}.bak.$(date +%Y%m%d%H%M%S)"
      fi
    else
      log_warn "Target exists and is not a symlink (use -f to override): $dest"
      return
    fi
  fi

  if [ "$DRY_RUN" = true ]; then
    log_info "[DRY-RUN] Would link $src -> $dest"
  else
    ln -sfn "$src" "$dest"
    log_info "Linked $src -> $dest"
  fi
}

main() {
  log_info "Starting dotfiles deployment..."
  log_info "Done!"
}

main "$@"
