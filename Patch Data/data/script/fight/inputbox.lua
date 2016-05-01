include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--输入界面-----改名卡
local message = nil
local NameInputEdit, NameInput = nil

local btn_ok = nil
local btn_cancel = nil

local Font_ok = nil
local Font_cancel = nil
---------------------------------solo界面UI
local Solo_ui = nil
local SoloCardCount = nil		----solo许可证的数量

local Back = nil
local pullPosX = 100
local pullPosY = 100

function InitInputBox_ui(wnd,bisopen)
	n_inputbox_ui = CreateWindow(wnd.id, (1920-400)/2, (1080-340)/2, 400, 340)
	n_inputbox_ui:EnableBlackBackgroundTop(1)
	InitMain_InputBox(n_inputbox_ui)
	n_inputbox_ui:SetVisible(bisopen)
end

function InitMain_InputBox(wnd)
	Back = wnd:AddImage(path_hero.."inputbox_hero.png",0,0,400,340)
	btn_ok = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",58,270,90,40)		
	btn_cancel = wnd:AddButton(path_hero.."detail1_hero.png",path_hero.."detail2_hero.png",path_hero.."detail3_hero.png",250,270,90,40)	
	btn_ok.script[XE_LBUP] = function()
		XClickPlaySound(5)
	
		XClickInputBoxIndex(1,NameInput:GetEdit())
	end
	btn_cancel.script[XE_LBUP] = function()
		XClickPlaySound(5)
		
		XClickInputBoxIndex(0,NameInput:GetEdit())
	end	
	
	---------为了SOLO专门设置
	Solo_ui = wnd:AddImage("..\\UI\\Icon\\equip\\solo.dds", 130, 185, 50, 50)
	Solo_ui:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)
	Solo_ui:AddImage(path.."friend4_hall.png",34,34,26,26)
	local moneyBK = Solo_ui:AddImage(path_fight.."solo_money.png", 70, 40, 80, 21)
	moneyBK:AddImage(path_shop.."money_shop.png",0,-6,64,64)		
	local m_pShopBuy = Solo_ui:AddImage(path_fight.."solo_buy.png", -3, 55, 58, 22)
	m_pShopBuy.script[XE_LBUP] = function()
		XClickPlaySound(5)
	
		XShopClickBuyItem(1, 206, 7)
	end
	Solo_ui.script[XE_LBUP] = function()
		XClickPlaySound(5)
	
		XShopClickBuyItem(1, 206, 7)
	end
		
	n_inputbox_ui:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息	
    Back.script[XE_LBDOWN] = function()
	    n_inputbox_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = n_inputbox_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	Back.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
	    n_inputbox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	n_inputbox_ui.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(n_inputbox_ui:IsVisible()) then
		    local PosX = XGetCursorPosX()-pullPosX
		    local PosY = XGetCursorPosY()-pullPosY
		    n_inputbox_ui:SetAbsolutePosition(PosX,PosY)
		else
	        n_inputbox_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
	---文字
	message = wnd:AddFont("输入角色的新名字", 15, 8, -30, 0, 340, 120, 0x8177d0)
	message:SetFontSpace(2,2)	
	-- ----名字修改
	NameInputEdit = CreateWindow(wnd.id, 57,130,330,40)
	NameInput = NameInputEdit:AddEdit(path_login.."passwordEdit_login.png","","onNameInputEnter","",20,0,0,290,30,0xffffffff,0xff000000,0,"")
	NameInput:SetTransparent(0)
	XEditSetMaxByteLength(NameInput.id,14)
	Font_ok = btn_ok:AddFont("确定",15,8,0,0,90,42,0xbeb5ee)
	Font_cancel = btn_cancel:AddFont("取消",15,8,0,0,90,42,0xbeb5ee)
	Solo_ui:AddFont("Solo结束后将世界公告您的胜利消息！",12,0,-40,-80,400,15,0xff0000)	
	SoloCardCount = Solo_ui:AddFont("0",12,8,0,0,84,86,0xffffff)
	moneyBK:AddFont("手续费",15,8,0,25,80,21,0xffffff)	
	moneyBK:AddFont("2000",15,0,30,0,100,15,0xffA5A46C)	
	Solo_ui:AddFont("点击购买",12,0,-5,57,100,13,0xffffff)	
	
end
---------通信
function onNameInputEnter()
	XClickInputBoxIndex(1,NameInput:GetEdit())
end
function SendDataToInput(messageFont,color)
	message:SetFontText(messageFont,color)
end
-- 从背包中得到SOLO道具的个数
function GetSoloCardCount(pictureName,Count)
	Solo_ui.changeimage("..\\"..pictureName)
	SoloCardCount:SetFontText(tostring(Count), 0xffffff)
end
--------是否显示solo界面
function SetInputBoxSoloIsVisible(flag)
	if Solo_ui ~= nil then
		if flag == 1 and Solo_ui:IsVisible() == false then
			Solo_ui:SetVisible(1)
		elseif flag == 0 and Solo_ui:IsVisible() == true then
			Solo_ui:SetVisible(0)
		end
	end
end

function SetInputBoxIsVisible(flag) 
	if n_inputbox_ui ~= nil then
		if flag == 1 and n_inputbox_ui:IsVisible() == false then
			n_inputbox_ui:CreateResource()
			NameInput:SetEdit("")
			NameInput:SetFocus(1)
			SetInputBoxSoloIsVisible(0)
			n_inputbox_ui:SetVisible(1)
		elseif flag == 0 and n_inputbox_ui:IsVisible() == true then
			n_inputbox_ui:DeleteResource()
			n_inputbox_ui:SetVisible(0)
		end
	end
end

function GetInputBoxIsVisible()  
    if(n_inputbox_ui ~= nil and n_inputbox_ui:IsVisible()) then
       return 1
    else
       return 0
    end
end
