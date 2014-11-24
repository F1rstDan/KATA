
ItemShopSystem = {}
print( "[KATA] ===ItemShopSystem=== Called" )
--------------------------------------------------------------------------------
-- ACTIVATE 激活
--------------------------------------------------------------------------------
function ItemShopSystem:RegistEvents()
    --物品购买事件
	ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(ItemShopSystem, 'OnItemPurchased'), self)

	POS_SPAWNER_GOOD = Entities:FindByName(nil,"Spawner_good"):GetAbsOrigin()
	POS_SPAWNER_BAD = Entities:FindByName(nil,"Spawner_bad"):GetAbsOrigin()
	POS_SIDE_GOOD = Entities:FindByName(nil,"Side_good"):GetAbsOrigin()
	POS_SIDE_BAD = Entities:FindByName(nil,"Side_bad"):GetAbsOrigin()
	POS_SECRET_GOOD = Entities:FindByName(nil,"Secret_good"):GetAbsOrigin()
	POS_SECRET_BAD = Entities:FindByName(nil,"Secret_bad"):GetAbsOrigin()

	local unit_table = FindUnitsInRadius(	DOTA_TEAM_GOODGUYS,
											Vector(0, 0, 0),
											nil,
											FIND_UNITS_EVERYWHERE,
											DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											DOTA_UNIT_TARGET_ALL,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
	for _,unit in pairs(unit_table) do
		print( '[KATA] GetUnitName = '..unit:GetUnitName() )
		if unit:GetUnitName() == "npc_kunkka_Animation" then
			KUNKKA_Animation = unit
		elseif unit:GetUnitName() == "npc_tidehunter_Animation" then
			TIDEHUNTER_Animation = unit
		end
	end
	local unit_table = FindUnitsInRadius(	DOTA_TEAM_BADGUYS,
											Vector(0, 0, 0),
											nil,
											FIND_UNITS_EVERYWHERE,
											DOTA_UNIT_TARGET_TEAM_FRIENDLY,
											DOTA_UNIT_TARGET_ALL,
											DOTA_UNIT_TARGET_FLAG_NONE,
											FIND_ANY_ORDER,
											false)
	for _,unit in pairs(unit_table) do
		print( '[KATA] GetUnitName = '..unit:GetUnitName() )
		if unit:GetUnitName() == "npc_kunkka_Animation" then
			KUNKKA_Animation = unit
		elseif unit:GetUnitName() == "npc_tidehunter_Animation" then
			TIDEHUNTER_Animation = unit
		end
	end

end


--------------------------------------------------------------------------------
-- 购买物品事件
--------------------------------------------------------------------------------
function ItemShopSystem:OnItemPurchased( keys )
	print( '[KATA] OnItemPurchase Called' )
	print( '[KATA_itemP] PlayerID = '..keys.PlayerID )
	print( '[KATA_itemP] itemname = '..keys.itemname )
	print( '[KATA_itemP] itemcost = '..keys.itemcost )

	local hero = PlayerResource:GetPlayer(keys.PlayerID):GetAssignedHero() --根据玩家ID获取英雄
	local itemPurchase 
		for i = 0,11 do		--0~5是英雄的物品栏，6~11是英雄储藏处
			if hero:GetItemInSlot(i) ~= nil then --防止 “赋予空值” 而出错
				local item = hero:GetItemInSlot(i)
				print( '[KATA_itemP] item['..i..']= '..hero:GetItemInSlot(i):GetAbilityName() )
				if item:GetAbilityName() == keys.itemname then		--GetAbilityName()和GetName()都可以
					itemPurchase = item  --获取到购买的物品
				end
			end
		end
	local In_Side = false
	local In_Secret = false
	if hero:IsPositionInRange(POS_SIDE_GOOD,700.0) or hero:IsPositionInRange(POS_SIDE_BAD,700.0) then
		In_Side = true
	elseif hero:IsPositionInRange(POS_SECRET_GOOD,700.0) or hero:IsPositionInRange(POS_SECRET_BAD,700.0) then
		In_Secret = true
	end
	print( '[KATA_itemP] hero = '..hero:GetName() )

	--=====================================================
	--==============在边路商店购买增强单位物品==============
		local modifier_name
		--====购买加强攻击
		if keys.itemname == "item_kata_unit_attack" then
			if In_Side then
				modifier_name = "Modifiers_item_kata_unit_attack_area"
			else --不在边路商店就卖回去
				hero:SellItem(itemPurchase)
			end
		--====购买生命吸取，吸血
		elseif keys.itemname == "item_kata_unit_lifesteal" then
			if In_Side then
				modifier_name = "Modifiers_item_kata_unit_lifesteal_area"
			else --不在边路商店就卖回去
				hero:SellItem(itemPurchase)
			end
		--====购买生命回复，加速恢复
		elseif keys.itemname == "item_kata_unit_health_regen" then
			if In_Side then
				modifier_name = "Modifiers_item_kata_unit_health_regen_area"
			else --不在边路商店就卖回去
				hero:SellItem(itemPurchase)
			end
		--====购买加速移动
		elseif keys.itemname == "item_kata_unit_movespeed" then
			if In_Side then
				modifier_name = "Modifiers_item_kata_unit_movespeed_area"
			else --不在边路商店就卖回去
				hero:SellItem(itemPurchase)
			end
		end

		if modifier_name then
			if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
				itemPurchase:ApplyDataDrivenModifier(hero, KUNKKA_Animation, modifier_name,{Duration=45})
			else
				itemPurchase:ApplyDataDrivenModifier(hero, TIDEHUNTER_Animation, modifier_name,{Duration=45})
			end
			itemPurchase:RemoveSelf()	--删除购买的物品
		end

	--=====================================================
	--==============如果购买物品=提升我方单位等级==============
	if keys.itemname == "item_kata_unit_up" then
		itemPurchase:RemoveSelf()	--删除购买的物品

		-- 必须在边路商店旁边
		if In_Side then
			if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
				KUNKKA_LEVEL = KUNKKA_LEVEL +3
			else
				TIDEHUNTER_LEVEL = TIDEHUNTER_LEVEL +3
			end
		else
			local additemcost = PlayerResource:GetGold(keys.PlayerID) + keys.itemcost
			print( '[KATA_itemP] additemcost = '..additemcost )
			PlayerResource:SetGold(keys.PlayerID,additemcost,false)
			-- 返回金钱
		end
	end

	--=====================================================
	--==============如果购买物品=雇佣兵 豺狼人刺客==============
	if keys.itemname == "item_npc_gnoll_assassin" then
		itemPurchase:RemoveSelf()	--删除购买的物品

		-- 必须在边路商店旁边
		if In_Side then
			if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
				local newunit = CreateUnitByName("npc_gnoll_assassin", POS_SPAWNER_GOOD, true, nil, nil, DOTA_TEAM_GOODGUYS )
				newunit:CreatureLevelUp(KUNKKA_LEVEL-1)
			else
				local newunit = CreateUnitByName("npc_gnoll_assassin", POS_SPAWNER_BAD, true, nil, nil, DOTA_TEAM_BADGUYS )
				newunit:CreatureLevelUp(TIDEHUNTER_LEVEL-1)
			end
		else
			local additemcost = PlayerResource:GetGold(keys.PlayerID) + keys.itemcost
			print( '[KATA_itemP] additemcost = '..additemcost )
			PlayerResource:SetGold(keys.PlayerID,additemcost,false)
			-- 返回金钱
		end
	end
	--=====================================================
	--==============如果购买物品=雇佣兵 石头人 远古岩石傀儡==============
	if keys.itemname == "item_npc_rock_golem" then
		itemPurchase:RemoveSelf()	--删除购买的物品

		-- 必须在边路商店旁边
		if In_Side then
			if hero:GetTeam() == DOTA_TEAM_GOODGUYS then
				local newunit = CreateUnitByName("npc_rock_golem", POS_SPAWNER_GOOD, true, nil, nil, DOTA_TEAM_GOODGUYS )
				newunit:CreatureLevelUp(KUNKKA_LEVEL-1)
			else
				local newunit = CreateUnitByName("npc_rock_golem", POS_SPAWNER_BAD, true, nil, nil, DOTA_TEAM_BADGUYS )
				newunit:CreatureLevelUp(TIDEHUNTER_LEVEL-1)
			end
		else
			local additemcost = PlayerResource:GetGold(keys.PlayerID) + keys.itemcost
			print( '[KATA_itemP] additemcost = '..additemcost )
			PlayerResource:SetGold(keys.PlayerID,additemcost,false)
			-- 返回金钱
		end
	end


	--=====================================================
	--==============如果购买物品=快高长大蘑菇==============
	if keys.itemname == "item_kata_mushroom" then
		itemPurchase:RemoveSelf()	--删除购买的物品

		-- 必须在边路商店旁边
		if In_Side then
			print( '[KATA_itemP] inininin')
			-- 如果英雄不等于60级，给予下一等级的经验
			if hero:GetLevel() ~= 60 then
				local addexp = ( hero:GetLevel()+1 )*100
				print( '[KATA_itemP] lvlupexp = '..addexp )
				hero:AddExperience(addexp, false)
			else
				local additemcost = PlayerResource:GetGold(keys.PlayerID) + keys.itemcost
				print( '[KATA_itemP] additemcost = '..additemcost )
				PlayerResource:SetGold(keys.PlayerID,additemcost,false)
				-- 返回金钱
			end
		else
			local additemcost = PlayerResource:GetGold(keys.PlayerID) + keys.itemcost
			print( '[KATA_itemP] additemcost = '..additemcost )
			PlayerResource:SetGold(keys.PlayerID,additemcost,false)
			-- 返回金钱
		end
	end
	--=========================================================
	--==============如果购买物品= 传送到 秘密商店==============
	if keys.itemname == "item_kata_gotoSecret" then
		itemPurchase:RemoveSelf()	--删除购买的物品

		-- 必须在边路商店旁边
		if hero:IsPositionInRange(POS_SIDE_GOOD,700.0) then
			hero:AddNewModifier(nil, nil, 'modifier_phased',{}) --添加相位状态
			hero:SetOrigin(POS_SECRET_GOOD) --设置单位到位置
			hero:RemoveModifierByName('modifier_phased') --移除相位状态
			hero:Stop() --停止单位动作
			KATAMoveToPos( hero, POS_SECRET_GOOD + RandomVector(25) ) --使单位随机移动，激活商店

			PlayerResource:SetCameraTarget(keys.PlayerID,hero)	--镜头定位到英雄
			-- 1.5秒后取消镜头锁定
			-- GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("offCamera"),
			-- 					function()
			-- 					PlayerResource:SetCameraTarget(keys.PlayerID,nil)
			-- 					return nil
			-- 					end,
			-- 					1.5)
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("offCamera"),function() KATAOffCamera(keys.PlayerID) end,1.5)

		elseif hero:IsPositionInRange(POS_SIDE_BAD,700.0) then
			hero:AddNewModifier(nil, nil, 'modifier_phased',{}) --添加相位状态
			hero:SetOrigin(POS_SECRET_BAD) --设置单位到位置
			hero:RemoveModifierByName('modifier_phased') --移除相位状态
			hero:Stop() --停止单位动作
			KATAMoveToPos( hero, POS_SECRET_BAD + RandomVector(25) ) --使单位随机移动，激活商店

			PlayerResource:SetCameraTarget(keys.PlayerID,hero)	--镜头定位到英雄
			-- 1.5秒后取消镜头锁定
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("offCamera"),function() KATAOffCamera(keys.PlayerID) end,1.5)
		else
			local additemcost = PlayerResource:GetGold(keys.PlayerID) + keys.itemcost
			print( '[KATA_itemP] additemcost = '..additemcost )
			PlayerResource:SetGold(keys.PlayerID,additemcost,false)
			-- 返回金钱
		end
	end

	--=========================================================
	--==============如果购买物品= 传送到 边路商店==============
	if keys.itemname == "item_kata_gotoSide" then
		itemPurchase:RemoveSelf()	--删除购买的物品

		-- 必须在秘密商店旁边
		if hero:IsPositionInRange(POS_SECRET_GOOD,700.0) then
			hero:AddNewModifier(nil, nil, 'modifier_phased',{}) --添加相位状态
			hero:SetOrigin(POS_SIDE_GOOD) --设置单位到位置
			hero:RemoveModifierByName('modifier_phased') --移除相位状态
			hero:Stop() --停止单位动作
			KATAMoveToPos( hero, POS_SIDE_GOOD + RandomVector(25) ) --使单位随机移动，激活商店

			PlayerResource:SetCameraTarget(keys.PlayerID,hero)	--镜头定位到英雄
			-- 1.5秒后取消镜头锁定
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("offCamera"),function() KATAOffCamera(keys.PlayerID) end,1.5)

		elseif hero:IsPositionInRange(POS_SECRET_BAD,700.0) then
			hero:AddNewModifier(nil, nil, 'modifier_phased',{}) --添加相位状态
			hero:SetOrigin(POS_SIDE_BAD) --设置单位到位置
			hero:RemoveModifierByName('modifier_phased') --移除相位状态
			hero:Stop() --停止单位动作
			KATAMoveToPos( hero, POS_SIDE_BAD + RandomVector(25) ) --使单位随机移动，激活商店

			PlayerResource:SetCameraTarget(keys.PlayerID,hero)	--镜头定位到英雄
			-- 1.5秒后取消镜头锁定
			GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("offCamera"),function() KATAOffCamera(keys.PlayerID) end,1.5)
		else
			local additemcost = PlayerResource:GetGold(keys.PlayerID) + keys.itemcost
			print( '[KATA_itemP] additemcost = '..additemcost )
			PlayerResource:SetGold(keys.PlayerID,additemcost,false)
			-- 返回金钱
		end
	end

end


--------------------------------------------------------------------------------
-- 取消镜头跟踪
--------------------------------------------------------------------------------
function KATAOffCamera( PlayerID )
	print( '[KATA_itemP] OffCamera ')
	PlayerResource:SetCameraTarget(PlayerID,nil)
	return nil
end

--------------------------------------------------------------------------------
-- 命令单位移动到点，以激活商店。。
--------------------------------------------------------------------------------
function KATAMoveToPos( target, pos )
	local newOrder = {
		UnitIndex = target:entindex(), 
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = pos, --Optional.  Only used when targeting the ground
		Queue = 0 --Optional.  Used for queueing up abilities
	}
	ExecuteOrderFromTable(newOrder)
end
