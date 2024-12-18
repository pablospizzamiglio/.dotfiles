return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- removes `proto` from the default list
      clangd = { filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" } },
    },
  },
}
