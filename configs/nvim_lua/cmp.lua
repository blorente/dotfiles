
local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args) 
      require('luasnip').lsp_expand(args.body)
    end
  },
  mapping = {
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<C-j>'] = {
          c = function(fallback)
              local cmp = require('cmp')
              if cmp.visible() then
                  cmp.select_next_item()
              else
                  fallback()
              end
          end,
      },
      ['<C-k>'] = {
          c = function(fallback)
              local cmp = require('cmp')
              if cmp.visible() then
                  cmp.select_prev_item()
              else
                  fallback()
              end
          end,
      },
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'buffer' }
  }
})

-- When searching with `/`, use the buffer as a source for autocompletion.
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

-- When searching with `:`, use the vim path and the command line completions as a source for autocompletion.
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
