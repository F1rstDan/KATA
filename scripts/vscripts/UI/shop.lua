
UIShopSystem = {}
print( "[KATA] ===UIShopSystem=== Called" )


--------------------------------------------------------------------------------
-- ACTIVATE 激活
--------------------------------------------------------------------------------
function UIShopSystem:RegistEvents()

	Convars:RegisterCommand("kata_shop_buy", function(name,item_number)
		local player = Convars:GetCommandClient()
		local n = tonumber(item_number)
		if player ~= nil then
			local playerID = player:GetPlayerID()
			print( "[KATAUIShopSystem] GetGold",PlayerResource:GetGold(playerID) )
			print( "[KATAUIShopSystem] item_number",item_number )
			print( "[KATAUIShopSystem] UI_SHOP_COST_TABLE",UI_SHOP_COST_TABLE[n] )

			if PlayerResource:GetGold(playerID) >= UI_SHOP_COST_TABLE[n] then
				PlayerResource:SetGold(playerID, PlayerResource:GetGold(playerID) - UI_SHOP_COST_TABLE[n],false) --扣除金钱
				local team
				local pos
				local lvl
				local mUnit
				if PlayerResource:GetTeam(playerID) == DOTA_TEAM_GOODGUYS then
					team = DOTA_TEAM_GOODGUYS
					pos = POS_SPAWNER_GOOD
					lvl = KUNKKA_LEVEL-1
					mUnit = KUNKKA_Animation
				elseif PlayerResource:GetTeam(playerID) == DOTA_TEAM_BADGUYS then
					team = DOTA_TEAM_BADGUYS
					pos = POS_SPAWNER_BAD
					lvl = TIDEHUNTER_LEVEL-1
					mUnit = TIDEHUNTER_Animation
				end

				if n <=2 then
					local newunit = CreateUnitByName(UI_SHOP_ITEM_TABLE[n], pos, true, nil, nil, team )
					newunit:CreatureLevelUp(lvl)
				elseif n >5 and n <=9 then
					--todo
					if UI_SHOP_ITEM_STOCK_TABLE[n] > 0 then
						local itemT = CreateItem("item_"..UI_SHOP_ITEM_TABLE[n],mUnit,mUnit)
						itemT:ApplyDataDrivenModifier(mUnit, mUnit, "Modifiers_item_"..UI_SHOP_ITEM_TABLE[n].."_area",{Duration=45})
						itemT:RemoveSelf()	--删除物品

						UI_SHOP_ITEM_STOCK_TABLE[n] = UI_SHOP_ITEM_STOCK_TABLE[n] -1
						UI_SHOP_ITEM_STOCK_TIME_TABLE[n] = GAME_TIME_S + 60
						GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("AddStock"),function()
								if UI_SHOP_ITEM_STOCK_TIME_TABLE[n] - GAME_TIME_S > 0 then
									print( "[KATAUIShopSystem] STOCK_TIME",UI_SHOP_ITEM_STOCK_TIME_TABLE[n] - GAME_TIME_S )
									return 1
								elseif UI_SHOP_ITEM_STOCK_TIME_TABLE[n] - GAME_TIME_S <= 0 then
									UI_SHOP_ITEM_STOCK_TABLE[n] = UI_SHOP_ITEM_STOCK_TABLE[n] +1
									return nil
								end
						end,0)
					else
						PlayerResource:SetGold(playerID, PlayerResource:GetGold(playerID) + UI_SHOP_COST_TABLE[n],false) --返回金钱
						-- FireGameEvent( 'custom_error_show', { player_ID = playerID, _error = "#dota_hud_error_item_out_of_stock" } ) --物品已售完
						FireGameEvent( 'custom_error_show', { player_ID = playerID, _error = "#dota_hud_error_cant_glyph" } ) --冷却中...
					end
				elseif n == 10 then
					if PlayerResource:GetTeam(playerID) == DOTA_TEAM_GOODGUYS then
						KUNKKA_LEVEL = KUNKKA_LEVEL +3
					else
						TIDEHUNTER_LEVEL = TIDEHUNTER_LEVEL +3
					end
				end
			else
				FireGameEvent( 'custom_error_show', { player_ID = playerID, _error = "#dota_hud_error_not_enough_gold" } ) --金钱不足
			end


		end
	end, "ShopBuy", 0)
end