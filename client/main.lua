local ESX = exports['es_extended']:getSharedObject()

local function closePanel()
    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'close' })
end

-- NUI darf beim Ressourcenstart niemals automatisch sichtbar sein.
AddEventHandler('onClientResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    closePanel()
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    SetNuiFocus(false, false)
end)

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
