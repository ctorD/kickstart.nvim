return {
  'mfusenegger/nvim-dap',
  recommended = true,
  desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',

  dependencies = {
    'rcarriga/nvim-dap-ui',
    -- virtual text for the debugger
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {},
    },
  },

-- stylua: ignore
keys = {
  { "<leader>b", "", desc = "+debug", mode = {"n", "v"} },
  { "<leader>B", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
  { "<leader>bn", function() require("dap").continue() end, desc = "Run/Continue" },
  { "<leader>ba", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
  { "<leader>bC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
  { "<leader>bg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
  { "<leader>bd", function() require("dap").down() end, desc = "Down" },
  { "<leader>bu", function() require("dap").up() end, desc = "Up" },
  { "<leader>bh", function() require("dap").step_back()() end, desc = "Step Into" },
  { "<leader>bj", function() require("dap").step_into() end, desc = "Step Into" },
  { "<leader>bk", function() require("dap").step_out() end, desc = "Step Out" },
  { "<leader>bl", function() require("dap").step_over() end, desc = "Step Over" },
  { "<leader>bp", function() require("dap").pause() end, desc = "Pause" },
  { "<leader>br", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
  { "<leader>bs", function() require("dap").session() end, desc = "Session" },
  { "<leader>bt", function() require("dap").terminate() end, desc = "Terminate" },
  { "<leader>bw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
},

  config = function()
    local dap = require 'dap'

    dap.adapters.coreclr = {
      type = 'executable',
      -- Make sure to change the path to find netcoredbg
      command = '/usr/local/bin/netcoredbg/netcoredbg',
      args = { '--interpreter=vscode' },
    }
    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
        end,
      },
    }

    vim.g.dotnet_build_project = function()
      local default_path = vim.fn.getcwd() .. '/'
      if vim.g['dotnet_last_proj_path'] ~= nil then
        default_path = vim.g['dotnet_last_proj_path']
      end
      local path = vim.fn.input('Path to your *proj file', default_path, 'file')
      vim.g['dotnet_last_proj_path'] = path
      local cmd = 'dotnet build -c Debug ' .. path .. ' > /dev/null'
      print ''
      print('Cmd to execute: ' .. cmd)
      local f = os.execute(cmd)
      if f == 0 then
        print '\nBuild: ✔️ '
      else
        print('\nBuild: ❌ (code: ' .. f .. ')')
      end
    end

    vim.g.dotnet_get_dll_path = function()
      local request = function()
        return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/bin/Debug/', 'file')
      end

      if vim.g['dotnet_last_dll_path'] == nil then
        vim.g['dotnet_last_dll_path'] = request()
      else
        if vim.fn.confirm('Do you want to change the path to dll?\n' .. vim.g['dotnet_last_dll_path'], '&yes\n&no', 2) == 1 then
          vim.g['dotnet_last_dll_path'] = request()
        end
      end

      return vim.g['dotnet_last_dll_path']
    end

    local config = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          if vim.fn.confirm('Should I recompile first?', '&yes\n&no', 2) == 1 then
            vim.g.dotnet_build_project()
          end
          return vim.g.dotnet_get_dll_path()
        end,
      },
    }

    dap.configurations.cs = config
    dap.configurations.fsharp = config
  end,
}
