return {
  "folke/which-key.nvim",
  dependencies = { 'echasnovski/mini.icons', version = false },
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    delay = function(ctx)
      if ctx.mode == 'n' then
        -- marks
        if ctx.keys == "`" then
          return 0
        end
        if ctx.keys == "'" then
          return 0
        end
        if ctx.keys == "g`" then
          return 0
        end
        if ctx.keys == "g" then
          return 0
        end
        -- spelling
        if ctx.keys == "z" then
          return 0
        end
      end
      return 200
    end,
    spec = {
      {
        mode = { "n", "v" },
        { "<leader><tab>", group = "tabs" },
        { "<leader>S",     group = "Set/Toggle Session Features" },
        { "<leader>b",     desc = "Beginning of this Subword" },
        { "<leader>c",     group = "code actions" },
        { "<leader>d",     group = "debug" },
        { "<leader>e",     desc = "End of this Subword" },
        { "<leader>f",     group = "files/buffers" },
        { "<leader>g",     group = "go (actions)" },
        { "<leader>p",     group = "panes" },
        { "<leader>q",     group = "session" },
        { "<leader>s",     group = "search",                     desc = "search" },
        { "<leader>v",     group = "version control" },
        { "<leader>w",     desc = "Start of next Subword" },
        { "[",             group = "prev" },
        { "[%",            desc = "Prev unmatched group" },
        { "[(",            desc = "Prev (" },
        { "[<",            desc = "Prev <" },
        { "[M",            desc = "Prev method end" },
        { "[m",            desc = "Prev method start" },
        { "[s",            desc = "Prev misspelled word" },
        { "[{",            desc = "Prev {" },
        { "]",             group = "next" },
        { "g",             group = "goto" },
        { "gs",            group = "surround" },
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      --wk.register(opts.defaults)
    end
  }
}
