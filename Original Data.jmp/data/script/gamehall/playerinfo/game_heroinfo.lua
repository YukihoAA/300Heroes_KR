include("../Data/Script/Common/include.lua")

local btn_ListBK2 = nil

-- 称号
local btn_hideCall = nil
local Font_hideCall = nil
local btn_hideCallBK = {}
local btn_hideCallFont = {"隐藏称号","最佳坦克","最佳战士","最佳刺客","最佳射手","最佳法师","最佳辅助"}
local index_hideCall = 1
local exp_red = nil
local exp_current = 20000
local exp_all = 50000

-- 常用英雄、最近战绩
local heroInfo_togglebtn = nil
local heroInfo_togglebtn2 = nil

-- 个人数据库
local btn_left = nil
local btn_right = nil
local data_list = {"拥有英雄","英雄皮肤","英雄专属","战场装备","永恒神器","成就称号"}
local data_percent = {0.6,0.6,0.6,0.6,0.6,0.6}
-- {"10%","20%","30%","40%","50%","60%"}
local data_num = {999,999,999,999,999,999}
local img_columns = {}
local font_list = {}
local font_percent = {}
local font_num = {}

-- 玩家的信息资料
local PlayerInfo_strName = nil			-- 玩家名称

local PlayerInfo_m_expCurrent = nil		-- 玩家当前经验
local PlayerInfo_m_expAll = nil			-- 总经验
local PlayerInfo_m_call = nil			-- 玩家称号
local PlayerInfo_m_character = nil		-- 玩家节操值
local PlayerInfo_m_level = nil			-- 玩家等级
local PlayerInfo_m_vip = nil			-- 玩家VIP等级

local PlayerInfo_m_hero = nil			-- 拥有英雄数量
local PlayerInfo_m_skin = nil			-- 拥有皮肤数量
local PlayerInfo_m_pertain = nil		-- 英雄专属数量
local PlayerInfo_m_equip = nil			-- 战场装备数量
local PlayerInfo_m_bestEquip = nil		-- 永恒神器数量
local PlayerInfo_m_honour = nil			-- 成就称号数量

local PlayerInfo_p_hero = nil			-- 拥有英雄百分比
local PlayerInfo_p_skin = nil			-- 拥有皮肤百分比
local PlayerInfo_p_pertain = nil		-- 英雄专属百分比
local PlayerInfo_p_equip = nil			-- 战场装备百分比
local PlayerInfo_p_bestEquip = nil		-- 永恒神器百分比
local PlayerInfo_p_honour = nil			-- 成就称号百分比

local PlayerInfo_str_vs = nil			-- 竞技场战绩--对战胜率
local PlayerInfo_str_solo = nil			-- 竞技场战绩--solo胜率
local PlayerInfo_kill = nil
local PlayerInfo_defence = nil 
local PlayerInfo_assist = nil
local PlayerInfo_isSkin = nil
local PlayerInfo_iX = nil
local PlayerInfo_iY = nil
local PlayerInfo_iW = nil
local PlayerInfo_iH = nil

-- 数据界面
local player_pic = nil
local player_name = nil
local player_character = nil
local player_level = nil
local player_exp = nil
local player_vs = nil		-- 对战胜率
local player_solo = nil		-- solo胜率

local player_kill, killLevel_icon = nil
local player_defence, defenceLevel_icon= nil
local player_assist, assistLevel_icon = nil
local player_vip = nil

local Kill_icon = {path_info.."kill_info1.png",path_info.."kill_info2.png",path_info.."kill_info3.png",path_info.."kill_info4.png",path_info.."kill_info5.png",path_info.."kill_info6.png"}
local Defence_icon = {path_info.."defence_info1.png",path_info.."defence_info2.png",path_info.."defence_info3.png",path_info.."defence_info4.png",path_info.."defence_info5.png",path_info.."defence_info6.png"}
local Assist_icon = {path_info.."assist_info1.png",path_info.."assist_info2.png",path_info.."assist_info3.png",path_info.."assist_info4.png",path_info.."assist_info5.png",path_info.."assist_info6.png"}

local TitleList = {}

local LastFightInfo = {}
LastFightInfo.Kill = {}
LastFightInfo.Aid = {}
LastFightInfo.Monster = {}
LastFightInfo.KillF = {}
LastFightInfo.AidF = {}
LastFightInfo.MonsterF = {}
LastFightInfo.KillI = {}
LastFightInfo.AidI = {}
LastFightInfo.MonsterI = {}
LastFightInfo.Date = {}
LastFightInfo.Result = {}

local MastBestHeroInfo = {}
MastBestHeroInfo.Win = {}
MastBestHeroInfo.Lose = {}
MastBestHeroInfo.WinI = {}
MastBestHeroInfo.LoseI = {}

-- 玩家召唤师头像
local summoner_ui = nil
local summoner_bk = nil
local summoner_posx = {}
local summoner_posy = {}
local summoner_side = {}
local summoner_head = {}
-- local summoner_click = nil
local last_pictureName = nil		-- 点击取消还原
local click_index = -1

local btn_summoner_Confirm, btn_summoner_Cancel = nil
local summoner_toggleBK = nil
local summoner_togglebtn = nil
local Many_SummonerHead = 0
local updownCount = 0
local maxUpdown = 0

-- 通信
local SummonerInfo = {}
SummonerInfo.pictureName = {}
-- SummonerInfo.x = {}
-- SummonerInfo.y = {}
-- SummonerInfo.w = {}
-- SummonerInfo.h = {}	
SummonerInfo.Id = {}

local SummonerStateListMaxCount = 5
local SummonerState = {}
local SummonerStateTimeFont = {}

local MaxDesignCount = 0 -- 玩家拥有的称号个数
local CurShowDesignIndex = 1 -- 从数组的哪个位置开始显示

function InitGame_HeroInfoUI(wnd, bisopen)
	g_game_heroInfo_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainGame_HeroInfo(g_game_heroInfo_ui)
	g_game_heroInfo_ui:SetVisible(bisopen)
end

function InitMainGame_HeroInfo(wnd)
	
	-- 玩家头像
	player_pic = wnd:AddImage(path_info.."headpic_info.png",72,178,130,130)
	player_pic:SetTextTip("点击更换头像")
	player_pic.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		if summoner_ui:IsVisible() then
			summoner_ui:SetVisible(0)
			if click_index > 0 then
				last_pictureName = SummonerInfo.pictureName[click_index]
				XClickSummonerHeadIndex(SummonerInfo.Id[click_index])
			end
		else
			summoner_ui:SetVisible(1)
		end
		
		click_index = -1
		-- summoner_click:SetVisible(0)
	end
	
	for i=1, SummonerStateListMaxCount do
		SummonerState[i] = wnd:AddImage(path_info.."checkbox_info.png", 65+((i-1)*35), 330, 32, 32)
		SummonerState[i]:SetVisible(0)
		SummonerState[i]:AddImage(path_info.."sumclick_info.png", 0, 0, 32, 32)
		SummonerStateTimeFont[i] = SummonerState[i]:AddFont("", 12, 8, 0, -32, 32, 20, 0xffffff)
		-- SummonerStateTimeFont[i]:SetVisible(0)
	end
	
	wnd:AddImage(path_info.."headside_info.png",58,164,158,158)
	player_name = wnd:AddFont("英雄名字七个字", 18, 0, 225, 166, 200, 20, 0xff6ffefc)
	wnd:AddFont("称    号", 15, 0, 226, 200, 100, 20, 0x8b83e6)
	-- 节操
	wnd:AddFont("节操值", 15, 0, 226, 243, 100, 20, 0x8b83e6)
	player_character = wnd:AddFont("54321", 15, 0, 285, 246, 200, 20, 0x8296d1)
	-- 等级
	wnd:AddFont("        级", 15, 0, 226, 287, 100, 20, 0x8b83e6)
	player_level = wnd:AddFont("39", 15, 0, 228, 287, 100, 20, 0xffffff)
	
	wnd:AddImage(path_info.."expall_info.png",290,290,512,16)
	exp_red = wnd:AddImage(path_info.."expme_info.png",290,290,512,16)
	wnd:SetAddImageRect(exp_red.id, 0, 0, (exp_current/exp_all)*352, 16, 290 ,290, (exp_current/exp_all)*352, 16)
	player_exp = wnd:AddFont("0/0", 15, 8, -290, -287, 352, 20, 0x8296d1)
	
	player_vip = wnd:AddImage(path_info.."VIP10.png",550,180,128,128)
	local RankSearch = wnd:AddButton(path_info.."search1_info.png", path_info.."search2_info.png", path_info.."search3_info.png",415,160,32,32)
	RankSearch:SetTextTip("点击上300英雄战绩网查找战绩")
	RankSearch.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickRankSearch(1)
	end
	-- 称号
	btn_hideCall = wnd:AddTwoButton(path_info.."call1_info.png", path_info.."call2_info.png", path_info.."call1_info.png",285,200,160,32)
	Font_hideCall = btn_hideCall:AddFont("隐藏称号",12,0,-4,2,200,12,0xbeb5ee)
	-- 隐藏称号下拉背景框
	hideCall_BK = wnd:AddImage(path_info.."call4_info.png",285,220,160,256)
	XSetAddImageRect( hideCall_BK.id, 0, 0, 160, 20, 285, 220, 160, 20)
	hideCall_BK:SetVisible(0)
	
	XWindowEnableAlphaTouch(hideCall_BK.id)
	hideCall_BK:EnableEvent(XE_MOUSEWHEEL)
	hideCall_BK.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		if updown>0 then
			-- 上
			if CurShowDesignIndex<=1 then
				CurShowDesignIndex = 1
			else
				CurShowDesignIndex = CurShowDesignIndex-1
			end
		elseif updown<0 then
			-- 下
			if CurShowDesignIndex >= #btn_hideCallFont then
				CurShowDesignIndex = #btn_hideCallFont
			else
				CurShowDesignIndex = CurShowDesignIndex+1
			end
		end
		
		for i = 1, 7 do
			btn_hideCallBK[i]:SetTransparent(0)
			TitleList[i]:SetFontText(btn_hideCallFont[i + CurShowDesignIndex - 1], 0xbeb5ee)
		end
	end
	
	for dis = 1,7 do
		btn_hideCallBK[dis] = wnd:AddImage(path_info.."call3_info.png",285,200+dis*20,160,32)
		TitleList[dis] = hideCall_BK:AddFont("",12,0,-4,dis*20-18,160,32,0xbeb5ee)
		btn_hideCallBK[dis]:SetTransparent(0)
		btn_hideCallBK[dis]:SetTouchEnabled(0)
		
		-- 鼠标滑过
		btn_hideCallBK[dis].script[XE_ONHOVER] = function()
			if hideCall_BK:IsVisible() == true then
				if (dis+CurShowDesignIndex-1) <= #btn_hideCallFont then
					if btn_hideCallFont[dis+CurShowDesignIndex-1] ~= "" then
						btn_hideCallBK[dis]:SetTransparent(1)
					end
				end
			end
		end
		btn_hideCallBK[dis].script[XE_ONUNHOVER] = function()
			if hideCall_BK:IsVisible() == true then
				if (dis+CurShowDesignIndex-1) <= #btn_hideCallFont then
					if btn_hideCallFont[dis+CurShowDesignIndex-1] ~= "" then
						btn_hideCallBK[dis]:SetTransparent(0)
					end
				end
			end
		end
		btn_hideCallBK[dis].script[XE_LBUP] = function()
			if (dis+CurShowDesignIndex-1) <= #btn_hideCallFont then
				if btn_hideCallFont[dis+CurShowDesignIndex-1] ~= "" then
					XClickComboBoxList(btn_hideCallFont[dis+CurShowDesignIndex-1])
					Font_hideCall:SetFontText(btn_hideCallFont[dis+CurShowDesignIndex-1],0xbeb5ee)
					index_hideCall = dis
					
					btn_hideCall:SetButtonFrame(0)
					hideCall_BK:SetVisible(0)
					for index = 1, 7 do
						btn_hideCallBK[index]:SetTransparent(0)
						btn_hideCallBK[index]:SetTouchEnabled(0)
					end
				end
			end
		end
	end
	
	btn_hideCall.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if hideCall_BK:IsVisible() then
			hideCall_BK:SetVisible(0)
			for index = 1, 7 do
				btn_hideCallBK[index]:SetTransparent(0)
				btn_hideCallBK[index]:SetTouchEnabled(0)
			end
		else
			hideCall_BK:SetVisible(1)
			for index = 1, 7 do
				btn_hideCallBK[index]:SetTransparent(0)
				btn_hideCallBK[index]:SetTouchEnabled(1)
			end
		end
	end
	
	-- 常用英雄、最近战绩
	wnd:AddImage(path_info.."Font5_info.png",760,160,128,32)
	wnd:AddImage(path_info.."Font6_info.png",1017,160,128,32)
	
	for i = 1,10 do
		posy = 138+57*math.ceil(i/2)
		if i%2 == 0 then
			posx = 954
		else
			posx = 692
		end
		wnd:AddImage(path_info.."line2_info.png",posx,posy,256,2)
	end
	
	-- 常用英雄滚动条
	-- local heroInfo_toggleImg = wnd:AddImage(path.."toggleBK_main.png",925,210,16,194)
	-- heroInfo_togglebtn = heroInfo_toggleImg:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	-- local ToggleT = heroInfo_toggleImg:AddImage(path.."TD1_main.png",0,-16,16,16)
	-- local ToggleD = heroInfo_toggleImg:AddImage(path.."TD1_main.png",0,194,16,16)
	
	-- XSetWindowFlag(heroInfo_togglebtn.id,1,1,0,144)
	
	-- heroInfo_togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)
	-- heroInfo_togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	-- heroInfo_togglebtn.script[XE_ONUPDATE] = function()
		-- if heroInfo_togglebtn._T == nil then
			-- heroInfo_togglebtn._T = 0
		-- end
		-- local L,T,R,B = XGetWindowClientPosition(heroInfo_togglebtn.id)
		-- if heroInfo_togglebtn._T ~= T then
			-- heroInfo_togglebtn._T = T
		-- end
	-- end
	
	-- 最近战绩滚动条
	-- local heroInfo_toggleImg2 = wnd:AddImage(path.."toggleBK_main.png",1180,210,16,194)
	-- heroInfo_togglebtn2 = heroInfo_toggleImg2:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	-- local ToggleT = heroInfo_toggleImg2:AddImage(path.."TD1_main.png",0,-16,16,16)
	-- local ToggleD = heroInfo_toggleImg2:AddImage(path.."TD1_main.png",0,194,16,16)
	
	-- XSetWindowFlag(heroInfo_togglebtn2.id,1,1,0,144)
	
	-- heroInfo_togglebtn2:ToggleBehaviour(XE_ONUPDATE, 1)
	-- heroInfo_togglebtn2:ToggleEvent(XE_ONUPDATE, 1)
	-- heroInfo_togglebtn2.script[XE_ONUPDATE] = function()
		-- if heroInfo_togglebtn2._T == nil then
			-- heroInfo_togglebtn2._T = 0
		-- end
		-- local L,T,R,B = XGetWindowClientPosition(heroInfo_togglebtn2.id)
		-- if heroInfo_togglebtn2._T ~= T then
			-- heroInfo_togglebtn2._T = T
		-- end
	-- end
	
	-- 战绩部分
	wnd:AddImage(path_info.."rankBK_info.png",655,465,1024,32)
	btn_ListBK2 = wnd:AddImage(path_info.."ListBK2_info.png",610,408,405,89)
	btn_ListBK2:SetVisible(0)
	
	-- 竞技场战绩
	btn_RankA = wnd:AddCheckButton(path_info.."rankA1_info.png",path_info.."rankA2_info.png",path_info.."rankA3_info.png",700,455,256,64)
	btn_RankA.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK2:SetPosition(610,408)
		
		btn_RankB:SetCheckButtonClicked(0)
		btn_RankC:SetCheckButtonClicked(0)
		
		XClickPlayerInfoCheckBtn(0)
	end
	
	-- 战场战绩
	btn_RankB = wnd:AddCheckButton(path_info.."rankB1_info.png",path_info.."rankB2_info.png",path_info.."rankB3_info.png",830,455,256,64)
	btn_RankB.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK2:SetPosition(730,408)
		
		btn_RankA:SetCheckButtonClicked(0)
		btn_RankC:SetCheckButtonClicked(0)
		
		XClickPlayerInfoCheckBtn(1)
	end
	
	-- 排位战绩
	btn_RankC = wnd:AddCheckButton(path_info.."rankC1_info.png",path_info.."rankC2_info.png",path_info.."rankC3_info.png",930,455,256,64)
	btn_RankC.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK2:SetPosition(830,408)
		
		btn_RankA:SetCheckButtonClicked(0)
		btn_RankB:SetCheckButtonClicked(0)
		
		XClickPlayerInfoCheckBtn(2)
	end
	
	wnd:AddFont("对战胜率", 12, 0, 695, 510, 100, 12, 0x8b83e6)
	player_vs = wnd:AddFont("1", 15, 0, 760, 506, 200, 20, 0x8296d1)
	wnd:AddFont("SOLO胜率", 12, 0, 1035, 510, 100, 12, 0x8b83e6)
	player_solo = wnd:AddFont("1", 15, 0, 1100, 506, 200, 20, 0x8296d1)
	
	killLevel_icon = wnd:AddImage(Kill_icon[1],695,535,136,126)
	player_kill = wnd:AddFont("1", 15, 8, -713, -680, 100, 20, 0x8296d1)
	defenceLevel_icon = wnd:AddImage(Defence_icon[1],880,535,136,126)
	player_defence = wnd:AddFont("1", 15, 8, -898, -680, 100, 20, 0x8296d1)
	assistLevel_icon = wnd:AddImage(Assist_icon[1],1060,535,136,126)
	player_assist = wnd:AddFont("1", 15, 8, -1083, -680, 100, 20, 0x8296d1)
	
	
	-- 个人数据库
	wnd:AddImage(path_info.."linedata_info.png",65,360,534,79)
	wnd:AddImage(path_info.."Font7_info.png",300,380,128,32)
	-- wnd:AddFont("更新时间", 12, 0, 470, 385, 100, 20, 0x8b83e6)

	-- wnd:AddFont("＜1小时", 15, 0, 525, 383, 100, 20, 0x8296d1)
	-- 尚未开放
	wnd:AddFontEx("尚未开放", 18, 0, 310, 440, 100, 20, 0x8c85e5)
	
	for i = 1,#data_list do
		img_columns[i] = wnd:AddImage(path_info.."playerdata_info.png",54+80*i,425,64,256)
		wnd:SetAddImageRect(img_columns[i].id, 0, 0, 64, 40+168*data_percent[i],54+80*i,593-168*data_percent[i], 64, 40+168*data_percent[i])
		
		font_list[i] = wnd:AddFont(data_list[i], 15, 0, 35+81*i, 668, 100, 20, 0x8c85e5)
		local m_percent = data_percent[i]*100
		font_percent[i] = wnd:AddFont(m_percent.."%", 15, 0, 58+80*i, 645, 100, 20, 0xd1d4ff)
		font_percent[i]:SetVisible(0)
		font_num[i] = wnd:AddFont(data_num[i], 15, 0, 60+80*i, 615, 100, 20, 0xffffff)
		font_num[i]:SetVisible(0)
	end
	
	-- btn_left = wnd:AddButton(path_info.."L1.png",path_info.."L2.png",path_info.."L3.png",75,522,64,128)
	-- btn_right = wnd:AddButton(path_info.."R1.png",path_info.."R2.png",path_info.."R3.png",590,522,64,128)
	
	local YYYYYYY = 0
	for i = 1, 4 do
		LastFightInfo[i] = wnd:AddImage(path_info.."headpic_info.png", 953, 198+YYYYYYY, 52, 52)
		
		LastFightInfo[i]:AddImage(path_shop.."iconside_shop.png", -2, -2, 54,54)
		LastFightInfo.Kill[i] = LastFightInfo[i]:AddImage(path_info.."sharenshu_info.png", 65, 5, 32, 32)
		LastFightInfo.KillF[i] = LastFightInfo.Kill[i]:AddFont("0", 15, 0, 25, 3, 100, 20, 0xff877edb)
		LastFightInfo.Aid[i] = LastFightInfo[i]:AddImage(path_info.."zhugongshu_info.png", 119, 5, 32, 32)
		LastFightInfo.AidF[i] = LastFightInfo.Aid[i]:AddFont("0", 15, 0, 25, 3, 100, 20, 0xff877edb)
		LastFightInfo.Monster[i] = LastFightInfo[i]:AddImage(path_info.."bubingshu_info.png", 173, 5, 32, 32)
		LastFightInfo.MonsterF[i] = LastFightInfo.Monster[i]:AddFont("0", 15, 0, 25, 3, 100, 20, 0xff877edb)
		LastFightInfo.Date[i] = LastFightInfo[i]:AddFont("2055年99月99日99点45分", 15, 0, 60, 33, 200, 20, 0xff877edb)
		LastFightInfo.Result[i] = LastFightInfo[i]:AddImage(path_info.."win_info.png", 5, 30, 64, 32)
		LastFightInfo.Result[i]:SetTouchEnabled(0)
		
		MastBestHeroInfo[i] = wnd:AddImage(path_info.."headpic_info.png", 691, 198+YYYYYYY, 50, 50)
		MastBestHeroInfo[i]:AddImage(path_shop.."iconside_shop.png", -2, -2, 54,54)
		MastBestHeroInfo[i]:AddFont("胜", 15, 0, 80, 0, 50, 20, 0xff7a8ec3)
		MastBestHeroInfo.Win[i] = MastBestHeroInfo[i]:AddFont("0", 15, 0, 130, 1, 50, 20, 0xffffffff)
		MastBestHeroInfo[i]:AddFont("负", 15, 0, 80, 30, 50, 20, 0xff877edb)
		MastBestHeroInfo.Lose[i] = MastBestHeroInfo[i]:AddFont("0", 15, 0, 130, 31, 50, 20, 0xffffffff)
		
		YYYYYYY = YYYYYYY + 57
	end
	
	
	-- 召唤师头像界面
	summoner_ui = CreateWindow(wnd.id, 215,168,564,381)
	summoner_bk = summoner_ui:AddImage(path_info.."summonerBK_info.png", 0, 0, 564, 381)
	
	btn_summoner_Confirm = summoner_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",78,335,100,32)
	btn_summoner_Confirm:AddFont("确认",15, 8, 0, 0, 100, 32, 0xffffff)
	btn_summoner_Cancel = summoner_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",368,335,100,32)
	btn_summoner_Cancel:AddFont("取消",15, 8, 0, 0, 100, 32, 0xffffff)
	btn_summoner_Confirm.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- summoner_click:SetVisible(0)
		summoner_ui:SetVisible(0)
		if click_index > 0 then
			last_pictureName = SummonerInfo.pictureName[click_index]
			XClickSummonerHeadIndex(SummonerInfo.Id[click_index])
		end
	end	
	btn_summoner_Cancel.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		-- summoner_click:SetVisible(0)
		summoner_ui:SetVisible(0)
		
		player_pic.changeimage(last_pictureName)	-- 时刻改变召唤师头像图片
		ChangeSummoner_headXYWH(last_pictureName)	-- 时刻改变召唤师头像图片
	end
	for i=1,15 do
		summoner_posx[i] = 102*((i-1)%5)+21
		summoner_posy[i] = 102*math.ceil(i/5)-81		
		
		summoner_head[i] = summoner_ui:AddImage(path_info.."sumhead_info.png", summoner_posx[i], summoner_posy[i], 94, 94)
		summoner_head[i]:SetTouchEnabled(0)
		summoner_side[i] = summoner_head[i]:AddButton(path_info.."sumside1_info.png",path_info.."sumside2_info.png",path_info.."sumside1_info.png", -6, -6, 106, 106)
				
		summoner_side[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			click_index = i+updownCount*5
			local L,T = summoner_head[i]:GetPosition()
			
			ChangeSummoner_headXYWH(SummonerInfo.pictureName[i+updownCount*5])	-- 时刻改变召唤师头像图片
		end
	end
	-- summoner_click = summoner_ui:AddImage(path_info.."sumclick_info.png", 0, 0, 106, 106)
	-- summoner_click:SetVisible(0)
	summoner_ui:SetVisible(0)
	
	-- 召唤师头像滚动条
	summoner_toggleBK = summoner_ui:AddImage(path.."toggleBK_main.png",537,32,16,274)
	summoner_togglebtn = summoner_toggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = summoner_toggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = summoner_toggleBK:AddImage(path.."TD1_main.png",0,274,16,16)
	
	XSetWindowFlag(summoner_togglebtn.id,1,1,0,224)
	
	summoner_togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)
	summoner_togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	summoner_togglebtn.script[XE_ONUPDATE] = function()
		if summoner_togglebtn._T == nil then
			summoner_togglebtn._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(summoner_togglebtn.id)
		if summoner_togglebtn._T ~= T then
			local length = 0
			if #SummonerInfo.pictureName <=15 then
				length = 224
			else
				length = 224/math.ceil((#SummonerInfo.pictureName/5)-3)
			end
			local Many = math.floor(T/length)
			updownCount = Many
			
			if Many_SummonerHead ~= Many then
				for i = 1, #summoner_head do
					summoner_head[i]:SetVisible(0)
				end
				for i=updownCount*5+1, #SummonerInfo.pictureName do
					if i>updownCount*5 and i<updownCount*5+16 then
						summoner_head[i-updownCount*5].changeimage(SummonerInfo.pictureName[i])
						summoner_head[i-updownCount*5]:SetVisible(1)
					end
				end
				Many_SummonerHead = Many
			end
			
			summoner_togglebtn._T = T
		end
	end
	
	XWindowEnableAlphaTouch(summoner_ui.id)
	summoner_ui:EnableEvent(XE_MOUSEWHEEL)
	summoner_ui.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		local length = 0

		if #SummonerInfo.pictureName >15 then
			maxUpdown = math.ceil((#SummonerInfo.pictureName/5)-3)
			length = 224/maxUpdown
		else
			maxUpdown = 0
			length = 224
		end
		if updown>0 then
			updownCount = updownCount-1
			if updownCount<0 then
				updownCount=0
			end
		else
			updownCount = updownCount+1
			if updownCount>maxUpdown then
				updownCount=maxUpdown
			end
		end	
		local btn_pos = length*updownCount
	
		summoner_togglebtn:SetPosition(0,btn_pos)
		summoner_togglebtn._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			for i = 1, #summoner_head do
				summoner_head[i]:SetVisible(0)
			end
			for i=updownCount*5+1, #SummonerInfo.pictureName do
				if i>updownCount*5 and i<updownCount*5+16 then
					summoner_head[i-updownCount*5].changeimage(SummonerInfo.pictureName[i])
					summoner_head[i-updownCount*5]:SetVisible(1)
				end
			end
		end
	end
end

-- 通信召唤师头像
function Clear_SummonerHead()
	SummonerInfo = {}
	SummonerInfo.pictureName = {}
	SummonerInfo.Id = {}
	
	for i,v in pairs(summoner_head) do
		summoner_head[i]:SetVisible(0)
	end
	-- summoner_click:SetVisible(0)
	click_index = -1
end

function Receive_SummonerHead(pictureName,id,x,y,w,h)
	local index = #SummonerInfo.pictureName+1
	SummonerInfo.pictureName[index] = ".."..pictureName
	SummonerInfo.Id[index] = id
end

function Refresh_SummonerHead()
	-- 滚动条恢复
	updownCount = 0
	maxUpdown = 0
	summoner_togglebtn:SetPosition(0,0)
	summoner_togglebtn._T = 0
	
	for i,value in pairs(summoner_head) do
		summoner_head[i].changeimage(SummonerInfo.pictureName[i])
		summoner_head[i]:SetVisible(1)
	end	
	
	click_index = -1
	-- summoner_click:SetVisible(0)
	if #SummonerInfo.pictureName <=15 then
		summoner_toggleBK:SetVisible(0)
	else
		summoner_toggleBK:SetVisible(1)
	end
end

function FirstCurrent_SummonerHead(pictureName)
	player_pic.changeimage("..\\"..pictureName)	-- 时刻改变召唤师头像图片
	-- player_pic:SetAddImageRect(player_pic.id,x,y,w,h,72,178,130,130)
	last_pictureName = "..\\"..pictureName
end

function Current_SummonerHead(pictureName)
	player_pic.changeimage(pictureName) -- 时刻改变召唤师头像图片
	-- player_pic:SetAddImageRect(player_pic.id,x,y,w,h,72,178,130,130)
end

function Current_SummonerHeadNoXYWH(pictureName)
	player_pic.changeimage(pictureName)	-- 时刻改变召唤师头像图片
end

-- 通信召唤师头像完毕
function IsFocusOn_HeroInfo()
	if (g_game_heroInfo_ui:IsVisible() == true) then
		
		-- 下拉选项框
		local flagA = (hideCall_BK:IsVisible() == true and btn_hideCall:IsFocus() == false and btn_hideCallBK[1]:IsFocus() == false and btn_hideCallBK[2]:IsFocus() == false
		and btn_hideCallBK[3]:IsFocus() == false and btn_hideCallBK[4]:IsFocus() == false and btn_hideCallBK[5]:IsFocus() == false and btn_hideCallBK[6]:IsFocus() == false
		and btn_hideCallBK[7]:IsFocus() == false)

		if(flagA == true) then
			btn_hideCall:SetButtonFrame(0)
			hideCall_BK:SetVisible(0)
			for index,value in pairs(btn_hideCallBK) do
				btn_hideCallBK[index]:SetTransparent(0)
				btn_hideCallBK[index]:SetTouchEnabled(0)
			end
		end
	end
end

-- 清除玩家信息表
function HeroIofo_clear()
	-- 玩家的信息资料
	PlayerInfo_strName = nil		-- 玩家名称

	PlayerInfo_m_expCurrent = nil	-- 玩家当前经验
	PlayerInfo_m_expAll = nil		-- 玩家总经验
	PlayerInfo_m_call = nil			-- 玩家称号
	PlayerInfo_m_character = nil	-- 玩家节操值
	PlayerInfo_m_level = nil		-- 玩家等级
	PlayerInfo_m_vip = nil			-- 玩家VIP等级
	
	PlayerInfo_m_hero = nil			-- 拥有英雄数量
	PlayerInfo_m_skin = nil			-- 拥有皮肤数量
	PlayerInfo_m_pertain = nil		-- 英雄专属数量
	PlayerInfo_m_equip = nil		-- 战场装备数量
	PlayerInfo_m_bestEquip = nil	-- 永恒神器数量
	PlayerInfo_m_honour = nil		-- 成就称号数量
	
	PlayerInfo_p_hero = nil			-- 拥有英雄百分比
	PlayerInfo_p_skin = nil			-- 拥有皮肤百分比
	PlayerInfo_p_pertain = nil		-- 英雄专属百分比
	PlayerInfo_p_equip = nil		-- 战场装备百分比
	PlayerInfo_p_bestEquip = nil	-- 永恒神器百分比
	PlayerInfo_p_honour = nil		-- 成就称号百分比
	
	PlayerInfo_str_vs = nil			-- 竞技场战绩--对战胜率
	PlayerInfo_str_solo = nil		-- 竞技场战绩--solo胜率
	PlayerInfo_kill = nil
	PlayerInfo_defence = nil 
	PlayerInfo_assist = nil
	index_hideCall = 0
	btn_hideCallFont = {"【隐藏称号】"}
	
	for i = 1, 7 do
		TitleList[i]:SetFontText("", 0xbeb5ee)
		btn_hideCallBK[i]:SetTouchEnabled(0)
	end
end

function ClearLastInfo()
	for i = 1, 4 do
		LastFightInfo[i]:SetVisible(0)
		MastBestHeroInfo[i]:SetVisible(0)
	end
end

function SetHeroInfo( cName,  cWin, cSolo, cMorals, cKill, cTank, cAid, cCurTitle, cLv, cVipLv, cExpCurrent, cExpAll)	-- cIsSkin, cX, cW, cY, cH)
	PlayerInfo_strName = cName
	
	PlayerInfo_m_expCurrent = cExpCurrent	-- log("\nPlayerInfo_m_expCurrent  "..cExpCurrent)----玩家当前经验
	PlayerInfo_m_expAll = cExpAll			-- log("\nPlayerInfo_m_expAll  "..cExpAll)----玩家总经验
	
	PlayerInfo_m_character = cMorals
	PlayerInfo_m_level = cLv
	PlayerInfo_str_vs = cWin				-- log("\nPlayerInfo_str_vs  "..cWin)
	PlayerInfo_str_solo = cSolo				-- log("\nPlayerInfo_str_solo  "..cSolo)
	PlayerInfo_kill = cKill					-- log("\nPlayerInfo_kill  "..cKill)
	PlayerInfo_m_call = cCurTitle			-- log("\nPlayerInfo_m_call  "..cCurTitle)
	PlayerInfo_defence = cTank				-- log("\nPlayerInfo_defence  "..cTank)
	PlayerInfo_assist = cAid				-- log("\nPlayerInfo_assist  "..cAid)
	PlayerInfo_m_vip = cVipLv
	-- PlayerInfo_isSkin = cIsSkin
	-- PlayerInfo_iX = cX
	-- PlayerInfo_iY = cY
	-- PlayerInfo_iW = cW
	-- PlayerInfo_iH = cH
end

-- 设置称号Name
function SetSummonerTitle( cName, cindex)
	btn_hideCallFont[cindex] = cName
	if cindex*20 <= 256 then
		XSetAddImageRect( hideCall_BK.id, 0, 0, 160, cindex*20, 285, 220, 160, cindex*20)
	end
end

-- 设置玩家拥有的称号个数
function SetMaxDesignCount( cMaxDesignCount)
	MaxDesignCount = cMaxDesignCount
end

-- count代表获得的次数，0---击杀，1---防守，2---助攻
function HonourLevel_Icon(icon_type,count)
	if icon_type==0 then
		if count<25 then
			killLevel_icon.changeimage(Kill_icon[1])
		elseif count <100 then
			killLevel_icon.changeimage(Kill_icon[2])
		elseif count <250 then
			killLevel_icon.changeimage(Kill_icon[3])
		elseif count <450 then
			killLevel_icon.changeimage(Kill_icon[4])
		elseif count <800 then
			killLevel_icon.changeimage(Kill_icon[5])
		else
			killLevel_icon.changeimage(Kill_icon[6])
		end
	elseif icon_type==1 then
		if count<25 then
			defenceLevel_icon.changeimage(Defence_icon[1])
		elseif count <100 then
			defenceLevel_icon.changeimage(Defence_icon[2])
		elseif count <250 then
			defenceLevel_icon.changeimage(Defence_icon[3])
		elseif count <450 then
			defenceLevel_icon.changeimage(Defence_icon[4])
		elseif count <800 then
			defenceLevel_icon.changeimage(Defence_icon[5])
		else
			defenceLevel_icon.changeimage(Defence_icon[6])
		end
	elseif icon_type==2 then
		if count<25 then
			assistLevel_icon.changeimage(Assist_icon[1])
		elseif count <100 then
			assistLevel_icon.changeimage(Assist_icon[2])
		elseif count <250 then
			assistLevel_icon.changeimage(Assist_icon[3])
		elseif count <450 then
			assistLevel_icon.changeimage(Assist_icon[4])
		elseif count <800 then
			assistLevel_icon.changeimage(Assist_icon[5])
		else
			assistLevel_icon.changeimage(Assist_icon[6])
		end
	end
end

-- 绘制玩家信息界面
function HeroInfo_RedrawUI()
		if PlayerInfo_m_vip >0 then
			player_vip:SetVisible(1)
			player_vip.changeimage(path_info.."VIP"..PlayerInfo_m_vip..".png")
		else
			player_vip:SetVisible(0)
		end
		player_name:SetFontText(PlayerInfo_strName,0xff6ffefc)
		player_character:SetFontText(PlayerInfo_m_character,0x8296d1)
		player_level:SetFontText(tostring(PlayerInfo_m_level),0xffffff)
		
		exp_red.changeimage(path_info.."expme_info.png")
		exp_red:SetAddImageRect(exp_red.id, 0, 0, (PlayerInfo_m_expCurrent/PlayerInfo_m_expAll)*352, 16, 290 ,290, (PlayerInfo_m_expCurrent/PlayerInfo_m_expAll)*352, 16)
		local ppp = PlayerInfo_m_expCurrent.."/"..PlayerInfo_m_expAll
		player_exp:SetFontText(ppp,0x8296d1)
		if PlayerInfo_m_expAll == 9999999 then
			player_exp:SetVisible(0)
		else
			player_exp:SetVisible(1)
		end
		
		player_vs:SetFontText(PlayerInfo_str_vs,0x8296d1)
		player_solo:SetFontText(PlayerInfo_str_solo,0x8296d1)
		player_kill:SetFontText(PlayerInfo_kill,0x8296d1)	
		player_defence:SetFontText(PlayerInfo_defence,0x8296d1)	
		player_assist:SetFontText(PlayerInfo_assist,0x8296d1)
		
		HonourLevel_Icon(0,PlayerInfo_kill)		
		HonourLevel_Icon(1,PlayerInfo_defence)								
		HonourLevel_Icon(2,PlayerInfo_assist)
		-- 玩家称号是第多少个
		-- index_hideCall = btn_hideCallFont[PlayerInfo_m_call]
		-- local Last = 0
		-- 称号过多超过7个则出问题
		for i = 1, 7 do
			TitleList[i]:SetFontText(btn_hideCallFont[i], 0xbeb5ee)
		end
		Font_hideCall:SetFontText(PlayerInfo_m_call,0xbeb5ee)
		-- 数量和百分比
		-- data_num = {PlayerInfo_m_hero,PlayerInfo_m_skin,PlayerInfo_m_pertain,PlayerInfo_m_equip,PlayerInfo_m_bestEquip,PlayerInfo_m_honour}
		-- data_percent = {PlayerInfo_p_hero,PlayerInfo_p_skin,PlayerInfo_p_pertain,PlayerInfo_p_equip,PlayerInfo_p_bestEquip,PlayerInfo_p_honour}
	
		-- for i=1,#data_percent do
			-- img_columns[i].changeimage(path_info.."playerdata_info.png")
			-- img_columns[i]:SetAddImageRect(img_columns[i].id, 0, 0, 64, 40+168*data_percent[i],54+80*i,593-168*data_percent[i], 64, 40+168*data_percent[i])
	
			-- local m_percent = data_percent[i]*100
			-- font_percent[i]:SetFontText(m_percent.."%",0xd1d4ff)
			-- font_num[i]:SetFontText(data_num[i],0xffffff)
		-- end		
end

function SetLastFightInfo( cIconPath, cKill, cAid, cMonster, cDate, cType, cIndex, ctip)
	LastFightInfo[cIndex]:SetVisible(1)
	LastFightInfo[cIndex].changeimage("..\\"..cIconPath)
	XSetImageTip(LastFightInfo[cIndex].id, ctip)
	LastFightInfo.KillI[cIndex] = cKill
	LastFightInfo.KillF[cIndex]:SetFontText(cKill, 0xff877edb)
	LastFightInfo.AidI[cIndex] = cAid
	LastFightInfo.AidF[cIndex]:SetFontText(cAid, 0xff877edb)
	LastFightInfo.MonsterI[cIndex] = cMonster
	LastFightInfo.MonsterF[cIndex]:SetFontText(cMonster, 0xff877edb)
	LastFightInfo.Date[cIndex]:SetFontText(cDate, 0xff877edb)
	if cType == "0" then
		LastFightInfo.Result[cIndex].changeimage(path_info.."win_info.png")
	elseif cType == "1" then
		LastFightInfo.Result[cIndex].changeimage(path_info.."lose_info.png")
	else
		LastFightInfo.Result[cIndex].changeimage(path_info.."run_info.png")
	end
end

function SetMastBestHeroInfo( cIconPath, cWin, cLose, cIndex, ctip)
	MastBestHeroInfo[cIndex]:SetVisible(1)
	MastBestHeroInfo[cIndex].changeimage("..\\"..cIconPath)
	XSetImageTip(MastBestHeroInfo[cIndex].id, ctip)
	MastBestHeroInfo.WinI[cIndex] = cWin
	MastBestHeroInfo.Win[cIndex]:SetFontText(tostring(cWin), 0xffffffff)
	MastBestHeroInfo.LoseI[cIndex] = cLose
	MastBestHeroInfo.Lose[cIndex]:SetFontText(tostring(cLose), 0xffffffff)
end

function SetSummonerState(cisvisible, cpath, ctime, tip, index)
	if (index+1)>SummonerStateListMaxCount then
		return
	end
	SummonerState[index+1]:SetVisible(cisvisible)
	if cisvisible==1 then
		SummonerState[index+1].changeimage(".."..cpath)
		XSetImageTip(SummonerState[index+1].id, tip)
		SummonerStateTimeFont[index+1]:SetFontText(ctime, 0xffffff)
	end
end

function SetGameHeroInfoIsVisible(flag) 
	if g_game_heroInfo_ui ~= nil then
		if flag == 1 and g_game_heroInfo_ui:IsVisible() == false then
			btn_ListBK2:SetPosition(610,408)
			btn_ListBK2:SetVisible(1)
			btn_RankA:SetCheckButtonClicked(1)	
			btn_RankB:SetCheckButtonClicked(0)	
			btn_RankC:SetCheckButtonClicked(0)	
			
			summoner_ui:SetVisible(0)		
			g_game_heroInfo_ui:SetVisible(1)
		elseif flag == 0 and g_game_heroInfo_ui:IsVisible() == true then
			g_game_heroInfo_ui:SetVisible(0)
			btn_summoner_Cancel:TriggerBehaviour(XE_LBUP)
			CurShowDesignIndex = 1
		end
	end	
end

function GetGameHeroInfoIsVisible()  
    if g_game_heroInfo_ui ~= nil and g_game_heroInfo_ui:IsVisible()==true then
        return 1
    else
        return 0
    end
end