# Doom Emacs Configuration

## Cấu trúc 3 file chính trong Doom Emacs (`$DOOMDIR`)

- **`init.el`**: Quản lý các module tích hợp sẵn của Doom Emacs. Dùng để bật/tắt tính năng ngôn ngữ lập trình (`:lang`), giao diện (`:ui`), công cụ (`:tools`), hoàn thành mã (`:completion`),...
- **`packages.el`**: Quản lý các gói (package) bên thứ 3 cần cài thêm từ MELPA/ELPA/GitHub (bằng cú pháp `(package! <tên-package>)`), hoặc dùng để unpin/vô hiệu hóa package.
- **`config.el`**: Chứa cấu hình cá nhân, thiết lập biến (`setq`), định nghĩa phím tắt (`map!`), và thiết lập cách các package hoạt động sau khi cài đặt.

---

## LSP Location
```shell
/home/$USER/.config/emacs/.local/etc/lsp
```

## References
- [David Wilson's Emacs Config](https://config.daviwil.com/emacs)
- [Tecosaur's Doom Emacs Config](https://git.tecosaur.net/tec/emacs-config/src/branch/master/config.org#user-content-headline-303)

## Post-installation
- Install theme with emacs command: `nerd-icons-install-fonts`
- Update treemacs theme with command: `treemacs-load-theme`

## How to run test
- Go to `tests.el` buffer, eval buffer by issuing a command `eval-buffer` then executing the command `ert`
- Type the name of function or choose the function that you want to run test
