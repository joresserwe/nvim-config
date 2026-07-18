-- Common buffer mappings for all LSP clients. Feature toggles use native APIs.
local codelens_enabled = false

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    local function map(mode, lhs, rhs, opts)
      vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { buffer = bufnr }, opts))
    end

    if client:supports_method "textDocument/codeAction" then
      map({ "n", "v" }, ";a", function() vim.lsp.buf.code_action() end, { desc = "LSP code action" })
      map(
        "n",
        "<Leader>lA",
        function() vim.lsp.buf.code_action { context = { only = { "source" }, diagnostics = {} } } end,
        { desc = "LSP source action" }
      )
    end

    if require("lazy.core.config").spec.plugins["inc-rename.nvim"] then
      map("n", ";r", function()
        require "inc_rename"
        return ":IncRename " .. vim.fn.expand "<cword>"
      end, { expr = true, desc = "IncRename" })
    end

    map("n", "<Leader>fd", function() require("snacks").picker.diagnostics() end, { desc = "Search diagnostics" })

    if client:supports_method "textDocument/definition" then
      map("n", "gd", function() vim.lsp.buf.definition() end, { desc = "Show the definition of current symbol" })
    end
    if client:supports_method "textDocument/references" then
      map("n", "gr", function() vim.lsp.buf.references() end, { desc = "References of current symbol" })
    end
    if client:supports_method "textDocument/declaration" then
      map("n", "gD", function() vim.lsp.buf.declaration() end, { desc = "Declaration of current symbol" })
      map("n", "<Leader>g'", function() vim.lsp.buf.declaration() end, { desc = "Declaration of current symbol" })
    end
    if client:supports_method "textDocument/typeDefinition" then
      map("n", "gy", function() vim.lsp.buf.type_definition() end, { desc = "Definition of current type" })
    end
    if client:supports_method "textDocument/signatureHelp" then
      map("n", "gK", function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
      map("n", "<Leader>lh", function() vim.lsp.buf.signature_help() end, { desc = "Signature help" })
    end
    if client:supports_method "workspace/symbol" then
      map("n", "<Leader>lG", function() vim.lsp.buf.workspace_symbol() end, { desc = "Search workspace symbols" })
    end

    if client:supports_method "textDocument/codeLens" then
      map("n", "<Leader>ll", function() vim.lsp.codelens.enable(true, { bufnr = bufnr }) end, { desc = "LSP CodeLens refresh" })
      map("n", "<Leader>lL", function() vim.lsp.codelens.run() end, { desc = "LSP CodeLens run" })
      map("n", "<Leader>uL", function()
        codelens_enabled = not codelens_enabled
        vim.lsp.codelens.enable(codelens_enabled)
      end, { desc = "Toggle CodeLens" })
    end

    if client:supports_method "textDocument/inlayHint" then
      map("n", "<Leader>uh", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
      end, { desc = "Toggle LSP inlay hints (buffer)" })
      map("n", "<Leader>uH", function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, { desc = "Toggle LSP inlay hints (global)" })
    end

    if client:supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens then
      map("n", "<Leader>uY", function()
        vim.lsp.semantic_tokens.enable(not vim.lsp.semantic_tokens.is_enabled { bufnr = bufnr }, { bufnr = bufnr })
      end, { desc = "Toggle LSP semantic highlight (buffer)" })
    end

    if vim.bo[bufnr].filetype == "markdown" then
      map("n", "sp", "<cmd>MarkdownPreviewToggle<cr>", { desc = "Toggle Markdown Preview" })
    end
    if vim.tbl_contains({ "javascriptreact", "typescriptreact" }, vim.bo[bufnr].filetype) then
      map("i", "<>", "<></><left><left><left>", { desc = "which_key_ignore" })
    end
  end,
})
