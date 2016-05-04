include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local posx_move = -240
local posy_move = -150

function InitSetup_QuitUI(wnd, bisopen)
	g_setup_quit_ui = CreateWindow(wnd.id, (1920-1920)/2, (1080-1080)/2, 1920, 1080)
	InitMainSetup_Quit(g_setup_quit_ui)
	g_setup_quit_ui:SetVisible(bisopen)
end
function InitMainSetup_Quit(wnd)
	
	wnd:AddImage(path_setup.."BK_setup.png",0,0,793,486)
	wnd:AddImage(path_setup.."quitfont_setup.png",592+posx_move,162+posy_move,128,32)
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",985+posx_move,160+posy_move,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupIsVisible(0)
	end
	local btn_back = wnd:AddButton(path_setup.."back1_setup.png",path_setup.."back2_setup.png",path_setup.."back3_setup.png",535+posx_move,560+posy_move,164,49)
	btn_back:AddFont("返回游戏",15, 0, 50, 14, 100, 20, 0xffffff)
	btn_back.script[XE_LBUP] = function()
		XClickPlaySound(5)
				
		Set_SetupQuitIsVisible(0)
	end
	local btn_quit = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",820+posx_move,560+posy_move,164,49)
	btn_quit:AddFont("退出游戏",15, 0, 50, 15, 100, 20, 0xffffff)
	btn_quit.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XGameCloseWindow(1)
	end
end

function Set_SetupQuitIsVisible(flag) 
	if g_setup_quit_ui ~= nil then
		if flag == 1 and g_setup_quit_ui:IsVisible() == false then
			g_setup_quit_ui:SetVisible(1)
		elseif flag == 0 and g_setup_quit_ui:IsVisible() == true then
			g_setup_quit_ui:SetVisible(0)
		end
	end
end

function Get_SetupQuitIsVisible()  
    if(g_setup_quit_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end