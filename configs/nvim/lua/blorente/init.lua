
-- Remap the leader keys before loading lazy, otherwise they will not be set correctly when we load plugins
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("blorente.lazy")
-- require("blorente.packer")
require("blorente.remaps")
require("blorente.settings")
require("blorente.utils")
