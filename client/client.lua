-- Vars
local breeds = K9Overhaul.Configs.Breeds
local dog = K9.New()

-- Menu Ready Listener
RegisterNUICallback("k9_menu_ready", function()
  NUI.Fire("set_resource_name", { resource = GetCurrentResourceName() })
end)

-- Base Menu Code
local K9Menu = Menu.Create("K9", "Testing Description")

-- Basic Actions
local K9Basic = Menu.CreateSubMenu("Basic", K9Menu, K9Menu, "Basic Player Actions")

Menu.CreateButton("Spawn", function()
  dog:Spawn()
end, K9Menu, K9Basic)

Menu.CreateButton("Despawn", function()
  dog:Despawn()
end, K9Menu, K9Basic)

local BreedSlider = Menu.CreateRangeSlider("Breeds", function(self, action, value)
  if action == "changed" then
    self:UpdateText(breeds[value].label)
  elseif action == "selected" then
    dog:SetNewK9({ model = breeds[value].model })
  end
end, K9Menu, K9Basic, 1, 1, #breeds, 1)

-- K9 Actions
local K9Actions = Menu.CreateSubMenu("Actions", K9Menu, K9Menu, "K9 Specific Actions")

Menu.CreateButton("Follow", function()
  dog:Follow()
end, K9Menu, K9Actions)

Menu.CreateButton("Stay", function()
  dog:Stay()
end, K9Menu, K9Actions)

Menu.CreateButton("Attack", function()
  dog:Attack()
end, K9Menu, K9Actions)

Menu.CreateButton("Enter Vehicle", function()
  local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
  dog:EnterVehicle(vehicle)
end, K9Menu, K9Actions)

Menu.CreateButton("Exit Vehicle", function()
  dog:ExitVehicle()
end, K9Menu, K9Actions)

-- K9 Animations
local K9Animations = Menu.CreateSubMenu("Animations", K9Menu, K9Menu, "K9 Aniamtions")

-- KEYBOARD CONTROLS
Utils.RegisterKeyMap("follow", function()
  dog:Follow()
end, function() end, "K9 Following toggle", "keyboard", "g")

Utils.RegisterKeyMap("open_menu", function()
  if not K9Menu.Opened then
    K9Menu:OpenMenu()
    K9Menu.Opened = true
  end
end, function() end, "Open the K9 menu", "keyboard", "insert")

Utils.RegisterKeyMap("menu_select", function()
  if K9Menu.Opened then
    K9Menu.OpenedMenu:FireComponent()
  end
end, function() end, "Select K9 menu option", "keyboard", "return")

Utils.RegisterKeyMap("menu_up", function()
  if K9Menu.Opened then
    K9Menu.OpenedMenu:GoUp()
  end
end, function() end, "K9 menu up", "keyboard", "up")

Utils.RegisterKeyMap("menu_down", function()
  if K9Menu.Opened then
    K9Menu.OpenedMenu:GoDown()
  end
end, function() end, "K9 menu down", "keyboard", "down")

Utils.RegisterKeyMap("menu_left", function()
  if K9Menu.Opened then
    local selectedComponent = K9Menu.OpenedMenu.Components[K9Menu.OpenedMenu.Hovered]
    if selectedComponent then
      if selectedComponent.Type == "rangeslider" then
        selectedComponent:GoLeft()
      end
    end
  end
end, function() end, "K9 menu left", "keyboard", "left")

Utils.RegisterKeyMap("menu_right", function()
  if K9Menu.Opened then
    local selectedComponent = K9Menu.OpenedMenu.Components[K9Menu.OpenedMenu.Hovered]
    if selectedComponent then
      if selectedComponent.Type == "rangeslider" then
        selectedComponent:GoRight()
      end
    end
  end
end, function() end, "K9 menu right", "keyboard", "right")

Utils.RegisterKeyMap("menu_back", function()
  if K9Menu.Opened then
    K9Menu.OpenedMenu:GoBack()
  end
end, function() end, "K9 menu back", "keyboard", "delete")