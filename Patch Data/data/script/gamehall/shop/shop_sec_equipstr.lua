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
local EquipStrSearchInputEdit = nil
local EquipStrSearchInput = nil
-- local EquipStrSearchInputText = nil
local check_ADhave = nil
local check_APhave = nil
local check_TANKhave = nil
local check_CShave = nil
local Many_Equip = 0 		-- 上次滑动按钮停留的位置
local Many = 0
local m_VisibleCount = 0

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

local g_item_money = {}		-- 金币价格
local g_item_gold = {}		-- 钻石价格
local g_item_money_font = {}	-- 金币价格FONT
local g_item_gold_font = {}		-- 钻石价格FONT
local g_item_honour = {}		-- 功勋价格
local g_item_contri = {}		-- 荣誉价格
local g_item_vip = {}		-- VIP价格

local g_item_flag = {}		-- 商品限时、打折等等

local g_item_buy = {}		-- 购买按钮
-- local g_item_buyUnEnable = {} -- 购买不可点击

local index_have = 1
local ppx = -50
local ppy = -150
local AllCount = 0
local heroInfo_toggleImg = nil
local heroInfo_togglebtn = nil
local updownCount = 0
local maxUpdown = 0

function IsShop_Sec_EquipStrInputFocus()
	if EquipStrSearchInput ~= nil then
		return EquipStrSearchInput:IsFocus()
	end
	return false
end

function InitShop_Sec_EquipStrUI(wnd, bisopen)
	g_shop_Sec_EquipStr_ui = CreateWindow(wnd.id, 50, 150, 900, 600)
	InitMainShop_Sec_EquipStr(g_shop_Sec_EquipStr_ui)
	g_shop_Sec_EquipStr_ui:SetVisible(bisopen)
end

function InitMainShop_Sec_EquipStr(wnd)
	
	-- 装备强化搜索
	EquipStrSearchInputEdit = CreateWindow(wnd.id, 950+ppx,165+ppy, 256, 32)
	EquipStrSearchInput = EquipStrSearchInputEdit:AddEdit(path_shop.."InputEdit_shop.png","","onSec_EquipStrSearch_Enter","",13,5,5,230,25,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(EquipStrSearchInput.id,60)
	EquipStrSearchInput:SetDefaultFontText("搜索按Enter键确定",0xff303b4a)
	local FindButton = EquipStrSearchInputEdit:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png", 235, -3, 83, 35)
	FindButton:SetVisible(0)
	FindButton.script[XE_LBUP] = function()
		XEnterFindInput(1, EquipStrSearchInput.id, 1)
		ResetSecStoneStrScrollList()
	end
	
	-- 装备强化
	-- local ADHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,215+ppy,128,32)
	-- ADHave:AddFont("装备强化", 15, 0, 20, 5, 100, 20, 0xc7bcf6)
	
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
	----装备重铸
	-- local APHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,250+ppy,128,32)
	-- APHave:AddFont("装备重铸", 15, 0, 20, 5, 100, 20, 0xc7bcf6)
	
	-- local check_APBK = wnd:AddImage(path_hero.."checkbox_hero.png",1146+ppx,250+ppy,32,32)
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
	----装备铸魂
	-- local TANKHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,285+ppy,128,32)
	-- TANKHave:AddFont("装备铸魂", 15, 0, 20, 5, 100, 20, 0xc7bcf6)
	
	-- local check_TANKBK = wnd:AddImage(path_hero.."checkbox_hero.png",1146+ppx,285+ppy,32,32)
	-- check_TANKBK:SetTouchEnabled(1)
	-- check_TANKhave = check_TANKBK:AddImage(path_hero.."checkboxYes_hero.png",4,-2,32,32)
	-- check_TANKhave:SetTouchEnabled(0)
	-- check_TANKhave:SetVisible(0)
	-- check_TANKBK.script[XE_LBUP] = function()
		-- if (check_TANKhave:IsVisible()) then
			-- check_TANKhave:SetVisible(0)
		-- else
			-- check_TANKhave:SetVisible(1)
		-- end
		
		-- ----onSearchEnter()
	-- end
	----炼金道具
	-- local CSHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,320+ppy,128,32)
	-- CSHave:AddFont("炼金道具", 15, 0, 20, 5, 100, 20, 0xc7bcf6)
	
	-- local check_CSBK = wnd:AddImage(path_hero.."checkbox_hero.png",1146+ppx,320+ppy,32,32)
	-- check_CSBK:SetTouchEnabled(1)
	-- check_CShave = check_CSBK:AddImage(path_hero.."checkboxYes_hero.png",4,-2,32,32)
	-- check_CShave:SetTouchEnabled(0)
	-- check_CShave:SetVisible(0)
	-- check_CSBK.script[XE_LBUP] = function()
		-- if (check_CShave:IsVisible()) then
			-- check_CShave:SetVisible(0)
		-- else
			-- check_CShave:SetVisible(1)
		-- end
		
		-- ----onSearchEnter()
	-- end
	
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
		------恢复钻石排序为默认
		Gold_index = 0
		Gold_N:SetVisible(1)
		Gold_H:SetVisible(0)
		Gold_L:SetVisible(0)
		
		--ResetSecStoneStrScrollList()
		XShopSrotHeroCheckMoney(1, Money_index)
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
		------恢复金币排序为默认
		Money_index = 0
		Money_N:SetVisible(1)
		Money_H:SetVisible(0)
		Money_L:SetVisible(0)
		
		--ResetSecStoneStrScrollList()
		XShopSrotHeroCheckGold(1, Gold_index)
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
					SecStoneStr_RedrawUI()
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
			SecStoneStr_RedrawUI()
		end
	end
	
	-- 具体的商品信息
	for i=1, 12 do
		g_item_posx[i] = 213*((i -1)%4+1)-150+ppx
		g_item_posy[i] = 193*math.ceil((i)/4)-33+ppy
		g_item_ui[i] = g_shop_Sec_EquipStr_ui:AddImage(path_shop.."ITEMBK_shop.png",g_item_posx[i],g_item_posy[i],212,195)
		g_item_flag[i] = g_item_ui[i]:AddImage(path_shop.."flag1_shop.png",0,42,128,32)
		g_item_flag[i]:SetVisible(0)
		g_item_pic[i] = g_item_ui[i]:AddImage(path_equip.."bag_equip.png",74,44,64,64)
		g_item_ui[i]:AddImage(path_shop.."itemside_shop.png",68,38,76,76)
		
		g_item_money[i] = g_item_ui[i]:AddImage(path_shop.."money_shop.png",10,110,64,64)
		g_item_gold[i] = g_item_ui[i]:AddImage(path_shop.."gold_shop.png",103,110,64,64)
		
		g_item_buy[i] = g_item_ui[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		g_item_buy[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			--SetShopItemBuyNameInfo(EquipInfo.strName[i])
			XShopBuyItemIndexForLua(i+Many*4-1)
			XShopClickBuyItem(1, EquipInfo.Id[i+Many*4], EquipInfo.ItemId[i+Many*4])
		end
		
		g_item_name[i] = g_item_ui[i]:AddFont("英雄"..i, 15, 8, -7, -18, 200, 20, 0x83d1e7)
		g_item_Time[i] = g_item_ui[i]:AddFont("99天\n20小时", 11, 0, 155, 57, 50, 50, 0xbeb5ee)
		g_item_Time[i]:SetVisible(0)
		g_item_gold_font[i] = g_item_gold[i]:AddFontEx("1", 15, 0, 33, 8, 100, 20, 0xff83d1e7)
		g_item_gold_font[i]:SetFontSpace(1, 0)
		g_item_money_font[i] = g_item_money[i]:AddFontEx("1", 15, 0, 33, 8, 100, 20, 0xffe4e18b)
		g_item_money_font[i]:SetFontSpace(1, 0)
		g_item_buy[i]:AddFont("购买", 15, 0, 22, 7, 100, 20, 0xc7bcf6)
	end
	
	FindButton:AddFont("搜索", 18, 0, 15, 2, 100, 20, 0xffffff)
end

-- 装备强化搜索
function IsFocusOn_EquipStrSearch()
	if (g_shop_Sec_EquipStr_ui:IsVisible() == true) then
		-- 搜索框框
		local Input_Focus = EquipStrSearchInput:IsFocus()
		
		if Input_Focus == true then
		
		elseif Input_Focus == false then
			-- EquipStrSearchInput:SetEdit("")
		end
	end
end

function onSec_EquipStrSearch_Enter()
	XEnterFindInput(1, EquipStrSearchInput.id, 0)
	ResetSecStoneStrScrollList()
end

function SetShop_Sec_EquipStrIsVisible(flag) 
	if g_shop_Sec_EquipStr_ui ~= nil then
		if flag == 1 and g_shop_Sec_EquipStr_ui:IsVisible() == false then
			g_shop_Sec_EquipStr_ui:SetVisible(1)
			XSetShopSecEquipStrUiVisible(1)
			XClickShopSecStoneUi(1, 1)		-- 1表示强化界面
		elseif flag == 0 and g_shop_Sec_EquipStr_ui:IsVisible() == true then
			g_shop_Sec_EquipStr_ui:SetVisible(0)
			XSetShopSecEquipStrUiVisible(0)
			EquipStrSearchInput:SetEdit("")
			Gold_N:SetVisible(1)
			Gold_H:SetVisible(0)
			Gold_L:SetVisible(0)
			Money_N:SetVisible(1)
			Money_H:SetVisible(0)
			Money_L:SetVisible(0)
			Money_index = 0
			Gold_index = 0
		end
	end
end

function GetShop_Sec_EquipStrIsVisible()  
    if(g_shop_Sec_EquipStr_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function ResetSecStoneStrScrollList()
	-- 让控件和滚动条保持一致
	Many = 0
	Many_Equip = Many
	-- end		
	updownCount = 0
	maxUpdown = 0
	heroInfo_togglebtn:SetPosition(0,0)
	heroInfo_togglebtn._T = 0
	SecStoneStr_RedrawUI()
end

-- 根据数据创建Item
function CreateItemFrame_SecStoneStr()
	return SecStoneStr_RedrawUI()
end

-- 得到物品个数
function GetItemCount_SecStoneStr(ItemCount)
	AllCount = ItemCount
	if AllCount < 13 then
		heroInfo_togglebtn:SetVisible(0)
		heroInfo_toggleImg:SetVisible(0)
	else
		heroInfo_togglebtn:SetVisible(1)
		heroInfo_toggleImg:SetVisible(1)
	end
	return CreateItemFrame_SecStoneStr()
end

-- 绘制商品信息界面
function SecStoneStr_RedrawUI()
	for i=1, #g_item_ui do
		if ((i+Many*4) > AllCount) then
			g_item_ui[i]:SetVisible(0)
		else
			if (EquipInfo.strPictureAdr[i+Many*4] == "" or EquipInfo.strPictureAdr[i+Many*4] == nil) then
				-- 如果图片路劲为空则返回
				log("\nErrorIconPathFrom [shop_Sec_equipStr]")
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

-- 接收C++传来的商品信息
function SecStoneStr_ReceiveEquipInfo(strName,strPictureAdr,strDesc,leftTime,money,gold,honour,contri,vip,m_Flag,IsCanBuy,Id,ItemId, ctip)
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

-- 清空商品信息表
function SecStoneStr_clearEquipInfo()
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

function GetFindInputChar_equipstr()
	if g_shop_Sec_EquipStr_ui:IsVisible()==true then
		XTellCInputChar(EquipStrSearchInput.id)
	end
end

function ReSetItemPosAndVisible_SecStonestr()
	SecStoneStr_RedrawUI()
end