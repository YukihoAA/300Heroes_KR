include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local check_A = nil --父
local check_1 =nil --子
local check_2 =nil --子

--check_A--
local eight_Button = {}
local eight_button_font = {"等级排行","竞技排行","战场排行","剑数排行","盾数排行","盾数排行","盾数排行","盾数排行"}
local eight_Font = {}
local check_A_RArrow = nil
local buttonExtaimage = nil
--check_1--
local day = 7
local hour = 23
local minute = 59
local second = 59
local countdown_font = "活动倒计时： "..day.."天"..hour.."小时"..minute.."分"..second.."秒"
local countdown_detail_font = "召唤师等级前100名赢得奖励"
local ranking_count_award = {7,5,5,5,5}
local award_one = {}
local award_two = {}
local award_three = {}
local award_four = {}
local award_five = {}
local award_block = {award_one,award_two,award_three,award_four,award_five}
local promote_button = nil
local name = {"虚位以待","虚位以待","虚位以待","虚位以待","虚位以待"}
local nameword = {"["..name[1].."]","["..name[2].."]","["..name[3].."]","["..name[4].."]","["..name[5].."]"}
local first = {}
local second = {}
local third = {}
local forth = {}
local fifth = {}
local awardPic = {first,second,third,forth,fifth}

--check_2--
local titleFont_1 = "活动已结束 以下是获奖名单"
local titleFont_2 = "召唤师等级前100名赢得奖励"
local name = "玩家名字七个字"
local winnerName = {} --得到奖励的玩家--
local checkMsgButton = nil









function InitTask_newserverUI(wnd, bisopen)
	g_task_newserver_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainTask_newserver(g_task_newserver_ui)
	g_task_newserver_ui:SetVisible(bisopen)
end
function InitMainTask_newserver(wnd)
	--两个check都有的--
	check_A = wnd:AddImage(path_task.."BK_task.png",130,137,1000,584)
	InitCheck_A(check_A)
	--添加下划线---
	check_1 = CreateWindow(wnd.id, 400, 140, 985, 575)
	newsever_InitCheck_1(check_1)
	check_1:SetVisible(1)
	check_2 = CreateWindow(wnd.id, 400, 140, 985, 575)
	newsever_InitCheck_2(check_2)
	check_2:SetVisible(0)
end
function newsever_InitCheck_1(wnd)
	--添加文字--
	wnd:AddFont(countdown_font,15, 0, 20, 80, 250, 20, 0x7f94cd)
	wnd:AddFont(countdown_detail_font,15, 0, 20, 105, 200, 20, 0x7f94cd)
	--添加名次--
	wnd:AddImage(path_task.."rank1_task.png",33,155,128,32)--第一名
	wnd:AddImage(path_task.."rank2-3_task.png",33,235,128,32)--2-3
	wnd:AddImage(path_task.."rank4-10_task.png",33,315,128,32)--4-10
	wnd:AddImage(path_task.."rank11-50_task.png",33,395,128,32)--11-50
	wnd:AddImage(path_task.."rank51-100_task.png",33,475,128,32)--51-100
	--添加发光线--
	for index = 1,6 do
        wnd:AddImage(path_task.."partition_sign.png",40,132+(index-1)*80,621,2)
	end
	--添加奖励包--
	for y = 1,5 do
	    for x =1,ranking_count_award[y] do
		    awardPic[y][x] = wnd:AddImage(path_equip.."bag_equip.png",205+(x-1)*65,148+(y-1)*80,50,50)
		    award_block[y][x] = wnd:AddImage(path_shop.."iconside_shop.png",205+(x-1)*65-2,148+(y-1)*80-2,54,54)			
		end
	end
	---奖杯---
	wnd:AddImage(path_task.."cup_task.png",485,80,64,64)
	promote_button = wnd:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",550,90,100,32)
	promote_button:AddFont("等级提升",15, 8, 0, 0, 100, 32, 0xbcbcc4)
	for index = 1,5 do
		wnd:AddFont(nameword[index],15,0,45,100+80*index,100,20,0xbcbcc4)
	end
end

function newsever_InitCheck_2(wnd)
    --添加标题--
   	wnd:AddFont(titleFont_1,15, 0, 20, 80, 200, 20, 0x7f94cd)
	wnd:AddFont(titleFont_2,15, 0, 20, 105, 200, 20, 0x7f94cd)
	--添加名次--
	wnd:AddImage(path_task.."A1_task.png",125,140,128,64)--第1名
	wnd:AddImage(path_task.."A2_task.png",317,140,128,64)--第2名
	wnd:AddImage(path_task.."A3_task.png",520,140,128,64)--第3名
	wnd:AddImage(path_task.."A4_task.png",33,220,64,16)--第4名
	wnd:AddImage(path_task.."A5_task.png",133,220,64,16)--第5名
	wnd:AddImage(path_task.."A6_task.png",233,220,64,16)--第6名
	wnd:AddImage(path_task.."A7_task.png",333,220,64,16)--第7名
	wnd:AddImage(path_task.."A8_task.png",433,220,64,16)--第8名
	wnd:AddImage(path_task.."A9_task.png",533,220,64,16)--第9名
	wnd:AddImage(path_task.."A10_task.png",633,220,64,16)--第10名
	wnd:AddImage(path_task.."A11_task.png",315,290,128,16)--第11-50名
	wnd:AddImage(path_task.."A12_task.png",315,408,128,16)--第51-100名
	--设置发光线--
	wnd:AddImage(path_task.."lightlineshort_task.png",165,134,512,2)
	wnd:AddImage(path_task.."lightlineshort_task.png",165,202,512,2)
	wnd:AddImage(path_task.."lightlineshort_task.png",165,273,512,2)
	wnd:AddImage(path_task.."lightlineshort_task.png",165,390,512,2)
	
	for index = 1,3 do
	    winnerName[index] = wnd:AddFont(name,15,0,105+(index-1)*202,172,150,20,0xbcbcc4)
	end
	for index = 4,10 do
	    winnerName[index] = wnd:AddFont(name,12,0,10+(index-4)*101,244,100,15,0xbcbcc4)
	end
	for index = 11,50 do --装备
	    local PosX = (index-11)%8*87+10
		local PosY = math.floor((index-11)/8)
		PosY = PosY*17+303
	    winnerName[index] = wnd:AddFont(name,12,0,PosX,PosY,100,15,0xbcbcc4)
	end	
	for index = 51,100 do --装备
	    local PosX = (index-51)%8*87+10
		local PosY = math.floor((index-51)/8)
		PosY = PosY*17+420
	    winnerName[index] = wnd:AddFont(name,12,0,PosX,PosY,100,15,0xbcbcc4)
	end	
	--添加案件
	checkMsgButton = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check3_equip.png",555,90,128,32)
	checkMsgButton:AddFont("查看邮件",15, 0, 22, 3, 100, 20, 0xbcbcc4)
end
function InitCheck_A(wnd)
	--添加标题等--
	wnd:AddImage(path_task.."newServer_task.png",455,28,128,32)--新服庆点
	wnd:AddImage(path_task.."allhappy_task.png",520,90,256,32)--新服庆典 全民狂欢
	check_A_RArrow = wnd:AddImage(path_info.."R2_info.png",240,76,27,36)
	
    --添加8个button
    for index = 1,8 do
	    local x = 66 + (index-1)*57
	    eight_Button[index] = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check3_equip.png",33,x,256,64)
		eight_Button[index].script[XE_LBUP] = function()
		    XClickPlaySound(5)
		    check_A_RArrow:SetPosition(240,76+(index-1)*57)
			buttonExtaimage:SetPosition(33,x)
		end
	end
	buttonExtaimage = wnd:AddImage(path_equip.."check3_equip.png",33,66,256,64)
	for index = 1,8 do
	    local x = 87 + (index-1)*57
	    eight_Font[index] = wnd:AddFont(eight_button_font[index],15, 0, 95, x, 100, 20, 0xbcbcc4)
	end
end



function SetTask_newserverIsVisible(flag) 
	if g_task_newserver_ui ~= nil then
		if flag == 1 and g_task_newserver_ui:IsVisible() == false then
			g_task_newserver_ui:SetVisible(1)
			
			check_A_RArrow:SetPosition(240,76)
			buttonExtaimage:SetPosition(33,66)
		elseif flag == 0 and g_task_newserver_ui:IsVisible() == true then
			g_task_newserver_ui:SetVisible(0)
		end
	end
end

function GetTask_newserverIsVisible()  
    if g_task_newserver_ui ~= nil and g_task_newserver_ui:IsVisible()  then
       return 1
    else
       return 0
    end
end