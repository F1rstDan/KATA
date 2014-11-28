
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
				PlayerResource:SetGold(playerID, PlayerResource:GetGold(playerID) - UI_SHOP_COST_TABLE[n],false)
				local team
				local pos
				local lvl
				if PlayerResource:GetTeam(playerID) == DOTA_TEAM_GOODGUYS then
					team = DOTA_TEAM_GOODGUYS
					pos = POS_SPAWNER_GOOD
					lvl = KUNKKA_LEVEL-1
				elseif PlayerResource:GetTeam(playerID) == DOTA_TEAM_BADGUYS then
					team = DOTA_TEAM_BADGUYS
					pos = POS_SPAWNER_BAD
					lvl = TIDEHUNTER_LEVEL-1
				end

				if n <=2 then
					local newunit = CreateUnitByName(UI_SHOP_ITEM_TABLE[n], pos, true, nil, nil, team )
					newunit:CreatureLevelUp(lvl)
				elseif n >5 and n <=9 then
					--todo
				elseif n == 10 then
					if PlayerResource:GetTeam(playerID) == DOTA_TEAM_GOODGUYS then
						KUNKKA_LEVEL = KUNKKA_LEVEL +3
					else
						TIDEHUNTER_LEVEL = TIDEHUNTER_LEVEL +3
					end
				end
			end


		end
	end, "ShopBuy", 0)
end