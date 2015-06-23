require('addon_game_mode')

function enterBadArea(trigger)
  local unit = trigger.activator
	print("entrou-bad")
	print(unit:GetUnitName())
  for i=0,5 do
    local item = unit:GetItemInSlot(i)
    if item then
      if item:GetAbilityName() == 'item_capture_good_flag' then
        UTIL_RemoveImmediate(item)
        unit:RemoveModifierByName('modifier_creep_slow')
        heroWithBadFlag = nil
        print("ponto para Dire")
        score.Bad = score.Bad + 1
        CAddonTemplateGameMode:updateScore(score.Good, score.Bad)
        -- aqui tem que resetar jogadores e flags
        spawnGoodFlag()
      end
    end
  end
end

function leaveBadArea(trigger)
  local unit = trigger.activator
	local unit_name = unit:GetUnitName()
	print("saiu-b")
	print(unit_name)
	--CastAbilityOnTarget(handle target, handle ability, int playerIndex)
	--void SetMoveCapability(int iMoveCapabilities)
	--DOTAUnitMoveCapability_t
  --Name	Value	Description
  --DOTA_UNIT_CAP_MOVE_NONE	0	
  --DOTA_UNIT_CAP_MOVE_GROUND	1
  --DOTA_UNIT_CAP_MOVE_FLY	2
	unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
end

function enterGoodArea(trigger)
  local unit = trigger.activator
	print("entrou")
	print(unit:GetUnitName())
  for i=0,5 do
    local item = unit:GetItemInSlot(i)
    if item then
      if item:GetAbilityName() == 'item_capture_bad_flag' then
        UTIL_RemoveImmediate(item)
        unit:RemoveModifierByName('modifier_creep_slow')
        heroWithBadFlag = nil
        print("ponto para Radiant")
        score.Good = score.Good + 1
        CAddonTemplateGameMode:updateScore(score.Good, score.Bad)
        -- aqui tem que resetar jogadores e flags
        spawnBadFlag()
      end
    end
  end
end

function leaveGoodArea(trigger)
  local unit = trigger.activator
	local unit_name = unit:GetUnitName()
	print("saiu")
	print(unit_name)
	unit:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
end
