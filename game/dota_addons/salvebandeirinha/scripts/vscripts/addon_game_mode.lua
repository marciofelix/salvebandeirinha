-- Generated from template

if CAddonTemplateGameMode == nil then
	CAddonTemplateGameMode = class({})
end

function Precache( context )
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

--function CAddonTemplateGameMode:InitGameMode()
--	print( "Template addon is loaded." )
--	GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", 2 )
--end

function CAddonTemplateGameMode:InitGameMode()
	print("[Salve Bandeirinha] Iniciando.")

  -- Set GameMode parameters
  GameMode = GameRules:GetGameModeEntity()    
  -- Override the normal camera distance.  Usual is 1134
  --GameMode:SetCameraDistanceOverride( 1404.0 )
  -- Disable buyback
  GameMode:SetBuybackEnabled(false)
  -- Override the top bar values to show your own settings instead of total deaths
  GameMode:SetTopBarTeamValuesOverride (true)

	-- Setup rules
	GameRules:SetHeroRespawnEnabled(true)
	GameRules:SetUseUniversalShopMode(true)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetHeroSelectionTime(15.0)
	GameRules:SetPreGameTime(5.0)
	GameRules:SetPostGameTime(30.0)
	print("[Salve Bandeirinha] Gamemode rules are set.")

	-- Init self
	--InvokerWars = self
	-- Timers
	--self.timers = {}
	--Score
	--self.scoreDire = 0
	--self.scoreRadiant = 0
	--self.kills_to_win = 50

	-- Register Think
	--GameMode:SetContextThink("InvokerWarsThink", Dynamic_Wrap( InvokerWars, 'Think' ), THINK_TIME )
	GameRules:GetGameModeEntity():SetThink("OnThink", self, "GlobalThink", 2)

	-- Register Game Events
	--ListenToGameEvent('game_rules_state_change', Dynamic_Wrap( InvokerWars, "OnGameRulesStateChange" ), self )
	--ListenToGameEvent('entity_killed', Dynamic_Wrap(InvokerWars, 'OnEntityKilled'), self )
	--ListenToGameEvent('npc_spawned', Dynamic_Wrap(InvokerWars, 'OnNPCSpawned'), self )
end

-- Evaluate the state of the game
function CAddonTemplateGameMode:OnThink()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--print( "Template addon script is running." )
	elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
		return nil
	end
	return 1
end
