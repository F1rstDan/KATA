function item_kata_whistle_Ability( keys )		--使用传送口哨
	local caster = keys.caster           --获取施法者
	local target = keys.target          --获取施法目标

	if POS_SPAWNER_GOOD == nil then
	POS_SPAWNER_GOOD = Entities:FindByName(nil,"Spawner_good"):GetAbsOrigin()
	POS_SPAWNER_BAD = Entities:FindByName(nil,"Spawner_bad"):GetAbsOrigin()
	end

	if caster == target then
		if target:GetTeam() == DOTA_TEAM_GOODGUYS then
			target:AddNewModifier(nil, nil, 'modifier_phased',{}) --添加相位状态
			target:SetOrigin( POS_SPAWNER_BAD + RandomVector(RandomInt(200,1200)) ) --随机位置
			target:RemoveModifierByName('modifier_phased') --移除相位状态
		elseif target:GetTeam() == DOTA_TEAM_BADGUYS then
			target:AddNewModifier(nil, nil, 'modifier_phased',{}) --添加相位状态
			target:SetOrigin(POS_SPAWNER_GOOD + RandomVector(RandomInt(200,1200))) --随机位置
			target:RemoveModifierByName('modifier_phased') --移除相位状态
		end
	else
		target:AddNewModifier(nil, nil, 'modifier_phased',{}) --添加相位状态
		target:SetOrigin(caster:GetOrigin()) --设置单位到施法者位置
		target:RemoveModifierByName('modifier_phased') --移除相位状态
		-- target:Stop() --停止单位动作。注：算了，不停止了，让队友有更多配合
	end

	PlayerResource:SetCameraTarget(target:GetPlayerID(),target)	--镜头定位到英雄
		-- 1.5秒后取消镜头锁定
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("offCamera"),
				function()
				PlayerResource:SetCameraTarget(target:GetPlayerID(),nil)
				return nil
				end,
				1.5)
end

function item_kata_necronomicon_Ability( keys )		--使用死灵书
	local caster = keys.caster			--获取施法者
	local item = keys.ability			--获取使用物品
	local level = caster:GetLevel()
	local name = "modifiers_item_kata_necronomicon1"

	if level >= 1 and level <= 4 then
		name = "modifiers_item_kata_necronomicon1"
	elseif level >= 5 and level <= 7 then
		name = "modifiers_item_kata_necronomicon2"
	elseif level >= 8 and level <= 14 then
		name = "modifiers_item_kata_necronomicon3"
	elseif level >= 15 and level <= 60 then
		name = "modifiers_item_kata_necronomicon4"
	end
	print( '[KATA_necronomicon] level = '..level..' ,name = '..name..' ,item name = '..item:GetName() )

	item:ApplyDataDrivenModifier(caster, caster, name,{Duration=0.1}) --添加死灵书

end

-- function item_kata_salve_Ability( keys )		--使用药膏,测试失败
-- 	local caster = keys.caster			--获取施法者
-- 	local item = keys.ability			--获取使用物品

-- 	print( '[KATA_salve] useing ' )

-- 	item:ApplyDataDrivenModifier(caster, caster, "item_kata_salve_M",{ 
-- 		Duration=0.1,
-- 		OnDestroy=
-- 		{
-- 			Heal=
-- 			{
-- 				HealAmount=52,
-- 				Target=CASTER
-- 			}
-- 		} 

-- 		})

-- end
