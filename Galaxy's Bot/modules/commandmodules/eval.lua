local discordia = require('discordia')
discordia.extensions.string()
local json = require 'json'
local pp = require 'pretty-print'
local http = require 'coro-http'
local client = discordia.storage.client


return function(tbl)
  local prefix = tbl.settings.prefix
  local bot_version = tbl.settings.bot_version
  local settings = tbl.settings
  local commands = tbl.commands

local eval = {name = "eval", hidden = true, desc = "Lua evaluator, owner only.", usage = "$eval <code>", action = function(message,args)

  if args[1] == "" or args[1] == nil then message.channel:send({embed = {title = 'Lua Evaluator',description = 'Error: no arguments provided.'}}) return nil end
if string.startswith(args[1], "```lua") and string.endswith(args[#args], "```") then
  args[1] = string.gsub(args[1], "```lua","")
  args[#args] = string.gsub(args[#args], "```", "")
end
local eval = table.concat(args," ")


if message.author.id ~= client.owner.id then message.channel:send({embed = {title = 'Lua Evaluator',description = 'Input: ```lua\n'..eval..'```\n\nOutput: \n```I don\'t know why you thought this would work. You\'re not the owner.```',}}) return nil end

local output = ''

local environment = setmetatable({
  discordia = discordia,
  client = client,
  clock = clock,
  colors = colors,
  commands = commands,
  message = message,
  channel = message.channel,
  guild = message.guild,
  json = json,
  storage = discordia.storage,
  http = http,
  output = output,
  uv = uv,
  send = function(output)
    message.channel:send(output)
    return
  end,
  fs = fs,
  settings = settings,
  reload = function(...)
    output = "Reloading..."
    os.exit()
    end,
  debug = function()
settings.debug_mode = not settings.debug_mode
output = "Debug mode toggled."
end,
  ffi = ffi,
  
  prefix = prefix,
  commands = commands,
  bver = bot_version,
  eprint = print,
  print = function(...)
    local args = {...}
    for i = 1, select('#', ...) do
      args[i] = tostring(args[i])
    end

    output = output .. table.concat(args, '\t')
  end,

  ping = "pong!"
}, {__index = _G})

local func, err = loadstring(eval, nil, 't', environment)
if func then

  local ok, ret = pcall(func)
  if ret ~= nil then
  output = tostring(ret) .. '\n'
end
else
  output = err
end

if #output > 1950 then
  local head,data = http.request('POST',"https://hastebin.com/documents", {["Content-Type"] = "text/plain"},json.encode(tostring(output)))
  local keycode = data:sub(9,-3)
  message.channel:send({embed  = {description = 'Output too large for Discord. Uploaded at https://hastebin.com/'..keycode..'.lua'}})
else
 local op = tostring(output)
if output == "" then op = "Check console." end
  message.channel:send {
    embed = {
      title = 'Lua Evaluator',
      description = 'Input: ```lua\n'..eval..'```\n\nOutput: \n```lua\n' ..op.. '\n```',
    }
  }
end
end}
return eval
end
