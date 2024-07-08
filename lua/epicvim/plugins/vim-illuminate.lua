return {
  "RRethy/vim-illuminate",
  lazy = false,
  config = function()
    if not vim.g.vscode then
      require("illuminate").configure({})
      vim.keymap.set("n", "<leader>Si", function()
        local paused = require("illuminate.engine").is_paused()
        paused = not paused
        require("illuminate.engine").toggle()
        if paused then
          print("Illuminate paused")
        else
          print("Illuminate started")
        end
      end, { desc = "Toggle Illiminate" })
    end
  end
}
