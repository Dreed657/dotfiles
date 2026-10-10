#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
NVIM_SOURCE="$ROOT_DIR/nvim"
NVIM_TARGET="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
LOCAL_BIN="$HOME/.local/bin"
LOCAL_OPT="$HOME/.local/opt"

info() { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m==>\033[0m %s\n' "$*"; }
fail() { printf '\033[1;31m==> ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

install_dependencies() {
  local missing=()
  for cmd in git curl tar rg; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done

  if command -v fd >/dev/null 2>&1 || command -v fdfind >/dev/null 2>&1; then
    :
  else
    missing+=("fd")
  fi

  if ((${#missing[@]} == 0)); then
    return
  fi

  info "Installing terminal dependencies: ${missing[*]}"

  if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y git curl tar ripgrep fd-find unzip gcc make
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo apt-get install -y git curl tar ripgrep fd-find unzip build-essential
  else
    fail "Unsupported package manager. Install git, curl, tar, ripgrep and fd manually, then rerun this script."
  fi

  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    mkdir -p "$LOCAL_BIN"
    ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"
  fi
}

install_neovim() {
  local need_install=1

  if command -v nvim >/dev/null 2>&1; then
    local version
    version="$(nvim --version | head -n1 | awk '{print $2}' | sed 's/^v//')"
    if printf '%s\n%s\n' '0.11.2' "$version" | sort -V -C; then
      need_install=0
    else
      warn "Neovim $version is older than 0.11.2; installing the current release locally."
    fi
  fi

  (( need_install == 0 )) && return

  local machine asset tmp archive extracted
  machine="$(uname -m)"
  case "$machine" in
    x86_64|amd64) asset="nvim-linux-x86_64.tar.gz" ;;
    aarch64|arm64) asset="nvim-linux-arm64.tar.gz" ;;
    *) fail "Unsupported CPU architecture: $machine" ;;
  esac

  mkdir -p "$LOCAL_BIN" "$LOCAL_OPT"
  tmp="$(mktemp -d)"
  trap 'rm -rf "$tmp"' RETURN
  archive="$tmp/$asset"

  info "Installing current Neovim release into ~/.local/opt"
  curl -fL "https://github.com/neovim/neovim/releases/latest/download/$asset" -o "$archive"
  tar -xzf "$archive" -C "$tmp"
  extracted="$tmp/${asset%.tar.gz}"

  rm -rf "$LOCAL_OPT/nvim"
  mv "$extracted" "$LOCAL_OPT/nvim"
  ln -sf "$LOCAL_OPT/nvim/bin/nvim" "$LOCAL_BIN/nvim"
}

link_config() {
  mkdir -p "$(dirname "$NVIM_TARGET")"

  if [[ -L "$NVIM_TARGET" ]]; then
    local current
    current="$(readlink -f "$NVIM_TARGET")"
    if [[ "$current" == "$(readlink -f "$NVIM_SOURCE")" ]]; then
      info "Neovim config is already linked."
      return
    fi
  fi

  if [[ -e "$NVIM_TARGET" || -L "$NVIM_TARGET" ]]; then
    local backup="${NVIM_TARGET}.bak.$(date +%Y%m%d-%H%M%S)"
    warn "Existing Neovim config found; moving it to $backup"
    mv "$NVIM_TARGET" "$backup"
  fi

  ln -s "$NVIM_SOURCE" "$NVIM_TARGET"
  info "Linked $NVIM_TARGET -> $NVIM_SOURCE"
}

main() {
  [[ -d "$NVIM_SOURCE" ]] || fail "Expected config directory at $NVIM_SOURCE"

  install_dependencies
  install_neovim
  link_config

  export PATH="$LOCAL_BIN:$PATH"

  info "Bootstrap complete."
  printf '\nRun:\n  nvim\n\n'
  printf 'On first launch, LazyVim will install its plugin set automatically.\n'

  if [[ ":$PATH:" != *":$LOCAL_BIN:"* ]]; then
    warn "$LOCAL_BIN is not on PATH in your shell startup files. Add it if nvim is not found in a new terminal."
  fi
}

main "$@"
