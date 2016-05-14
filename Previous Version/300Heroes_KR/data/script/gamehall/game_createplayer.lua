include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 玩家召唤师头像
local player_pic = nil
local summoner_ui = nil
local summoner_bk = nil
local summoner_posx = {}
local summoner_posy = {}
local summoner_side = {}
local summoner_head = {}

local summoner_toggleBK = nil
local summoner_togglebtn = nil
local Many_SummonerHead = 0

-- 通信
local SummonerInfo = {}
SummonerInfo.pictureName = {}
SummonerInfo.Id = {}

local ChangeHead = nil
local ChooseButton = nil

local chatInputEdit = nil
local chatInput = nil
local chatInputText = nil
local ClickIndex = 1

-- 窗口滚动
local updownCount = 0
local maxUpdown = 0

function InitCreatePlayerUI(wnd, bisopen)
	g_CreatePlayer = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitCreatePlayer(g_CreatePlayer)
	g_CreatePlayer:SetVisible(bisopen)
end

function InitCreatePlayer(wnd)
    wnd:AddImage(path_shop.."BK_shop.png",0,0,1280,800)

	-- 玩家头像
	player_pic = wnd:AddImage(path_info.."headpic_info.png",520,250,130,130)
	player_pic:AddImage(path_info.."headside_info.png",-14,-14,158,158)
	
	-- 创建召唤师
	player_pic:AddImage(path_info.."creatFont_info.png",8,-54,119,29)
	player_pic:AddFont("荤柳函版", 15, 0, 165, 105, 200, 14, 0x615897)
	
	ChangeHead = player_pic:AddButton(path_info.."creatHead1_info.png",path_info.."creatHead2_info.png",path_info.."creatHead1_info.png",182,63,32,32)
	ChangeHead.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
	   ChangeHead:SetEnabled(0)
	   summoner_ui:SetVisible(1)
	end
	
	
	ChooseButton = player_pic:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",30,244,83,35)
	ChooseButton:AddFont("犬牢",15,8,8,-8,100,20,0xffffff)
	
	ChooseButton.script[XE_LBUP] = function()
		XClickPlaySound(5)
	    onChooseEnter()
	end
	
	-- 聊天输入栏
	chatInputEdit = CreateWindow(player_pic.id, -54,166, 262, 55)
	chatInput = chatInputEdit:AddEdit(path_info.."creatEdit_info.png","","onChooseEnter","",15,10,18,250,40,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(chatInput.id,14)	
	
	-- 召唤师头像界面
	summoner_ui = CreateWindow(player_pic.id, 238,-46,399,269)
	summoner_bk = summoner_ui:AddImage(path_fight_soulchange.."summoner_bk.png", 0, 0, 399, 269)
	
	for i=1,15 do
		summoner_posx[i] = 72*((i-1)%5)+10
		summoner_posy[i] = 72*math.ceil(i/5)-45
		
		summoner_head[i] = summoner_ui:AddImage(path_fight_soulchange.."sum_head.png", summoner_posx[i], summoner_posy[i], 66, 66)
		summoner_head[i]:SetTouchEnabled(0)
		summoner_side[i] = summoner_head[i]:AddButton(path_fight_soulchange.."sum_side.png",path_fight_soulchange.."sum_side_1.png",path_fight_soulchange.."sum_side.png", -4, -4, 74, 74)
		
		summoner_side[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			ClickIndex = i+updownCount*5
			player_pic.changeimage(SummonerInfo.pictureName[i+updownCount*5])	-- 时刻改变召唤师头像图片
			ChangeSummoner_head(SummonerInfo.pictureName[i+updownCount*5])
			Current_SummonerHeadNoXYWH(SummonerInfo.pictureName[i+updownCount*5])
		end
	end
	summoner_ui:SetVisible(0)
	
	-- 召唤师头像滚动条
	summoner_toggleBK = summoner_ui:AddImage(path.."toggleBK_main.png",375,40,16,185)
	summoner_togglebtn = summoner_toggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = summoner_toggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = summoner_toggleBK:AddImage(path.."TD1_main.png",0,185,16,16)
	
	XSetWindowFlag(summoner_togglebtn.id,1,1,0,135)
	
	summoner_togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)
	summoner_togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	summoner_togglebtn.script[XE_ONUPDATE] = function()
		if summoner_togglebtn._T == nil then
			summoner_togglebtn._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(summoner_togglebtn.id)
		if summoner_togglebtn._T ~= T then
			local length = 0
			if #SummonerInfo.pictureName <=15 then
				length = 135
			else
				length = 135/math.ceil((#SummonerInfo.pictureName/5)-3)
			end
			local Many = math.floor(T/length)
			updownCount = Many	
			
			if Many_SummonerHead ~= Many then
				for i = 1, #summoner_head do
					summoner_head[i]:SetVisible(0)
				end
				
				for i=updownCount*5+1, #SummonerInfo.pictureName do
					if i>updownCount*5 and i<updownCount*5+16 then
						summoner_head[i-updownCount*5].changeimage(SummonerInfo.pictureName[i])
						summoner_head[i-updownCount*5]:SetVisible(1)
					end
				end
				Many_SummonerHead = Many
			end		
			summoner_togglebtn._T = T
		end
	end
	
	XWindowEnableAlphaTouch(g_CreatePlayer.id)
	g_CreatePlayer:EnableEvent(XE_MOUSEWHEEL)
	g_CreatePlayer.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		local length = 0
		
		if #SummonerInfo.pictureName >15 then
			maxUpdown = math.ceil((#SummonerInfo.pictureName/5)-3)
			length = 135/maxUpdown
		else
			maxUpdown = 0
			length = 135
		end
		if updown>0 then
			updownCount = updownCount-1
			if updownCount<0 then
				updownCount=0
			end
		else
			updownCount = updownCount+1
			if updownCount>maxUpdown then
				updownCount=maxUpdown
			end
		end			
		btn_pos = length*updownCount
		
		summoner_togglebtn:SetPosition(0,btn_pos)
		summoner_togglebtn._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			for i = 1, #summoner_head do
				summoner_head[i]:SetVisible(0)
			end
			
			for i=updownCount*5+1, #SummonerInfo.pictureName do
				if i>updownCount*5 and i<updownCount*5+16 then
					summoner_head[i-updownCount*5].changeimage(SummonerInfo.pictureName[i])
					summoner_head[i-updownCount*5]:SetVisible(1)
				end
			end
		end
	end
end

function onChooseEnter()
	XCreatePlayerButttonClickUp(chatInput:GetEdit(),ClickIndex-1)
end

function SetFirst_CreatPlayerHead(pic)
	player_pic.changeimage("..\\"..pic)	-- 时刻改变召唤师头像图片
end

-- 创建角色 通信召唤师头像
function Clear_CreatPlayerSummonerHead()
	SummonerInfo = {}
	SummonerInfo.pictureName = {}	
	SummonerInfo.Id = {}
	chatInput:SetEdit("")
	ClickIndex = 1
	for i,v in pairs(summoner_head) do
		summoner_head[i]:SetVisible(0)
	end
end

function Receive_CreatPlayerSummonerHead(pictureName,id)
	local index = #SummonerInfo.pictureName+1
	
	SummonerInfo.pictureName[index] = "..\\"..pictureName
	SummonerInfo.Id[index] = id
end

function Refresh_CreatPlayerSummonerHead()
	-- 滚动条恢复
	summoner_ui:SetVisible(0)
	ChangeHead:SetEnabled(1)
	updownCount = 0
	maxUpdown = 0
	summoner_togglebtn:SetPosition(0,0)
	summoner_togglebtn._T = 0
	
	for i,value in pairs(summoner_head) do
		summoner_head[i].changeimage( SummonerInfo.pictureName[i])
		summoner_head[i]:SetVisible(1)
	end
	
	if #SummonerInfo.pictureName > 15 then
		summoner_toggleBK:SetVisible(1)
	else
		summoner_toggleBK:SetVisible(0)
	end
end

function SetCreatePlayerIsVisible(flag) 
	if g_CreatePlayer ~= nil then
		if flag == 1 and g_CreatePlayer:IsVisible() == false then
			g_CreatePlayer:CreateResource()
			g_CreatePlayer:SetVisible(1)
		elseif flag == 0 and g_CreatePlayer:IsVisible() == true then
			g_CreatePlayer:DeleteResource()
			g_CreatePlayer:SetVisible(0)
		end
	end
end