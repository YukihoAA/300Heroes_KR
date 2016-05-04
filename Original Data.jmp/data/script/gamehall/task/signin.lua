-- include("../Data/Script/Common/include.lua")
-- include("../Data/Script/Common/window.lua")


-- local checkA = nil

-- local Cover = {}				-----遮罩系列
-- local CoverNotThisMonth = {}	-----非当月（深遮罩）
-- local CoverAreadyPass = {}		-----已经过了（浅遮罩）
-- local CoverIsSignInCheck = {}	-----已经登陆的勾

-- local Year = 0			     	-----年
-- local Month = 0				    -----月
-- local Day = 0				    -----日
-- local Weeks = 0      		    -----第一天的INDEX
-- local MonthDays = 0				-----当月天数
-- local IsSignIn = {}			    -----签到状态
-- local Index = 0
-- -----日历信息
-- local DateDay =  {}	  			-----日历日期文字
-- local SignInReward = {}			-----每日登陆奖励
-- local SignInRewardBK = {}		-----每日登陆的奖励背景
-- local SignInRewardFrame = {}	-----每日登陆奖励的框

-- local SignIn_PosX = {}			-----日历格子的X坐标
-- local SignIn_PosY	= {}		-----日历格子的Y坐标

-- local FramePosY = {}			-----框的Y坐标


-- -----当天签到信息
-- local curYear = 0			
-- local curMonth = 0	
-- local curDay = 0	
-- local curWeeks = 0 

-- local Today = nil    	  	    -----当天高亮框

-- local YearFont = nil
-- local MonthFont = nil

-- local CalendarLeft = nil		-----日历左翻
-- local CalendarRight = nil		-----日历右翻

-- local BK = nil
-- local Flip_BK = nil 			-----登陆弹窗背景
-- local Flip_BTN = nil			-----弹窗关闭按钮

-- local IsCanVisible = true		-----弹窗是否可见

-- -- local number = 0                ----是否今天第一次登陆（控制签到弹窗）
-- local number1 = 0				-----控制记录当天登陆
-- local PositionToday_x,PositionToday_y = 0,0 -----当日标亮的偏移量
-- local number2 = 0				-----当日标亮的偏移量只计算一次

-- local NotThisMonth_Frame = {}

-- function InitsigninUI(wnd, bisopen)
	-- g_signin_ui = CreateWindow(wnd.id, 0, 115, 700, 650)
	-- InitMainsignin(g_signin_ui)
	-- g_signin_ui:SetVisible(bisopen)
-- end

-- function InitMainsignin(wnd)
	-- Flip_BK = wnd:AddImage(path_task.."BK3_sign.png",0,0,702,654)

	-- checkA = wnd:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png",175,13,27,36)
	-- CalendarLeft = checkA
	-- CalendarLeft.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- XPreDateInfo(1)
	-- end
	
	-- checkA:AddImage(path_task.."yearAmonth_sign.png",106,8,256,32)
	-- YearFont = wnd:AddFont(Year,18,0,220,19,200,30,0x7ed4e5)
	-- MonthFont = wnd:AddFont(Month,18,0,305,19,200,30,0x7ed4e5)
	-- checkA:AddFont("提升VIP等级",15,0,376,14,200,20,0x7ed4e5)
	-- local btn_VIPLvUp = wnd:AddButton(path_info.."indexnil_vip.png",path_info.."indexnil_vip.png",path_info.."indexnil_vip.png",445,160,128,32)
	
	-- btn_VIPLvUp:SetTransparent(0)
	-- btn_VIPLvUp.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- XGameSigninToAddMoney(1)
	-- end
	-- checkA:AddImage(path_task.."SignInPo_sign.png",-25,-4,433,79)
	-- CalendarRight =  wnd:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png",468,13,27,36)
	-- XWindowEnableAlphaTouch(CalendarLeft.id)
	-- XWindowEnableAlphaTouch(CalendarRight.id)	
	-- CalendarRight.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- XNextDateInfo(1)
	-- end
	-- for i=1,7 do
		-- checkA:AddImage(path_task..i.."_sign.png",-113+87*(i-1),52,64,32)
	-- end	
	
	-- checkA:AddImage(path_task.."BK_sign.png",-132,77,610,523)
	
	-- for idx = 1,42 do
		-- SignIn_PosX[idx] = 87*((idx-1)%7+1)
		-- SignIn_PosY[idx] = math.ceil(idx/7)*87
		-- SignInRewardBK[idx] = wnd:AddImage(path_equip.."bag_equip.png", SignIn_PosX[idx]-26, SignIn_PosY[idx]+22, 50, 50)
		-- SignInRewardFrame[idx] = wnd:AddImage(path_shop.."iconside_shop.png",  SignIn_PosX[idx]-24, SignIn_PosY[idx]+20, 54, 54)
		-- SignInRewardBK[idx]:SetVisible(0)
		-- SignInRewardFrame[idx]:SetVisible(0)
		-- DateDay[idx] = SignInRewardBK[idx]:AddFont("1", 12, 8, 20, 13, 22, 11,0x7872b0)
		-- -- DateDay[idx] = wnd:AddFont("1", 12, 8, SignIn_PosX[idx]-6, SignIn_PosY[idx]+35, 22, 11,0x7872b0)
		-- CoverNotThisMonth[idx] = wnd:AddImage(path_task.."deep_sign.png",SignIn_PosX[idx]-44,SignIn_PosY[idx]+4,87,87)
		-- CoverAreadyPass[idx] = wnd:AddImage(path_task.."light_sign.png",SignIn_PosX[idx]-44,SignIn_PosY[idx]+4,86,87)
		-- CoverIsSignInCheck[idx] = wnd:AddImage(path_task.."SignIned_sign.png", SignIn_PosX[idx]-14, SignIn_PosY[idx]+31, 64, 64)
		-- CoverNotThisMonth[idx]:SetVisible(0)
		-- CoverAreadyPass[idx]:SetVisible(0)
		-- CoverIsSignInCheck[idx]:SetVisible(0)
	-- end
		
	-- --BK:SetVisible(1)
	-- Flip_BK:SetVisible(1)
	
	-- Flip_BTN = Flip_BK:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",656,7,35,35)
	-- Flip_BTN.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- IsCanVisible = false
		-- g_signin_ui:SetVisible(0)
	-- end
	
	-- checkA:AddFont("每天登陆游戏会自动签到，签到有礼奖励以邮件形式发送！",12,0,10,607,350,13,0x7ed4e5)
	
	-- Today = wnd:AddImage(path_task.."hover_sign.png",0,0,88,88)
	-- Today:SetVisible(0)
	
-- end

-- function RefreshSignIn()
	-- for i = 1,42 do
		-- DateDay[i]:SetFontText(" ",0x7872b0)
		-- SignInRewardBK[i]:SetVisible(0)
		-- SignInRewardFrame[i]:SetVisible(0)	
		-- CoverNotThisMonth[i]:SetVisible(0)
		-- CoverAreadyPass[i]:SetVisible(0)
		-- CoverIsSignInCheck[i]:SetVisible(0)
		-- Today:SetVisible(0)
	-- end

	-- -----画日历
	-- for i = 1, MonthDays do
		-- DateDay[i+Weeks-1]:SetFontText(tostring(i),0x7872b0)
        -- SignInRewardBK[i+Weeks-1]:SetVisible(1)
		-- SignInRewardFrame[i+Weeks-1]:SetVisible(1)
	-- end
	-- -----非当月遮罩
	-- for i = 1,Weeks-1  do
		-- CoverNotThisMonth[i]:SetVisible(1)
	-- end
	-- for i=MonthDays+Weeks,42 do
		-- CoverNotThisMonth[i]:SetVisible(1)
	-- end 


	-- -----已过遮罩
	-- if Year <= curYear then
		-- if Month <curMonth then
			-- for i = Weeks, MonthDays+Weeks-1 do
				-- CoverAreadyPass[i]:SetVisible(1)
			-- end
		-- elseif	Year == curYear and Month == curMonth then
			-- for i = Weeks, curDay+Weeks-2 do
				-- CoverAreadyPass[i]:SetVisible(1)
			-- end
		-- elseif Year < curYear and Month >= curMonth then
			-- for i = Weeks, MonthDays+Weeks-1 do
				-- CoverAreadyPass[i]:SetVisible(1)
			-- end
		-- else	
			-- for i = 1, 42 do
				-- CoverAreadyPass[i]:SetVisible(0)
			-- end
		-- end	
	-- end	

	-- -----当日标亮
	-- if Year == curYear and Month == curMonth then
		-- if number2 == 0 then
			-- PositionToday_x,PositionToday_y = CoverAreadyPass[Day+Weeks-1]:GetPosition()
			-- local PositionInit_x,PositionInit_y = Today:GetPosition()
			-- -----控制登陆弹窗和活动时候的偏移量一致
			-- PositionToday_x = PositionToday_x - PositionInit_x
			-- PositionToday_y = PositionToday_y - PositionInit_y
			-- Today:SetPosition(PositionToday_x-7,PositionToday_y-8)
		-- end
		-- number2 = number2 + 1
		-- Today:SetVisible(1)	
	-- end	
-- end

-- -----绘制当月签到标记
-- function IsMonthSignIn()
	-- for i = 1,42 do
		-- CoverIsSignInCheck[i]:SetVisible(0)
	-- end
	-- for i = 1,MonthDays do
		-- if IsSignIn[i] == 1 then
			-- CoverIsSignInCheck[i+Weeks-1]:SetVisible(1)
		-- end
	-- end
-- end	

-- -----接收C++传来的日历信息
-- function Sign_ReceiveDate(m_year,m_month,m_day,m_weeks,m_weekdays)
	-- Year = m_year
	-- Month = m_month
	-- Day = m_day
	-- Weeks = m_weeks + 1
	-- MonthDays = m_weekdays
	-- YearFont:SetFontText(Year,0x7ed4e5)
	-- MonthFont:SetFontText(Month,0x7ed4e5)

	-- if number1 ==0 then
		-- curYear = m_year
		-- curMonth = m_month
		-- curDay = m_day
		-- curWeeks = m_weeks
		-- number1 = number1+1 
	-- end
	-- RefreshSignIn()
-- end
-- -----接收签到信息
-- function Sign_ReceiveSignIn(DayIndex,IsCheck)
	-- IsSignIn[DayIndex] = IsCheck
	-- if IsSignIn[DayIndex] == 1 then
		-- CoverIsSignInCheck[DayIndex+Weeks-1]:SetVisible(1)
	-- end
-- end
-- -----设置偏移量
-- function SetSigninUIPos(posx,posy)
	-- local L,T = g_signin_ui:GetPosition()
	-- g_signin_ui:SetPosition(L+posx,T+posy)
	-- local Lk,Tk = g_signin_ui:GetPosition()
-- end
-- -----弹窗背景是否可见
-- function SetBKIsVisible(flag)
	-- if flag == 1 then
		-- --BK:SetVisible(1)
		-- Flip_BK:SetVisible(1)
		-- --RefreshSignIn()

	-- elseif flag == 0 then
		-- --BK:SetVisible(0)
		-- IsCanVisible = true
		-- Flip_BK:SetVisible(0)
	-- end	
-- end

-- function SetsigninIsVisible(flag)
	-- -- if g_signin_ui ~= nil then
		-- -- if flag == 1 and IsCanVisible == true then
			-- -- g_signin_ui:SetVisible(1)
			-- -- XSignInDateInfo(1)
		-- -- elseif flag == 0 then
			-- -- g_signin_ui:SetVisible(0)
		-- -- end
	-- -- end
-- end

-- function GetsigninIsVisible()  
    -- if(g_signin_ui:IsVisible()) then
       -- -- XGameHeroSkinIsOpen(1)
    -- else
       -- -- XGameHeroSkinIsOpen(0)
    -- end
-- end