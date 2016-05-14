include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--------聊天界面

---聊天栏
local chatpart_ui = nil
local chatshow = {}
local chatImg = nil
local toggleImg = nil
local togglebtn = nil
local ToggleT = nil
local ToggleD = nil
local chatInput = nil

--聊天输入框
local chatInputEdit = nil


-----聊天方式
local btn_chat = nil
local chat_way = nil
local chat_BK = nil
local BTN_channel = {}
local BTN_channelHide = {}
local chat_channel = {"评盔","傈眉","模备","庇富","己唱迫","康盔唱迫"}
	
--------聊天消息界面按钮
local message_channel = {"盲泼","模备","庇富","傍瘤"}
local message_font = {}
local message_hall = nil
local message_friend = nil
local message_secret = nil
local message_system = nil
local message_click = nil
local message_clickFont = nil
local message_realchannel = {8,6,16,3,17,17}

local current_channel = nil

local updownCount = 0
local lastToggleBtnPos = 129
local maxlines = 12

local close_Btn = nil
local line = nil

function InitChatIn_UI(wnd, bisopen)
	n_chat_in_ui = CreateWindow(wnd.id, 0, 415, 470, 248)
	InitMain_ChatIn(n_chat_in_ui)
	n_chat_in_ui:SetVisible(bisopen)
	n_chat_in_ui:SetTouchEnabled(0)
end

function InitMain_ChatIn(wnd)
	--聊天栏
	chatpart_ui = CreateWindow(wnd.id, 0,0, 470, 248)
	chatImg = chatpart_ui:AddImage(path.."chatMessageBK_hall.png",-4,-4,470,248)
	close_Btn = chatImg:AddButton(path.."close1_hall.png",path.."close2_hall.png",path.."close3_hall.png",442,7,23,23)
	close_Btn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickChatInCloseBtn()
	end
	
	
	
	line = chatpart_ui:AddImage(path.."line_chat.png",0,26,462,1)
	chatshow[0] = chatpart_ui:AddChat(15,8,-4,-35,440,200,0xffbeb5ee)
	chatshow[1] = chatpart_ui:AddChat(15,8,-4,-35,440,200,0xffbeb5ee)
	chatshow[2] = chatpart_ui:AddChat(15,8,-4,-35,440,200,0xffbeb5ee)
	chatshow[3] = chatpart_ui:AddChat(15,8,-4,-35,440,200,0xffbeb5ee)
	
	--点击可点穿
	DisableRButtonClick(chatpart_ui.id)
	DisableRButtonClick(chatImg.id)
	DisableRButtonClick(chatshow[0].id)
	DisableRButtonClick(chatshow[1].id)
	DisableRButtonClick(chatshow[2].id)
	DisableRButtonClick(chatshow[3].id)
	
	for i = 1,3 do
		if chatshow[i] ~= nil then
			chatshow[i]:SetVisible(0)
		end
	end
	
	--滑动栏、滑动键
	toggleImg = chatpart_ui:AddImage(path.."toggleBK_main.png",442,43,16,179)
	togglebtn = toggleImg:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,lastToggleBtnPos,16,50)
	ToggleT = toggleImg:AddImage(path.."TD1_main.png",0,-16,16,16)
	ToggleD = toggleImg:AddImage(path.."TD1_main.png",0,179,16,16)
	
	XSetWindowFlag(togglebtn.id,1,1,0,lastToggleBtnPos)
	
	togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)	
	togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	
	togglebtn.script[XE_ONUPDATE] = function()
		if togglebtn._T == nil then
			togglebtn._T = 0
		end
		
		local L,T,R,B = XGetWindowClientPosition(togglebtn.id)
		if togglebtn._T ~= T then
			local id = GetChatInChatWnd()
			if id ~= 0 then
				local curLines = XGetChatLineNum(id)
				local delta = curLines - maxlines
				
				local length = 0
				if delta > 0 then
					length = lastToggleBtnPos / delta
					
					local line = math.floor(((lastToggleBtnPos-T)/length)+0.5)
					if line < 0 then
						line = 0
					elseif line > delta then
						line = delta
					end
					
					if line > updownCount then
						XScrollChat(id,0,line-updownCount)
					elseif line < updownCount then
						XScrollChat(id,1,updownCount-line)
					end
					
					updownCount = line
					
					if updownCount==0 then
						XSetChatAutoScroll(id,1)
					else
						XSetChatAutoScroll(id,0)
					end
				end
			end
			togglebtn._T = T
		end		
	end

	XWindowEnableAlphaTouch(chatpart_ui.id)
	chatpart_ui:EnableEvent(XE_MOUSEWHEEL)
	chatpart_ui.script[XE_MOUSEWHEEL] = function()
		local id = GetChatInChatWnd()
		if id ~= 0 then
			local curLines = XGetChatLineNum(id)
			local delta = curLines - maxlines
			
			local length = 0
			if delta > 0 then
				length = lastToggleBtnPos / delta
			else
				delta = 0
				length = 0
			end
			
			local updown  = XGetMsgParam0()
			if updown<0 then
				updownCount = updownCount-1
				if updownCount<0 then
					updownCount=0
				else
					XScrollChat(id,1,1)
				end
			else
				updownCount = updownCount+1
				if updownCount>delta then
					updownCount=delta
				else
					XScrollChat(id,0,1)
				end
			end
			
			if updownCount==0 then
				XSetChatAutoScroll(id,1)
			else
				XSetChatAutoScroll(id,0)
			end
			
			togglebtn:SetPosition(0,lastToggleBtnPos-length*updownCount)
			togglebtn._T = lastToggleBtnPos-length*updownCount
		end
	end
	
	--liaotianshurulan
	chatInputEdit = CreateWindow(wnd.id, -2,242,420,45)
	chatInput = chatInputEdit:AddEdit(path.."chatEdit_hall.png","","onChatInEnter","",15,10,10,410,35,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(chatInput.id,60)
	chatInput:SetDefaultFontText("郴侩阑 涝仿 饶 Enter肺 傈价", 0xff303b4a)

	--选择发送方式键--大厅、好友、密语、号角、战斗号角
		
	btn_chat = chatInputEdit:AddButton(path.."channelselect1_hall.png",path.."channelselect2_hall.png",path.."channelselect3_hall.png",426,2,39,42)
	chat_way = btn_chat:AddFont(chat_channel[1],12,8,0,0,39,42,0xffbeb5ee)
	chat_BK = btn_chat:AddImage(path.."chatBK_hall.png",0,-124,79,120)
	chat_BK:SetVisible(0)
	
	for dis = 1,6 do
		BTN_channel[dis] = chat_BK:AddImage(path.."chatchannel1_hall.png",1,dis*20-19,77,18)
		
		chat_BK:AddFont(chat_channel[dis],12,0,10,dis*20-20,128,32,0xffbeb5ee)
		BTN_channelHide[dis] = chat_BK:AddImage(path.."chatchannel2_hall.png",1,dis*20-19,77,18)
		BTN_channelHide[dis]:SetVisible(0)
		
		BTN_channel[dis]:SetTransparent(0)
		BTN_channel[dis]:SetTouchEnabled(0)
		
		-----------鼠标滑过
		BTN_channel[dis].script[XE_ONHOVER] = function()
			if chat_BK:IsVisible() == true then
				BTN_channel[dis]:SetTransparent(1)
			end
		end
		BTN_channel[dis].script[XE_ONUNHOVER] = function()
			if chat_BK:IsVisible() == true then
				BTN_channel[dis]:SetTransparent(0)
			end
		end
		BTN_channel[dis].script[XE_LBUP] = function()
			XClickPlaySound(5)
			chat_way:SetFontText(chat_channel[dis],0xffbeb5ee)
			current_channel = message_realchannel[dis]
			XChatInputChangeChannel(current_channel)
			if chatInput~=nil then
				chatInput:SetFocus(1)
			end
			if dis == 5 then
				XSelectLoudSpeaker(0)
			elseif dis==6 then
				XSelectLoudSpeaker(1)
			end
			btn_chat:SetButtonFrame(0)
			chat_BK:SetVisible(0)
			for index,value in pairs(BTN_channel) do
				BTN_channel[index]:SetTransparent(0)
				BTN_channel[index]:SetTouchEnabled(0)
			end
		end
		
	end
	
	btn_chat.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if chat_BK:IsVisible() then
			chat_BK:SetVisible(0)
			for index,value in pairs(BTN_channel) do
				BTN_channel[index]:SetTransparent(0)
				BTN_channel[index]:SetTouchEnabled(0)
			end
		else
			chat_BK:SetVisible(1)
			for index,value in pairs(BTN_channel) do
				BTN_channel[index]:SetTransparent(0)
				BTN_channel[index]:SetTouchEnabled(1)
			end
		end
	end
	
	--------------4聊天方式显示消息
	message_hall = wnd:AddImage(path.."chatBtn_hall.png",5-3,3,85,23)	
	message_friend = wnd:AddImage(path.."chatBtn_hall.png",92-3,3,85,23)
	message_secret = wnd:AddImage(path.."chatBtn_hall.png",179-3,3,85,23)
	message_system = wnd:AddImage(path.."chatBtn_hall.png",266-3,3,85,23)
	message_click = wnd:AddImage(path.."chatBtn1_hall.png",5-3,3,85,23)
	
	message_font[1] = message_hall:AddFont(message_channel[1],15,0,20,0,40,30,0xffbeb5ee)
	message_font[2] = message_friend:AddFont(message_channel[2],15,0,20,0,40,30,0xffbeb5ee)
	message_font[3] = message_secret:AddFont(message_channel[3],15,0,20,0,40,30,0xffbeb5ee)
	message_font[4] = message_system:AddFont(message_channel[4],15,0,20,0,40,30,0xffbeb5ee)
	
	message_clickFont = message_click:AddFont(message_channel[1],15,0,20,0,40,30,0xff6ffefc)
	
	message_hall.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ChangeChatInWindow(0)
		local L,T = message_hall:GetPosition()
		message_click:SetAbsolutePosition(L,T)
		message_clickFont:SetFontText(message_channel[1],0xff6ffefc)
	end
	message_friend.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ChangeChatInWindow(1)
		local L,T = message_friend:GetPosition()
		message_click:SetAbsolutePosition(L,T)
		message_clickFont:SetFontText(message_channel[2],0xff6ffefc)
	end
	message_secret.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ChangeChatInWindow(2)
		local L,T = message_secret:GetPosition()
		message_click:SetAbsolutePosition(L,T)
		message_clickFont:SetFontText(message_channel[3],0xff6ffefc)
	end
	message_system.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ChangeChatInWindow(3)
		local L,T = message_system:GetPosition()
		message_click:SetAbsolutePosition(L,T)
		message_clickFont:SetFontText(message_channel[4],0xff6ffefc)
	end
	
	current_channel = message_realchannel[1]
end

function ChangeChatInWindow(index)
	for dis = 0,3 do
		if dis == index then
			chatshow[dis]:SetVisible(1)
			XSetChatEnd(chatshow[dis].id)
		else
			chatshow[dis]:SetVisible(0)
		end
	end
	
	updownCount = 0
	togglebtn:SetPosition(0,lastToggleBtnPos)
end

--聊天输入栏按Enter键发送函数到C++
function onChatInEnter(data)
	local msg = chatInput:GetEdit()
	XChatInputChangeChannel(current_channel)
	XChatSendMsg(chatInput.id,data)
	chatInput:SetEdit("")
	
	if current_channel == 17 then
		SwitchHallIn()
	end
end

----------聊天消息部分显示
function SetChatInMainIsVisible(flag) 
	if chatpart_ui ~= nil then
		if flag == 1 and chatpart_ui:IsVisible() == false then
			chatpart_ui:SetVisible(1)
		elseif flag == 0  and chatpart_ui:IsVisible() == true then
			chatpart_ui:SetVisible(0)
		end
	end
end

----------输入框部分显示
function SetChatInInputIsVisible(flag) 
	if chatInputEdit ~= nil then
		chatInput:SetVisible(flag)
		chatInputEdit:SetVisible(flag)
		
		message_hall:SetVisible(flag)
		message_friend:SetVisible(flag)
		message_secret:SetVisible(flag)
		message_system:SetVisible(flag)
		message_click:SetVisible(flag)
		close_Btn:SetVisible(flag)
		--chatImg:SetVisible(flag)
		line:SetVisible(flag)
		toggleImg:SetVisible(flag)
		togglebtn:SetVisible(flag)
		ToggleT:SetVisible(flag)
		ToggleD:SetVisible(flag)
		
		message_font[1]:SetVisible(flag)
		message_font[2]:SetVisible(flag)
		message_font[3]:SetVisible(flag)
		message_font[4]:SetVisible(flag)
		
		if flag == 1 then
			--点击可点穿
			XEnableClick(chatpart_ui.id)
			XEnableClick(chatImg.id)
			XEnableClick(chatshow[0].id)
			XEnableClick(chatshow[1].id)
			XEnableClick(chatshow[2].id)
			XEnableClick(chatshow[3].id)
			
			DisableRButtonClick(chatpart_ui.id)
			DisableRButtonClick(chatImg.id)
			DisableRButtonClick(chatshow[0].id)
			DisableRButtonClick(chatshow[1].id)
			DisableRButtonClick(chatshow[2].id)
			DisableRButtonClick(chatshow[3].id)
		else
			DisableClick(chatpart_ui.id)
			DisableClick(chatImg.id)
			DisableClick(chatshow[0].id)
			DisableClick(chatshow[1].id)
			DisableClick(chatshow[2].id)
			DisableClick(chatshow[3].id)
		end
	end
end


function SetChatInPosition(x,y)
	n_chat_in_ui:SetPosition(x, y)
end

function AddChatInTextToLua(index0,index1,index2,index3,strChat)
	if index0 == 1 then
	chatshow[0]:AddChatText(strChat)
	end
	if index1 == 1 then
	chatshow[1]:AddChatText(strChat)
	end
	if index2 == 1 then
	chatshow[2]:AddChatText(strChat)
	end
	if index3 == 1 then
	chatshow[3]:AddChatText(strChat)
	end
	
	if updownCount > 0 then
		updownCount = updownCount + 1
		
		local id = GetChatInChatWnd()
		if id ~= 0 then
			local curLines = XGetChatLineNum(id)
			local delta = curLines - maxlines
			
			local length = 0
			if delta > 0 then
				length = lastToggleBtnPos / delta
				togglebtn:SetPosition(0,lastToggleBtnPos-length*updownCount)
			end
		end
	end
end

function SetChatInInputFocus(focus)
    if chatInput == nil then
	    return
	end	
	if (focus == 1 and chatInput:IsFocus() == false) then
		chatInput:SetFocus(1)
	elseif(focus == 0 and chatInput:IsFocus() == true) then
		chatInput:SetFocus(0)	   
	end
end



function SetChatInAlpha(alpha)
	if n_chat_in_ui ~= nil then
		n_chat_in_ui:SetTransparent(alpha)
		message_hall:SetTransparent(alpha)
		message_friend:SetTransparent(alpha)
		message_secret:SetTransparent(alpha)
		message_system:SetTransparent(alpha)
		message_clickFont:SetTransparent(alpha)
		chat_way:SetTransparent(alpha)
		
		for i = 0,3 do
			chatshow[i]:SetTransparent(alpha)
			message_font[i+1]:SetTransparent(alpha) 
		end
	end
end

function SetInLoudSpeakerEnable()
	local rst = IsItemInPack(5)
	local visible
	if rst == true then
		visible = 0
	else
		visible = 1
	end

	if BTN_channelHide[5]~=nil then
		BTN_channelHide[5]:SetVisible(visible)
	end
end

function SetInLoudSpeakerExEnable()
	local rst = IsItemInPack(4)
	local visible
	if rst == true then
		visible = 0
	else
		visible = 1
	end

	if BTN_channelHide[6]~=nil then
		BTN_channelHide[6]:SetVisible(visible)
	end
end

function SwitchHallIn()
	chat_way:SetFontText(chat_channel[1],0xffbeb5ee)
	current_channel = message_realchannel[1]
	XChatInputChangeChannel(current_channel)
end

function SetTxtIntoInChatInput(txt)
	if chatInput ~= nil and chatInput:IsFocus() then
		chatInput:SetEdit(txt)
	end
end

function IsInChatInputFocus()
	if chatInput ~= nil then
		return chatInput:IsFocus()
	end
	
	return false
end

function AddItemToChatIn(name,onlyid, itemid)
	SetChatInInputIsVisible(1)
	SetChatInInputFocus(1)
	XAddItemToChat(chatInput.id, name, onlyid, itemid)
end

function GetChatInChatWnd()
	if chatshow[0] and chatshow[0]:IsVisible() then
		return chatshow[0].id
	elseif chatshow[1] and chatshow[1]:IsVisible() then
		return chatshow[1].id
	elseif chatshow[2] and chatshow[2]:IsVisible() then
		return chatshow[2].id
	elseif chatshow[3] and chatshow[3]:IsVisible() then
		return chatshow[3].id
	else
		return 0
	end
end

function ChatInPrivateTalk(talk)
	chatInput:SetEdit(talk)
end

function SwitchChannel(index)
	chat_way:SetFontText(chat_channel[index],0xffbeb5ee)
	current_channel = message_realchannel[index]
	XChatInputChangeChannel(current_channel)
	if chatInput~=nil then
		chatInput:SetFocus(1)
	end
	if index == 5 then
		XSelectLoudSpeaker(0)
	elseif index==6 then
		XSelectLoudSpeaker(1)
	end
	btn_chat:SetButtonFrame(0)
	chat_BK:SetVisible(0)
end

function SwitchInChannelByChannel(channel)
	local index = 0
	for i = 1, 6 do
		if message_realchannel[i] == channel then
			index = i
			break
		end
	end
	
	if index > 0 then
		SwitchChannel(index)
	end
end

function ClearChatIn()
	for i = 0, 3 do
		if chatshow[i] ~= nil then
			chatshow[i]:ClearChatText()
		end
	end
	
	if chatInput~=nil then
		chatInput:SetEdit("")
	end
end

-- 整个界面显示
function SetChatInIsVisible(flag) 
	if n_chat_in_ui ~= nil then
		if flag == 1 and n_chat_in_ui:IsVisible() == false then
			n_chat_in_ui:CreateResource()
			n_chat_in_ui:SetVisible(1)
			XChatInputChangeChannel(message_realchannel[1])
		elseif flag == 0  and n_chat_in_ui:IsVisible() == true then
			n_chat_in_ui:DeleteResource()
			n_chat_in_ui:SetVisible(0)
		end
	end
end

function GetChatInIsVisible()  
    if( n_chat_in_ui ~= nil and n_chat_in_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end
