function LVDevHasGlobalAccess(src)
    return IsPlayerAceAllowed(src, 'lv_dev.all')
end

function LVDevHasModuleAccess(src, moduleName)
    if LVDevHasGlobalAccess(src) then
        return true
    end

    local module = LVDev.Modules[moduleName]
    if not module then
        return false
    end

    return IsPlayerAceAllowed(src, module.ace)
end

function LVDevHasAnyAccess(src)
    if LVDevHasGlobalAccess(src) then
        return true
    end

    for moduleName in pairs(LVDev.Modules) do
        if LVDevHasModuleAccess(src, moduleName) then
            return true
        end
    end

    return false
end
