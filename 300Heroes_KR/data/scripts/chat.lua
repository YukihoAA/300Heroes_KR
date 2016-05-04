include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--------聊天界面

--聊天框和号角框定义
local LoudBgImg = nil
local LoudBtn = nil
local btn_LoudImg = nil
local chat_loudspeaker = nil

---号角框
local loudpart_ui = nil

---聊天栏
local chatpart_ui = nil
local chatshow = {}
local chatImg = nil
local toggleImg = nil
local togglebtn = nil
local chatInput = nil

--聊天输入框
local chatInputEdit = nil


-----聊天方式
local btn_chat = nil
local chat_way = nil
local chat_BK = nil
local BTN_channel = {}
local BTN_channelHide = {}
local chat_channel = {"肺厚","模备","庇富","己唱迫","康盔唱迫"}
	
--------聊天消息界面按钮
local message_channel = {"肺厚","模备","庇富","傍瘤"}
local message_hall = nil
local message_friend = nil
local message_secret = nil
local message_system = nil
local message_click = nil
local message_clickFont = nil
local message_realchannel = {18,16,3,17,17}

local current_channel = nil

local updownCount = 0
local lastToggleBtnPos = 129
local maxlines = 13

function InitChat_UI(wnd, bisopen)
	g_chat_ui = CreateWindow(wnd.id, 720, 498-OffsetY1, 556,248)
	InitMain_Chat(g_chat_ui)
	g_chat_ui:SetVisible(bisopen)
	g_chat_ui:SetTouchEnabled(0)
end

function InitMain_Chat(wnd)
	--聊天栏
	chatpart_ui = CreateWindow(wnd.id, 0,0, 556,248)
	chatImg = chatpart_ui:AddImage(path.."chatMessageBK_hall.png",-4,-4,556,248)
	chatpart_ui:AddImage(path.."line_chat.png",0,26,548,1)
	chatshow[0] = chatpart_ui:AddChat(15,8,-4,-35,520,200,0xffbeb5ee)
	chatshow[1] = chatpart_ui:AddChat(15,8,-4,-35,520,200,0xffbeb5ee)
	chatshow[2] = chatpart_ui:AddChat(15,8,-4,-35,520,200,0xffbeb5ee)
	chatshow[3] = chatpart_ui:AddChat(15,8,-4,-35,520,200,0xffbeb5ee)
	
	for i = 1,3 do
		if chatshow[i] ~= nil then
			chatshow[i]:SetVisible(0)
		end
	end
	
	--号角对话栏
	loudpart_ui = CreateWindow(chatpart_ui.id, 0,450-498, 570, 64)
	LoudBgImg = loudpart_ui:AddImage(path.."haojiaoBK_hall.png",0,0,512,64)
	chat_loudspeaker = loudpart_ui:AddChat(15,8,0,0,512,45,0xffbeb5ee)
	LoudBtn = loudpart_ui:AddImage(path.."channelselect1_hall.png",510,0,39,42)
	btn_LoudImg = LoudBtn:AddImage(path.."haojiaoBtn_hall.png",6,6,32,32)
	
	SetLoudSpeakerIsVisible(0)
	
	--滑动栏、滑动键
	toggleImg = chatpart_ui:AddImage(path.."toggleBK_main.png",530,43,16,179)
	togglebtn = toggleImg:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,lastToggleBtnPos,16,50)
	local ToggleT = toggleImg:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = toggleImg:AddImage(path.."TD1_main.png",0,179,16,16)
	
	XSetWindowFlag(togglebtn.id,1,1,0,lastToggleBtnPos)
	
	togglebtn:ToggleBehaviour(XE_ONUPDATE, 1)	
	togglebtn:ToggleEvent(XE_ONUPDATE, 1)
	
	togglebtn.script[XE_ONUPDATE] = function()
		if togglebtn._T == nil then
			togglebtn._T = 0
		end
		
		local L,T,R,B = XGetWindowClientPosition(togglebtn.id)
		if togglebtn._T ~= T then
			local id = GetChatOutChatWnd()
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
		local id = GetChatOutChatWnd()
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
	chatInputEdit = CreateWindow(wnd.id, -2,242,505,45)
	chatInput = chatInputEdit:AddEdit(path.."chatEdit_hall.png","","onChatEnter","",15,10,10,505,35,0xffffffff,0xff000000,0,"")
	XEditSetMaxByteLength(chatInput.id,60)
	chatInput:SetDefaultFontText("郴侩 涝仿 饶 Enter虐肺 傈价", 0xff303b4a)

	--选择发送方式键--肺厚、模备、庇富、己唱迫、康盔唱迫
		
	btn_chat = chatInputEdit:AddButton(path.."channelselect1_hall.png",path.."channelselect2_hall.png",path.."channelselect3_hall.png",510,1,39,42)
	chat_way = btn_chat:AddFont(chat_channel[1],12,8,0,0,39,42,0xffbeb5ee)
	chat_BK = btn_chat:AddImage(path.."chatBK_hall.png",-40,-104,79,100)
	chat_BK:SetVisible(0)
	
	for dis = 1,5 do
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
			if dis == 4 then
				XSelectLoudSpeaker(0)
			elseif dis==5 then
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
			SetLoudSpeakerEnable()
			SetLoudSpeakerExEnable()
		end
	end
	
	--------------4聊天方式显示消息
	message_hall = wnd:AddImage(path.."chatBtn_hall.png",5-3,3,85,23)	
	message_friend = wnd:AddImage(path.."chatBtn_hall.png",92-3,3,85,23)
	message_secret = wnd:AddImage(path.."chatBtn_hall.png",179-3,3,85,23)
	message_system = wnd:AddImage(path.."chatBtn_hall.png",266-3,3,85,23)
	message_click = wnd:AddImage(path.."chatBtn1_hall.png",5-3,3,85,23)
	
	message_hall:AddFont(message_channel[1],15,0,20,0,40,30,0xffbeb5ee)
	message_friend:AddFont(message_channel[2],15,0,20,0,40,30,0xffbeb5ee)
	message_secret:AddFont(message_channel[3],15,0,20,0,40,30,0xffbeb5ee)
	message_system:AddFont(message_channel[4],15,0,20,0,40,30,0xffbeb5ee)
	
	message_clickFont = message_click:AddFont(message_channel[1],15,0,20,0,40,30,0xff6ffefc)
	
	message_hall.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ChangeChatWindow(0)
		local L,T = message_hall:GetPosition()
		message_click:SetAbsolutePosition(L,T)
		message_clickFont:SetFontText(message_channel[1],0xff6ffefc)
	end
	message_friend.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ChangeChatWindow(1)
		local L,T = message_friend:GetPosition()
		message_click:SetAbsolutePosition(L,T)
		message_clickFont:SetFontText(message_channel[2],0xff6ffefc)
	end
	message_secret.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ChangeChatWindow(2)
		local L,T = message_secret:GetPosition()
		message_click:SetAbsolutePosition(L,T)
		message_clickFont:SetFontText(message_channel[3],0xff6ffefc)
	end
	message_system.script[XE_LBUP] = function()
		XClickPlaySound(5)
		ChangeChatWindow(3)
		local L,T = message_system:GetPosition()
		message_click:SetAbsolutePosition(L,T)
		message_clickFont:SetFontText(message_channel[4],0xff6ffefc)
	end
	
	current_channel = message_realchannel[1]
end

function ChangeChatWindow(index)
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
function onChatEnter(data)
	local msg = chatInput:GetEdit()
	XChatInputChangeChannel(current_channel)
	XChatSendMsg(chatInput.id,data)
	chatInput:SetEdit("")

	if current_channel == 17 then
		SwitchHall()
	end
end
--判断聊天内容输入框光标是否闪动
function IsMouseInChatInput()
	if g_chat_ui:IsVisible() == true then
		---判断"   聊天输入内容后按Enter键发送"   是否显示
		local Input_Focus = chatInput:IsFocus()
		
		------下拉选项框
		local flagA = (chat_BK:IsVisible() == true and btn_chat:IsFocus() == false and BTN_channel[1]:IsFocus() == false and BTN_channel[2]:IsFocus() == false
		and BTN_channel[3]:IsFocus() == false and BTN_channel[4]:IsFocus() == false and BTN_channel[5]:IsFocus() == false)

		if(flagA == true) then
			btn_chat:SetButtonFrame(0)
			chat_BK:SetVisible(0)
			for index,value in pairs(BTN_channel) do
				BTN_channel[index]:SetTransparent(0)
				BTN_channel[index]:SetTouchEnabled(0)
			end
		end
	end
end
----------整个界面显示
function SetChatIsVisible(flag) 
	if g_chat_ui ~= nil then
		if flag == 1 and g_chat_ui:IsVisible() == false then
			g_chat_ui:SetVisible(1)
			--XChatInputChangeChannel(message_realchannel[1])
		elseif flag == 0  and g_chat_ui:IsVisible() == true then
			g_chat_ui:SetVisible(0)
		end
	end
end
----------聊天消息部分显示
function SetChatMainIsVisible(flag) 
	if chatpart_ui ~= nil then
		if flag == 1 and chatpart_ui:IsVisible() == false then
			chatpart_ui:SetVisible(1)
		elseif flag == 0  and chatpart_ui:IsVisible() == true then
			chatpart_ui:SetVisible(0)
		end
	end
end

----------输入框部分显示
function SetChatInputIsVisible(flag) 
	if chatInputEdit ~= nil then
		chatInput:SetVisible(flag)
		chatInputEdit:SetVisible(flag)
	end
end
----------号角部分显示
function SetLoudSpeakerIsVisible(flag) 
	if loudpart_ui ~= nil then
		if flag == 1  and loudpart_ui:IsVisible() == false then
			loudpart_ui:SetVisible(1)
		elseif flag == 0  and loudpart_ui:IsVisible() == true then
			loudpart_ui:SetVisible(0)
		end
	end
end


function GetChatIsVisible()  
    if(g_chat_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function SetChatPosition(x,y)
	g_chat_ui:SetPosition(x, y)
end

function AddChatTextToLua(index0,index1,index2,index3,strChat)
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
		
		local id = GetChatOutChatWnd()
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

function SetChatInputFocus(focus)
    if chatInput == nil then
	    return
	end	
	if (focus == 1 and chatInput:IsFocus() == false) then
		chatInput:SetFocus(1)
	elseif(focus == 0 and chatInput:IsFocus() == true) then
		chatInput:SetFocus(0)	   
	end
end

function PrivateTalk(talk)
	chatInput:SetEdit(talk)
end

function SetLoudSpeakerEnable()
	local rst = IsItemInPack(5)
	local visible;
	if rst == true then
		visible = 0
	else
		visible = 1
	end
	
	if BTN_channelHide[4]~=nil then
		BTN_channelHide[4]:SetVisible(visible)
	end
end

function SetLoudSpeakerExEnable()
	local rst = IsItemInPack(4)
	local visible;
	if rst == true then
		visible = 0
	else
		visible = 1
	end

	if BTN_channelHide[5]~=nil then
		BTN_channelHide[5]:SetVisible(visible)
	end
end

function IsItemInPack(itemID)
	for i = 1, #equipManage.CitemIndex do
		if equipManage.CitemIndex[i] == itemID then
			return true
		end
	end
	
	return false
end

function SwitchHall()
	chat_way:SetFontText(chat_channel[1],0xffbeb5ee)
	current_channel = message_realchannel[1]
	XChatInputChangeChannel(current_channel)
end

function onChatInputSendToLua(txt)
	if chatInput ~= nil and chatInput:IsFocus() then
		chatInput:SetEdit(txt)
	else
		SetTxtIntoTeamChatInput(txt)
		SetTxtIntoStartChatInput(txt)
		SetTxtIntoInChatInput(txt)
		SetTxtIntoRoomChatInput(txt)
	end
end

function SetLoudspeakerTxt(txt)
	if chat_loudspeaker ~= nil then
		chat_loudspeaker:AddChatText(txt)
	end
end

function ClearLoudspeakerTxt(txt)
	if chat_loudspeaker ~= nil then
		chat_loudspeaker:ClearChatText()
	end
end

function SetLoudspeakerAlpha(alpha)
	if loudpart_ui ~= nil then
		loudpart_ui:SetTransparent(alpha)
		LoudBtn:SetTransparent(alpha)
		btn_LoudImg:SetTransparent(alpha)
		chat_loudspeaker:SetTransparent(alpha)
	end
end

function IsAnyChatInputFocus()
	if IsChatInputFocus() or IsTeamChatInputFocus() or IsStartChatInputFocus() or IsInChatInputFocus()then
		return true
	end
	
	return false
end

function IsChatInputFocus()
	if chatInput ~= nil then
		return chatInput:IsFocus()
	end
	
	return false
end

function AddItemToChatOut(name,onlyid, itemid)
	SetChatInputIsVisible(1)
	SetChatInputFocus(1)
	XAddItemToChat(chatInput.id, name, onlyid, itemid)
end

function GetChatOutChatWnd()
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

function SwitchChannelOut(index)
	chat_way:SetFontText(chat_channel[index],0xffbeb5ee)
	current_channel = message_realchannel[index]
	XChatInputChangeChannel(current_channel)
	if chatInput~=nil then
		chatInput:SetFocus(1)
	end
	if index == 4 then
		XSelectLoudSpeaker(0)
	elseif index==5 then
		XSelectLoudSpeaker(1)
	end
	btn_chat:SetButtonFrame(0)
	chat_BK:SetVisible(0)
end

function SwitchChannelByChannel(channel)
	local index = 0
	for i = 1, 5 do
		if message_realchannel[i] == channel then
			index = i
			break;
		end
	end
	
	if index > 0 then
		SwitchChannelOut(index)
	end
end

function ClearChat()
	ClearOutChat()
	ClearChatIn()
	ClearGameTeamChat()
	ClearGameStartChat()
	ClearRoomChat()
end

function ClearOutChat()
	for i = 0, 3 do
		if chatshow[i] ~= nil then
			chatshow[i]:ClearChatText()
		end
	end
	
	if chatInput~=nil then
		chatInput:SetEdit("")
	end
end