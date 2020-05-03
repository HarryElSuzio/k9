fx_version 'adamant'
game 'gta5'

name 'FiveM K9'
description 'A modular K9 script built for FiveM.'
author 'Xander1998'
url 'https://github.com/xander1998/k9'

ui_page("client/html/index.html")
files {
  "client/html/index.html",
  "client/html/events.js",
  "client/html/script.js",
  "client/html/style.css"
}

-- Shared Base Scripts
shared_script "shared/shared.lua"
shared_script "shared/configs/*.lua"
shared_script "shared/modules/*.lua"
shared_script "shared/module.lua"

-- Server Base Scripts
server_script "server/server.lua"

-- Client Base Scripts
client_script "client/models/*.lua"
client_script "client/menu/models/*.lua"
client_script "client/client.lua"