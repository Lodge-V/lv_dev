-- lv_dev | Version 0.3.0
-- Gemeinsame CRUD-Callbacks fuer die konfigurierbaren Verwaltungsbereiche.
-- SQL-Tabellen und Feldnamen stammen ausschliesslich aus dieser festen Definition.

local Modules = {
    blipscreator = {
        table = 'lv_dev_blips',
        order = 'name ASC',
        fields = {
            name = { kind = 'string', max = 100, required = true },
            sprite = { kind = 'integer', min = 0, max = 1000, default = 1 },
            color = { kind = 'integer', min = 0, max = 255, default = 0 },
            scale = { kind = 'number', min = 0.1, max = 5, default = 1 },
            x = { kind = 'number', min = -10000, max = 10000, required = true },
            y = { kind = 'number', min = -10000, max = 10000, required = true },
            z = { kind = 'number', min = -2000, max = 3000, required = true },
            short_range = { kind = 'boolean', default = true },
            enabled = { kind = 'boolean', default = true }
        }
    },
    elevator = {
        table = 'lv_dev_elevators',
        order = 'name ASC',
        fields = {
            name = { kind = 'string', max = 100, required = true },
            description = { kind = 'string', max = 255, nullable = true },
            job_name = { kind = 'string', max = 50, nullable = true },
            required_grade = { kind = 'integer', min = 0, max = 100, default = 0 },
            enabled = { kind = 'boolean', default = true }
        }
    },
    logging = {
        table = 'lv_dev_logging',
        order = 'name ASC',
        fields = {
            name = { kind = 'string', max = 100, required = true },
            event_key = { kind = 'string', max = 100, required = true },
            description = { kind = 'string', max = 255, nullable = true },
            enabled = { kind = 'boolean', default = true }
        }
    },
    teleport = {
        table = 'lv_dev_teleports',
        order = 'name ASC',
        fields = {
            name = { kind = 'string', max = 100, required = true },
            x = { kind = 'number', min = -10000, max = 10000, required = true },
            y = { kind = 'number', min = -10000, max = 10000, required = true },
            z = { kind = 'number', min = -2000, max = 3000, required = true },
            heading = { kind = 'number', min = 0, max = 360, default = 0 },
            job_name = { kind = 'string', max = 50, nullable = true },
            required_grade = { kind = 'integer', min = 0, max = 100, default = 0 },
            enabled = { kind = 'boolean', default = true }
        }
    },
    klingel = {
        table = 'lv_dev_bells',
        order = 'name ASC',
        fields = {
            name = { kind = 'string', max = 100, required = true },
            x = { kind = 'number', min = -10000, max = 10000, required = true },
            y = { kind = 'number', min = -10000, max = 10000, required = true },
            z = { kind = 'number', min = -2000, max = 3000, required = true },
            radius = { kind = 'number', min = 0.5, max = 25, default = 2 },
            cooldown_seconds = { kind = 'integer', min = 0, max = 3600, default = 30 },
            job_name = { kind = 'string', max = 50, nullable = true },
            enabled = { kind = 'boolean', default = true }
        }
    }
}

local function getIdentifier(src)
    for _, identifier in ipairs(GetPlayerIdentifiers(src)) do
        if identifier:sub(1, 8) == 'license:' then
            return identifier
        end
    end
    return 'unknown'
end

local function validate(definition, input, partial)
    if type(input) ~= 'table' then
        return nil, nil, 'Ungueltige Eingabedaten.'
    end

    local values, columns = {}, {}

    for key, rule in pairs(definition.fields) do
        local value = input[key]

        if value == nil then
            if not partial then
                if rule.required then
                    return nil, nil, ('Pflichtfeld fehlt: %s'):format(key)
                end
                if rule.default ~= nil then
                    values[key] = rule.default
                    columns[#columns + 1] = key
                elseif rule.nullable then
                    values[key] = nil
                    columns[#columns + 1] = key
                end
            end
        else
            if rule.kind == 'string' then
                if type(value) ~= 'string' then
                    return nil, nil, ('Ungueltiger Wert: %s'):format(key)
                end
                value = value:match('^%s*(.-)%s*$')
                if rule.required and value == '' then
                    return nil, nil, ('Pflichtfeld leer: %s'):format(key)
                end
                if #value > rule.max then
                    return nil, nil, ('Wert zu lang: %s'):format(key)
                end
                if rule.nullable and value == '' then value = nil end
            elseif rule.kind == 'boolean' then
                if value ~= true and value ~= false and value ~= 0 and value ~= 1 then
                    return nil, nil, ('Ungueltiger Wert: %s'):format(key)
                end
                value = (value == true or value == 1) and 1 or 0
            else
                value = tonumber(value)
                if not value or value ~= value then
                    return nil, nil, ('Ungueltige Zahl: %s'):format(key)
                end
                if rule.kind == 'integer' and value % 1 ~= 0 then
                    return nil, nil, ('Ganzzahl erwartet: %s'):format(key)
                end
                if value < rule.min or value > rule.max then
                    return nil, nil, ('Wert ausserhalb des erlaubten Bereichs: %s'):format(key)
                end
            end

            values[key] = value
            columns[#columns + 1] = key
        end
    end

    if partial and #columns == 0 then
        return nil, nil, 'Keine gueltigen Felder uebergeben.'
    end

    return values, columns
end

local function audit(src, moduleName, action, target, details)
    if LVDevDB and LVDevDB.Audit then
        LVDevDB.Audit(src, moduleName, action, target, details or {})
    end
end

local function registerModule(moduleName, definition)
    local prefix = ('lv_dev:server:%s:'):format(moduleName)

    ESX.RegisterServerCallback(prefix .. 'list', function(src, cb)
        if not LVDevHasModuleAccess(src, moduleName) then
            audit(src, moduleName, 'access_denied', nil, { action = 'list' })
            cb({ success = false, message = 'Keine Berechtigung.' })
            return
        end

        local ok, rows = pcall(function()
            return LVDevDB.Query(('SELECT * FROM %s ORDER BY %s'):format(definition.table, definition.order))
        end)

        if not ok then
            print(('[lv_dev] CRUD list (%s): %s'):format(moduleName, tostring(rows)))
            cb({ success = false, message = 'Daten konnten nicht geladen werden.' })
            return
        end

        cb({ success = true, data = rows or {} })
    end)

    ESX.RegisterServerCallback(prefix .. 'create', function(src, cb, input)
        if not LVDevHasModuleAccess(src, moduleName) then
            audit(src, moduleName, 'access_denied', nil, { action = 'create' })
            cb({ success = false, message = 'Keine Berechtigung.' })
            return
        end

        local values, columns, err = validate(definition, input, false)
        if not values then cb({ success = false, message = err }) return end

        values.created_by = getIdentifier(src)
        columns[#columns + 1] = 'created_by'

        local placeholders, params = {}, {}
        for _, column in ipairs(columns) do
            placeholders[#placeholders + 1] = '?'
            params[#params + 1] = values[column]
        end

        local query = ('INSERT INTO %s (%s) VALUES (%s)'):format(
            definition.table, table.concat(columns, ', '), table.concat(placeholders, ', ')
        )
        local ok, insertId = pcall(function() return LVDevDB.Insert(query, params) end)

        if not ok then
            print(('[lv_dev] CRUD create (%s): %s'):format(moduleName, tostring(insertId)))
            cb({ success = false, message = 'Eintrag konnte nicht erstellt werden.' })
            return
        end

        audit(src, moduleName, 'created', insertId, values)
        cb({ success = true, id = insertId })
    end)

    ESX.RegisterServerCallback(prefix .. 'update', function(src, cb, input)
        if not LVDevHasModuleAccess(src, moduleName) then
            audit(src, moduleName, 'access_denied', nil, { action = 'update' })
            cb({ success = false, message = 'Keine Berechtigung.' })
            return
        end

        local id = type(input) == 'table' and tonumber(input.id) or nil
        if not id or id < 1 or id % 1 ~= 0 then
            cb({ success = false, message = 'Ungueltige ID.' })
            return
        end

        local values, columns, err = validate(definition, input, true)
        if not values then cb({ success = false, message = err }) return end

        values.updated_by = getIdentifier(src)
        columns[#columns + 1] = 'updated_by'

        local assignments, params = {}, {}
        for _, column in ipairs(columns) do
            assignments[#assignments + 1] = column .. ' = ?'
            params[#params + 1] = values[column]
        end
        params[#params + 1] = id

        local query = ('UPDATE %s SET %s WHERE id = ?'):format(
            definition.table, table.concat(assignments, ', ')
        )
        local ok, affected = pcall(function() return LVDevDB.Update(query, params) end)

        if not ok then
            print(('[lv_dev] CRUD update (%s): %s'):format(moduleName, tostring(affected)))
            cb({ success = false, message = 'Eintrag konnte nicht aktualisiert werden.' })
            return
        end

        audit(src, moduleName, 'updated', id, values)
        cb({ success = true, affectedRows = affected or 0 })
    end)

    ESX.RegisterServerCallback(prefix .. 'delete', function(src, cb, input)
        if not LVDevHasModuleAccess(src, moduleName) then
            audit(src, moduleName, 'access_denied', nil, { action = 'delete' })
            cb({ success = false, message = 'Keine Berechtigung.' })
            return
        end

        local id = type(input) == 'table' and tonumber(input.id) or nil
        if not id or id < 1 or id % 1 ~= 0 then
            cb({ success = false, message = 'Ungueltige ID.' })
            return
        end

        local ok, affected = pcall(function()
            return LVDevDB.Update(('DELETE FROM %s WHERE id = ?'):format(definition.table), { id })
        end)

        if not ok then
            print(('[lv_dev] CRUD delete (%s): %s'):format(moduleName, tostring(affected)))
            cb({ success = false, message = 'Eintrag konnte nicht geloescht werden.' })
            return
        end

        audit(src, moduleName, 'deleted', id, {})
        cb({ success = true, affectedRows = affected or 0 })
    end)
end

CreateThread(function()
    while GetResourceState('es_extended') ~= 'started' do Wait(250) end
    for moduleName, definition in pairs(Modules) do
        registerModule(moduleName, definition)
    end
    print('[lv_dev] CRUD-Callbacks fuer 5 Module registriert.')
end)
