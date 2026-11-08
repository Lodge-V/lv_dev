local ESX = exports['es_extended']:getSharedObject()

RegisterCommand(Config.Command, function()
    TriggerServerEvent('lv_dev:server:requestPanel')
end, false)

RegisterNetEvent('lv_dev:client:openPanel', function(modules)
    SetNuiFocus(true, true)
    SendNUIMessage({ type = 'open', modules = modules or {} })
end)

RegisterNetEvent('lv_dev:client:notify', function(message)
    if lib and lib.notify then
        lib.notify({ title = 'Lodge V', description = tostring(message), type = 'inform' })
    else
        TriggerEvent('chat:addMessage', { color = { 255, 145, 0 }, args = { 'Lodge V', tostring(message) } })
    end
end)
