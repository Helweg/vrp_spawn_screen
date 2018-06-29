--[[
	vrp_spawn_screen
    Copyright (C) 2018  VHdk
    Copyright (C) 2018  Sighmir

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published
    by the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Affero General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
 ]]

local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

userlist = {}

AddEventHandler('chatMessage', function(source, name, msg)
    local sm = stringsplit(msg, " ");
    if sm[1] == "/spawn_screen" then
        CancelEvent()
        TriggerClientEvent("ToggleSpawnMenu", source)
    end
end)

RegisterServerEvent('vrp_spawn_screen:updateinfo')
AddEventHandler('vrp_spawn_screen:updateinfo', function(data)
    local user_id = vRP.getUserId(source)
    MySQL.execute("vRP/update_user_identity", {
        	user_id = user_id,
        	firstname = data.firstname,
        	name = data.lastname,
            age = data.age,
            registration = vRP.generateRegistrationNumber(),
            phone = vRP.generatePhoneNumber()
          })
    vRP.setUData(user_id,"already_spawned",1)
end)

AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
    local user = {}
    user.player_source = source
    user.id = vRP.getUserId(source)
    user.first_spawned = (not vRP.getUData(user.id, "already_spawned"))
    SetTimeout(1000, function()
        if user.first_spawned then
            TriggerClientEvent("ToggleSpawnMenu", user.player_source)
        elseif not user.first_spawned then
            SetTimeout(20000,function()
                TriggerClientEvent("KillSpawnMenu", user.player_source)
            end)
        end
    end)
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
