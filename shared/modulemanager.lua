ModuleManager = {}
ModuleManager.SelectedModule = K9Overhaul.Configs.Module

Citizen.CreateThread(function()

end)

function ModuleManager:Add(module)
  self[module.Name] = module
  print("[K9 Overhaul]: Loaded Module - " .. module.Name)
end

function ModuleManager:CallFunc(func, ...)
  self[self.SelectedModule]:CallFunc(func, ...)
end