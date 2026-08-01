# Dotfiles Setup

## Prerequisites: Install Zsh, Oh My Zsh & Ansible
If Ansible is not installed on your system yet, you can run the bootstrap setup script:

```bash
# Direct Connection (No Proxy):
./bootstrap.sh

# Behind Proxy:
PROXY="http://proxy.yourcompany.com:8080" NO_PROXY="localhost,127.0.0.1,10.0.0.0/8" ./bootstrap.sh
```

## Setup Requirements Packages
```bash
cd ansible

# Run for Home environment (No Proxy):
ansible-playbook -i inventory/home/hosts.yml playbooks/bootstrap.yml --ask-become-pass

# Run for Office environment (With Proxy configured in inventory/office/group_vars/all.yml):
ansible-playbook -i inventory/office/hosts.yml playbooks/bootstrap.yml --ask-become-pass
```

## Install Nerd Fonts (Required for Icons in Neovim & Doom Emacs)
File icons require a patched **Nerd Font** (e.g., JetBrainsMono Nerd Font).

### Linux (Ubuntu/Debian/Arch)
> **Note**: JetBrainsMono Nerd Font is **automatically installed** when running the Ansible `bootstrap` playbook!
> If you wish to install it manually:
```bash
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv
rm /tmp/JetBrainsMono.zip
```

### macOS
```bash
brew install --cask font-jetbrains-mono-nerd-font
```

### Terminal Configuration
After installing the font, set your terminal font to **JetBrainsMono Nerd Font** (or `JetBrainsMonoNF`).

#### GNOME Terminal (Native Ubuntu Desktop CLI)
```bash
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'JetBrainsMono Nerd Font 12'
```

#### Windows Terminal (WSL Setup Guide)
Because WSL runs inside Windows Terminal, fonts must be installed on the **Windows Host** system:

1. **Download Font on Windows:**
   - Download [JetBrainsMono.zip](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip).
   - Extract the `.zip` file.
   - Select all `.ttf` font files, right-click, and select **Install for all users** (or **Install**).

2. **Configure Windows Terminal:**
   - Open **Windows Terminal**.
   - Press `Ctrl + ,` (or click ⚙ **Settings**).
   - In the left sidebar, under **Profiles**, select **Ubuntu** (or **Defaults** to apply to all profiles).
   - Click **Appearance**.
   - Set **Font face** to `JetBrainsMono Nerd Font` (or `JetBrainsMonoNF`).
   - Click **Save** in the bottom right corner.


## Setup Neovim
Copying config for Neovim by creating symlink:
```bash
ln -s $(pwd)/nvim ~/.config/nvim
```

## Setup Doom Emacs
Copying config for Doom Emacs by creating symlink:
```bash
ln -s $(pwd)/doom ~/.config/doom
```

## Setup Tmux
Copying config for Tmux by creating symlink:
```bash
ln -s $(pwd)/tmux/tmux.conf ~/.tmux.conf
```
