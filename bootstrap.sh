#!/usr/bin/env bash
# Bootstrap a fresh Linux/macOS machine with this Neovim config.
#
# Installs system dependencies (neovim, git, ripgrep, fd, lazygit, node) via
# the platform's package manager, then places the config in ~/.config/nvim.
#
# Usage:
#   ./bootstrap.sh                        # copy the repo this script lives in
#   ./bootstrap.sh -u <repo-url>          # clone a remote repo instead
#   ./bootstrap.sh -f                     # overwrite an existing nvim config

set -euo pipefail

REPO_URL=""
FORCE=0

while getopts "u:fh" opt; do
    case $opt in
        u) REPO_URL="$OPTARG" ;;
        f) FORCE=1 ;;
        h) sed -n '2,12p' "$0"; exit 0 ;;
        *) echo "Unknown option" >&2; exit 1 ;;
    esac
done

step()  { printf '\033[36m==> %s\033[0m\n' "$*"; }
skip()  { printf '\033[90m    %s\033[0m\n' "$*"; }
warn()  { printf '\033[33m!!! %s\033[0m\n' "$*"; }

# 1. Install system dependencies.
step "Detecting platform and installing system dependencies"

UNAME="$(uname -s)"

install_macos() {
    if ! command -v brew >/dev/null; then
        warn "Homebrew not found. Install from https://brew.sh first."
        exit 1
    fi
    # PATH name -> brew formula name. Most are identical; the only exception
    # is `fd`, which is shipped as `fd` on brew.
    declare -A pkgs=(
        [nvim]=neovim
        [git]=git
        [rg]=ripgrep
        [fd]=fd
        [lazygit]=lazygit
        [node]=node
    )
    for bin in "${!pkgs[@]}"; do
        local formula="${pkgs[$bin]}"
        if command -v "$bin" >/dev/null; then
            skip "$bin already on PATH"
        elif brew list --formula "$formula" >/dev/null 2>&1; then
            skip "$formula already installed via brew"
        else
            step "Installing $formula"
            brew install "$formula"
        fi
    done
    if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
        skip "JetBrainsMono Nerd Font already installed"
    else
        step "Installing JetBrainsMono Nerd Font"
        brew install --cask font-jetbrains-mono-nerd-font || \
            warn "Could not install Nerd Font cask; install manually."
    fi
}

install_debian() {
    # bin name -> apt package name.
    declare -A apt_pkgs=(
        [git]=git
        [rg]=ripgrep
        [fd]=fd-find
        [node]=nodejs
        [npm]=npm
        [nvim]=neovim
    )
    local missing=()
    for bin in "${!apt_pkgs[@]}"; do
        if command -v "$bin" >/dev/null; then
            skip "$bin already on PATH"
        else
            missing+=("${apt_pkgs[$bin]}")
        fi
    done

    if (( ${#missing[@]} > 0 )); then
        step "Updating apt"
        sudo apt-get update -qq
        step "Installing: ${missing[*]}"
        sudo apt-get install -y "${missing[@]}"
    fi

    if ! command -v lazygit >/dev/null; then
        step "Installing lazygit from official release"
        local ver
        ver=$(curl -sSL "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" \
            | grep -Po '"tag_name": "v\K[^"]*')
        curl -sSL "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${ver}_Linux_x86_64.tar.gz" \
            | sudo tar -xz -C /usr/local/bin lazygit
    else
        skip "lazygit already on PATH"
    fi

    warn "Install a Nerd Font manually: https://www.nerdfonts.com"
}

install_arch() {
    declare -A pac_pkgs=(
        [nvim]=neovim
        [git]=git
        [rg]=ripgrep
        [fd]=fd
        [lazygit]=lazygit
        [node]=nodejs
        [npm]=npm
    )
    local missing=()
    for bin in "${!pac_pkgs[@]}"; do
        if command -v "$bin" >/dev/null; then
            skip "$bin already on PATH"
        else
            missing+=("${pac_pkgs[$bin]}")
        fi
    done
    if (( ${#missing[@]} > 0 )); then
        sudo pacman -S --needed --noconfirm "${missing[@]}"
    fi
    warn "Install a Nerd Font via your AUR helper, e.g. 'yay -S ttf-jetbrains-mono-nerd'."
}

case "$UNAME" in
    Darwin) install_macos ;;
    Linux)
        if   command -v apt-get >/dev/null; then install_debian
        elif command -v pacman   >/dev/null; then install_arch
        else
            warn "Unsupported Linux distro. Install these manually: neovim git ripgrep fd lazygit node"
        fi
        ;;
    *) warn "Unsupported OS: $UNAME"; exit 1 ;;
esac

# 2. Place the config under ~/.config/nvim.
NVIM_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
step "Target nvim config dir: $NVIM_DIR"

if [[ -e "$NVIM_DIR" ]]; then
    if [[ $FORCE -eq 1 ]]; then
        step "Removing existing $NVIM_DIR (-f was supplied)"
        rm -rf "$NVIM_DIR"
    else
        warn "$NVIM_DIR already exists. Re-run with -f to overwrite."
        warn "Skipping config copy."
    fi
fi

if [[ ! -e "$NVIM_DIR" ]]; then
    mkdir -p "$(dirname "$NVIM_DIR")"
    if [[ -n "$REPO_URL" ]]; then
        step "Cloning $REPO_URL -> $NVIM_DIR"
        git clone "$REPO_URL" "$NVIM_DIR"
    else
        local_root="$(cd "$(dirname "$0")" && pwd)"
        step "Copying $local_root -> $NVIM_DIR"
        mkdir -p "$NVIM_DIR"
        # rsync if available, else cp -a.
        if command -v rsync >/dev/null; then
            rsync -a --exclude='.git' --exclude='.gitignore' "$local_root/" "$NVIM_DIR/"
        else
            cp -a "$local_root/." "$NVIM_DIR/"
            rm -rf "$NVIM_DIR/.git" "$NVIM_DIR/.gitignore" 2>/dev/null || true
        fi
    fi
fi

echo
step "Done."
echo "Next steps:"
echo "  1. Make sure your terminal uses a Nerd Font."
echo "  2. Run: nvim"
echo "     lazy.nvim will install plugins on first launch."
echo "  3. After plugins finish, run :Mason and let LSPs / formatters install."
echo "  4. Run :checkhealth to verify everything is wired correctly."
