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
EquipInfo.ItemId = {}EquipInfo.m_IsShow = {}	-- 用来判断该空间是否显示
EquipInfo.Id = {}
EquipInfo.ItemId = {}
EquipInfo.Tip = {}

-- 界面控件
local VIPSearchInputEdit = nil
local VIPSearchInput = nil
-- local VIPSearchInputText = nil
local check_ADhave = nil
local check_APhave = nil

local Many_Equip = 0 		-- 上次滑动按钮停留的位置
local Many = 0
local m_VisibleCount = 0

local VIP_btn = nil			-- VIP积分排序
local VIP_N = nil			-- 不排序
local VIP_H = nil			-- 最高
local VIP_L = nil			-- 最低
local VIP_index = 0

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
local g_item_vip = {}			-- VIP价格
local g_item_flag = {}			-- 商品限时、打折等等
local g_item_buy = {}			-- 购买按钮

local index_have = 1
local AllCount = 0
local ppx = -50
local ppy = -150
local heroInfo_toggleImg = nil
local heroInfo_togglebtn = nil
local updownCount = 0
local maxUpdown = 0


function IsShop_VipInputFocus()
	if VIPSearchInput ~= nil then
		return VIPSearchInput:IsFocus()
	end
	return false
end


function InitShop_VipUI(wnd, bisopen)
	g_shop_vip_ui = CreateWindow(wnd.id, 50, 150, 900, 600)
	InitMainShop_Vip(g_shop_vip_ui)
	g_shop_vip_ui:SetVisible(bisopen)
end
function InitMainShop_Vip(wnd)
	
	-- VIP搜索
	VIPSearchInputEdit = CreateWindow(wnd.id, 950+ppx,165+ppy, 256, 32)
	VIPSearchInput = VIPSearchInputEdit:AddEdit(path_shop.."InputEdit_shop.png","","onSec_VIPSearch_Enter","",13,5,5,230,25,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(VIPSearchInput.id,60)
	VIPSearchInput:SetDefaultFontText("搜索按Enter键确定", 0xff303b4a)
	local FindButton = VIPSearchInputEdit:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 235, -3, 83, 35)
	FindButton:SetVisible(0)
	FindButton.script[XE_LBUP] = function()
		XEnterFindInput(VIPSearchInput.id, 1)
		ResetSecVipScrollList()
	end
	-- 英雄
	-- local ADHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,215+ppy,128,32)
	-- ADHave:AddFont("英雄", 15, 0, 35, 5, 100, 20, 0xc7bcf6)
	
	-- local check_ADBK = wnd:AddImage(path_hero.."checkbox_hero.png",1146+ppx,215+ppy,32,32)
	-- check_ADBK:SetTouchEnabled(1)
	-- check_ADhave = check_ADBK:AddImage(path_hero.."checkboxYes_hero.png",4,-2,32,32)
	-- check_ADhave:SetTouchEnabled(0)
	-- check_ADhave:SetVisible(0)
	-- check_ADBK.script[XE_LBUP] = function()
		-- if (check_ADhave:IsVisible()) then
			-- check_ADhave:SetVisible(0)
		-- else
			-- check_ADhave:SetVisible(1)
		-- end
		
		-- ----onSearchEnter()
	-- end
	-- 宝石
	-- local APHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,260+ppy,128,32)
	-- APHave:AddFont("宝石", 15, 0, 35, 5, 100, 20, 0xc7bcf6)
	
	-- local check_APBK = wnd:AddImage(path_hero.."checkbox_hero.png",1146+ppx,260+ppy,32,32)
	-- check_APBK:SetTouchEnabled(1)
	-- check_APhave = check_APBK:AddImage(path_hero.."checkboxYes_hero.png",4,-2,32,32)
	-- check_APhave:SetTouchEnabled(0)
	-- check_APhave:SetVisible(0)
	-- check_APBK.script[XE_LBUP] = function()
		-- if (check_APhave:IsVisible()) then
			-- check_APhave:SetVisible(0)
		-- else
			-- check_APhave:SetVisible(1)
		-- end
		
		-- ----onSearchEnter()
	-- end
	
	-- VIP积分价格排序
	VIP_btn = wnd:AddButton(path_shop.."vip0_shop.png",path_shop.."vip0_shop.png",path_shop.."vip0_shop.png",1030+ppx,415+ppy,256,32)	
	VIP_N = wnd:AddImage(path_shop.."vip0_shop.png",1030+ppx,415+ppy,256,32)
	VIP_H = wnd:AddImage(path_shop.."vipH_shop.png",1030+ppx,415+ppy,256,32)
	VIP_L = wnd:AddImage(path_shop.."vipL_shop.png",1030+ppx,415+ppy,256,32)
	VIP_N:SetTouchEnabled(0)
	VIP_H:SetTouchEnabled(0)
	VIP_L:SetTouchEnabled(0)
		
	VIP_N:SetVisible(1)
	VIP_H:SetVisible(0)
	VIP_L:SetVisible(0)
	VIP_btn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		VIPSearchInput:SetEdit("")
		VIP_index = VIP_index + 1
		VIP_index = VIP_index%3
		if VIP_index == 1 then
			VIP_N:SetVisible(0)
			VIP_H:SetVisible(1)
			VIP_L:SetVisible(0)
		elseif VIP_index == 2 then
			VIP_N:SetVisible(0)
			VIP_H:SetVisible(0)
			VIP_L:SetVisible(1)
		else
			VIP_N:SetVisible(1)
			VIP_H:SetVisible(0)
			VIP_L:SetVisible(0)
		end
		XShopSrotHeroCheckMoney(VIP_index)
	end
	
	
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
					SecVip_RedrawUI()
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
		local length = 0
		if AllCount >12 then
			updown  = XGetMsgParam0()
			maxUpdown = math.ceil((AllCount/4)-3)
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
			SecVip_RedrawUI()
		end
	end
	
	-- 具体的商品信息
	-- for i=1,18 do
		-- g_item_posx[i] = 213*((i-1)%4+1)-150+ppx
		-- g_item_posy[i] = 193*math.ceil(i/4)-33+ppy
		
		-- g_item_ui[i] = wnd:AddImage(path_shop.."ITEMBK_shop.png",g_item_posx[i],g_item_posy[i],212,195)
		-- g_item_name[i] = g_item_ui[i]:AddFont("VIP升级超级礼包", 15, 0, 55, 17, 200, 30, 0x83d1e7)
		-- g_item_Time[i] = g_item_ui[i]:AddImage(path_shop.."flag1_shop.png",0,42,128,32)
		
		-- g_item_money[i] = g_item_ui[i]:AddImage(path_shop.."money_shop.png",7,110,64,64)
		-- g_item_gold[i] = g_item_ui[i]:AddImage(path_shop.."gold_shop.png",100,110,64,64)
		
		-- g_item_buy[i] = g_item_ui[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		-- g_item_buy[i]:AddFont("购买"..i, 15, 0, 22, 7, 100, 30, 0xc7bcf6)
		

		
		-- if g_item_posy[i] >700+ppy or g_item_posy[i] <100+ppy then
			-- g_item_ui[i]:SetVisible(0)
		-- else
			-- g_item_ui[i]:SetVisible(1)
		-- end
	-- end
	--g_item_buy[1].script[XE_LBUP] = function()
	--   XLwantVipShopInfo(1)
	--end
	
	-- 具体的商品信息
	for i=1, 12 do
		g_item_posx[i] = 213*((i -1)%4+1)-150+ppx
		g_item_posy[i] = 193*math.ceil((i)/4)-33+ppy
		g_item_ui[i] = g_shop_vip_ui:AddImage(path_shop.."ITEMBK_shop.png",g_item_posx[i],g_item_posy[i],212,195)
		g_item_flag[i] = g_item_ui[i]:AddImage(path_shop.."flag1_shop.png",0,42,128,32)
		g_item_flag[i]:SetVisible(0)
		g_item_pic[i] = g_item_ui[i]:AddImage(path_equip.."bag_equip.png",74,44,64,64)
		g_item_ui[i]:AddImage(path_shop.."itemside_shop.png",68,38,76,76)
		
		g_item_money[i] = g_item_ui[i]:AddImage(path_shop.."vippoint_shop.png",72,110,64,64)
		g_item_gold[i] = g_item_ui[i]:AddImage(path_shop.."gold_shop.png",113,110,64,64)
		g_item_gold[i]:SetVisible(0)
		
		g_item_buy[i] = g_item_ui[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		g_item_buy[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			-- SetShopItemBuyNameInfo(EquipInfo.strName[i])
			XShopBuyItemIndexForLua(i+Many*4-1)
			XShopClickBuyItem(EquipInfo.Id[i+Many*4], EquipInfo.ItemId[i+Many*4])
		end
		
		g_item_name[i] = g_item_ui[i]:AddFont("英雄"..i, 15, 8, -7, -18, 200, 20, 0x83d1e7)
		g_item_Time[i] = g_item_ui[i]:AddFont("99天\n20小时", 11, 0, 155, 57, 50, 50, 0xbeb5ee)
		g_item_Time[i]:SetVisible(0)
		g_item_gold_font[i] = g_item_gold[i]:AddFontEx("1", 15, 0, 33, 8, 100, 20, 0xff83d1e7)
		g_item_gold_font[i]:SetFontSpace(1, 0)
		g_item_money_font[i] = g_item_money[i]:AddFontEx("1", 15, 0, 33, 8, 100, 20, 0x938ae3)
		g_item_money_font[i]:SetFontSpace(1, 0)
		g_item_buy[i]:AddFont("购买", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	end
	
	FindButton:AddFont("搜索", 18, 0, 15, 2, 100, 20, 0xffffff)
end

-- 宝石搜索
function IsFocusOn_VIPSearch()
	if (g_shop_vip_ui:IsVisible() == true) then
		-- 搜索框框
		local Input_Focus = VIPSearchInput:IsFocus()
		
		if Input_Focus == true then
		
		elseif Input_Focus == false then
			-- VIPSearchInput:SetEdit("")
		end
	end
end

function onSec_VIPSearch_Enter()
	XEnterFindInput(VIPSearchInput.id, 0)
	ResetSecVipScrollList()
end

function SetShop_VipIsVisible(flag) 
	if g_shop_vip_ui ~= nil then
		if flag == 1 and g_shop_vip_ui:IsVisible() == false then
			g_shop_vip_ui:SetVisible(1)
			XSetShopSecVipUiVisible(1)
			XClickShopSecVipUi(0)
		elseif flag == 0 and g_shop_vip_ui:IsVisible() == true then
			g_shop_vip_ui:SetVisible(0)
			XSetShopSecVipUiVisible(0)
			VIPSearchInput:SetEdit("")
			VIP_N:SetVisible(1)
			VIP_H:SetVisible(0)
			VIP_L:SetVisible(0)
			VIP_index = 0
		end
	end
end

function GetShop_VipIsVisible()  
    if(g_shop_vip_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function ResetSecVipScrollList()
	-- 让控件和滚动条保持一致
	Many = 0
	Many_Equip = Many
	-- end		
	updownCount = 0
	maxUpdown = 0
	heroInfo_togglebtn:SetPosition(0,0)
	heroInfo_togglebtn._T = 0
	SecVip_RedrawUI()
end

-- 根据数据创建Item
function CreateItemFrame_SecVip()
	return SecVip_RedrawUI()
end

-- 得到物品个数
function GetItemCount_SecVip(ItemCount)
	AllCount = ItemCount
	if AllCount < 13 then
		heroInfo_togglebtn:SetVisible(0)
		heroInfo_toggleImg:SetVisible(0)
	else
		heroInfo_togglebtn:SetVisible(1)
		heroInfo_toggleImg:SetVisible(1)
	end
	return CreateItemFrame_SecVip()
end

-- 绘制商品信息界面
function SecVip_RedrawUI()
	for i=1, #g_item_ui do
		if ((i+Many*4) > AllCount) then
			g_item_ui[i]:SetVisible(0)
		else
			if (EquipInfo.strPictureAdr[i+Many*4] == "" or EquipInfo.strPictureAdr[i+Many*4] == nil) then
				-- 如果图片路劲为空则返回
				log("\nErrorIconPathFrom [shop_vip]")
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
					g_item_gold_font[i]:SetFontText(EquipInfo.gold[i+Many*4], 0x83d1e7)
				end
				if (EquipInfo.money[i+Many*4] == "" or EquipInfo.money[i+Many*4] == nil) then
					g_item_money[i]:SetVisible(0)
				else
					g_item_money[i]:SetVisible(1)
					g_item_money_font[i]:SetFontText(EquipInfo.money[i+Many*4], 0x938ae3)
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
				if (EquipInfo.IsCanBuy[i+Many*4] == tostring(0)) then
					g_item_buy[i]:SetEnabled(0)
				else
					g_item_buy[i]:SetEnabled(1)
				end
			end
		end
	end
end

-- 接收C++传来的商品信息
function SecVip_ReceiveEquipInfo(strName,strPictureAdr,strDesc,leftTime,money,gold,honour,contri,vip,m_Flag,IsCanBuy,Id,ItemId, ctip)
	local size = #EquipInfo.strName+1
	EquipInfo.strName[size] = strName
	EquipInfo.strPictureAdr[size] = strPictureAdr
	EquipInfo.strDesc[size] = strDesc
	EquipInfo.leftTime[size] = leftTime
	EquipInfo.IsCanBuy[size] = IsCanBuy

	-- log("\nmoney = " .. money)
	-- log("\ngold = " .. gold)
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

-- 清空商品信息表
function SecVip_clearEquipInfo()
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
end

function GetFindInputChar_vip()
	if g_shop_vip_ui:IsVisible()==true then
		XTellCInputChar(VIPSearchInput.id)
	end
end

function SetButtonState_secviphero(cindex)
	EquipInfo.IsCanBuy[cindex] = "0"
	if g_item_buy[cindex-Many*4] ~= nil then
		g_item_buy[cindex-Many*4]:SetEnabled(0)
	end
end

function ReSetItemPosAndVisible_Secvip()
	SecVip_RedrawUI()
end