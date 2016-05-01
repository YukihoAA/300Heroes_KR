include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

---菜单栏
local btn_sec_equip = nil
local btn_sec_bestequip = nil

local btn_ListBK = nil

local ppx = -60
local ppy = -100

function InitShop_BattleEquipUI(wnd, bisopen)
	g_shop_battleEquip_ui = CreateWindow(wnd.id, 60, 100, 420, 80)
	InitMainShop_BattleEquip(g_shop_battleEquip_ui)
	g_shop_battleEquip_ui:SetVisible(bisopen)
end
function InitMainShop_BattleEquip(wnd)

	btn_ListBK = wnd:AddImage(path_shop.."ListBK_rec.png",60+ppx,107+ppy,256,64)
	wnd:AddImage(path_shop.."upLine_rec.png",60+ppx,155+ppy,188,3)
	wnd:AddImage(path_shop.."upLine_rec.png",200+ppx,155+ppy,188,3)

	InitShop_Sec_EquipUI(G_login_ui, 0)				--装备
	InitShop_Sec_BestEquipUI(G_login_ui, 0)			--神器
	
	--装备
	btn_sec_equip = wnd:AddCheckButton(path_shop.."indexD1_rec.png",path_shop.."indexD2_rec.png",path_shop.."indexD3_rec.png",90+ppx,122+ppy,100,34)
	XWindowEnableAlphaTouch(btn_sec_equip.id)
	btn_sec_equip.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(60+ppx,107+ppy)
		
		SetShop_Sec_EquipIsVisible(1)
		SetShop_Sec_BestEquipIsVisible(0)
		
		btn_sec_bestequip:SetCheckButtonClicked(0)
	end
	--神器
	btn_sec_bestequip = wnd:AddCheckButton(path_shop.."indexE1_rec.png",path_shop.."indexE2_rec.png",path_shop.."indexE3_rec.png",230+ppx,122+ppy,100,34)
	XWindowEnableAlphaTouch(btn_sec_bestequip.id)
	btn_sec_bestequip.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(200+ppx,107+ppy)
		
		SetShop_Sec_EquipIsVisible(0)
		SetShop_Sec_BestEquipIsVisible(1)
			
		btn_sec_equip:SetCheckButtonClicked(0)
	end
end

function SetShop_BattleEquipIsVisible(flag) 
	if g_shop_battleEquip_ui ~= nil then
		if flag == 1 and g_shop_battleEquip_ui:IsVisible() == false then
			g_shop_battleEquip_ui:SetVisible(1)
			
			SetShop_Sec_EquipIsVisible(1)
			SetShop_Sec_BestEquipIsVisible(0)
			
			btn_sec_equip:SetCheckButtonClicked(1)
			btn_sec_bestequip:SetCheckButtonClicked(0)
			
			btn_ListBK:SetPosition(60+ppx,107+ppy)
			btn_ListBK:SetVisible(1)
		elseif flag == 0 and g_shop_battleEquip_ui:IsVisible() == true then
			g_shop_battleEquip_ui:SetVisible(0)
			
			SetShop_Sec_EquipIsVisible(0)
			SetShop_Sec_BestEquipIsVisible(0)
		end
	end
end

function GetShop_BattleEquipIsVisible()  
    if(g_shop_battleEquip_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end