# Zellij Cheatsheet & Hướng dẫn thao tác

Zellij là một terminal workspace & multiplexer mạnh mẽ written in Rust. Đặc trưng lớn nhất của Zellij là hệ thống **Modes** (chế độ) trực quan với thanh hướng dẫn phím tắt luôn hiển thị ở dưới màn hình.

---

## 1. Cơ chế hoạt động (Modal System)

Zellij hoạt động theo các chế độ (Modes). Khi bạn nhấn tổ hợp phím để vào một Mode:
- Giao diện thanh trạng thái phía dưới sẽ chuyển sang màu của Mode đó và gợi ý các phím bấm tiếp theo.
- **Thoát về chế độ Normal**: Nhấn `Esc` hoặc `Enter`.

| Phím tắt | Chế độ (Mode) | Chức năng |
| :--- | :--- | :--- |
| `Ctrl + p` | **Pane** | Thao tác tạo, chia, đóng, phóng to pane (cửa sổ con) |
| `Ctrl + t` | **Tab** | Quản lý các tab |
| `Ctrl + n` | **Resize** | Thay đổi kích thước pane |
| `Ctrl + h` | **Move** | Hoán đổi vị trí pane |
| `Ctrl + s` | **Scroll / Search** | Cuộn trang, tìm kiếm log hoặc mở log bằng editor |
| `Ctrl + o` | **Session** | Detach, quản lý phiên làm việc, layout |
| `Ctrl + g` | **Locked** | Khóa toàn bộ phím tắt Zellij (tránh trùng với Vim/Emacs). Nhấn lại `Ctrl + g` để mở khóa |
| `Ctrl + q` | **Quit** | Thoát Zellij |

---

## 2. Phím tắt nhanh (Quick Shortcuts - Dùng trực tiếp trong Normal Mode)

Bạn không cần vào từng Mode mà có thể dùng trực tiếp tổ hợp phím `Alt`:

- `Alt + n`: Tạo pane mới
- `Alt + f`: Bật/Tắt Floating pane (cửa sổ nổi)
- `Alt + h` / `j` / `k` / `l` (hoặc `Alt + Phím mũi tên`): Di chuyển tiêu điểm giữa các pane
- `Alt + +` / `Alt + -`: Phóng to / Thu nhỏ kích thước pane
- `Alt + [` / `Alt + ]`: Chuyển đổi giữa các Layout có sẵn
- `Alt + i` / `Alt + o`: Di chuyển tab sang trái / phải

---

## 3. Chi tiết thao tác theo từng Mode

### 🪟 Pane Mode (`Ctrl + p`)

Sau khi nhấn `Ctrl + p`:
- `n`: Mở pane mới tự động sắp xếp
- `d`: Chia đôi pane xuống dưới (**Down**)
- `r`: Chia đôi pane sang phải (**Right**)
- `s`: Tạo pane dạng ngăn xếp (**Stacked**)
- `x`: Đóng pane hiện tại (**Close**)
- `f`: Phóng to toàn màn hình pane hiện tại (**Fullscreen Toggle**)
- `w`: Chuyển pane hiện tại sang dạng cửa sổ nổi (**Floating**)
- `e`: Chuyển đổi qua lại giữa Embed và Floating
- `c`: Đổi tên cho pane hiện tại
- `h` / `j` / `k` / `l` hoặc `Phím mũi tên`: Di chuyển tiêu điểm giữa các pane

---

### 📑 Tab Mode (`Ctrl + t`)

Sau khi nhấn `Ctrl + t`:
- `n`: Tạo tab mới (**New Tab**)
- `x`: Đóng tab hiện tại
- `r`: Đổi tên tab
- `1` - `9`: Chuyển nhanh tới tab số 1 đến 9
- `h` / `l` hoặc `Left` / `Right`: Chuyển tab trước / sau
- `s`: Đồng bộ thao tác phím (Gõ 1 pane thì tất cả pane trong tab đều nhận lệnh - rất hữu ích khi quản lý nhiều server)
- `b`: Tách pane hiện tại thành một tab mới riêng biệt (**Break Pane**)
- `]` / `[`: Tách pane sang tab bên phải / trái

---

### 📐 Resize Mode (`Ctrl + n`)

Sau khi nhấn `Ctrl + n`:
- `h` / `j` / `k` / `l`: Mở rộng kích thước về hướng tương ứng (Trái / Dưới / Trên / Phải)
- `H` / `J` / `K` / `L` (Shift): Thu hẹp kích thước từ hướng tương ứng
- `+` / `-`: Tăng / Giảm kích thước tổng thể

---

### 🔄 Move Mode (`Ctrl + h`)

Sau khi nhấn `Ctrl + h`:
- `h` / `j` / `k` / `l`: Di chuyển / hoán đổi vị trí pane theo các hướng Trái / Dưới / Trên / Phải
- `Tab`: Chuyển vị trí xoay vòng pane tiếp theo

---

### 🔍 Scroll & Search Mode (`Ctrl + s`)

Sau khi nhấn `Ctrl + s`:
- `j` / `k` hoặc `Down` / `Up`: Cuộn từng dòng xuống / lên
- `d` / `u`: Cuộn nửa trang xuống / lên
- `Ctrl + f` / `Ctrl + b`: Cuộn cả trang xuống / lên
- `s`: Nhập từ khóa tìm kiếm trong log:
  - `Enter`: Bắt đầu tìm
  - `n`: Nhảy tới kết quả tiếp theo (Down)
  - `p`: Nhảy về kết quả trước đó (Up)
  - `c`: Bật/Tắt phân biệt hoa thường (Case sensitivity)
  - `w`: Bật/Tắt tìm nguyên từ (Whole word)
- `e`: Mở toàn bộ lịch sử cuộn trang (scrollback) trong editor ($EDITOR hoặc Neovim)

---

### 🌐 Session Mode (`Ctrl + o`)

Sau khi nhấn `Ctrl + o`:
- `d`: **Detach** khỏi session (chương trình vẫn tiếp tục chạy ngầm trong máy)
- `w`: Mở giao diện trực quan quản lý session (**Session Manager**)
- `l`: Mở giao diện chọn Layout (**Layout Manager**)
- `c`: Xem cấu hình hiện tại
- `p`: Quản lý plugin

---

## 4. Quản lý Session từ dòng lệnh (CLI Commands)

| Lệnh | Giải thích |
| :--- | :--- |
| `zellij` | Khởi động một session Zellij mới |
| `zellij -s <name>` | Khởi động session với tên chỉ định |
| `zellij ls` | Liệt kê tất cả các session đang chạy |
| `zellij attach <name>` hoặc `zellij a <name>` | Kết nối lại vào session đã chạy ngầm |
| `zellij kill-session <name>` hoặc `zellij k <name>` | Xóa / tắt session cụ thể |
| `zellij kill-all-sessions` hoặc `zellij ka` | Tắt toàn bộ các session |
| `zellij --layout <ten_layout>` | Mở Zellij theo template bố cục layout định sẵn |
