
--------------------------------------------------------------------------------
-- 树精卫士：逆生种子 "treant_seed"
--------------------------------------------------------------------------------
function SeedSpawnUnitBonus( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("treant_natures_protection")
	local target = keys.target

	ability:ApplyDataDrivenModifier(caster, target, "modifiers_natures_protection_spawnunit_bonus",nil) --根据第3技能，添加攻击生命
end



--------------------------------------------------------------------------------
-- 树精卫士：扎根 "treant_root"
--------------------------------------------------------------------------------
function RootOnChannelSucceeded( keys )
	local caster = keys.caster
	local ability = keys.ability
	local abilityname = ability:GetAbilityName()
	local level = ability:GetLevel()

	if abilityname == "treant_root" then
		if not caster:HasAbility("treant_root_stop") then
			caster:AddAbility("treant_root_stop")
		end
		caster:SwapAbilities("treant_root","treant_root_stop",false,true)
		local ability = caster:FindAbilityByName("treant_root_stop")
		ability:SetLevel(level)
		ability:StartCooldown(1.0)
	elseif abilityname == "treant_root_stop" then
		caster:SwapAbilities("treant_root_stop","treant_root",false,true)
		local ability = caster:FindAbilityByName("treant_root")
		ability:SetLevel(level)
		ability:StartCooldown(1.0)
	end
end

function RootSelfDamage( keys )
	local caster = keys.caster
	local self_damage = keys.self_damage
	local health = caster:GetHealth()

	if health - self_damage > 1 then
		caster:SetHealth(health - self_damage)
	else
		caster:SetHealth(1)
	end
end

function RootSpawnUnit( keys )
	local caster = keys.caster
	local ability = caster:FindAbilityByName("treant_natures_protection")
	-- print("RootSpawnUnit")
	ability:ApplyDataDrivenModifier(caster, caster, "modifiers_natures_protection_spawnunit",{Duration=0.1}) --添加生产单位buff

	if caster:HasModifier("modifier_root") then
		keys.ability:ApplyDataDrivenModifier(caster, caster, "modifier_root_spawnunit",nil)
	end
end

--------------------------------------------------------------------------------
-- 树精卫士：大自然的保护 "treant_natures_protection"
--------------------------------------------------------------------------------
function NaturesProtectionOnAttacked( keys )
	local caster = keys.caster
	local ability = keys.ability
	local count = caster:GetModifierStackCount("modifiers_natures_protection_buff",ability)

	caster:SetModifierStackCount("modifiers_natures_protection_buff",ability,count +1)
	if count +1 >= 13 then
		ability:ApplyDataDrivenModifier(caster, caster, "modifiers_natures_protection_spawnunit",{Duration=0.1}) --添加生产单位buff
		caster:SetModifierStackCount("modifiers_natures_protection_buff",ability,0)
	end
end

function NaturesProtectionHealthBonus( keys )
	-- local target = keys.target
	-- local health_bonus = keys.health_bonus

	-- print(health_bonus)
	-- target:SetMaxHealth(health_bonus)

	keys.target:SetMaxHealth(keys.health_bonus)		--设置最大生命值
	keys.target:SetHealth(keys.health_bonus)		--设置当前生命值
end


--------------------------------------------------------------------------------
-- 树精卫士：大招 "treant_vines"
--------------------------------------------------------------------------------
function VinesOnSpellStart( keys )
	local ability = keys.ability
	local caster = keys.caster
	local caster_vector = caster:GetAbsOrigin()
	local caster_angle = caster:GetAngles()
	local length = 450
	-- local health_bonus = keys.health_bonus

	for i = 1,12 do
		local cos=math.cos(math.rad(90-caster_angle.y))
		local sin=math.sin(math.rad(90-caster_angle.y))
		local xxx=sin * length + caster_vector.x
		local yyy=cos * length + caster_vector.y
		-- print("NaturesTest cos="..cos..", sin="..sin..", xxx="..xxx..", yyy="..yyy)
		caster_angle.y =caster_angle.y+30

		local unit = CreateUnitByName("npc_treant_vine",Vector(xxx,yyy,0), false, caster, caster, caster:GetTeam())
		ability:ApplyDataDrivenModifier(caster, unit, "modifier_vines",nil)
		-- unit:AddNewModifier(nil, nil, 'modifier_phased',{}) --添加相位状态
		unit:SetMaxHealth(keys.health_bonus)		--设置最大生命值
		unit:SetHealth(keys.health_bonus)			--设置当前生命值
	end
end