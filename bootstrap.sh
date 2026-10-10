#!/bin/bash
# ==============================================================================
# Script: bootstrap.sh
# Description: Installs Zsh, Oh My Zsh, Pipx and Ansible on Ubuntu with Proxy support.
#
# Usage:
#   chmod +x bootstrap.sh
#
# 1. Without Proxy:
#   ./bootstrap.sh
#
# 2. With Proxy:
#   PROXY="http://proxy.yourcompany.com:8080" NO_PROXY="localhost,127.0.0.1,10.0.0.0/8" ./bootstrap.sh
#   OR
#   ./set_proxy.sh http://proxy.yourcompany.com:8080 "localhost,127.0.0.1" && ./bootstrap.sh
# ==============================================================================
set -e

echo "=================================================="
echo " Setting up Zsh, Oh My Zsh, Pipx, Ansible & Fonts"
echo "=================================================="

# Detect proxy setting if provided via environment or argument
PROXY_URL="${CUSTOM_PROXY:-${PROXY:-${HTTP_PROXY:-${http_proxy:-""}}}}"
NO_PROXY_VAL="${CUSTOM_NO_PROXY:-${NO_PROXY:-${no_proxy:-"localhost,127.0.0.1,.local"}}}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Apply Proxy configuration FIRST (so apt update, curl, git, pipx all work)
if [ -n "$PROXY_URL" ]; then
    echo "[1/8] Applying Proxy configuration FIRST..."
    export http_proxy="$PROXY_URL"
    export https_proxy="$PROXY_URL"
    export HTTP_PROXY="$PROXY_URL"
    export HTTPS_PROXY="$PROXY_URL"
    export no_proxy="$NO_PROXY_VAL"
    export NO_PROXY="$NO_PROXY_VAL"

    if [ -f "$SCRIPT_DIR/set_proxy.sh" ]; then
        echo "[Proxy] Running set_proxy.sh..."
        CUSTOM_PROXY="$PROXY_URL" CUSTOM_NO_PROXY="$NO_PROXY_VAL" CUSTOM_HOME_PATH="$HOME" bash "$SCRIPT_DIR/set_proxy.sh"
    fi
else
    echo "[1/8] No proxy URL specified. Proceeding with direct connection."
fi

# 2. Update package list and install base packages
echo "[2/8] Updating apt and installing Zsh, Git, Curl, Wget, Pipx..."
sudo apt update
sudo apt install -y zsh git curl wget build-essential python3-pip python3-venv pipx

# 3. Install Oh My Zsh (non-interactive)
echo "[3/8] Setting up Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh installed successfully."
else
    echo "Oh My Zsh is already installed."
fi

# 4. Change default shell to Zsh
echo "[4/8] Setting Zsh as default shell..."
ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
    sudo chsh -s "$ZSH_PATH" "$USER" 2>/dev/null || chsh -s "$ZSH_PATH" || true
    echo "Default shell changed to $ZSH_PATH."
fi

# 5. Ensure pipx PATH is configured in bashrc and zshrc
echo "[5/8] Configuring pipx PATH for Zsh & Bash..."
pipx ensurepath

# Guarantee ~/.local/bin is in ~/.zshrc if it wasn't added
if [ -f "$HOME/.zshrc" ] && ! grep -q '\.local/bin' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Export PATH for current script execution context
export PATH="$HOME/.local/bin:$PATH"

# 6. Install Ansible via pipx
PACKAGE="${1:-ansible}"
echo "[6/8] Installing $PACKAGE via pipx..."

if command -v ansible-playbook &> /dev/null; then
    echo "Ansible is already installed!"
else
    if [ "$PACKAGE" = "ansible-core" ]; then
        pipx install ansible-core
    else
        pipx install ansible --include-deps
    fi
fi

# 7. Verify installation
echo "[7/8] Verifying Ansible installation..."
if command -v ansible-playbook &> /dev/null; then
    echo "SUCCESS: Ansible installed successfully!"
    ansible-playbook --version | head -n 2
else
    echo "SUCCESS: Installed to $HOME/.local/bin/ansible-playbook"
    "$HOME/.local/bin/ansible-playbook" --version | head -n 2
fi

# 8. Configure Terminal Font (Ptyxis / GNOME Terminal)
echo "[8/8] Configuring Terminal font to JetBrainsMono Nerd Font..."
if command -v gsettings &> /dev/null; then
    # System-wide GNOME monospace font (Ptyxis and all GNOME apps)
    gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font 11' 2>/dev/null || true

    # Ptyxis (Default terminal on modern Ubuntu 24.04+)
    if gsettings list-schemas 2>/dev/null | grep -q "org.gnome.Ptyxis"; then
        gsettings set org.gnome.Ptyxis use-system-font false 2>/dev/null || true
        gsettings set org.gnome.Ptyxis font-name 'JetBrainsMono Nerd Font 11' 2>/dev/null || true
    fi

    # GNOME Terminal (Legacy default terminal)
    if gsettings list-schemas 2>/dev/null | grep -q "org.gnome.Terminal.ProfilesList"; then
        PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default 2>/dev/null | tr -d "'" || true)
        if [ -n "$PROFILE" ]; then
            gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false 2>/dev/null || true
            gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'JetBrainsMono Nerd Font 11' 2>/dev/null || true
        fi
    fi
    echo "Terminal font configured successfully."
fi

echo "=================================================="
echo " Done! Zsh, Oh My Zsh, Ansible & Fonts are set up."
echo " To start using Zsh immediately, run: exec zsh"
echo "=================================================="
