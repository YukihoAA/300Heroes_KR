include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

----selectarenamode界面
local Back = nil
local btn_ok,btn_cancel = nil
local message = nil
local PasswordInputEdit,PasswordInput = nil


function InitRoomPassword_ui(wnd,bisopen)
	n_roompassword_ui = CreateWindow(wnd.id, (1280-400)/2, (800-340)/2, 400, 340)
	n_roompassword_ui:EnableBlackBackgroundTop(1)
	InitMain_RoomPassword(n_roompassword_ui)
	n_roompassword_ui:SetVisible(bisopen)
end

function InitMain_RoomPassword(wnd)
	Back = wnd:AddImage(path_hero.."inputbox_hero.png",0,0,400,340)
	
	btn_ok = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",58,270,90,40)	
	btn_ok:AddFont("确认",15,8,0,0,90,42,0xbeb5ee)
	btn_cancel = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",250,270,90,40)
	btn_cancel:AddFont("取消",15,8,0,0,90,42,0xbeb5ee)	
	
	btn_ok.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickRoomPasswordIndex(1, PasswordInput:GetEdit())
	end
	btn_cancel.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickRoomPasswordIndex(0, PasswordInput:GetEdit())
	end	
	message = wnd:AddFont("请输入房间密码", 15, 8, -30, 0, 340, 120, 0x8177d0)
	message:SetFontSpace(2,2)	
	-- ----名字修改
	PasswordInputEdit = CreateWindow(wnd.id, 57,130,330,40)
	PasswordInput = PasswordInputEdit:AddEdit(path_login.."passwordEdit_login.png","","onNameInputEnter","",20,0,0,290,30,0xffffffff,0xff000000,0,"")
	PasswordInput:SetTransparent(0)
	XEditSetMaxByteLength(PasswordInput.id,3)
	XEditInclude(PasswordInput.id,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`1234567890-=;',./~!@#$%^&*()_+{}|:<>?[]\\")
end



-- 是否显示
function SetRoomPasswordIsVisible(flag) 
	if n_roompassword_ui ~= nil then
		if flag == 1 and n_roompassword_ui:IsVisible() == false then
			n_roompassword_ui:CreateResource()
			PasswordInput:SetEdit("")
			PasswordInput:SetFocus(1)
			n_roompassword_ui:SetVisible(1)			
		elseif flag == 0 and n_roompassword_ui:IsVisible() == true then
			n_roompassword_ui:DeleteResource()
			n_roompassword_ui:SetVisible(0)
		end
	end
end

function GetRoomPasswordIsVisible()  
    if(n_roompassword_ui ~= nil and n_roompassword_ui:IsVisible()) then
       return 1
    else
       return 0
    end
end