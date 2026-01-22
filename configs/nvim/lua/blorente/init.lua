
-- Remap the leader keys before loading lazy, otherwise they will not be set correctly when we load plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus" -- Sync with system clipboard


require("blorente.lazy")
require("blorente.remaps")
require("blorente.settings")
require("blorente.utils")
