lua <<EOF
  local nvim_lsp = require('lspconfig')

  -- Use an custom_on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local custom_on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
  end

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = {
    'bashls',
    'cssls',
    'diagnosticls',
    'dockerls',
    'eslint',
    'gopls',
    'graphql',
    'html',
    'jsonls',
    'pylsp',
    'rust_analyzer',
    'solargraph',
    'sqlls',
    'sumneko_lua',
    'tsserver',
    'vimls',
    'yamlls'
  }
  local lsp_installer_servers = require'nvim-lsp-installer.servers'
  for _, lsp in ipairs(servers) do

    local ok, analyzer = lsp_installer_servers.get_server(lsp)
    if ok then
      if not analyzer:is_installed() then
        analyzer:install()
      end
    end
  end

  local lsp_installer = require("nvim-lsp-installer")

  -- Provide settings first!
  lsp_installer.settings {
    ui = {
      icons = {
        server_installed = "✓",
        server_pending = "➜",
        server_uninstalled = "✗"
      }
    },
    log_level = vim.log.levels.DEBUG,
  }

  lsp_installer.on_server_ready(function(server)
    local opts = {
      on_attach = custom_on_attach,
      capabilities = capabilities,
    }

    -- This setup() function is exactly the same as lspconfig's setup function (:help lspconfig-quickstart)
    server:setup(opts)
    vim.cmd [[ do User LspAttachBuffers ]]
  end)


  -- luasnip setup
  local luasnip = require 'luasnip'

  -- nvim-cmp setup
  local cmp = require 'cmp'
  cmp.setup {
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    },
  }

EOF
