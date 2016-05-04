include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--新手引导选择第一个英雄界面
local SelectHero = {}
local btn_confirm = nil
local SelectHeroPath = {path_hero.."FirstHero1.png",path_hero.."FirstHero2.png",path_hero.."FirstHero3.png",path_hero.."FirstHero4.png",path_hero.."FirstHero5.png"}
local SelectHeroIndex = 3
local SelectHeroClick = nil

function InitSelectFirstHero_ui(wnd,bisopen)
	n_selectfirsthero_ui = CreateWindow(wnd.id, (1920-1106)/2, (1080-392)/2, 1106, 392)
	InitMain_SelectFirstHero(n_selectfirsthero_ui)
	n_selectfirsthero_ui:SetVisible(bisopen)
end

function InitMain_SelectFirstHero(wnd)
	wnd:AddImage(path_hero.."FirstHeroBK.png",-2,-2,1110,396)
	
	for i=1,5 do
		local posx = 214*i-188
		local posy = 41
		SelectHero[i] = wnd:AddImage(SelectHeroPath[i],posx,posy,191,292)
				
		SelectHero[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			SelectHeroIndex = i
			local L,T = SelectHero[i]:GetPosition()
			SelectHeroClick:SetAbsolutePosition(L-12,T-12)
			btn_confirm:SetAbsolutePosition(L+41,T+303)
		end
	end
	SelectHeroClick = wnd:AddImage(path_hero.."FirstHeroClick.png",442,29,215,316)
	
	btn_confirm = wnd:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",495,344,100,32)
	btn_confirm:AddFont("确认出战",12, 8, 0, 0, 100, 32, 0xffffff)
	
	btn_confirm.script[XE_LBUP] = function()
		XClickPlaySound(5)
		local iHeroID ={96,76,53,101,55}
		XClickConfirmHeroIndex(iHeroID[SelectHeroIndex])
	end
end

--------通信
function GetSelectHeroInfo(index,tips)
	SelectHero[index]:SetImageTip(tips)
end


-- 设置显示
function SetSelectFirstHeroIsVisible(flag) 
	if n_selectfirsthero_ui ~= nil then
		if flag == 1 and n_selectfirsthero_ui:IsVisible() == false then
			n_selectfirsthero_ui:CreateResource()
			SelectHeroIndex = 3
			SelectHeroClick:SetPosition(442,29)
			btn_confirm:SetPosition(495,344)
			n_selectfirsthero_ui:SetVisible(1)
		elseif flag == 0 and n_selectfirsthero_ui:IsVisible() == true then
			n_selectfirsthero_ui:DeleteResource()
			n_selectfirsthero_ui:SetVisible(0)
		end
	end
end

function GetSelectFirstHeroIsVisible()  
    if(n_selectfirsthero_ui ~= nil and n_selectfirsthero_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end