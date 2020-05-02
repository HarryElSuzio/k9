K9 = {}
K9.__index = K9

function K9.New()
  local newK9 = {}
  setmetatable(newK9, K9)

  newK9.name = "Flex"
  newK9.model = "DOG_MODEL_HERE"

  return newK9
end

function K9:Spawn()

end

function K9:Despawn()

end

function K9:ChangeModel()
  
end

function K9:EnterVehicle()

end

function K9:ExitVehicle()

end

function K9:SearchVehicle()
  
end

function K9:SearchPerson()

end

function K9:FindPerson()

end

function K9:PlayTask()

end