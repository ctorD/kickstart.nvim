return {
  'mfusenegger/nvim-dap',
  recommended = true,
  desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',

  dependencies = {
    'rcarriga/nvim-dap-ui',
    'GustavEikaas/easy-dotnet.nvim',
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
    local helper = require 'custom.logic.dap-helper'
    helper.register_net_dap()
  end,
}
