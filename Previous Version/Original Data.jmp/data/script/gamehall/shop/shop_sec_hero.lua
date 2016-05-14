include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 装备具体信息
local EquipInfo = {}
EquipInfo.strName = {}			-- 装备名称
EquipInfo.strPictureAdr = {}	-- 装备图片路径
EquipInfo.strDesc = {}			-- 装备描述
EquipInfo.leftTime = {}			-- 剩余时间
EquipInfo.IsCanBuy = {}			-- 是否能购买
EquipInfo.money = {}
EquipInfo.gold = {}
EquipInfo.honour = {}
EquipInfo.contri = {}
EquipInfo.vip = {}
EquipInfo.m_Flag = {}			-- 装备标签（限时、打折...）
EquipInfo.m_IsShow = {}			-- 用来判断该空间是否显示
EquipInfo.Id = {}
EquipInfo.ItemId = {}
EquipInfo.Tip = {}

-- 界面控件
local EquipHeroSearchInputEdit = nil
local EquipHeroSearchInput = nil
-- local EquipHeroSearchInputText = nil
local check_herohave = nil
local Many_Equip = 0 		-- 上次滑动按钮停留的位置
local Many = 0
local m_VisibleCount = 0
local ItemList = nil
local Money_btn = nil		-- 金币排序
local Money_N = nil			-- 不排序
local Money_H = nil			-- 最高
local Money_L = nil			-- 最低
local Money_index = 0

local Gold_btn = nil		-- 金币排序
local Gold_N = nil			-- 不排序
local Gold_H = nil			-- 最高
local Gold_L = nil			-- 最低
local Gold_index = 0

-- 商品的窗口
local g_item_ui = {}		-- 主窗口
local g_item_posx = {}		-- 窗口X
local g_item_posy = {}		-- 窗口Y
local g_item_name = {}		-- 商品名称
local g_item_pic = {}		-- 商品图片
local g_item_desc = {}		-- 商品描述
local g_item_Time = {}		-- 商品剩余时间
local g_item_money = {}			-- 金币价格
local g_item_gold = {}			-- 钻石价格
local g_item_money_font = {}	-- 金币价格FONT
local g_item_gold_font = {}		-- 钻石价格FONT
local g_item_honour = {}		-- 功勋价格
local g_item_contri = {}		-- 荣誉价格
local g_item_vip = {}			-- VIP价格
local g_item_flag = {}			-- 商品限时、打折等等
local g_item_buy = {}			-- 购买按钮
-- local g_item_buyUnEnable = {} -- 购买不可点击
-- 下拉列表
local BTN_showAllBK = {}
local BTN_oftenUseBK = {}
local BTN_showAllFont = {"显示全部","刺客","战士","坦克","射手","法师","辅助"}
local BTN_oftenUseFont = {"最新英雄","我的最爱","最近出战","字母排序","限时打折"}
local btn_showAll = nil
local Font_showAll = nil
local showAll_BK = nil
local btn_Oftenuse = nil
local Font_Oftenuse = nil
local Oftenuse_BK = nil
local index_have = 1
local AllCount = 0		-- 总个数
local ppx = -50
local ppy = -150
local heroInfo_toggleImg = nil
local heroInfo_togglebtn = nil

-- 窗口滚动
local updownCount = 0
local maxUpdown = 0

function IsShop_Sec_HeroInputFocus()
	if EquipHeroSearchInput ~= nil then
		return EquipHeroSearchInput:IsFocus()
	end
	return false
end

function InitShop_Sec_HeroUI(wnd, bisopen)
	g_shop_Sec_hero_ui = CreateWindow(wnd.id, 50, 150, 900, 600)
	InitMainShop_Sec_Hero(g_shop_Sec_hero_ui)
	g_shop_Sec_hero_ui:SetVisible(bisopen)
end

function InitMainShop_Sec_Hero(wnd)

	-- 英雄定位
	-- local hero_type = wnd:AddImage(path_start.."sortbk_start.png",470+ppx,120+ppy,128,32)
	-- hero_type:AddFont("英雄定位",12,0,22,6,100,15,0xbeb5ee)
	-- 使用习惯
	-- local hero_use = wnd:AddImage(path_start.."sortbk_start.png",710+ppx,120+ppy,128,32)
	-- hero_use:AddFont("使用习惯",12,0,22,6,100,15,0xbeb5ee)

	----装备搜索
	EquipHeroSearchInputEdit = CreateWindow(wnd.id, 950+ppx,165+ppy, 256, 32)
	EquipHeroSearchInput = EquipHeroSearchInputEdit:AddEdit(path_shop.."InputEdit_shop.png","","onHeroSearch_Enter","",13,5,5,230,25,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(EquipHeroSearchInput.id,60)
	EquipHeroSearchInput:SetDefaultFontText("搜索按Enter键确定", 0xff303b4a)
	local FindButton = EquipHeroSearchInputEdit:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 235, -3, 83, 35)
	FindButton:SetVisible(0)
	FindButton.script[XE_LBUP] = function()
		XEnterFindInput(EquipHeroSearchInput.id, 1)
		ResetScrollList()
	end
	
	-- 未拥有英雄
	local NotHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,215+ppy,128,32)
	-- NotHave:SetVisible(0)
	
	local check_heroBK = wnd:AddImage(path_hero.."checkbox_hero.png",1146+ppx,215+ppy,32,32)
	-- check_heroBK:SetVisible(0)
	check_heroBK:SetTouchEnabled(1)
	check_herohave = check_heroBK:AddImage(path_hero.."checkboxYes_hero.png",4,-2,32,32)
	check_herohave:SetTouchEnabled(0)
	check_herohave:SetVisible(0)
	check_heroBK.script[XE_LBUP] = function()
		EquipHeroSearchInput:SetEdit("")
		Gold_index = 0
		Gold_N:SetVisible(1)
		Gold_H:SetVisible(0)
		Gold_L:SetVisible(0)
		Money_index = 0
		Money_N:SetVisible(1)
		Money_H:SetVisible(0)
		Money_L:SetVisible(0)
	
		if (check_herohave:IsVisible()) then
			check_herohave:SetVisible(0)
			index_have = 1
			for i = 1, #g_item_ui do
				if i<13 then
					g_item_ui[i]:SetVisible(1)
				end
			end
		else
			check_herohave:SetVisible(1)
			index_have = 2
		end
		
		ResetScrollList()
		
		XShopIsHaveHeroCheck(index_have-1)
	end
	
	----金币价格排序
	Money_btn = wnd:AddButton(path_shop.."money0_shop.png",path_shop.."money0_shop.png",path_shop.."money0_shop.png",1030+ppx,380+ppy,256,32)	
	Money_N = wnd:AddImage(path_shop.."money0_shop.png",1030+ppx,380+ppy,256,32)
	Money_H = wnd:AddImage(path_shop.."moneyH_shop.png",1030+ppx,380+ppy,256,32)
	Money_L = wnd:AddImage(path_shop.."moneyL_shop.png",1030+ppx,380+ppy,256,32)
	Money_N:SetTouchEnabled(0)
	Money_H:SetTouchEnabled(0)
	Money_L:SetTouchEnabled(0)
		
	Money_N:SetVisible(1)
	Money_H:SetVisible(0)
	Money_L:SetVisible(0)
	Money_btn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		EquipHeroSearchInput:SetEdit("")
		Money_index = Money_index + 1
		Money_index = Money_index%3
		if Money_index == 1 then
			Money_N:SetVisible(0)
			Money_H:SetVisible(1)
			Money_L:SetVisible(0)
		elseif Money_index == 2 then
			Money_N:SetVisible(0)
			Money_H:SetVisible(0)
			Money_L:SetVisible(1)
		else
			Money_N:SetVisible(1)
			Money_H:SetVisible(0)
			Money_L:SetVisible(0)
		end
		XShopSrotHeroCheckMoney(Money_index)
		------恢复钻石排序为默认
		Gold_index = 0
		Gold_N:SetVisible(1)
		Gold_H:SetVisible(0)
		Gold_L:SetVisible(0)
		
		--ResetScrollList()
	end
	
	----钻石价格排序
	Gold_btn = wnd:AddButton(path_shop.."gold0_shop.png",path_shop.."gold0_shop.png",path_shop.."gold0_shop.png",1030+ppx,415+ppy,256,32)
	Gold_N = wnd:AddImage(path_shop.."gold0_shop.png",1030+ppx,415+ppy,256,32)
	Gold_H = wnd:AddImage(path_shop.."goldH_shop.png",1030+ppx,415+ppy,256,32)
	Gold_L = wnd:AddImage(path_shop.."goldL_shop.png",1030+ppx,415+ppy,256,32)
	Gold_N:SetTouchEnabled(0)
	Gold_H:SetTouchEnabled(0)
	Gold_L:SetTouchEnabled(0)
		
	Gold_N:SetVisible(1)
	Gold_H:SetVisible(0)
	Gold_L:SetVisible(0)
	Gold_btn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		EquipHeroSearchInput:SetEdit("")
		Gold_index = Gold_index + 1
		Gold_index = Gold_index%3
		if Gold_index == 1 then
			Gold_N:SetVisible(0)
			Gold_H:SetVisible(1)
			Gold_L:SetVisible(0)
		elseif Gold_index == 2 then
			Gold_N:SetVisible(0)
			Gold_H:SetVisible(0)
			Gold_L:SetVisible(1)
		else
			Gold_N:SetVisible(1)
			Gold_H:SetVisible(0)
			Gold_L:SetVisible(0)
		end
		XShopSrotHeroCheckGold(Gold_index)
		------恢复金币排序为默认
		Money_index = 0
		Money_N:SetVisible(1)
		Money_H:SetVisible(0)
		Money_L:SetVisible(0)
		
		--ResetScrollList()
	end
	
	ItemList = wnd:AddImage(path_hero.."checkbox_hero.png",0,0,0,0)
	ItemList:SetTransparent(0)
	
	-- 滚动条
	heroInfo_toggleImg = wnd:AddImage(path.."toggleBK_main.png",918+ppx,180+ppy,16,540)
	heroInfo_togglebtn = heroInfo_toggleImg:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = heroInfo_toggleImg:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = heroInfo_toggleImg:AddImage(path.."TD1_main.png",0,540,16,16)
	
	XSetWindowFlag(heroInfo_togglebtn.id,1,1,0,490)
	
	heroInfo_togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)
	heroInfo_togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	
	heroInfo_togglebtn.script[XE_ONUPDATE] = function()
		if (AllCount > 12) then
			if heroInfo_togglebtn._T == nil then
				heroInfo_togglebtn._T = 0
			end
			local L,T,R,B = XGetWindowClientPosition(heroInfo_togglebtn.id)
			if heroInfo_togglebtn._T ~= T then
				local length = 490/math.ceil((AllCount/4)-3)
				Many = math.floor(T/length)
				updownCount = Many
								
				if Many_Equip ~= Many then
					SecHero_RedrawUI()
					Many_Equip = Many
				end					
				heroInfo_togglebtn._T = T
			end
		end
	end
	
	-- 设置界面可以滑动
	XWindowEnableAlphaTouch(wnd.id)
	wnd:EnableEvent(XE_MOUSEWHEEL)
	wnd.script[XE_MOUSEWHEEL] = function()
		local updown  = 0
		local length =0
		if #EquipInfo.strName >12 then
			updown  = XGetMsgParam0()
			maxUpdown = math.ceil((#EquipInfo.strName/4)-3)
			length = 490/maxUpdown			
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
		Many = updownCount
		local btn_pos = length*updownCount
	
		heroInfo_togglebtn:SetPosition(0,btn_pos)
		heroInfo_togglebtn._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			SecHero_RedrawUI()
		end
	end
	-----显示全部下拉背景框
	--btn_showAll = wnd:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",575+ppx,120+ppy,128,32)
	--Font_showAll = btn_showAll:AddFont("显示全部",12,0,18,6,100,15,0xbeb5ee)
	--showAll_BK = wnd:AddImage(path_shop.."listBK1_shop.png",575+ppx,150+ppy,128,512)
	--wnd:SetAddImageRect(showAll_BK.id,0,0,128,204,575+ppx,150+ppy,128,204)
	
	--showAll_BK:SetVisible(0)
	
	-- for dis = 1,7 do
		-- BTN_showAllBK[dis] = wnd:AddImage(path_hero.."listhover_hero.png",575+ppx,121+dis*29+ppy,128,32)
		-- showAll_BK:AddFont(BTN_showAllFont[dis],12,0,18,dis*29-23,128,32,0xbeb5ee)
		-- BTN_showAllBK[dis]:SetTransparent(0)
		-- BTN_showAllBK[dis]:SetTouchEnabled(0)
		
		-- -----------鼠标滑过
		-- BTN_showAllBK[dis].script[XE_ONHOVER] = function()
			-- if showAll_BK:IsVisible() == true then
				-- BTN_showAllBK[dis]:SetTransparent(1)
			-- end
		-- end
		-- BTN_showAllBK[dis].script[XE_ONUNHOVER] = function()
			-- if showAll_BK:IsVisible() == true then
				-- BTN_showAllBK[dis]:SetTransparent(0)
			-- end
		-- end
		-- BTN_showAllBK[dis].script[XE_LBUP] = function()
			-- Font_showAll:SetFontText(BTN_showAllFont[dis],0xbeb5ee)
			-- index_showAll = dis
			
			-- --onSearchEnter()
			-- btn_showAll:SetButtonFrame(0)
			-- showAll_BK:SetVisible(0)
			-- for index,value in pairs(BTN_showAllBK) do
				-- BTN_showAllBK[index]:SetTransparent(0)
				-- BTN_showAllBK[index]:SetTouchEnabled(0)
			-- end
		-- end
		
	-- end
	
	-- btn_showAll.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- if showAll_BK:IsVisible() then
			-- showAll_BK:SetVisible(0)
			-- for index,value in pairs(BTN_showAllBK) do
				-- BTN_showAllBK[index]:SetTransparent(0)
				-- BTN_showAllBK[index]:SetTouchEnabled(0)
			-- end
		-- else
			-- showAll_BK:SetVisible(1)
			-- for index,value in pairs(BTN_showAllBK) do
				-- BTN_showAllBK[index]:SetTransparent(0)
				-- BTN_showAllBK[index]:SetTouchEnabled(1)
			-- end
		-- end
	-- end
	----常用优先下拉背景框
	-- btn_Oftenuse = wnd:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",815+ppx,120+ppy,128,32)
	-- Font_Oftenuse = btn_Oftenuse:AddFont(BTN_oftenUseFont[1],12,0,18,6,100,15,0xbeb5ee)
	
	-- Oftenuse_BK = wnd:AddImage(path_shop.."listBK1_shop.png",815+ppx,150+ppy,128,512)
	-- wnd:SetAddImageRect(Oftenuse_BK.id,0,0,128,145,815+ppx,150+ppy,128,145)
	-- Oftenuse_BK:SetVisible(0)
	
	-- for dis = 1,5 do
		-- BTN_oftenUseBK[dis] = wnd:AddImage(path_hero.."listhover_hero.png",815+ppx,121+dis*29+ppy,128,32)
		-- Oftenuse_BK:AddFont(BTN_oftenUseFont[dis],12,0,18,dis*29-23,128,32,0xbeb5ee)
		-- BTN_oftenUseBK[dis]:SetTransparent(0)
		-- BTN_oftenUseBK[dis]:SetTouchEnabled(0)
		-- -----------鼠标滑过
		-- BTN_oftenUseBK[dis].script[XE_ONHOVER] = function()
			-- if Oftenuse_BK:IsVisible() == true then
				-- BTN_oftenUseBK[dis]:SetTransparent(1)
			-- end
		-- end
		-- BTN_oftenUseBK[dis].script[XE_ONUNHOVER] = function()
			-- if Oftenuse_BK:IsVisible() == true then
				-- BTN_oftenUseBK[dis]:SetTransparent(0)
			-- end
		-- end
		-- BTN_oftenUseBK[dis].script[XE_LBUP] = function()
			-- Font_Oftenuse:SetFontText(BTN_oftenUseFont[dis],0xbeb5ee)
			-- index_oftenUse = dis
			
			-- --onSearchEnter()
			-- btn_Oftenuse:SetButtonFrame(0)
			-- Oftenuse_BK:SetVisible(0)
			-- for index,value in pairs(BTN_oftenUseBK) do
				-- BTN_oftenUseBK[index]:SetTransparent(0)
				-- BTN_oftenUseBK[index]:SetTouchEnabled(0)
			-- end
		-- end
	-- end
	
	-- btn_Oftenuse.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- if Oftenuse_BK:IsVisible() then
			-- Oftenuse_BK:SetVisible(0)
			-- for index,value in pairs(BTN_oftenUseBK) do
				-- BTN_oftenUseBK[index]:SetTransparent(0)
				-- BTN_oftenUseBK[index]:SetTouchEnabled(0)
			-- end
		-- else
			-- Oftenuse_BK:SetVisible(1)
			-- for index,value in pairs(BTN_oftenUseBK) do
				-- BTN_oftenUseBK[index]:SetTransparent(0)
				-- BTN_oftenUseBK[index]:SetTouchEnabled(1)
			-- end
		-- end
	-- end
	
	-- 具体的商品信息
	for i=1, 12 do
		g_item_posx[i] = 213*((i -1)%4+1)-150+ppx
		g_item_posy[i] = 193*math.ceil((i)/4)-33+ppy
		g_item_ui[i] = ItemList:AddImage(path_shop.."ITEMBK_shop.png",g_item_posx[i],g_item_posy[i],212,195)
		g_item_flag[i] = g_item_ui[i]:AddImage(path_shop.."flag1_shop.png",0,42,128,32)
		g_item_flag[i]:SetVisible(0)
		
		g_item_pic[i] = g_item_ui[i]:AddImage(path_equip.."bag_equip.png",74,44,64,64)
		g_item_ui[i]:AddImage(path_shop.."itemside_shop.png",68,38,76,76)
		
		g_item_money[i] = g_item_ui[i]:AddImage(path_shop.."money_shop.png",10,110,64,64)
		g_item_gold[i] = g_item_ui[i]:AddImage(path_shop.."gold_shop.png",103,110,64,64)
		
		g_item_buy[i] = g_item_ui[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		g_item_buy[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			XShopBuyItemIndexForLua(i+Many*4-1)
			XShopClickBuyItem(EquipInfo.Id[i+Many*4], EquipInfo.ItemId[i+Many*4])
		end
		
		g_item_name[i] = g_item_ui[i]:AddFont("英雄"..i, 15, 8, -7, -18, 200, 14, 0x83d1e7)
		g_item_Time[i] = g_item_ui[i]:AddFont("99天\n20小时", 11, 0, 155, 57, 50, 50, 0xbeb5ee)
		g_item_Time[i]:SetVisible(0)
		g_item_gold_font[i] = g_item_gold[i]:AddFontEx("1", 15, 0, 33, 8, 100, 15, 0xff83d1e7)
		g_item_gold_font[i]:SetFontSpace(1, 0)
		g_item_money_font[i] = g_item_money[i]:AddFontEx("1", 15, 0, 33, 8, 100, 15, 0xffe4e18b)
		g_item_money_font[i]:SetFontSpace(1, 0)
		g_item_buy[i]:AddFont("购买", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	end
	
	FindButton:AddFont("搜索", 18, 0, 15, 2, 100, 20, 0xffffff)
	NotHave:AddFont("未拥有英雄", 15, 0, 15, 5, 100, 20, 0xc7bcf6)
end
-- 英雄搜索
function IsFocusOn_EquipSearchHero()
	if (g_shop_Sec_hero_ui:IsVisible() == true) then
		-- 搜索框框
		local Input_Focus = EquipHeroSearchInput:IsFocus()
		
		if Input_Focus == true then
		
		elseif Input_Focus == false then
			-- EquipHeroSearchInput:SetEdit("")
		end

		-- 下拉选项框
		local flagA = (showAll_BK:IsVisible() == true and btn_showAll:IsFocus() == false and BTN_showAllBK[1]:IsFocus() == false and BTN_showAllBK[2]:IsFocus() == false
		and BTN_showAllBK[3]:IsFocus() == false and BTN_showAllBK[4]:IsFocus() == false and BTN_showAllBK[5]:IsFocus() == false and BTN_showAllBK[6]:IsFocus() == false
		and BTN_showAllBK[7]:IsFocus() == false)

		if(flagA == true) then
			btn_showAll:SetButtonFrame(0)
			showAll_BK:SetVisible(0)
			for index,value in pairs(BTN_showAllBK) do
				BTN_showAllBK[index]:SetTransparent(0)
				BTN_showAllBK[index]:SetTouchEnabled(0)
			end
		end

		local flagB = Oftenuse_BK:IsVisible() == true and btn_Oftenuse:IsFocus() == false and BTN_oftenUseBK[1]:IsFocus() == false and BTN_oftenUseBK[2]:IsFocus() == false
		and BTN_oftenUseBK[3]:IsFocus() == false and BTN_oftenUseBK[4]:IsFocus() == false and BTN_oftenUseBK[5]:IsFocus() == false 

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

function onHeroSearch_Enter()
	XEnterFindInput(EquipHeroSearchInput.id, 0)
	ResetScrollList()
end
-- 清空商品信息表
function SecHero_clearEquipInfo()
	-- ResetScrollList()
	if (#EquipInfo.strName > 0) then
		EquipInfo = {}
		EquipInfo.strName = {}			-- 装备名称
		EquipInfo.strPictureAdr = {}	-- 装备图片路径
		EquipInfo.strDesc = {}			-- 装备描述
		EquipInfo.leftTime = {}			-- 剩余时间
	
		EquipInfo.money = {}
		EquipInfo.gold = {}
		EquipInfo.honour = {}
		EquipInfo.contri = {}
		EquipInfo.vip = {}
		EquipInfo.m_Flag = {}
		
		EquipInfo.IsCanBuy = {}
		EquipInfo.m_IsShow = {}
		
		EquipInfo.Id = {}
		EquipInfo.ItemId = {}
		EquipInfo.Tip = {}
	end
	for i=1,#g_item_ui do
		g_item_ui[i]:SetVisible(0)
	end
	-- for i=(1+(Many*4)), (1+(Many*4)+11) do
		-- g_item_ui[i]:SetVisible(1)
	-- end
end
-- 接收C++传来的商品信息
function SecHero_ReceiveEquipInfo(strName,strPictureAdr,strDesc,leftTime,money,gold,honour,contri,vip,m_Flag,IsCanBuy,Id,ItemId, tip)
	local size = #EquipInfo.strName+1
	EquipInfo.strName[size] = strName
	EquipInfo.strPictureAdr[size] = strPictureAdr
	EquipInfo.strDesc[size] = strDesc
	EquipInfo.leftTime[size] = leftTime
	EquipInfo.IsCanBuy[size] = IsCanBuy

	EquipInfo.money[size] = money
	EquipInfo.gold[size] = gold
	EquipInfo.honour[size] = honour
	EquipInfo.contri[size] = contri
	EquipInfo.vip[size] = vip
	EquipInfo.m_Flag[size] = m_Flag
	EquipInfo.Id[size] = Id
	EquipInfo.ItemId[size] = ItemId
	-- log("\ntip = "..tip)
	EquipInfo.Tip[size] = tip
	-- XSetImageTip(g_item_pic[size].id, tip)
end

-- 绘制商品信息界面
function SecHero_RedrawUI()
	for i=1, #g_item_ui do
		if ((i+Many*4) > AllCount) then
			g_item_ui[i]:SetVisible(0)
		else
			if (EquipInfo.strPictureAdr[i+Many*4] == "" or EquipInfo.strPictureAdr[i+Many*4] == nil) then
				-- 如果图片路劲为空则返回
				log("\nErrorIconPathFrom [shop_Sec_hero]")
			else
				g_item_ui[i]:SetVisible(1)
				g_item_name[i]:SetFontText(EquipInfo.strName[i+Many*4],0x83d1e7)
				g_item_pic[i].changeimage("..\\"..EquipInfo.strPictureAdr[i+Many*4])
				XSetImageTip(g_item_pic[i].id, EquipInfo.Tip[i+Many*4])
				
				if (EquipInfo.m_Flag[i+Many*4] == "0") then
					g_item_flag[i]:SetVisible(0)
				else
					g_item_flag[i]:SetVisible(1)
					g_item_flag[i].changeimage(path_shop.."flag"..EquipInfo.m_Flag[i+Many*4].."_shop.png")
				end
				
				if (EquipInfo.gold[i+Many*4] == "" or EquipInfo.gold[i+Many*4] == nil) then
					g_item_gold[i]:SetVisible(0)
				else
					g_item_gold[i]:SetVisible(1)
					g_item_gold_font[i]:SetFontText(EquipInfo.gold[i+Many*4], 0xff83d1e7)
				end
				
				if (EquipInfo.money[i+Many*4] == "" or EquipInfo.money[i+Many*4] == nil) then
					g_item_money[i]:SetVisible(0)
				else
					g_item_money[i]:SetVisible(1)
					g_item_money_font[i]:SetFontText(EquipInfo.money[i+Many*4], 0xffe4e18b)
				end
				
				if (g_item_money[i]:IsVisible()==true and g_item_gold[i]:IsVisible()==false) then
					g_item_money[i]:SetPosition(72, 110)
				elseif (g_item_money[i]:IsVisible()==false and g_item_gold[i]:IsVisible()==true) then
					g_item_gold[i]:SetPosition(72, 110)
				else
					g_item_money[i]:SetPosition(20, 110)
					g_item_gold[i]:SetPosition(113, 110)
				end
				
				g_item_money[i].changeimage(path_shop.."money_shop.png")
				g_item_gold[i].changeimage(path_shop.."gold_shop.png")
				
				g_item_gold_font[i]:SetFontText(EquipInfo.gold[i+Many*4], 0xff83d1e7)
				g_item_money_font[i]:SetFontText(EquipInfo.money[i+Many*4], 0xffe4e18b)
				
				-- 判断是否拥有该英雄
				if (EquipInfo.IsCanBuy[i+Many*4] == tostring(0)) then
					g_item_buy[i]:SetEnabled(0)
					--g_item_buyUnEnable[i]:SetVisible(1)
				else
					g_item_buy[i]:SetEnabled(1)
					--g_item_buyUnEnable[i]:SetVisible(0)
				end
			end
		end
	end
end

-- 得到物品个数
function GetItemCount(ItemCount)
	AllCount = ItemCount
	if AllCount < 13 then
		heroInfo_toggleImg:SetVisible(0)
	else
		heroInfo_toggleImg:SetVisible(1)
	end
	return CreateItemFrame()
end

-- 根据数据创建Item
function CreateItemFrame()
	return SecHero_RedrawUI()
end

function ResetScrollList()
	-- 让控件和滚动条保持一致
	Many = 0
	Many_Equip = Many

	updownCount = 0
	maxUpdown = 0
	heroInfo_togglebtn:SetPosition(0,0)
	heroInfo_togglebtn._T = 0
	SecHero_RedrawUI()
end

function GoldSort(x, y, SortType)
	if (x == "-1" or x == "" or x == "NULL" or x == nil) then
		XShopSortGold(1)
		return
	end
	
	if (y == "-1" or y == "" or y == "NULL" or y == nil) then
		XShopSortGold(0)
		return
	end
	
	local tempX = string.find(x, "->")
	if tempX ~= nil then
		x = string.sub(x,tempX+2,#x)
	end
	
	local tempY = string.find(y, "->")
	if tempY ~= nil then
		y = string.sub(y,tempY+2,#y)
	end
	
	local a = tonumber(x)
	local b = tonumber(y)
	if (SortType == 0) then
		if (a > b) then
			XShopSortGold(1)
		else
			XShopSortGold(0)
		end
	else
		if (a < b) then
			XShopSortGold(1)
		else
			XShopSortGold(0)
		end
	end
end

function SetBuyBtnIsEnable( cIsVisible, cIndex)
	if (cIsVisible == 0) then
		g_item_buy[cIndex-Many*4]:SetEnabled(0)
		-- g_item_buyUnEnable[cIndex]:SetVisible(1)
	else
		g_item_buy[cIndex-Many*4]:SetEnabled(1)
		-- g_item_buyUnEnable[cIndex]:SetVisible(0)
	end
end

function ClearControlStatus()
	Money_index = 0
	Gold_index = 0
end

function ReSetContrnlState_hero()
	XResetShopHaveHeroCheckButtonState()
	Gold_N:SetVisible(1)
	Gold_H:SetVisible(0)
	Gold_L:SetVisible(0)
	Money_N:SetVisible(1)
	Money_H:SetVisible(0)
	Money_L:SetVisible(0)
	check_herohave:SetVisible(0)
	index_have = 1
	Money_index = 0
	Gold_index = 0
	EquipHeroSearchInput:SetEdit("")
end

-- 设置显示
function SetShop_Sec_HeroIsVisible(flag) 
	if g_shop_Sec_hero_ui ~= nil then		
		if flag == 1 and g_shop_Sec_hero_ui:IsVisible() == false then
			g_shop_Sec_hero_ui:SetVisible(1)
			XSetShopSecHeroUiIsVisible(1)
			XShopSecHeroClick()	-- 传消息给C,英雄子界面已经被打开
		elseif flag == 0 and g_shop_Sec_hero_ui:IsVisible() == true then
			ReSetContrnlState_hero()
			g_shop_Sec_hero_ui:SetVisible(0)
			XSetShopSecHeroUiIsVisible(0)
		end
	end
end
-- 获得显示
function GetShop_Sec_HeroIsVisible()  
    if(g_shop_Sec_hero_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function GetFindInputChar_hero()
	if g_shop_Sec_hero_ui:IsVisible()==true then
		XTellCInputChar(EquipHeroSearchInput.id)
	end
end

function SetButtonState_sechero(cindex)
	EquipInfo.IsCanBuy[cindex] = "0"
	if g_item_buy[cindex-Many*4]~=nil then
		g_item_buy[cindex-Many*4]:SetEnabled(0)
	end
end

function ReSetItemPosAndVisible_Sechero()
	SecHero_RedrawUI()
end