include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------物品合成
local Click_btn = nil
local Click_Font = nil
local checkA = nil

function InitEquip_synthesizeUI(wnd, bisopen)
	g_equip_synthesize_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainEquip_synthesize(g_equip_synthesize_ui)
	g_equip_synthesize_ui:SetVisible(bisopen)
end
function InitMainEquip_synthesize(wnd)
	wnd:AddImage(path_equip.."BK4_equip.png",195,185,884,497)
	
	checkA = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",205,150,128,64)
	checkA:AddFont("物品合成",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkA.script[XE_LBUP] = function()
		XClickPlaySound(5)
	end
	Click_btn = wnd:AddImage(path_equip.."checkB3_equip.png",205,150,128,64)
	Click_Font = Click_btn:AddFont("物品合成",15, 0, 20, 15, 100, 20, 0xbcbcc4)
	
	InitSyn_EquipUI(G_login_ui,0)
end

function SetEquip_synthesizeIsVisible(flag) 
	if g_equip_synthesize_ui ~= nil then
		if flag == 1 and g_equip_synthesize_ui:IsVisible() == false then
			g_equip_synthesize_ui:SetVisible(1)
			
			Click_btn:SetPosition(205,150)
			Click_Font:SetFontText("物品合成")
			
			SetSynEquipIsVisible(1)
		elseif flag == 0 and g_equip_synthesize_ui:IsVisible() == true then
			g_equip_synthesize_ui:SetVisible(0)
			SetSynEquipIsVisible(0)
		end
	end
end

function GetEquip_synthesizeIsVisible()  
    if(g_equip_synthesize_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end