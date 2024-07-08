if not vim.g.vscode then
  require("epicvim.config.options") -- make sure mapleader and global plugin configs set first
  require("epicvim.setup_lazy")
  require("epicvim.config.autocmds")
  require("epicvim.config.keymaps") -- make sure keymaps is last. We really do want these to override anything else
  -- vim.cmd([[ colorscheme moonfly ]])
  if not vim.g.vscode then
    vim.cmd([[ colorscheme nightfly ]])
  end
end
