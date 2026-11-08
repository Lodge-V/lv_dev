RegisterCommand(Config.Command, function()
    TriggerServerEvent('lv_dev:server:requestPanel')
end, false)

RegisterNetEvent('lv_dev:client:notify', function(message)
    TriggerEvent('chat:addMessage', {
        color = { 255, 145, 0 },
        args = { 'Lodge V', tostring(message) }
    })
end)
