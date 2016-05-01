include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local btn_HeroAll = nil
local btn_HeroSkin = nil
local btn_ListBK = nil

function InitGame_HeroSkinUI(wnd, bisopen)
	g_game_heroSkin_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainGame_HeroSkin(g_game_heroSkin_ui)
	g_game_heroSkin_ui:SetVisible(bisopen)
end
function InitMainGame_HeroSkin(wnd)
	--µ×Í¼±³¾°
	local bkk = wnd:AddImage(path_hero.."ffffff_hero.png",0,0,1280,800)
	
	--ÉÏ±ßÀ¸
	wnd:AddImage(path.."upBK_hall.png",0,0,1280,54)
	wnd:AddImage(path.."upLine2_hall.png",0,54,1280,35)
	--wnd:AddImage(path.."linecut_hall.png",273,60,2,32)	
	btn_ListBK = wnd:AddImage(path_start.."ListBK_start.png",245,53,256,38)
		
	--Ó¢ÐÛ×ÜÀÀ
	btn_HeroAll = wnd:AddCheckButton(path_hero.."indexA1_hero.png",path_hero.."indexA2_hero.png",path_hero.."indexA3_hero.png",165,53,110,33)
	btn_HeroAll:SetVisible(0)
	XWindowEnableAlphaTouch(btn_HeroAll.id)
	btn_HeroAll.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		SetGameHeroAllIsVisible(1)
		SetGameHeroSkinIsVisible(0)		
	end
	--Ó¢ÐÛ×°°ç
	btn_HeroSkin = wnd:AddImage(path_hero.."indexB3_hero.png",275,53,110,33)
	
end

function SetGameHeroSkinIsVisible(flag) 
	if g_game_heroSkin_ui ~= nil then
		if flag == 1 and g_game_heroSkin_ui:IsVisible() == false then
			g_game_heroSkin_ui:SetVisible(1)
			
			btn_HeroAll:SetCheckButtonClicked(0)
			SetFourpartUIVisiable(4)
		elseif flag == 0 and g_game_heroSkin_ui:IsVisible() == true then
			g_game_heroSkin_ui:SetVisible(0)
		end
	end
end

function GetGameHeroSkinIsVisible()  
    if(g_game_heroSkin_ui:IsVisible()) then
        XGameHeroSkinIsOpen(1)
    else
        XGameHeroSkinIsOpen(0)
    end
end