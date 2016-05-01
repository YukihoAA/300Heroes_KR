include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------装备强化
local Click_btn = nil
local Click_Font = nil

local checkA = nil
local checkB = nil
local checkC = nil
local checkD = nil

function InitEquip_strUI(wnd, bisopen)
	g_equip_str_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainEquip_str(g_equip_str_ui)
	g_equip_str_ui:SetVisible(bisopen)
end
function InitMainEquip_str(wnd)
	wnd:AddImage(path_equip.."BK4_equip.png",195,185,884,497)
	
	InitEquip_StrStrengthUI(G_login_ui,0)
	InitEquip_StrRebuildUI(G_login_ui,0)
	InitEquip_StrSoulUI(G_login_ui,0)
	InitEquip_StrMakeUI(G_login_ui,0)
	InitEquip_StrBagSoulUI(G_login_ui,0)
	InitEquip_StrBagMakeUI(G_login_ui,0)
	

	checkA = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",205,150,128,64)
	checkA:AddFont("强化",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(205,150)
		Click_Font:SetFontText("强化")
		
		SetEquip_StrStrengthIsVisible(1)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(1)
		SetEquip_StrBagMakeIsVisible(0)	
	end
	checkB = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",302,150,128,64)
	checkB:AddFont("重铸",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(302,150)
		Click_Font:SetFontText("重铸")
		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(1)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(1)
		SetEquip_StrBagMakeIsVisible(0)
		
	end
	checkC = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",399,150,128,64)
	checkC:AddFont("铸魂",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(399,150)
		Click_Font:SetFontText("铸魂")
		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(1)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(1)
		SetEquip_StrBagMakeIsVisible(0)
		
	end
	checkD = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",496,150,128,64)
	checkD:AddFont("炼金",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkD.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(496,150)
		Click_Font:SetFontText("炼金")
		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(1)
		SetEquip_StrBagSoulIsVisible(0)
		SetEquip_StrBagMakeIsVisible(1)
	end

	Click_btn = wnd:AddImage(path_equip.."checkB3_equip.png",205,150,128,64)
	Click_Font = Click_btn:AddFont("强化",15, 0, 40, 15, 100, 20, 0xbcbcc4)
	
end

     

function SetEquip_strIsVisible(flag) 
	if g_equip_str_ui ~= nil then
		if flag == 1 and g_equip_str_ui:IsVisible() == false then
		
			XEquip_str_ClickUp(1)--通知c++开启界面
			g_equip_str_ui:SetVisible(1)
			
			Click_btn:SetPosition(205,150)
			Click_Font:SetFontText("强化")
			
			SetEquip_StrStrengthIsVisible(1)
			SetEquip_StrRebuildIsVisible(0)
			SetEquip_StrSoulIsVisible(0)
			SetEquip_StrMakeIsVisible(0)
			SetEquip_StrBagSoulIsVisible(1)
			SetEquip_StrBagMakeIsVisible(0)
			
		elseif flag == 0 and g_equip_str_ui:IsVisible() == true then
			g_equip_str_ui:SetVisible(0)
			SetEquip_StrStrengthIsVisible(0)
			SetEquip_StrRebuildIsVisible(0)
			SetEquip_StrSoulIsVisible(0)
			SetEquip_StrMakeIsVisible(0)
			SetEquip_StrBagSoulIsVisible(0)
			SetEquip_StrBagMakeIsVisible(0)
			
		end
	end
end

function GetEquip_strIsVisible()  
    if(g_equip_str_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end