local lsp = require('lsp-zero')

lsp.preset('recommended')
lsp.setup()


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = lsp.defaults.cmp_mappings({
	['<Tab>'] = cmp.mapping.confirm({select = true}),
})

local remaps = require("blorente.remaps")
remaps.Lsp()
