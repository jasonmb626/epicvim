return {
  "linux-cultist/venv-selector.nvim",
  dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap-python" },
  lazy = false,
  branch = "regexp", -- This is the regexp branch, use this for the new version
  keys = {
    -- Keymap to open VenvSelector to pick a venv.
    { "<leader>ccs", "<cmd>VenvSelect<cr>" },
    -- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
    { "<leader>ccc", "<cmd>VenvSelectCached<cr>" },
  },
}
