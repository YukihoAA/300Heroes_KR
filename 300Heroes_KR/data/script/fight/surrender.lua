include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local Green_Surrender = {}
local Yes_Surrender = nil
local No_Surrender = nil
local Surrender_Response = {path_fight_soulchange.."surrender_green.png",path_fight_soulchange.."surrender_red.png"}

function InitSurrender_ui(wnd,bisopen)
	n_surrender_ui = CreateWindow(wnd.id, 1920-316, 1080-475, 316, 175)
	InitMain_Surrender(n_surrender_ui)
	n_surrender_ui:SetVisible(bisopen)
end

function InitMain_Surrender(wnd)
	local SurrenderBK = wnd:AddImage(path_fight_soulchange.."surrender_BK.png",0,0,316,175)
	SurrenderBK:AddImage(path_fight_soulchange.."surrender_n.png",52,55,218,40)
	
	for i=1,7 do
		local posx= 31*i+21
		local posy= 55
		Green_Surrender[i] = SurrenderBK:AddImage(Surrender_Response[1],posx,posy,30,38)
	end
	Yes_Surrender = SurrenderBK:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",47,122,90,40)
	Yes_Surrender:AddFont("蛮己",15,0,25,10,100,15,0xbeb5ee)
	No_Surrender = SurrenderBK:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",185,122,90,40)
	No_Surrender:AddFont("馆措",15,0,25,10,100,15,0xbeb5ee)
	
	Yes_Surrender.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickSurrenderResponse(1)
	end
	No_Surrender.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickSurrenderResponse(0)
	end
	SurrenderBK:AddFont("亲汗力狼",15,0,125,25,100,15,0xbeb5ee)--,"bdzy")
end

-------投降信息通信
function SetSurrenderBtnIsVisible(flag)
	Yes_Surrender:SetVisible(flag)
	No_Surrender:SetVisible(flag)
end
function Clear_SurrenderData()
	for i,v in pairs(Green_Surrender) do
		Green_Surrender[i]:SetVisible(0)
	end
end
function SendData_Surrender(index,YesOrNo)

	if index >=1 and index <=7 then
		if YesOrNo == 1 then
			Green_Surrender[index].changeimage(Surrender_Response[1])
		else
			Green_Surrender[index].changeimage(Surrender_Response[2])
		end
		Green_Surrender[index]:SetVisible(1)
	end
end

-- 设置显示
function SetSurrenderIsVisible(flag) 
	if n_surrender_ui ~= nil then
		if flag == 1 and n_surrender_ui:IsVisible() == false then
			n_surrender_ui:CreateResource()
			n_surrender_ui:SetVisible(1)
		elseif flag == 0 and n_surrender_ui:IsVisible() == true then
			n_surrender_ui:DeleteResource()
			n_surrender_ui:SetVisible(0)
		end
	end
end

function GetSurrenderIsVisible()  
    if(n_surrender_ui ~= nil and n_surrender_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end