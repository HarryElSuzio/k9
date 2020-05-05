K9 = {}
K9.__index = K9

-- Variables
local Actions = {
  Follow = 1,
  Stay = 2,
  Search = 3,
  Attack = 4,
  Mounted = 5,
  Animated = 6
}

local Animations = {
  Sit = {
    dict = "creatures@rottweiler@amb@world_dog_sitting@base",
    anims = { 
      base = "base"
    }
  },
  VehicleEnter = {
    dict = "creatures@rottweiler@in_vehicle@van",
    anims = {
      get_in = "get_in"
    }
  }
}

-- Adding Relationship Groups
local Handler = GetHashKey("HANDLER")
local K9Unit = GetHashKey("K9")
local K9Target = GetHashKey("K9TARGET")
AddRelationshipGroup("handler", Handler)
AddRelationshipGroup("k9", K9Unit)
AddRelationshipGroup("k9target", K9Target)

-- K9 / Handler Relations
SetRelationshipBetweenGroups(1, Handler, K9Unit)
SetRelationshipBetweenGroups(0, K9Unit, Handler)

-- K9 / Target Relations
SetRelationshipBetweenGroups(5, K9Target, K9Unit)
SetRelationshipBetweenGroups(5, K9Unit, K9Target)

function K9.New()
  local newK9 = {}
  setmetatable(newK9, K9)

  newK9.name = "Flex"
  newK9.model = "a_c_rottweiler"
  newK9.speed = 0.2
  newK9.spawned = false
  newK9.spawnedHandle = nil
  newK9.CurrentAction = Actions.Stay
  newK9.MountedVehicle = nil
  newK9.EnteredDoor = nil
  newK9.EnteredDoorBone = nil

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
  if self.spawnedHandle then return end
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
  local playerPos = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 1.0, 0.0)
  local heading = GetEntityHeading(playerPed)
  self.spawnedHandle = CreatePed(28, model, playerPos.x, playerPos.y, playerPos.z, heading, true, true)
  self.spawned = true

  SetBlockingOfNonTemporaryEvents(self.spawnedHandle, true)
  GiveWeaponToPed(self.spawnedHandle, GetHashKey("WEAPON_ANIMAL"), 200, true, true);

  local fleeAttributes = {0, 3, 5, 46}
  for _, v in pairs(fleeAttributes) do
    SetPedFleeAttributes(self.spawnedHandle, v, true)
  end

  SetPedRelationshipGroupHash(PlayerPedId(), Handler)
  SetPedRelationshipGroupHash(self.spawnedHandle, K9Unit)

  self:Stay()

  -- Citizen.CreateThread(function()
  --   while true do
  --     Citizen.Wait(0)



  --   end
  -- end)
end

function K9:Despawn()
  if not self.spawnedHandle then return end
  DeletePed(self.spawnedHandle)
  SetPedRelationshipGroupHash(PlayerPedId(), GetHashKey("PLAYER"))
  self.spawned = false
  self.CurrentAction = Actions.Stay
  self.spawnedHandle = nil
end

-- Actions
function K9:Follow()
  if not self.spawnedHandle then return end
  if not self.CurrentAction == Actions.Follow then
    ClearPedTasks(self.spawnedHandle)
    TaskFollowToOffsetOfEntity(self.spawnedHandle, PlayerPedId(), 0.0, 0.0, 0.0, 5.0, -1, 0.0, true)
    self.CurrentAction = Actions.Follow
  else
    ClearPedTasks(self.spawnedHandle)
    self.CurrentAction = Actions.Stay
  end
end

function K9:Stay()
  if not self.spawnedHandle then return end
  ClearPedTasks(self.spawnedHandle)
  self.CurrentAction = Actions.Stay
end

function K9:Search()
  if not self.spawnedHandle then return end
  -- use module functions
end

function K9:Attack()
  if not self.spawnedHandle then return end
  ClearPedTasks(self.spawnedHandle)
  local found, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
  if found then
    if IsEntityAPed(target) then
      TaskCombatPed(self.spawnedHandle, target, 0, 16)
      SetPedRelationshipGroupHash(target, K9Target)
    end
  end

  self.CurrentAction = Actions.Attack
end

function K9:Animate(animDic, animName)
  if not self.spawnedHandle then return end
  ClearPedTasks(self.spawnedHandle)
  self.CurrentAction = Actions.Animated
end

function K9:EnterVehicle(vehicle)
  if not self.spawnedHandle then return end
  ClearPedTasks(self.spawnedHandle)
  local fwv = GetEntityForwardVector(vehicle)
  local fvX, fvY = fwv.x * 1.2, fwv.y * 1.2
  local playerPos = GetEntityCoords(PlayerPedId())
  local pos, door, distance = Utils.GetClosestVehicleDoor(playerPos, vehicle)
  local seat = Utils.GetSeatBoneFromDoor(door)
  local doorIndex = Utils.DoorIndicies[door]
  local doorBone = Utils.DoorBones[door]

  SetVehicleDoorOpen(vehicle, doorIndex, false, false)
  TaskGoToCoordAnyMeans(self.spawnedHandle, pos.x - fvX, pos.y - fvY, pos.z, 2.0, 0, 0, 786603, 0.25)
  Citizen.Wait(1500)
  TaskTurnPedToFaceEntity(self.spawnedHandle, vehicle, -1)
  Citizen.Wait(2000)

  local SitAnim = Animations.Sit
  local VehicleAnim = Animations.VehicleEnter

  RequestAnimDict(SitAnim.dict)
  RequestAnimDict(VehicleAnim.dict)
  local loadThresh = GetGameTimer() + 5000
  while not HasAnimDictLoaded(SitAnim.dict) and not HasAnimDictLoaded(VehicleAnim.dict) do
    Citizen.Wait(0)
    if GetGameTimer() > loadThresh then
      return
    end
  end

  TaskPlayAnim(self.spawnedHandle, VehicleAnim.dict, VehicleAnim.anims.get_in, 8.0, -4.0, -1, 2, -8.0, false, false, false)

  Citizen.Wait(1500)

  local dogBone = GetEntityBoneIndexByName(self.spawnedHandle, "root")
  local vehSeatBone = GetEntityBoneIndexByName(vehicle, seat)
  AttachEntityToEntity(self.spawnedHandle, vehicle, vehSeatBone, 0.0, -0.1, 0.4, 0.0, 0.0, 0.0, 0, false, false, true, 0, true)

  Citizen.Wait(250)

  TaskPlayAnim(self.spawnedHandle, SitAnim.dict, SitAnim.anims.base, 8.0, -4.0, -1, 2, -8.0, false, false, false)
  
  Citizen.Wait(250)

  SetVehicleDoorShut(vehicle, doorIndex, false)

  self.CurrentAction = Actions.Mounted
  self.EnteredDoor = doorIndex
  self.EnteredDoorBone = doorBone
  self.MountedVehicle = vehicle
end

function K9:ExitVehicle()
  if not self.MountedVehicle then return end
  if not self.spawnedHandle then return end
  ClearPedTasks(self.spawnedHandle)
  local vehPos = GetEntityCoords(self.MountedVehicle)
  local offsetPos = GetWorldPositionOfEntityBone(self.MountedVehicle, GetEntityBoneIndexByName(self.MountedVehicle, self.EnteredDoorBone))

  SetVehicleDoorOpen(self.MountedVehicle, self.EnteredDoor, false, false)
  Citizen.Wait(1000)
  
  DetachEntity(self.spawnedHandle, true, true)
  SetEntityCoords(self.spawnedHandle, offsetPos.x, offsetPos.y, offsetPos.z, 0.0, 0.0, 0.0, false)

  Citizen.Wait(1000)
  SetVehicleDoorShut(self.MountedVehicle, self.EnteredDoor, false)

  self.MountedVehicle = nil
  self.EnteredDoor = nil
  self.EnteredDoorBone = nil
  self.CurrentAction = Actions.Stay
end