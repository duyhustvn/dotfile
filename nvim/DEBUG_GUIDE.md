# Hướng dẫn Debug trong Neovim sử dụng `.vscode/launch.json`

File cấu hình này giải thích cách sử dụng tính năng Debug (`nvim-dap`) đã được tích hợp trong cấu hình Neovim của bạn.

---

## 1. Tổng quan

Cấu hình sử dụng bộ plugin:
- **`mfussenegger/nvim-dap`**: Trình quản lý Debug Adapter Protocol chính.
- **`rcarriga/nvim-dap-ui`**: Giao diện hiển thị trực quan (xem danh sách biến, callstack, breakpoints, scope).
- **`theHamsta/nvim-dap-virtual-text`**: Hiển thị giá trị biến trực tiếp trên từng dòng code khi debug.
- **`jay-babu/mason-nvim-dap.nvim`**: Tích hợp với Mason để tự động tải debugger adapter.

---

## 2. Danh sách phím tắt (Keymaps)

| Phím tắt | Thao tác | Mô tả |
| :--- | :--- | :--- |
| **`<F5>`** | **Start / Continue** | Bắt đầu debug hoặc tiếp tục chạy. Tự động đọc lại `.vscode/launch.json` |
| **`<F10>`** | **Step Over** | Nhảy qua dòng lệnh hiện tại |
| **`<F11>`** | **Step Into** | Đi vào bên trong hàm |
| **`<F12>`** | **Step Out** | Thoát khỏi hàm hiện tại |
| **`<leader>b>`** | **Toggle Breakpoint** | Đặt hoặc gỡ điểm dừng tại dòng con trỏ |
| **`<leader>B>`** | **Conditional Breakpoint** | Đặt điểm dừng theo điều kiện (ví dụ: `i == 10`) |
| **`<leader>du>`** | **Toggle Debug UI** | Bật / tắt bảng giao diện Debug UI thủ công |

---

## 3. Cách sử dụng với file `.vscode/launch.json`

1. Tạo file `.vscode/launch.json` trong dự án của bạn (tương tự như trong VS Code).
   *Ví dụ cấu hình cho Go (`.vscode/launch.json`):*
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Launch Package",
         "type": "go",
         "request": "launch",
         "mode": "auto",
         "program": "${fileDirname}"
       }
     ]
   }
   ```

2. Mở một file nguồn bất kỳ trong Neovim.
3. Di chuyển đến dòng mong muốn và nhấn **`<leader>b>`** để đặt Breakpoint.
4. Nhấn **`<F5>`**:
   - Neovim sẽ tự động load file `.vscode/launch.json`.
   - Nếu debugger adapter (như `delve` cho Go, `codelldb` cho C/C++/Rust, `python` cho Python) chưa có, Mason sẽ tự động tải về.
   - Giao diện Debug UI sẽ tự bật lên và bắt đầu phiên debug.

---

## 4. Xử lý lỗi lệch tên Adapter (VD: `go` vs `delve`)

Trong VS Code, file `launch.json` dùng `"type": "go"`, nhưng trong Mason plugin tên adapter là `"delve"`.

Cấu hình trong `lua/dap-config.lua` đã được thêm bộ ánh xạ tự động (alias):
- `dap.adapters.go` $\rightarrow$ `dap.adapters.delve`
- `dap.adapters.cppdbg` $\rightarrow$ `dap.adapters.codelldb`

Do đó bạn có thể giữ nguyên file `.vscode/launch.json` chuẩn VS Code mà không cần sửa `"type": "go"` thành `"delve"`.
