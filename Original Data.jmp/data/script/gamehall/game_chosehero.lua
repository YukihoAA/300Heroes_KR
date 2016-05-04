include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local BTN_showAllBK = {}
local BTN_showAllFont = {"显示全部","刺客","战士","坦克","射手","法师","辅助"}
local index_showAll = 1
local BTN_oftenUseBK = {}
local BTN_oftenUseFont = {"最新英雄","限时购买","常用优先","我的最爱","最近出战","胜场最高"} 
local index_oftenUse = 1

local showAll_BK = nil
local Oftenuse_BK = nil
local btn_showAll = nil
local Font_showAll = nil
local btn_Oftenuse = nil
local Font_Oftenuse = nil

-- 队友英雄部分
local hero_buttom = {}
local hero_head = {}
local hero_hide = {}
local hero_side = {}
-- local hero_chose = {} 
local hero_id = {}			-- 英雄编号
local hero_toggleImg = nil
local hero_togglebtn = nil

-- 英雄列表部分
local HERO_buttom = {}
local HERO_head = {}
local HERO_hide = {}
local HERO_favor = {}
local HERO_side = {}
local HERO_yellow = {}
local HERO_click = nil
-- 位置坐标
local ICON_X = {}
local ICON_Y = {}
local click_index = nil		-- 被点击的图片


-- 18个具体的英雄信息
local HeroInfo = {}
HeroInfo.strPictureName = {}	-- 英雄头像路径
HeroInfo.strName = {}			-- 英雄名称
HeroInfo.heroId = {}
HeroInfo.heroTip = {}
HeroInfo.IsFavorite = {}

-- 信息结束
local TeamplayerInfo = {}
TeamplayerInfo.strPictureName = {}	-- 英雄头像路径
TeamplayerInfo.strName = {}			-- 英雄名称
TeamplayerInfo.heroId = {}
TeamplayerInfo.heroTip = {}
TeamplayerInfo.heroStart = {0,0,0,0,0,0}		-- 英雄是否出击

local bgImg = nil
local bgImg_SkinLv = nil
local heronameInput = nil
-- 窗口滚动
local updownCount = 0
local maxUpdown = 0

local BTN_herochose = nil
local btn_heroLove = nil
local heroSearchInputEdit = nil
local btn_heroBelong = nil
local btn_heroSearch = nil
local imgFont = nil


local TeamMates_ui = nil		--队友选择英雄界面
local CanChoseHero_ui = nil		--可以选择的英雄
local HeroSearch_ui = nil		--英雄搜索
local HeroBelong_ui = nil		--英雄搜索
local HeroOftenUse_ui = nil		--英雄搜索

function InitGame_ChoseHeroUI(wnd, bisopen)
	g_game_chosehero_ui = CreateWindow(wnd.id, 0, -OffsetY1, 1280, 800)
	InitMainGame_ChoseHero(g_game_chosehero_ui)
	g_game_chosehero_ui:SetVisible(bisopen)
end
function InitMainGame_ChoseHero(wnd)
	-- 底图背景
	bgImg = wnd:AddImage(path_hero.."ffffff_hero.png",0,OffsetY1,1280,800)	
	bgImg_SkinLv = bgImg:AddImage(path_hero.."skinlv_1.png", 10, 10, 111, 69)
	wnd:AddImage(path_hero.."MB_hero.png", 0, 0, 1280, 800)
		
	-- 英雄选择界面
	BTN_herochose = wnd:AddButton(path_start.."backReady1_start.png",path_start.."backReady2_start.png",path_start.."backReady3_start.png",1210,315,74,141)
	imgFont = BTN_herochose:AddImage(path_start.."returnreadyfont_start.png",25,45,64,64)
	imgFont:SetTouchEnabled(0)
	imgFont:SetTransparent(0)
	BTN_herochose.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if GetTutorailModeIsOpen()==1 then
			XClickOkButtonTutorial()
		end
		SetGameChoseHeroIsVisible(0)
		SetGameStartIsVisible(1)
		SetSkinWindowPos(1)
	end
	
	-- 英雄皮肤
	-- wnd:AddImage(path_start.."10_SKIN.png",967,199,128,256)
	-- wnd:AddImage(path_hero.."SKIN_SIDE.png",962,194,128,256)
	-- local BTN_sell = wnd:AddButton(path_start.."SKINBYE.png",path_start.."SKINBYE_1.png",path_start.."SKINBYE_2.png",966,373,128,32)
	-- BTN_sell.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
	-- end
	
	-- local BTN_Phen = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",840,407, 179, 56)
	-- BTN_Phen:AddFont("装扮", 15, 0, 70, 15, 72, 15, 0xffffff)
	-- BTN_Phen.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		
		-- RecoverChoseList()
	-- end
	-- local BTN_Skin = wnd:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",1025,407, 179, 56)
	-- BTN_Skin:AddFont("皮肤", 15, 0, 70, 15, 72, 15, 0xffffff)
	-- BTN_Skin.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
	-- end
	
	
	-- 队友选择英雄
	TeamMates_ui = CreateWindow(wnd.id, 0, 0, 100, 200)
	for i=1,6 do
		hero_buttom[i] = TeamMates_ui:AddImage(path_start.."icon0_start.png",75*i-25,458,86,170)
		hero_buttom[i]:SetTouchEnabled(0)
		hero_head[i] = hero_buttom[i]:AddImage(path_start.."herohead_start.png",12,13,64,148)-- 原来是256，暂时修改成148
		hero_hide[i] = hero_buttom[i]:AddImage(path_start.."icon3_start.png",0,0,86,170)
		hero_hide[i]:SetTouchEnabled(0)
		hero_side[i] = hero_buttom[i]:AddImage(path_start.."icon1_start.png",0,0,86,170)
		hero_side[i]:SetTouchEnabled(0)
		-- local mm = i+1
		-- hero_id[i] = TeamMates_ui:AddImage(path_start.."player_"..mm..".png",5+74*i,580,64,32)	
	end
	
	-- 可供选择的英雄
	CanChoseHero_ui = CreateWindow(wnd.id, 0, 0, 100, 200)
	for index = 1,150 do 
		ICON_X[index] = ((index+5)%15)*75 + 60
		ICON_Y[index] = 308+160*math.ceil((index+6)/15)
		
		-- 头像
		HERO_head[index] = CanChoseHero_ui:AddImage(path_start.."herohead_start.png",ICON_X[index],ICON_X[index],64,148)---原来是256，暂时修改成148
		-- 遮罩
		HERO_hide[index] = HERO_head[index]:AddImage(path_start.."icon6_start.png",-10,-10,86,170)
		HERO_hide[index]:SetVisible(0)
		-- 最爱
		HERO_favor[index] = HERO_head[index]:AddImage(path_hero.."LOVE2_hero.png",3,120,32,32)
		HERO_favor[index]:SetTouchEnabled(0)
		HERO_favor[index]:SetVisible(0)
		
		-- 边框
		HERO_side[index] = HERO_head[index]:AddImage(path_start.."icon7_start.png",-10,-10,86,170)
		HERO_side[index]:SetTouchEnabled(0)
		
		if ICON_Y[index] >700 or ICON_Y[index] <400 then
			HERO_head[index]:SetVisible(0) 
		else
			HERO_head[index]:SetVisible(1)
		end
		HERO_head[index].script[XE_LBUP] = function()
			XClickPlaySound(5)
			-- 标记点击的图片
			if GetStepIndex_Tutorial()==9 then
				XClickOkButtonTutorial()
			end
			SetClientSelSkinIndex_skinframe(0)
			click_index = index
			local Lh,Th = HERO_side[index]:GetPosition()
			HERO_click:SetAbsolutePosition(Lh,Th)
			HERO_click:SetVisible(1)	
			
			-- log("\nHeroId = "..HeroInfo.heroId[index])
			bgImg_SkinLv:SetVisible(0)
			bgImg.changeimage(path_hero.."ffffff_hero.png")
			SetWndBgImg_gamestart(path_hero.."ffffff_hero.png", 0)
			if FindHeroHeadIcon_ChoseHero(HeroInfo.heroId[index]) then
				bgImg.changeimage("..\\UI\\hero\\"..HeroInfo.heroId[index]..".png")
				SetWndBgImg_gamestart("..\\UI\\hero\\"..HeroInfo.heroId[index]..".png", 0)
			end
			SetGameSkinFrameIsVisible(1)
			
			XGameHeroChoseId(HeroInfo.heroId[index])
			SetCurTitleState_teadytime(0)
		end	
		HERO_head[index].script[XE_ONHOVER] = function()
			HERO_side[index].changeimage(path_start.."icon8_start.png")
		end
		HERO_head[index].script[XE_ONUNHOVER] = function()
			HERO_side[index].changeimage(path_start.."icon7_start.png")
		end
		HERO_hide[index].script[XE_LBUP] = function()
			XClickPlaySound(5)
			-- 单机显示英雄皮肤
			-- if GetTutorailModeIsOpen()==1 and GetStepIndex_Tutorial()==10 then
				-- XClickOkButtonTutorial()
			-- end
			-- SetClientSelSkinIndex_skinframe(0)
			-- bgImg.changeimage(path_hero.."ffffff_hero.png")
			-- SetWndBgImg_gamestart(path_hero.."ffffff_hero.png")
			-- bgImg:SetAddImageRect(bgImg.id, 0, 0, 1280, 800, 0 ,0, 1280, 800)	
			-- SetGameSkinFrameIsVisible(1)
			-- SetCurTitleState_teadytime(0)
			-- SetSkinWindowPos(1)
		end
		HERO_hide[index].script[XE_LBDBCLICK] = function()
			XClickPlaySound(5)
			-- 双击返回出击界面
			if GetTutorailModeIsOpen()==1 and GetStepIndex_Tutorial()==10 then
				XClickOkButtonTutorial()
			end
			
			-- log("\nHeroId = "..HeroInfo.heroId[index])
			bgImg_SkinLv:SetVisible(0)
			bgImg.changeimage(path_hero.."ffffff_hero.png")
			SetWndBgImg_gamestart(path_hero.."ffffff_hero.png", 0)
			if FindHeroHeadIcon_ChoseHero(HeroInfo.heroId[index]) then
				bgImg.changeimage("..\\UI\\hero\\"..HeroInfo.heroId[index]..".png")
				SetWndBgImg_gamestart("..\\UI\\hero\\"..HeroInfo.heroId[index]..".png", 0)
			end
			-- bgImg:SetAddImageRect(bgImg.id, 0, 0, 1280, 800, 0 ,0, 1280, 800)	
			SetGameSkinFrameIsVisible(1)
			
			-- XGameHeroChoseId(HeroInfo.heroId[index])
			-- ClickHeroName:SetFontText(HeroInfo.strName[index],0xa7a7e8)
			SetCurTitleState_teadytime(0)
			
			SetGameChoseHeroIsVisible(0)
			SetGameStartIsVisible(1)
			SetSkinWindowPos(1)
		end
	end
	-- 黄色高亮(只画一个，移动位置)
	HERO_click = wnd:AddImage(path_start.."icon2_start.png",50,180,86,170)
	HERO_click:SetTouchEnabled(0)
	HERO_click:SetVisible(0)
	
	
	--英雄搜索
	HeroSearch_ui =  CreateWindow(wnd.id, 0, 0, 100, 50)
	btn_heroSearch = HeroSearch_ui:AddImage(path_start.."sortbk_start.png",50,417,128,32)
	btn_heroSearch:AddFont("英雄搜索",12,0,22,6,100,15,0xbeb5ee)	
	heroSearchInputEdit = CreateWindow(HeroSearch_ui.id, 158,417, 138, 32)
	heronameInput = heroSearchInputEdit:AddEdit(path_hero.."herostartSearch_hero.png","","StartChoseHero_OnSearchEnter","",13,5,5,135,25,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(heronameInput.id,20)

	--英雄定位
	HeroBelong_ui =  CreateWindow(wnd.id, 0, 0, 100, 50)
	btn_heroBelong = HeroBelong_ui:AddImage(path_start.."sortbk_start.png",296,417,128,32)
	btn_heroBelong:AddFont("英雄定位",12,0,22,6,100,15,0xbeb5ee)
	btn_showAll = HeroBelong_ui:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",400,417,128,32)
	Font_showAll = btn_showAll:AddFont(BTN_showAllFont[1],12,0,18,6,100,15,0xbeb5ee)
	
		
	--使用习惯
	HeroOftenUse_ui =  CreateWindow(wnd.id, 0, 0, 100, 50)
	btn_Oftenuse = HeroOftenUse_ui:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",615,417,128,32)
	Font_Oftenuse = btn_Oftenuse:AddFont(BTN_oftenUseFont[1],12,0,18,6,100,15,0xbeb5ee)
	btn_heroLove = HeroOftenUse_ui:AddImage(path_start.."sortbk_start.png",513,417,128,32)
	btn_heroLove:AddFont("使用习惯",12,0,22,6,100,15,0xbeb5ee)

	--显示全部下拉背景框
	showAll_BK = HeroBelong_ui:AddImage(path_hero.."listBK1_hero.png",400,447,128,256)
	showAll_BK:SetVisible(0)
	
	for dis = 1,7 do
		BTN_showAllBK[dis] = HeroBelong_ui:AddImage(path_hero.."listhover_hero.png",400,418+dis*29,128,32)
		showAll_BK:AddFont(BTN_showAllFont[dis],12,0,18,dis*29-23,128,32,0xbeb5ee)
		BTN_showAllBK[dis]:SetTransparent(0)
		BTN_showAllBK[dis]:SetTouchEnabled(0)
		
		-- 鼠标滑过
		BTN_showAllBK[dis].script[XE_ONHOVER] = function()
			if showAll_BK:IsVisible() == true then
				BTN_showAllBK[dis]:SetTransparent(1)
			end
		end
		BTN_showAllBK[dis].script[XE_ONUNHOVER] = function()
			if showAll_BK:IsVisible() == true then
				BTN_showAllBK[dis]:SetTransparent(0)
			end
		end
		
		BTN_showAllBK[dis].script[XE_LBUP] = function()
			Font_showAll:SetFontText(BTN_showAllFont[dis],0xbeb5ee)
			index_showAll = dis
			
			StartChoseHero_OnSearchEnter()
			btn_showAll:SetButtonFrame(0)
			showAll_BK:SetVisible(0)
			for index,value in pairs(BTN_showAllBK) do
				BTN_showAllBK[index]:SetTransparent(0)
				BTN_showAllBK[index]:SetTouchEnabled(0)
			end
		end
	end

	btn_showAll.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if showAll_BK:IsVisible() then
			showAll_BK:SetVisible(0)
			for index,value in pairs(BTN_showAllBK) do
				BTN_showAllBK[index]:SetTransparent(0)
				BTN_showAllBK[index]:SetTouchEnabled(0)
			end
		else
			showAll_BK:SetVisible(1)
			for index,value in pairs(BTN_showAllBK) do
				BTN_showAllBK[index]:SetTransparent(0)
				BTN_showAllBK[index]:SetTouchEnabled(1)
			end
		end
	end
	
	-- 常用优先下拉背景框
	Oftenuse_BK = HeroOftenUse_ui:AddImage(path_hero.."listBK2_hero.png",615,447,128,256)
	Oftenuse_BK:SetVisible(0)

	for dis = 1,6 do
		BTN_oftenUseBK[dis] = HeroOftenUse_ui:AddImage(path_hero.."listhover_hero.png",615,418+dis*29,128,32)
		Oftenuse_BK:AddFont(BTN_oftenUseFont[dis],12,0,18,dis*29-23,128,32,0xbeb5ee)
		BTN_oftenUseBK[dis]:SetTransparent(0)
		BTN_oftenUseBK[dis]:SetTouchEnabled(0)
		
		-- 鼠标滑过
		BTN_oftenUseBK[dis].script[XE_ONHOVER] = function()
			if Oftenuse_BK:IsVisible() == true then
				BTN_oftenUseBK[dis]:SetTransparent(1)
			end
		end
		BTN_oftenUseBK[dis].script[XE_ONUNHOVER] = function()
			if Oftenuse_BK:IsVisible() == true then
				BTN_oftenUseBK[dis]:SetTransparent(0)
			end
		end
		
		BTN_oftenUseBK[dis].script[XE_LBUP] = function()
			Font_Oftenuse:SetFontText(BTN_oftenUseFont[dis],0xbeb5ee)
			index_oftenUse = dis
			
			StartChoseHero_OnSearchEnter()
			btn_Oftenuse:SetButtonFrame(0)
			Oftenuse_BK:SetVisible(0)
			for index,value in pairs(BTN_oftenUseBK) do
				BTN_oftenUseBK[index]:SetTransparent(0)
				BTN_oftenUseBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	btn_Oftenuse.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if Oftenuse_BK:IsVisible() then
			Oftenuse_BK:SetVisible(0)
			for index,value in pairs(BTN_oftenUseBK) do
				BTN_oftenUseBK[index]:SetTransparent(0)
				BTN_oftenUseBK[index]:SetTouchEnabled(0)
			end
		else
			Oftenuse_BK:SetVisible(1)
			for index,value in pairs(BTN_oftenUseBK) do
				BTN_oftenUseBK[index]:SetTransparent(0)
				BTN_oftenUseBK[index]:SetTouchEnabled(1)
			end
		end
	end
	
	
	-- 显示滚动条
	hero_toggleImg = CanChoseHero_ui:AddImage(path.."toggleBK_main.png",1184,483,16,280)
	hero_togglebtn = hero_toggleImg:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = hero_toggleImg:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = hero_toggleImg:AddImage(path.."TD1_main.png",0,280,16,16)
	
	XSetWindowFlag(hero_togglebtn.id,1,1,0,230)
	
	hero_togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)
	hero_togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	hero_togglebtn.script[XE_ONUPDATE] = function()
		if hero_togglebtn._T == nil then
			hero_togglebtn._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(hero_togglebtn.id)
		if hero_togglebtn._T ~= T then
			local length = 0
			local Line = 0
			if #HeroInfo.strName <= 9 then
				Line = 1
			else
				Line = math.ceil((#HeroInfo.strName-9)/15)+1
			end
			if Line<=2 then
				length = 230
			else
				length = 230/(Line-2)
			end
			local Many = math.floor(T/length)
			updownCount = Many
			
			if Many >=1 then
				for i,v in pairs(hero_buttom) do
					hero_buttom[i]:SetVisible(0)
				end
			else
				for i,v in pairs(hero_buttom) do
					hero_buttom[i]:SetVisible(1)
				end
			end
			for i=1,#HeroInfo.strName do
				local Li, Ti = ICON_X[i],ICON_Y[i]- Many*160
				HERO_head[i]:SetPosition(Li, Ti)
				
				if Ti >700 or Ti <400 then
					HERO_head[i]:SetVisible(0)
				else
					HERO_head[i]:SetVisible(1)
				end
			end
			if click_index>0 then
				local Lc, Tc = HERO_side[click_index]:GetPosition()
				HERO_click:SetAbsolutePosition(Lc, Tc)
				if Tc >700 or Tc <400 then
					HERO_click:SetVisible(0)
				else
					HERO_click:SetVisible(1)
				end
			end
			hero_togglebtn._T = T
		end
	end
		
	-- 设置界面可以滑动
	XWindowEnableAlphaTouch(g_game_chosehero_ui.id)
	g_game_chosehero_ui:EnableEvent(XE_MOUSEWHEEL)
	g_game_chosehero_ui.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		local length = 0
		local Line = 0
		if #HeroInfo.strName <= 9 then
			Line = 1
		else
			Line = math.ceil((#HeroInfo.strName-9)/15)+1
		end
		if Line<=2 then
			maxUpdown = 0
			length = 230
		else
			maxUpdown = Line-2
			length = 230/maxUpdown
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
		btn_pos = length*updownCount
				
		hero_togglebtn:SetPosition(0,btn_pos)
		hero_togglebtn._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			if updownCount > 0 then
				for i,v in pairs(hero_buttom) do
					hero_buttom[i]:SetVisible(0)
				end
			else
				for i,v in pairs(hero_buttom) do
					hero_buttom[i]:SetVisible(1)
				end
			end
			for i=1,#HeroInfo.strName do
				local Li, Ti = ICON_X[i],ICON_Y[i]- updownCount*160
				HERO_head[i]:SetPosition(Li, Ti)
				
				if Ti >700 or Ti <400 then
					HERO_head[i]:SetVisible(0)
				else
					HERO_head[i]:SetVisible(1)
				end
			end
			if click_index>0 then
				local Lc, Tc = HERO_side[click_index]:GetPosition()
				HERO_click:SetAbsolutePosition(Lc, Tc)
				if Tc >700 or Tc <400 then
					HERO_click:SetVisible(0)
				else
					HERO_click:SetVisible(1)
				end
			end
		end
	end
end

-- 搜索英雄名称发送函数到C++
function StartChoseHero_OnSearchEnter()
	XSearchStartChoseHeroName(heronameInput:GetEdit(),index_showAll,index_oftenUse)
end

-- 选择英雄信息表
function ClearChoseHeroInfo()
	
	HeroInfo = {}					-- 清除发送来的信息
	HeroInfo.strPictureName = {}	-- 英雄头像路径
	HeroInfo.strName = {}			-- 英雄名称
	HeroInfo.heroId = {}
	HeroInfo.heroTip = {}
	HeroInfo.IsFavorite = {}
	
	updownCount = 0
	maxUpdown = 0	
	hero_togglebtn:SetPosition(0,0)
	hero_togglebtn._T = 0
	click_index = 0
	HERO_click:SetVisible(0)
	
	for i,value in pairs(HERO_side) do
		local Li, Ti = ICON_X[i],ICON_Y[i]
		HERO_head[i]:SetPosition(Li, Ti)
		HERO_head[i]:SetVisible(0)
		HERO_hide[i]:SetVisible(0)
	end	
	for i,value in pairs(hero_buttom) do
		hero_buttom[i]:SetVisible(1)
	end	
end	

-- 获取开始选人的数据
function SendChoseHeroDataToLua(strPictureName,strName,heroId,tip,IsFavorite)
	local size = #HeroInfo.strName+1
	HeroInfo.strPictureName[size] = "..\\"..strPictureName				
	HeroInfo.strName[size] = strName							
	HeroInfo.heroId[size] = heroId								
	HeroInfo.heroTip[size] = tip
	HeroInfo.IsFavorite[size] = IsFavorite	
	
	HERO_head[size].changeimage(HeroInfo.strPictureName[size])
	HERO_hide[size]:SetImageTip(HeroInfo.heroTip[size])
	HERO_head[size]:SetImageTip(HeroInfo.heroTip[size])
	
	if size<=24 then
		HERO_head[size]:SetVisible(1) 
	else
		HERO_head[size]:SetVisible(0) 
	end
	
	if HeroInfo.IsFavorite[size] <= 0 then
		HERO_favor[size]:SetVisible(0)
	else
		HERO_favor[size]:SetVisible(1)
	end
end
function SendChoseHeroDataOver()
	if #HeroInfo.strName <=24 then
		hero_toggleImg:SetVisible(0)
	else
		hero_toggleImg:SetVisible(1)
	end
end

-- 还原英雄定位和筛选等问题
function RecoverChoseHeroList()

	-- 清除队友选择英雄信息表
	TeamplayerInfo = {}
	TeamplayerInfo.strPictureName = {}	-- 英雄头像路径
	TeamplayerInfo.strName = {}			-- 英雄名称
	TeamplayerInfo.heroId = {}
	TeamplayerInfo.heroTip = {}
	TeamplayerInfo.heroStart = {0,0,0,0,0,0}
		
	Font_showAll:SetFontText(BTN_showAllFont[1],0xbeb5ee)
	btn_showAll:SetButtonFrame(0)
	showAll_BK:SetVisible(0)
	Font_Oftenuse:SetFontText(BTN_oftenUseFont[1],0xbeb5ee)
	btn_Oftenuse:SetButtonFrame(0)
	Oftenuse_BK:SetVisible(0)
		
	for index,value in pairs(BTN_showAllBK) do
		BTN_showAllBK[index]:SetTransparent(0)
	end		
	for index,value in pairs(BTN_oftenUseBK) do
		BTN_oftenUseBK[index]:SetTransparent(0)
	end
	
	index_showAll = 1
	index_oftenUse = 1
	heronameInput:SetEdit("")
	for i,value in pairs(hero_buttom) do
		hero_buttom[i]:SetVisible(1)
		hero_head[i]:SetVisible(0)
		hero_hide[i]:SetVisible(1)
	end
	
end
function Chose_HeroClick()
	click_index = 0
	HERO_click:SetVisible(0)
end

-- 队友选择英雄
function SendData_ChoseHeroTeamplayer(strPictureName,strName,HeroId,tip,index)
	TeamplayerInfo.strPictureName[index] = "..\\"..strPictureName					
	TeamplayerInfo.strName[index] = strName									
	TeamplayerInfo.heroId[index] = HeroId
	TeamplayerInfo.heroTip[index] = tip
	TeamplayerInfo.heroStart[index] = 0

	if index >0 and index <7 then
		hero_head[index].changeimage(TeamplayerInfo.strPictureName[index])
		hero_head[index]:SetImageTip(TeamplayerInfo.heroTip[index])
		hero_head[index]:SetVisible(1)
	end
end

-- 队友谁出击
function ChoseHeroTeamplayer_StartGame(index)
	hero_hide[index]:SetVisible(0)
	TeamplayerInfo.heroStart[index] = 1
end

-- 把自己拥有的被选择的英雄禁止点击
function ChoseHero_EnableHeroId(bChosedId,EnabledFlag)

	if HeroInfo ~= {} or HeroInfo.heroId ~= {} then
		for i,v in pairs(HeroInfo.heroId) do
			if HeroInfo.heroId[i] == bChosedId then
				HERO_hide[i]:SetVisible(1-EnabledFlag)
			end
		end
	end
end
function IsFocusOn_ChoseHero()
	if (g_game_chosehero_ui:IsVisible() == true) then
		local flagA = showAll_BK:IsVisible() == true and btn_showAll:IsFocus() == false and BTN_showAllBK[1]:IsFocus() == false and BTN_showAllBK[2]:IsFocus() == false
		and BTN_showAllBK[3]:IsFocus() == false and BTN_showAllBK[4]:IsFocus() == false and BTN_showAllBK[5]:IsFocus() == false and BTN_showAllBK[6]:IsFocus() == false
		and BTN_showAllBK[7]:IsFocus() == false

		if(flagA == true) then
			btn_showAll:SetButtonFrame(0)
			showAll_BK:SetVisible(0)
			for index,value in pairs(BTN_showAllBK) do
				BTN_showAllBK[index]:SetTransparent(0)
				BTN_showAllBK[index]:SetTouchEnabled(0)
			end
		end
		
		local flagB = Oftenuse_BK:IsVisible() == true and btn_Oftenuse:IsFocus() == false and BTN_oftenUseBK[1]:IsFocus() == false and BTN_oftenUseBK[2]:IsFocus() == false
		and BTN_oftenUseBK[3]:IsFocus() == false and BTN_oftenUseBK[4]:IsFocus() == false and BTN_oftenUseBK[5]:IsFocus() == false and BTN_oftenUseBK[6]:IsFocus() == false

		if(flagB == true) then
			btn_Oftenuse:SetButtonFrame(0)
			Oftenuse_BK:SetVisible(0)
			for index,value in pairs(BTN_oftenUseBK) do
				BTN_oftenUseBK[index]:SetTransparent(0)
				BTN_oftenUseBK[index]:SetTouchEnabled(0)
			end
		end
	end
end

function SetGameChoseHeroIsVisible(flag) 
	if g_game_chosehero_ui ~= nil then
		if flag == 1 and g_game_chosehero_ui:IsVisible() == false then
			g_game_chosehero_ui:SetVisible(1)
			
			SetFourpartUIVisiable(0)
			
			for i=1, #HERO_head do
				if HERO_head[i]~=nil then
					HERO_head[i]:SetTouchEnabled(1)
				end
			end
		elseif flag == 0 and g_game_chosehero_ui:IsVisible() == true then
			g_game_chosehero_ui:SetVisible(0)
		end
	end
end

function FindHeroHeadIcon_ChoseHero( cHeroId)
	for i = 1, #HeroHeadMMM do
		if HeroHeadMMM[i] == cHeroId then
			return true
		end
	end
	return false
end

function SetWndBgImg_choosehero(cpath,lv)
	bgImg.changeimage(cpath)
	if lv==0 then
		bgImg_SkinLv:SetVisible(0)
	else
		bgImg_SkinLv:SetVisible(1)
		bgImg_SkinLv.changeimage(path_hero.."skinlv_"..lv..".png")
	end
	-- bgImg:SetAddImageRect(bgImg.id, 0, 0, 1280, 800, 0 ,0, 1280, 800)	
end

function SetChoseHeroTutorialAllButtonEnable(IsEnable)
	heroSearchInputEdit:SetTouchEnabled(IsEnable)
	BTN_herochose:SetEnabled(IsEnable)
	btn_showAll:SetTouchEnabled(IsEnable)
	btn_Oftenuse:SetTouchEnabled(IsEnable)
	for i=1, #HERO_head do
		HERO_head[i]:SetTouchEnabled(IsEnable)
	end
end

function SetChoseHeroTutorialButtonEnable(IsEnable)
	HERO_head[1]:SetTouchEnabled(0)
end

function SetchoseheroTutorialState( cIsEnable, cId)
	if cId==1 then
		btn_heroLove:EnableImageAnimateEX( cIsEnable, 11, 90, 450, 10, 85, 10)
	elseif cId==2 then
		BTN_showAllBK[1]:EnableImageAnimateEX( cIsEnable, 11, 90, 350, -10, 680, 305)
	elseif cId==3 then
		HERO_head[1]:EnableImageAnimateEX( cIsEnable, 7, 90, 0, 80, 0, -170)
	elseif cId==4 then
		imgFont:EnableImageAnimateEX(cIsEnable, 7, 90, 20, 120, -20, -120)
	end
end

function AutoChoseHero_DeBug()
	SetClientSelSkinIndex_skinframe(0)
	click_index = 1
	local Lh,Th = HERO_side[1]:GetPosition()
	HERO_click:SetAbsolutePosition(Lh,Th)
	HERO_click:SetVisible(1)	
	
	bgImg.changeimage(path_hero.."ffffff_hero.png")
	SetWndBgImg_gamestart(path_hero.."ffffff_hero.png", 0)
	if FindHeroHeadIcon_ChoseHero(HeroInfo.heroId[1]) then
		bgImg.changeimage("..\\UI\\hero\\"..HeroInfo.heroId[1]..".png")
		SetWndBgImg_gamestart("..\\UI\\hero\\"..HeroInfo.heroId[1]..".png", 0)
	end
	SetGameSkinFrameIsVisible(1)
	
	XGameHeroChoseId(HeroInfo.heroId[1])
	SetCurTitleState_teadytime(0)
end

function ReturnGameStartUI()
	if g_game_chosehero_ui:IsVisible() == true then
		SetGameChoseHeroIsVisible(0)
		SetGameStartIsVisible(1)
		SetSkinWindowPos(1)
	end
end