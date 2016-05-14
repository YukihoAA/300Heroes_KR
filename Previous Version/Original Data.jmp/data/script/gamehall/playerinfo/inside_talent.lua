include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 选人界面 天赋专精修改
function InitTalent_InsideUI(wnd, bisopen)
	g_talent_inside_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainTalent_Inside(g_talent_inside_ui)
	g_talent_inside_ui:SetVisible(bisopen)
end

function InitMainTalent_Inside(wnd)
	wnd:AddImage(path_shop.."BK_shop.png",0,0,1280,800)
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",1150,60,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		SetTalent_InsideIsVisible(0)		
		SetGameStartIsVisible(1)
	end
end

function SetTalent_InsideIsVisible(flag) 
	if g_talent_inside_ui ~= nil then
		if flag == 1 and g_talent_inside_ui:IsVisible() == false then
			g_talent_inside_ui:SetVisible(1)
			SetGameStartIsVisible(0)
			XIsOpenTatle()

			SetFourpartUIVisiable(0)
		elseif flag == 0 and g_talent_inside_ui:IsVisible() == true then
			g_talent_inside_ui:SetVisible(0)
			SetGameHeroTalentIsVisible(0)		
		end
	end
end

function GetTalent_InsideIsVisible()  
    if(g_talent_inside_ui:IsVisible()) then
      -- XTalent_InsideIsOpen(1)
    else
      -- XTalent_InsideIsOpen(0)
    end
end