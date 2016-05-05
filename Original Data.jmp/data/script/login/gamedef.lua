-- 场外登陆
G_login_ui = nil 							-- 登陆UI管理---第一个UI
g_server_selection_ui = nil 				-- 选择服务器
g_game_hall_ui = nil						-- 游戏大厅
g_game_fight_ui = nil						-- 游戏，战斗类型选择（永恒竞技、永恒战场、天梯排位、勇者斗恶龙、二次元杀阵、大乱斗）
g_game_hero_ui = nil						-- 大厅内部：英雄按钮的点击进入界面
g_game_heroAll_ui = nil						-- 英雄总览
g_game_heroDetail_ui = nil					-- 单个英雄的详细信息和皮肤（定位、技能、觉醒、信息）
g_game_heroSkin_ui = nil					-- 英雄装扮

-- 游戏组队界面ui
g_GameTeamFight_ui = nil
g_game_start_ui = nil						-- 游戏开始===进入第一个界面、出击界面（随机英雄）
g_game_chosehero_ui = nil					-- 游戏开始===进入第二个界面、开始选英雄界面
g_game_SkinFrame_ui = nil
g_PlayerInfo_ui = nil						-- 个人信息等大界面
g_game_heroInfo_ui = nil					-- 个人信息
g_game_heroTalent_ui = nil					-- 天赋专精
g_game_heroSkill_ui = nil					-- 战斗技能
g_game_heroAchievement_ui = nil				-- 成就
g_game_heroVipLevel_ui = nil				-- VIP等级
g_game_heroRankList_ui = nil				-- 排行榜
g_talent_inside_ui = nil					-- 选人界面天赋专精修改界面
g_achievement_inside_ui = nil				-- 场内成就UI

-- 商城部分
g_game_shop_ui = nil						-- 大厅内部：商城按钮的点击进入界面
g_shop_head_ui = nil						-- 菜单栏界面
g_shop_recommend_ui = nil					-- 推荐
g_shop_hero_ui = nil						-- 英雄			--（英雄、皮肤、装扮）
g_shop_Sec_hero_ui = nil					-- 子页英雄
g_shop_Sec_heroSkin_ui = nil				-- 子页皮肤
g_shop_Sec_heroPhen_ui = nil				-- 子页装扮
g_shop_battleEquip_ui = nil					-- 战场装备		--（装备、神器）
g_shop_Sec_Equip_ui = nil					-- 子页装备
g_shop_Sec_BestEquip_ui = nil				-- 子页神器
g_shop_stoneStr_ui = nil					-- 宝石和强化	--（宝石、装备强化）
g_shop_Sec_Stone_ui = nil					-- 子页宝石
g_shop_Sec_EquipStr_ui = nil				-- 子页装备强化
g_shop_expendable_ui = nil					-- 消耗品
g_shop_honour_ui = nil						-- 荣誉和功勋
g_shop_vip_ui = nil							-- VIP商城
g_show_EquipInfo_ui = nil					-- 右下角界面
g_shop_buy_ui = nil							-- herobuy和itembuy合体购买界面

-- 装备部分
g_game_equip_ui = nil    					-- 大厅内部：装备按钮的点击进入界面
g_equip_all_ui = nil						-- 装备总览
g_equip_str_ui = nil						-- 装备强化
g_equip_stoneInlay_ui = nil					-- 宝石镶嵌
g_equip_synthesize_ui = nil					-- 物品合成

g_bag_value_ui = nil						-- 装备总览界面数值
g_bag_hero_ui = nil							-- 装备总览界面英雄
g_bag_equip_ui = nil						-- 装备总览界面全部物品
g_bag_expend_ui = nil						-- 装备总览界面背包扩展
g_bag_expend2_ui = nil                  	-- 装备总览界面背包扩展2

g_str_Strength_ui = nil						-- 装备强化界面 强化界面
g_str_Rebuild_ui = nil						-- 装备强化界面 重铸界面
g_str_Soul_ui = nil							-- 装备强化界面 铸魂界面
g_str_Make_ui = nil							-- 装备强化界面 炼金界面
g_str_BagSoul_ui = nil						-- 装备强化界面 强化背包界面
g_str_BagMake_ui = nil						-- 装备强化界面 炼金背包界面

g_equip_geminlay_ui = nil					-- 宝石镶嵌界面镶嵌
g_equip_gemsyn_ui = nil						-- 宝石镶嵌界面合成

g_syn_equip_ui = nil						-- 物品合成界面分界面
g_equip_GemBuy_ui = nil         			-- 物品购买界面

g_bagbuy_ui = nil							-- 時效背包，擴展裝備購買界面

g_equip_redemption_ui = nil					-- 装备赎回

-- 任务和活动
g_task_ui = nil								-- 任务活动主界面
g_task_signin_ui = nil						-- 签到奖励
g_task_limittime_ui = nil					-- 限时活动
g_task_growup_ui = nil						-- 成长福利
g_task_sevenday_ui = nil					-- 七天目标
g_task_newserver_ui = nil					-- 新服庆典

-- 设置和好友邮件部分
g_setup_ui = nil							-- 设置主界面
g_setup_face_ui = nil						-- 画面设置
g_setup_game_ui = nil						-- 游戏设置
g_setup_keypress_ui = nil					-- 按键设置
g_setup_impeach_ui = nil					-- 举报
g_setup_safe_ui = nil						-- 安全锁
g_setup_quit_ui = nil						-- 退出游戏
g_setup_accuse_ui = nil                 	-- 举报
g_setup_mail_ui = nil						-- 邮件
g_setup_talk_ui = nil						-- 聊天
g_chat_ui = nil								-- 大厅聊天界面
g_PassWord_ui = nil                   		-- 解锁安全锁界面
g_Tutorial_ui = nil							-- 新手引导界面

-- 场内界面
N_battleground_ui = nil 					-- 场内UI管理
n_fightbag_ui = nil 						-- 自己的战斗背包	(左下)
n_fighttarget_ui = nil 						-- 选中单位的战斗背包(左上)

n_score_ui = nil 							-- 游戏计分			(中上)
n_data_ui = nil 							-- 游戏数据			(右上)
n_state_ui = nil 							-- BUFF状态			(中下)
n_lolmain_ui = nil 							-- 技能状态界面		(中下)
n_minimap_ui = nil 							-- 小地图			(右下)
n_tab_ui = nil   							-- tab界面			(中中)
n_endData_ui = nil							-- 结算界面			(中中)
n_market_ui = nil							-- 商店界面			(中中)
n_deadData_ui = nil							-- 英雄死亡回放		(中上)
n_farshop_ui = nil 							-- 远程商店界面		(右上)
n_surrender_ui = nil 						-- 投降界面			(右中下)
n_teamplayer_ui = nil						-- 队友血条和R技能	(左中上)
n_messagebox_ui = nil						-- 消息提醒按钮
n_inputbox_ui = nil							-- 消息提醒按钮
n_eqmessagebox_ui = nil						-- 消息提醒按钮
n_talkmessagebox_ui = nil           		-- 消息提醒
n_Autobox_ui = nil                  		-- 自动强化messagebox
n_soulchange_ui = nil						-- 灵魂契约
n_readytime_ui = nil						-- 准备开始时间90秒倒计时
n_exitwait_ui = nil							-- 退出界面倒计时
n_summonerskill_ui = nil					-- 召唤师技能选择
n_selectfirsthero_ui = nil					-- 选择第一个英雄
n_Advert_ui = nil                   		-- 广告界面
n_equip_inside_ui = nil						-- 场内装备UI
n_shop_inside_ui = nil						-- 场内商城UI
n_playerRoleInfo_ui = nil					-- 场内英雄信息界面（按C）
n_chat_in_ui = nil							-- 场内聊天界面

n_battlesignal_ui = nil						-- 场内信号
n_battlesignalsetting_ui = nil				-- 场内信号设置

-- 三大界面
g_shop_hero_equip_ui = nil
g_mail_goal_active_ui = nil
g_setup_friend_ui = nil

g_CreatePlayer = nil                		-- 创建角色
n_loading_ui = nil							-- 进入场内UILoading

-- 比赛界面
n_roomlist_ui = nil
n_roomfounder_ui = nil
n_roomfind_ui = nil
n_roompassword_ui = nil
n_roomset_ui = nil

-- 定义公共的图片资源路径变量
path = "../Data/UI/Main/"
path_start = "../Data/UI/Start/"
path_hero = "../Data/UI/Hero/"
path_login = "../Data/UI/Login/"
path_server = "../Data/UI/Server/"
path_mode = "../Data/UI/GameMode/"

-- 个人信息
path_info = "../Data/UI/PlayerInfo/"
path_info_ranklist = "../Data/UI/PlayerInfo/RankList/"

-- 商城部分
path_shop = "../Data/UI/Shop/"

-- 装备部分
path_equip = "../Data/UI/Equip/"

-- 任务和活动
path_task = "../Data/UI/Task/"

-- 设置界面
path_setup = "../Data/UI/Setup/"

-- 新手引导
path_tutorial = "../UI/Common/"

-- 场内UI管理
path_fight = "../Data/UI/Fight/"
path_fight_tab = "../Data/UI/Fight/Tab/"
path_fight_market = "../Data/UI/Fight/Market/"
path_fight_end = "../Data/UI/Fight/End/"
path_fight_soulchange = "../Data/UI/Fight/SoulChange/"
path_fight_deadData = "../Data/UI/Fight/DeadData/"
path_fight_teamplayer = "../Data/UI/Fight/Teamplayer/"

-- 战术面板
path_Tactics = "../Data/UI/Fight/Tactics/"

--[[
G_login_ui	g_server_selection_ui
			g_game_hall_ui
			g_chat_ui
		
			g_game_fight_ui
			g_GameTeamFight_ui
			
			g_game_equip_ui			g_equip_all_ui = nil					--装备总览
									g_equip_str_ui = nil					--装备强化
									g_equip_stoneInlay_ui = nil				--宝石镶嵌
									g_equip_synthesize_ui = nil				--物品合成
									
			g_bag_value_ui = nil			----装备总览界面数值
			g_bag_hero_ui = nil				----装备总览界面英雄
			g_bag_equip_ui = nil			----装备总览界面全部物品
			g_bag_expend_ui = nil			----装备总览界面背包扩展
			g_str_Strength_ui = nil			----装备强化界面 强化界面
			g_str_Rebuild_ui = nil			----装备强化界面 重铸界面
			g_str_Soul_ui = nil				----装备强化界面 铸魂界面
			g_str_Make_ui = nil				----装备强化界面 炼金界面
			g_str_BagSoul_ui = nil			----装备强化界面 强化背包界面
			g_str_BagMake_ui = nil			----装备强化界面 炼金背包界面
			g_equip_geminlay_ui = nil		----宝石镶嵌界面镶嵌
			g_equip_gemsyn_ui = nil			----宝石镶嵌界面合成
			g_syn_equip_ui = nil			----物品合成界面分界面

			
			g_game_hero_ui				g_game_heroAll_ui			g_game_heroDetail_ui = nil		--单个英雄的详细信息和皮肤（定位、技能、觉醒、信息）
										g_game_heroSkin_ui = nil
										
			g_game_shop_ui-------全部是G_login_ui子界面	
			
			g_shop_head_ui = nil					----菜单栏界面
			g_shop_recommend_ui = nil				----推荐
			g_shop_hero_ui = nil					----英雄			---（英雄、皮肤、装扮）
			g_shop_Sec_hero_ui = nil				----子页英雄
			g_shop_Sec_heroSkin_ui = nil			----子页皮肤
			g_shop_Sec_heroPhen_ui = nil			----子页装扮
			g_shop_battleEquip_ui = nil				----战场装备		---（装备、神器）
			g_shop_Sec_Equip_ui = nil				----子页装备
			g_shop_Sec_BestEquip_ui = nil			----子页神器
			g_shop_stoneStr_ui = nil				----宝石和强化		---（宝石、装备强化）
			g_shop_Sec_Stone_ui = nil				----子页宝石
			g_shop_Sec_EquipStr_ui = nil			----子页装备强化
			g_shop_expendable_ui = nil				----消耗品
			g_shop_honour_ui = nil					----荣誉和功勋
			g_shop_vip_ui = nil						----VIP商城
			g_show_EquipInfo_ui = nil				----右下角界面

			
			g_task_ui		g_task_signin_ui = nil					----签到奖励
							g_task_limittime_ui = nil				----限时活动
							g_task_growup_ui = nil					----成长福利
							g_task_sevenday_ui = nil				----七天目标
							g_task_newserver_ui = nil				----新服庆典
							
			g_PlayerInfo_ui				g_game_heroInfo_ui = nil				--个人信息
										g_game_heroTalent_ui = nil				--天赋专精
										g_game_heroSkill_ui = nil				--战斗技能
										g_game_heroAchievement_ui = nil			--成就
										g_game_heroVipLevel_ui = nil			--VIP等级
										g_game_heroRankList_ui = nil			--排行榜
										
			g_shop_hero_equip_ui
			g_mail_goal_active_ui
			g_setup_friend_ui
			
			g_setup_ui					g_setup_face_ui = nil					----画面设置
										g_setup_game_ui = nil					----游戏设置
										g_setup_keypress_ui = nil				----按键设置
										g_setup_impeach_ui = nil				----举报
										g_setup_safe_ui = nil					----安全锁
										g_setup_quit_ui = nil	
			g_setup_mail_ui
			g_setup_talk_ui
			
			g_signin_ui
			g_hero_tips_ui
			g_shop_buy_ui
			
			g_game_start_ui
			g_game_chosehero_ui
			
			n_equip_inside_ui	
			n_shop_inside_ui
			n_functionBtn_ui
			
			n_fightbag_ui
			n_fighttarget_ui

			n_score_ui
			n_data_ui
			n_state_ui
			n_lolmain_ui
			n_farshop_ui		
--]]			

function BackToServerSelection()				
	SetGameHallIsVisible(0)					
	SetGameFightIsVisible(0)				
	SetTeamFightIsVisible(0)	
	SetGameEquipIsVisible(0)				
	SetGameHeroIsVisible(0)					
	SetGameShopIsVisible(0)
	SetTaskIsVisible(0,0)						
	SetPlayerInfoIsVisible(0)				
	SetTalent_InsideIsVisible(0)			
	Set_SetupIsVisible(0)
	SetMailIsVisible(0)
	SetTalkIsVisible(0)
	SetShopBuyIsVisible(0)                  
	SetBagBuyUiIsVisible(0)
	SetGameStartIsVisible(0)                
	SetGameChoseHeroIsVisible(0)              
	SetEquip_InsideIsVisible(0)             
	SetShop_InsideIsVisible(0)              
	SetFourpartUIVisiable(0)                
	SetGameSkinFrameIsVisible(0)
	ClearAll_skinframe()					
	SetRoomListIsVisible(0)
	SetRoomFounderIsVisible(0)
	SetRoomFindIsVisible(0)
	SetRoomPasswordIsVisible(0)
	SetRoomSetIsVisible(0)
	SetEquipRedemptionIsVisible(0)
	
	ShowServerselection(1)	
end

function BackToGameHall()
	ShowServerselection(0)					
	SetGameFightIsVisible(0)				
	SetTeamFightIsVisible(0)
	SetGameEquipIsVisible(0)
	SetGameHeroIsVisible(0)					
	SetGameShopIsVisible(0)	
	SetTaskIsVisible(0,0)					
	SetPlayerInfoIsVisible(0)				
	SetTalent_InsideIsVisible(0)
	Set_SetupIsVisible(0)
	SetMailIsVisible(0)
	SetTalkIsVisible(0)
	SetBagBuyUiIsVisible(0)					
	SetShopBuyIsVisible(0)  
	SetGameStartIsVisible(0)				
	SetGameChoseHeroIsVisible(0)  
	SetEquip_InsideIsVisible(0)				
	SetShop_InsideIsVisible(0) 
	SetGameSkinFrameIsVisible(0)			
	ClearAll_skinframe()
	SetRoomListIsVisible(0)
	SetRoomFounderIsVisible(0)
	SetRoomFindIsVisible(0)
	SetRoomPasswordIsVisible(0)
	SetRoomSetIsVisible(0)
	SetEquipRedemptionIsVisible(0)
	
	SetGameHallIsVisible(1) 
end

function BackToChoseHero()
	SetGameChoseHeroIsVisible(0)
	ShowServerselection(0)					
	SetGameHallIsVisible(0)
	SetGameFightIsVisible(0)
	SetTeamFightIsVisible(0)
	SetGameEquipIsVisible(0)	
	SetGameHeroIsVisible(0)
	SetGameShopIsVisible(0)	
	SetTaskIsVisible(0,0)	
	SetPlayerInfoIsVisible(0)
	SetTalent_InsideIsVisible(0)	
	Set_SetupIsVisible(0)
	SetMailIsVisible(0)
	SetTalkIsVisible(0)
	SetShopBuyIsVisible(0)                  
	SetBagBuyUiIsVisible(0)	
			
	SetEquip_InsideIsVisible(0)
	SetShop_InsideIsVisible(0)
	SetFourpartUIVisiable(0)	
	SetRoomListIsVisible(0)
	SetRoomFounderIsVisible(0)
	SetRoomFindIsVisible(0)
	SetRoomPasswordIsVisible(0)
	SetRoomSetIsVisible(0)
	SetEquipRedemptionIsVisible(0)
	
	RecoverStartList()
	SetGameStartIsVisible(1)
end

function HideAllWnd()	
	ShowServerselection(0)						
	SetGameHallIsVisible(0)
	SetGameFightIsVisible(0)
	SetTeamFightIsVisible(0)
	SetGameEquipIsVisible(0)	
	SetGameHeroIsVisible(0)
	SetGameShopIsVisible(0)	
	SetTaskIsVisible(0,0)	
	SetPlayerInfoIsVisible(0)
	SetTalent_InsideIsVisible(0)	
	Set_SetupIsVisible(0)
	SetMailIsVisible(0)
	SetTalkIsVisible(0)
	SetShopBuyIsVisible(0)                  
	SetBagBuyUiIsVisible(0)	
	SetGameStartIsVisible(0)	
	SetGameChoseHeroIsVisible(0)	
	SetEquip_InsideIsVisible(0)
	SetShop_InsideIsVisible(0)
	SetFourpartUIVisiable(0)	
	SetGameSkinFrameIsVisible(0)
	ClearAll_skinframe()	
	SetRoomListIsVisible(0)
	SetRoomFounderIsVisible(0)
	SetRoomFindIsVisible(0)
	SetRoomPasswordIsVisible(0)
	SetRoomSetIsVisible(0)
	SetEquipRedemptionIsVisible(0)
end

HeroHeadMMM = {17,23,30,38,42,45,48,53,57,60,75,76,86,96,100,101,102,104,105,107,108,109,113,115,117,118,120,121,
122,134,135,137,138,140,142,144,145,146,147,148,149,151,152,153,155,156,157,158,159,160,161,163,164,165,167,168,
169,170,171,172,174,180,181,183,184,185,186,189,190,191,192,193,194}