include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


local backGround = nil --底图
local close_button = nil
local GemItem = {}
local GemItemkuang = {}
local PosX = {}
local PosY = {}
local ToggleBK = nil --滚动条底
local ToggleBTN = nil --滚动条按键
local ToggleBTN_PosY = 0 		-------上次滑动按钮停留的位置


local EquipGemBuy = {}
EquipGemBuy.ustId = {} 
EquipGemBuy.picPath = {}

local GemBuyfont = {}
local GemBuyEventCase = 1--1为买宝石 2为分解宝石

local updownCount = 0
local maxUpdown = 0

function GemBuy_SetEventCase(index)
    GemBuyEventCase = index
	if(GemBuyEventCase == 1) then
	    GemBuyfont:SetFontText("点击购买宝石",0x7788be)
	elseif(GemBuyEventCase == 2) then
	    GemBuyfont:SetFontText("分解成以下宝石",0x7788be)
	end
end


function InitEquip_GemBuy_ui(wnd, bisopen)
	g_equip_GemBuy_ui = CreateWindow(wnd.id, 450, 330, 450, 500)
	InitEquip_GemBuy(g_equip_GemBuy_ui)
	g_equip_GemBuy_ui:SetVisible(bisopen)
end
----------整个界面显示

function InitEquip_GemBuy(wnd)
    backGround = wnd:AddImage(path_equip.."GemBuyBack_equip.png",0,0,450, 213)
	close_button = g_equip_GemBuy_ui:AddButton(path_hero.."closesmall1_hero.png",path_hero.."closesmall2_hero.png",path_hero.."closesmall3_hero.png",419,10,32,32)
	close_button.script[XE_LBUP] = function()
		SetEquip_GemBuyIsVisible(0)
	end
	GemBuyfont = backGround:AddFont("点击购买宝石",15,0,170,10,200,15,0x7788be)
	
	for index = 1,35 do
		PosX[index] = (index-1)%7*54+27
		PosY[index] = 54*math.ceil(index/7)-15	
		GemItem[index] = g_equip_GemBuy_ui:AddImage(path_equip.."bag_equip.png",PosX[index],PosY[index],50,50)
		if PosY[index] >195 or PosY[index] <32 then
			GemItem[index]:SetVisible(0)
		else
		    GemItem[index]:SetVisible(1)
		end
		
		
	    EquipGemBuy[index] = GemItem[index]:AddImage(path_equip.."bag_equip.png",0,0,50,50)
		GemItemkuang[index] = GemItem[index]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
	    EquipGemBuy[index]:SetVisible(0)
		EquipGemBuy[index].script[XE_LBUP] = function()
		    if(EquipGemBuy.ustId[index] == nil or EquipGemBuy.ustId[index] == 0 or GemBuyEventCase ~=1) then
			    return
			end
            XEquipGemBuyByUstId(EquipGemBuy.ustId[index])	
            GemItemkuang[index].changeimage(path_equip.."kuang_equip.png")			
		end
		
		EquipGemBuy[index].script[XE_ONHOVER] = function()
			GemItemkuang[index].changeimage(path_equip.."kuang2_equip.png")
		end
		EquipGemBuy[index].script[XE_ONUNHOVER] = function()
			GemItemkuang[index].changeimage(path_equip.."kuang_equip.png")
		end
		EquipGemBuy[index].script[XE_LBDOWN] = function()
			GemItemkuang[index].changeimage(path_equip.."kuang3_equip.png")
		end
	end

		---右边滚动条
	ToggleBK = wnd:AddImage(path.."toggleBK_main.png",421,56,16,124)
	ToggleBTN = ToggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = ToggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = ToggleBK:AddImage(path.."TD1_main.png",0,124,16,16)
	
	XSetWindowFlag(ToggleBTN.id,1,1,0,74)
	
	ToggleBTN:ToggleBehaviour(XE_ONUPDATE, 1)
	ToggleBTN:ToggleEvent(XE_ONUPDATE, 1)
	ToggleBTN.script[XE_ONUPDATE] = function()
		if ToggleBTN._T == nil then
			ToggleBTN._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(ToggleBTN.id)
		if ToggleBTN._T ~= T then
			local length = 0
			if #GemItem<=21 then
				length = 74
			else
				length = 74/math.ceil((#GemItem/7)-3)
			end
			local Many = math.floor(T/length)
			updownCount = Many
			
			if ToggleBTN_PosY ~= Many then
				for i,value in pairs(GemItem) do
					local Li = PosX[i]
					local Ti = PosY[i]- Many*54
					GemItem[i]:SetPosition(Li, Ti )
					if Ti >195 or Ti <32 then
						GemItem[i]:SetVisible(0)
					else
						if (i <= #GemItem) then
							GemItem[i]:SetVisible(1)
						end
					end
				end
				ToggleBTN_PosY = Many
			end			
			ToggleBTN._T = T
		end
	end
	
	XWindowEnableAlphaTouch(g_equip_GemBuy_ui.id)
	g_equip_GemBuy_ui:EnableEvent(XE_MOUSEWHEEL)
	g_equip_GemBuy_ui.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		local length = 0
		maxUpdown = math.ceil((35/7)-3)
		length = 74/maxUpdown
		
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
		ToggleBTN:SetPosition(0,btn_pos)
		ToggleBTN._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
            for i,value in pairs(GemItem) do
				local Li = PosX[i]
				local Ti = PosY[i]- updownCount*54
				GemItem[i]:SetPosition(Li, Ti)
				if Ti >195 or Ti <32 then
					GemItem[i]:SetVisible(0)
				else
					if (i <= #GemItem) then
						GemItem[i]:SetVisible(1)
					end
				end
			end
		end
	end
end

function Equip_GemBuy_GetInfo(strPic,index,ustId,tips)
	 EquipGemBuy[index].changeimage("..\\"..strPic)--跟换图片
	 EquipGemBuy[index]:SetVisible(1)
	 EquipGemBuy.ustId[index] = ustId
	 EquipGemBuy.picPath[index] = "..\\"..strPic
	 EquipGemBuy[index]:SetImageTip(tips)
end

function Equip_GemBuyAllClean()
    for i,value in pairs(GemItem) do
        GemItem[i]:SetPosition(PosX[i],PosY[i])
		if PosY[i] >195 or PosY[i] <32 then
			GemItem[i]:SetVisible(0)
		else
		    GemItem[i]:SetVisible(1)
		end
		EquipGemBuy[i].changeimage()
		EquipGemBuy[i]:SetVisible(0)
		EquipGemBuy.ustId[i] = nil
		EquipGemBuy.picPath[i] = nil
    end
	
	updownCount = 0
	maxUpdown = 0
	ToggleBTN:SetPosition(0,0)
	ToggleBTN._T = 0
end

function SetEquip_GemBuyIsVisible(flag) 
	if g_equip_GemBuy_ui ~= nil then
		if flag == 1 and g_equip_GemBuy_ui:IsVisible() == false then
			g_equip_GemBuy_ui:SetVisible(1)
		elseif flag == 0 and g_equip_GemBuy_ui:IsVisible() == true then
		    Equip_GemBuyAllClean()
			g_equip_GemBuy_ui:SetVisible(0)
			GemBuy_SetEventCase(1)
		end
	end
end

function CheckGemBuyIsvisible()
    if(g_equip_GemBuy_ui:IsVisible()) then
	    return true
	else
        return false	
	end
end



function Equip_GemBuySetPosition(x,y)
	g_equip_GemBuy_ui:SetPosition(x, y)
end




