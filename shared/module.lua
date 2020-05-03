Citizen.CreateThread(function()
  local module = K9Overhaul.Configs.Module
  local modules = K9Overhaul.Modules
  if module ~= nil or module ~= "none" then
    for k, v in pairs(modules) do
      if k == module then
        K9Overhaul.SelectedModule = v
      end
    end
  end
end)