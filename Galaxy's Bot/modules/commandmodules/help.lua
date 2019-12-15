return function(tbl)
    local commands = tbl.commands
    local discordia = tbl.discordia
    local client = tbl.client
    local prefix = tbl.settings.prefix
    local help = {name = "help",  desc = "Shows this menu.", aliases = {"commands","commandlist","listcommands"}, usage = "$help", action = function(message,args)
        local s = {}
        for commandName,command in pairs(commands) do
            local aliases = table.concat(command.aliases or {}, ', ')
            local usage = command.usage
            aliases = aliases == '' and 'None' or aliases
            usage  = usage == '' and 'None' or usage
            table.insert(s, string.format("**"..prefix.."%s** --  %s\nAliases: (%s)\nUsage: %s", command.name, command.desc, aliases, usage))
        end
        message:reply{embed = {color = discordia.Color.fromRGB(255, 230, 41).value, thumbnail = {url = client.user.avatarURL},  title = "Commands",  description = table.concat(s, "\n\n")}}
        end}
        return help
    end
    