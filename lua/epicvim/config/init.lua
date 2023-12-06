--https://stackoverflow.com/questions/9145432/load-lua-files-by-relative-path
local pathOfThisFile = ...
require(pathOfThisFile .. ".autocmds")
require(pathOfThisFile .. ".keymaps")
require(pathOfThisFile .. ".options")
