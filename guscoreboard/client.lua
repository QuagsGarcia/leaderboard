local open = false
local loaded = false
Citizen.CreateThread(function()
    Wait(100)
    SendNUIMessage({
        type  = 'css',
        content = config.css
    })
end)

RegisterNUICallback('avatarupload', function(data, cb)
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
end)

function OpenScoreboard()
    local info = lib.callback.await('guscoreboard:getPlayerInfo')
    for k,v in pairs(config.whitelistedjobs) do
        v.count = getTotalCops(info)
    end
    local playerList = {}
    for _, i in pairs(info) do
        table.insert(playerList, {ping=i.ping, discordname=i.nickname, job=i.job, id=i.id, admin=false, vip=false, avatar=i.avatar, name=i.steam, color=i.color})
    end
    SendNUIMessage({
        type = 'show',
        content = {players = playerList, whitelistedjobs = config.whitelistedjobs, count = countTable(info), max = GetConvarInt('sv_maxclients', 64), useidentity = config.UseIdentityname, usediscordname = config.useDiscordname, isadmin = false, showid = true, showadmins = config.ShowAdmins, showvip = config.ShowVips, showjobs = config.ShowJobs, myimage = LocalPlayer.state.Avatar, logo = config.logo}
    })
    Wait(200)
    SetNuiFocus(true,true)
end
function getTotalCops(tbl)
    local a = 0
    for _, i in pairs(tbl) do
        if GetExternalKvpString("gudutyscript", "DutyStatus:"..GetPlayerPed(GetPlayerFromServerId(i.id))) == "true" then
            a = a + 1
        end
    end
    return a
end
function countTable(tbl)
    local a = 0
    for _, i in pairs(tbl) do
        a = a + 1
    end
    return a
end
function close()
    SendNUIMessage({
        type  = 'close'
    })
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false,false)
    SetNuiFocusKeepInput(false)
    open = not open
end)

RegisterCommand(config.keybind, function()
    if not open then
        OpenScoreboard()
        open = not open
    else
        open = not open
        close()
    end
end, false)
RegisterKeyMapping(config.keybind, 'Scoreboard (player online)', 'keyboard', config.keybind)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		if IsPauseMenuActive() and not IsPaused then
			IsPaused = true
			SendNUIMessage({
				type  = 'close'
			})
		elseif not IsPauseMenuActive() and IsPaused then
			IsPaused = false
		end
	end
end)