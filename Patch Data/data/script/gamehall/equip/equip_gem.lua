include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------宝石镶嵌
local Click_btn = nil
local Click_Font = nil

local checkA = nil
local checkB = nil

function InitEquip_stoneInlayUI(wnd, bisopen)
	g_equip_stoneInlay_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainEquip_stoneInlay(g_equip_stoneInlay_ui)
	g_equip_stoneInlay_ui:SetVisible(bisopen)
end
function InitMainEquip_stoneInlay(wnd)
	
	wnd:AddImage(path_equip.."BK4_equip.png",195,185,884,497)
	
	checkA = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",205,150,128,64)
	checkA:AddFont("宝石镶嵌",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(205,150)
		Click_Font:SetFontText("宝石镶嵌")
		
		SetEquip_GemInlayIsVisible(1)
		SetEquip_GemSynIsVisible(0)
	end
	checkB = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",302,150,128,64)
	checkB:AddFont("宝石合成",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(302,150)
		Click_Font:SetFontText("宝石合成")
		
		SetEquip_GemInlayIsVisible(0)
		SetEquip_GemSynIsVisible(1)
	end
	
	
	Click_btn = wnd:AddImage(path_equip.."checkB3_equip.png",205,150,128,64)
	Click_Font = Click_btn:AddFont("宝石镶嵌",15, 0, 20, 15, 100, 20, 0xbcbcc4)
	
	InitEquip_GemInlayUI(G_login_ui,0)
	InitEquip_GemSynUI(G_login_ui,0)
	
end






function SetEquip_stoneInlayIsVisible(flag) 
	if g_equip_stoneInlay_ui ~= nil then
		if flag == 1 and g_equip_stoneInlay_ui:IsVisible() == false then
			g_equip_stoneInlay_ui:SetVisible(1)
			
			Click_btn:SetPosition(205,150)
			Click_Font:SetFontText("宝石镶嵌")
			
			--cleanALl_ItemInfo()
			--XneedAllEquipInfo(1)
			
			SetEquip_GemInlayIsVisible(1)
			SetEquip_GemSynIsVisible(0)
			
		elseif flag == 0 and g_equip_stoneInlay_ui:IsVisible() == true then
			g_equip_stoneInlay_ui:SetVisible(0)
			SetEquip_GemInlayIsVisible(0)
			SetEquip_GemSynIsVisible(0)
						
		end
	end
end

function GetEquip_stoneInlayIsVisible()  
    if(g_equip_stoneInlay_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end