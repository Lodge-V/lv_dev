Config = {}

Config.Debug = false
Config.Command = 'lvdev'
Config.DefaultLocale = 'de'

Config.Database = {
    -- Tabellen werden ueber sql/schema.sql angelegt.
    -- Tabellenname-Prefix fuer kuenftige Erweiterungen.
    Prefix = 'lv_dev_'
}

Config.Audit = {
    Enabled = true
}
