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

-- Models Menu Code
local K9Models = Menu.CreateSubMenu("Breeds", K9Menu, K9Menu, "Choose your breed of K9")
for k, v in pairs(breeds) do
  Menu.CreateButton(v.label, function()
    dog:SetNewK9({ model = v.model })
  end, K9Menu, K9Models)
end

-- Control Handler
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    -- INSERT
    if IsControlJustReleased(0, 121) then
      if not K9Menu.Opened then
        K9Menu:OpenMenu()
        K9Menu.Opened = true
      end
    end

    -- ENTER
    if IsControlJustPressed(0, 191) then
      K9Menu.OpenedMenu:FireComponent()
    end

    -- BACKSPACE
    if IsControlJustPressed(0, 194) then
      K9Menu.OpenedMenu:GoBack()
    end

    -- UP
    if IsControlJustPressed(0, 172) then
      K9Menu.OpenedMenu:GoUp()
    -- DOWN
    elseif IsControlJustPressed(0, 173) then
      K9Menu.OpenedMenu:GoDown()
    end
  end
end)