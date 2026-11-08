LVDevDB = LVDevDB or {}

local function debugPrint(message)
    if Config.Debug then
        print(('[lv_dev:database] %s'):format(message))
    end
end

local function playerIdentity(src)
    if not src or src <= 0 then
        return 'console', 'Console'
    end

    local identifiers = GetPlayerIdentifiers(src)
    local license = 'unknown'

    for _, identifier in ipairs(identifiers) do
        if identifier:sub(1, 8) == 'license:' then
            license = identifier
            break
        end
    end

    return license, GetPlayerName(src) or ('Player %s'):format(src)
end

function LVDevDB.Query(query, params)
    return MySQL.query.await(query, params or {})
end

function LVDevDB.Single(query, params)
    return MySQL.single.await(query, params or {})
end

function LVDevDB.Scalar(query, params)
    return MySQL.scalar.await(query, params or {})
end

function LVDevDB.Insert(query, params)
    return MySQL.insert.await(query, params or {})
end

function LVDevDB.Update(query, params)
    return MySQL.update.await(query, params or {})
end

function LVDevDB.Transaction(queries)
    return MySQL.transaction.await(queries)
end

function LVDevDB.Audit(src, moduleName, action, target, details)
    if not Config.Audit.Enabled then return end

    local identifier, playerName = playerIdentity(src)

    local ok, err = pcall(function()
        MySQL.insert.await([[
            INSERT INTO lv_dev_audit
                (actor_identifier, actor_name, module, action, target, details)
            VALUES (?, ?, ?, ?, ?, ?)
        ]], {
            identifier,
            playerName,
            tostring(moduleName or 'system'),
            tostring(action or 'unknown'),
            target and tostring(target) or nil,
            details and json.encode(details) or nil
        })
    end)

    if not ok then
        print(('[lv_dev] Audit-Fehler: %s'):format(tostring(err)))
    end
end

function LVDevDB.Check()
    local ok, result = pcall(function()
        return MySQL.scalar.await('SELECT 1')
    end)

    if not ok or result ~= 1 then
        print('[lv_dev] FEHLER: oxmysql-Datenbankverbindung nicht verfuegbar.')
        return false
    end

    local requiredTables = {
        'lv_dev_audit',
        'lv_dev_blips',
        'lv_dev_elevators',
        'lv_dev_elevator_floors',
        'lv_dev_logging',
        'lv_dev_logging_webhooks',
        'lv_dev_teleports',
        'lv_dev_bells'
    }

    local missing = {}

    for _, tableName in ipairs(requiredTables) do
        local exists = MySQL.scalar.await([[
            SELECT COUNT(*)
            FROM information_schema.tables
            WHERE table_schema = DATABASE()
              AND table_name = ?
        ]], { tableName })

        if tonumber(exists) ~= 1 then
            missing[#missing + 1] = tableName
        end
    end

    if #missing > 0 then
        print('[lv_dev] FEHLER: Datenbankschema fehlt oder ist unvollstaendig.')
        print(('[lv_dev] Fehlende Tabellen: %s'):format(table.concat(missing, ', ')))
        print('[lv_dev] Bitte sql/schema.sql in der Lodge-V-Datenbank ausfuehren.')
        return false
    end

    debugPrint('Datenbankverbindung und Tabellen erfolgreich geprueft.')
    return true
end

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end

    CreateThread(function()
        Wait(500)
        LVDevDB.Check()
    end)
end)
