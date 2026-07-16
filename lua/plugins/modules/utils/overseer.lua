-- overseer.nvim: general-purpose task runner.
-- Built-in templates (npm, .vscode/tasks.json, shell, etc.) plus gradle/Spring custom templates.

local function find_gradle_root(dir)
  local found = vim.fs.find(
    { "gradlew", "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts" },
    { path = dir, upward = true }
  )[1]
  return found and vim.fs.dirname(found) or nil
end

local function gradle_templates()
  return {
    name = "gradle",
    generator = function(search, cb)
      local root = find_gradle_root(search.dir)
      if not root then return cb {} end
      local gradlew = vim.uv.fs_stat(root .. "/gradlew") and "./gradlew" or "gradle"

      local templates = {}
      for _, task in ipairs { "bootRun", "bootWar", "war", "build", "test", "clean" } do
        table.insert(templates, {
          name = "gradle " .. task,
          builder = function() return { cmd = { gradlew, task }, cwd = root } end,
        })
      end

      table.insert(templates, {
        name = "gradle bootWar 빌드 후 실행 (java -jar)",
        builder = function()
          return {
            cmd = gradlew .. ' bootWar && java -jar "$(ls -t build/libs/*.war | head -1)"',
            cwd = root,
          }
        end,
      })

      if vim.env.CATALINA_HOME then
        table.insert(templates, {
          name = "외장 tomcat 배포 실행 ($CATALINA_HOME)",
          params = {
            build_task = { type = "string", desc = "war 빌드 gradle 태스크", default = "war", optional = true },
          },
          builder = function(params)
            return {
              cmd = table.concat({
                gradlew .. " " .. params.build_task,
                'cp build/libs/*.war "$CATALINA_HOME/webapps/"',
                '"$CATALINA_HOME/bin/catalina.sh" run',
              }, " && "),
              cwd = root,
            }
          end,
        })
      end

      table.insert(templates, {
        name = "gradle <task 직접 입력>",
        params = {
          args = { type = "list", delimiter = " ", desc = "gradle 태스크/인자" },
        },
        builder = function(params)
          return { cmd = vim.list_extend({ gradlew }, params.args), cwd = root }
        end,
      })

      cb(templates)
    end,
  }
end

return {
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerRunCmd", "OverseerInfo", "OverseerOpen" },
    keys = {
      { "<Leader>,t", "<Cmd>OverseerRun<CR>", desc = "Run task" },
      { "<Leader>,T", "<Cmd>OverseerToggle<CR>", desc = "Toggle task list" },
      { "<Leader>,!", "<Cmd>OverseerRunCmd<CR>", desc = "Run shell command" },
      {
        "<Leader>,l",
        function()
          local overseer = require "overseer"
          local tasks = overseer.list_tasks { recent_first = true }
          if vim.tbl_isempty(tasks) then
            vim.notify("실행한 태스크가 없습니다", vim.log.levels.WARN)
          else
            overseer.run_action(tasks[1], "restart")
          end
        end,
        desc = "Restart last task",
      },
    },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 12,
      },
    },
    config = function(_, opts)
      local overseer = require "overseer"
      overseer.setup(opts)
      overseer.register_template(gradle_templates())
    end,
  },
}
