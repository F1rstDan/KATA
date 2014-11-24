User = {}
print( "[KATA] ===User=== Called" )


--------------------------------------------------------------------------------
-- ACTIVATE 激活
--------------------------------------------------------------------------------
function User:RegistEvents()

	ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(User, 'OnPlayerPickHero'), self)
	--玩家选择英雄事件
end

--------------------------------------------------------------------------------
-- OnPlayerPickHero 
--------------------------------------------------------------------------------
function User:OnPlayerPickHero( event )
	local player = event.player
	local heroindex = event.heroindex
	local heroname = event.hero
	print( '[KATA_OnPlayerPickHero] player = '..player..' ,heroindex = '..heroindex..' ,heroname = '..heroname )

	local hero = EntIndexToHScript( heroindex )
	local SteamID = PlayerResource:GetSteamAccountID( player -1)

	if SteamID == 40354906 then
		print('Yep!')
		hero:SetCustomHealthLabel("#SetCustomHealthLabel_TheCreator", 211, 168, 9 ) --土豪金颜色
		--------------------------------------------------------------------------------
		--因为0.1间隔执行，所谓整个游戏都很卡？
		--------------------------------------------------------------------------------
		-- hero.CHLstring = "#SetCustomHealthLabel_TheCreator"
		-- hero.CHLcolorR = 211			--土豪金RGB, 211, 168, 9
		-- hero.CHLcolorG = 168
		-- hero.CHLcolorB = 9
		-- hero.CHLcolorIsLight = true		--现阶段是否提亮中，否则降低亮度
		-- hero.CHLcolorLightN = 0			--现在提亮值

		-- GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("show"),function()
		-- 	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then return end		--如果是英雄选择模式，则退出
		-- 	if hero or heroname ~= hero:GetUnitName() then
		-- 		if hero.CHLcolorIsLight then
		-- 			-- print('color+'..hero.CHLcolorLightN)
		-- 			hero.CHLcolorR = hero.CHLcolorR +2
		-- 			hero.CHLcolorG = hero.CHLcolorG +6
		-- 			hero.CHLcolorB = hero.CHLcolorB +14
		-- 			hero.CHLcolorLightN = hero.CHLcolorLightN +1
		-- 			if hero.CHLcolorLightN >= 10 then
		-- 				hero.CHLcolorIsLight = false
		-- 			end
		-- 			hero:SetCustomHealthLabel(hero.CHLstring, hero.CHLcolorR, hero.CHLcolorG, hero.CHLcolorB ) --土豪金颜色
		-- 		else
		-- 			-- print('color-'..hero.CHLcolorLightN)
		-- 			hero.CHLcolorR = hero.CHLcolorR -2
		-- 			hero.CHLcolorG = hero.CHLcolorG -6
		-- 			hero.CHLcolorB = hero.CHLcolorB -14
		-- 			hero.CHLcolorLightN = hero.CHLcolorLightN -1
		-- 			if hero.CHLcolorLightN <= 0 then
		-- 				hero.CHLcolorIsLight = true
		-- 			end
		-- 			hero:SetCustomHealthLabel(hero.CHLstring, hero.CHLcolorR, hero.CHLcolorG, hero.CHLcolorB ) --土豪金颜色
		-- 		end
		-- 	else
		-- 		return nil
		-- 	end
		-- 	return 0.1
		-- end,0.1)
	end

end