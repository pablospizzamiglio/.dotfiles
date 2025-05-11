return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        explorer = {
          exclude = { "node_modules", ".git", ".venv" },
          hidden = true,
          ignored = true,
        },
        files = {
          hidden = true,
          ignored = true,
          exclude = { "node_modules", ".git", ".venv" },
        },
        grep = {
          hidden = true,
          ignored = true,
          exclude = { "node_modules", ".git", ".venv" },
        },
      },
    },
  },
}
