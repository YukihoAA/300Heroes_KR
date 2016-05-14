include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


---菜单栏
local btn_sec_stone = nil
local btn_sec_equipStr = nil

local btn_ListBK = nil

local ppx = -60
local ppy = -100

function InitShop_StoneStrUI(wnd, bisopen)
	g_shop_stoneStr_ui = CreateWindow(wnd.id, 60, 100, 420, 80)
	InitMainShop_StoneStr(g_shop_stoneStr_ui)
	g_shop_stoneStr_ui:SetVisible(bisopen)
end
function InitMainShop_StoneStr(wnd)
	
	btn_ListBK = wnd:AddImage(path_shop.."ListBK_rec.png",60+ppx,107+ppy,256,64)
	wnd:AddImage(path_shop.."upLine_rec.png",60+ppx,155+ppy,188,3)
	wnd:AddImage(path_shop.."upLine_rec.png",200+ppx,155+ppy,188,3)
		
	InitShop_Sec_StoneUI(G_login_ui, 0)				--装备
	InitShop_Sec_EquipStrUI(G_login_ui, 0)			--神器
	
	--装备
	btn_sec_stone = wnd:AddCheckButton(path_shop.."indexF1_rec.png",path_shop.."indexF2_rec.png",path_shop.."indexF3_rec.png",90+ppx,122+ppy,100,34)
	XWindowEnableAlphaTouch(btn_sec_stone.id)
	btn_sec_stone.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(60+ppx,107+ppy)
		
		SetShop_Sec_StoneIsVisible(1)
		SetShop_Sec_EquipStrIsVisible(0)
		
		btn_sec_equipStr:SetCheckButtonClicked(0)
	end
	--神器
	btn_sec_equipStr = wnd:AddCheckButton(path_shop.."indexG1_rec.png",path_shop.."indexG2_rec.png",path_shop.."indexG3_rec.png",230+ppx,122+ppy,100,34)
	XWindowEnableAlphaTouch(btn_sec_equipStr.id)
	btn_sec_equipStr.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(200+ppx,107+ppy)
		
		SetShop_Sec_StoneIsVisible(0)
		SetShop_Sec_EquipStrIsVisible(1)
			
		btn_sec_stone:SetCheckButtonClicked(0)
	end
	
end

function SetShop_StoneStrIsVisible(flag) 
	if g_shop_stoneStr_ui ~= nil then
		if flag == 1 and g_shop_stoneStr_ui:IsVisible() == false then
			g_shop_stoneStr_ui:SetVisible(1)
			
			SetShop_Sec_StoneIsVisible(1)
			SetShop_Sec_EquipStrIsVisible(0)
			
			btn_sec_stone:SetCheckButtonClicked(1)
			btn_sec_equipStr:SetCheckButtonClicked(0)
			
			btn_ListBK:SetPosition(60+ppx,107+ppy)
			btn_ListBK:SetVisible(1)
			
		elseif flag == 0 and g_shop_stoneStr_ui:IsVisible() == true then
			g_shop_stoneStr_ui:SetVisible(0)
			
			SetShop_Sec_StoneIsVisible(0)
			SetShop_Sec_EquipStrIsVisible(0)
		end
	end
end

function GetShop_StoneStrIsVisible()  
    if(g_shop_stoneStr_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end