-- MENU STUFF
RegisterNUICallback("k9_menu_ready", function()
  NUI.Fire("set_resource_name", { resource = GetCurrentResourceName() })
end)

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    -- INSERT
    if IsControlJustReleased(0, 121) then

    end

    -- ENTER
    if IsControlJustPressed(0, 191) then
  
    end

    -- BACKSPACE
    if IsControlJustPressed(0, 194) then

    end

    -- UP
    if IsControlJustPressed(0, 172) then

    -- DOWN
    elseif IsControlJustPressed(0, 173) then

    end
  end
end)