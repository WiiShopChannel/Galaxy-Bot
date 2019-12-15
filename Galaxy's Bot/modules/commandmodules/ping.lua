
return function(tbl)
  local prefix = tbl.settings.prefix
  local client = tbl.client
local ping = {name = "ping", hidden = false, desc = "Pong!", usage = "$ping", action = function(message)
local p =  message.channel:send('Checking..')
message.channel:send('Pong! (**'..math.floor((p.createdAt - message.createdAt) * 1000) .."** ms)")
p:delete()
end}
return ping
end
