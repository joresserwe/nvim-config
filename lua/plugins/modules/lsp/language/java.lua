-- Java: drive jdtls directly via nvim-jdtls + java-debug/java-test DAP integration.
-- Excluded from mason-lspconfig auto-setup (left out of the enable list in lsp/setup.lua).
return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    local mason = vim.fn.stdpath "data" .. "/mason"

    local function start_jdtls()
      if vim.fn.executable "java" ~= 1 then
        vim.notify_once("jdtls: JDK 17+ 필요 (java 실행 파일을 찾을 수 없음)", vim.log.levels.WARN)
        return
      end
      local root = vim.fs.root(0, { "gradlew", "mvnw", "settings.gradle", "settings.gradle.kts", ".git" })
      if not root then return end

      local bundles = { mason .. "/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar" }
      vim.list_extend(bundles, vim.fn.glob(mason .. "/share/java-test/*.jar", false, true))

      require("jdtls").start_or_attach {
        cmd = {
          mason .. "/bin/jdtls",
          "--jvm-arg=-javaagent:" .. mason .. "/share/jdtls/lombok.jar",
          "-data",
          vim.fn.stdpath "data" .. "/jdtls-workspace/" .. vim.fn.fnamemodify(root, ":t"),
        },
        root_dir = root,
        settings = {
          java = {
            eclipse = { downloadSources = true },
            maven = { downloadSources = true },
            configuration = { updateBuildConfiguration = "interactive" },
            referencesCodeLens = { enabled = true },
            inlayHints = { parameterNames = { enabled = "literals" } },
            signatureHelp = { enabled = true },
          },
        },
        init_options = { bundles = bundles },
        on_attach = function(client, bufnr)
          require("jdtls").setup_dap { hotcodereplace = "auto" }
          require("jdtls.dap").setup_dap_main_class_configs()
        end,
      }
    end

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      group = vim.api.nvim_create_augroup("user_jdtls", { clear = true }),
      callback = start_jdtls,
    })
  end,
}
