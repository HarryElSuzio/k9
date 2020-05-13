local isServer = IsDuplicityVersion()

if isServer then
else

  local ESX = {}
  local illegalItems = {
    "weed"
  }
  local ESXModule = Module.New("ESX")
  ModuleManager:Add(ESXModule)
  ESXModule:AddFunc("GetVehicleInventory", GetVehicleInventoryItems)

  TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
  end)

  function GetVehicleInventoryItems(searchType, plate, callback)
    if searchType == "trunk" then
      SearchTrunk(plate, callback)
    elseif searchType == "glovebox" then
      SearchGlovebox(plate, callback)
    end
  end

  function SearchTrunk(plate, callback)
    ESX.TriggerServerCallback("esx_trunk:getInventoryV", function(inventory)
      local foundIllegal = false
      local items = inventory.items
      local weapons = inventory.weapons

      for _, illegalItem in pairs(illegalItems) do
        -- SEARCHING ITEMS
        for _, item in pairs(items) do
          if item.name == illegalItem then
            foundIllegal = true
          end
        end

        -- SEARCHING WEAPONS
        for _, weapon in pairs(weapons) do
          if weapon.name == illegalItem then
            foundIllegal = true
          end
        end
      end

      callback(foundIllegal)
    end, plate)
  end

  function SearchGlovebox(plate, callback)
    ESX.TriggerServerCallback("esx_glovebox:getInventoryV", function(inventory)
      local foundIllegal = false
      local items = inventory.items
      local weapons = inventory.weapons

      for _, illegalItem in pairs(illegalItems) do
        -- SEARCHING ITEMS
        for _, item in pairs(items) do
          if item.name == illegalItem then
            foundIllegal = true
          end
        end

        -- SEARCHING WEAPONS
        for _, weapon in pairs(weapons) do
          if weapon.name == illegalItem then
            foundIllegal = true
          end
        end
      end

      callback(foundIllegal)
    end, plate)
  end

end