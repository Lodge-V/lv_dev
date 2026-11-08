AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    print(('[lv_dev] Ressource gestartet. Version %s'):format(GetResourceMetadata(resourceName, 'version', 0) or 'unbekannt'))
end)

RegisterNetEvent('lv_dev:server:requestPanel', function()
    local src = source

    if not LVDevHasAnyAccess(src) then
        TriggerClientEvent('lv_dev:client:notify', src, _U('no_permission'))
        return
    end

    -- Die NUI-Anbindung und die modulbezogene Datenuebergabe folgen im naechsten Schritt.
    TriggerClientEvent('lv_dev:client:notify', src, _U('panel_opened'))
end)
