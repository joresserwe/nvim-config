return {
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
}
