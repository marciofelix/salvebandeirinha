-- Generated from template
if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

if score == nil then
	score = class({})
	score.Bad = 0
	score.Good = 0
end

function Precache( context )
  PrecacheItemByNameSync("item_capture_good_flag", context)
  PrecacheItemByNameSync("item_capture_bad_flag", context)
  PrecacheUnitByNameSync("npc_dota_hero_dragon_knight", context)
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = CAddonTemplateGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function CAddonTemplateGameMode:InitGameMode()
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
	GameRules:SetHeroSelectionTime(15.0)
	GameRules:SetPreGameTime(5.0)
	GameRules:SetPostGameTime(30.0)
	--GameRules:MakeTeamLose(DOTA_TEAM_GOODGUYS || DOTA_TEAM_BADGUYS) -- faz um time perder. acho que vamos precisar.
	
	print("[Salve Bandeirinha] Gamemode rules are set.")

	spawnGoodFlag()
	spawnBadFlag()

	-- Register Think
	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print("[Salve Bandeirinha] Template addon script is running.")
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end

function CAddonTemplateGameMode:updateScore(scoreGood, scoreBad)
  print("entrou update score")
  print(scoreGood)
  print(scoreBad)
  local GameMode = GameRules:GetGameModeEntity()
  GameMode:SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, scoreGood)
  GameMode:SetTopBarTeamValue(DOTA_TEAM_BADGUYS, scoreBad)
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




