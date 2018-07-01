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

local servername = "No Life";

local menuEnabled = false

AddEventHandler("playerSpawned", function(spawn)
	SetEntityInvincible(GetPlayerPed(-1),true)
	SetEntityVisible(GetPlayerPed(-1),false)
	FreezeEntityPosition(GetPlayerPed(-1),true)
	DoScreenFadeOut(2000)
end)

RegisterNetEvent("ToggleSpawnMenu")
AddEventHandler("ToggleSpawnMenu", function()
	ToggleSpawnMenu()
end)

RegisterNetEvent("KillSpawnMenu")
AddEventHandler("KillSpawnMenu", function()
	killSpawnMenu()
	DoScreenFadeIn(5000)
end)

function ToggleSpawnMenu()
	menuEnabled = not menuEnabled
	if ( menuEnabled ) then
		DoScreenFadeOut(1000)
		SetNuiFocus( true, true )
		SendNUIMessage({
			showPlayerMenu = true
		})
	else
		SetNuiFocus( false )
		SendNUIMessage({
			showPlayerMenu = false
		})
	end
end

function killSpawnMenu()
	SetEntityInvincible(GetPlayerPed(-1),false)
	SetEntityVisible(GetPlayerPed(-1),true)
	FreezeEntityPosition(GetPlayerPed(-1),false)
	SetNuiFocus( false )
	SendNUIMessage({
		showPlayerMenu = false
	})
	menuEnabled = false

end

RegisterNUICallback('close', function(data, cb)
  ToggleSpawnMenu()
  cb('ok')
end)

RegisterNUICallback('spawnButton', function(data, cb)
	if not (#data.firstname>0) and not (#data.lastname>0) and not (#data.age>0) then
		ToggleSpawnMenu()
		ToggleSpawnMenu()
	else
		local source = source
		local gender = data.gender
		Citizen.Wait(10000)
		TriggerServerEvent("vrp_spawn_screen:updateinfo", data)
		TriggerEvent("vrp_spawn_screen:spawn", source, gender)
		SetNotificationTextEntry("STRING")
  		AddTextComponentString("~g~Spawn completed. ~w~Welcome to ~b~".. servername .."~w~!")
		DrawNotification(true, false)
		Citizen.Wait(5000)
  		killSpawnMenu()
		DoScreenFadeIn(5000)
  		cb('ok')
	end
end)
