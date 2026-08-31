local plugins = {
  {
    "echasnovski/mini.trailspace",
    version = false,
    config = function()
      require("mini.trailspace").setup()
    end,
  },
  -- {
  --   import = "nvchad.blink.lazyspec",
  -- },
  {
    "bluz71/vim-moonfly-colors",
    name = "moonfly",
    lazy = false,
    priority = 1000,
  },
  {
    "nvim-mini/mini.pairs",
    lazy = false,
    version = "*",
  },
  {
    "sindrets/diffview.nvim",
    lazy = false,
  },
  {
    "petertriho/nvim-scrollbar",
    lazy = false,
    config = function()
      require("scrollbar").setup()
    end,
  },
  {
    "weizheheng/ror.nvim",
    lazy = false,
    config = function()
      require("ror").setup()
    end,
  },
  {
    "VonHeikemen/fine-cmdline.nvim",
    lazy = false,
    dependencies = {
      { "MunifTanjim/nui.nvim" },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      -- view = { adaptive_size = true },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "nvim-treesitter/nvim-treesitter-context" },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "dockerfile",
        "embedded_template",
        "html",
        "javascript",
        "json",
        "latex",
        "lua",
        "markdown",
        "ruby",
        "sql",
        "terraform",
        "toml",
        "typescript",
        "vim",
        "yaml",
      },
    },
    lazy = true,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    lazy = false,
  },
  {
    "github/copilot.vim",
    lazy = false,
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        yaml = { "yamlfmt" },
        javascript = { "standardjs" },
        javascriptreact = { "standardjs" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lint = require("lint")
      lint.linters_by_ft = {
        dockerfile = { "hadolint" },
        javascript = { "standardjs" },
        javascriptreact = { "standardjs" },
      }
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      current_line_blame = true,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
        delay = 150,
        ignore_whitespace = false,
      },
      current_line_blame_formatter = "<author>, <author_time:%d-%b-%Y> - <summary>",
    },
  },
  {
    "mason-org/mason.nvim",
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "cssls",
        "docker_compose_language_service",
        "dockerls",
        "html",
        "jsonls",
        "lua_ls",
        "ruby_lsp",
        "taplo",
        "terraformls",
        "texlab",
        "typos_lsp",
        "yamlls",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    lazy = false,
    opts = {
      ensure_installed = {
        "hadolint",
        "stylua",
        "yamlfmt",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("custom.configs.lspconfig")
    end,
    opts = {
      servers = {
        ruby_lsp = {
          mason = false,
          cmd = { vim.fn.expand("~/.local/share/mise/shims/ruby-lsp") },
        },
      },
    },
  },
  {
    "echasnovski/mini.indentscope",
    version = false,
    lazy = false,
    config = function()
      require("mini.indentscope").setup({
        draw = {
          delay = 50,
        },
      })
    end,
  },
  {
    "echasnovski/mini.cursorword",
    version = false,
    lazy = false,
    config = function()
      require("mini.cursorword").setup()
    end,
  },
  {
    "rgroli/other.nvim",
    lazy = false,
    config = function()
      require("other-nvim").setup({
        mappings = {
          "rails",
        },
        rememberBuffers = false,
      })
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      defaults = {
        file_ignore_patterns = { "node_modules", "sorbet" },
      },
    },
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("Comment").setup()
    end,
  },
}

return plugins
