Module = {}
Module.__index = Module

function Module.New(name)
  local newModule = {}
  setmetatable(newModule, Module)

  newModule.Name = name
  newModule.Functions = {}

  return newModule
end

function Module:AddFunc(key, action)
  self.Functions[key] = action
end

function Module:CallFunc(key, ...)
  self.Functions[key](...)
end