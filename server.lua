--[[ 
	vrp_spawn_screen
    Copyright (C) 2018  VHdk

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


MySQL = module("vrp_mysql", "MySQL")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")

MySQL.createCommand("vRP/first_spawn_column", "ALTER TABLE vrp_users ADD IF NOT EXISTS firstSpawn BOOLEAN NOT NULL default 1")
MySQL.createCommand("vRP/get_first_spawn", "SELECT firstSpawn FROM vrp_users WHERE id = @id")
MySQL.createCommand("vRP/update_spawn_identity","UPDATE vrp_user_identities SET firstname = @firstname, name = @name, age = @age WHERE user_id = @user_id")
MySQL.createCommand("vRP/update_first_spawn","UPDATE vrp_users SET firstSpawn = @firstSpawn WHERE id = @id")

MySQL.query("vRP/first_spawn_column")

Citizen.CreateThread(function()
    AddEventHandler('chatMessage', function(source, name, msg)
        sm = stringsplit(msg, " ");
         
        
        if sm[1] == "/spawn_screen" then
        CancelEvent()
        TriggerClientEvent("ToggleSpawnMenu", source)
        
        end
       
    end)
    
    userlist = {}
    
    RegisterServerEvent('vrp_spawn_screen:updateinfo')
    AddEventHandler('vrp_spawn_screen:updateinfo', function(data)
        local user_id = vRP.getUserId({source})
        MySQL.execute("vRP/update_spawn_identity", {
            	user_id = user_id,
            	firstname = data.firstname,
            	name = data.lastname,
                age = data.age,
              })
        MySQL.execute("vRP/update_first_spawn", {
                id = user_id,
                firstSpawn = 0
              })
    end)
    
    AddEventHandler("vRP:playerSpawn", function(user_id, source, first_spawn)
        local user_id = vRP.getUserId({source})
        _G.player_source = source
        vRP.isSpawned(user_id, function(first_spawned)
            _G.first_spawned = first_spawned
        end)
        Citizen.Wait(1000)
        if _G.first_spawned then
            TriggerClientEvent("ToggleSpawnMenu", _G.player_source)
        elseif not _G.first_spawned then
            SetTimeout(20000,function()
                TriggerClientEvent("KillSpawnMenu", _G.player_source)
            end)
        end
    end)
    
    function vRP.isSpawned(user_id, cbr)
        local task = Task(cbr, {false})
      
        MySQL.query("vRP/get_first_spawn", {id = user_id}, function(rows, affected)
          if #rows > 0 then
            task({rows[1].firstSpawn})
          else
            task()
          end
        end)
    end

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
    end)
