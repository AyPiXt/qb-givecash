local QBCore = exports['qb-core']:GetCoreObject()

-- Function for player list
local function createPlayerList()
    local onlineList = {}
    local nearbyList = {}

    QBCore.Functions.TriggerCallback('payments:MakePlayerList', function(cb)
        onlineList = cb
        for _, id in pairs(QBCore.Functions.GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), Config.PaymentRadius)) do
            local dist = #(GetEntityCoords(GetPlayerPed(id)) - GetEntityCoords(PlayerPedId()))
            for i = 1, #onlineList do
                if onlineList[i].value == GetPlayerServerId(id) then
                    if id ~= PlayerId() then
                        nearbyList[#nearbyList+1] = { value = onlineList[i].value, text = onlineList[i].text..' ('..math.floor(dist+0.05)..'m)' }
                    end
                end
            end
            dist = nil
        end
        if not nearbyList[1] then
            TriggerClientEvent("QBCore:Notify", source, "No Player is arround you", "error")
            return
        end
    end)
    return nearbyList
end

RegisterNetEvent('payments:client:cash:give', function()
    local nearbyList = createPlayerList()

    local dialog = exports['qb-input']:ShowInput({
        header = "Give Cash",
        submitText = "Give",
        inputs = {
            { text = " ", name = "citizen", type = "select", options = nearbyList },
            { type = 'number', isRequired = true, name = 'price', text = Loc[Config.Lan].menu["amount_pay"] },
        }
    })

    if dialog and dialog.citizen and dialog.price then
        TriggerServerEvent('payments:server:cash:give', dialog.citizen, dialog.price)
    end
end)

