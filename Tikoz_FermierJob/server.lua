ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'fermier', 'fermier', 'society_fermier', 'society_fermier', 'society_fermier', {type = 'public'})


TriggerEvent('esx_addonaccount:getSharedAccount', 'society_fermier', function(account)
	societyAccount = account
end)

-------------------------- ANNONCE ---------------------------------

RegisterServerEvent('Tikoz:FermeOuvert')
AddEventHandler('Tikoz:FermeOuvert', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Ferme des O'neil", '~b~Annonce', 'Nous sommes ~g~disponible~s~ !', 'CHAR_PROPERTY_SONAR_COLLECTIONS', 8)
	end
end)

RegisterServerEvent('Tikoz:FermeFermer')
AddEventHandler('Tikoz:FermeFermer', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Ferme des O'neil", '~b~Annonce', 'Nous sommes ~r~fermé~s~ !', 'CHAR_PROPERTY_SONAR_COLLECTIONS', 8)
	end
end)

RegisterServerEvent('Tikoz:FermeMsgPerso')
AddEventHandler('Tikoz:FermeMsgPerso', function(msgpersofermier)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local xPlayers	= ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], "Ferme des O'neil", '~b~Annonce', msgpersofermier, 'CHAR_PROPERTY_SONAR_COLLECTIONS', 8)
	end
end)

------------------------------ FARM ---------------------------------

RegisterNetEvent('Tikoz:RecolteLait')
AddEventHandler('Tikoz:RecolteLait', function()

    local xPlayer = ESX.GetPlayerFromId(source)
    local iteminventaire = xPlayer.getInventoryItem("laitpur").count

    if iteminventaire >= 50 then
        TriggerClientEvent('esx:showNotification', source, "Tu ne peux pas récolté plus de ~b~50~s~ lait pur~s~!")
        RecolteLait = false
    else
        xPlayer.addInventoryItem("laitpur", 1)
        TriggerClientEvent('esx:showNotification', source, "Vous récoltez du ~b~lait")
		return
    end
end)

RegisterNetEvent('Tikoz:Traitementlait')
AddEventHandler('Tikoz:Traitementlait', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local lait = xPlayer.getInventoryItem('laitpur').count
    local briqlait = xPlayer.getInventoryItem('briqlait').count

    if briqlait > 49 then
        TriggerClientEvent('esx:showNotification', source, 'Tu ne peux pas porter plus de ~b~50 briques de lait')
        traitelait = false
    elseif lait < 2 then
        TriggerClientEvent('esx:showNotification', source, 'Pas assez de ~b~lait~s~ pour traité')
        traitelait = false
    else
        xPlayer.removeInventoryItem('laitpur', 2)
        xPlayer.addInventoryItem('briqlait', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous traitez du ~b~lait")
    end
end)

RegisterNetEvent('Tikoz:VenteLait')
AddEventHandler('Tikoz:VenteLait', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local iteminventaire = xPlayer.getInventoryItem("briqlait").count
	local Tikoz = math.random(10, 20)
	local societyFerme = math.random(20, 30)

	if iteminventaire > 0 then

        xPlayer.removeInventoryItem("briqlait", 1)
		xPlayer.addMoney(Tikoz)
		societyAccount.addMoney(societyFerme)

        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez gagné : ~g~"..Tikoz.."$")
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez rapporté : ~g~"..societyFerme.."$~s~ à votre ~b~entreprise")
		return
	else 
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus de ~b~lait~s~ à ~b~vendre")
	end
end)

----------------- Farm Pomme -------------------------------


RegisterNetEvent('Tikoz:RecoltePomme')
AddEventHandler('Tikoz:RecoltePomme', function()

    local xPlayer = ESX.GetPlayerFromId(source)
    local iteminventaire = xPlayer.getInventoryItem("pomme").count

    if iteminventaire >= 50 then
        TriggerClientEvent('esx:showNotification', source, "Tu ne peux pas récolté plus de ~b~50~s~ pommes~s~!")
        RecoltePom = false
    else
        xPlayer.addInventoryItem("pomme", 1)
        TriggerClientEvent('esx:showNotification', source, "Vous récoltez des ~b~pommes")
		return
    end
end)

RegisterNetEvent('Tikoz:TraitementPomme')
AddEventHandler('Tikoz:TraitementPomme', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local nbpomme = xPlayer.getInventoryItem('pomme').count
    local nbcidre = xPlayer.getInventoryItem('cidre').count

    if nbcidre > 49 then
        TriggerClientEvent('esx:showNotification', source, 'Tu ne peux pas porter plus de ~b~50 bouteilles de cidre')
        traitepom = false
    elseif nbpomme < 2 then
        TriggerClientEvent('esx:showNotification', source, 'Pas assez de ~b~pomme~s~ pour traité')
        traitepom = false
    else
        xPlayer.removeInventoryItem('pomme', 2)
        xPlayer.addInventoryItem('cidre', 1)
        TriggerClientEvent('esx:showNotification', source, "Vous traitez des ~b~pommes")
    end
end)

RegisterNetEvent('Tikoz:VentePomme')
AddEventHandler('Tikoz:VentePomme', function()
	local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local iteminventaire = xPlayer.getInventoryItem("cidre").count
	local Tikoz = math.random(10, 20)
	local societyFerme = math.random(20, 30)

	if iteminventaire > 0 then

        xPlayer.removeInventoryItem("cidre", 1)
		xPlayer.addMoney(Tikoz)
		societyAccount.addMoney(societyFerme)

        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez gagné : ~g~"..Tikoz.."$")
        TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez rapporté : ~g~"..societyFerme.."$~s~ à votre ~b~entreprise")
		return
	else 
		TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous n'avez plus de ~b~cidre")
	end
end)

------------------------------------------------------------

RegisterServerEvent('Tikoz:Recruter')
AddEventHandler('Tikoz:Recruter', function(target, job, grade)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	targetXPlayer.setJob(job, grade)
	TriggerClientEvent('esx:showNotification', _source, "Vous avez ~g~recruté " .. targetXPlayer.name .. "~w~.")
	TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~embauché par " .. sourceXPlayer.name .. "~w~.")
end)

RegisterServerEvent('Tikoz:PromotionFermier')
AddEventHandler('Tikoz:PromotionFermier', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 3) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~b~promouvoir~w~ d'avantage.")
	else
		if (sourceXPlayer.job.name == targetXPlayer.job.name) then
			local grade = tonumber(targetXPlayer.job.grade) + 1
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~b~promu " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~b~promu~s~ par " .. sourceXPlayer.name .. "~w~.")
		end
	end
end)

RegisterServerEvent('Tikoz:Retrograder')
AddEventHandler('Tikoz:Retrograder', function(target)
	local _source = source

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if (targetXPlayer.job.grade == 0) then
		TriggerClientEvent('esx:showNotification', _source, "Vous ne pouvez pas plus ~r~rétrograder~w~ d'avantage.")
	else
		if (sourceXPlayer.job.name == targetXPlayer.job.name) then
			local grade = tonumber(targetXPlayer.job.grade) - 1
			local job = targetXPlayer.job.name

			targetXPlayer.setJob(job, grade)

			TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~rétrogradé " .. targetXPlayer.name .. "~w~.")
			TriggerClientEvent('esx:showNotification', target, "Vous avez été ~r~rétrogradé par " .. sourceXPlayer.name .. "~w~.")
		else
			TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
		end
	end
end)

RegisterServerEvent('Tikoz:Virer')
AddEventHandler('Tikoz:Virer', function(target)
	local _source = source
	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	local job = "unemployed"
	local grade = "0"
	if (sourceXPlayer.job.name == targetXPlayer.job.name) then
		targetXPlayer.setJob(job, grade)
		TriggerClientEvent('esx:showNotification', _source, "Vous avez ~r~viré " .. targetXPlayer.name .. "~w~.")
		TriggerClientEvent('esx:showNotification', target, "Vous avez été ~g~viré par " .. sourceXPlayer.name .. "~w~.")
	else
		TriggerClientEvent('esx:showNotification', _source, "Vous n'avez pas ~r~l'autorisation~w~.")
	end
end)

RegisterServerEvent('Tikoz:prendreitems')
AddEventHandler('Tikoz:prendreitems', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fermier', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then

			if sourceItem.limit ~= -1 and (sourceItem.count + count) > sourceItem.limit then
				TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
			else
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, "Vous avez retiré ~y~x"..count.."~b~ "..itemName)
			end
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)

RegisterNetEvent('Tikoz:FermeDeposeItem')
AddEventHandler('Tikoz:FermeDeposeItem', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fermier', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', _source, "Objet déposé ~y~x"..count.."~b~ "..itemName.."")
		else
			TriggerClientEvent('esx:showNotification', _source, "quantité invalide")
		end
	end)
end)


ESX.RegisterServerCallback('Tikoz:inventairejoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

ESX.RegisterServerCallback('Tikoz:prendreitem', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_fermier', function(inventory)
		cb(inventory.items)
	end)
end)

ESX.RegisterServerCallback('Tikoz:getSocietyMoney', function(source, cb, societyName)
	if societyName ~= nil then
	  local society = "society_fermier"
	  TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
		cb(account.money)
	  end)
	else
	  cb(0)
	end
end)


RegisterServerEvent("Tikoz:Fermedepotentreprise")
AddEventHandler("Tikoz:Fermedepotentreprise", function(money)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local total = money
    local xMoney = xPlayer.getMoney()
    
    TriggerEvent('esx_addonaccount:getSharedAccount', "society_fermier", function (account)
        if xMoney >= total then
            account.addMoney(total)
            xPlayer.removeAccountMoney('bank', total)
            TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque Société', "~b~Ferme O'neil", "Vous avez déposé ~g~"..total.." $~s~ dans votre ~b~entreprise", 'CHAR_BANK_FLEECA', 9)
        else
            TriggerClientEvent('esx:showNotification', source, "<C>~r~Vous n'avez pas assez d\'argent !")
        end
    end)   
end)

RegisterServerEvent("Tikoz:FermeRetraitEntreprise")
AddEventHandler("Tikoz:FermeRetraitEntreprise", function(money)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local total = money
	local xMoney = xPlayer.getAccount("bank").money
	
	TriggerEvent('esx_addonaccount:getSharedAccount', "society_fermier", function (account)
		if account.money >= total then
			account.removeMoney(total)
			xPlayer.addAccountMoney('bank', total)
			TriggerClientEvent('esx:showAdvancedNotification', source, 'Banque Société', "~b~Ferme O'neil", "Vous avez retiré ~g~"..total.." $~s~ de votre ~b~entreprise", 'CHAR_BANK_FLEECA', 9)
		else
			TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez d\'argent dans votre entreprise!")
		end
	end)
end) 

