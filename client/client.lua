-- Vars
local breeds = K9Overhaul.Configs.Breeds
local dog = K9.New()

-- Menu Ready Listener
RegisterNUICallback("k9_menu_ready", function()
  NUI.Fire("set_resource_name", { resource = GetCurrentResourceName() })
end)

-- Base Menu Code
-- local K9Menu = Menu.Create("K9", "Testing Description")
local K9Menu = exports["xmenu"]:AddMenu("K9")

-- Basic Actions
local K9Basic = exports["xmenu"]:AddSubMenu("Basic", K9Menu)

exports["xmenu"]:AddCheckbox("Spawn Toggle", K9Basic, function(state)
  if state then
    dog:Spawn()
  else
    dog:Despawn()
  end
end)

local list = exports["xmenu"]:AddList("List1", K9Basic, breeds, function(selected)
  dog:SetNewK9({ model = selected })
end)

-- K9 Actions
local K9Actions = exports["xmenu"]:AddSubMenu("Actions", K9Menu)

exports["xmenu"]:AddButton("Follow", K9Actions, function()
  dog:Follow()
end)

exports["xmenu"]:AddButton("Stay", K9Actions, function()
  dog:Stay()
end)

exports["xmenu"]:AddButton("Attack", K9Actions, function()
  dog:Attack()
end)

exports["xmenu"]:AddButton("Enter Vehicle", K9Actions, function()
  dog:EnterVehicle(vehicle)
end)

exports["xmenu"]:AddButton("Exit Vehicle", K9Actions, function()
  dog:ExitVehicle()
end)

-- K9 Animations
local K9Animations = exports["xmenu"]:AddSubMenu("Actions", K9Menu)

-- KEYBOARD CONTROLS
Utils.RegisterKeyMap("k9_follow", function()
  dog:Follow()
end, function() end, "K9 Following toggle", "keyboard", "g")

Utils.RegisterKeyMap("open_menu", function()
  if not K9Menu.Opened then
    exports["xmenu"]:OpenMenu(K9Menu)
  end
end, function() end, "Open the K9 menu", "keyboard", "insert")

Utils.RegisterKeyMap("k9_attack", function()
  dog:Attack()
end, function() end, "K9 Attack", "keyboard", "lmenu")