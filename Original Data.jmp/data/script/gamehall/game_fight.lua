include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 永恒竞技、永恒战场、勇者斗恶龙、天梯排位、二次元杀阵
local btn_ListBK = nil
local btn_Forever = nil
local btn_ForeverWar = nil
local btn_Dragon = nil
local btn_Rank = nil
local btn_battleArray = nil

local flag_YHJJ = nil		-- 永恒竞技父节点
local flag_YHZC = nil		-- 永恒战场父节点
local flag_YZDEL = nil		-- 勇者斗恶龙父节点
local flag_TTPW = nil		-- 天梯排位父节点
local flag_ECYSZ = nil
local QualityCount = nil 	-- 节操值

-- PlayMode
local EPLAYMODE_MATCH_ATH = 0
local EPLAYMODE_MATCH_BATTLE = 1
local EPLAYMODE_MATCH_RANK = 2
local EPLAYMODE_FUN_PVE0 = 3
local EPLAYMODE_FUN_PVE1 = 4
local EPLAYMODE_FUN_PVE2 = 5
local EPLAYMODE_FUN_PVE3 = 6
local EPLAYMODE_FUN_PVP0 = 7
local EPLAYMODE_FUN_PVP1 = 8
local EPLAYMODE_FUN_PVP2 = 9
local EPLAYMODE_FUN_PVP3 = 10
local EPLAYMODE_DEAD_BATTLE = 11
local EPLAYMODE_MAX = 12

-- 任务感叹号~
local GanTanHao = nil
local GanTanHaoCount = nil
local GanTanHaoCountbg = nil

-- 勇者斗恶龙界面相关成员
local img_YZDEL_InfoFrame = nil		-- 信息底
local CurPage = 1					-- 当前页数
local AllPage = 3					-- 总页数
local MonsterInfo = {}				-- 怪物档案
local MonsterParticularInfo = {}	-- 怪物详细信息
local btn_ShowParticularInfo = {}	-- 显示详细信息按钮
local MonsterName = {"白熊召唤符","红库巴召唤符","蓝库巴召唤符","青眼白龙召唤符","欧西里斯天空龙召唤符","群龙召唤符"}
local IsOpenParticularInfo = false	-- 是否打开具体信息
local DropoutGoodsList = {}			-- 掉落物品List
local btn_Buy = {}					-- 购买按钮
local HavedItem = {}				-- 已经拥有的召唤符
local HavedCount = {}				-- 已拥有的召唤符的数量
local HavedCountFont = {}			-- 已拥有的召唤符的数量文字
local LogPlayerName_YZDEL = nil		-- 勇者斗恶龙击杀消息中玩家的名字
local LogMonsterName_YZDEL = nil	-- 勇者斗恶龙击杀消息中怪物的名字
local LogItemName_YZDEL = nil		-- 勇者斗恶龙击杀消息中道具的名字
local LogFont = nil					-- 最后通过此成员输出
local LogFontList = {}				-- 公告栏消息表

-- 永恒战场相关成员
local GongGao = nil					-- 公告
local PL = nil						-- 体力值
local PlaceTime_YHZC = nil			-- 限制时间
local GongGao1 = nil				-- 公告
local EquipDeploy = nil				-- 装备配置按钮

-- 相关按钮~
local pNewClassButton_YHJJ = nil	-- 新手教学按钮
local pNewClassButton_YHZC = nil
local pSoloSoloButton_YHJJ = nil	-- Solo
local pSoloSoloButton_YHZC = nil
local pTeamButton_YHJJ = nil		-- 组队战斗
local pTeamButton_YHZC = nil
local pTeamButton_YZDEL = nil
local pSingleButton_YHJJ = nil		-- 单人匹配
local pSingleButton_YHZC = nil
local pSingleButton_YZDEL = nil
local pSingleButton_TTPW = nil
local pSingleButton_ECYSZ = nil
local pDeathButton_YZDEL = nil		-- 跨服战场

-- 背景图片和Logo图片切换
local fightBK = nil
local fightLogo = nil
local FightBKPic = {path_mode.."BK_mode.png",path_mode.."BK_mode.png",path_mode.."BK_mode.png",path_mode.."BK_mode.png",path_mode.."BK_mode.png"}
local FightLogoPic = {path_mode.."logo1_mode.png",path_mode.."logo2_mode.png",path_mode.."logo3_mode.png",path_mode.."logo4_mode.png",path_mode.."logo5_mode.png"}

function InitGame_FightUI(wnd, bisopen)
	g_game_fight_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainGame_Fight(g_game_fight_ui)
	g_game_fight_ui:SetVisible(bisopen)
end

function InitMainGame_Fight(wnd)
	
	fightBK = wnd:AddImage(FightBKPic[1],0,0,1280,800)
	fightBK:AddEffect("..\\Data\\Magic\\Common\\UI\\changwai\\moshixuanze\\tx_UI_CW_moshixuanze_01.x",0,0,1280,800)
	fightLogo = fightBK:AddImage(FightLogoPic[1],0,111,540,520)
		
	-- 上边栏
	wnd:AddImage(path.."upBK_hall.png",0,0,1280,54)
	wnd:AddImage(path.."upLine2_hall.png",0,54,1280,35)
	for i=1,4 do
		wnd:AddImage(path.."linecut_hall.png",163+110*i,60,2,32)
	end
	
	-- 战斗模式选择
	btn_ListBK = wnd:AddImage(path_start.."ListBK_start.png",135,53,256,38)
	-- 永恒竞技
	btn_Forever = wnd:AddCheckButton(path_start.."indexA1_start.png",path_start.."indexA2_start.png",path_start.."indexA3_start.png",165,53,110,33)
	XWindowEnableAlphaTouch(btn_Forever.id)
	btn_Forever:SetCheckButtonClicked(1)
	btn_Forever.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		XSetGameType_Fight(0)
		btn_ListBK:SetPosition(135,53)
		
		-- fightBK.changeimage(FightBKPic[1])
		fightLogo.changeimage(FightLogoPic[1])
		
		btn_ForeverWar:SetCheckButtonClicked(0)
		btn_Dragon:SetCheckButtonClicked(0)
		btn_Rank:SetCheckButtonClicked(0)
		btn_battleArray:SetCheckButtonClicked(0)
		flag_YHJJ:SetVisible(1)
		flag_YHZC:SetVisible(0)
		flag_YZDEL:SetVisible(0)
		flag_TTPW:SetVisible(0)
		flag_ECYSZ:SetVisible(0)
	end
	-- 永恒战场
	btn_ForeverWar = wnd:AddCheckButton(path_start.."indexB1_start.png",path_start.."indexB2_start.png",path_start.."indexB3_start.png",275,53,110,33)
	XWindowEnableAlphaTouch(btn_ForeverWar.id)
	btn_ForeverWar.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		XIsOpenYHZC()
		XSetGameType_Fight(1)
		btn_ListBK:SetPosition(245,53)
		-- fightBK.changeimage(FightBKPic[2])
		fightLogo.changeimage(FightLogoPic[2])
		
		btn_Forever:SetCheckButtonClicked(0)
		btn_Dragon:SetCheckButtonClicked(0)
		btn_Rank:SetCheckButtonClicked(0)
		btn_battleArray:SetCheckButtonClicked(0)
		flag_YHJJ:SetVisible(0)
		flag_YHZC:SetVisible(1)
		flag_YZDEL:SetVisible(0)
		flag_TTPW:SetVisible(0)
		flag_ECYSZ:SetVisible(0)
	end
	-- 勇者斗恶龙
	btn_Dragon = wnd:AddCheckButton(path_start.."indexC1_start.png",path_start.."indexC2_start.png",path_start.."indexC3_start.png",385,53,110,33)
	XWindowEnableAlphaTouch(btn_Dragon.id)
	btn_Dragon.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		XSetGameType_Fight(3)
		btn_ListBK:SetPosition(355,53)
		-- fightBK.changeimage(FightBKPic[3])
		fightLogo.changeimage(FightLogoPic[3])
		
		btn_Forever:SetCheckButtonClicked(0)
		btn_ForeverWar:SetCheckButtonClicked(0)
		btn_Rank:SetCheckButtonClicked(0)
		btn_battleArray:SetCheckButtonClicked(0)
		flag_YHJJ:SetVisible(0)
		flag_YHZC:SetVisible(0)
		flag_YZDEL:SetVisible(1)
		flag_TTPW:SetVisible(0)
		flag_ECYSZ:SetVisible(0)
	end
	-- 天梯排位
	btn_Rank = wnd:AddCheckButton(path_start.."indexD1_start.png",path_start.."indexD2_start.png",path_start.."indexD3_start.png",495,53,110,33)
	XWindowEnableAlphaTouch(btn_Rank.id)
	-- btn_Rank:SetEnabled(0)
	btn_Rank.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		XSetGameType_Fight(2)
		btn_ListBK:SetPosition(465,53)
		-- fightBK.changeimage(FightBKPic[4])
		fightLogo.changeimage(FightLogoPic[4])
		
		btn_Forever:SetCheckButtonClicked(0)
		btn_Dragon:SetCheckButtonClicked(0)
		btn_ForeverWar:SetCheckButtonClicked(0)
		btn_battleArray:SetCheckButtonClicked(0)
		flag_YHJJ:SetVisible(0)
		flag_YHZC:SetVisible(0)
		flag_YZDEL:SetVisible(0)
		flag_TTPW:SetVisible(1)
		flag_ECYSZ:SetVisible(0)
	end
	-- 二次元杀阵
	btn_battleArray = wnd:AddCheckButton(path_start.."indexE1_start.png",path_start.."indexE2_start.png",path_start.."indexE3_start.png",605,53,110,33)
	XWindowEnableAlphaTouch(btn_battleArray.id)
	btn_battleArray.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(575,53)
		-- fightBK.changeimage(FightBKPic[5])
		fightLogo.changeimage(FightLogoPic[5])
		
		btn_Forever:SetCheckButtonClicked(0)
		btn_Dragon:SetCheckButtonClicked(0)
		btn_Rank:SetCheckButtonClicked(0)
		btn_ForeverWar:SetCheckButtonClicked(0)
		flag_YHJJ:SetVisible(0)
		flag_YHZC:SetVisible(0)
		flag_YZDEL:SetVisible(0)
		flag_TTPW:SetVisible(0)
		flag_ECYSZ:SetVisible(1)
	end
	
	
	-- 永恒竞技
	flag_YHJJ = CreateWindow(wnd.id, 0, 0, 1280, 800) -- 这里只是创建一个永恒竞技部分UI的父节点，并没有显示
	pNewClassButton_YHJJ = flag_YHJJ:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",444,666, 179, 56)
	pNewClassButton_YHJJ:AddFont("新手教学", 15, 8, 0, 0, 179, 56, 0xffffff)
	pSoloSoloButton_YHJJ = flag_YHJJ:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",637,666, 179, 56)
	pSoloSoloButton_YHJJ:AddFont("SOLO 单挑", 15, 8, 0, 0, 179, 56, 0xffffff)
	pTeamButton_YHJJ = flag_YHJJ:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",830,666, 179, 56)
	pTeamButton_YHJJ:AddFont("组队战斗", 15, 8, 0, 0, 179, 56, 0xffffff)
	pSingleButton_YHJJ = flag_YHJJ:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",1023,666, 179, 56)
	pSingleButton_YHJJ:AddFont("单人匹配", 15, 8, 0, 0, 179, 56, 0xffffff)
	pNewClassButton_YHJJ.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameStartXinShouJiaoXue( EPLAYMODE_MATCH_ATH )
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
	pSoloSoloButton_YHJJ.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameFightSolo(EPLAYMODE_MATCH_ATH)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
	pTeamButton_YHJJ.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGetIsLeader(1)
		XGameTeamFight(EPLAYMODE_MATCH_ATH)
		XSetTeamType(1)				-- 1表示当前队伍类型是组队，0表示单人
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
		if (XGetWaitTimeIsVisible() == 0) then
			SetTeamFightVisible(1, 0)	-- 打开组队界面
		end
	end
	pSingleButton_YHJJ.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XStartCrossServerGame(EPLAYMODE_MATCH_ATH)
		XSetTeamType(0)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
	
	-- 永恒战场
	flag_YHZC = CreateWindow(wnd.id, 0, 0, 1280, 800)
	pNewClassButton_YHZC = flag_YHZC:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 251, 666,  179, 56)	
	pNewClassButton_YHZC:AddFont("新手教学", 15, 8, 0, 0, 179, 56, 0xffffff)
	pDeathButton_YZDEL = flag_YHZC:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 444, 666,  179, 56)
	pDeathButton_YZDEL:AddFont("跨服战场", 15, 8, 0, 0, 179, 56, 0xffffff)
	pDeathButton_YZDEL:AddFont("19:00 - 21:00 开放", 15, 8, 0, 20, 179, 15, 0xff0000)
	PL = pDeathButton_YZDEL:AddFont("", 15, 8, 0, 65, 179, 56, 0xffffff)
	pSoloSoloButton_YHZC = flag_YHZC:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 637, 666,  179, 56)
	pSoloSoloButton_YHZC:AddFont("SOLO 单挑", 15, 8, 0, 0, 179, 56, 0xffffff)
	pTeamButton_YHZC = flag_YHZC:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 830, 666,  179, 56)	
	pTeamButton_YHZC:AddFont("组队战斗", 15, 8, 0, 0, 179, 56, 0xffffff)
	pSingleButton_YHZC = flag_YHZC:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 1023, 666,  179, 56)
	pSingleButton_YHZC:AddFont("单人游戏", 15, 8, 0, 0, 179, 56, 0xffffff)
	
	GongGao1 = flag_YHZC:AddImage(path_mode.."logozc_mode.png",365,425,793,215)
	EquipDeploy = flag_YHZC:AddButton(path_mode.."zcan1_mode.png",path_mode.."zcan2_mode.png",path_mode.."zcan3_mode.png",930,515,256,64)
	EquipDeploy:AddFont("装备配置",20,0,24,2,100,20,0xffffffff)
	
	pSoloSoloButton_YHZC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameFightSolo(EPLAYMODE_MATCH_BATTLE)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
	pSingleButton_YHZC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameStartOneHeroGame(EPLAYMODE_MATCH_BATTLE)
		XSetTeamType(0)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
	pNewClassButton_YHZC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameStartXinShouJiaoXue( EPLAYMODE_MATCH_BATTLE )
		XSetTeamType(0)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
	pDeathButton_YZDEL.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XStartCrossServerGame(EPLAYMODE_MATCH_BATTLE)
		XSetTeamType(0)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
	pTeamButton_YHZC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGetIsLeader(1)
		XGameTeamFight(EPLAYMODE_MATCH_BATTLE)
		XSetTeamType(1)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
		if (XGetWaitTimeIsVisible() == 0) then
			SetTeamFightVisible(1, 1)	-- 打开组队界面
		end
	end
	EquipDeploy.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_O_OpenEquip()
	end
	
	-- 勇者斗恶龙
	flag_YZDEL = CreateWindow(wnd.id, 0, 0, 1280, 800)
	pTeamButton_YZDEL = flag_YZDEL:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 830, 666,  179, 56)
	pTeamButton_YZDEL:AddFont("组队战斗", 15, 8, 0, 0, 179, 56, 0xffffff)
	pSingleButton_YZDEL = flag_YZDEL:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 1023, 666,  179, 56)
	pSingleButton_YZDEL:AddFont("单人游戏", 15, 8, 0, 0, 179, 56, 0xffffff)
	pSingleButton_YZDEL.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameStartOneHeroGame(EPLAYMODE_FUN_PVE0)
		XSetTeamType(0)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
	pTeamButton_YZDEL.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGetIsLeader(1)
		XGameTeamFight(EPLAYMODE_FUN_PVE0)
		XSetTeamType(1)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
		if (XGetWaitTimeIsVisible() == 0) then
			SetTeamFightVisible(1, 0)	-- 打开组队界面
		end
	end
		
	-- 天梯排位
	flag_TTPW = CreateWindow(wnd.id, 0, 0, 1280, 800)
	pSingleButton_TTPW = flag_TTPW:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 1023, 666,  179, 56)
	pSingleButton_TTPW:AddFont("单人游戏", 15, 8, 0, 0, 179, 56, 0xffffff)
	-- pSingleButton_TTPW:AddFont("19:00 - 23:00 开放", 15, 0, 25, -20, 200, 15, 0xff0000)
	pSingleButton_TTPW:AddFont("敬请期待", 15, 8, 0, 20, 179, 15, 0xff0000)
	pSingleButton_TTPW:SetEnabled(0)
	pSingleButton_TTPW.script[XE_LBUP] = function()
		XStartCrossServerGame(EPLAYMODE_MATCH_RANK)
		XSetTeamType(0)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
		
		
	-- 二次元杀阵
	flag_ECYSZ = CreateWindow(wnd.id, 0, 0, 1280, 800) 
	pSingleButton_ECYSZ = flag_ECYSZ:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png", 1023, 666,  179, 56)
	pSingleButton_ECYSZ:AddFont("单人游戏", 15, 8, 0, 0, 179, 56, 0xffffff)
	pSingleButton_ECYSZ:AddFont("18:00 - 22:00 开放", 15, 8, 0, 20, 179, 15, 0xff0000)
	pSingleButton_ECYSZ.script[XE_LBUP] = function()
		XGameStartOneHeroGame(EPLAYMODE_FUN_PVP0)
		XSetTeamType(0)
		SetGameHallIsVisible(1)		-- 退回大厅界面
		g_game_fight_ui:SetVisible(0)
	end
end


function GetMySelfInfo()
	PlayerInfop[1].id = nil
	PlayerInfop[1].name = "角色名字七个字"
	PlayerInfop[1].Lv = "40"
end

function GetQualityCount(count)
	QualityCount = count
end
-- 从背包中得到召唤符的个数
function GetZhaoHuanFuCount(Count, Type)
	--HavedCountFont[Type+1]:SetFontText(tostring(Count),0xffffffff)
end

function ClearHavedItemCount()
	-- for i = 1, #HavedCountFont do
		-- HavedCountFont[i]:SetFontText("0", 0xffffffff)
	-- end
	-- img_SoloItemCount:SetFontText("0", 0xffffffff)
end

-- 设置限制时间的颜色
function SetPlaceTimeColor(CColor)
	-- if (CColor == 0) then
		-- --GongGao:SetVisible(1)
		-- pDeathButton_YZDEL:SetEnabled(0)
		-- --PlaceTime_YHZC:SetFontText("18:00 — 22:00  ", 0xffE62A21)
	-- else
		-- --GongGao:SetVisible(0)
		-- pDeathButton_YZDEL:SetEnabled(1)
		-- --PlaceTime_YHZC:SetFontText("18:00 — 22:00 ", 0xff60C65E)
	-- end
end

-- 得到体力值
function GetPL_GameFight(Cpl)
	if PL then
		PL:SetFontText(Cpl, 0x00ff00) -- 0xff605AA4
	end
end

-- 得到未完成任务的数量
function GetTaskCount(Count)
	if (GanTanHaoCount ~= nil) then
		GanTanHaoCount:SetFontText(""..Count,0xffffffff)
	end
end

-- 得到勇者斗恶龙中玩家击杀的怪物名称
function GetKillMonsterName(Name)
	LogMonsterName_YZDEL = Name
end

-- 得到勇者斗恶龙中玩家的名称
function GetYZDELPlayerName(Name)
	LogPlayerName_YZDEL = Name
end

-- 得到勇者斗恶龙中掉落道具的名称
function GetYZDELItemName(Name)
	LogItemName_YZDEL = Name
end

function GetLogFont()
	LogFont = "["..LogPlayerName_YZDEL.."]召唤["..LogMonsterName_YZDEL.."]并成功推到，拾取["..LogItemName_YZDEL.."]。"
	--log("\n"..LogFont)
end

function ShowLogFont()
	if (LogFontList[1] == nil) then
		LogFontList[1] = img_YZDEL_InfoFrame:AddFont(LogFont,18,0,0,0,180,40,0xffffffff)
	end
end

function IsFocusOn_SOLOUI()
	if (g_game_fight_ui:IsVisible() == true) then
		-- 搜索框框
		local Input_Focus = userinput_solo:IsFocus()
		
		if Input_Focus == true then
			font_Solo:SetVisible(0)
		elseif Input_Focus == false and font_Solo:IsVisible() == false then
			userinput_solo:SetEdit("")
			font_Solo:SetVisible(1)
		end
	end
end

function SetButtonState_Fright( cIndex, cState)
	if cIndex == 0 then
		pDeathButton_YZDEL:SetEnabled(cState)
	elseif cIndex == 1 then
		pNewClassButton_YHJJ:SetEnabled(cState)
		pNewClassButton_YHZC:SetEnabled(cState)
	elseif cIndex == 2 then
		pSoloSoloButton_YHJJ:SetEnabled(cState)
	    pSoloSoloButton_YHZC:SetEnabled(cState)
	elseif cIndex == 3 then
		pTeamButton_YHJJ:SetEnabled(cState)
	    pTeamButton_YHZC:SetEnabled(cState)
	    pTeamButton_YZDEL:SetEnabled(cState)
	elseif cIndex == 4 then
		pSingleButton_YHJJ:SetEnabled(cState)
	    pSingleButton_YHZC:SetEnabled(cState)
	    pSingleButton_YZDEL:SetEnabled(cState)
	    -- pSingleButton_TTPW:SetEnabled(cState)
	end
end

-- 设置显示
function SetGameFightIsVisible(flag) 
	if flag == 1 and g_game_fight_ui:IsVisible() == false then
		XSetGameType_Fight(0)
		btn_Forever:SetCheckButtonClicked(1)
		btn_Dragon:SetCheckButtonClicked(0)
		btn_Rank:SetCheckButtonClicked(0)
		btn_ForeverWar:SetCheckButtonClicked(0)
		btn_battleArray:SetCheckButtonClicked(0)
		
		flag_YHJJ:SetVisible(1)
		flag_YHZC:SetVisible(0)
		flag_YZDEL:SetVisible(0)
		flag_TTPW:SetVisible(0)
		flag_ECYSZ:SetVisible(0)
		
		btn_ListBK:SetPosition(135,53)
		btn_ListBK:SetVisible(1)
		-- fightBK.changeimage(FightBKPic[1])
		fightLogo.changeimage(FightLogoPic[1])
		
		g_game_fight_ui:SetVisible(1)
		SetFourpartUIVisiable(2)
		
		XShopUiIsClick(1, 1)
	elseif flag == 0 and g_game_fight_ui:IsVisible() == true then
		g_game_fight_ui:SetVisible(0)
	end
end

function GetGameFightIsVisible()  
    if g_game_fight_ui~=nil and g_game_fight_ui:IsVisible()==true then
        return 1
    else
        return 0
    end
end
