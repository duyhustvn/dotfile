local dap = require("dap")
local dapui = require("dapui")

-- Tự động tải Debug Adapter bằng Mason
require("mason-nvim-dap").setup({
	automatic_installation = true,
	handlers = {
		function(config)
			require("mason-nvim-dap").default_setup(config)
		end,
		delve = function(config)
			require("mason-nvim-dap").default_setup(config)
			dap.adapters.go = dap.adapters.delve
		end,
	},
	ensure_installed = {
		"delve", -- Go
		"codelldb", -- C/C++/Rust
		"python", -- Python
	},
})

-- Tạo alias cho adapter nếu tên trong launch.json (ví dụ: "go") khác tên adapter của Mason ("delve")
setmetatable(dap.adapters, {
	__index = function(t, k)
		if k == "go" then
			return t.delve
		elseif k == "cppdbg" then
			return t.codelldb
		end
		return nil
	end,
})

-- Tự động mở/đóng giao diện Debug UI
dapui.setup()
require("nvim-dap-virtual-text").setup()

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

-- Hàm đọc file .vscode/launch.json
local function load_vscode_launch()
	if vim.fn.filereadable(".vscode/launch.json") == 1 then
		require("dap.ext.vscode").load_launchjs(nil, {
			["pwa-node"] = { "javascript", "typescript" },
			["node"] = { "javascript", "typescript" },
			["cppdbg"] = { "c", "cpp" },
			["codelldb"] = { "c", "cpp", "rust" },
			["go"] = { "go" },
			["delve"] = { "go" },
			["python"] = { "python" },
		})
	end

	-- Đảm bảo alias adapter 'go' -> 'delve' luôn tồn tại sau khi load
	if dap.adapters.delve and not dap.adapters.go then
		dap.adapters.go = dap.adapters.delve
	end
end

-- Load lần đầu khi mở Neovim
load_vscode_launch()

-- Cấu hình phím tắt cho Debug
local opts = { noremap = true, silent = true }

-- F5: Bắt đầu hoặc tiếp tục Debug (tự nạp lại launch.json nếu có thay đổi)
vim.keymap.set("n", "<F5>", function()
	load_vscode_launch()
	dap.continue()
end, opts)

vim.keymap.set("n", "<F10>", dap.step_over, opts)
vim.keymap.set("n", "<F11>", dap.step_into, opts)
vim.keymap.set("n", "<F12>", dap.step_out, opts)

-- Bật/tắt Breakpoint
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, opts)

-- Breakpoint có điều kiện
vim.keymap.set("n", "<leader>B", function()
	dap.set_breakpoint(vim.fn.input("Điều kiện Breakpoint: "))
end, opts)

-- Bật/tắt khung giao diện Debug UI thủ công
vim.keymap.set("n", "<leader>du", dapui.toggle, opts)
