K9 = {}
K9.__index = K9

function K9.New()
  local newK9 = {}
  setmetatable(newK9, K9)

  newK9.name = "Flex"
  newK9.model = "a_c_rottweiler"
  newK9.speed = 0.2
  newK9.spawned = false
  newK9.spawnedHandle = 0

  return newK9
end

function K9:SetNewK9(data)
  self.model = data.model
  if self.spawned then
    self:Despawn()
    self:Spawn()
  end
end

function K9:Spawn()
  local loadingThresh = GetGameTimer() + 5000
  local model = GetHashKey(self.model)
  RequestModel(model)
  while not HasModelLoaded(model) do
    Citizen.Wait(0)
    if loadingThresh < GetGameTimer() then
      return
    end
  end

  local playerPed = PlayerPedId()
  local playerPos = GetEntityCoords(playerPed)
  local heading = GetEntityHeading(playerPed)
  self.spawnedHandle = CreatePed(28, model, playerPos.x, playerPos.y, playerPos.z, heading, true, true)
  self.spawned = true

  SetPedMoveRateOverride(self.spawnedHandle, 10)
  TaskFollowToOffsetOfEntity(self.spawnedHandle, playerPed, 0.0, 0.0, 0.0, 100, -1, 1, true)
end

function K9:Despawn()
  DeletePed(self.spawnedHandle)
  self.spawned = false
end