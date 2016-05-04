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

-- 商品的窗口
local g_item_ui = {}		-- 主窗口
local g_item_posx = {}		-- 窗口X
local g_item_posy = {}		-- 窗口Y

local g_item_name = {}		-- 商品名称
local g_item_pic = {}		-- 商品图片
local g_item_desc = {}		-- 商品描述
local g_item_Time = {}		-- 商品剩余时间

local g_item_money = {}		-- 金币价格
local g_item_gold = {}		-- 钻石价格
local g_item_money_font = {}	-- 金币价格FONT
local g_item_gold_font = {}		-- 钻石价格FONT
local g_item_honour = {}		-- 功勋价格
local g_item_contri = {}		-- 荣誉价格
local g_item_vip = {}		-- VIP价格

local g_item_flag = {}		-- 商品限时、打折等等

local g_item_free = {}		-- 试用按钮
local g_item_buy = {}		-- 购买按钮
--local g_item_buyUnEnable = {} -- 购买不可点击

local Gold_btn = nil		-- 金币排序
local Gold_N = nil			-- 不排序
local Gold_H = nil			-- 最高
local Gold_L = nil			-- 最低
local Gold_index = 0

-- 界面控件
local BestEquipSearchInputEdit = nil
local BestEquipSearchInput = nil
-- local BestEquipSearchInputText = nil
local check_herohave = nil
local Many_Equip = 0 		-- 上次滑动按钮停留的位置
local Many = 0
local m_VisibleCount = 0
local ItemList = nil

-- 下拉列表
local BTN_oftenUseBK = {}
local BTN_oftenUseFont = {"显示全部","刺客","战士","坦克","射手","法师","辅助"}
local btn_Oftenuse = nil
local Font_Oftenuse = nil
local Oftenuse_BK = nil
local index_have = 1
local AllCount = 0		-- 总个数
local ppx = -50
local ppy = -150
local heroInfo_toggleImg = nil
local heroInfo_togglebtn = nil
local updownCount = 0
local maxUpdown = 0

function IsShop_Sec_BestEquipInputFocus()
	if BestEquipSearchInput ~= nil then
		return BestEquipSearchInput:IsFocus()
	end
	return false
end

function InitShop_Sec_BestEquipUI(wnd, bisopen)
	g_shop_Sec_BestEquip_ui = CreateWindow(wnd.id, 50, 150, 900, 600)
	InitMainShop_Sec_BestEquip(g_shop_Sec_BestEquip_ui)
	g_shop_Sec_BestEquip_ui:SetVisible(bisopen)
end
function InitMainShop_Sec_BestEquip(wnd)
	-- 装备定位
	-- local hero_use = wnd:AddImage(path_start.."sortbk_start.png",710+ppx,120+ppy,128,32)
	-- hero_use:AddFont("装备定位",12,0,22,6,100,15,0xbeb5ee)
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
				-- log("\nMany = " .. Many)
				if Many_Equip ~= Many then
					SecBestEquip_RedrawUI()
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
		-- log("\nbtn_pos = " .. btn_pos)
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			SecBestEquip_RedrawUI()
		end
	end
	
	ItemList = wnd:AddImage(path_hero.."checkbox_hero.png",0,0,0,0)
	ItemList:SetTransparent(0)
	
	-- 装备定位下拉背景框
	-- btn_Oftenuse = wnd:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",815+ppx,120+ppy,128,32)
	-- Font_Oftenuse = btn_Oftenuse:AddFont(BTN_oftenUseFont[1],12,0,18,6,100,15,0xbeb5ee)
	
	-- Oftenuse_BK = wnd:AddImage(path_shop.."listBK1_shop.png",815+ppx,150+ppy,128,512)
	-- wnd:SetAddImageRect(Oftenuse_BK.id,0,0,128,204,815+ppx,150+ppy,128,204)
	-- Oftenuse_BK:SetVisible(0)
	
	-- for dis = 1,7 do
		-- BTN_oftenUseBK[dis] = wnd:AddImage(path_hero.."listhover_hero.png",815+ppx,121+dis*29+ppy,128,32)
		-- Oftenuse_BK:AddFont(BTN_oftenUseFont[dis],12,0,18,dis*29-23,128,32,0xbeb5ee)
		-- BTN_oftenUseBK[dis]:SetTransparent(0)
		-- BTN_oftenUseBK[dis]:SetTouchEnabled(1)
		-- 鼠标滑过
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
	
	-- 神器搜索
	BestEquipSearchInputEdit = CreateWindow(wnd.id, 950+ppx,165+ppy, 256, 32)
	BestEquipSearchInput = BestEquipSearchInputEdit:AddEdit(path_shop.."InputEdit_shop.png","","onBestEquipSearch_Enter","",13,5,5,230,25,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(BestEquipSearchInput.id,60)
	BestEquipSearchInput:SetDefaultFontText("搜索按Enter键确定",0xff303b4a)
	local FindButton = BestEquipSearchInputEdit:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 235, -3, 83, 35)
	FindButton:SetVisible(0)
	FindButton.script[XE_LBUP] = function()
		XEnterFindInput(1, BestEquipSearchInput.id, 1)
		ResetSecBestEquipScrollList()
	end
	
	
	-- 钻石价格排序
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
		
		-- ResetSecBestEquipScrollList()
		XShopSrotHeroCheckGold(1, Gold_index)
	end
	
	-- 未拥有神器
	-- local NotHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,215+ppy,128,32)
	-- NotHave:AddFont("未拥有神器", 14, 0, 15, 5, 100, 20, 0xc7bcf6)
	
	-- local check_heroBK = wnd:AddImage(path_hero.."checkbox_hero.png",1146+ppx,215+ppy,32,32)
	-- check_heroBK:SetTouchEnabled(1)
	-- check_herohave = check_heroBK:AddImage(path_hero.."checkboxYes_hero.png",4,-2,32,32)
	-- check_herohave:SetTouchEnabled(0)
	-- check_herohave:SetVisible(0)
	-- check_heroBK.script[XE_LBUP] = function()
		-- if (check_herohave:IsVisible()) then
			-- check_herohave:SetVisible(0)
			-- index_have = 1
		-- else
			-- check_herohave:SetVisible(1)
			-- index_have = 2
		-- end
		
		-- onSearchEnter()
	-- end
	
	for i=1, 12 do
		g_item_posx[i] = 213*((i-1)%4+1)-150+ppx
		g_item_posy[i] = 193*math.ceil(i/4)-33+ppy
		
		g_item_ui[i] = ItemList:AddImage(path_shop.."ITEMBK_shop.png",g_item_posx[i],g_item_posy[i],212,195)
		g_item_flag[i] = g_item_ui[i]:AddImage(path_shop.."flag1_shop.png",0,42,128,32)
		g_item_flag[i]:SetVisible(0)
		g_item_pic[i] = g_item_ui[i]:AddImage(path_equip.."bag_equip.png",74,44,64,64)
		g_item_ui[i]:AddImage(path_shop.."itemside_shop.png",68,38,76,76)
		
		g_item_money[i] = g_item_ui[i]:AddImage(path_shop.."money_shop.png",10,110,64,64)
		g_item_gold[i] = g_item_ui[i]:AddImage(path_shop.."gold_shop.png",103,110,64,64)
		
		-- g_item_free[i] = g_item_ui[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",15,145,83,35)
		-- g_item_free[i]:AddFont("试用"..i, 15, 0, 22, 7, 100, 30, 0xc7bcf6)
		-- g_item_free[i].script[XE_LBUP] = function()
			-- XClickPlaySound(5)
		-- end

		g_item_buy[i] = g_item_ui[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		g_item_buy[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			--SetShopItemBuyNameInfo(EquipInfo.strName[i])
			XShopBuyItemIndexForLua(i+Many*4-1)
			XShopClickBuyItem(1, EquipInfo.Id[i+Many*4], EquipInfo.ItemId[i+Many*4])
		end
		
		g_item_name[i] = g_item_ui[i]:AddFont("装备升级超级礼包", 15, 8, -7, -18, 200, 20, 0x83d1e7)
		g_item_gold_font[i] = g_item_gold[i]:AddFontEx("1", 15, 0, 33, 8, 100, 20, 0xff83d1e7)
		g_item_gold_font[i]:SetFontSpace(1, 0)
		g_item_money_font[i] = g_item_money[i]:AddFontEx("1", 15, 0, 33, 8, 100, 20, 0xffe4e18b)
		g_item_money_font[i]:SetFontSpace(1, 0)
		g_item_buy[i]:AddFont("购买", 15, 0, 22, 7, 100, 30, 0xc7bcf6)
	end
	
	FindButton:AddFont("搜索", 20, 0, 15, 2, 100, 20, 0xffffff)
end

-- 神器搜索
function IsFocusOn_BestEquipSearch()
	if g_shop_Sec_BestEquip_ui~=nil and g_shop_Sec_BestEquip_ui:IsVisible()==true then
		-- 搜索框框
		local Input_Focus = BestEquipSearchInput:IsFocus()
		
		if Input_Focus == true then
		
		elseif Input_Focus == false then
			-- BestEquipSearchInput:SetEdit("")
		end

		-- 下拉选项框
		local flagB = (Oftenuse_BK:IsVisible() == true and btn_Oftenuse:IsFocus() == false and BTN_oftenUseBK[1]:IsFocus() == false and BTN_oftenUseBK[2]:IsFocus() == false
		and BTN_oftenUseBK[3]:IsFocus() == false and BTN_oftenUseBK[4]:IsFocus() == false and BTN_oftenUseBK[5]:IsFocus() == false and BTN_oftenUseBK[6]:IsFocus() == false
		and BTN_oftenUseBK[7]:IsFocus() == false)

		if(flagB == true) then
			btn_Oftenuse:SetButtonFrame(0)
			Oftenuse_BK:SetVisible(0)
			for index,value in pairs(BTN_oftenUseBK) do
				BTN_oftenUseBK[index]:SetTransparent(0)
			end
		end
	end
end

function onBestEquipSearch_Enter()
	if BestEquipSearchInput==nil then
		return
	end

	XEnterFindInput(1, BestEquipSearchInput.id, 0)
	ResetSecBestEquipScrollList()
end

function SetShop_Sec_BestEquipIsVisible(flag) 
	if g_shop_Sec_BestEquip_ui ~= nil then
		if flag == 1 and g_shop_Sec_BestEquip_ui:IsVisible() == false then
			g_shop_Sec_BestEquip_ui:SetVisible(1)
			XSetShopSecBestEquipUiVisible(1)
			XClickShopSecBestEquipUi(1)
		elseif flag == 0 and g_shop_Sec_BestEquip_ui:IsVisible() == true then
			g_shop_Sec_BestEquip_ui:SetVisible(0)
			XSetShopSecBestEquipUiVisible(0)
			BestEquipSearchInput:SetEdit("")
			Gold_N:SetVisible(1)
			Gold_H:SetVisible(0)
			Gold_L:SetVisible(0)
			Gold_index = 0
		end
	end
end

function GetShop_Sec_BestEquipIsVisible()  
    if(g_shop_Sec_BestEquip_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

-- 重置滚动条
function ResetSecBestEquipScrollList()
	Many = 0
	Many_Equip = Many
	
	updownCount = 0
	maxUpdown = 0
	
	if heroInfo_togglebtn~=nil then
		heroInfo_togglebtn:SetPosition(0,0)
		heroInfo_togglebtn._T = 0
	end
	
	SecBestEquip_RedrawUI()
end

-- 创建Item
function CreateItemFrame_SecBestEquip()
	return SecBestEquip_RedrawUI()
end

-- 绘制Item
function SecBestEquip_RedrawUI()
	for i=1, #g_item_ui do
		if ((i+Many*4) > AllCount) then
			g_item_ui[i]:SetVisible(0)
		else
			if (EquipInfo.strPictureAdr[i+Many*4] == "" or EquipInfo.strPictureAdr[i+Many*4] == nil) then
				-- 如果图片路劲为空则返回
				log("\nErrorIconPathFrom [shop_Sec_bestEquip]")
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
				
				if g_item_money[i]:IsVisible()==true and g_item_gold[i]:IsVisible()==false then
					g_item_money[i]:SetPosition(72, 110)
				elseif g_item_money[i]:IsVisible()==false and g_item_gold[i]:IsVisible()==true then
					g_item_gold[i]:SetPosition(72, 110)
				else
					g_item_money[i]:SetPosition(20, 110)
					g_item_gold[i]:SetPosition(113, 110)
				end
				
				-- 判断是否拥有该英雄
				-- if (EquipInfo.IsCanBuy[i+Many*4] == tostring(0)) then
					-- g_item_buy[i]:SetVisible(0)
					-- g_item_buyUnEnable[i]:SetVisible(1)
				-- else
					-- g_item_buy[i]:SetVisible(1)
					-- g_item_buyUnEnable[i]:SetVisible(0)
				-- end
			end
		end
	end
end

function GetItemCount_SecBestEquip(ItemCount)
	AllCount = ItemCount
	
	if heroInfo_togglebtn==nil or heroInfo_toggleImg==nil then
		return
	end
	
	if AllCount < 13 then
		heroInfo_togglebtn:SetVisible(0)
		heroInfo_toggleImg:SetVisible(0)
	else
		heroInfo_togglebtn:SetVisible(1)
		heroInfo_toggleImg:SetVisible(1)
	end
	return CreateItemFrame_SecBestEquip()
end

function SecBestEqiup_ReceiveEquipInfo(strName,strPictureAdr,strDesc,leftTime,money,gold,honour,contri,vip,m_Flag,IsCanBuy,Id,ItemId, ctip)
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
	EquipInfo.Tip[size] = ctip
end

function SecBestEquip_clearItemInfo()
	-- ResetSecBestEquipScrollList()
	if (#EquipInfo.strName > 0) then
		EquipInfo = {}
		EquipInfo.strName = {}			----装备名称
		EquipInfo.strPictureAdr = {}	----装备图片路径
		EquipInfo.strDesc = {}			----装备描述
		EquipInfo.leftTime = {}			----剩余时间
	
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
end

function GetFindInputChar_bestequip()
	if BestEquipSearchInput==nil then
		return
	end

	if g_shop_Sec_BestEquip_ui:IsVisible()==true then
		XTellCInputChar(BestEquipSearchInput.id)
	end
end

function ReSetItemPosAndVisible_Secequipbest()
	SecBestEquip_RedrawUI()
end