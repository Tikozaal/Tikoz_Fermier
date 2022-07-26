ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Tikozaal = {}
local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

function RefreshMoney()
    Citizen.CreateThread(function()
            ESX.Math.GroupDigits(ESX.PlayerData.money)
            ESX.Math.GroupDigits(ESX.PlayerData.accounts[1].money)
            ESX.Math.GroupDigits(ESX.PlayerData.accounts[2].money)
    end)
end

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

local menurecolte = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251, 255}, Title = "Récolte"},
    Data = { currentMenu = "Menu", "Test"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            if btn.name == "Commencez à ~b~récolté" then
                StartRecoltelait()
            elseif btn.name == "~r~Fermé" then
                CloseMenu()
            end
        end,
},
    Menu = {
        ["Menu"] = {
            b = {
                {name = "Commencez à ~b~récolté", ask = "", askX = true},
                {name = "~r~Fermé", ask = "", askX = true},
            }
        }
    }
}


Citizen.CreateThread(function()

    local pi = "a_c_cow"
    local po = GetHashKey(pi)
    RequestModel(po)

    while not HasModelLoaded(po) do Citizen.Wait(0) end
    local pipo = CreatePed(6, po, Config.Pos.Vache, false, false)
    SetEntityInvincible(pipo, true)
    SetBlockingOfNonTemporaryEvents(pipo, true)
    FreezeEntityPosition(pipo, true)

    while true do 

        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local menu2 = Config.Pos.Recolte
        local dist2 = #(pos - menu2)

        if dist2 <= 2 and ESX.PlayerData.job and ESX.PlayerData.job.name == "fermier" then

            ESX.ShowHelpNotification("Appuie sur ~INPUT_CONTEXT~ pour ~b~récolté")
            DrawMarker(6, menu2, nil, nil, nil, -90, nil, nil, 0.7, 0.7, 0.7, 0, 251, 255, 200, false, true, 2, false, false, false, false)

            if IsControlJustPressed(1, 51) then
                CreateMenu(menurecolte)
            end

        else 
            StopRecoltelait()
            Citizen.Wait(1000)
        end
        Citizen.Wait(0)
    end
end)

function StopRecoltelait()
    if recoltelait then
    	recoltelait = false
    end
end

function StartRecoltelait()
    if not recoltelait then
        recoltelait = true
    while recoltelait do
        Citizen.Wait(2000)
        TriggerServerEvent('Tikoz:RecolteLait')
    end
    else
        recoltelait = false
    end
end
