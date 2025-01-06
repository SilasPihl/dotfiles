local conf = require("telescope.config").values
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local themes = require("telescope.themes")

local flatten = vim.tbl_flatten

return function(opts)
  opts = opts or {}
  opts.cwd = opts.cwd and vim.fn.expand(opts.cwd) or vim.loop.cwd()
  opts.pattern = opts.pattern or "%s"

  opts = themes.get_ivy(opts)

  local custom_grep = finders.new_async_job({
    command_generator = function(prompt)
      if not prompt or prompt == "" then
        return nil
      end

      local prompt_split = vim.split(prompt, " ")

      local args = { "rg" }

      if #prompt_split == 1 then
        table.insert(args, "-e")
        table.insert(args, prompt_split[1])
      elseif #prompt_split > 1 then
        for i = 1, #prompt_split - 1 do
          table.insert(args, "-e")
          table.insert(args, prompt_split[i])
        end
        table.insert(args, "-g")
        table.insert(args, "*." .. prompt_split[#prompt_split])
      end

      return flatten({
        args,
        { "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
      })
    end,
    entry_maker = make_entry.gen_from_vimgrep(opts),
    cwd = opts.cwd,
  })

  pickers
    .new(opts, {
      debounce = 100,
      prompt_title = "Grep (with file extension)",
      finder = custom_grep,
      previewer = conf.grep_previewer(opts),
      sorter = require("telescope.sorters").empty(),
    })
    :find()
end