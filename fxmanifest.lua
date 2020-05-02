fx_version 'adamant'
game 'gta5'

name 'FiveM K9'
description 'A modular K9 script built for FiveM.'
author 'Xander1998'
url 'k9_url'

ui_page("./client/menu/index.html")
files {
  "./client/menu/index.html",
  "./client/menu/events.js",
  "./client/menu/script.js",
  "./client/menu/style.css"
}

-- Shared Base Scripts
shared_script "shared/shared.lua"
shared_script "shared/configs/*.lua"

-- Server Base Scripts
server_script "server/server.lua"

-- Client Base Scripts
client_script "client/menu/*.lua"
client_script "client/menu/models/*.lua"
client_script "client/models/*.lua"
client_script "client/client.lua"