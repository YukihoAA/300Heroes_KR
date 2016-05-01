include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

----selectarenamode界面
local RoomNameEdit,RoomNameInput = nil
local RoomPasswordEdit,RoomPasswordInput = nil
------选择模式
local btn_mode = nil
local Font_mode = nil
local mode_BK = nil
local BTN_modeBK = {}
local BTN_modeFont = {"1v1","2v2","3v3","4v4","5v5"}
local index_mode = 0

------选择地图
local btn_map = nil
local Font_map = nil
local map_BK = nil
local BTN_mapBK = {}
local BTN_mapFont = {"永恒竞技场","永恒战场","天梯排位赛"}
local index_map = 0

--输入密码
local index_check = 0
local check_password, passwordBK = nil
local btn_cancel = nil
local btn_create = nil
local MapId = {254,252,256}
local Mode = {1,2,3,4,5}

function InitRoomSet_ui(wnd,bisopen)
	n_roomset_ui = CreateWindow(wnd.id, (1280-402)/2, (800-280)/2, 402, 280)
	n_roomset_ui:EnableBlackBackgroundTop(1)
	InitMain_RoomSet(n_roomset_ui)
	n_roomset_ui:SetVisible(bisopen)
end

function InitMain_RoomSet(wnd)
	wnd:AddImage(path_hero.."message_hero.png",0,0,402,280)
	wnd:AddImage(path_mode.."roomsetfont_mode.png",0,0,402,37)
		
	btn_cancel = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",35,220,90,40)	
	btn_create = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",277,220,90,40)
	
	btn_cancel.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickRoomSetIndex(0,0,0,0,"","")
	end
	btn_create.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickRoomSetIndex(1,index_check,MapId[index_map],Mode[index_mode],RoomNameInput:GetEdit(),RoomPasswordInput:GetEdit())
	end
		
	wnd:AddFont("输入房间名", 15, 0, 42, 55, 315, 50, 0xbeb9cf)
	wnd:AddFont("选择模式", 15, 0, 55, 98, 315, 50, 0xbeb9cf)
	wnd:AddFont("选择地图", 15, 0, 55, 141, 315, 50, 0xbeb9cf)
	wnd:AddFont("输入密码", 15, 0, 55, 184, 315, 50, 0xbeb9cf)
	
	wnd:AddFont("取消",15,0,60,230,90,42,0xffffff)
	wnd:AddFont("创建",15,0,302,230,90,42,0xffffff)
	
	---房间名
	RoomNameEdit = CreateWindow(wnd.id, 135, 50, 212, 36)
	RoomNameInput = RoomNameEdit:AddEdit(path_mode.."roomset_mode.png","","","",15,5,10,212,36,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(RoomNameInput.id,15)
	---房间密码
	RoomPasswordEdit = CreateWindow(wnd.id, 135,179, 212, 36)
	RoomPasswordInput = RoomPasswordEdit:AddEdit(path_mode.."roomset_mode.png","","","",15,5,10,212,36,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(RoomPasswordInput.id,15)
	XEditInclude(RoomPasswordInput.id,"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz`1234567890-=;',./~!@#$%^&*()_+{}|:<>?[]\\")
	-----选择地图
	btn_map = wnd:AddTwoButton(path_mode.."roomsetdown_mode.png", path_mode.."roomsetup_mode.png", path_mode.."roomsetdown_mode.png",135,136,212,36)
	Font_map = btn_map:AddFont(BTN_mapFont[1],15,0,10,7,100,15,0xbeb5ee)
	
	map_BK = wnd:AddImage(path_mode.."roomsetbk_mode.png",135,172,212,151)
	map_BK:SetVisible(0)
	
	for dis = 1,3 do
		BTN_mapBK[dis] = wnd:AddImage(path_mode.."roomsethover_mode.png",135,137+dis*36,212,36)
		map_BK:AddFont(BTN_mapFont[dis],15,0,10,dis*36-27,128,32,0xbeb5ee)
		BTN_mapBK[dis]:SetTransparent(0)
		BTN_mapBK[dis]:SetTouchEnabled(0)
		
		-----------鼠标滑过
		BTN_mapBK[dis].script[XE_ONHOVER] = function()
			if map_BK:IsVisible() == true then
				BTN_mapBK[dis]:SetTransparent(1)
			end
		end
		BTN_mapBK[dis].script[XE_ONUNHOVER] = function()
			if map_BK:IsVisible() == true then
				BTN_mapBK[dis]:SetTransparent(0)
			end
		end
		
		BTN_mapBK[dis].script[XE_LBUP] = function()
			Font_map:SetFontText(BTN_mapFont[dis],0xbeb5ee)
			index_map = dis
						
			btn_map:SetButtonFrame(0)
			map_BK:SetVisible(0)
			for index,value in pairs(BTN_mapBK) do
				BTN_mapBK[index]:SetTransparent(0)
				BTN_mapBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	btn_map.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if map_BK:IsVisible() then
			map_BK:SetVisible(0)
			for index,value in pairs(BTN_mapBK) do
				BTN_mapBK[index]:SetTransparent(0)
				BTN_mapBK[index]:SetTouchEnabled(0)
			end
		else
			map_BK:SetVisible(1)
			for index,value in pairs(BTN_mapBK) do
				BTN_mapBK[index]:SetTransparent(0)
				BTN_mapBK[index]:SetTouchEnabled(1)
			end
		end
	end
	
	-----选择模式
	btn_mode = wnd:AddTwoButton(path_mode.."roomsetdown_mode.png", path_mode.."roomsetup_mode.png", path_mode.."roomsetdown_mode.png",135,93,212,36)
	Font_mode = btn_mode:AddFont(BTN_modeFont[1],15,0,10,7,100,15,0xbeb5ee)
	
	mode_BK = wnd:AddImage(path_mode.."roomsetbk_mode.png",135,129,212,200)
	mode_BK:SetVisible(0)
	
	for dis = 1,5 do
		BTN_modeBK[dis] = wnd:AddImage(path_mode.."roomsethover_mode.png",135,94+dis*36,212,36)
		mode_BK:AddFont(BTN_modeFont[dis],15,0,10,dis*36-27,128,32,0xbeb5ee)
		BTN_modeBK[dis]:SetTransparent(0)
		BTN_modeBK[dis]:SetTouchEnabled(0)
		
		-----------鼠标滑过
		BTN_modeBK[dis].script[XE_ONHOVER] = function()
			if mode_BK:IsVisible() == true then
				BTN_modeBK[dis]:SetTransparent(1)
			end
		end
		BTN_modeBK[dis].script[XE_ONUNHOVER] = function()
			if mode_BK:IsVisible() == true then
				BTN_modeBK[dis]:SetTransparent(0)
			end
		end
		
		BTN_modeBK[dis].script[XE_LBUP] = function()
			Font_mode:SetFontText(BTN_modeFont[dis],0xbeb5ee)
			index_mode = dis
						
			btn_mode:SetButtonFrame(0)
			mode_BK:SetVisible(0)
			for index,value in pairs(BTN_modeBK) do
				BTN_modeBK[index]:SetTransparent(0)
				BTN_modeBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	btn_mode.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if mode_BK:IsVisible() then
			mode_BK:SetVisible(0)
			for index,value in pairs(BTN_modeBK) do
				BTN_modeBK[index]:SetTransparent(0)
				BTN_modeBK[index]:SetTouchEnabled(0)
			end
		else
			mode_BK:SetVisible(1)
			for index,value in pairs(BTN_modeBK) do
				BTN_modeBK[index]:SetTransparent(0)
				BTN_modeBK[index]:SetTouchEnabled(1)
			end
		end
	end
	--输入密码
	passwordBK = wnd:AddImage(path_task.."taskcheck_sign.png",30,185,21,21)
	passwordBK:SetTouchEnabled(1)
	check_password = passwordBK:AddImage(path_task.."taskcheckyes_sign.png",0,0,21,21)
	check_password:SetTouchEnabled(0)
	check_password:SetVisible(0)
	passwordBK.script[XE_LBUP] = function()
		if (check_password:IsVisible()) then
			check_password:SetVisible(0)
			index_check = 0
		else
			check_password:SetVisible(1)
			index_check = 1
		end
	end
end

----通信
function Clear_RoomSet()
	index_check = 0
	check_password:SetVisible(0)
	RoomNameInput:SetEdit("")
	RoomPasswordInput:SetEdit("")

	index_map = 1
	btn_map:SetButtonFrame(0)
	map_BK:SetVisible(0)
	Font_map:SetFontText(BTN_mapFont[1],0xbeb5ee)
	
	index_mode = 1
	btn_mode:SetButtonFrame(0)
	mode_BK:SetVisible(0)
	Font_mode:SetFontText(BTN_modeFont[1],0xbeb5ee)
end
----房间名字
function RoomName_Set(name)
	RoomNameInput:SetEdit(name)
end












function SetRoomSetIsVisible(flag) 
	if n_roomset_ui ~= nil then
		if flag == 1 and n_roomset_ui:IsVisible() == false then
			n_roomset_ui:CreateResource()
			Clear_RoomSet()
			n_roomset_ui:SetVisible(1)
		elseif flag == 0 and n_roomset_ui:IsVisible() == true then
			n_roomset_ui:DeleteResource()
			n_roomset_ui:SetVisible(0)
		end
	end
end

function GetRoomSetIsVisible()  
    if n_roomset_ui~=nil and n_roomset_ui:IsVisible()==true then
       return 1
    else
       return 0
    end
end