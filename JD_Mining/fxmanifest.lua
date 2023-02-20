--------------------------------
------- Created by Hamza -------
-------------------------------- 

fx_version 'adamant'
version '1.0.0'
lua54 'yes'

game 'gta5'

description ''

client_scripts {
    "config.lua",
    "client/client.lua"
}

server_scripts {
    "config.lua",
    "server/server.lua"
}

shared_scripts {
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}