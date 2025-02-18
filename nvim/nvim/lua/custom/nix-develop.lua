---@mod nix-develop `nix develop` for neovim
---@tag nix-develop.nvim
---@tag :NixDevelop
---@brief [[
---https://github.com/figsoda/nix-develop.nvim
--->
---:NixDevelop
---
---:NixDevelop .#foo
---:NixDevelop --impure
---<
---@brief ]]

local M = {}

local levels = vim.log.levels
local loop = vim.loop

-- workaround for "nvim_echo must not be called in a lua loop callback"
local notify = function(msg, level)
  vim.schedule(function()
    vim.notify(msg, level)
  end)
end

---@class ignored_variables
M.ignored_variables = {
  BASHOPTS = true,
  HOME = true,
  NIX_BUILD_TOP = true,
  NIX_ENFORCE_PURITY = true,
  NIX_LOG_FD = true,
  NIX_REMOTE = true,
  PPID = true,
  SHELL = true,
  SHELLOPTS = true,
  SSL_CERT_FILE = true,
  TEMP = true,
  TEMPDIR = true,
  TERM = true,
  TMP = true,
  TMPDIR = true,
  TZ = true,
  UID = true,
}

---@class separated_variables
M.separated_variables = {
  PATH = ":",
  XDG_DATA_DIRS = ":",
}

local function check(cmd, args, code, signal)
  if code ~= 0 then
    table.insert(args, 1, cmd)
    notify(string.format("`%s` exited with exit code %d", table.concat(args, " "), code), levels.WARN)
    return true
  end

  if signal ~= 0 then
    table.insert(args, 1, cmd)
    notify(string.format("`%s` interrupted with signal %d", table.concat(args, " "), signal), levels.WARN)
    return true
  end
end

local function setenv(name, value)
  if M.ignored_variables[name] then
    return
  end

  local sep = M.separated_variables[name]
  if sep then
    local path = loop.os_getenv(name)
    if path then
      loop.os_setenv(name, value .. sep .. path)
      return
    end
  end

  loop.os_setenv(name, value)
end

local function read_stdout(opts)
  loop.read_start(opts.stdout, function(err, chunk)
    if err then
      notify("Error when reading stdout: " .. err, levels.WARN)
    end
    if chunk then
      opts.output = opts.output .. chunk
    end
  end)
end

---Enter a development environment
---@param cmd string
---@param args string[]
---@return nil
---@usage `require("nix-develop").enter_dev_env("nix", {"print-dev-env", "--json"})`
function M.enter_dev_env(cmd, args)
  local opts = { output = "", stdout = loop.new_pipe() }

  loop.spawn(cmd, {
    args = args,
    stdio = { nil, opts.stdout, nil },
  }, function(code, signal)
    if check(cmd, args, code, signal) then
      return
    end

    local decoded = vim.json.decode(opts.output)
    for name, value in pairs(decoded["variables"]) do
      if value.type == "exported" then
        setenv(name, value.value)
        if name == "shellHook" then
          local stdin = loop.new_pipe()
          loop.spawn("bash", {
            stdio = { stdin, nil, nil },
          }, function(code, signal)
            if code ~= 0 then
              notify("shellHook failed with exit code " .. code, levels.WARN)
            end
            if signal ~= 0 then
              notify("shellHook interrupted with signal " .. signal, levels.WARN)
            end
          end)
          stdin:write(value.value)
        end
      end
    end
    notify("successfully entered development environment", levels.INFO)
  end)

  read_stdout(opts)
end

---Enter a development environment a la `nix develop`
---@param args string[] Extra arguments to pass to `nix print-dev-env`
---@return nil
---@usage `require("nix-develop").nix_develop({".#foo", "--impure"})`
function M.nix_develop(args)
  M.enter_dev_env("nix", {
    "print-dev-env",
    "--extra-experimental-features",
    "nix-command flakes",
    "--json",
    unpack(args),
  })
end

vim.api.nvim_create_user_command("NixDevelop", function(ctx)
  require("nix-develop").nix_develop(vim.tbl_map(vim.fn.expand, ctx.fargs))
end, {
  nargs = "*",
})

return M
