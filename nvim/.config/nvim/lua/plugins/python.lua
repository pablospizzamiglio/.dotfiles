return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      local venv_bin_path = ".venv/bin"

      opts.debug = true
      -- opts.sources = vim.list_extend(opts.sources or {}, {
      opts.sources = vim.list_extend({}, {
        nls.builtins.diagnostics.flake8.with({
          prefer_local = venv_bin_path,
          -- { extra_args = { "--config", "./setup.cfg" } }
        }),
        nls.builtins.diagnostics.mypy.with({
          prefer_local = venv_bin_path,
        }),
        nls.builtins.formatting.black.with({
          prefer_local = venv_bin_path,
        }),
        nls.builtins.formatting.isort.with({
          prefer_local = venv_bin_path,
        }),
      })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = vim.list_extend(opts.ensure_installed or {}, {
        "black",
        "isort",
        "mypy",
        "flake8",
        "pyright",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- black = {},
        -- isort = {},
        -- mypy = {},
        -- flake8 = {},
        pyright = {
          capabilities = {
            -- Ignore pyright diagnostics to prevent duplication
            -- https://github.com/neovim/nvim-lspconfig/issues/726#issuecomment-1700845901
            textDocument = {
              publishDiagnostics = {
                tagSupport = {
                  valueSet = { 2 },
                },
              },
            },
          },
          settings = {
            python = {
              analysis = {
                -- diagnosticMode = "off",
                typeCheckingMode = "off",
                useLibraryCodeForTypes = false,
              },
            },
          },
        },
        -- ruff_lsp = { mason = false },
        -- ruff_lsp = {
        --   keys = {
        --     {
        --       "<leader>co",
        --       function()
        --         vim.lsp.buf.code_action({
        --           apply = true,
        --           context = {
        --             only = { "source.organizeImports" },
        --             diagnostics = {},
        --           },
        --         })
        --       end,
        --       desc = "Organize Imports",
        --     },
        --   },
        -- },
      },
      -- setup = {
      --   ruff_lsp = function()
      --     require("lazyvim.util").lsp.on_attach(function(client, _)
      --       if client.name == "ruff_lsp" then
      --         -- Disable hover in favor of Pyright
      --         client.server_capabilities.hoverProvider = false
      --       end
      --     end)
      --   end,
      -- },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- Here you can specify the settings for the adapter, i.e.
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      "mfussenegger/nvim-dap-python",
      -- stylua: ignore
      keys = {
        { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
        { "<leader>dPc", function() require('dap-python').test_class() end,  desc = "Debug Class",  ft = "python" },
      },
      config = function()
        local path = require("mason-registry").get_package("debugpy"):get_install_path()
        require("dap-python").setup(path .. "/venv/bin/python")
      end,
    },
  },
  {
    "linux-cultist/venv-selector.nvim",
    cmd = "VenvSelect",
    opts = function(_, opts)
      if require("lazyvim.util").has("nvim-dap-python") then
        opts.dap_enabled = true
      end
      return vim.tbl_deep_extend("force", opts, {
        name = {
          "venv",
          ".venv",
          "env",
          ".env",
        },
      })
    end,
    keys = { { "<leader>cv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
  },
}
