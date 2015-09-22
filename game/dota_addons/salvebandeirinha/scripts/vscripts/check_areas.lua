require('addon_game_mode')

function enterGoodArea(trigger)
  local unit = trigger.activator
  print("entrou")
  print(unit:GetUnitName())
  print(unit:GetTeamNumber())
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_bad_flag" then
          point(CONSTANTS.goodGuysHero)
          unit:IncrementDenies()
        end
      end
    end
  end
end

function enterBadArea(trigger)
  local unit = trigger.activator
  print("entrou-bad")
  print(unit:GetUnitName())
  print(unit:GetTeamNumber())
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
    for i = 0,5 do
      local item = unit:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_good_flag" then
          point(CONSTANTS.badGuysHero)
          unit:IncrementDenies()
        end
      end
    end
  end
end

function leaveGoodArea(trigger)
  local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    unit:RemoveModifierByName("modifier_invulnerable")
  end
end

function leaveBadArea(trigger)
  local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:RemoveModifierByName("modifier_invulnerable")
  end
end

function enterGoodAreaBack(trigger)
  local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
  end
end

function enterBadAreaBack(trigger)
  local unit = trigger.activator
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
  end
end


