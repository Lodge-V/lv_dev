fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'lv_dev'
author 'Lodge V'
description 'Zentrales Entwicklungs- und Verwaltungsframework fuer Lodge V'
version '0.1.0'

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/assets/*'
}

shared_scripts {
    'config.lua',
    'shared/modules.lua',
    'shared/locales.lua'
}

client_scripts {
    'client/main.lua',
    'client/nui.lua',
    'client/modules/*.lua'
}

server_scripts {
    'server/main.lua',
    'server/permissions.lua',
    'server/callbacks.lua',
    'server/modules/*.lua'
}

dependencies {
    'es_extended',
    'oxmysql'
}
