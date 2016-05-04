include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


--英雄总览、英雄装扮



function InitGame_HeroUI(wnd, bisopen)
	g_game_hero_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainGame_Hero(g_game_hero_ui)
	g_game_hero_ui:SetVisible(bisopen)
end

function InitMainGame_Hero(wnd)
	--------初始化子界面
	InitGame_HeroSkinUI(g_game_hero_ui, 0)
	InitGame_HeroAllUI(g_game_hero_ui, 0)
	InitGame_HeroDetailUI(g_game_hero_ui, 0)
end

function SetGameHeroIsVisible(flag) 
	if g_game_hero_ui ~= nil then
		if flag == 1 and g_game_hero_ui:IsVisible() == false then
			g_game_hero_ui:SetVisible(1)

			XGameHeroCardIsOpen(1)
			SetGameHeroDetailIsVisible(0)
			SetGameHeroSkinIsVisible(0)
		elseif flag == 0 and g_game_hero_ui:IsVisible() == true then
			g_game_hero_ui:SetVisible(0)
		end
	end
end

function GetGameHeroIsVisible()  
    if g_game_hero_ui~=nil and g_game_hero_ui:IsVisible()==true then
        return 1
    else
		return 0
    end
end