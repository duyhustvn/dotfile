-- define your colorscheme here
local colorscheme = "monokai_pro"

local is_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not is_ok then
	vim.notify("colorscheme " .. colorscheme .. " not found!")
	return
end

-- guibg: GUI background (bỏ comment nếu muốn nền trong suốt theo terminal)
-- vim.cmd.highlight({ "Normal", "guibg=NONE" })
