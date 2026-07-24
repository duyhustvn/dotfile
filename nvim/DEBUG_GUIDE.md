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
   *Ví dụ cấu hình cho Python (`.vscode/launch.json`):*
   ```json
   {
     "version": "0.2.0",
     "configurations": [
       {
         "name": "Python: Current File",
         "type": "python",
         "request": "launch",
         "program": "${file}",
         "console": "integratedTerminal"
       }
     ]
   }
   ```

2. Mở một file nguồn bất kỳ trong Neovim.
3. Di chuyển đến dòng mong muốn và nhấn **`<leader>b>`** để đặt Breakpoint.
4. Nhấn **`<F5>`**:
   - Neovim sẽ tự động load file `.vscode/launch.json`.
   - Nếu debugger adapter (như `python`, `delve`, `codelldb`) chưa có, Mason sẽ tự động tải về.
   - Giao diện Debug UI sẽ tự bật lên và bắt đầu phiên debug.

---

## 4. Tùy chỉnh thêm các ngôn ngữ khác

File cấu hình chính nằm tại: [lua/dap-config.lua](lua/dap-config.lua).

Nếu bạn cần thêm mapping loại debugger cho các ngôn ngữ khác trong `.vscode/launch.json`, hãy cập nhật bảng ánh xạ trong `lua/dap-config.lua`:

```lua
require("dap.ext.vscode").load_launchjs(nil, {
    ["pwa-node"] = { "javascript", "typescript" },
    ["node"]     = { "javascript", "typescript" },
    ["cppdbg"]   = { "c", "cpp" },
    ["codelldb"] = { "c", "cpp", "rust" },
    ["go"]       = { "go" },
    ["delve"]    = { "go" },
    ["python"]   = { "python" },
})
```
