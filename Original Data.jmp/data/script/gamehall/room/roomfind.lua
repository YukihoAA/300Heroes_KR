include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

----selectarenamode界面
local Back = nil
local btn_ok,btn_cancel = nil
local message = nil
local NameInputEdit,NameInput = nil


function InitRoomFind_ui(wnd,bisopen)
	n_roomfind_ui = CreateWindow(wnd.id, (1280-400)/2, (800-340)/2, 400, 340)
	n_roomfind_ui:EnableBlackBackgroundTop(1)
	InitMain_RoomFind(n_roomfind_ui)
	n_roomfind_ui:SetVisible(bisopen)
end

function InitMain_RoomFind(wnd)
	Back = wnd:AddImage(path_hero.."inputbox_hero.png",0,0,400,340)
	
	btn_ok = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",58,270,90,40)	
	btn_ok:AddFont("确认",15,8,0,0,90,42,0xbeb5ee)
	btn_cancel = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",250,270,90,40)
	btn_cancel:AddFont("取消",15,8,0,0,90,42,0xbeb5ee)	
	
	btn_ok.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickRoomFindIndex(1, NameInput:GetEdit())
	end
	btn_cancel.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickRoomFindIndex(0, NameInput:GetEdit())
	end	
	message = wnd:AddFont("请输入房间编号", 15, 8, -30, 0, 340, 120, 0x8177d0)
	message:SetFontSpace(2,2)	
	-- ----名字修改
	NameInputEdit = CreateWindow(wnd.id, 57,130,330,40)
	NameInput = NameInputEdit:AddEdit(path_login.."passwordEdit_login.png","","onNameInputEnter","",20,0,0,290,30,0xffffffff,0xff000000,0,"")
	NameInput:SetTransparent(0)
	XEditSetMaxByteLength(NameInput.id,3)
	XEditInclude(NameInput.id,"1234567890")
end



-- 是否显示
function SetRoomFindIsVisible(flag) 
	if n_roomfind_ui ~= nil then
		if flag == 1 and n_roomfind_ui:IsVisible() == false then
			n_roomfind_ui:CreateResource()
			NameInput:SetEdit("")
			NameInput:SetFocus(1)
			n_roomfind_ui:SetVisible(1)
		elseif flag == 0 and n_roomfind_ui:IsVisible() == true then
			n_roomfind_ui:DeleteResource()
			n_roomfind_ui:SetVisible(0)
		end
	end
end

function GetRoomFindIsVisible()  
    if( n_roomfind_ui ~= nil and n_roomfind_ui:IsVisible()) then
       return 1
    else
       return 0
    end
end