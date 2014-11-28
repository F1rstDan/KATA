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
1000,	-- 9,提升单位移动速度
1000,	-- 10,升级单位
}

-- 商店物品
UI_SHOP_ITEM_TABLE = {
"npc_gnoll_assassin",	-- 1,雇佣兵 豺狼人刺客
"npc_rock_golem",	-- 2,雇佣兵 石头人 远古岩石傀儡
"",		-- 3,
"",		-- 4,
"",		-- 5,
"",	-- 6,提升单位攻击力
"",	-- 7,单位获得生命吸取能力
"",	-- 8,提升单位生命恢复
"",	-- 9,提升单位移动速度
"",	-- 10,升级单位
}

-- 商店价格，转化成 字符串
	UI_SHOP_COST_TABLE_String = ","
	for i,cost in ipairs(UI_SHOP_COST_TABLE) do
		UI_SHOP_COST_TABLE_String = UI_SHOP_COST_TABLE_String .. cost .. "," 
	end
