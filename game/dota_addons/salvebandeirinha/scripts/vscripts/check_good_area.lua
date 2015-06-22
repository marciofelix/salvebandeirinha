function enterGoodArea(trigger)
  local unit = trigger.activator
	local unit_name = unit:GetUnitName()
	print("entrou")
	print(unit_name)
	unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
end

function leaveGoodArea(trigger)
  local unit = trigger.activator
	local unit_name = unit:GetUnitName()
	print("saiu")
	print(unit_name)
	--CastAbilityOnTarget(handle target, handle ability, int playerIndex)
	--void SetMoveCapability(int iMoveCapabilities)
	--DOTAUnitMoveCapability_t
  --Name	Value	Description
  --DOTA_UNIT_CAP_MOVE_NONE	0	
  --DOTA_UNIT_CAP_MOVE_GROUND	1
  --DOTA_UNIT_CAP_MOVE_FLY	2
	unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
	--unit:ForceKill(true)
end
