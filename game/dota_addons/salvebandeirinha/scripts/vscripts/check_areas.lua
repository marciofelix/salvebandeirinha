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
          UTIL_RemoveImmediate(item)
          print("ponto para Radiant")
          score.Good = score.Good + 1
          GM:updateScore(score.Good, score.Bad)
          -- gold for the team
          local team = Entities:FindAllByName(CONSTANTS.goodGuysHero)
          for k,v in pairs(team) do
            v:SetGold(CONSTANTS.goldForPoint, true)
          end
          print("vendo se inimigo está com bandeira")
          local teamenemy = Entities:FindAllByName(CONSTANTS.badGuysHero)
          for k,v in pairs(teamenemy) do
            print(v:GetName())
            for i = 0,5 do
              local item = v:GetItemInSlot(i)
              if item then
                print("esta com o item:"..item:GetAbilityName())
                if item:GetAbilityName() == "item_capture_good_flag" then
                  print("-------------devolve fera-------------")
                  UTIL_RemoveImmediate(item)
                  spawnGoodFlag()
                end
              end
            end
          end
          -- aqui tem que resetar jogadores
          spawnBadFlag()
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
          UTIL_RemoveImmediate(item)
          print("ponto para Dire")
          score.Bad = score.Bad + 1
          GM:updateScore(score.Good, score.Bad)
          -- gold for the team
          local team = Entities:FindAllByName(CONSTANTS.badGuysHero)
          for k,v in pairs(team) do
            v:SetGold(CONSTANTS.goldForPoint, true)
          end
          print("vendo se inimigo está com bandeira")
          local teamenemy = Entities:FindAllByName(CONSTANTS.goodGuysHero)
          for k,v in pairs(teamenemy) do
            print(v:GetName())
            for i = 0,5 do
              local item = v:GetItemInSlot(i)
              if item then
                print("esta com o item:"..item:GetAbilityName())
                if item:GetAbilityName() == "item_capture_bad_flag" then
                  print("-------------devolve fera-------------")
                  UTIL_RemoveImmediate(item)
                  spawnBadFlag()
                end
              end
            end
          end
          -- aqui tem que resetar jogadores
          spawnGoodFlag()
        end
      end
    end
  end
end

function leaveGoodArea(trigger)
  local unit = trigger.activator
  local unit_name = unit:GetUnitName()
  print("saiu")
  print(unit_name)
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    unit:RemoveModifierByName("modifier_invulnerable")
  end
end

function leaveBadArea(trigger)
  local unit = trigger.activator
  local unit_name = unit:GetUnitName()
  print("saiu-b")
  print(unit_name)
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:RemoveModifierByName("modifier_invulnerable")
  end
end

function enterGoodAreaBack(trigger)
  local unit = trigger.activator
  print("entrou-fundo")
  print(unit:GetUnitName())
  print(unit:GetTeamNumber())
  if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
  end
end

function enterBadAreaBack(trigger)
  local unit = trigger.activator
  print("entrou-bad fundo")
  print(unit:GetUnitName())
  print(unit:GetTeamNumber())
  if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
  end
end


