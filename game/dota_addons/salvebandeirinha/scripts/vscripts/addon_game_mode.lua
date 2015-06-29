-- Generated from template
if GM == nil then
  GM = class({})
  GM.playersAssigned = false
end

if score == nil then
  score = class({})
  score.Bad = 0
  score.Good = 0
end

if CONSTANTS == nil then
  CONSTANTS = {}
  CONSTANTS.scoreToWin = 10
  CONSTANTS.goodGuysHero = "npc_dota_hero_dragon_knight"
  CONSTANTS.badGuysHero = "npc_dota_hero_sven"
  CONSTANTS.goldForPoint = 150
end

-- Precache things we know we'll use.
function Precache(context)
  -- Items models.
  PrecacheItemByNameSync("item_capture_good_flag", context)
  PrecacheItemByNameSync("item_capture_bad_flag", context)
  PrecacheResource("model_folder", "models/items/wards", context)

  -- Hero Models.
  PrecacheResource("model_folder", "models/heroes/dragon_knight", context)
  PrecacheResource("model_folder", "models/items/dragon_knight", context)
  PrecacheResource("model_folder", "models/heroes/sven", context)
  PrecacheResource("model_folder", "models/items/sven", context)

  -- Particle effect applied to the flag holder.
  PrecacheResource("particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.AddonTemplate = GM()
  GameRules.AddonTemplate:InitGameMode()
end

function GM:InitGameMode()
  print("[Salve Bandeirinha] Iniciando.")

  -- Set GameMode parameters
  GameMode = GameRules:GetGameModeEntity()

  --Override the values of the team values on the top game bar.
  GameMode:SetTopBarTeamValuesOverride(true)
  GameMode:SetTopBarTeamValuesVisible(true)
  GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, 0)
  GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, 0)

  -- não recomenda itens
  GameMode:SetRecommendedItemsDisabled(true)
  
  -- Setup rules
  GameRules:SetHeroRespawnEnabled(true)
  GameRules:SetUseUniversalShopMode(true)
  GameRules:SetSameHeroSelectionEnabled(true)
  GameRules:SetHeroSelectionTime(0.0)
  GameRules:SetPreGameTime(0.0)
  GameRules:SetPostGameTime(5.0)
  
  print("[Salve Bandeirinha] Gamemode rules are set.")
  print("[Salve Bandeirinha] Gamemode rules are set.")
  print("[Salve Bandeirinha] Gamemode rules are set.")
  print("[Salve Bandeirinha] Gamemode rules are set.")
  print("[Salve Bandeirinha] Gamemode rules are set.")

  --
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(GM, 'OnNPCSpawned'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(GM, 'OnEntityHurt'), self)

  --Coloca as bandeiras no mapa
  spawnGoodFlag()
  spawnBadFlag()

  -- Register Think
  GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
end

function GM:assignPlayers()
  print("Assigning heroes for all players...")
  GM.playersAssigned = true
  for i = 1,11 do
    local player = PlayerInstanceFromIndex(i)

    if player ~= nil then
      if player:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
        CreateHeroForPlayer(CONSTANTS.goodGuysHero, player)
      else 
        CreateHeroForPlayer(CONSTANTS.badGuysHero, player)
      end
    end
  end
end

-- Evaluate the state of the game
function GM:OnThink()
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    if GM.playersAssigned == false then
      GM:assignPlayers()
    end
  elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
    return nil
  end
  return 1
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.
  The hero parameter is the hero entity that just spawned in.
]]
function GM:OnNPCSpawned(keys)
  local hero = EntIndexToHScript(keys.entindex)
  if hero:IsHero() then
    print("OnNPCSpawned zerando pontos de habilidade")
    hero:SetAbilityPoints(0)
  end
end

-- An entity somewhere has been hurt.
-- Se algúem apanha: ou está sendo congelado ou descongelado.
-- Se é atacado por inimigo alteramos o time para customx para ele poder ser atacado por aliado e congelamos.
-- Se é atacado por aliado retornamos para o time original e descongelamos.
function GM:OnEntityHurt(keys)
  local bateu = EntIndexToHScript(keys.entindex_attacker)
  local apanhou = EntIndexToHScript(keys.entindex_killed)

  print("time bateu: "..bateu:GetTeamNumber())
  print("time apanhou: "..apanhou:GetTeamNumber())
  
  --DOTA_UNIT_CAP_MOVE_NONE
  --DOTA_UNIT_CAP_MOVE_GROUND
  apanhou:SetMoveCapability(DOTA_UNIT_CAP_MOVE_NONE)
  --DOTA_UNIT_CAP_NO_ATTACK
  --DOTA_UNIT_CAP_MELEE_ATTACK
  apanhou:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
  -- create item to apply modifier
  local itemmod = CreateItem("item_apply_modifiers", bateu, bateu)
  if apanhou:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    itemmod:ApplyDataDrivenModifier(bateu, apanhou, "modifier_mute", {duration=-1})
    -- check if there is someone of his tem unfrozen
    local teamg = Entities:FindAllByName(CONSTANTS.goodGuysHero)
    local allfrozen = true
    for k,v in pairs(teamg) do
      if v:HasGroundMovementCapability() then
        allfrozen = false
      end
    end
    if allfrozen then
      point(CONSTANTS.badGuysHero)
      return
    end
    apanhou:SetTeam(DOTA_TEAM_CUSTOM_1)
    print("tem que dropar item")
    for i = 0,5 do
      print("i:"..i)
      local item = apanhou:GetItemInSlot(i)
      if item then
        print("item nome:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_bad_flag" then
          apanhou:RemoveItem(item)
          print("dropando item")
          spawnBadFlag()
        end
      end
    end
  elseif apanhou:GetTeamNumber() == DOTA_TEAM_BADGUYS then
    itemmod:ApplyDataDrivenModifier(bateu, apanhou, "modifier_mute", {duration=-1})
    -- check if there is someone of his tem unfrozen
    local teamb = Entities:FindAllByName(CONSTANTS.badGuysHero)
    local allfrozen = true
    for k,v in pairs(teamb) do
      if v:HasGroundMovementCapability() then
        allfrozen = false
      end
    end
    if allfrozen then
      point(CONSTANTS.goodGuysHero)
      return
    end
    apanhou:SetTeam(DOTA_TEAM_CUSTOM_2)
    print("tem que dropar item")
    for i = 0,5 do
      print("i:"..i)
      local item = apanhou:GetItemInSlot(i)
      if item then
        print("item nome:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_good_flag" then
          apanhou:RemoveItem(item)
          print("dropando item")
          spawnGoodFlag()
        end
      end
    end
  elseif apanhou:GetTeamNumber() == DOTA_TEAM_CUSTOM_1 then
    if bateu:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
      apanhou:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
      apanhou:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
      apanhou:SetTeam(DOTA_TEAM_GOODGUYS)
      apanhou:RemoveModifierByName("modifier_mute")
    end
  elseif apanhou:GetTeamNumber() == DOTA_TEAM_CUSTOM_2 then
    if bateu:GetTeamNumber() == DOTA_TEAM_BADGUYS then
      apanhou:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
      apanhou:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
      apanhou:SetTeam(DOTA_TEAM_BADGUYS)
      apanhou:RemoveModifierByName("modifier_mute")
    end
  end
end

function GM:updateScore(scoreGood, scoreBad)
  print("Updating score: " .. scoreGood .. " x " .. scoreBad)

  local GameMode = GameRules:GetGameModeEntity()
  GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, scoreGood)
  GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, scoreBad)

  -- If any team reaches scoreToWin, the game ends and that team is considered winner.
  if scoreGood == CONSTANTS.scoreToWin then
    print("Team GOOD GUYS victory!")
    GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
  end
  if scoreBad == CONSTANTS.scoreToWin then
    print("Team BAD GUYS victory!")
    GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
  end
end

function spawnGoodFlag()
  print("entrou spawnGoodFlag")
  local flag = CreateItem("item_capture_good_flag", nil, nil)
  CreateItemOnPositionSync(Vector(1920, -3328, 128), flag)
  print("saiu spawnGoodFlag")
end

function spawnBadFlag()
  print("entrou spawnBadFlag")
  local flag = CreateItem("item_capture_bad_flag", nil, nil)
  CreateItemOnPositionSync(Vector(1920, -256, 128), flag)
  print("saiu spawnBadFlag")
end

-- arg is the name of the hero how made point
-- remove flag from inventory and respawn flag if need
-- reset and respawn heroes
function point(nameHero)
  print("ponto")
  if nameHero == CONSTANTS.goodGuysHero then
    print("para Radiant")
    score.Good = score.Good + 1
  else
    print("para Dire")
    score.Bad = score.Bad + 1
  end
  GM:updateScore(score.Good, score.Bad)
  -- gold for the team how made point
  local team = Entities:FindAllByName(nameHero)
  for k,v in pairs(team) do
    v:SetGold(v:GetGold() + CONSTANTS.goldForPoint, false)
  end
  -- reset heroes of good guys e drop/respawn flag if need
  local teamg = Entities:FindAllByName(CONSTANTS.goodGuysHero)
  for k,v in pairs(teamg) do
    for i = 0,5 do
      local item = v:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_bad_flag" then
          UTIL_RemoveImmediate(item)
          spawnBadFlag()
        end
      end
    end
    v:SetTeam(DOTA_TEAM_GOODGUYS)
    v:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    v:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
    v:RemoveModifierByName("modifier_mute")
    v:SetTimeUntilRespawn(0)
  end
  -- reset heroes of bad guys e drop/respawn flag if need
  local teamb = Entities:FindAllByName(CONSTANTS.badGuysHero)
  for k,v in pairs(teamb) do
    for i = 0,5 do
      local item = v:GetItemInSlot(i)
      if item then
        if item:GetAbilityName() == "item_capture_good_flag" then
          UTIL_RemoveImmediate(item)
          spawnGoodFlag()
        end
      end
    end
    v:SetTeam(DOTA_TEAM_BADGUYS)
    v:SetMoveCapability(DOTA_UNIT_CAP_MOVE_GROUND)
    v:SetAttackCapability(DOTA_UNIT_CAP_MELEE_ATTACK)
    v:RemoveModifierByName("modifier_mute")
    v:SetTimeUntilRespawn(0)
  end
end
