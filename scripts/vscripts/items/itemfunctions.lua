if itemFunctions == nil then
	print ( '[ItemFunctions] creating itemFunctions' )
	itemFunctions = {} -- Creates an array to let us beable to index itemFunctions when creating new functions
	itemFunctions.__index = itemFunctions
end
 
function itemFunctions:new() -- Creates the new class
	print ( '[ItemFunctions] itemFunctions:new' )
	o = o or {}
	setmetatable( o, itemFunctions )
	return o
end
 
function itemFunctions:start() -- Runs whenever the itemFunctions.lua is ran
	print('[ItemFunctions] itemFunctions started!')
end
 
function DropItemOnDeath(keys) -- keys is the information sent by the ability
	print( '[ItemFunctions] DropItemOnDeath Called' )
	local killedUnit = EntIndexToHScript( keys.caster_entindex ) -- EntIndexToHScript takes the keys.caster_entindex, which is the number assigned to the entity that ran the function from the ability, and finds the actual entity from it.
	local itemName = tostring(keys.ability:GetAbilityName()) -- In order to drop only the item that ran the ability, the name needs to be grabbed. keys.ability gets the actual ability and then GetAbilityName() gets the configname of that ability such as juggernaut_blade_dance.

	if killedUnit:IsRealHero() or killedUnit:HasInventory() then -- In order to make sure that the unit that died actually has items, it checks if it is either a hero or if it has an inventory.
		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("DropItemOnDeath"),function()
			local respawntime = PlayerResource:GetRespawnSeconds(killedUnit:GetPlayerID())
			if respawntime <=5 and respawntime >0 then --如果英雄身上有不朽之守护，则不掉落 并退出函数
				print( '[KATA_item] respawnseconds = '..respawntime )
				return
			else
				print( '[KATA_item] respawnseconds = '..respawntime )
				for itemSlot = 0, 5, 1 do --a For loop is needed to loop through each slot and check if it is the item that it needs to drop
					if killedUnit ~= nil then --检查以确保杀死单位不是不存在的 checks to make sure the killed unit is not nonexistent.
						local Item = killedUnit:GetItemInSlot( itemSlot ) -- uses a variable which gets the actual item in the slot specified starting at 0, 1st slot, and ending at 5,the 6th slot.
						if Item ~= nil and Item:GetName() == itemName then -- makes sure that the item exists and making sure it is the correct item
							-- local newItem = CreateItem(itemName, nil, nil) -- creates a new variable which recreates the item we want to drop and then sets it to have no owner
							-- local newItem = CreateItem(itemName, killedUnit, killedUnit) --改的，让新建物品依然是原主人
							local newItem = CreateItem(itemName, Item:GetPurchaser(), Item:GetPurchaser()) --改的，让新建物品依然是原主人
							-- CreateItemOnPositionSync(killedUnit:GetOrigin(), newItem) -- takes the newItem variable and creates the physical item at the killed unit's location
							-- killedUnit:RemoveItem(Item) -- finally, the item is removed from the original units inventory.
							newItem:SetCurrentCharges(Item:GetCurrentCharges()) --改的，设置新建物品的可用次数=旧物品的可用次数
							CreateItemOnPositionSync(killedUnit:GetOrigin()+RandomVector(100), newItem) --改的，移动新建物品到死亡单位位置(移动原物品出来，会有bug)
							killedUnit:RemoveItem(Item) --改的，移除原物品。
						end
					end
				end
			end
		end,0.3)	
	end
end