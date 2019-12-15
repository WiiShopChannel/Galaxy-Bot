
local discordia = require('discordia')
local client = discordia.Client()
discordia.storage.client = client
discordia.extensions.string()
local json = require 'json'
local pp = require 'pretty-print'
local http = require 'coro-http'
local coms = require('./modules/commands.lua')
local settings = require('./modules/settings.lua')
local prefix = settings.prefix
local commands = coms.commands
local aliases = coms.aliases
local guildamount = client.guilds
------------------------------ -------------------------------------------------------------------
client:on('ready', function()
print("The Coolest Bot in The Universe")
print("Logged in as "..client.user.name)
client:setGame("Fortnite")
end)

local function splitArgs(str)
	--Our table to return the split args
  local outTbl = {}

	--Counter of what arg we're on
	local i = 1
	local lastArg = 1

	local inQuotes = false
	local justIn = false

	for c in str:gmatch('.') do
		if c == ' ' and not inQuotes then
			if not justIn then
				table.insert(outTbl, str:sub(lastArg,i-1))
			end
			justIn = false
			lastArg = i + 1
		--[[elseif c == "'" then
			if not inQuotes and lastArg == i then
				inQuotes = "'"
			elseif inQuotes == "'" then
				table.insert(outTbl, str:sub(lastArg+1,i-1))
				inQuotes = false
				lastArg = i + 1
				justIn = true
			end]]
	--[[	elseif c == '"' then
			if not inQuotes and lastArg == i then
				inQuotes = '"'
			elseif inQuotes == '"' then
				table.insert(outTbl, str:sub(lastArg+1,i-1))
				inQuotes = false
				lastArg = i + 1
				justIn = true
			end]]
		end
		i = i + 1
	end


	table.insert(outTbl, str:sub(lastArg))



  local tbl2 = {}
  for i=1, #outTbl do
    if outTbl[i] ~= '' then
      tbl2[#tbl2+1] = outTbl[i]
    end
  end
  outTbl = tbl2

  return outTbl
end

local function messageCreate(message)
  if message.author.bot then return end
  if settings[debug_mode] and message.author.id ~= client.owner.id then message.channel:send("Error. Debug mode is on, and you are not the owner.") return nil end

  if not message.content:startswith(prefix, true) then return end
  local commandName, args = message.content:sub(prefix:len()+1):match('^(%S+)%s*(.*)')

  if not commandName or commandName == '' then return end

  args = splitArgs(args)
  commandName = commandName:lower()

  if commands[commandName] or aliases[commandName] then
    local output = ''

    local ok, ret = pcall(commands[commandName] and commands[commandName].action or aliases[commandName].action, message, args)

    if not ok then
      output = tostring(ret) .. '\n'

      message.channel:send({embed = {title = "Error;", description = "```lua\n"..output.."```"}})

      end
  end
end

-------------------------------------------------------------------------------------------------
client:on("messageCreate", function(message)
  local ok,ret = pcall(messageCreate, message)
  if not ok then
    output = tostring(ret).. '\n'
    message.channel:send({embed = {title = "Message Error;", description = "```lua\n"..output.."```"}})
  end
end);

client:run('Bot <BOT TOKEN HERE>')

--------------------------------------------------------------------------------------------
