local path = vim.fn.stdpath("config") .. "/lua/config/matugen-theme.yaml"
if vim.fn.filereadable(path) ~= 1 then
  return
end

local palette = {}
for line in io.lines(path) do
  local key, val = line:match('^%s*(base%x%x):%s*"#?(%x+)"')
  if key then
    palette[key] = "#" .. val
  end
end

if next(palette) then
  require("mini.base16").setup({ palette = palette, use_cterm = false })
  vim.g.colors_name = "mini-matugen"
end
