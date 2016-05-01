include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------场内界面---成就
function InitAchievement_InsideUI(wnd, bisopen)
	g_achievement_inside_ui = CreateWindow(wnd.id, (1920-1280)/2, (1080-750)/2, 1280, 750)
	InitMainAchievement_Inside(g_achievement_inside_ui)
	g_achievement_inside_ui:SetVisible(bisopen)
end
function InitMainAchievement_Inside(wnd)
	local A = wnd:AddImage(path_shop.."BK_shop.png",30,27,1280,800)
	A:SetAddImageRect(A.id, 0, 50, 1220, 700, 30 ,27, 1220, 700)
	XWindowEnableAlphaTouch(A.id)
	
	A:AddImage(path_shop.."lineUp_shop.png",-4,-3,1228,5)
	A:AddImage(path_shop.."lineDown_shop.png",-4,698,1228,5)
	A:AddImage(path_shop.."lineLeft_shop.png",-5,1,5,698)
	A:AddImage(path_shop.."lineRight_shop.png",1220,1,5,698)
	
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",1210,30,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMinimapTitle(0)
	end
end
function SetAchievement_InsideIsVisible(flag) 
	if g_achievement_inside_ui ~= nil then
		if flag == 1 and g_achievement_inside_ui:IsVisible() == false then
			g_achievement_inside_ui:SetVisible(1)
			SetGameHeroAchievementIsVisible(1)
		elseif flag == 0 and g_achievement_inside_ui:IsVisible() == true then
			g_achievement_inside_ui:SetVisible(0)
			SetGameHeroAchievementIsVisible(0)
		end
	end
end

function GetAchievement_InsideIsVisible()  
    if(g_achievement_inside_ui:IsVisible()) then
      -- XAchievement_InsideIsOpen(1)
    else
      -- XAchievement_InsideIsOpen(0)
    end
end