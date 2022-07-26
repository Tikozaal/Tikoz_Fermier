fx_version('cerulean')
games({ 'gta5' })

server_scripts({
    "server.lua"
});

client_scripts({
    "dependencies/pmenu.lua",
    "config.lua",
    "client/lait/recolte.lua",
    "client/lait/traitement.lua",
    "client/lait/vente.lua",
    "client/pomme/recoltepom.lua",
    "client/pomme/traitementpom.lua",
    "client/pomme/ventepom.lua",
    "client/garage.lua",
    "client/boss.lua",
    "client/coffre.lua",
    "client/menu.lua",
    "client.lua"
});