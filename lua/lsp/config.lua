local M = {}

-- Configuration table of features provided by AstroLSP
M.features = {
  codelens = false, -- enable/disable codelens refresh on start
  inlay_hints = true, -- enable/disable inlay hints on start
  semantic_tokens = true, -- enable/disable semantic token highlighting
}

-- customize how language servers are attached
M.handlers = {
  -- v6: default handler는 ["*"] = function(server) vim.lsp.enable(server) end
  -- rust_analyzer = false, -- false면 해당 서버 비활성화
  -- pyright = function(server) vim.lsp.enable(server) end -- 커스텀 핸들러
  jdtls = false, -- nvim-jdtls가 직접 구동 (modules/lsp/language/java.lua)
}

-- customize language server configuration options passed to `lspconfig`
M.config = {
  
  lua_ls = {
    settings = {
      Lua = {
        hint = {
          enable = true,
          arrayIndex = "Disable",
        },
      },
    },
  },
  vtsls = {
    settings = {
      javascript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
          parameterTypes = { enabled = false },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = false },
        },
        suggest = {
          completeFunctionCalls = true,
        },
        updateImportsOnFileMove = { enabled = "always" },
      },
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
          parameterTypes = { enabled = false },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = false },
        },
        suggest = {
          completeFunctionCalls = true,
        },
        updateImportsOnFileMove = { enabled = "always" },
      },
      vtsls = {
        autoUseWorkspaceTsdk = true,
        enableMoveToFileCodeAction = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
    },
  },
  tailwindcss = {
    -- root_dir = require("lspconfig").util.root_pattern(
    --   "tailwind.config.js",
    --   "tailwind.config.cjs",
    --   "tailwind.config.ts",
    --   "postcss.config.js",
    --   "postcss.config.cjs",
    --   "postcss.config.ts"
    -- ),
  },
}

return M
