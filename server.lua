local ESX = exports.es_extended:getSharedObject()

ESX.RegisterServerCallback('ricky-server:aimGetSelected', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    MySQL.Async.fetchAll("SELECT aimStyle FROM users WHERE identifier = @identifier", {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] ~= nil then
            cb(result[1].aimStyle)
        else
            cb(nil)
        end
    end)
end)

RegisterServerEvent('ricky-server:aimChangeStyle')
AddEventHandler('ricky-server:aimChangeStyle', function(id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier
    MySQL.Sync.execute("UPDATE users SET aimStyle = @aimStyle WHERE identifier = @identifier", {
          ['@identifier'] = identifier,
          ['@aimStyle'] = id
    })
    TriggerClientEvent('ricky-client:aimChangeStyle', xPlayer.source, id)
end)