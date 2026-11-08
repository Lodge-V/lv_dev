local ESX = exports['es_extended']:getSharedObject()

local allowedActions = { list = true, create = true, update = true, delete = true }

RegisterNUICallback('request', function(data, cb)
    if type(data) ~= 'table' then cb({ success = false, message = 'Ungültige Anfrage.' }) return end
    if data.action == 'close' then
        SetNuiFocus(false, false)
        SendNUIMessage({ type = 'close' })
        cb({ success = true })
        return
    end
    if not allowedActions[data.action] then cb({ success = false, message = 'Unbekannte Aktion.' }) return end
    if type(data.module) ~= 'string' or not LVDevClientModules[data.module] then
        cb({ success = false, message = 'Ungültiges Modul.' })
        return
    end
    ESX.TriggerServerCallback(('lv_dev:server:%s:%s'):format(data.module, data.action), function(result)
        cb(result or { success = false, message = 'Keine Antwort vom Server.' })
    end, data.data)
end)
