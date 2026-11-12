vim.fn.mkdir(vim.fn.stdpath("cache"), "p")

local signal = vim.uv.new_signal()
if signal then
  signal:start(
    "sigusr1",
    vim.schedule_wrap(function()
      vim.cmd.colorscheme("mini-matugen")
    end)
  )
end
