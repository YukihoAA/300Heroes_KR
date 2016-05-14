include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local Click_btn = nil
local Click_dirR = nil

local checkA = nil
local checkB = nil
local checkC = nil
local checkD = nil

local checkA_ui = nil
local checkB_ui = nil
local checkC_ui = nil
local checkD_ui = nil
-----4个滚动条的上次位置
local Many_A = 0
local Many_B = 0
local Many_C = 0
local Many_D = 0

------首次充值文字
local Gold_lv = {10,50,100,300,500,1000,2000,0,3000,0,5000,0}
local Charge_posY = {}
local Charge_Font = {}
local updownCount = 0
local maxUpdown = 0

local posx = {}
local posy = {}
local Charge_Icon = {}
local Charge_Side = {}
local A_ToggleBTN = nil
local B_ToggleBTN = nil
local C_ToggleBTN = nil
local D_ToggleBTN = nil
-----累计充值文字
local Gold_total = {100,300,500,1000,2000,3000,5000,10000,30000,50000}
local Total_posY = {}
local Total_Font = {}
local Charge_total = nil

-----超值限购UI
local Gift_A = {}
local Gift_posY = {}
local gift_font = {"新手礼包","战场礼包","战场礼包","战场礼包","战场礼包"}

local YY_posy = {}
local YY_Font = {}

local Font_name = {"嘉年华首胜","三爷礼包","金闪闪礼包","嘉","三爷","金闪闪","金闪闪礼","嘉年华首胜了","三爷礼包啊","金闪闪的礼包"}
local Font_detail = {"活动期间获得一场战场的首胜","活动期间累计10场竞技场或战场的胜利","活动期间SOLO胜利10次","活动期间SOLO胜利10次","活动期间SOLO胜利10次","活动期间SOLO胜利10次",
"活动期间SOLO胜利10次","活动期间SOLO胜利10次","活动期间SOLO胜利10次","活动期间SOLO胜利10次"}


local Charge_image = {}
local Charge_side = {}
local Charge_num = {}
local Total_image = {}
local Total_side = {}
local Gift_image = {}
local Gift_side = {}
local YY_image ={}
local YY_side = {}
--------运营活动UI
local YY_btn_finish = {}
local YY_finish_font = {}
local YY_finish = {}

local wordSetMoney = {}

local WanCheng = nil
local WeiWanCheng = nil

function InitTask_limittimeUI(wnd, bisopen)
	g_task_limittime_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainTask_limittime(g_task_limittime_ui)
	g_task_limittime_ui:SetVisible(bisopen)
end
function InitMainTask_limittime(wnd)
	wnd:AddImage(path_task.."BK_task.png",130,137,1000,584)
	wnd:AddImage(path_task.."font2_task.png",585,165,128,32)
	
	checkA = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check3_equip.png",163,203,256,64)
	checkA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(163,203)
		Click_dirR:SetPosition(370,213)
		checkA_ui:SetVisible(1)
		checkB_ui:SetVisible(0)
		checkC_ui:SetVisible(0)
		checkD_ui:SetVisible(0)
		XLclickFirstPay(1)
	end
	checkB = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check3_equip.png",163,260,256,64)
	checkB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(163,260)
		Click_dirR:SetPosition(370,270)
		
		checkA_ui:SetVisible(0)
		checkB_ui:SetVisible(1)
		checkC_ui:SetVisible(0)
		checkD_ui:SetVisible(0)
		XLclickLimitTimeBuy(1)
	end
	checkC = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check3_equip.png",163,317,256,64)
	checkC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(163,317)
		Click_dirR:SetPosition(370,327)
		
		checkA_ui:SetVisible(0)
		checkB_ui:SetVisible(0)
		checkC_ui:SetVisible(1)
		checkD_ui:SetVisible(0)
	end
	checkD = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check3_equip.png",163,374,256,64)
	checkD.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(163,374)
		Click_dirR:SetPosition(370,384)
		
		checkA_ui:SetVisible(0)
		checkB_ui:SetVisible(0)
		checkC_ui:SetVisible(0)
		checkD_ui:SetVisible(1)
		XLclickActivityinterface(1)
	end
	
	
	
	Click_btn = wnd:AddImage(path_equip.."check3_equip.png",163,203,256,64)
	Click_dirR = wnd:AddImage(path_info.."R2_info.png",370,213,27,36)
	
	checkB:SetVisible(0)
	checkC:SetVisible(0)
	checkD:SetVisible(0)
	wnd:AddFont("首充大礼",15, 0, 225, 224, 100, 20, 0xbcbcc4)
	--wnd:AddFont("超值限购",15, 0, 225, 281, 100, 20, 0xbcbcc4)
	--wnd:AddFont("累计充值",15, 0, 225, 338, 100, 20, 0xbcbcc4)
	--wnd:AddFont("运营活动",15, 0, 225, 395, 100, 20, 0xbcbcc4)

	
	
	-- 首冲大礼UI
	checkA_ui = CreateWindow(wnd.id, 400, 200, 720, 510)
	-- checkA_ui:AddImage(path_task.."once_task.png",35,20,128,64)
	checkA_ui:AddFont("第一次充值", 15, 0, 156-128, 22, 200, 15, 0x6ffefc)
	checkA_ui:AddFont("达到对应数额即送豪华礼包", 15, 0, 238-128, 22, 200, 13, 0x7f94cd)
	checkA_ui:AddFont("充值可获得VIP积分 免费兑换绝版英雄和道具", 15, 0, 153-128, 47, 350, 13, 0x7f94cd)
	wordSetMoney = checkA_ui:AddFont("首冲完成\n奖励以邮件发送",15, 0, -180, 65, 100, 50, 0x6ffefc)
	wordSetMoney:SetVisible(0)
	-- 充值按钮
	local btn_reCharge = checkA_ui:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",505,14, 179, 56)
	btn_reCharge:AddFont("充 值", 15, 0, 60, 15, 72, 20, 0xbeb9cf)
	btn_reCharge.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToAddMoney(1)
	end

	checkA_ui:AddImage(path_task.."partition_sign.png",40,80+10,621,2)
	checkA_ui:AddImage(path_task.."partition_sign.png",40,475+10,621,2)
	-- 首次充值等文字UI
	
	for i=1,12 do
		Charge_posY[i] = 63*i+32+10
		Charge_Font[i] = checkA_ui:AddImage(path_equip.."bag_equip.png",45,Charge_posY[i],50,50)
		Charge_Font[i]:SetTransparent(0)
		if(i~= 8 and i ~= 10 and i ~= 12) then
		    Charge_Font[i]:AddFont("首次充值", 15, 0, 0, 10, 100, 20, 0x7f94cd)
		    Charge_Font[i]:AddFont("单笔满", 15, 0, -20, 35, 100, 20, 0x7f94cd)
		    Charge_Font[i]:AddFont(Gold_lv[i].." 钻石", 15, 0, 25, 35, 100, 20, 0x6ffefc)
		end	
		if(i~= 7 and i ~= 9 and i ~= 11) then
		    Charge_Font[i]:AddImage(path_info.."payBackLight.png",10,56,576,1)
		end
		
		for k=1,8 do
			Charge_image[i*8-8+k] = Charge_Font[i]:AddImage(path_equip.."bag_equip.png",61*k+45,0,50,50)
			Charge_image[i*8-8+k]:SetVisible(0)
			Charge_side[i*8-8+k] = Charge_Font[i]:AddImage(path_shop.."iconside_shop.png",61*k+45-2,-2,54, 54)
			Charge_side[i*8-8+k]:SetVisible(0)
			Charge_num[i*8-8+k] = Charge_image[i*8-8+k]:AddFont("0",12,6,-47,-37,100,20,0xFFFFFF)
			Charge_num[i*8-8+k]:SetFontBackground()
		end
		
		
		if Charge_posY[i] >450 or Charge_posY[i] <50 then
			Charge_Font[i]:SetVisible(0)
		else
			Charge_Font[i]:SetVisible(1)
		end
		
	end
	
	
	-- 右边滚动条
	local A_ToggleBK = checkA_ui:AddImage(path.."toggleBK_main.png",667,105,16,368)
	A_ToggleBTN = A_ToggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = A_ToggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = A_ToggleBK:AddImage(path.."TD1_main.png",0,368,16,16)
	
	XSetWindowFlag(A_ToggleBTN.id,1,1,0,318)
	
	A_ToggleBTN:ToggleBehaviour(XE_ONUPDATE, 1)
	A_ToggleBTN:ToggleEvent(XE_ONUPDATE, 1)
	A_ToggleBTN.script[XE_ONUPDATE] = function()
		if A_ToggleBTN._T == nil then
			A_ToggleBTN._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(A_ToggleBTN.id)
		if A_ToggleBTN._T ~= T then
			if #Charge_Font <=6 then
				length = 318
			else
				length = 318/math.ceil(#Charge_Font-6)
			end
			local Many = math.floor(T/length)
			updownCount = Many
			if Many_A ~= Many then
			
				for i,value in pairs(Charge_Font) do
					local Ti = Charge_posY[i]-Many*63
					
					Charge_Font[i]:SetPosition(45, Ti)
					
					if Ti >450 or Ti <50 then
						Charge_Font[i]:SetVisible(0)
					else
						Charge_Font[i]:SetVisible(1)
					end
				end
				Many_A = Many
			end
			A_ToggleBTN._T = T
		end
	end
	XWindowEnableAlphaTouch(checkA_ui.id)
	checkA_ui:EnableEvent(XE_MOUSEWHEEL)
	checkA_ui.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		local length = 54
		maxUpdown = 6
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
		local btn_pos = length*updownCount
	
		A_ToggleBTN:SetPosition(0,btn_pos)
		A_ToggleBTN._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			for i,value in pairs(Charge_Font) do
				local Ti = Charge_posY[i]-updownCount*63
				
				Charge_Font[i]:SetPosition(45, Ti)				
				if Ti >450 or Ti <50 then
					Charge_Font[i]:SetVisible(0)
				else
					Charge_Font[i]:SetVisible(1)
				end
			end
		end
	end
	--checkA_ui:AddFont("每个UI下方预留着一小行文字的空间，作为需要文字提醒的备用A", 11, 0, 200, 485, 400, 20, 0x7f94cd)
	
	
	----------超值限购UI
	checkB_ui = CreateWindow(wnd.id, 400, 200, 720, 510)
	checkB_ui:AddFont("超值礼包每日",18, 0, 244, 30, 200, 20, 0x8197d3)
	checkB_ui:AddFont("限购一次", 18, 0, 355, 30, 200, 20, 0x6ffefc)
	checkB_ui:AddImage(path_task.."partition_sign.png",40,90,621,2)
	checkB_ui:AddImage(path_task.."partition_sign.png",40,290,621,2)
	checkB_ui:AddImage(path_task.."partition_sign.png",40,485,621,2)
	
	
	for i=1,5 do
		Gift_posY[i] = 204*i-130+40
		Gift_A[i] = checkB_ui:AddImage(path_equip.."bag_equip.png",245,Gift_posY[i],50,50)
		Gift_A[i]:AddImage(path_shop.."iconside_shop.png",-2,-2,54, 54)
		
		Gift_A[i]:AddFont(gift_font[i], 15, 8, 30, -60, 110, 20, 0x7f94cd)
		Gift_A[i]:AddFont("礼包预览", 15, 0, -173, 70, 100, 20, 0x7f94cd)
		
		for k=1,5 do
			Gift_image[i*5-5+k] = Gift_A[i]:AddImage(path_equip.."bag_equip.png",93*k+32-245,104,50,50)
			Gift_side[i*5-5+k] = Gift_A[i]:AddImage(path_shop.."iconside_shop.png",93*k+32-245-2,104-2,54, 54)
		end
		
		local left = Gift_A[i]:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png",-180,115,27,36)
		local right = Gift_A[i]:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png",340,115,27,36)
		XWindowEnableAlphaTouch(left.id)
		XWindowEnableAlphaTouch(right.id)	
		Gift_A[i]:AddImage(path_shop.."gold_shop.png",96,5,64,64)
		Gift_A[i]:AddFont("12950", 15, 0, 130, 10, 100, 20, 0x6ffefc)
		Gift_A[i]:AddFont("0/1", 15, 0, 230, 43, 100, 20, 0x6ffefc)
		local btn_buy = Gift_A[i]:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",92,36,100,32)
		btn_buy:AddFont("购买", 15, 8, 0, 0, 100, 32, 0xffffff)
		
		if Gift_posY[i] >450 or Gift_posY[i] <50 then
			Gift_A[i]:SetVisible(0)
		else
			Gift_A[i]:SetVisible(1)
		end
	end
	
	---右边滚动条
	local B_ToggleBK = checkB_ui:AddImage(path.."toggleBK_main.png",667,105,16,368)
	B_ToggleBTN = B_ToggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = B_ToggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = B_ToggleBK:AddImage(path.."TD1_main.png",0,368,16,16)
	XSetWindowFlag(B_ToggleBTN.id,1,1,0,318)
	
	B_ToggleBTN:ToggleBehaviour(XE_ONUPDATE, 1)
	B_ToggleBTN:ToggleEvent(XE_ONUPDATE, 1)
	B_ToggleBTN.script[XE_ONUPDATE] = function()
		if B_ToggleBTN._T == nil then
			B_ToggleBTN._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(B_ToggleBTN.id)
		if B_ToggleBTN._T ~= T then
			if #Gift_A <=2 then
				length = 318
			else
				length = 318/math.ceil(#Gift_A-2)
			end
			local Many = math.floor(T/length)
			
			if Many_B ~= Many then
				for i,value in pairs(Gift_posY) do
					local Ti = Gift_posY[i]-Many*204
					
					Gift_A[i]:SetPosition(245, Ti)
					
					if Ti >450 or Ti <50 then
						Gift_A[i]:SetVisible(0)
					else
						Gift_A[i]:SetVisible(1)
					end
				end
				Many_B = Many
			end
			B_ToggleBTN._T = T
		end
	end
	--checkB_ui:AddFont("每个UI下方预留着一小行文字的空间，作为需要文字提醒的备用B", 11, 0, 200, 485, 400, 20, 0x7f94cd)
	
	----------累计充值UI
	checkC_ui = CreateWindow(wnd.id, 400, 200, 720, 510)
	checkC_ui:AddImage(path_task.."font2_task.png", 330, 30, 128, 32)
	checkC_ui:AddFont("活动倒计时：7天23小时59分58秒", 15, 0, 40, 17, 300, 20, 0x7f94cd)
	checkC_ui:AddFont("已累计充值：", 15, 0, 40, 45, 300, 20, 0x7f94cd)
	
	--------充值按钮
	local btn_reCharge = checkC_ui:AddButton(path.."button1_hall.png", path.."button2_hall.png", path.."button3_hall.png",505,14, 179, 56)
	btn_reCharge:AddFont("充 值", 15, 0, 60, 15, 72, 20, 0xbeb9cf)
	btn_reCharge.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XGameSigninToAddMoney(1)
	end
	checkC_ui:AddImage(path_task.."partition_sign.png",40,90,621,2)
	checkC_ui:AddImage(path_task.."partition_sign.png",40,485,621,2)
	checkC_ui:AddImage(path_shop.."gold_shop.png",124,40,64,64)
	----总共充值
	Charge_total = checkC_ui:AddFont("9999", 15, 0, 160, 45, 100, 20, 0x6ffefc)
	checkC_ui:AddFont("钻石", 15, 0, 200, 45, 100, 20, 0x6ffefc)
	
	for i=1,10 do
		
		Total_posY[i] = 34+80*i+10
		Total_Font[i] = checkC_ui:AddImage(path_equip.."bag_equip.png",40,Total_posY[i],50,50)
		Total_Font[i]:SetTransparent(0)
		
		Total_Font[i]:AddFont("累计充值达到", 15, 0, 0, 0, 100, 20, 0x7f94cd)
		Total_Font[i]:AddFont(Gold_total[i].." 钻石", 15, 0, 100, 0, 100, 20, 0x6ffefc)
		
		for k=1,6 do
			Total_image[i*6-6+k] = Total_Font[i]:AddImage(path_equip.."bag_equip.png",70*k+100+30,-18,50,50)
			Total_side[i*6-6+k] = Total_Font[i]:AddImage(path_shop.."iconside_shop.png",70*k+100+30-2,-18-2,54,54)
		end
		
		if Total_posY[i] >450 or Total_posY[i] <50 then
			Total_Font[i]:SetVisible(0)
		else
			Total_Font[i]:SetVisible(1)
		end	
	end
	
	---右边滚动条
	local C_ToggleBK = checkC_ui:AddImage(path.."toggleBK_main.png",667,105,16,368)
	C_ToggleBTN = C_ToggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = C_ToggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = C_ToggleBK:AddImage(path.."TD1_main.png",0,368,16,16)
	XSetWindowFlag(C_ToggleBTN.id,1,1,0,318)
	
	C_ToggleBTN:ToggleBehaviour(XE_ONUPDATE, 1)
	C_ToggleBTN:ToggleEvent(XE_ONUPDATE, 1)
	C_ToggleBTN.script[XE_ONUPDATE] = function()
		if C_ToggleBTN._T == nil then
			C_ToggleBTN._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(C_ToggleBTN.id)
		if C_ToggleBTN._T ~= T then
		
			if #Total_Font <=5 then
				length = 400
			else
				length = math.floor(343/math.ceil(#Total_Font-5))
			end
			local Many = math.floor(T/length)
			
			if Many_C ~= Many then
				for i,value in pairs(Total_Font) do
					local Ti = Total_posY[i]-Many*80
					
					Total_Font[i]:SetPosition(40, Ti)
					
					if Ti >450 or Ti <50 then
						Total_Font[i]:SetVisible(0)
					else
						Total_Font[i]:SetVisible(1)
					end
				end
				Many_C = Many
			end
			C_ToggleBTN._T = T
		end
	end
	--checkC_ui:AddFont("每个UI下方预留着一小行文字的空间，作为需要文字提醒的备用C", 11, 0, 200, 485, 400, 20, 0x7f94cd)
	
	----------运营活动UI
	checkD_ui = CreateWindow(wnd.id, 400, 200, 720, 510)
	checkD_ui:AddFont("迎新嘉年华",18, 0, 263, 30, 200, 20, 0x7c8dbb)
	checkD_ui:AddFont("活动倒计时：", 15, 0, 40, 17, 300, 20, 0x7c8dbb)
	checkD_ui:AddFont("7天23小时59分58秒", 15, 0, 40, 45, 300, 20, 0x7c8dbb)
	checkD_ui:AddFont("活动期间对局经验、金币翻倍", 15, 0, 485, 30, 300, 20, 0x6ffefc)
	checkD_ui:AddImage(path_task.."partition_sign.png",40,90,621,2)
	
	
	for i=1,10 do
		YY_posy[i] = 130*i-40+15
		
		YY_Font[i] = checkD_ui:AddImage(path_equip.."bag_equip.png",40,YY_posy[i],50,50)
		YY_Font[i]:SetTransparent(0)
		
		YY_Font[i]:AddFont(Font_name[i], 15, 0, 0, 0, 100, 20, 0x7c8dbb)
		YY_Font[i]:AddFont(Font_detail[i], 15, 0, 0, 30, 500, 20, 0x7c8dbb)
		YY_Font[i]:AddFont("任务奖励", 15, 0, 10, 70, 100, 20, 0x7c8dbb)
		
		YY_Font[i]:AddFont("0/1", 15, 0, 265, 13, 100, 20, 0x6ffefc)
		
		if YY_posy[i] >450 or YY_posy[i] <50 then
			YY_Font[i]:SetVisible(0)
		else
			YY_Font[i]:SetVisible(1)
		end	
		checkD_ui:AddImage(path_task.."partition_sign.png",40,130*i+80+15,621,2)
		
		for k=1,5 do
			YY_image[i*5-5+k] = YY_Font[i]:AddImage(path_equip.."bag_equip.png",68*k+67,53,50,50)
			YY_side[i*5-5+k] = YY_Font[i]:AddImage(path_shop.."iconside_shop.png",68*k+67-2,53-2,54,54)
		end
		
		YY_btn_finish[i] = YY_Font[i]:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",477,6,100,32)
		YY_finish_font[i] = YY_btn_finish[i]:AddFont("前往完成", 15, 8, 0, 0, 100, 32, 0xffffff)
		
		YY_finish[i] = YY_Font[i]:AddImage(path_task.."SignIned_sign.png",510,50,64,64)
		YY_finish[i]:SetVisible(0)
		YY_btn_finish[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			-----暂时测试
			YY_finish_font[i]:SetFontText("完成",0xffffff)
			YY_finish[i]:SetVisible(1)
		end
	end
	
	
	---右边滚动条
	local D_ToggleBK = checkD_ui:AddImage(path.."toggleBK_main.png",667,105,16,368)
	D_ToggleBTN = D_ToggleBK:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = D_ToggleBK:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = D_ToggleBK:AddImage(path.."TD1_main.png",0,368,16,16)
	XSetWindowFlag(D_ToggleBTN.id,1,1,0,318)
	
	D_ToggleBTN:ToggleBehaviour(XE_ONUPDATE, 1)
	D_ToggleBTN:ToggleEvent(XE_ONUPDATE, 1)
	D_ToggleBTN.script[XE_ONUPDATE] = function()
		if D_ToggleBTN._T == nil then
			D_ToggleBTN._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(D_ToggleBTN.id)
		if D_ToggleBTN._T ~= T then
		
			if #YY_Font <=3 then
				length = 318
			else
				length = 318/math.ceil(#YY_Font-3)
			end
			local Many = math.floor(T/length)
			
			if Many_D ~= Many then
				for i,value in pairs(YY_Font) do
					local Ti = YY_posy[i]-Many*130
					
					YY_Font[i]:SetPosition(40, Ti)
					
					if Ti >450 or Ti <50 then
						YY_Font[i]:SetVisible(0)
					else
						YY_Font[i]:SetVisible(1)
					end
				end
				Many_D = Many
			end
			D_ToggleBTN._T = T
		end
	end
	
	-- checkD_ui:AddFont("每个UI下方预留着一小行文字的空间，作为需要文字提醒的备用D", 11, 0, 200, 485, 400, 20, 0x7f94cd)
	WanCheng = wnd:AddImage(path_task .. "yiwancheng.png", 150, 195, 75, 50)
	-- WeiWanCheng = wnd:AddImage(path .. "friendMes_hall.png", 305, 222, 19, 20)
end

function SetwordSetMoneyIsvisible(ibool)
    if(wordSetMoney:IsVisible() == false and ibool == 1) then
		-- log("CheckwordSetMoney_1")
		wordSetMoney:SetVisible(1)
	elseif(wordSetMoney:IsVisible() and ibool == 0) then
		-- log("CheckwordSetMoney_2")
		wordSetMoney:SetVisible(0)
	end   
	-- log("CheckwordSetMoney_3")
end

function SetFlagIsVisible()
	local bType = GetFirstCheckButtonVisible()
	-- log("\nbType = " .. bType)
	if bType==0 then
		WanCheng:SetVisible(1)
		-- WeiWanCheng:SetVisible(0)
	else
		WanCheng:SetVisible(0)
		-- WeiWanCheng:SetVisible(1)
	end
end

function XGetFirstPayItemFromVS(strPic,i,k,num,tip)
	if(i == 7 and k> 8) then
	    i = 8
	    k = k-8
	elseif(i == 8 and k <= 8) then
	    i = 9
	elseif(i == 8 and k > 8) then
	    i = 10
	    k = k-8
	elseif(i == 9 and k <= 8) then
	    i = 11
	elseif(i == 9 and k > 8) then
	    i = 12
	    k = k-8
	end	
    Charge_image[i*8-8+k].changeimage( "..\\"..strPic)
	Charge_image[i*8-8+k]:SetImageTip(tip)
	Charge_num[i*8-8+k]:SetFontText(tostring(num))
	Charge_image[i*8-8+k]:SetVisible(1)
	Charge_side[i*8-8+k]:SetVisible(1)
end

function SetTask_limittimeIsVisible(flag) 
	if g_task_limittime_ui ~= nil then
		if flag == 1 and g_task_limittime_ui:IsVisible() == false then
			g_task_limittime_ui:SetVisible(1)
			SetFlagIsVisible()
			Click_btn:SetPosition(163,203)
			Click_dirR:SetPosition(370,213)
			checkA_ui:SetVisible(1)
			checkB_ui:SetVisible(0)
			checkC_ui:SetVisible(0)
			checkD_ui:SetVisible(0)
			XLclickFirstPay(1)
			
			updownCount = 0
			maxUpdown = 0
			A_ToggleBTN:SetPosition(0,0)
			A_ToggleBTN._T = 0
		
			for i,value in pairs(Charge_Font) do
				local Ti = Charge_posY[i]
				
				Charge_Font[i]:SetPosition(45, Ti)				
				if Ti >450 or Ti <50 then
					Charge_Font[i]:SetVisible(0)
				else
					Charge_Font[i]:SetVisible(1)
				end
			end
		elseif flag == 0 and g_task_limittime_ui:IsVisible() == true then
			g_task_limittime_ui:SetVisible(0)
		end
	end
end

function GetTask_limittimeIsVisible()  
    if g_task_limittime_ui ~= nil and g_task_limittime_ui:IsVisible()  then
       return 1
    else
       return 0
    end
end
