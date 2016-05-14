include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

----selectarenamode界面
local btn_close = nil
local btn_Enter = {}

local room_number = {}
local room_name = {}
local room_password = {}
local room_mapid = {}
local room_mode = {}
local room_people ={}

local btn_showall = nil
local btn_wait = nil
local btn_refresh = nil
local btn_find = nil
local btn_create = nil

local middle = nil	-- 中间的页数

---------通信处理
local RoomInfo = {}
RoomInfo.name = {}
RoomInfo.password = {}
RoomInfo.mapid = {}
RoomInfo.mode = {}
RoomInfo.people = {}
RoomInfo.roomid = {}

function InitRoomList_ui(wnd,bisopen)
	n_roomlist_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMain_RoomList(n_roomlist_ui)
	n_roomlist_ui:SetVisible(bisopen)
end

function InitMain_RoomList(wnd)
	local BBK = wnd:AddImage(path_shop.."BK_shop.png",0,0,1280,800)
	btn_close = BBK:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",1235,10,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		---关闭界面
		XClickRoomListIndex(0)
	end
	local head = BBK:AddImage(path_mode.."roomlisthead_mode.png",484, 0, 312, 62)
	head:AddFont("房间列表", 18, 8, 0, 0, 312, 56, 0xffffff)
	BBK:AddImage(path_mode.."roomlist_mode.png",65, 74, 1078, 623)
	
	for i=1,12 do		
		room_password[i] = BBK:AddImage(path_setup.."lock_setup.png",516,56+50*i,32,32)
		
		btn_Enter[i] = BBK:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",1166,54+50*i,83,35)
		btn_Enter[i]:AddFont("进入", 15, 8, 0, 0, 83, 35, 0x95f9fd)
		btn_Enter[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			------加入房间
			XClickRoomListEnter(i-1,RoomInfo.roomid[i])
			ClearRoomChat()
		end
	end
	------显示全部
	btn_showall = BBK:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",69,720,83,35)
	btn_showall:AddFont("显示全部", 15, 8, 0, 0, 83, 35, 0xffffff)
	btn_showall:SetEnabled(0)
	btn_showall.script[XE_LBUP] = function()
		XClickPlaySound(5)
		------全部房间
		XClickRoomListIndex(2)
	end
	------显示等待
	btn_wait = BBK:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",164,720,83,35)
	btn_wait:AddFont("显示等待", 15, 8, 0, 0, 83, 35, 0xffffff)
	btn_wait:SetEnabled(0)
	btn_wait.script[XE_LBUP] = function()
		XClickPlaySound(5)
		------等待房间
		XClickRoomListIndex(3)
	end
	------刷新列表
	btn_refresh = BBK:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",259,720,83,35)
	btn_refresh:AddFont("刷新列表", 15, 8, 0, 0, 83, 35, 0xffffff)
	btn_refresh.script[XE_LBUP] = function()
		XClickPlaySound(5)
		------刷新房间
		XClickRoomListIndex(4)
	end
	------查找房间
	btn_find = BBK:AddButton(path_setup.."buy1_setup.png", path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",354,720,83,35)
	btn_find:AddFont("查找房间", 15, 8, 0, 0, 83, 35, 0xffffff)
	btn_find.script[XE_LBUP] = function()
		XClickPlaySound(5)
		------查找房间
		XClickRoomListIndex(5)
	end
	------创建房间
	btn_create = BBK:AddButton(path_start.."readyEnter1_start.png",path_start.."readyEnter2_start.png",path_start.."readyEnter3_start.png",972,718,179,56)
	btn_create:AddFont("创建房间", 18, 8, 0, 0, 179, 56, 0xffffff)
	btn_create.script[XE_LBUP] = function()
		XClickPlaySound(5)
		------创建房间
		XClickRoomListIndex(1)
		ClearRoomChat()
	end
	
	for i=1,12 do
		room_number[i] = BBK:AddFont(i, 15, 0, 115, 63+50*i, 200, 20, 0xffffff)
		room_name[i] = BBK:AddFont("名字"..i, 15, 0, 280, 63+50*i, 200, 20, 0xffffff)
		room_mapid[i] = BBK:AddFont("地图号"..i, 15, 0, 690, 63+50*i, 200, 20, 0xffffff)
		room_mode[i] = BBK:AddFont("房间模式"..i, 15, 0, 910, 63+50*i, 200, 20, 0xffffff)
		room_people[i] = BBK:AddFont("房间人数"..i, 15, 0, 1060,63+50*i, 200, 20, 0xffffff)
	end
	
	--左右翻页
	local left = BBK:AddButton(path_mode.."roomlistpage1_mode.png",path_mode.."roomlistpage2_mode.png",path_mode.."roomlistpage1_mode.png", 550, 720, 70, 30)
	left:AddFont("上一页", 15, 8, 0, 0, 70, 30, 0xffffffff)
	local right = BBK:AddButton(path_mode.."roomlistpage1_mode.png",path_mode.."roomlistpage2_mode.png",path_mode.."roomlistpage1_mode.png", 700, 720, 70, 30)
	right:AddFont("下一页", 15, 8, 0, 0, 70, 30, 0xffffffff)
	local AAAA = BBK:AddImage(path_mode.."roomlistpage1_mode.png", 625, 720, 70, 30)
	middle = AAAA:AddFont("1/1", 15, 8, 0, 0, 70, 30, 0xffffffff)
	
	left.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		--上一页
		XClickRoomListIndex(6)
	end
	
	right.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		--下一页
		XClickRoomListIndex(7)
	end
end


----------通信房间列表
function Clear_RoomList()
	RoomInfo = {}
	RoomInfo.name = {}
	RoomInfo.password = {}
	RoomInfo.mapid = {}
	RoomInfo.mode = {}
	RoomInfo.people = {}
	RoomInfo.roomid = {}

	for i,v in pairs(room_number) do
		room_number[i]:SetVisible(0)
		room_name[i]:SetVisible(0)
		room_password[i]:SetVisible(0)
		room_mapid[i]:SetVisible(0)
		room_mode[i]:SetVisible(0)
		room_people[i]:SetVisible(0)
		btn_Enter[i]:SetVisible(0)
	end
end
function SendData_RoomList(name,mapid,mode,currentPeople,maxPeople,password,id)
	local size = #RoomInfo.name+1
	RoomInfo.name[size] = name
	RoomInfo.password[size] = password
	RoomInfo.mapid[size] = mapid
	RoomInfo.mode[size] = mode
	RoomInfo.people[size] = currentPeople.."/"..maxPeople
	RoomInfo.roomid[size] = id
	
	room_number[size]:SetFontText(id,0xffffff)
	room_name[size]:SetFontText(name,0xffffff)
	room_mapid[size]:SetFontText(mapid,0xffffff)
	room_mode[size]:SetFontText(mode,0xffffff)
	room_people[size]:SetFontText(RoomInfo.people[size],0xffffff)
	
	room_number[size]:SetVisible(1)
	room_name[size]:SetVisible(1)
	room_mapid[size]:SetVisible(1)
	room_mode[size]:SetVisible(1)
	room_people[size]:SetVisible(1)
	btn_Enter[size]:SetVisible(1)
	
	if password>0 then
		room_password[size]:SetVisible(1)
	else
		room_password[size]:SetVisible(0)
	end	
end

-- 左右翻页页数
function PageOf_RoomList(page)
	middle:SetFontText(page,0xffffffff)
end

-- 是否显示
function SetRoomListIsVisible(flag) 
	if n_roomlist_ui ~= nil then
		if flag == 1 and n_roomlist_ui:IsVisible() == false then
			n_roomlist_ui:CreateResource()
			n_roomlist_ui:SetVisible(1)
		elseif flag == 0 and n_roomlist_ui:IsVisible() == true then
			n_roomlist_ui:DeleteResource()
			n_roomlist_ui:SetVisible(0)
		end
	end
end

function GetRoomListIsVisible()  
    if n_roomlist_ui ~=nil and n_roomlist_ui:IsVisible()==true then
       return 1
    else
       return 0
    end
end