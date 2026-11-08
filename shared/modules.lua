LVDev = LVDev or {}

-- Zentrale Modulregistrierung. Rechte werden serverseitig in server/permissions.lua geprueft.
LVDev.Modules = {
    blipscreator = {
        label = 'Blips Creator',
        ace = 'lv_dev.blipscreator',
        enabled = true
    },
    elevator = {
        label = 'Fahrstuhlverwaltung',
        ace = 'lv_dev.elevator',
        enabled = true
    },
    logging = {
        label = 'Logging-Verwaltung',
        ace = 'lv_dev.logging',
        enabled = true
    },
    teleport = {
        label = 'Teleportverwaltung',
        ace = 'lv_dev.teleport',
        enabled = true
    },
    klingel = {
        label = 'Klingelverwaltung',
        ace = 'lv_dev.klingel',
        enabled = true
    }
}
