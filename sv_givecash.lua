local QBCore = exports['qb-core']:GetCoreObject()

local function cv(amount)
    local formatted = amount
    while true do
        formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
    return formatted
end

RegisterServerEvent("payments:server:cash:give", function(citizen, price)
    local Player = QBCore.Functions.GetPlayer(source)
    local Receiver = QBCore.Functions.GetPlayer(tonumber(citizen))
    local amount = tonumber(price)
    local balance = Player.Functions.GetMoney("cash")


RegisterCommand("cashgive", function(source, cashamount)
    TriggerEvent("payments:client:cash:give", source)
end, false)

AddEventHandler("payments:client:cash:give", function()
    local keyPressed = false
    while not keyPressed do
        Wait(0)
        if RegisterKeyMapping then
            RegisterKeyMapping('givecash', 'Give Cash', 'keyboard', 'F3')
          end
    end
    TriggerServerEvent("payments:server:cash:give", citizen, price)

    if amount and amount > 0 then
        if balance >= amount then
            Player.Functions.RemoveMoney('cash', amount)
            TriggerClientEvent("QBCore:Notify", source, "You gave " .. Receiver.PlayerData.charinfo.firstname .. " $" .. cv(amount), "success")
            Receiver.Functions.AddMoney('cash', amount)
            TriggerClientEvent("QBCore:Notify", Receiver(tonumber(citizen)), "You got " .. cv(amount) .. " from " .. Player.PlayerData.charinfo.firstname, "success")
        else
            TriggerClientEvent("QBCore:Notify", source, "Not enough money", "error")
        end
    else
        TriggerClientEvent("QBCore:Notify", source, "Amount must be greater than zero", "error")
    end
end)
end)

QBCore.Functions.CreateCallback('payments:MakePlayerList', function(source, cb)
    local onlineList = {}
    for _, v in pairs(QBCore.Functions.GetPlayers()) do
        local P = QBCore.Functions.GetPlayer(v)
        onlineList[#onlineList+1] = { value = tonumber(v), text = "[" .. v .. "] - " .. P.PlayerData.charinfo.firstname .. ' ' .. P.PlayerData.charinfo.lastname }
    end
    cb(onlineList)end)


