-- 商店价格
UI_SHOP_COST_TABLE = {
800,	-- 1,雇佣兵 豺狼人刺客
1000,	-- 2,雇佣兵 石头人 远古岩石傀儡
0,		-- 3,
0,		-- 4,
0,		-- 5,
1000,	-- 6,提升单位攻击力
1000,	-- 7,单位获得生命吸取能力
1000,	-- 8,提升单位生命恢复
650,	-- 9,提升单位移动速度
1000,	-- 10,升级单位
}

-- 商店物品
UI_SHOP_ITEM_TABLE = {
"npc_gnoll_assassin",			-- 1,雇佣兵 豺狼人刺客
"npc_rock_golem",				-- 2,雇佣兵 石头人 远古岩石傀儡
"",		-- 3,
"",		-- 4,
"",		-- 5,
"kata_unit_attack",		-- 6,提升单位攻击力
"kata_unit_lifesteal",		-- 7,单位获得生命吸取能力
"kata_unit_health_regen",	-- 8,提升单位生命恢复
"kata_unit_movespeed",		-- 9,提升单位移动速度
"kata_unit_up",			-- 10,升级单位
}

-- 商店价格，转化成 字符串
	UI_SHOP_COST_TABLE_String = ","
	for i,cost in ipairs(UI_SHOP_COST_TABLE) do
		UI_SHOP_COST_TABLE_String = UI_SHOP_COST_TABLE_String .. cost .. "," 
	end

-- 商店物品，转化成 字符串
	UI_SHOP_ITEM_TABLE_String = ","
	for i,items in ipairs(UI_SHOP_ITEM_TABLE) do
		UI_SHOP_ITEM_TABLE_String = UI_SHOP_ITEM_TABLE_String .. items .. "," 
	end

-- 商店物品的库存
UI_SHOP_ITEM_STOCK_TABLE = {
1,	-- 1,雇佣兵 豺狼人刺客
1,	-- 2,雇佣兵 石头人 远古岩石傀儡
1,		-- 3,
1,		-- 4,
1,		-- 5,
1,	-- 6,提升单位攻击力
1,	-- 7,单位获得生命吸取能力
1,	-- 8,提升单位生命恢复
1,	-- 9,提升单位移动速度
1,	-- 10,升级单位
}
-- 商店物品的库存最大量
UI_SHOP_ITEM_STOCK_MAX_TABLE = {
0,	-- 1,雇佣兵 豺狼人刺客
0,	-- 2,雇佣兵 石头人 远古岩石傀儡
0,		-- 3,
0,		-- 4,
0,		-- 5,
1,	-- 6,提升单位攻击力
1,	-- 7,单位获得生命吸取能力
1,	-- 8,提升单位生命恢复
1,	-- 9,提升单位移动速度
0,	-- 10,升级单位
}

-- 商店物品的库存补充时间; 实际游戏时间+60
UI_SHOP_ITEM_STOCK_TIME_TABLE = {}

-- 商店物品库存，转化成 字符串
function UIShopItemStock2String()
	UI_SHOP_ITEM_STOCK_TABLE_String = ","
	for i,items in ipairs(UI_SHOP_ITEM_STOCK_TABLE) do
		UI_SHOP_ITEM_STOCK_TABLE_String = UI_SHOP_ITEM_STOCK_TABLE_String .. items .. "," 
	end
end

