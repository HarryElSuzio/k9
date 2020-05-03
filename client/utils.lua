Utils = {}

Utils.DoorIndicies = {
  ["BackL"] = 2,
  ["BackR"] = 3
}
Utils.DoorBones = {
  ["BackL"] = "door_dside_r",
  ["BackR"] = "door_dside_f"
}
Utils.DoorSeats = {
  ["BackL"] = "seat_dside_r",
  ["BackR"] = "seat_pside_r"
}

function Utils.GetClosestVehicleDoor(pos, vehicle)
  local closestBonePos = -1
  local closestDoor = nil
  local closestDistance = -1
  for k, v in pairs(Utils.DoorIndicies) do
    local doorBone = Utils.DoorBones[k]
    local bonePos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, doorBone))
    if bonePos.x ~= 0 and bonePos.y ~= 0 and bonePos.z ~= 0 then
      local distance = Vdist2(pos.x, pos.y, pos.z, bonePos.x, bonePos.y, bonePos.z)
      if closestDistance == -1 or closestDistance > distance then
        print("[" .. k .. "] was closer than " .. tostring(closestDoor))
        closestBonePos = bonePos
        closestDoor = k
        closestDistance = distance
      end
    end
  end
  return closestBonePos, closestDoor, closestDistance
end

function Utils.GetSeatBoneFromDoor(door)
  return Utils.DoorSeats[door]
end

function Utils.GetClosestPlayer()
  local closestPlayer = -1
  local players = GetActivePlayers()
  for _, v in pairs(players) do
    
  end
end