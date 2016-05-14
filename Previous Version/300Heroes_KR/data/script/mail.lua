include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 设置主界面

local img_MailBg = nil			-- 邮箱背景
local pullPosX = 100
local pullPosY = 100


local btn_close = nil			-- 关闭按钮
local chk_All = {}				-- 全部按钮		1,2 - 未点击状态，已点击状态	3,4 - 文字暗，文字亮
local chk_UnRead = {}			-- 未读按钮
local chk_Readed = {}			-- 已读按钮
local img_CountFrame = nil		-- 数量框
local font_CountFont = nil		-- 数量
local int_Count = 0				-- 邮件未读数量
local font_AllCount = nil		-- 总数量文字
local int_AllCount = 99			-- 邮件总数量

local int_ClickType = 0			-- 类型 0 - 全部	1 - 未读	2 - 已读
local btn_CheckFrame = {}		-- 勾选框
btn_CheckFrame.Choose = {}		-- 全选or单选
local btn_LeftPage = nil		-- 左翻页
local btn_RightPage = nil		-- 右翻页
local img_PageBg = nil			-- 页数背景
local font_Page = nil			-- 页数
local int_CurPage = 1			-- 当前页数
local int_AllPage = 25			-- 总页数

-- 邮件内容及控件的定义
local MailInfo = {}				-- 邮件具体信息 - 老惑：概老惯价
MailInfo.Date = {}				-- 日期
MailInfo.LastDay = {}			-- 剩余天数
MailInfo.IsOpen = {}			-- 是否打开过	1 - 已读	0 - 未读
MailInfo.IsSel = {}				-- 是否选中
MailInfo.IsCheck = {}			-- 是否勾选
MailInfo.IsHaveItem = {}

local MailInfo_Content = nil	-- 内容
local MailInfo_Money = nil		-- 奖励金币
local MailInfo_Exp = nil		-- 奖励经验
local MailInfo_Title = nil		-- 邮件标题
local MailInfo_Time = nil		-- 邮件剩余时间
local MailInfo_IconPath = {}	-- 邮件道具图片的路径
local MailInfo_IconPath1 = {}	-- 邮件道具图片的路径1
local MailInfo_IconPath2 = {}	-- 邮件道具图片的路径2

local img_SelList = {}			-- 选中列表

local MailItemList = {}			-- 邮件列表
MailItemList.MailIcon = {}		-- 邮件图标
MailItemList.Name = {}			-- 邮件主题
MailItemList.Date = {}			-- 邮件日期
MailItemList.LastDay = {}		-- 邮件剩余天数
MailItemList.IsHave = {}

local btn_TackAll = nil			-- 全部提取
local btn_DelMail = nil			-- 删除邮件

-- 邮件具体内容相关控件
local img_MailInfoBg = nil		-- 邮箱具体信息背景
local img_MailInfoName = nil	-- 标题背景图
local font_MailInfoName = nil	-- 标题文字
local font_MailInfoLastDay = nil	-- 剩余多少天文字
local img_MailInfoBg1 = nil		-- 内容背景图
local font_MailInfo = nil		-- 具体内容
local MailInfoItemLlist = {}	-- 道具列表
MailInfoItemLlist.Icon = {}		-- 道具图标
MailInfoItemLlist.Head = {}		-- 道具框
MailInfoItemLlist.CountF = {}	-- 道具数量控件
MailInfoItemLlist.CountI = {}	-- 道具数量
local font_Money = nil			-- 金币
local font_Exp = nil			-- 钻石
local btn_DelMailInfo = nil		-- 删除邮件
local btn_TackMailInfo = nil	-- 提取附件
local btn_CloseInfo = nil			-- 关闭

local mposx = -120
local mposy = -20
function InitMail_UI(wnd, bisopen)
	g_setup_mail_ui = CreateWindow(wnd.id, 1920-655, (1080-532)/2, 372, 532)
	InitMain_Mail(g_setup_mail_ui)
	g_setup_mail_ui:SetVisible(bisopen)
end

function InitMain_Mail(wnd)
	img_MailInfoBg = wnd:AddImage(path_setup.."FriendBg_setup.png", -516, -4, 510, 540)
	img_MailInfoBg:SetVisible(0)
	img_MailBg = wnd:AddImage(path_setup.."FriendBg_setup.png",-4, -4, 380, 540)
	
	local img_MailManage = img_MailBg:AddImage(path_setup.."font1_mail.png", 157, 15, 128, 32)
	img_MailManage:SetTouchEnabled(0)
	
	btn_close = img_MailBg:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",336,9,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XCloseMailList(1)
	end
	img_MailBg:AddImage(path_setup.."FGT_mail.png", 7, 90, 512, 4)
	
	-- 标签按钮的初始化
	chk_All[1] = img_MailBg:AddImage(path_setup.."biaoqian1_mail.png", 14, 58, 128, 64)
	chk_All[2] = img_MailBg:AddImage(path_setup.."biaoqian2_mail.png", 14, 58, 128, 64)
	chk_All[3] = chk_All[1]:AddImage(path_setup.."font7_mail.png", 10, 0, 128, 48)
	chk_All[4] = chk_All[2]:AddImage(path_setup.."font6_mail.png", 10, 0, 128, 48)
	chk_All[2]:SetTouchEnabled(1)
	chk_All[3]:SetTouchEnabled(0)
	chk_All[1]:SetVisible(0)
	
	chk_UnRead[1] = img_MailBg:AddImage(path_setup.."biaoqian1_mail.png", 102, 58, 128, 64)
	chk_UnRead[2] = img_MailBg:AddImage(path_setup.."biaoqian2_mail.png", 102, 58, 128, 64)
	chk_UnRead[3] = chk_UnRead[1]:AddImage(path_setup.."font10_mail.png", 10, 0, 128, 48)
	chk_UnRead[4] = chk_UnRead[2]:AddImage(path_setup.."font9_mail.png", 10, 0, 128, 48)
	chk_UnRead[2]:SetVisible(0)
	chk_UnRead[2]:SetTouchEnabled(1)
	chk_UnRead[3]:SetTouchEnabled(0)
	
	chk_Readed[1] = img_MailBg:AddImage(path_setup.."biaoqian1_mail.png", 190, 58, 128, 64)
	chk_Readed[2] = img_MailBg:AddImage(path_setup.."biaoqian2_mail.png", 190, 58, 128, 64)
	chk_Readed[3] = chk_Readed[1]:AddImage(path_setup.."font5_mail.png", 10, 0, 128, 48)
	chk_Readed[4] = chk_Readed[2]:AddImage(path_setup.."font4_mail.png", 10, 0, 128, 48)
	chk_Readed[2]:SetVisible(0)
	chk_Readed[2]:SetTouchEnabled(1)
	chk_Readed[3]:SetTouchEnabled(0)
	
	img_CountFrame = img_MailBg:AddImage(path.."friend4_hall_big.png", 75, 53, 32, 32)
	font_CountFont = img_CountFrame:AddFont(tostring(int_Count), 15, 8, 1, 0, 30, 20, 0xffffffff)
	
	chk_All[1].script[XE_LBUP] = function()
		XClickPlaySound(5)
		int_ClickType = 0
		
		XClickCheckBtnMail(1, int_ClickType)
		
		chk_All[1]:SetVisible(0)
		chk_All[2]:SetVisible(1)
		img_CountFrame:SetPosition(75, 53)
		
		chk_UnRead[1]:SetVisible(1)
		chk_UnRead[2]:SetVisible(0)
		chk_Readed[1]:SetVisible(1)
		chk_Readed[2]:SetVisible(0)
		
		for i = 1, 8 do
			img_SelList[i]:SetVisible(0)
		end
	end
	
	chk_UnRead[1].script[XE_LBUP] = function()
		XClickPlaySound(5)
		int_ClickType = 1
		
		XClickCheckBtnMail(1, int_ClickType)
		
		chk_UnRead[1]:SetVisible(0)
		chk_UnRead[2]:SetVisible(1)
		img_CountFrame:SetPosition(163, 53)
		
		chk_All[1]:SetVisible(1)
		chk_All[2]:SetVisible(0)
		chk_Readed[1]:SetVisible(1)
		chk_Readed[2]:SetVisible(0)
		
		for i = 1, 8 do
			img_SelList[i]:SetVisible(0)
		end
	end
	
	chk_Readed[1].script[XE_LBUP] = function()
		XClickPlaySound(5)
		int_ClickType = 2
		-- log("\nint_ClickType = "..int_ClickType)
		XClickCheckBtnMail(1, int_ClickType)
		
		chk_Readed[1]:SetVisible(0)
		chk_Readed[2]:SetVisible(1)
		img_CountFrame:SetPosition(251, 53)
		
		chk_All[1]:SetVisible(1)
		chk_All[2]:SetVisible(0)
		chk_UnRead[1]:SetVisible(1)
		chk_UnRead[2]:SetVisible(0)
		
		for i = 1, 8 do
			img_SelList[i]:SetVisible(0)
		end
	end
	
	-- 勾选框的创建
	img_MailBg:AddFont("傈眉", 15, 0, 52, 102, 50, 20, 0xff634792)
	btn_CheckFrame[1] = img_MailBg:AddButton(path_hero.."checkbox_hero.png", path_hero.."checkbox_hero.png", path_hero.."checkbox_hero.png", 19, 97, 32, 32)
	btn_CheckFrame.Choose[1] = btn_CheckFrame[1]:AddImage(path_hero.."checkboxYes_hero.png", 5, -1, 32, 32)
	btn_CheckFrame.Choose[1]:SetTouchEnabled(0)
	btn_CheckFrame.Choose[1]:SetVisible(0)
	
	-- 翻页相关控件的创建
	btn_LeftPage = img_MailBg:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png", 115, 96, 27,36)
	XWindowEnableAlphaTouch(btn_LeftPage.id)
	img_PageBg = img_MailBg:AddImage(path_setup.."yemadiban_mail.png", 142, 105, 92, 18)
	int_AllPage = math.ceil(int_AllCount/4)
	font_Page = img_PageBg:AddFont(int_CurPage.."/"..int_AllPage, 15, 8, 0, 0, 92, 18, 0xffffffff)
	btn_RightPage = img_MailBg:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png", 235, 96, 27,36)
	XWindowEnableAlphaTouch(btn_RightPage.id)
	
	btn_LeftPage.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XMailBackPageClick(1)
	end
	
	btn_RightPage.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XMailNextPageClick(1)
	end
	
	-- img_MailBg:AddFont("邮件数量", 15, 0, 277, 102, 100, 20, 0xff634792)
	-- font_AllCount = img_MailBg:AddFont(tostring(int_AllCount), 15, 0, 333, 100, 50, 20, 0xffffffff)
	local AA = img_MailBg:AddFont("救郴:快祈焊粮扁埃篮 7老捞哥, 梅何拱前捞 乐栏搁 30老涝聪促", 11, 0, 15, 460, 400, 12, 0xb27936)
	AA:SetFontSpace(1,1)
	-- 邮件列表创建
	local iX,iY = 12,135
	for i = 1, 8 do
		MailItemList[i] = img_MailBg:AddImage(path_setup.."youjiandiban3_mail.png", iX, iY + (40*(i-1)), 358, 39)
		--MailItemList[i]:SetTouchEnabled(1)
		
		img_SelList[i] = MailItemList[i]:AddImage(path_setup.."youjiandiban4_mail.png", 0, 0, 358, 39)
		img_SelList[i]:SetVisible(0)
		
		MailItemList.MailIcon[i] = MailItemList[i]:AddImage(path_setup.."youjian1_mail.png", 57, 3, 43, 34)
		MailItemList.MailIcon[i]:SetTouchEnabled(0)
		MailItemList.IsHave[i] = MailItemList.MailIcon[i]:AddImage(path_setup.."huixinzhen_mail.png", 18, 0, 15, 26)
		MailItemList.IsHave[i]:SetTouchEnabled(0)
		MailItemList.Name[i] = MailItemList[i]:AddFont("老惑：概老惯价"..i, 12, 8, -107, -10, 125, 20,  0xff87ced4)
		MailItemList.Date[i] = MailItemList[i]:AddFont("2015.8.1"..i, 12, 0, 242, 10, 100, 20,  0xff87ced4)
		MailItemList.LastDay[i] = MailItemList[i]:AddFont(i.."1老", 12, 0, 317, 10, 60, 20,  0xff87ced4)
		
		btn_CheckFrame[1+i] = img_MailBg:AddButton(path_hero.."checkbox_hero.png", path_hero.."checkbox_hero.png", path_hero.."checkbox_hero.png", 19, iY + 5 + (40*(i-1)), 32, 32)
		btn_CheckFrame.Choose[1+i] = btn_CheckFrame[1+i]:AddImage(path_hero.."checkboxYes_hero.png", 5, -1, 32, 32)
		btn_CheckFrame.Choose[1+i]:SetTouchEnabled(0)
		btn_CheckFrame.Choose[1+i]:SetVisible(0)
		
		-- 点击
		MailItemList[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			MailInfo.IsSel[i] = 1
			img_SelList[i]:SetVisible(1)
			for j = 1, 8 do
				if (i ~= j) then
					MailInfo.IsSel[j] = 0
					img_SelList[j]:SetVisible(0)
				end
			end
			XMailListIconClick(1, ((int_CurPage-1)*8)+(i-1))
		end
		
		-- 悬浮
		MailItemList[i].script[XE_ONHOVER] = function()
			img_SelList[i]:SetVisible(1)
			for j = 1, 8 do
				if (i ~= j) then
					if (MailInfo.IsSel[j] == 0 or MailInfo.IsSel[j] == nil) then
						img_SelList[j]:SetVisible(0)
					end
				end
			end
		end
		
		-- 离开
		MailItemList[i].script[XE_ONUNHOVER] = function()
			if (MailInfo.IsSel[i] == 0 or MailInfo.IsSel[i] == nil) then
				img_SelList[i]:SetVisible(0)
			end
		end
	end
	
	-- 勾选框逻辑
	for i = 1, #btn_CheckFrame do
		btn_CheckFrame[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			if btn_CheckFrame.Choose[i]:IsVisible() then
				if (i == 1) then
					btn_CheckFrame.Choose[i]:SetVisible(0)
					for j = 2, #btn_CheckFrame.Choose do
						btn_CheckFrame.Choose[j]:SetVisible(0)
						MailInfo.IsCheck[j-1] = 0
					end
				else
					btn_CheckFrame.Choose[i]:SetVisible(0)
					MailInfo.IsCheck[i] = 0
				end
			else
				if (i == 1) then
					btn_CheckFrame.Choose[i]:SetVisible(1)
					for j = 2, #btn_CheckFrame.Choose do
						btn_CheckFrame.Choose[j]:SetVisible(1)
						MailInfo.IsCheck[j-1] = 1
					end
				else
					btn_CheckFrame.Choose[i]:SetVisible(1)
					MailInfo.IsCheck[i] = 1
				end
			end
		end
	end
	
	btn_TackAll = img_MailBg:AddButton(path_setup.."btn1_mail.png", path_setup.."btn2_mail.png", path_setup.."btn3_mail.png", 60, 483, 100, 32)
	local Fa = btn_TackAll:AddFont("傈何罐扁", 15, 8, 0, 0, 100, 32, 0xffffff)
	Fa:SetTouchEnabled(0)
	btn_DelMail = img_MailBg:AddButton(path_setup.."btn1_mail.png", path_setup.."btn2_mail.png", path_setup.."btn3_mail.png", 221, 483, 100, 32)
	local Fb = btn_DelMail:AddFont("傈眉昏力", 15, 8, 0, 0, 100, 32, 0xffffff)
	Fb:SetTouchEnabled(0)
	local AM = btn_DelMail:AddFont("梅何拱前捞 乐嚼聪促.",11, 0, -12, 31, 150, 12, 0xb27936)
	AM:SetFontSpace(1,1)
	btn_TackAll.script[XE_LBUP] = function()
		XClickPlaySound(5)
		local MailIndex = {}
		for i = 2, 9 do
			if (btn_CheckFrame.Choose[i]:IsVisible() and i ~= 1) then
				MailIndex[i-1] = ((i-2)+((int_CurPage-1)*8))
			else
				MailIndex[i-1] = -1
			end
		end
		XTackAllMail(1, MailIndex[1], MailIndex[2], MailIndex[3], MailIndex[4], MailIndex[5], MailIndex[6], MailIndex[7], MailIndex[8])
	end
	btn_DelMail.script[XE_LBUP] = function()
		XClickPlaySound(5)
		local MailIndex = {}
		for i = 2, 9 do
			if (btn_CheckFrame.Choose[i]:IsVisible() and i ~= 1) then
				MailIndex[i-1] = ((i-2)+((int_CurPage-1)*8))
			else
				MailIndex[i-1] = -1
			end
		end
		XDelAllMail(1, MailIndex[1], MailIndex[2], MailIndex[3], MailIndex[4], MailIndex[5], MailIndex[6], MailIndex[7], MailIndex[8])
	end
	
	-- 邮箱具体内容控件的创建
	img_MailInfoBg:AddImage(path_setup.."font2_mail.png", 232, 16, 64, 32)
	img_MailInfoBg:AddImage(path_setup.."font3_mail.png", 17, 60, 64, 32)
	-- img_MailInfoName = img_MailInfoBg:AddImage(path_setup.."zhutiEdit_mail.png", 68, 65, 512, 32)
	font_MailInfoName = img_MailInfoBg:AddFont("老惑：概老惯价", 15, 0, 69, 70, 300, 20, 0xff87ced4)
	img_MailInfoBg1 = img_MailInfoBg:AddImage(path_setup.."InfoBg_mail.png", 27, 99, 458, 228)
	font_MailInfo = img_MailInfoBg1:AddFont("某腐磐疙 7臂磊", 15, 0, 10, 10, 440, 200, 0xffffffff)
	font_MailInfoLastDay = img_MailInfoBg1:AddFont("快祈拱焊粮扁埃：XX老", 11, 0, 330, 205, 120, 11, 0xc23452)
	font_MailInfoLastDay:SetFontSpace(1,1)
	for i = 1, 6 do
		MailInfoItemLlist[i] = img_MailInfoBg:AddImage(path_info.."skill0_info.png", 62+(62*(i-1)), 355, 64, 64)
		MailInfoItemLlist.Icon[i] = MailInfoItemLlist[i]:AddImageMultiple(path_equip.."bag_equip.png", "", "", 10, 10, 45, 45)
		MailInfoItemLlist.Head[i] = MailInfoItemLlist[i]:AddImage(path_info.."skill1_info.png", 0, 0, 64, 64)
		MailInfoItemLlist.CountF[i] = MailInfoItemLlist[i]:AddFont( "0", 12, 6, -42, -38, 100, 17, 0xFFFFFF)
		MailInfoItemLlist.CountF[i]:SetFontBackground()
	end
	img_MailInfoBg:AddImage(path_shop.."money_shop.png", 98, 445, 64, 64)
	img_MailInfoBg:AddImage(path_setup.."exp_mail.png", 303, 453, 64, 32)
	font_Money = img_MailInfoBg:AddFont("12345", 15, 0, 135, 453, 100, 15, 0xfff0e18e)
	font_Exp = img_MailInfoBg:AddFont("54321", 15, 0, 343, 453, 100, 15, 0xff53e787)
	btn_DelMailInfo = img_MailInfoBg:AddButton(path_setup.."btn1_mail.png", path_setup.."btn2_mail.png", path_setup.."btn3_mail.png", 95, 483, 100, 32)
	local Fa = btn_DelMailInfo:AddFont("皋老昏力", 15, 8, 0, 0, 100, 32, 0xffffff)
	Fa:SetTouchEnabled(0)
	btn_TackMailInfo = img_MailInfoBg:AddButton(path_setup.."btn1_mail.png", path_setup.."btn2_mail.png", path_setup.."btn3_mail.png", 300, 483, 100, 32)
	local Fb = btn_TackMailInfo:AddFont("拱前罐扁", 15, 8, 0, 0, 100, 32, 0xffffff)
	Fb:SetTouchEnabled(0)
	btn_DelMailInfo.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XDeleteMail(1)
	end
	
	btn_TackMailInfo.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XTackItem(1)
	end
	btn_CloseInfo = img_MailInfoBg:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",465,7,35,35)
	btn_CloseInfo.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XCloseMailContent(1)
	end
	
	g_setup_mail_ui:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	
    img_MailBg.script[XE_LBDOWN] = function()
	    g_setup_mail_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = g_setup_mail_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	img_MailBg.script[XE_LBUP] = function()
	    g_setup_mail_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	g_setup_mail_ui.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(g_setup_mail_ui:IsVisible()) then
		    local x = XGetCursorPosX()
			local y = XGetCursorPosY()
			local w,h = img_MailBg:GetWH()
			local PosX
			local PosY
            PosX = x- pullPosX
			if(PosX < 0) then
			    PosX = 0
			elseif(PosX > windowswidth-w)	then
			    PosX = windowswidth - w
			end
			PosY = y- pullPosY
			if(PosY < 0) then
			    PosY = 0
			elseif(PosY > windowsheight - h)	then
			    PosY = windowsheight - h
			end			
		    g_setup_mail_ui:SetAbsolutePosition(PosX,PosY)
		else
	        g_setup_mail_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
	
end


-- 清空，初始化邮件数据
function InitMailInfo()
	if (#MailInfo > 0) then
		MailInfo = {}
		MailInfo.Date = {}
		MailInfo.LastDay = {}
		MailInfo.IsOpen = {}
		MailInfo.IsSel = {}
		MailInfo.IsCheck = {}
		MailInfo.IsHaveItem = {}
	end
	
	int_CurPage = 1
	int_AllCount = 0
	int_AllPage = 1
	int_Count = 0
	
	for i = 1, 9 do
		btn_CheckFrame.Choose[i]:SetVisible(0)
	end
end

-- 清楚邮件详细信息
function ClearMailInfo()
	MailInfo_Title = ""
	MailInfo_Content = ""
	MailInfo_Time = ""
	MailInfo_Money = 0
	MailInfo_Exp = 0
	for i = 1, 6 do
		MailInfo_IconPath[i] = ""
		MailInfo_IconPath1[i] = ""
		MailInfo_IconPath2[i] = ""
		MailInfoItemLlist[i]:SetVisible(0)
	end
end

-- 从C中获取邮件信息，调此函数前务必先清空表内数据
function GetMailInfoFromC( cTitle, cDate, cLastDay, cIsNew, index, cIsHaveItem)
	local i = index
	MailInfo[i] = cTitle
	MailInfo.Date[i] = cDate
	MailInfo.LastDay[i] = cLastDay
	MailInfo.IsOpen[i] = cIsNew

	MailInfo.IsCheck[i] = 0
	MailInfo.IsSel[i] = 0
	MailInfo.IsHaveItem[i] = cIsHaveItem
end

-- 得到邮件详细内容
function GetMailInfo(cTitle, cContent, cTime, cMoney, cExp, cCount1, cCount2, cCount3, cCount4, cCount5, cCount6)
	MailInfo_Title = cTitle
	MailInfo_Content = cContent
	MailInfo_Time = cTime
	MailInfo_Money = cMoney
	MailInfo_Exp = cExp
	MailInfoItemLlist.CountI[1] = cCount1
	MailInfoItemLlist.CountI[2] = cCount2
	MailInfoItemLlist.CountI[3] = cCount3
	MailInfoItemLlist.CountI[4] = cCount4
	MailInfoItemLlist.CountI[5] = cCount5
	MailInfoItemLlist.CountI[6] = cCount6
	return ReFreshInfo()
end

function SetMailIconPathData( path1, path2, path3, cindex)
	MailInfo_IconPath[cindex] = path1
	MailInfo_IconPath1[cindex] = path2
	MailInfo_IconPath2[cindex] = path3
end

-- 得到邮件相关数量
function GetMailCount( cAllCount, cCount)
	int_AllCount = cAllCount
	int_Count = cCount
	if int_ClickType == 0 or int_ClickType == 1 then
		--log("\nint_ClickType = "..int_ClickType)
		SendMailNumToLua(cCount)
	end
end

-- 重绘
function ReFresh()
	local iCount = 0
	font_CountFont:SetFontText(int_AllCount, 0xffffffff)
	
	for i = 1, 8 do
		if (MailInfo[i] == nil) then
			btn_CheckFrame[i+1]:SetVisible(0)
			MailItemList[i]:SetVisible(0)
		else
			btn_CheckFrame[i+1]:SetVisible(1)
			MailItemList[i]:SetVisible(1)
			iCount = iCount + 1
		end
	end
	
	font_Page:SetFontText(int_CurPage.."/"..int_AllPage, 0xffffffff)
	-- font_AllCount:SetFontText(int_AllCount, 0xffffffff)
	-- if int_ClickType == 0 or int_ClickType == 1 then
	-- end
	
	if (iCount == 0) then
		return
	end
	
	for i = 1, iCount do
		MailItemList.Name[i]:SetFontText(MailInfo[i], 0xff87ced4)
		MailItemList.Date[i]:SetFontText(MailInfo.Date[i], 0xff87ced4)
		MailItemList.LastDay[i]:SetFontText(MailInfo.LastDay[i].."老", 0xff87ced4)
		if (MailInfo.IsOpen[i] == 0) then
			MailItemList.MailIcon[i].changeimage(path_setup.."youjian2_mail.png")
		else
			MailItemList.MailIcon[i].changeimage(path_setup.."youjian1_mail.png")
		end
		
		if MailInfo.IsHaveItem[i]>0 then
			MailItemList.IsHave[i]:SetVisible(1)
		else
			MailItemList.IsHave[i]:SetVisible(0)
		end
	end
end

function ReFreshInfo()
	font_MailInfoName:SetFontText(MailInfo_Title, 0xff87ced4)
	font_MailInfo:SetFontText(MailInfo_Content, 0xffffffff)
	font_MailInfoLastDay:SetFontText(MailInfo_Time, 0xc23452)
	font_Money:SetFontText(tostring(MailInfo_Money), 0xfff0e18e)
	font_Exp:SetFontText(tostring(MailInfo_Exp), 0xff53e787)
	for i = 1, 6 do
		if MailInfo_IconPath[i] == "" then
			break
		end
		MailInfoItemLlist[i]:SetVisible(1)
		MailInfoItemLlist.Icon[i].changeimageMultiple( "..\\" .. MailInfo_IconPath[i], "..\\" .. MailInfo_IconPath1[i], "..\\" .. MailInfo_IconPath2[i])
		MailInfoItemLlist.CountF[i]:SetFontText(tostring(MailInfoItemLlist.CountI[i]), 0xffffffff)
	end
end

function SetMailContentTipInfo(ctip, cindex)
	XSetImageTip(MailInfoItemLlist.Icon[cindex+1].id, ctip)
end

function ClearCheckBtn()
	for i = 1, 9 do
		btn_CheckFrame.Choose[i]:SetVisible(0)
	end
	for i = 1, 8 do
		img_SelList[i]:SetVisible(0)
	end
end

function SetPageCount(index, count)
	int_CurPage = index
	int_AllPage = count
	if int_CurPage==1 then
		btn_LeftPage:SetEnabled(0)
	else
		btn_LeftPage:SetEnabled(1)
	end
	if int_CurPage==int_AllPage then
		btn_RightPage:SetEnabled(0)
	else
		btn_RightPage:SetEnabled(1)
	end
end

function SetMailInfoVisible(cVisible)
	img_MailInfoBg:SetVisible(cVisible)
end

function VisibleAllMailList()
	for i = 1, 8 do
		MailInfo[i]:SetVisible(0)
	end
end

-------------设置显示
function SetMailIsVisible(flag) 
	if g_setup_mail_ui ~= nil then
		if flag == 1 and g_setup_mail_ui:IsVisible() == false then
			g_setup_mail_ui:CreateResource()
			img_CountFrame:SetPosition(75, 53)
			int_ClickType = 0
			XClickCheckBtnMail(1, int_ClickType)
			chk_All[1]:SetVisible(0)
			chk_All[2]:SetVisible(1)
			chk_UnRead[1]:SetVisible(1)
			chk_UnRead[2]:SetVisible(0)
			chk_Readed[1]:SetVisible(1)
			chk_Readed[2]:SetVisible(0)
			for i = 1, 8 do
				img_SelList[i]:SetVisible(0)
			end
			
			g_setup_mail_ui:SetVisible(1)
			XGetMailUiIsVisible(1, 1)
			if img_MailInfoBg:IsVisible()==true then
				img_MailInfoBg:SetVisible(0)
			end
		elseif flag == 0 and g_setup_mail_ui:IsVisible() == true then
			g_setup_mail_ui:DeleteResource()
			g_setup_mail_ui:SetVisible(0)
			XGetMailUiIsVisible(1, 0)
		end
	end
end

function GetMailIsVisible()  
    if(g_setup_mail_ui:IsVisible()) then
       XMailIsOpen(1)
    else
       XMailIsOpen(0)
    end
end