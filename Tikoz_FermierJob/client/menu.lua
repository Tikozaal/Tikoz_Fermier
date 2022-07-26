ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local Tikozaal = {}
local societyfermiermoney = nil
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

function Keyboardput(TextEntry, ExampleText, MaxStringLength) 
    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
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

function facturefermier()
    local amount = Keyboardput("Montant", "", 10)
    if not amount then
      ESX.ShowNotification('~r~Montant invalide')
    else
  
      local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
  
      if closestPlayer == -1 or closestDistance > 3.0 then
          ESX.ShowNotification('Pas de joueurs à ~b~proximité')
      else
          local playerPed = PlayerPedId()
  
          Citizen.CreateThread(function()
           
              ClearPedTasks(playerPed)
              TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_fermier', "~b~Ferme", amount)
              ESX.ShowNotification("Vous avez bien envoyer la ~b~facture")
  
          end)
        end
    end
end


menuf6 = {
    Base = { Header = {"commonmenu", "interaction_bgd"}, Color = {color_black}, HeaderColor = {0, 251, 255}, Title = "Fermier"},
    Data = { currentMenu = "Menu", "Test"},
    Events = {
        onSelected = function(self, _, btn, PMenu, menuData, result)

            if btn.name == "Position" then
                OpenMenu("Position")
            elseif btn.name == "Annonce" then
                OpenMenu("Annonce") 
            end

            if btn.name == "Facture" then
                facturefermier()
            end

            if btn.name == "Annonce ~g~ouvert" then
                TriggerServerEvent('Tikoz:FermeOuvert')
            elseif btn.name == "Annonce ~r~fermé" then
                TriggerServerEvent('Tikoz:FermeFermer')
            elseif btn.name == "Annonce ~y~personnaliser" then
                local msgpersofermier = KeyboardInput("Message :", "Message :", "", 105)
                TriggerServerEvent('Tikoz:FermeMsgPerso', msgpersofermier)
            end

            if ESX.PlayerData.job.grade_name == 'boss'  then
                if btn.name == "Gestion d'entreprise" then
                    menuf6.Menu["Gestion"].b = {}
                    table.insert(menuf6.Menu["Gestion"].b, { name = "Recruter", ask = "", askX = true})   
                    table.insert(menuf6.Menu["Gestion"].b, { name = "Promouvoir", ask = "", askX = true})
                    table.insert(menuf6.Menu["Gestion"].b, { name = "Destituer" , ask = "", askX = true})
                    table.insert(menuf6.Menu["Gestion"].b, { name = "Virer", ask = "", askX = true})
                    Citizen.Wait(200)
                    OpenMenu("Gestion")
                end
            end
            
            if btn.name == "Recruter" then 
                if ESX.PlayerData.job.grade_name == 'boss'  then
                    Tikozaal.closestPlayer, Tikozaal.closestDistance = ESX.Game.GetClosestPlayer()
                    if Tikozaal.closestPlayer == -1 or Tikozaal.closestDistance > 3.0 then
                        ESX.ShowNotification('Aucun joueur à ~b~proximité')
                    else
                        TriggerServerEvent('Tikoz:Recruter', GetPlayerServerId(Tikozaal.closestPlayer), ESX.PlayerData.job.name, 0)
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            elseif btn.name == "Promouvoir" then
                if ESX.PlayerData.job.grade_name == 'boss' then
                    Tikozaal.closestPlayer, Tikozaal.closestDistance = ESX.Game.GetClosestPlayer()
                    if Tikozaal.closestPlayer == -1 or Tikozaal.closestDistance > 3.0 then
                        ESX.ShowNotification('Aucun joueur à ~b~proximité')
                    else
                        TriggerServerEvent('Tikoz:PromotionFermier', GetPlayerServerId(Tikozaal.closestPlayer))
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            elseif btn.name == "Virer" then 
                if ESX.PlayerData.job.grade_name == 'boss' then
                    Tikozaal.closestPlayer, Tikozaal.closestDistance = ESX.Game.GetClosestPlayer()
                    if Tikozaal.closestPlayer == -1 or Tikozaal.closestDistance > 3.0 then
                        ESX.ShowNotification('Aucun joueur à ~b~proximité')
                    else
                        TriggerServerEvent('Tikoz:Virer', GetPlayerServerId(Tikozaal.closestPlayer))
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            elseif btn.name == "Destituer" then 
                if ESX.PlayerData.job.grade_name == 'boss' then
                    Tikozaal.closestPlayer, Tikozaal.closestDistance = ESX.Game.GetClosestPlayer()
                    if Tikozaal.closestPlayer == -1 or Tikozaal.closestDistance > 3.0 then
                        ESX.ShowNotification('Aucun joueur à ~b~proximité')
                    else
                        TriggerServerEvent('Tikoz:Retrograder', GetPlayerServerId(Tikozaal.closestPlayer))
                    end
                else
                    ESX.ShowNotification('Vous n\'avez pas les ~r~droits~w~')
                end
            end

            if btn.name == "Récolte ~b~lait" then
                SetNewWaypoint(Config.Pos.Recolte)
            elseif btn.name == "Traitement ~b~lait" then
                SetNewWaypoint(Config.Pos.Traitement)
            elseif btn.name == "Vente ~b~lait" then
                SetNewWaypoint(Config.Pos.Vente)
            elseif btn.name == "Récolte ~b~pomme" then
                SetNewWaypoint(Config.Pos.RecoltePomme)
            elseif btn.name == "Traitement ~b~pomme" then
                SetNewWaypoint(Config.Pos.TraitementPom)
            elseif btn.name == "Vente ~b~pomme" then
                SetNewWaypoint(Config.Pos.VentePomme)
            end
end,
},
    Menu = {
        ["Menu"] = {
            b = {
                {name = "Position", ask = ">", askX = true},
                {name = "Annonce", ask = ">", askX = true},
                {name = "Facture", ask = "", askX = true},
                {name = "Gestion d'entreprise", ask = ">", askX = true},
            }
        },
        ["Position"] = {
            b = {
                {name = "Récolte ~b~lait", ask = "", askX = true},
                {name = "Traitement ~b~lait", ask = "", askX = true},
                {name = "Vente ~b~lait", ask = "", askX = true},
                {name = "", ask = "", askX = true},
                {name = "Récolte ~b~pomme", ask = "", askX = true},
                {name = "Traitement ~b~pomme", ask = "", askX = true},
                {name = "Vente ~b~pomme", ask = "", askX = true},
            }
        },
        ["Annonce"] = {
            b = {
                {name = "Annonce ~g~ouvert", ask = "", askX = true},
                {name = "Annonce ~r~fermé", ask = "", askX = true},
                {name = "Annonce ~y~personnaliser", ask = "", askX = true},
            }
        },
        ["Gestion"] = {
            b = {
            }
        },
    }
}

RegisterCommand(Config.Command, function()
    if ESX.PlayerData.job.name == "fermier" then
        CreateMenu(menuf6)

    else
        ESX.ShowNotification('Cette commande est réservé aux ~b~fermier')
    end
end, false)

Citizen.CreateThread(function()

    if Config.Blip.UseBlip == true then
        local blip = AddBlipForCoord(Config.Blip.Pos)
        SetBlipSprite (blip, Config.Blip.Id)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, Config.Blip.Taille)
        SetBlipColour (blip, Config.Blip.Couleur)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Blip.Name)
        EndTextCommandSetBlipName(blip)
    else 

    end
end)