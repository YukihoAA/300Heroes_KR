include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


local posx_move = -240
local posy_move = -150

function InitSetup_ImpeachUI(wnd, bisopen)
	g_setup_impeach_ui = CreateWindow(wnd.id, (1920-1920)/2, (1080-1080)/2, 1920, 1080)
	InitMainSetup_Impeach(g_setup_impeach_ui)
	g_setup_impeach_ui:SetVisible(bisopen)
end
function InitMainSetup_Impeach(wnd)
	
	wnd:AddImage(path_setup.."BK_setup.png",0,0,793,486)
	
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",985+posx_move,160+posy_move,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupIsVisible(0)
	end
	local btn_back = wnd:AddButton(path_setup.."back1_setup.png",path_setup.."back2_setup.png",path_setup.."back3_setup.png",290+posx_move,560+posy_move,164,49)
	btn_back:AddFont("返回设置",15, 0, 50, 14, 100, 20, 0xffffff)
	btn_back.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupImpeachIsVisible(0)
		--Set_SetupIsVisible(1)
	end
	local btn_apply = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",645+posx_move,560+posy_move,164,49)
	btn_apply:AddFont("确认",15, 0, 65, 15, 100, 20, 0xffffff)
	btn_apply.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupImpeachIsVisible(0)
		--Set_SetupIsVisible(1)
	end
	local btn_cancel = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",815+posx_move,560+posy_move,164,49)
	btn_cancel:AddFont("取消",15, 0, 65, 15, 100, 20, 0xffffff)
	btn_cancel.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupImpeachIsVisible(0)
		--Set_SetupIsVisible(1)
	end
end

function Set_SetupImpeachIsVisible(flag) 
	if g_setup_impeach_ui ~= nil then
		if flag == 1 and g_setup_impeach_ui:IsVisible() == false then
			g_setup_impeach_ui:SetVisible(1)
		elseif flag == 0 and g_setup_impeach_ui:IsVisible() == true then
			g_setup_impeach_ui:SetVisible(0)
		end
	end
end

function Get_SetupImpeachIsVisible()  
    if(g_setup_impeach_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end