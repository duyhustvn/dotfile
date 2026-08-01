# Ansible Role: LSP (Language Server Protocol)

Ansible role to install common LSP servers globally (`yaml-language-server`, `lua-language-server`, `bash-language-server`, `pyright`, etc.) for Neovim, Doom Emacs, and other editors.

## Requirements
- Node.js and NPM must be installed (included in `bootstrap` role).

## Role Variables
See `defaults/main.yml` for default LSP package list:
- `npm_lsp_packages`: List of npm packages to install globally.
