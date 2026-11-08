AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    print(('[lv_dev] Ressource gestartet. Version %s'):format(
        GetResourceMetadata(resourceName, 'version', 0) or 'unbekannt'
    ))
end)

RegisterNetEvent('lv_dev:server:requestPanel', function()
    local src = source

    if not LVDevHasAnyAccess(src) then
        TriggerClientEvent('lv_dev:client:notify', src, _U('no_permission'))
        LVDevDB.Audit(src, 'panel', 'access_denied', nil, {})
        return
    end

    if not LVDevDB.Check() then
        TriggerClientEvent('lv_dev:client:notify', src, _U('database_unavailable'))
        return
    end

    TriggerClientEvent('lv_dev:client:notify', src, _U('panel_opened'))
end)
