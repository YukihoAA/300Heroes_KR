include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local Loading = nil
function InitLoading_ui(wnd,bisopen)
	-- log("\nInitLoading_ui1   ")
	n_loading_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	-- log("\nInitLoading_ui2   ")
	InitMain_Loading(n_loading_ui)
	n_loading_ui:SetVisible(bisopen)
end

function InitMain_Loading(wnd)
	Loading = wnd:AddImage(path_hero.."ffffff_hero.png",0,0,1280,800)
	wnd:AddImage(path_hero.."kuangL_hero.png", 0, 22, 10, 756)
	wnd:AddImage(path_hero.."kuangR_hero.png", 1270, 22, 10, 756)
	wnd:AddImage(path_hero.."kuangT_hero.png", 0, 0, 1280, 22)
	wnd:AddImage(path_hero.."kuangB_hero.png", 0, 778, 1280, 22)
end

-------通信
function SetLoadingTexture(strName)
--log("Loading = "..strName)
	Loading.changeimage("..\\"..strName)
end
-----------设置进入游戏的加载图片显示
function SetLoadingIsVisible(flag) 
	if n_loading_ui ~= nil then
		if flag == 1 and n_loading_ui:IsVisible() == false then
			n_loading_ui:CreateResource()
			n_loading_ui:SetVisible(1)
		elseif flag == 0 and n_loading_ui:IsVisible() == true then
			n_loading_ui:DeleteResource()
			n_loading_ui:SetVisible(0)
		end
	end
end
