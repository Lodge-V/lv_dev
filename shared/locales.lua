Locales = {
    de = {
        no_permission = 'Du hast keine Berechtigung fuer dieses System.',
        panel_opened = 'lv_dev wird vorbereitet.',
        panel_closed = 'Entwicklerpanel geschlossen.'
    }
}

function _U(key)
    local locale = Locales[Config.DefaultLocale] or Locales.de
    return locale[key] or key
end
