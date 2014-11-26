
CreateUnitSystem = {}
print( "[KATA] ===CreateUnitSystem=== Called" )
--------------------------------------------------------------------------------
-- ACTIVATE 激活
--------------------------------------------------------------------------------
function CreateUnitSystem:RegistEvents()
	KataConstants()--=========常量设置============

    ListenToGameEvent('entity_killed', Dynamic_Wrap(CreateUnitSystem, 'OnEntityKilled_CreateUnit'), self)
	--单位死亡事件

	-- KATA_CreateUnitSystem()
	-- --激活创建单位系统

	GameRules:GetGameModeEntity():SetTopBarTeamValuesOverride( true )
	--覆盖队伍得分

	POS_SPAWNER_GOOD = Entities:FindByName(nil,"Spawner_good"):GetAbsOrigin()
	POS_SPAWNER_BAD = Entities:FindByName(nil,"Spawner_bad"):GetAbsOrigin()
end

--------------------------------------------------------------------------------
-- Constants 常量设置
--------------------------------------------------------------------------------
function KataConstants()
	GAME_TIME_S				= 0
	-- GAME_TIME_M				= 0
	GAME_ROUND_TIME			= 0		--回合时间
	GAME_ROUND				= 0		--第几回合
	GAME_ROUND_COUNTDOWN	= 0		--回合倒数时间
--------------------------------------------------------------------------------
KUNKKA_ADD_MINI			= 0		--添加数量
KUNKKA_ADD_BOSS			= 0		--添加数量
KUNKKA_ALIVE_MINI		= 0		--存活数量
KUNKKA_ALIVE_BOSS		= 0		--存活数量
KUNKKA_DEAD_MINI		= 0		--已死亡数量
KUNKKA_DEAD_BOSS		= 0		--已死亡数量
KUNKKA_LEVEL			= 1		--昆卡当前等级
KUNKKA_IS_ADDXP			= false --这回合是否增加了XP
--------------------------------------------------------------------------------
TIDEHUNTER_ADD_MINI			= 0		--添加数量
TIDEHUNTER_ADD_BOSS			= 0		--添加数量
TIDEHUNTER_ALIVE_MINI		= 0		--存活数量
TIDEHUNTER_ALIVE_BOSS		= 0		--存活数量
TIDEHUNTER_DEAD_MINI		= 0		--已死亡数量
TIDEHUNTER_DEAD_BOSS		= 0		--已死亡数量
TIDEHUNTER_LEVEL			= 1		--昆卡当前等级
TIDEHUNTER_IS_ADDXP			= false --这回合是否增加了XP
end

GAME_BEFORE_TIME = 0
function SetGameBeforeTime( ) --addon_game_mode.lua 引用
	GAME_BEFORE_TIME = math.floor( GameRules:GetGameTime() )
	print( "[KATA] GetGameTime set = "..GAME_BEFORE_TIME)
end

function CreateUnitSystem:Begin( ) --初始化，增加数量，给addon_game_mode.lua调用的

	KATA_CreateUnitSystemTime()		--启动生产单位计时器

	-- GameRules:GetGameModeEntity():SetContextThink("GAME_TIME_S",function() 
	-- 	GAME_TIME_S = GameRules:GetGameTime()-GAME_BEFORE_TIME
	-- 	return 1
	-- end,0)
	-- GameRules:GetGameModeEntity():SetContextThink("GAME_TIME_M",function()
	-- 	local t = GameRules:GetGameTime()-GAME_BEFORE_TIME
	-- 	GAME_TIME_M = ( t-(t%60) )/60
	-- 	return 60
	-- end,0)

	if GOODGUYS_AI then
		print( "[KATAadd level] GOODGUYS_AI")
		-- return
	elseif BADGUYS_AI then
		print( "[KATAadd level] BADGUYS_AI")
		-- return
	else
		local goodguy_player = 0
		local badguy_player = 0
		for playerid = 0 ,9 do
			if PlayerResource:GetPlayer(playerid) ~= nil then --如果玩家不为nil空
				if PlayerResource:GetTeam(playerid) == DOTA_TEAM_GOODGUYS then
					goodguy_player = goodguy_player+1
				elseif PlayerResource:GetTeam(playerid) == DOTA_TEAM_BADGUYS then
					badguy_player = badguy_player+1
				end
			end
		end

		local all = goodguy_player + badguy_player
		if goodguy_player > badguy_player and badguy_player ~= 0 then --如果玩家数量不等，人多方将提升 小兵等级
			local i = goodguy_player - badguy_player
			if i == 1 then
				if all == 3 then
					TIDEHUNTER_LEVEL = 4
				elseif all == 5 then
					TIDEHUNTER_LEVEL = 3
				elseif all == 7 then
					TIDEHUNTER_LEVEL = 3
				elseif all == 9 then
					TIDEHUNTER_LEVEL = 2
				end
			elseif i == 2 then
				TIDEHUNTER_LEVEL = 6
			elseif i == 3 then
				TIDEHUNTER_LEVEL = 8
			elseif i == 4 then
				TIDEHUNTER_LEVEL = 10
			end
		elseif badguy_player > goodguy_player and goodguy_player ~= 0 then
			local i = badguy_player - goodguy_player
			if i == 1 then
				if all == 3 then
					KUNKKA_LEVEL = 4
				elseif all == 5 then
					KUNKKA_LEVEL = 3
				elseif all == 7 then
					KUNKKA_LEVEL = 3
				elseif all == 9 then
					KUNKKA_LEVEL = 2
				end
			elseif i == 2 then
				KUNKKA_LEVEL = 6
			elseif i == 3 then
				KUNKKA_LEVEL = 8
			elseif i == 4 then
				KUNKKA_LEVEL = 10
			end
		end
	end

end

--------------------------------------------------------------------------------
-- 单位死亡事件
--------------------------------------------------------------------------------
function CreateUnitSystem:OnEntityKilled_CreateUnit( keys )
	-- print( '[KATA] OnEntityKilled Called' )
	-- print( '[KATA_Killed] entindex_killed = '..EntIndexToHScript( keys.entindex_killed ):GetName() )
	-- print( '[KATA_Killed] entindex_attacker = '..EntIndexToHScript( keys.entindex_attacker ):GetName() )
	-- print( '[KATA_Killed] entindex_inflictor = '..EntIndexToHScript( keys.entindex_inflictor ):GetName() )
	-- print( '[KATA_Killed] damagebits = '..keys.damagebits )

	-- 储存被击杀的单位
	local killed = EntIndexToHScript( keys.entindex_killed )
	-- 储存杀手单位
	-- local attacker =EntIndexToHScript( keys.entindex_attacker )

	if killed:GetUnitName() == 'npc_mini_kunkka'  then
		if killed.IsBoss then
			KUNKKA_ALIVE_BOSS = KUNKKA_ALIVE_BOSS -1	--存活数量
			KUNKKA_DEAD_BOSS  = KUNKKA_DEAD_BOSS  +1	--已死亡数量
		else
			KUNKKA_ALIVE_MINI = KUNKKA_ALIVE_MINI -1	--存活数量
			KUNKKA_DEAD_MINI  = KUNKKA_DEAD_MINI  +1	--已死亡数量
		end
	elseif killed:GetUnitName() == 'npc_mini_tidehunter' then
		if killed.IsBoss then
			TIDEHUNTER_ALIVE_BOSS = TIDEHUNTER_ALIVE_BOSS -1	--存活数量
			TIDEHUNTER_DEAD_BOSS  = TIDEHUNTER_DEAD_BOSS  +1	--已死亡数量
		else
			TIDEHUNTER_ALIVE_MINI = TIDEHUNTER_ALIVE_MINI -1	--存活数量
			TIDEHUNTER_DEAD_MINI  = TIDEHUNTER_DEAD_MINI  +1	--已死亡数量
		end
	end
end


--------------------------------------------------------------------------------
-- 生产单位系统
--------------------------------------------------------------------------------
function KATA_CreateUnitSystemTime()
	--
	-- GAME_ROUND_TIME = 0	--回合时间
	-- GAME_TIME_S = 0		--游戏过后的时间
	GAME_ROUND = 1
	KUNKKA_ADD_MINI = 3
	KUNKKA_ADD_BOSS = 0
	TIDEHUNTER_ADD_MINI = 3
	TIDEHUNTER_ADD_BOSS = 0
	KUNKKA_IS_ADDXP 	= false			--重新启动加金额技能
	TIDEHUNTER_IS_ADDXP = false

	
	-- 每1秒循环
	GameRules:GetGameModeEntity():SetContextThink("KATA_CreateUnitSystemTime",function()
		GAME_TIME_S = math.floor(GameRules:GetGameTime()) - GAME_BEFORE_TIME	--游戏过后的时间
		GAME_ROUND_TIME = GAME_TIME_S - (GAME_ROUND-1)*30						--回合时间
		GAME_ROUND_COUNTDOWN = 30 - GAME_ROUND_TIME								--回合倒数时间
		-- print( "[KATA] ===GAME_ROUND=== GAME_TIME_S = "..GAME_TIME_S.." GAME_ROUND_TIME = "..GAME_ROUND_TIME.." GAME_ROUND_COUNTDOWN = "..GAME_ROUND_COUNTDOWN )

		if GAME_ROUND_COUNTDOWN == 0 then	--倒数时间为0时，增加回合数和刷兵
			GAME_ROUND = GAME_ROUND + 1		--回合数+1
			KATA_CreateUnitSystem()			--启动刷兵
			KUNKKA_IS_ADDXP 	= false		--重新启动加金额技能
			TIDEHUNTER_IS_ADDXP = false

			-- print('[KATARoundTime] = '..GAME_ROUND_TIME)
			-- local KATARoundTime = { nRoundTimeTween = GAME_ROUND_TIME }
			-- FireGameEvent( "KATA_RoundTime", KATARoundTime )
		end

		if TIDEHUNTER_ALIVE_MINI + TIDEHUNTER_ALIVE_BOSS == 0 and not KUNKKA_IS_ADDXP and GAME_ROUND ~= 0 then	--如果昆卡方清场了 and 昆卡还没增加过经验 and 回合数不等于0(游戏重新开始) 
			--全部昆卡英雄添加经验金钱
			KATA_HeroAddXPGold(DOTA_TEAM_GOODGUYS,GAME_ROUND_COUNTDOWN)
			KUNKKA_IS_ADDXP = true
			GameRules:SendCustomMessage("#Chat_kunkka_getxp",DOTA_TEAM_GOODGUYS, -1)
		elseif KUNKKA_ALIVE_MINI + KUNKKA_ALIVE_BOSS == 0 and not TIDEHUNTER_IS_ADDXP and GAME_ROUND ~= 0  then	--如果潮汐方清场了
			--全部潮汐英雄添加经验金钱
			KATA_HeroAddXPGold(DOTA_TEAM_BADGUYS,GAME_ROUND_COUNTDOWN)
			TIDEHUNTER_IS_ADDXP = true
			GameRules:SendCustomMessage("#Chat_tidehunter_getxp",DOTA_TEAM_BADGUYS, -1)
		end

		if GAME_TIME_S%90 == 0 and GAME_ROUND ~= 1 then	--游戏每过1.5分钟，提升小兵等级
			KUNKKA_LEVEL = KUNKKA_LEVEL +1
			TIDEHUNTER_LEVEL = TIDEHUNTER_LEVEL +1
		end

		return 1
	end,0)

end



function KATA_CreateUnitSystem()

		if KUNKKA_ADD_MINI + KUNKKA_ADD_BOSS <35 then --如果上限没到35只兵，则增加
			if GAME_ROUND%2 == 0 then
				KUNKKA_ADD_MINI = KUNKKA_ADD_MINI +2
				TIDEHUNTER_ADD_MINI = TIDEHUNTER_ADD_MINI +2
			else
				KUNKKA_ADD_MINI = KUNKKA_ADD_MINI +1
				KUNKKA_ADD_BOSS = KUNKKA_ADD_BOSS +1
				TIDEHUNTER_ADD_MINI = TIDEHUNTER_ADD_MINI +1
				TIDEHUNTER_ADD_BOSS = TIDEHUNTER_ADD_BOSS +1
			end
		end

		KATA_CreateUnit_Mini( KUNKKA_ADD_MINI - KUNKKA_ALIVE_MINI,"kunkka")
		KATA_CreateUnit_Boss( KUNKKA_ADD_BOSS - KUNKKA_ALIVE_BOSS,"kunkka")
		KATA_CreateUnit_Mini( TIDEHUNTER_ADD_MINI - TIDEHUNTER_ALIVE_MINI,"tidehunter")
		KATA_CreateUnit_Boss( TIDEHUNTER_ADD_BOSS - TIDEHUNTER_ALIVE_BOSS,"tidehunter")
end

-- --------------------------------------------------------------------------------
-- -- 生产单位系统
-- --------------------------------------------------------------------------------
-- function KATA_CreateUnitSystem()
-- 	--每隔0.5秒就创建单位
-- 	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("createunitsystem"),function() 
-- 		-- print( "[KATA] ===0.5!!!!=== Called" )
-- 		if KUNKKA_AMOUNT_ADD > 0 then  --如果昆卡添加数 大于0，则开始添加单位
-- 			if KUNKKA_AMOUNT_ALIVE < KUNKKA_ALIVE_MAX then --如果昆卡存活数 小于150。同时存活最大量
-- 				local add = KUNKKA_AMOUNT_ADD --生产量
-- 				if add >= KUNKKA_ALIVE_MAX-KUNKKA_AMOUNT_ALIVE then add = KUNKKA_ALIVE_MAX-KUNKKA_AMOUNT_ALIVE end
-- 				KATA_CreateUnit(add,"kunkka")
-- 			end
-- 			if TIDEHUNTER_ONE_TIME_DEATHS >= 40 then --超级兵
-- 				KATA_CreateUnit_super(1,"kunkka")
-- 			end
-- 			TIDEHUNTER_ONE_TIME_DEATHS = 0
-- 		end
-- 		if TIDEHUNTER_AMOUNT_ADD > 0 then
-- 			if TIDEHUNTER_AMOUNT_ALIVE < TIDEHUNTER_ALIVE_MAX then --如果潮汐存活数 小于150。同时存活最大量
-- 				local add = TIDEHUNTER_AMOUNT_ADD --生产量
-- 				if add >= TIDEHUNTER_ALIVE_MAX-TIDEHUNTER_AMOUNT_ALIVE then add = TIDEHUNTER_ALIVE_MAX-TIDEHUNTER_AMOUNT_ALIVE end
-- 				KATA_CreateUnit(add,"tidehunter")
-- 			end
-- 			if KUNKKA_ONE_TIME_DEATHS >= 40 then --超级兵
-- 				KATA_CreateUnit_super(1,"tidehunter")
-- 			end
-- 			KUNKKA_ONE_TIME_DEATHS = 0

-- 		end
-- 		GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS,TIDEHUNTER_AMOUNT_ALIVE)
-- 		GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS,KUNKKA_AMOUNT_ALIVE)
-- 		return 1
-- 	end,0)
	
-- end


--------------------------------------------------------------------------------
-- 创建单位
--------------------------------------------------------------------------------
function KATA_CreateUnit_Mini(add,who)

	if who == "kunkka" then
		for i=1,add do -- 开始添加
			local newunit = CreateUnitByName("npc_mini_kunkka", POS_SPAWNER_GOOD + RandomVector(100) , true, nil, nil, DOTA_TEAM_GOODGUYS )
			newunit:CreatureLevelUp(KUNKKA_LEVEL-1)
			KUNKKA_ALIVE_MINI	= KUNKKA_ALIVE_MINI + 1	--存活数量
			print( "[KATACreateUnit] ===KUNKKA===do: "..i.." ALIVE: "..KUNKKA_ALIVE_MINI.." ADD: "..KUNKKA_ADD_MINI.." add: "..add )
		end
	elseif who == "tidehunter" then
		for i=1,add do
			local newunit = CreateUnitByName("npc_mini_tidehunter", POS_SPAWNER_BAD + RandomVector(100) , true, nil, nil, DOTA_TEAM_BADGUYS )
			newunit:CreatureLevelUp(TIDEHUNTER_LEVEL-1)
			TIDEHUNTER_ALIVE_MINI	= TIDEHUNTER_ALIVE_MINI + 1	--存活数量
			print( "[KATACreateUnit] ===TIDEHUNTER===do: "..i.." ALIVE: "..TIDEHUNTER_ALIVE_MINI.." ADD: "..TIDEHUNTER_ADD_MINI.." add: "..add )
		end
	end
end

--------------------------------------------------------------------------------
-- 创建超级单位
--------------------------------------------------------------------------------
function KATA_CreateUnit_Boss(add,who)

	if who == "kunkka" then
		for i=1,add do -- 开始添加
			-- GameRules:SendCustomMessage("#Chat_onetime_kill_kunkka",DOTA_TEAM_BADGUYS, -1)
			local newunit = CreateUnitByName("npc_mini_kunkka", POS_SPAWNER_GOOD + RandomVector(RandomInt(100,250)) , true, nil, nil, DOTA_TEAM_GOODGUYS )
			newunit.IsBoss = true
			newunit:CreatureLevelUp(KUNKKA_LEVEL+5)
			newunit:SetModelScale(1.2)
			KATA_BossAddAbility(newunit)	--添加随机技能
			KUNKKA_ALIVE_BOSS	= KUNKKA_ALIVE_BOSS + 1	--存活数量
			print( "[KATACreateUnit] ===KUNKKA===do: "..i.." ALIVE: "..KUNKKA_ALIVE_BOSS.." ADD: "..KUNKKA_ADD_BOSS.." add: "..add )
		end
	elseif who == "tidehunter" then
		for i=1,add do
			-- GameRules:SendCustomMessage("#Chat_onetime_kill_tidehunter",DOTA_TEAM_GOODGUYS, -1)
			local newunit = CreateUnitByName("npc_mini_tidehunter", POS_SPAWNER_BAD + RandomVector(RandomInt(100,250)) , true, nil, nil, DOTA_TEAM_BADGUYS )
			newunit.IsBoss = true
			newunit:CreatureLevelUp(TIDEHUNTER_LEVEL+5)
			newunit:SetModelScale(0.8)
			KATA_BossAddAbility(newunit)	--添加随机技能
			TIDEHUNTER_ALIVE_BOSS	= TIDEHUNTER_ALIVE_BOSS + 1	--存活数量
			print( "[KATACreateUnit] ===TIDEHUNTER===do: "..i.." ALIVE: "..TIDEHUNTER_ALIVE_BOSS.." ADD: "..TIDEHUNTER_ADD_BOSS.." add: "..add )
		end
	end
end

--------------------------------------------------------------------------------
-- 为小精英兵添加随机技能
--------------------------------------------------------------------------------
function KATA_BossAddAbility(unit)
	local i = RandomInt(1,4)
	local abilityname 

	if i == 1 then
		abilityname = "boss_acid_spray"			--酸性喷雾
	elseif i == 2 then
		abilityname = "boss_slow_down"			--退化光环
	elseif i == 3 then
		abilityname = "boss_blow"				--重击
	elseif i == 4 then
		abilityname = "boss_spell_resistance"	--法术抵抗
	end

	unit:AddAbility(abilityname)

	for i=0,unit:GetAbilityCount()-1 do
		local ability = unit:GetAbilityByIndex(i)
		if ability then
			if ability:GetAbilityName() == abilityname then 
				ability:UpgradeAbility()
				print( "[KATABossAddAbility] ability: "..ability:GetAbilityName() )
			end
		end
	end


end
--------------------------------------------------------------------------------
-- 为英雄添加增加经验金钱（团队，剩余时间）
--------------------------------------------------------------------------------
function KATA_HeroAddXPGold(team,time)
	-- DOTA_TEAM_GOODGUYS,DOTA_TEAM_BADGUYS
	for playerid = 0 ,9 do
		if PlayerResource:GetPlayer(playerid) ~= nil then --如果玩家不为nil空
			if PlayerResource:GetTeam(playerid) == team then --如果玩家是那个团队
				if PlayerResource:GetPlayer(playerid):GetAssignedHero() ~= nil then
					local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero() --根据玩家ID获取英雄
					if not hero:HasAbility("dota_ability_get_xp") then
						hero:AddAbility("dota_ability_get_xp")
					end
					for i=0,hero:GetAbilityCount()-1 do
						local ability = hero:GetAbilityByIndex(i)
						if ability then
							if ability:GetAbilityName() == "dota_ability_get_xp" then 
								local ability_getxp = hero:GetAbilityByIndex(i)
								ability_getxp:ApplyDataDrivenModifier(hero, hero, "modifier_dota_ability_get_xp",{Duration=time}) --添加
								print( "[KATAHeroAddXPGold] ability_getxp: "..ability_getxp:GetAbilityName() )
							end
						end
					end
					
				end
			end
		end
	end
	
end

--------------------------------------------------------------------------------
-- 计算最后需要生成多少（击杀量，需杀多少，生成多少，最多生产数）,返 击杀量的剩余量，生产量
--------------------------------------------------------------------------------
function CUnit_count(todo,k,add,max)
	local ex = todo%k   --余数
	local use = todo-ex --使用量
	local cu = use/k*add --需要生成多少单位
	if cu > max then
		ex = todo - (max-max%add)/add --击杀量 - (最多生产数可消耗的击杀量)
		cu = max --惩罚，依然补充到最大量
		print( "[KATA] ===MAX=== ex:"..ex.." max:"..max )
	end

	return ex,cu
end


--------------------------------------------------------------------------------
-- 命令单位攻击移动到点
--------------------------------------------------------------------------------
function KATAAttackMoveToPos( target, pos )
	local newOrder = {
		UnitIndex = target:entindex(), 
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = pos, --Optional.  Only used when targeting the ground
		Queue = 0 --Optional.  Used for queueing up abilities
	}
	ExecuteOrderFromTable(newOrder)
end

--------------------------------------------------------------------------------
-- 测试
--------------------------------------------------------------------------------
function OnStopMove_Good( keys )
	-- print( "[KATA] ===stopmove!!=== ")
	local newOrder = {
		UnitIndex = keys.caster:entindex(), 
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = POS_SPAWNER_GOOD + RandomVector(500), --Optional.  Only used when targeting the ground
		Queue = 0 --Optional.  Used for queueing up abilities
	}
	ExecuteOrderFromTable(newOrder)
end

function OnStopMove_Bad( keys )
	-- print( "[KATA] ===stopmove!!=== ")
	local newOrder = {
		UnitIndex = keys.caster:entindex(), 
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = POS_SPAWNER_BAD + RandomVector(500), --Optional.  Only used when targeting the ground
		Queue = 0 --Optional.  Used for queueing up abilities
	}
	ExecuteOrderFromTable(newOrder)
end