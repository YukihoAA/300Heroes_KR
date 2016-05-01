include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


windowswidth = nil
windowsheight = nil

-- 分辨率改变 修改界面位置
function sizechange_movewindow(width, height)

	windowswidth = width
	windowsheight = height
	-- log("\n分辨率改变   "..width.."  "..height)
	n_loading_ui:SetPosition((width-1280)/2, (height-800)/2)
	-- log("\n分辨率改变1222   "..width.."  "..height)
	n_fighttarget_ui:SetPosition(0, 0)                    					--目标装备界面
	n_fightbag_ui:SetPosition(0, height-127)                    			--自身装备界面
	n_score_ui:SetPosition((width-1470)/2, 0)								--比分
	n_data_ui:SetPosition(width-279, 0)										--个人数据===击杀助攻补兵
	n_lolmain_ui:SetPosition((width-1470)/2, height-87)						--技能主界面
	n_farshop_ui:SetPosition(width-273, 85)									--远程商店
	n_surrender_ui:SetPosition(width-316, height-475)						--投降界面
	n_tab_ui:SetPosition((width-872)/2, (height-408)/2)						--TAB界面
	SetEndData_Position(width,height)										--结算界面
	
	n_market_ui:SetPosition((width-878)/2, (height-542)/2)					--商店界面
	n_deadData_ui:SetPosition((width-872)/2, (height-416)/2)				--死亡回放
	n_state_ui:SetPosition((width-422)/2, height-130)						--自身BUFF状态界面
	
	n_TimeProgress_ui:SetPosition((width-259)/2, height-200)
	
	-- log("\n分辨率改变1   "..width.."  "..height)
	
	local w,h = n_minimap_ui:GetWH()
	n_minimap_ui:SetPosition(width-w, height-h)								--小地图界面
	n_teamplayer_ui:SetPosition(0, 160)										--队友技能小界面
	n_soulchange_ui:SetPosition(0, height-400)								--灵魂契约小界面
	n_chat_in_ui:SetPosition(0, height-415)									--场内聊天
	--n_battlesignal_ui:SetPosition((width-316)/2, (height-175)/2)			--信号界面
	n_battlesignalsetting_ui:SetPosition((width-396)/2, (height-478)/2)		--信号设置界面
	
	talk_show_playerinfo_wnd:SetPosition((width-732)/2, (height-280)/2)
	
	g_setup_ui:SetPosition((width-800)/2, (height-500)/2)					--设置界面居中
	g_setup_mail_ui:SetPosition(width-655, (height-532)/2)  				--邮件
	g_setup_talk_ui:SetPosition(width-655, (height-532)/2)  				--好友
	
	n_equip_inside_ui:SetPosition((width-870)/2, (height-518)/2)			--场内装备UI居中
	g_equip_redemption_ui:SetPosition((width-1280)/2, (height-800)/2)
	g_bag_value_ui:SetPosition((width-870)/2+70, (height-518)/2+50)
	g_bag_hero_ui:SetPosition((width-870)/2+70, (height-518)/2+35)
	g_equip_geminlay_ui:SetPosition((width-870)/2, (height-518)/2+50)
	g_equip_gemsyn_ui:SetPosition((width-870)/2, (height-518)/2+50)	
	g_str_Strength_ui:SetPosition((width-870)/2, (height-518)/2+50)
	g_str_Rebuild_ui:SetPosition((width-870)/2, (height-518)/2+50)
	g_str_Soul_ui:SetPosition((width-870)/2, (height-518)/2+50)
	g_str_Make_ui:SetPosition((width-870)/2, (height-518)/2+50)
	g_str_BagSoul_ui:SetPosition((width-870)/2+440, (height-518)/2+50)
	g_str_BagMake_ui:SetPosition((width-870)/2+440, (height-518)/2+50)	
	g_syn_equip_ui:SetPosition((width-870)/2, (height-518)/2+50)
	
	-- log("\n分辨率改变2   "..width.."  "..height)
	
	
	n_shop_inside_ui:SetPosition((width-1280)/2, (height-750)/2)						--场内商城UI居中
	n_shop_head_ui:SetPosition((width-1280)/2+50, (height-800)/2+50)					--场内商城UI居中
	g_shop_hero_ui:SetPosition((width-1280)/2+60, (height-800)/2+100)					--场内商城UI居中
	g_shop_battleEquip_ui:SetPosition((width-1280)/2+60, (height-800)/2+100)			--场内商城UI居中
	g_shop_stoneStr_ui:SetPosition((width-1280)/2+60, (height-800)/2+100)				--场内商城UI居中
	g_show_EquipInfo_ui:SetPosition((width-1280)/2+930, (height-800)/2+450)				--场内商城UI居中
	
	g_achievement_inside_ui:SetPosition((width-1280)/2, (height-750)/2)					--场内成就UI居中
	g_game_heroAchievement_ui:SetPosition((width-1280)/2, (height-800)/2+130)
	
	g_shop_recommend_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_Sec_hero_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_Sec_heroSkin_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_Sec_heroPhen_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_Sec_Equip_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_Sec_BestEquip_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)	
	g_shop_Sec_Stone_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_Sec_EquipStr_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_expendable_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_honour_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_shop_vip_ui:SetPosition((width-1280)/2+50, (height-800)/2+150)
	g_equip_GemBuy_ui:SetAbsolutePosition((width-468)/2, (height-140)/2)
	g_shop_buy_ui:SetPosition((width-438)/2, (height-530)/2)					-----shopbuy购买界面居中
	g_bagbuy_ui:SetPosition((width-438)/2, (height-530)/2)					-----shopbuy购买界面居中
	n_messagebox_ui:SetPosition((width-402)/2, (height-280)/2)
	n_exitwait_ui:SetPosition((width-402)/2, (height-280)/2)
	n_eqmessagebox_ui:SetPosition((width-402)/2, (height-280)/2)
	n_talkmessagebox_ui:SetPosition((width-402)/2, (height-280)/2)
	g_PassWord_ui:SetPosition((width-1280)/2, (height-800)/2)
	n_inputbox_ui:SetPosition((width-400)/2, (height-340)/2)
	n_playerRoleInfo_ui:SetPosition((width-318)/2, (height-482)/2)
	n_selectfirsthero_ui:SetPosition((width-1106)/2, (height-392)/2)				--新手引导第一个英雄
	-- log("\n分辨率改变3   "..width.."  "..height)
	
	SetPlayerRoleInfoIsVisible(0)
end
