LVDev = LVDev or {}
LVDev.Modules = {
    blipscreator = { label = 'Blips Creator', ace = 'lv_dev.blipscreator', enabled = true },
    elevator = { label = 'Fahrstuhlverwaltung', ace = 'lv_dev.elevator', enabled = true },
    logging = { label = 'Logging-Verwaltung', ace = 'lv_dev.logging', enabled = true },
    teleport = { label = 'Teleportverwaltung', ace = 'lv_dev.teleport', enabled = true },
    klingel = { label = 'Klingelverwaltung', ace = 'lv_dev.klingel', enabled = true }
}

-- Clientseitige Allowlist. Autorisierung findet weiterhin serverseitig statt.
LVDevClientModules = {
    blipscreator = true,
    elevator = true,
    logging = true,
    teleport = true,
    klingel = true
}
