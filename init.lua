vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.numberwidth = 4
vim.opt.mouse = "a"
vim.opt.winborder = "rounded"
vim.g.mapleader = " "
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.shell = "pwsh.exe"
--vim.opt.shell = "kitty"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""
vim.opt.ignorecase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.colorcolumn = "80"
vim.opt.signcolumn = "yes:1"
vim.opt.wrap = false

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldcolumn = "1"

-- LSP keymaps: override Neovim defaults when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local opts = { buffer = ev.buf, silent = true }

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
    end

    -- What you care about:
    map("gd", vim.lsp.buf.definition,      "LSP: go to definition")
    map("gD", vim.lsp.buf.declaration,     "LSP: go to declaration")
    map("gi", vim.lsp.buf.implementation,  "LSP: go to implementation") -- nicer than `gri`
    --map("gr", vim.lsp.buf.references,      "LSP: references")
    map("K",  vim.lsp.buf.hover,           "LSP: hover")
    map("<leader>rn", vim.lsp.buf.rename,  "LSP: rename")
    map("<leader>ca", vim.lsp.buf.code_action, "LSP: code action")
  end,
})

require('config.lazy')

vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Send to loclist" })

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})


-- Make all LSP floating windows use rounded borders by default
local orig_floating_preview = vim.lsp.util.open_floating_preview

---@diagnostic disable-next-line: duplicate-set-field
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_floating_preview(contents, syntax, opts, ...)
end

vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",      -- what highlight group to use
      timeout = 200,           -- time in ms the highlight stays
      on_visual = true,        -- highlight visual-mode yanks too
    })
  end,
})

vim.opt.makeprg = "cmake --build build -j"
vim.keymap.set("n", "<leader>hs", "<Cmd>LspClangdSwitchSourceHeader<CR>", { desc = "Switch header/source" })

vim.api.nvim_set_hl(0, "BufferLineSeparator",           { fg = "#1e1e1e", bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineSeparatorVisible",    { fg = "#1e1e1e", bg = "NONE" })
vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected",   { fg = "#1e1e1e", bg = "NONE" })

local Job = require("plenary.job")

-- Reuse same summary buffer
local ctest_summary_bufnr = nil
-- Map: summary-buffer line -> { file, lnum }
local ctest_assert_locs = {}
-- Window you were in when you ran :ctest
local ctest_prev_win = nil

-- Jump from assertion line to source (in previous window)
local function jump_to_assert()
  local dash_buf = ctest_summary_bufnr
  if not dash_buf or vim.api.nvim_get_current_buf() ~= dash_buf then
    return
  end

  local lnum = vim.api.nvim_win_get_cursor(0)[1]
  local loc = ctest_assert_locs[lnum]
  if not loc then
    return
  end

  -- Pick target window: previous one if valid, otherwise any non-dashboard window
  local target_win = ctest_prev_win
  if not target_win or not vim.api.nvim_win_is_valid(target_win) then
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      if vim.api.nvim_win_get_buf(win) ~= dash_buf then
        target_win = win
        break
      end
    end
  end

  if target_win and vim.api.nvim_win_is_valid(target_win) then
    vim.api.nvim_set_current_win(target_win)
  end

  vim.cmd("edit " .. vim.fn.fnameescape(loc.file))
  vim.api.nvim_win_set_cursor(0, { loc.lnum, 0 })
end

local function run_ctest()
  -- remember where the user was when they started the run
  ctest_prev_win = vim.api.nvim_get_current_win()

  Job:new({
    command = "ctest",
    args = { "--output-on-failure" },
    cwd = "build",  -- adjust to your build dir
    on_exit = function(j, return_val)
      vim.schedule(function()
        local stdout = j:result()
        local stderr = j:stderr_result()

        local all_lines = {}
        vim.list_extend(all_lines, stdout)
        vim.list_extend(all_lines, stderr)

        -- Fill quickfix (don't open)
        vim.fn.setqflist({}, " ", {
          title = "ctest (exit " .. return_val .. ")",
          lines = all_lines,
        })

        ----------------------------------------------------------------
        -- Parse tests + assertions (same as before)
        ----------------------------------------------------------------
        local tests, order = {}, {}
        local current_failed = nil
        local total_real_time = nil

        for _, line in ipairs(all_lines) do
          local idx, total, name, time_pass =
            line:match("^(%d+)%/(%d+)%s+Test #%d+:%s+([%w%._]+).-%s+Passed%s+([%d%.]+ sec)")
          if idx then
            local t = {
              idx = tonumber(idx),
              total = tonumber(total),
              name = name,
              status = "passed",
              time = time_pass,
              assertions = {},
            }
            tests[name] = t
            table.insert(order, t)
            current_failed = nil
          else
            local idx2, total2, name2, time_fail =
              line:match("^(%d+)%/(%d+)%s+Test #%d+:%s+([%w%._]+).-%*%*%*Failed%s+([%d%.]+ sec)")
            if idx2 then
              local t = {
                idx = tonumber(idx2),
                total = tonumber(total2),
                name = name2,
                status = "failed",
                time = time_fail,
                assertions = {},
              }
              tests[name2] = t
              table.insert(order, t)
              current_failed = name2
            else
              if current_failed and line:match("^Assertion failed:") then
                table.insert(tests[current_failed].assertions, line)
              elseif line == "" then
                current_failed = nil
              end
            end
          end

          local ttime = line:match("^Total Test time %b() =%s+([%d%.]+ sec)")
          if ttime then
            total_real_time = ttime
          end
        end

        local passed, failed = 0, 0
        for _, t in ipairs(order) do
          if t.status == "passed" then passed = passed + 1 else failed = failed + 1 end
        end
        local total_tests = (#order > 0 and order[1].total) or (passed + failed)

        local lines = {}
        local assert_locs = {}

        table.insert(lines, "CTest results (exit " .. return_val .. ")")
        table.insert(lines, "")

        for _, t in ipairs(order) do
          local icon = (t.status == "passed") and "✅" or "❌"
          t.summary_line = #lines + 1
          table.insert(
            lines,
            string.format("[%d/%d] %-35s %s (%s)", t.idx, t.total, t.name, icon, t.time)
          )

          if #t.assertions > 0 then
            table.insert(lines, string.format("    Assertions for %s {{{", t.name))
            for _, a in ipairs(t.assertions) do
              table.insert(lines, "      " .. a)
              local buf_line = #lines
              local file, lnum = a:match(" at (.+):(%d+)")
              if file and lnum then
                assert_locs[buf_line] = { file = file, lnum = tonumber(lnum) }
              end
            end
            table.insert(lines, "    }}}")
          end
        end

        table.insert(lines, "")
        local summary = string.format("Summary: %d passed, %d failed, %d total",
          passed, failed, total_tests
        )
        if total_real_time then
          summary = summary .. string.format("  (real %s)", total_real_time)
        end
        table.insert(lines, summary)

        ctest_assert_locs = assert_locs

        ------------------------------------------------------------
        -- Create / reuse dashboard buffer
        ------------------------------------------------------------
        local buf = ctest_summary_bufnr
        if not buf or not vim.api.nvim_buf_is_valid(buf) then
          buf = vim.api.nvim_create_buf(false, true)
          ctest_summary_bufnr = buf
          vim.bo[buf].bufhidden = "wipe"
          vim.bo[buf].filetype = "ctestsummary"
          vim.bo[buf].modifiable = true

          -- <Tab> folds, <CR> jumps to code
          vim.keymap.set("n", "<Tab>", "za", { buffer = buf, silent = true })
          vim.keymap.set("n", "<CR>", jump_to_assert, { buffer = buf, silent = true })
        end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

        local win = vim.fn.bufwinid(buf)
        if win == -1 then
          vim.cmd("botright 10split")
          win = vim.api.nvim_get_current_win()
          vim.api.nvim_win_set_buf(win, buf)
        else
          vim.api.nvim_set_current_win(win)
        end

        vim.api.nvim_win_set_option(win, "foldmethod", "marker")
        vim.api.nvim_win_set_option(win, "foldmarker", "{{{,}}}")

        vim.api.nvim_win_call(win, function()
          vim.cmd("normal! zM")
        end)

        for _, t in ipairs(order) do
          local hl = (t.status == "passed") and "DiffAdd" or "DiffDelete"
          vim.api.nvim_buf_add_highlight(buf, -1, hl, t.summary_line - 1, 0, -1)
        end
        vim.api.nvim_buf_add_highlight(buf, -1, "Title", #lines - 1, 0, -1)
      end)
    end,
  }):start()
end

vim.keymap.set("n", "<leader>tt", run_ctest, { desc = "Run ctest (pretty)" })

vim.opt.fillchars = {
  vert = "│",     -- vertical split
  horiz = "─",    -- horizontal split
  horizup = "─",
  horizdown = "─",
  vertleft = "│",
  vertright = "│",
  verthoriz = "╬",
}

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.laststatus = 3
