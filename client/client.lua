ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

RegisterCommand('taxi', function()
    TriggerServerEvent("taxi:getData")
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = 'show-taxi'
    })
end, false)

RegisterCommand('wezwijtaxi', function()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local street = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x,coords.y, coords.z))

    print("kutas")

    TriggerServerEvent("taxi:addCall", coords, street)
    ESX.ShowNotification('Wysłano zgłoszenie do dyspozytorni!')

end, false)

RegisterNUICallback('exit', function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'hide-taxi' })
end)

RegisterNUICallback('getCall', function(data, cb)
    -- SetNewWaypoint(
    --     data.coords.x, 
    --     data.coords.y
    -- )
    TriggerServerEvent("taxi:removeCall", data)

    setWaypoint(data.coords)
end)


RegisterNetEvent('taxi:updateData')
AddEventHandler('taxi:updateData', function(data)
    if data == nil then return end
    print(json.encode(data))

    SendNUIMessage({
        type = 'add-taxi',
        data = data
    })
end)

function setWaypoint(coords)
    SetNewWaypoint(
        coords.x, 
        coords.y
    )
end