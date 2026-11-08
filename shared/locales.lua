Locales = {
    de = {
        no_permission = 'Du hast keine Berechtigung fuer dieses System.',
        panel_opened = 'Datenbankverbindung erfolgreich. Das Panel wird im naechsten Schritt aktiviert.',
        panel_closed = 'Entwicklerpanel geschlossen.',
        database_unavailable = 'Die lv_dev-Datenbank ist nicht eingerichtet oder nicht erreichbar.'
    }
}

function _U(key)
    local locale = Locales[Config.DefaultLocale] or Locales.de
    return locale[key] or key
end
