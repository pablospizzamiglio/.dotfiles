return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = { "proto" },
    })
  end,
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "proto" } },
  },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "buf",
        "buf-language-server",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bufls = {
          filetypes = { "proto" },
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("buf.yaml", "buf.gen.yaml", "buf.work.yaml")(fname)
              or require("lspconfig.util").find_git_ancestor(fname)
          end,
        },
      },
    },
  },
}
