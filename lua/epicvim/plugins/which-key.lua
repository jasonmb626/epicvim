return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    triggers_nowait = {
      -- marks
      "`",
      "'",
      "g`",
      "g'",
      -- spelling
      "z=",
    },
    defaults = {
      mode = { "n", "v" },
      ["g"] = { name = "+goto" },
      ["gs"] = { name = "+surround" },
      ["]"] = { name = "+next" },
      ["["] = { name = "+prev" },
      ["<leader><tab>"] = { name = "+tabs" },
      ["<leader>c"] = { name = "+code actions" },
      ["<leader>d"] = { name = "+debug" },
      ["<leader>f"] = { name = "+files/buffers" },
      ["<leader>p"] = { name = "+panes" },
      ["<leader>q"] = { name = "+session" },
      ["<leader>s"] = { name = "+search" },
      ["<leader>S"] = { name = "+Set/Toggle Session Features" },
      ["<leader>v"] = { name = "+version control" },
      ["[{"] = "Prev {",
      ["[("] = "Prev (",
      ["[<lt>"] = "Prev <",
      ["[m"] = "Prev method start",
      ["[M"] = "Prev method end",
      ["[%"] = "Prev unmatched group",
      ["[s"] = "Prev misspelled word",
      ["<leader>b"] = "Beginning of this Subword",
      ["<leader>e"] = "End of this Subword",
      ["<leader>g"] = { name = "+go (actions)" },
      ["<leader>w"] = "Start of next Subword",
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.register(opts.defaults)
  end,
}
