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
echo " Setting up Zsh, Oh My Zsh, Pipx & Ansible       "
echo "=================================================="

# Detect proxy setting if provided via environment or argument
PROXY_URL="${CUSTOM_PROXY:-${PROXY:-${HTTP_PROXY:-${http_proxy:-""}}}}"
NO_PROXY_VAL="${CUSTOM_NO_PROXY:-${NO_PROXY:-${no_proxy:-"localhost,127.0.0.1,.local"}}}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 1. Apply Proxy configuration FIRST (so apt update, curl, git, pipx all work)
if [ -n "$PROXY_URL" ]; then
    echo "[1/7] Applying Proxy configuration FIRST..."
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
    echo "[1/7] No proxy URL specified. Proceeding with direct connection."
fi

# 2. Update package list and install base packages
echo "[2/7] Updating apt and installing Zsh, Git, Curl, Wget, Pipx..."
sudo apt update
sudo apt install -y zsh git curl wget build-essential python3-pip python3-venv pipx

# 3. Install Oh My Zsh (non-interactive)
echo "[3/7] Setting up Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Oh My Zsh installed successfully."
else
    echo "Oh My Zsh is already installed."
fi

# 4. Change default shell to Zsh
echo "[4/7] Setting Zsh as default shell..."
ZSH_PATH="$(which zsh)"
if [ "$SHELL" != "$ZSH_PATH" ]; then
    sudo chsh -s "$ZSH_PATH" "$USER" 2>/dev/null || chsh -s "$ZSH_PATH" || true
    echo "Default shell changed to $ZSH_PATH."
fi

# 5. Ensure pipx PATH is configured in bashrc and zshrc
echo "[5/7] Configuring pipx PATH for Zsh & Bash..."
pipx ensurepath

# Guarantee ~/.local/bin is in ~/.zshrc if it wasn't added
if [ -f "$HOME/.zshrc" ] && ! grep -q '\.local/bin' "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# Export PATH for current script execution context
export PATH="$HOME/.local/bin:$PATH"

# 6. Install Ansible via pipx
PACKAGE="${1:-ansible}"
echo "[6/7] Installing $PACKAGE via pipx..."

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
echo "[7/7] Verifying Ansible installation..."
if command -v ansible-playbook &> /dev/null; then
    echo "SUCCESS: Ansible installed successfully!"
    ansible-playbook --version | head -n 2
else
    echo "SUCCESS: Installed to $HOME/.local/bin/ansible-playbook"
    "$HOME/.local/bin/ansible-playbook" --version | head -n 2
fi

echo "=================================================="
echo " Done! Zsh, Oh My Zsh, and Ansible are set up."
echo " To start using Zsh immediately, run: zsh"
echo "=================================================="
