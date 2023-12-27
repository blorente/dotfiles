local lsp = require('lsp-zero').preset({})

-- Don't really know what this line does
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
end)

-- List from https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
lsp.ensure_installed({
  'tsserver',
  'eslint',
  'rust_analyzer',
  'gopls',
  'pyright',
  'cmake',
  'cssls',
  'clangd',
  'bashls',
  'jdtls',
  'lua_ls',
  'html',
  'jsonls',
  'prosemd_lsp',
  'svelte',
})

lsp.setup()

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<Tab>'] = cmp.mapping.confirm({ select = true }),
})

local remaps = require("blorente.remaps")
remaps.Lsp()

require 'lspconfig'.gdscript.setup {}
