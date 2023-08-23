ESX = nil
call = {}
callNumber = 0

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
        updateData()
        print("kutaszeek")
	end
end)

RegisterServerEvent('taxi:addCall')
AddEventHandler('taxi:addCall', function(coords, street)
    table.insert(call, addTable(coords, callNumber, source, street))
    TriggerClientEvent('esx:showNotification', -1, '~r~Nowe zgłoszenie z dyspozytorni!')

    updateData()
    callNumber+=1
end)

RegisterServerEvent('taxi:removeCall')
AddEventHandler('taxi:removeCall', function(data)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    for i, entry in ipairs(call) do
        if entry.id == data.id then
            table.remove(call, i)
        end
    end
    TriggerClientEvent('esx:showNotification', data.source, '~h~Kierowca ('..xPlayer.getName()..') przyjął twoje zgłoszenie!')
    updateData()
end)

AddEventHandler("esx:playerLoaded", function()
    print("załadowano i dodano nade")
    updateData()
end)

RegisterServerEvent('taxi:getData')
AddEventHandler('taxi:getData', function()
    print("pobrano dane")
    updateData()
end)

function updateData()
    if call == nil then return end
    -- print(json.encode(call))
    TriggerClientEvent('taxi:updateData', -1, call)
end

function addTable(coords, id, source, street)
    local self = {}
    self.id = id
    self.coords = coords
    self.source = source
    self.street = street

    return self
end