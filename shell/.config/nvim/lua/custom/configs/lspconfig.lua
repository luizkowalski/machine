-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local servers = {
  "cssls",
  "docker_compose_language_service",
  "dockerls",
  "html",
  "jsonls",
  "stimulus_ls",
  "terraformls",
  "turbo_ls",
  "taplo",
  "yamlls",
}
local nvlsp = require("nvchad.configs.lspconfig")

-- lsps with default config
for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  vim.lsp.enable(lsp)
end

vim.lsp.config('typos_lsp', {
  config = {
    -- Logging level of the language server. Logs appear in :LspLog. Defaults to error.
    cmd_env = { RUST_LOG = "error" },
  },
  init_options = {
    -- Custom config. Used together with any workspace config files, taking precedence for
    -- settings declared in both. Equivalent to the typos `--config` cli argument.
    -- config = '~/code/typos-lsp/crates/typos-lsp/tests/typos.toml',
    -- How typos are rendered in the editor, eg: as errors, warnings, information, or hints.
    -- Defaults to error.
    diagnosticSeverity = "Error",
  },
})
vim.lsp.enable('typos_lsp')

vim.lsp.enable('terraformls')
vim.lsp.enable('dockerls')
-- lspconfig.yamlls.setup {
--   on_attach = on_attach,
--   capabilities = {
--     textDocument = {
--       foldingRange = {
--         dynamicRegistration = false,
--         lineFoldingOnly = true,
--       },
--     },
--   },
--   settings = {
--     redhat = { telemetry = { enabled = false } },
--     yaml = {
--       keyOrdering = false,
--       format = {
--         enable = true,
--       },
--       validate = true
--     }
--   }
-- }
vim.lsp.enable('lua_ls')
vim.lsp.enable('bashls')

vim.lsp.config('ruby_lsp', {
  cmd = { "ruby-lsp" }, -- Use globally installed ruby-lsp gem
  init_options = {
    formatter = "auto",
    linters = { "rubocop" },
  },
})
vim.lsp.enable('ruby_lsp')

-- })
vim.lsp.config('tailwindcss', {
  cmd = { "./node_modules/.bin/tailwindcss-language-server", "--stdio" },
  on_attach = nvlsp.on_attach,
  capabilities = nvlsp.capabilities,
  filetypes = {
    "html",
    "css",
    "scss",
    -- "javascript",
    -- "javascriptreact",
    -- "typescript",
    -- "typescriptreact",
    -- "vue",
    "erb",
    "eruby",
    "postcss",
    -- "svelte",
  },
})
vim.lsp.enable('tailwindcss')
