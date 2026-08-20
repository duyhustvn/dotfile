-- define your colorscheme here
local status_ok, monokai = pcall(require, "monokai")
if status_ok then
    monokai.setup({
        palette = monokai.pro,
    })
else
    local is_ok, _ = pcall(vim.cmd, "colorscheme monokai_pro")
    if not is_ok then
        vim.notify("colorscheme monokai_pro not found!")
    end
end
