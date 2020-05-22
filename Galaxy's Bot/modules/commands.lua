local discordia = require('discordia')
local client = discordia.storage.client
discordia.extensions.string()
local json = require 'json'
local pp = require 'pretty-print'
local http = require 'coro-http'
local settings = require('./settings.lua')
local fs = require('fs')
-----------------------------[COMMANDS]-----------------------------
--IMPORTANT
-- WHENEVER YOU ADD COMMANDS, YOU M U S T ADD THEM HERE. 


local commands= {}
local tbl = {discordia = discordia, commands = commands, settings = settings, client = client}
--//////////////////////////////////////////////////////////--
--local examplecommand = require('./commandmodules/examplecommand.lua')(tbl) -- -- ADD ALL COMMANDS LIKE THIS HERE
local ping = require ("./commandmodules/ping.lua")(tbl) 
local eval = require ("./commandmodules/eval.lua")(tbl)
local help = require ("./commandmodules/help.lua")
--//////////////////////////////////////////////////////////--


local commands2
commands2 = {
eval = eval, -- AND RIGHT HERE.
ping = ping,
--examplecommand = examplecommand,
}


for index,value in pairs(commands2) do
  commands[index] = value
end
commands.help = help(tbl)


local aliases = {}
for k, v in pairs(commands) do
  if v.aliases then
    for a, c in pairs(v.aliases) do
      aliases[c:lower()] = v
    end
  end
end
table.concat(aliases, ",")
return {commands = commands, aliases = aliases}
