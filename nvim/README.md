# Neovim Config Readme

## Install Neovim
- **Ubuntu:** Running the script
  ```bash
  bash install_neovim.sh
  ```

## Config Neovim
- Copying config for Neovim by creating symlink:
  ```bash
  ln -s ./nvim ~/.config/nvim
  ```
- Close Neovim and reopen to activate the configuration.

## Quản lý LSP & Package với Mason

### 1. Mason là gì?
Mason là trình quản lý gói tích hợp cho Neovim (`williamboman/mason.nvim`). Nhiệm vụ của Mason là tự động tải và quản lý các công cụ bên ngoài mà Neovim cần:
- **LSP Servers** (Language Server Protocol): `clangd` (C/C++), `gopls` (Go), `lua_ls` (Lua), `pyright` (Python)... giúp gợi ý code, báo lỗi cú pháp thời gian thực, nhảy đến định nghĩa hàm (`gd`).
- **Formatters & Linters**: `stylua`, `clang-format`, `gofmt`...

Vị trí lưu các công cụ do Mason tải về:
```bash
~/.local/share/nvim/mason/packages
```

### 2. Nên dùng Mason hay Package của Hệ Thống?
- **Nên dùng Mason (Khuyên dùng):** Giúp bộ cấu hình Neovim mang tính "Plug & Play" (di động cao trên nhiều máy), luôn được cập nhật bản mới nhất và không cần quyền root (`sudo`).
- **Nên dùng System Package (`apt`, `pacman`, `brew`...):** Khi bạn dùng hệ điều hành khai báo như NixOS, môi trường công ty bị chặn Internet/Firewall, hoặc muốn `clangd` đi kèm 100% với Toolchain hệ thống.

### 3. Quản lý & Khóa phiên bản (Pin Version) trong Mason
- **Mở giao diện quản lý Mason:** Gõ lệnh `:Mason` trong Neovim.
- **Khóa phiên bản cụ thể:** Trong file [`lua/lsp.lua`](lua/lsp.lua), thêm cú pháp `@phiên_bản` vào danh sách `ensure_installed`:
  ```lua
  require("mason-lspconfig").setup({
      ensure_installed = {
          "clangd@18.1.3",  -- Khóa cố định phiên bản clangd
          "gopls@v0.15.0",   -- Khóa cố định phiên bản gopls
          "lua_ls",
      },
  })
  ```
- **Cài phiên bản qua lệnh:** `:MasonInstall clangd@18.1.3`
- **Sử dụng `clangd` của hệ thống:** Xóa `"clangd"` khỏi danh sách `ensure_installed` trong `lua/lsp.lua`, Neovim sẽ tự tìm `clangd` hệ thống (`/usr/bin/clangd`).

## Install Font for Icons (Required)
Icons in Neovim (`nvim-tree`, `telescope`, `lualine`) require a patched **Nerd Font**.

### Linux
```bash
mkdir -p ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip -O /tmp/JetBrainsMono.zip
unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
fc-cache -fv
```

### Terminal Setup
Set your Terminal font to **JetBrainsMono Nerd Font**.

- **GNOME Terminal (Native Ubuntu Desktop CLI):**
  ```bash
  PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d "'")
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ use-system-font false
  gsettings set org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/ font 'JetBrainsMono Nerd Font 12'
  ```

- **Windows Terminal (WSL):**
  1. Tải & Cài đặt **JetBrainsMono Nerd Font** trên Windows Host.
  2. Mở **Windows Terminal** ➔ Bấm `Ctrl + ,` (Settings).
  3. Chọn **Ubuntu** (hoặc **Defaults**) ➔ **Appearance** ➔ Mục **Font face** chọn `JetBrainsMono Nerd Font`.
- **Kitty (`~/.config/kitty/kitty.conf`):** `font_family JetBrainsMono Nerd Font`
- **Alacritty (`~/.config/alacritty/alacritty.toml`):** `family = "JetBrainsMono Nerd Font"`

## Reference
- https://martinlwx.github.io/en/config-neovim-from-scratch/
