include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


---------商品的窗口
local g_item_ui = {}		-------主窗口
local g_item_posx = {}		-------窗口X
local g_item_posy = {}		-------窗口Y
local g_item_name = {}		-------商品名称
local g_item_Time = {}		-------商品限时、打折等等

local g_item_money = {}		-------金币价格
local g_item_gold = {}		-------钻石价格
local g_item_buy = {}		-------购买按钮

local Gold_btn = nil		-------金币排序
local Gold_N = nil			-------不排序
local Gold_H = nil			-------最高
local Gold_L = nil			-------最低
local Gold_index = 0



------------界面控件
local EquipHeroPhenSearchInputEdit = nil
local EquipHeroPhenSearchInput = nil
--local EquipHeroPhenSearchInputText = nil
local check_herohave = nil
local Many_Equip = 0 		-------上次滑动按钮停留的位置
local heroInfo_togglebtn = nil


------------下拉列表
local BTN_oftenUseBK = {}
local BTN_oftenUseFont = {"最新上架","英雄翅膀","英雄头饰","英雄宠物"}

local btn_Oftenuse = nil
local Font_Oftenuse = nil
local Oftenuse_BK = nil


local ppx = -50
local ppy = -150
local updownCount = 0
local maxUpdown = 0

function IsShop_Sec_HeroPhenInputFocus()
	if EquipHeroPhenSearchInput ~= nil then
		return EquipHeroPhenSearchInput:IsFocus()
	end
	return false
end


function InitShop_Sec_HeroPhenUI(wnd, bisopen)
	g_shop_Sec_heroPhen_ui = CreateWindow(wnd.id, 50, 150, 900, 600)
	InitMainShop_Sec_HeroPhen(g_shop_Sec_heroPhen_ui)
	g_shop_Sec_heroPhen_ui:SetVisible(bisopen)
end
function InitMainShop_Sec_HeroPhen(wnd)
	
	----装扮分类
	local hero_use = wnd:AddImage(path_start.."sortbk_start.png",710+ppx,120+ppy,128,32)
	hero_use:AddFont("装扮分类",12,0,22,6,100,15,0xbeb5ee)

	-------滚动条
	heroInfo_toggleImg = wnd:AddImage(path.."toggleBK_main.png",918+ppx,180+ppy,16,540)
	heroInfo_togglebtn = heroInfo_toggleImg:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = heroInfo_toggleImg:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = heroInfo_toggleImg:AddImage(path.."TD1_main.png",0,540,16,16)
	
	XSetWindowFlag(heroInfo_togglebtn.id,1,1,0,490)
	
	heroInfo_togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)
	heroInfo_togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	
	heroInfo_togglebtn.script[XE_ONUPDATE] = function()
		if heroInfo_togglebtn._T == nil then
			heroInfo_togglebtn._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(heroInfo_togglebtn.id)
		if heroInfo_togglebtn._T ~= T then
		
			local length = math.floor(490/math.ceil((#g_item_ui/4)-3))
			local Many = math.floor(T/length)
			--updownCount = Many
			if Many_Equip ~= Many then
				for i,value in pairs(g_item_ui) do
					local Li = g_item_posx[i]
					local Ti = g_item_posy[i]- Many*193
					
					g_item_ui[i]:SetPosition(Li, Ti )
					
					if Ti >700+ppy or Ti <100+ppy then
						g_item_ui[i]:SetVisible(0)
					else
						g_item_ui[i]:SetVisible(1)
					end
				end
				Many_Equip = Many
			end				
			heroInfo_togglebtn._T = T
		end
	end
	
	----------具体的商品信息
	for i=1,120 do
		g_item_posx[i] = 213*((i-1)%4+1)-150+ppx
		g_item_posy[i] = 193*math.ceil(i/4)-33+ppy
		
		g_item_ui[i] = wnd:AddImage(path_shop.."ITEMBK_shop.png",g_item_posx[i],g_item_posy[i],212,195)
		g_item_name[i] = g_item_ui[i]:AddFont("装备升级超级礼包", 15, 0, 55, 17, 200, 30, 0x83d1e7)
		g_item_Time[i] = g_item_ui[i]:AddImage(path_shop.."flag1_shop.png",0,42,128,32)
		
		g_item_money[i] = g_item_ui[i]:AddImage(path_shop.."money_shop.png",7,110,64,64)
		g_item_gold[i] = g_item_ui[i]:AddImage(path_shop.."gold_shop.png",100,110,64,64)
		
		g_item_buy[i] = g_item_ui[i]:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",65,145,83,35)
		g_item_buy[i]:AddFont("购买"..i, 15, 0, 22, 7, 100, 30, 0xc7bcf6)
		
		if g_item_posy[i] >700+ppy or g_item_posy[i] <100+ppy then
			g_item_ui[i]:SetVisible(0)
		else
			g_item_ui[i]:SetVisible(1)
		end
		
	end
	
	----常用优先下拉背景框
	btn_Oftenuse = wnd:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",815+ppx,120+ppy,128,32)
	Font_Oftenuse = btn_Oftenuse:AddFont(BTN_oftenUseFont[1],12,0,18,6,100,15,0xbeb5ee)
	
	Oftenuse_BK = wnd:AddImage(path_shop.."listBK1_shop.png",815+ppx,150+ppy,128,512)
	wnd:SetAddImageRect(Oftenuse_BK.id,0,0,128,120,815+ppx,150+ppy,128,120)
	Oftenuse_BK:SetVisible(0)
	
	for dis = 1,4 do
		BTN_oftenUseBK[dis] = wnd:AddImage(path_hero.."listhover_hero.png",815+ppx,121+dis*29+ppy,128,32)
		Oftenuse_BK:AddFont(BTN_oftenUseFont[dis],12,0,18,dis*29-23,128,32,0xbeb5ee)
		BTN_oftenUseBK[dis]:SetTransparent(0)
		BTN_oftenUseBK[dis]:SetTouchEnabled(0)
		-----------鼠标滑过
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
			
			--onSearchEnter()
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
	
	----装扮搜索
	EquipHeroPhenSearchInputEdit = CreateWindow(wnd.id, 985+ppx,165+ppy, 256, 32)
	EquipHeroPhenSearchInput = EquipHeroPhenSearchInputEdit:AddEdit(path_shop.."InputEdit_shop.png","","onHeroPhenSearch_Enter","",13,5,5,230,25,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(EquipHeroPhenSearchInput.id,60)
	EquipHeroPhenSearchInput:SetDefaultFontText("搜索按Enter键确定",0xff303b4a)
	
	
	----钻石价格排序
	Gold_btn = wnd:AddButton(path_shop.."gold0_shop.png",path_shop.."gold0_shop.png",path_shop.."gold0_shop.png",1030+ppx,335+ppy,256,32)	
	Gold_N = wnd:AddImage(path_shop.."gold0_shop.png",1030+ppx,335+ppy,256,32)
	Gold_H = wnd:AddImage(path_shop.."goldH_shop.png",1030+ppx,335+ppy,256,32)
	Gold_L = wnd:AddImage(path_shop.."goldL_shop.png",1030+ppx,335+ppy,256,32)
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
	end
	
	----未拥有装扮
	local NotHave = wnd:AddImage(path_start.."sortbk_start.png",1030+ppx,215+ppy,128,32)
	NotHave:AddFont("未拥有装扮", 15, 0, 15, 5, 100, 20, 0xc7bcf6)
	
	local check_heroBK = wnd:AddImage(path_hero.."checkbox_hero.png",1146+ppx,215+ppy,32,32)
	check_heroBK:SetTouchEnabled(1)
	check_herohave = check_heroBK:AddImage(path_hero.."checkboxYes_hero.png",4,-2,32,32)
	check_herohave:SetTouchEnabled(0)
	check_herohave:SetVisible(0)
	check_heroBK.script[XE_LBUP] = function()
		if (check_herohave:IsVisible()) then
			check_herohave:SetVisible(0)
			index_have = 1
		else
			check_herohave:SetVisible(1)
			index_have = 2
		end
		
		----onSearchEnter()
	end
end

------------------装扮搜索
function IsFocusOn_EquipSearchHeroPhen()
	if (g_shop_Sec_heroPhen_ui:IsVisible() == true) then
		-------搜索框框
		local Input_Focus = EquipHeroPhenSearchInput:IsFocus()
		
		if Input_Focus == true then
			EquipHeroPhenSearchInputText:SetVisible(0)
		elseif Input_Focus == false and EquipHeroPhenSearchInputText:IsVisible() == false then
			EquipHeroPhenSearchInput:SetEdit("")
			EquipHeroPhenSearchInputText:SetVisible(1)
		end

		------下拉选项框
		local flagB = Oftenuse_BK:IsVisible() == true and btn_Oftenuse:IsFocus() == false and BTN_oftenUseBK[1]:IsFocus() == false and BTN_oftenUseBK[2]:IsFocus() == false
		and BTN_oftenUseBK[3]:IsFocus() == false and BTN_oftenUseBK[4]:IsFocus() == false

		if(flagB == true) then
			btn_Oftenuse:SetButtonFrame(0)
			Oftenuse_BK:SetVisible(0)
			for index,value in pairs(BTN_oftenUseBK) do
				BTN_oftenUseBK[index]:SetTransparent(0)
			end
		end
	end
end

function onHeroPhenSearch_Enter()
	EquipHeroPhenSearchInput:SetEdit("")
end

function SetShop_Sec_HeroPhenIsVisible(flag) 
	if g_shop_Sec_heroPhen_ui ~= nil then
		if flag == 1 and g_shop_Sec_heroPhen_ui:IsVisible() == false then
			g_shop_Sec_heroPhen_ui:SetVisible(1)
		elseif flag == 0 and g_shop_Sec_heroPhen_ui:IsVisible() == true then
			g_shop_Sec_heroPhen_ui:SetVisible(0)
		end
	end
end

function GetShop_Sec_HeroPhenIsVisible()  
    if(g_shop_Sec_heroPhen_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end