--[[
		==Kunkka And Tidehunter Arena==
				 ==潮汐争霸==
		===============================
		Authors:
				F1rstDan
		===============================
]]

-- load everyhing
require('require_everything')


print( "Dota KataGameMode game mode loaded.")
print( "Dota KATAGameMode game mode loaded.")

function PrecacheEveryThingFromKV( context )
	local kv_files = {"scripts/npc/npc_units_custom.txt","scripts/npc/npc_abilities_custom.txt","scripts/npc/npc_heroes_custom.txt","scripts/npc/npc_abilities_override.txt","npc_items_custom.txt"}
	for _, kv in pairs(kv_files) do
		local kvs = LoadKeyValues(kv)
		if kvs then
			print("BEGIN TO PRECACHE RESOURCE FROM: ", kv)
			PrecacheEverythingFromTable( context, kvs)
		end
	end
end
function PrecacheEverythingFromTable( context, kvtable)
	for key, value in pairs(kvtable) do
		if type(value) == "table" then
			PrecacheEverythingFromTable( context, value )
		else
			if string.find(value, "vpcf") then
				PrecacheResource( "particle",  value, context)
				print("PRECACHE PARTICLE RESOURCE", value)
			end
			if string.find(value, "vmdl") then
				PrecacheResource( "model",  value, context)
				print("PRECACHE MODEL RESOURCE", value)
			end
			if string.find(value, "vsndevts") then
				PrecacheResource( "soundfile",  value, context)
				print("PRECACHE SOUND RESOURCE", value)
			end
		end
	end
end
function Precache( context )
	print("BEGIN TO PRECACHE RESOURCE")
	local time = GameRules:GetGameTime()
	PrecacheEveryThingFromKV( context )
	time = time - GameRules:GetGameTime()
	print("DONE PRECACHEING IN:"..tostring(time).."Seconds")

	-- PrecacheResource( "model", "models/heroes/kunkka/kunkka.vmdl", context )				--昆卡
	PrecacheResource( "model", "models/heroes/kunkka/kunkka_feet.vmdl", context )			--昆卡
	PrecacheResource( "model", "models/heroes/kunkka/kunkka_hair.vmdl", context )			--昆卡
	PrecacheResource( "model", "models/heroes/kunkka/kunkka_hands.vmdl", context )			--昆卡
	-- PrecacheResource( "model", "models/heroes/tidehunter/tidehunter.vmdl", context )		--潮汐
	PrecacheResource( "model", "models/heroes/tidehunter/tidehunter_anchor.vmdl", context )	--潮汐

	--=========物品
	PrecacheResource( "particle_folder", "particles/econ/courier/courier_cluckles", context )	--传送口哨
	PrecacheResource( "particle_folder", "particles/econ/courier/courier_drodo", context )		--传送口哨
	PrecacheResource( "soundfile", "soundevents/game_sounds_greevils.vsndevts", context )		--传送口哨 预载声音文件

	--=========技能
	PrecacheResource( "particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context )	--额外金币
	PrecacheResource( "soundfile", "soundevents/game_sounds_ui.vsndevts", context )										--额外金币

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_pugna", context )						--小精灵大招吸血
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context )	--小精灵大招吸血

	PrecacheResource( "particle_folder", "particles/units/heroes/hero_crystalmaiden", context )				--卓尔游侠用冰女特效
	PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )						--卓尔游侠用斧王特效
end

-- function Precache( context )
-- 	--[[
-- 		Precache things we know we'll use.  Possible file types include (but not limited to):
-- 			PrecacheResource( "model", "*.vmdl", context )
-- 			PrecacheResource( "soundfile", "*.vsndevts", context )
-- 			PrecacheResource( "particle", "*.vpcf", context )
-- 			PrecacheResource( "particle_folder", "particles/folder", context )
-- 	]]
-- 	--=========单位
--     PrecacheResource( "model", "models/heroes/kunkka/kunkka.vmdl", context )		--昆卡
--     PrecacheResource( "model", "models/heroes/kunkka/kunkka_feet.vmdl", context )	--昆卡
--     PrecacheResource( "model", "models/heroes/kunkka/kunkka_hair.vmdl", context )	--昆卡
--     PrecacheResource( "model", "models/heroes/kunkka/kunkka_hands.vmdl", context )	--昆卡
--     PrecacheResource( "model", "models/heroes/tidehunter/tidehunter.vmdl", context )		--潮汐
--     PrecacheResource( "model", "models/heroes/tidehunter/tidehunter_anchor.vmdl", context )	--潮汐
--     PrecacheResource( "model", "models/ghostanim.vmdl", context ) --空盒子

--     PrecacheResource( "particle_folder", "particles/units/heroes/hero_alchemist/", context )		--小Boss，酸性喷雾，炼金
--     PrecacheResource( "particle_folder", "particles/units/heroes/hero_omniknight/", context )		--小Boss，退化光环，全能骑士
--     PrecacheResource( "particle_folder", "particles/units/heroes/hero_magnataur/", context )		--小Boss，重击，猛犸

--     PrecacheResource( "model", "models/creeps/neutral_creeps/n_creep_gnoll/n_creep_gnoll_frost.vmdl", context )	--豺狼人刺客

--     --=========物品
--     PrecacheItemByNameSync( "item_tombstone", context )			--复活墓碑
--     PrecacheResource( "model", "models/heroes/juggernaut/jugg_healing_ward.mdl", context )		--治疗守卫
--     PrecacheResource( "particle_folder", "particles/units/heroes/hero_juggernaut", context )	--治疗守卫
--     PrecacheResource( "particle_folder", "particles/econ/courier/courier_cluckles", context )	--传送口哨
--     PrecacheResource( "particle_folder", "particles/econ/courier/courier_drodo", context )		--传送口哨
--     PrecacheResource( "soundfile", "soundevents/game_sounds_greevils.vsndevts", context )		--传送口哨 预载声音文件
--     --=========提升单位物品
--     -- PrecacheResource( "particle_folder", "particles/base_attacks/", context )		--提升我方单位攻击力

--     --=========技能
--     PrecacheResource( "particle", "particles/econ/courier/courier_golden_roshan/golden_roshan_ambient.vpcf", context )	--额外金币
--     PrecacheResource( "soundfile", "soundevents/game_sounds_ui.vsndevts", context )										--额外金币

-- 		PrecacheResource( "particle_folder", "particles/units/heroes/hero_pugna", context )						--小精灵大招吸血
-- 		PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context )	--小精灵大招吸血

-- 		PrecacheResource( "particle_folder", "particles/units/heroes/hero_crystalmaiden", context )				--卓尔游侠用冰女特效
-- 		PrecacheResource( "particle_folder", "particles/units/heroes/hero_axe", context )						--卓尔游侠用斧王特效
-- 	end

--------------------------------------------------------------------------------

if KATAGameMode == nil then
	KATAGameMode = class({})
end

--------------------------------------------------------------------------------
-- ACTIVATE 激活
--------------------------------------------------------------------------------
function Activate()
    KATAGameMode:InitGameMode()
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function KATAGameMode:InitGameMode()

	GameRules:SetUseCustomHeroXPValues (true) 					--使用自定义经验
	GameRules:GetGameModeEntity():SetUseCustomHeroLevels(true) 	--使用自定义等级
	GameRules:GetGameModeEntity():SetCustomHeroMaxLevel( CUSTOM_MAX_LEVEL ) 	--最高等级60级
	GameRules:GetGameModeEntity():SetCustomXPRequiredToReachNextLevel( CUSTOM_XP_TABLE ) --定义等级表
	-- GameRules:SetHeroRespawnEnabled( false )					--英雄是否使用默认重生
	GameRules:GetGameModeEntity():SetBuybackEnabled( false )	--是否可以买活

	GameRules:SetHeroSelectionTime(TIME_HERO_SELECTION)			--选择英雄时间
	GameRules:SetPreGameTime(TIME_PRE_GAME)						--准备时间
	GameRules:SetSameHeroSelectionEnabled( true )				--复选英雄

	--物品购买事件
	ItemShopSystem:RegistEvents() --商店系统
	--单位死亡事件
	CreateUnitSystem:RegistEvents() --死亡和生产单位系统
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( KATAGameMode, 'OnEntityKilled' ), self ) --死亡墓碑
	--游戏状态改变事件
	ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( KATAGameMode, "OnGameRulesStateChange" ), self )
	-- GameRules:GetGameModeEntity():SetThink( "OnThink", self, "GlobalThink", TIME_PRE_GAME ) --游戏正在开始的一刻
	--玩家进入游戏事件
	-- ListenToGameEvent( "player_spawn", Dynamic_Wrap( KATAGameMode, "OnPlayerSpawn" ), self )
	User:RegistEvents()

	--英雄出生时，给予物品
	ListenToGameEvent( "npc_spawned", Dynamic_Wrap( KATAGameMode, "OnNPCSpawned" ), self )

	--计分板
	GameRules:GetGameModeEntity():SetThink( "UpdateScoreboard", self, 1 )

	--弹框告诉玩法
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("showhowtoplay"),function()
			ShowGenericPopup("#gametitle", "#gamecontent", "unknown1", "unknown2", 2)
			return nil
	end,1)
end

--------------------------------------------------------------------------------
-- 玩家进入游戏事件
--------------------------------------------------------------------------------
function KATAGameMode:OnPlayerSpawn( event )
	local userid = event.userid
	-- local player = PlayerResource:GetPlayer(event.userid -1)
	local SteamID = PlayerResource:GetSteamAccountID(userid)
	print( '[KATA_OnPlayerSpawn] OnPlayerSpawn'..event.userid )
	print( '[KATA_OnPlayerSpawn] SteamAccountID = '..PlayerResource:GetSteamAccountID(userid -1) )
	print( '[KATA_OnPlayerSpawn] SteamAccountID = '..PlayerResource:GetSteamAccountID(userid) )

	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("show"),function()
			for i=0,10 do
				print( '[KATA_OnPlayerSpawn] SteamAccountID'..'['..i..'] = '..PlayerResource:GetSteamAccountID(i) )
				-- Say(PlayerResource:GetPlayer(20), '[KATA_OnPlayerSpawn] SteamAccountID'..'['..i..'] = '..PlayerResource:GetSteamAccountID(i), false)
			end
			return nil
	end,1)
end


--------------------------------------------------------------------------------
-- 英雄出生时 给予物品，升级技能
--------------------------------------------------------------------------------
function KATAGameMode:OnNPCSpawned( event )
	local spawnedUnit = EntIndexToHScript( event.entindex )
	if not spawnedUnit or spawnedUnit:IsPhantom() then
		return
	end

	if spawnedUnit:IsRealHero() and not spawnedUnit.additem then -- 如果单位没用拿过物品
		print( '[KATA] give item' )
		-- local newItem = CreateItem("item_kata_salve", spawnedUnit, spawnedUnit) --药膏
		-- newItem:SetPurchaseTime(-10)
		-- spawnedUnit:AddItem(newItem)
		-- local newItem = CreateItem("item_kata_clarity", spawnedUnit, spawnedUnit) --净化药水
		-- newItem:SetPurchaseTime(-10)
		-- spawnedUnit:AddItem(newItem)
		local newItem = CreateItem("item_kata_whistle", spawnedUnit, spawnedUnit) --传送之笛
		newItem:SetPurchaseTime(-10)
		spawnedUnit:AddItem(newItem)
		-- local newItem = CreateItem("item_aegis", spawnedUnit, spawnedUnit) --不朽之守护
		-- newItem:SetPurchaseTime(-10) --购买时间(可原价出售时间)，原10秒
		-- newItem:SetCurrentCharges(0) --设置成0使用次数，使其出售价格为0
		-- spawnedUnit:AddItem(newItem)

		spawnedUnit.additem = true --设置单位已经拿过物品了。免得重生又获得一次

		--给英雄所有普通技能添加一级，除大招和黄点
		spawnedUnit:SetAbilityPoints(0)		--设置英雄的升级点为0
		for i=0,spawnedUnit:GetAbilityCount()-1 do
			local ability = spawnedUnit:GetAbilityByIndex(i)
			if ability then
				if ability:GetAbilityType() == 0 then 	--AbilityType, 普通技能=0, 大招技能=1, 属性技能=2
					-- ability:UpgradeAbility()
					ability:SetLevel(1)
				end
				print( "[KATAAddAbility] ability= "..ability:GetAbilityName().." ,AbilityType= "..ability:GetAbilityType() )
			end
		end
	end
end

--------------------------------------------------------------------------------
-- 真正游戏开始的一刻
--------------------------------------------------------------------------------
-- TIME_HEHE = 15.0
-- function KATAGameMode:OnThink()
-- 	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
-- 		print( '[KATA] Play Game!!' )
-- 		KATA_ADD_AMOUN( 1,1 )
-- 		-- GameRules:ResetToHeroSelection() --所有人重新选择英雄
-- 		return nil
-- 	-- elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_POST_GAME then
-- 	-- 	return nil
-- 	end
-- 	TIME_HEHE = TIME_HEHE + 0.1
-- 	print( '[KATA] TIME: '..TIME_HEHE )
--     return 0.1
-- end
--------------------------------------------------------------------------------
-- 游戏正式开始时
--------------------------------------------------------------------------------
GAME_BEFORE_TIME = 0
function KATAGameMode:OnGameRulesStateChange()
	local nNewState = GameRules:State_Get()
	GOODGUYS_AI = false
	BADGUYS_AI = false
	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then --游戏开始
		SetGameBeforeTime()
		GAME_BEFORE_TIME = math.floor( GameRules:GetGameTime() )
		print( "[KATA] GetGameTime addon = "..GAME_BEFORE_TIME)
		KATAGameMode:PlayGame() -- 初始化+AI
		KATA_CreateUnitSystem() -- 激活创建单位系统
	end
end

--------------------------------------------------------------------------------
-- 英雄死亡后，队友可帮助复活
--------------------------------------------------------------------------------
function KATAGameMode:OnEntityKilled( event )
	local killedUnit = EntIndexToHScript( event.entindex_killed )

	if killedUnit:GetUnitName() == "npc_kunkka_boss" then
		-- GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
		KATAGameMode:AgainGame("tidehunter")
	elseif killedUnit:GetUnitName() == "npc_tidehunter_boss" then
		-- GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
		KATAGameMode:AgainGame("kunkka")
	end

	if killedUnit and killedUnit:IsRealHero() then
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("creat_item_tombstone"),function() 
			-- 进行胜负判定
			print( '[KATA=win=] GetPlayerID = '..killedUnit:GetPlayerID() )
			-- if killedUnit:GetPlayerID() >=0 and killedUnit:GetPlayerID() <=9 then --10位玩家
				local goodguy_hero_alive = 0
				local badguy_hero_alive = 0
				for playerid = 0 ,9 do
					if PlayerResource:GetPlayer(playerid) ~= nil then --如果玩家不为nil空
						print( '[KATA=win=] in for playerid = '..playerid)
						if PlayerResource:GetPlayer(playerid):GetAssignedHero() ~= nil then --如果玩家英雄不为nil空
							local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero() --根据玩家ID获取英雄
							local hero_respawntime = PlayerResource:GetRespawnSeconds(playerid) --获取英雄复活时间，判定是否正在使用 不朽之守护 复活中
							if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
								print( '[KATA=win=] in for playerid = '..playerid..', is goodguys')
								if hero:IsAlive() then
									print( '[KATA=win=] goodguys+1, alive')
									goodguy_hero_alive = goodguy_hero_alive + 1
								elseif hero_respawntime <=5 and hero_respawntime >0 then
									print( '[KATA=win=] goodguys+1, item_aegis')
									goodguy_hero_alive = goodguy_hero_alive + 1			
								end
							elseif hero:GetTeam() == DOTA_TEAM_BADGUYS then
								print( '[KATA=win=] in for playerid = '..playerid..', is badguys')
								if hero:IsAlive() then
									print( '[KATA=win=] badguy+1, alive')
									badguy_hero_alive = badguy_hero_alive + 1
								elseif hero_respawntime <=5 and hero_respawntime >0 then
									print( '[KATA=win=] badguy+1, item_aegis')
									badguy_hero_alive = badguy_hero_alive + 1
								end
							end
						end
					end
				end
				if goodguy_hero_alive == 0 and not GOODGUYS_AI then
					-- GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
					KATAGameMode:AgainGame("tidehunter")
					print( '[KATA=win=] BADGUYS WIN !!!!!! ')
				elseif badguy_hero_alive == 0 and not BADGUYS_AI then
					-- GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
					KATAGameMode:AgainGame("kunkka")
					print( '[KATA=win=] GOODGUYS WIN !!!!!! ')
				end
			-- end

			-- 如果英雄身上有不朽之守护，则不产生复活墓碑 并退出函数
			local respawntime = PlayerResource:GetRespawnSeconds(killedUnit:GetPlayerID()) --获取英雄复活时间
			if respawntime <=5 and respawntime >0 then
				print( '[KATA] respawnseconds = '..respawntime )
				return
			else
				print( '[KATA] respawnseconds = '..respawntime )
				local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )	--创建墓碑物品
				newItem:SetPurchaseTime( 0 )		--设置墓碑购买时间为0
				newItem:SetPurchaser( killedUnit )	--设置墓碑所属为死亡单位
				local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )	--从表同步生成实体？
				tombstone:SetContainedItem( newItem )	--tombstone包含墓碑物品
				tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )	--设置角度
				FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true )	--找到明确的空间单位
			end
			return nil
		end,0.2)
	end

end



--------------------------------------------------------------------------------
-- 初始化+AI
--------------------------------------------------------------------------------
function KATAGameMode:PlayGame()
		print( '[KATA] Play Game!!' )
		CreateUnitSystem:Begin() -- 初始化

		-- 判断是否有一方是空的
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
		if goodguy_player == 0 then
			print( '[KATA_AI] GOODGUYS_AI!!' )
			GOODGUYS_AI = true
			local newunit = CreateUnitByName("npc_kunkka_boss", Entities:FindByName(nil,"Spawner_bad"):GetAbsOrigin() + RandomVector(500) , true, nil, nil, DOTA_TEAM_GOODGUYS )
		elseif badguy_player == 0 then
			print( '[KATA_AI] BADGUYS_AI!!' )
			BADGUYS_AI = true	
			local newunit = CreateUnitByName("npc_tidehunter_boss", Entities:FindByName(nil,"Spawner_good"):GetAbsOrigin() + RandomVector(500) , true, nil, nil, DOTA_TEAM_BADGUYS )
		end	
end

KUNKKA_WIN = 0
TIDEHUNTER_WIN = 0
--------------------------------------------------------------------------------
-- 游戏重新开始
--------------------------------------------------------------------------------
function KATAGameMode:AgainGame(team)
	print( '[KATAAgainGame]')

	KataConstants() -- 常量初始化

	if team == "tidehunter" then
		GameRules:SendCustomMessage("#Chat_tidehunter_win",0, 0)
		TIDEHUNTER_WIN = TIDEHUNTER_WIN +1
		if TIDEHUNTER_WIN >= 3 then
			GameRules:SetGameWinner(DOTA_TEAM_BADGUYS)
			return
		end
	else
		GameRules:SendCustomMessage("#Chat_kunkka_win",0, 0)
		KUNKKA_WIN = KUNKKA_WIN +1
		if KUNKKA_WIN >= 3 then
			GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			return
		end
	end

	KATAGameMode:RemoveAllUnit() --删除所有普通单位

	--倒数，15秒后重新选择英雄，重新开始游戏
	AGAIN_GAME_TIME = math.floor( GameRules:GetGameTime() )
	AGAIN_GAME_LAST_RECIPROCAL = 15 --记录上一次倒数时间，这样游戏暂停不会反复出现倒数
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("AgainGame"),
		function()
			local nowtime = math.floor( GameRules:GetGameTime() )
			local reciprocal = 15 -(nowtime - AGAIN_GAME_TIME)
			if reciprocal <= 0 then 	--倒数到0，并 
				GameRules:ResetToHeroSelection()--重新选择英雄
				KATAGameMode:RemoveAllItem()--删除所有物品
				KATAGameMode:RemoveAllUnit()--删除所有普通单位
				for playerid = 0 ,9 do
					if PlayerResource:GetPlayer(playerid) ~= nil then 	--如果玩家不为nil空
						PlayerResource:SetGold(playerid,600,false)		--不可靠金钱为300
						PlayerResource:SetGold(playerid,0,true)			--可靠金钱为0
						for i = 0,11 do		--0~5是英雄的物品栏，6~11是英雄储藏处
							if PlayerResource:GetPlayer(playerid):GetAssignedHero() ~= nil then
								local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero() --根据玩家ID获取英雄
								if hero:GetItemInSlot(i) ~= nil then --防止 “空值” 而出错
									local item = hero:GetItemInSlot(i)
									item:RemoveSelf()	--删除购买的物品
								end
							end
						end
					end
				end
				return nil
			else
				if AGAIN_GAME_LAST_RECIPROCAL - reciprocal ~= 0 then 		--游戏暂停则不会反复出现倒数,~= 0
					Say(PlayerResource:GetPlayer(20), reciprocal.."...", false)
					AGAIN_GAME_LAST_RECIPROCAL = reciprocal
				end
			end
		return 1
		end,
		1)


	--获取生存的英雄 
	local alivehero
	for playerid = 0 ,9 do
		if PlayerResource:GetPlayer(playerid) ~= nil then --如果玩家不为nil空
			if PlayerResource:GetPlayer(playerid):GetAssignedHero() ~= nil then
				local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero() --根据玩家ID获取英雄
				if hero:IsAlive() then
					alivehero = hero
				end
			end
		end
	end
	--镜头定位到英雄
	for playerid = 0 ,9 do
		if PlayerResource:GetPlayer(playerid) ~= nil then --如果玩家不为nil空
			PlayerResource:SetCameraTarget(playerid,alivehero)	--镜头定位到英雄
				-- 1.5秒后取消镜头锁定
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("offCamera"),
				function()
					PlayerResource:SetCameraTarget(playerid,nil)
				return nil
				end,
				1.5)
		end
	end

	--15秒后重新选择英雄，重新开始游戏
	-- GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("AgainGame"),
	-- 	function()
	-- 		GameRules:ResetToHeroSelection()--重新选择英雄
	-- 		KATAGameMode:RemoveAllItem()--删除所有物品
	-- 		KATAGameMode:RemoveAllUnit()--删除所有普通单位
	-- 		for playerid = 0 ,9 do
	-- 			if PlayerResource:GetPlayer(playerid) ~= nil then 	--如果玩家不为nil空
	-- 				PlayerResource:SetGold(playerid,600,false)		--不可靠金钱为300
	-- 				PlayerResource:SetGold(playerid,0,true)			--可靠金钱为0
	-- 				for i = 0,11 do		--0~5是英雄的物品栏，6~11是英雄储藏处
	-- 					if PlayerResource:GetPlayer(playerid):GetAssignedHero() ~= nil then
	-- 						local hero = PlayerResource:GetPlayer(playerid):GetAssignedHero() --根据玩家ID获取英雄
	-- 						if hero:GetItemInSlot(i) ~= nil then --防止 “空值” 而出错
	-- 							local item = hero:GetItemInSlot(i)
	-- 							item:RemoveSelf()	--删除购买的物品
	-- 						end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	return nil
	-- 	end,
	-- 	15)

end

--------------------------------------------------------------------------------
-- 删除所有普通单位
--------------------------------------------------------------------------------
function KATAGameMode:RemoveAllUnit()

	local unit_table_g = FindUnitsInRadius(	DOTA_TEAM_GOODGUYS,
											Vector(0, 0, 0),
											nil,
											FIND_UNITS_EVERYWHERE,
											DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											DOTA_UNIT_TARGET_ALL,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
	local unit_table_b = FindUnitsInRadius(	DOTA_TEAM_BADGUYS,
											Vector(0, 0, 0),
											nil,
											FIND_UNITS_EVERYWHERE,
											DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											DOTA_UNIT_TARGET_ALL,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)

	for _,unit in pairs(unit_table_g) do
		print( '[KATAAgainGame] goodguy GetUnitName = '..unit:GetUnitName() )
		if not unit:IsRealHero() and unit:GetUnitName() ~= "npc_kunkka_Animation" then
			unit:RemoveSelf()
		end
	end
	for _,unit in pairs(unit_table_b) do
		print( '[KATAAgainGame] badguy GetUnitName = '..unit:GetUnitName() )
		if not unit:IsRealHero() and unit:GetUnitName() ~= "npc_tidehunter_Animation" then
			unit:RemoveSelf()
		end
	end

end

--------------------------------------------------------------------------------
-- 删除所有物品
--------------------------------------------------------------------------------
function KATAGameMode:RemoveAllItem()
	local item_table = Entities:FindAllByClassname("dota_item_tombstone_drop")
	local item_table_drop = Entities:FindAllByClassname("dota_item_drop")


	for _,item in pairs(item_table) do
		print( '[KATAAgainGame] item_tombstone GetName = '..item:GetName() )
		item:RemoveSelf()
	end

	for _,item in pairs(item_table_drop) do
		print( '[KATAAgainGame] drop item GetName = '..item:GetName() )
		item:RemoveSelf()
	end

end


---------------------------------------------------------------------------
-- Simple scoreboard using debug text 计分板
---------------------------------------------------------------------------
function KATAGameMode:UpdateScoreboard()

	---------------------------------------------------------------------------
	-- 旧版的简易计分板
	---------------------------------------------------------------------------
	-- UTIL_ResetMessageTextAll()
	-- UTIL_MessageTextAll_WithContext( "#ScoreboardRound", 255, 255, 255, 150, {  value = GAME_ROUND } ) --回合数
	-- if GAME_ROUND_COUNTDOWN < 0 then
	-- 	UTIL_MessageTextAll_WithContext( "#ScoreboardTime", 255, 255, 255, 150, {  value = 0 } )
	-- else
	-- 	UTIL_MessageTextAll_WithContext( "#ScoreboardTime", 255, 255, 255, 150, {  value = GAME_ROUND_COUNTDOWN } )--回合倒数时间 --value = GAME_ROUND ,
	-- end
	-- UTIL_MessageTextAll_WithContext( "#ScoreboardTitle_kunkka", 50, 220, 230, 255, { value = KUNKKA_WIN } )
	-- UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 80 )
	-- UTIL_MessageTextAll_WithContext( "#ScoreboardRow_mini", 50, 220, 230, 150, { value = TIDEHUNTER_ALIVE_MINI } )
	-- UTIL_MessageTextAll_WithContext( "#ScoreboardRow_boss", 50, 220, 230, 150, { value = TIDEHUNTER_ALIVE_BOSS } )
	-- UTIL_MessageTextAll_WithContext( "#ScoreboardRow_level", 50, 220, 230, 150, { value = TIDEHUNTER_LEVEL } )
	-- UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 80 )

	-- UTIL_MessageTextAll_WithContext( "#ScoreboardTitle_tidehunter", 50, 230, 150, 255, { value = TIDEHUNTER_WIN } )
	-- UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 80 )
	-- UTIL_MessageTextAll_WithContext( "#ScoreboardRow_mini", 50, 230, 150, 150, { value = KUNKKA_ALIVE_MINI } )
	-- UTIL_MessageTextAll_WithContext( "#ScoreboardRow_boss", 50, 230, 150, 150, { value = KUNKKA_ALIVE_BOSS } )
	-- UTIL_MessageTextAll_WithContext( "#ScoreboardRow_level", 50, 230, 150, 150, { value = KUNKKA_LEVEL } )
	-- UTIL_MessageTextAll( "#ScoreboardSeparator", 255, 255, 255, 80 )

	-- 显示存活数,在队伍得分上
	-- GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, TIDEHUNTER_ALIVE_MINI + TIDEHUNTER_ALIVE_BOSS )
	-- GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, KUNKKA_ALIVE_MINI + KUNKKA_ALIVE_BOSS)
	---------------------------------------------------------------------------
	---------------------------------------------------------------------------

	-- AS传送数据，用UI显示计分板
	local KATASummary = {
		nRoundNumber = GAME_ROUND,
		nKunkkaAlive = KUNKKA_ALIVE_MINI + KUNKKA_ALIVE_BOSS,
		nKunkkaLevel = KUNKKA_LEVEL,
		nTidehunterAlive = TIDEHUNTER_ALIVE_MINI + TIDEHUNTER_ALIVE_BOSS,
		nTidehunterLevel = TIDEHUNTER_LEVEL,
		nRoundTimePercent = GAME_ROUND_COUNTDOWN/30
	}
	FireGameEvent( "KATA_Summary", KATASummary )
	-- 显示队伍得分
	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_GOODGUYS, KUNKKA_WIN )
	GameRules:GetGameModeEntity():SetTopBarTeamValue(DOTA_TEAM_BADGUYS, TIDEHUNTER_WIN)

	return 0.5
end
