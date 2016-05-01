include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

function show_login_ui(wnd,bisopen)
    if G_login_ui == nil then
		G_login_ui = CreateWindow(wnd, 0, 0, 1280, 800)
		G_login_ui:ToggleFlags(XF_ENABLEMSGPROCESS,0)
				
		-- 战场内UI界面
		SkipLoadResource(1)
		InitScore_ui(G_login_ui,0)							-- 比分
		InitData_ui(G_login_ui,0)							-- 击杀、助攻、死亡、补兵
		InitState_ui(G_login_ui,0)							-- 技能界面
		InitLolmain_ui(G_login_ui,0)						-- 技能界面
		InitTimeProgress_ui(G_login_ui,0)					-- 回城进度条
		
		InitFightbag_ui(G_login_ui,0)   					-- 自己的战斗背包
		InitFighttaget_ui(G_login_ui,0)  					-- 选中单位的战斗背包
		InitTeamplayer_ui(G_login_ui,0)  					-- 队友信息界面
		InitMinimap_ui(G_login_ui,0)						-- 小地图
		
		InitFarshop_ui(G_login_ui,0)						-- 远程商店
		InitSurrender_ui(G_login_ui,0)						-- 投降界面
		
		InitChatIn_UI(G_login_ui,0)							-- 场内聊天界面	
	
		InitDeadData_ui(G_login_ui,0)						-- 死亡回放
		InitMarket_ui(G_login_ui,0)							-- 场内商店
		InitTab_ui(G_login_ui,0)							-- 按Tab键
		InitSoulChange_ui(G_login_ui,0)						-- 灵魂契约
		InitSelectFirstHero_ui(G_login_ui,0)				-- 新手引导选择英雄界面
		InitEndData_ui(G_login_ui,0)						-- 结算界面
		
		InitBattleSignal_ui(G_login_ui,0)					-- 场内信号
		InitBattleSignalSetting_ui(G_login_ui,0)			-- 场内信号设置
		
		InitCreatePlayerUI(G_login_ui,0)					-- 创建召唤师
		SkipLoadResource(0)
		
		-- 场外UI管理		
		Initserver_selectionUI(G_login_ui,0)		
		InitGame_hallUI(G_login_ui,0)						-- 游戏大厅主界面
		InitLobbyAdvert_ui(G_login_ui,0)        			-- 广告界面
		InitGame_FightUI(G_login_ui, 0)						-- 游戏模式：永恒战场、永恒竞技等等
		InitGame_HeroUI(G_login_ui, 0)						-- 英雄界面
		InitShop_InsideUI(G_login_ui,0)						-- 场内商城UI
		InitGame_ShopUI(G_login_ui, 0)						-- 商城界面
		
		SkipLoadResource(1)
		InitEquip_InsideUI(G_login_ui,0)					-- 场内背包UI
		InitGame_EquipUI(G_login_ui, 0)						-- 装备界面
		Init_EquipRedemptionUI( G_login_ui, 0)				-- 装备赎回
		SkipLoadResource(0)
		
		InitTask_UI(G_login_ui, 0)							-- 任务和活动界面
		InitTalent_InsideUI(G_login_ui, 0)					-- 选人界面的天赋专精
		InitAchievement_InsideUI(G_login_ui,0)				-- 场内成就UI
		Init_PlayerInfoUI(G_login_ui, 0)					-- 个人信息界面

		InitGame_FourpartUI(G_login_ui,0)
	
		InitGameStart_ui(G_login_ui, 0)						--log("\nshow_login_ui31   ")-- 游戏开始界面1
		InitSummonerSkill_ui(G_login_ui, 0)					--log("\nshow_login_ui32   ")-- 召唤师技能选择
		InitGame_ChoseHeroUI(G_login_ui, 0)					--log("\nshow_login_ui33   ")-- 游戏开始界面2
		InitGame_SkinFrame(G_login_ui, 0)					--log("\nshow_login_ui34   ")-- 皮肤选择
		InitReadyTime_ui(G_login_ui,0)						--log("\nshow_login_ui35   ")-- 准备开始时间90秒倒计时
		
		InitGameTeamFight_ui(G_login_ui, 0)					--log("\nshow_login_ui37   ")-- 组对界面在基本3中界面上层
		InitEquip_GemBuy_ui(G_login_ui, 0)	    			--log("\nshow_login_ui38   ")-- 装备中宝石购买界面
		
		SkipLoadResource(1)
		InitMail_UI(G_login_ui, 0)							--log("\nshow_login_ui39   ")-- 邮件界面
		InitTalk_UI(G_login_ui, 0)							--log("\nshow_login_ui399   ")-- 好友界面
		SkipLoadResource(0)	
				
		game_equip_creatpullPic(G_login_ui)					-- 拖拽
		Fightbag_creatSmallpullPic(G_login_ui)  			-- 拖拽
        Market_creatpullPicMarket(G_login_ui)				-- 拖拽
		
		InitPlayerRoleInfo_ui(G_login_ui,0)					-- 按C界面
		
		-- 设置界面
		SkipLoadResource(1)
		InitSetup_UI(G_login_ui, 0)
		InitSetup_FaceUI(g_setup_ui, 0)
		InitSetup_GameUI(g_setup_ui, 0)
		InitSetup_KeypressUI(g_setup_ui, 0)
		InitSetup_ImpeachUI(g_setup_ui, 0)
		InitSetup_QuitUI(g_setup_ui, 0)
		InitSetup_SafeUI(g_setup_ui, 0)
		InitSetup_AccuseUI(G_login_ui, 0)
		InitTalkMessageBox_ui(G_login_ui,0)	
		
		InitRoomList_ui(G_login_ui,0)						-- 比赛界面
		InitRoomFounder_ui(G_login_ui,0)
		InitRoomFind_ui(G_login_ui,0)
		InitRoomPassword_ui(G_login_ui,0)
		InitRoomSet_ui(G_login_ui,0)
		
		InitInputBox_ui(G_login_ui,0)
		
		InitShopBuy_ui(G_login_ui, 0)						-- 商城购买界面
		InitBagBuyUi(G_login_ui, 0)
		InitSetup_PassWord(G_login_ui,0)
		InitLoading_ui(G_login_ui,0)
		
		InitMessageBox_ui(G_login_ui,0)
		InitExitWait_ui(G_login_ui,0)
		InitEqMessageBox_ui(G_login_ui,0)
		InitAutoBox_ui(G_login_ui,0)	
		SkipLoadResource(0)
				
	end
	G_login_ui:SetVisible(bisopen)
end

function CreateHall()
	ShopCreateResource()
	
	g_game_hero_ui:CreateResource()
	g_PlayerInfo_ui:CreateResource()
	g_game_heroTalent_ui:CreateResource()
	g_game_fight_ui:CreateResource()
	g_GameTeamFight_ui:CreateResource()
	
	g_task_ui:CreateResource()
	g_task_signin_ui:CreateResource()
	g_task_limittime_ui:CreateResource()
	g_task_growup_ui:CreateResource()
	g_task_sevenday_ui:CreateResource()
	g_task_newserver_ui:CreateResource()
	
	g_game_start_ui:CreateResource()
	g_game_chosehero_ui:CreateResource()
	g_game_SkinFrame_ui:CreateResource()
	n_summonerskill_ui:CreateResource()
	
	n_roomlist_ui:CreateResource()
	n_roomfounder_ui:CreateResource()
	n_roomfind_ui:CreateResource()
	n_roompassword_ui:CreateResource()
	n_roomset_ui:CreateResource()	
	
end
function ReleaseHall()
	ShopDeleteResource()
	
	g_game_hero_ui:DeleteResource()
	g_PlayerInfo_ui:DeleteResource()
	g_game_heroTalent_ui:DeleteResource()
	g_game_fight_ui:DeleteResource()
	g_GameTeamFight_ui:DeleteResource()
	
	g_task_ui:DeleteResource()
	g_task_signin_ui:DeleteResource()
	g_task_limittime_ui:DeleteResource()
	g_task_growup_ui:DeleteResource()
	g_task_sevenday_ui:DeleteResource()
	g_task_newserver_ui:DeleteResource()
	
	g_game_start_ui:DeleteResource()
	g_game_chosehero_ui:DeleteResource()
	g_game_SkinFrame_ui:DeleteResource()
	n_summonerskill_ui:DeleteResource()
	
	n_roomlist_ui:DeleteResource()
	n_roomfounder_ui:DeleteResource()
	n_roomfind_ui:DeleteResource()
	n_roompassword_ui:DeleteResource()
	n_roomset_ui:DeleteResource()
	
end












