require('addon_game_mode')

function pickOrReturnGoodFlag(event)
  local unit = EntIndexToHScript(event.caster_entindex)
	print("pegando item")
	print(unit:GetUnitName())
	if unit:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
	  print("tem que dropar item")
    for i = 0,5 do
      print("i:"..i)
      local item = unit:GetItemInSlot(i)
      if item then
        print("item nome:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_good_flag" then
          unit:RemoveItem(item)
          print("dropando item")
        end
      end
    end
    spawnGoodFlag()
	end
end

function pickOrReturnBadFlag(event)
  local unit = EntIndexToHScript(event.caster_entindex)
	print("pegando item")
	print(unit:GetUnitName())
	if unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
	  print("tem que dropar item")
    for i = 0,5 do
      print("i:"..i)
      local item = unit:GetItemInSlot(i)
      if item then
        print("item nome:"..item:GetAbilityName())
        if item:GetAbilityName() == "item_capture_bad_flag" then
          unit:RemoveItem(item)
          print("dropando item")
        end
      end
    end
    spawnBadFlag()
	end
end

