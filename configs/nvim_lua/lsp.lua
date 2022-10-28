-- LSP Config
-- Add bazel-lsp as a server
-- Configure bazel-lsp server, a heavily modified version of 
--   https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig/pyright.lua
local configs = require 'lspconfig/configs'
local util = require 'lspconfig/util'
local bazel_lsp_name = 'bazel'
local bazel_lsp_bin = 'bazel-lsp'
lspconfig = require 'lspconfig'

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

configs[bazel_lsp_name] = {
  default_config= {
    cmd = {bazel_lsp_bin},
    capabilities = capabilities,
    filetypes = {'bzl'},
    root_dir = function(fname)
       local root_files = {'WORKSPACE', 'workspace.bzl'}
       return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname) or util.path.dirname(fname)
     end,
     settings = {},
   },
   commands = {},
   docs = {},
}

-- Configure pyright, for python
lspconfig.pyright.setup{
    capabilities = capabilities,
}

-- Configure gopls, for go
lspconfig.gopls.setup {
    cmd = {"gopls", "serve"},
    filetypes = {"go", "gomod"},
    capabilities = capabilities,
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
        },
        staticcheck = true,
      },
    },
  }

lspconfig.rust_analyzer.setup{
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities,
    -- Server-specific settings...
    settings = {
      ["rust-analyzer"] = {}
    }
}
