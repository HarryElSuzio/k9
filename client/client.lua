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


    local selectedComponent = K9Menu.OpenedMenu.Components[K9Menu.OpenedMenu.Hovered]

    if selectedComponent then
      if selectedComponent.Type == "rangeslider" then
        -- Left
        if IsControlJustPressed(0, 174) then
          selectedComponent:GoLeft()
        -- Right
        elseif IsControlJustPressed(0, 175) then
          selectedComponent:GoRight()
        end
      end
    end
  end
end)