include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local check = {}

-------------------核心按键check[1]-----------------------------
local checkBtn = nil

local check_1_All_button = {}
check_1_All_button.frame = {}
check_1_All_button.font = {}
check_1_All_button.fontdetail = {"Q","W","E","R","T","D","F","1","2","3","4","5","6","Z"}--字体内容
check_1_All_button.correspondingA = {31,32,33,34,35,86,87,91,92,93,94,95,96,117}--对应快捷键
check_1_All_button.correspondingB = {41,42,43,44,35,88,89,97,98,99,100,101,102,117}--对应智能施法快捷键
check_1_All_button.check = {} 
check_1_All_button.yes = {}
-------------------按键功能check[2]-----------------------------
local check_2_All_button = {}
check_2_All_button.frame = {}
check_2_All_button.font = {}
check_2_All_button.fontdetail = {"B","SPACE","Y","C","TAB","F1","A","S","P","V","G","ALt","Ctrl","Ctrl","Ctrl","Ctrl","Ctrl","F","F12"}
check_2_All_button.correspondingA = {85,115,109,19,106,110,103,105,66,108,107}--对应快捷键暂时12个
local check_2_word ={"英雄回城","镜头到自己","锁定/自由镜头","英雄属性面板","记分牌(按住)","选定自己","攻击","英雄停止行动","打开竞技商店",
               "+左击战术面板","警告提醒","撤退提醒","+F1 表情坏笑","+F2 表情大笑","+F3 表情愤怒","+F4 表情流泪","+1-4 英雄动作","好友(大厅)","截屏"}--字体内容

-------------------战场/恶龙专用check[3]------------------------
local check_3_All_button = {}
check_3_All_button.frame = {}
check_3_All_button.font = {}
check_3_All_button.fontdetail = {"M","F2","F3","F4","O"}--字体内容
check_3_All_button.correspondingA = {65,111,112,113,20}
local check_3_word = {"游戏商城(大厅)","第一个药水栏","第二个药水栏","第三个药水栏","打开背包(大厅)"}
-------------------组合按键check[4]-----------------------------
local check_4_All_button = {}
check_4_All_button.frame = {}
check_4_All_button.font = {}
check_4_All_button.fontdetail = {"CTRL+Q","CTRL+W","CTRL+E","CTRL+R","ALT+Q","ALT+W","ALT+E","ALT+R","ALT+T"}--字体内容
check_4_All_button.correspondingA = {51,52,53,54,45,46,47,48,118}
check_4_All_button.wordfont = {"技能加点1","技能加点2","技能加点3","技能加点4","智能施法技能快捷1(对自己)","智能施法技能快捷2(对自己)","智能施法技能快捷3(对自己)","智能施法技能快捷4(对自己)",
							   "快捷密语之前密语我的玩家"}
check_4_All_button.word = {}
local check_4_sliplineback = nil
local check_4_slipline = nil
local updownCount = 0
local maxUpdown = 0
local Many_Equip = 0 		-------上次滑动按钮停留的位置
local g_item_posx = {}
local g_item_posy = {}


-------------------外部整体-----------------------------
local All_check = {}--核心按键
All_check.pic = {}
All_check.back = {}
local All_check_PathDark = {path_setup.."heartdark_setup.png",path_setup.."functiondark_setup.png",path_setup.."dragondark_setup.png",path_setup.."groupdark_setup.png"}
local All_check_PathBright = {path_setup.."heartbright_setup.png",path_setup.."functionbright_setup.png",path_setup.."dragonbright_setup.png",path_setup.."groupbright_setup.png"}

--------------------------------------------------------
local posx_move = -240
local posy_move = -150

function InitSetup_KeypressUI(wnd, bisopen)
	g_setup_keypress_ui = CreateWindow(wnd.id, (1920-1920)/2, (1080-1080)/2, 1920, 1080)
	InitMainSetup_Keypress(g_setup_keypress_ui)
	g_setup_keypress_ui:SetVisible(bisopen)
end
function InitMainSetup_Keypress(wnd)
	
	wnd:AddImage(path_setup.."BK_setup.png",0,0,793,486)
	wnd:AddImage(path_setup.."keypressfont1_setup.png",592+posx_move,162+posy_move,128,32)
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",985+posx_move,160+posy_move,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupIsVisible(0)
	end
	local btn_back = wnd:AddButton(path_setup.."back1_setup.png",path_setup.."back2_setup.png",path_setup.."back3_setup.png",290+posx_move,560+posy_move,164,49)
	btn_back:AddFont("返回设置",15, 0, 50, 14, 100, 20, 0xffffff)
	btn_back.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupKeypressIsVisible(0)
		--Set_SetupIsVisible(1)
	end
	local btn_return= wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",645+posx_move,560+posy_move,164,49)
	btn_return:AddFont("恢复默认",15, 0, 50, 15, 100, 20, 0xffffff)
	btn_return.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if(check[1]:IsVisible()) then
		    XLwantReturnACQ(1)--回复默认设置
		elseif(check[2]:IsVisible()) then
		    XLwantReturnACQ(2)--回复默认设置
		elseif(check[3]:IsVisible()) then
		    XLwantReturnACQ(3)--回复默认设置
		elseif(check[4]:IsVisible()) then
		    XLwantReturnACQ(4)--回复默认设置
		end
	end
	local btn_apply = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",815+posx_move,560+posy_move,164,49)
	btn_apply:AddFont("确认",15, 0, 65, 15, 100, 20, 0xffffff)
	btn_apply.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XLKeypressLwantApply(1)
	end
	-- local btn_cancel = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",815+posx_move,560+posy_move,164,49)
	-- btn_cancel:AddFont("取消",15, 0, 65, 15, 100, 20, 0xffffff)
	-- btn_cancel.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- XLKeypressLwantCancel(1)
		-- Set_SetupKeypressIsVisible(0)
	-- end
	---创建---
	Keypress_InitOutside(wnd)
	check[1] = CreateWindow(wnd.id, 250+posx_move, 240+posy_move, 775, 305)
	check[1]:SetTouchEnabled(1)
	check[1]:SetVisible(1)
	Keypress_InitCheck_1(check[1])
	check[2] = CreateWindow(wnd.id, 250+posx_move, 240+posy_move, 775, 305)
	check[2]:SetTouchEnabled(0)
	check[2]:SetVisible(0)
	Keypress_InitCheck_2(check[2])
	check[3] = CreateWindow(wnd.id, 250+posx_move, 240+posy_move, 775, 305)
	check[3]:SetTouchEnabled(0)
	check[3]:SetVisible(0)
	Keypress_InitCheck_3(check[3])
	check[4] = CreateWindow(wnd.id, 250+posx_move, 240+posy_move, 775, 305)
	check[4]:SetTouchEnabled(0)
	check[4]:SetVisible(0)
	Keypress_InitCheck_4(check[4])
end

function Keypress_InitOutside(wnd)
    wnd:AddImage(path_setup.."line_setup.png",250+posx_move,240+posy_move,778,13)
    --添加四个响应图片
    All_check.back[1] = wnd:AddImage(path_setup.."normalback_setup.png",255+posx_move,180+posy_move,256,128)
	All_check.back[2] = wnd:AddImage(path_setup.."normalback_setup.png",415+posx_move,180+posy_move,256,128)
	All_check.back[3] = wnd:AddImage(path_setup.."dragonback_setup.png",565+posx_move,183+posy_move,256,128)
	All_check.back[4] = wnd:AddImage(path_setup.."normalback_setup.png",785+posx_move,180+posy_move,256,128)
	All_check.back[2]:SetVisible(0)
	All_check.back[3]:SetVisible(0)
	All_check.back[4]:SetVisible(0)
	All_check.pic[1] = wnd:AddImage(All_check_PathBright[1],290+posx_move,215+posy_move,128,32)
	All_check.pic[2] = wnd:AddImage(All_check_PathDark[2],450+posx_move,215+posy_move,128,32)
	All_check.pic[3] = wnd:AddImage(All_check_PathDark[3],595+posx_move,215+posy_move,128,32)
	All_check.pic[4] = wnd:AddImage(All_check_PathDark[4],820+posx_move,215+posy_move,128,32)
	for index = 1,4 do
	    All_check.pic[index].script[XE_LBUP] = function()
		    XClickPlaySound(5)
			Keypress_LwantChageApage(index)
			XLwantChangeKey(0,0)
			XLwantChangeCombineKey(0,0)
            XLwantGetKeyPressInfo(1,index)
		end    
	end
end

function Keypress_LwantChageApage(index)
    Keypress_cleanAllcheck()
    All_check.back[index]:SetVisible(1)--将目标设为可见
	All_check.pic[index].changeimage(All_check_PathBright[index])--将目标文字设亮
	check[index]:SetVisible(1)--将内容设为可见
	check[index]:SetTouchEnabled(1)
end



function Keypress_cleanAllcheck()
   	for mndex = 1,4 do
		All_check.back[mndex]:SetVisible(0)--先将所有的背景设为不可见
		check[mndex]:SetVisible(0)--先将所有的内容设为不可见
		check[mndex]:SetTouchEnabled(0)
		All_check.pic[mndex].changeimage(All_check_PathDark[mndex])--先将所有文字设暗
    end	
end

function Keypress_InitCheck_1(wnd)
    ---创建所有框框和文字---
    for index = 1,5 do
	    local posX = 120+(index-1)*70
	    check_1_All_button.frame[index] = wnd:AddImage(path_setup.."quickframe_setup.png",posX,60,64,64)
	end
	for index = 1,2 do
	    local posX = 560+(index-1)*70
		local mndex = index+5
	    check_1_All_button.frame[mndex] = wnd:AddImage(path_setup.."quickframe_setup.png",posX,60,64,64)
	end
	for index = 1,6 do
	    local posX = 120+(index-1)*70
		local mndex = index+7
	    check_1_All_button.frame[mndex] = wnd:AddImage(path_setup.."quickframe_setup.png",posX,210,64,64)
	end
    check_1_All_button.frame[14] = wnd:AddImage(path_setup.."quickframe_setup.png",590,210,64,64)
	for index = 1,14 do
	    check_1_All_button.font[index] = check_1_All_button.frame[index]:AddFont(check_1_All_button.fontdetail[index],18,8,3,-13,64,30,0x9075f5)
	end
	---创建打勾框--
	createcheck_1_yes(wnd)
	---添加固定文字---
	wnd:AddFont("快捷释放",15,0,30,130,100,20,0xffaf3d)
	wnd:AddFont("快捷释放",15,0,30,280,100,20,0xffaf3d)
	
	wnd:AddImage(path_setup.."heroskill_setup.png",110,10,512,64)
	wnd:AddImage(path_setup.."callskill_setup.png",555,10,130,36)
	wnd:AddImage(path_setup.."toolskill_setup.png",110,160,512,64)
	wnd:AddImage(path_setup.."puteye_setup.png",555,160,256,64)
	--给所有图片按键添加响应---
	for index = 1,14 do
	    check_1_All_button.frame[index].script[XE_LBUP] = function()
		    if(check_1_All_button.font[index]:IsVisible()) then
			    Keypress_ShowAllFont_1()
			    check_1_All_button.font[index]:SetVisible(0)
				if(check_1_All_button.yes[index]:IsVisible()) then
				    XLwantChangeKey(1,check_1_All_button.correspondingB[index])--传按键对应id
				else
                    XLwantChangeKey(1,check_1_All_button.correspondingA[index])--传按键对应id 				
				end
			else
                check_1_All_button.font[index]:SetVisible(1)
                if(check_1_All_button.yes[index]:IsVisible()) then
				    XLwantChangeKey(0,check_1_All_button.correspondingB[index])--传按键对应id
				else
                    XLwantChangeKey(0,check_1_All_button.correspondingA[index])--传按键对应id 				
				end				
			end
		end
	end	
	--添加一个全部智能施法的按键
	checkBtn = wnd:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",20,20,83,35)
	checkBtn:AddFont("全部智能", 15, 0, 8, 8, 200, 20, 0xffaf3d)
	checkBtn.script[XE_LBUP] = function()
	    for index =1,4 do
		    if(check_1_All_button.yes[index]:IsVisible() == false) then
		        check_1_All_button.yes[index]:SetVisible(1)	
			    check_1_All_button.font[index]:SetVisible(1)
			    XLwantSetBrainPower(1,check_1_All_button.correspondingB[index],check_1_All_button.fontdetail[index]) --直接设置按键用于智能施法的切换			    
			end			
		end
		for index = 6,13 do
		     if(check_1_All_button.yes[index]:IsVisible()== false) then
		        check_1_All_button.yes[index]:SetVisible(1)	
			    check_1_All_button.font[index]:SetVisible(1)
			    XLwantSetBrainPower(1,check_1_All_button.correspondingB[index],check_1_All_button.fontdetail[index]) --直接设置按键用于智能施法的切换
			end			
		end
	end
end

function Keypress_XLwantReturnACQ()--恢复默认设置
    local fontdetail_1 = {"Q","W","E","R","T","D","F","1","2","3","4","5","6","Z"}--字体内容
	for index = 1,14 do
	    check_1_All_button.fontdetail[index] = fontdetail_1[index]
		check_1_All_button.font[index]:SetFontText(check_1_All_button.fontdetail[index],0x9075f5)
		check_1_All_button.font[index]:SetVisible(1)
		check_1_All_button.yes[index]:SetVisible(0)
	end
	local fontdetail_2 = {"B","SPACE","Y","C","TAB","F1","A","S","P","V","G"}--字体内容
	for index = 1,11 do
	    check_2_All_button.fontdetail[index] = fontdetail_2[index]
		check_2_All_button.font[index]:SetFontText(check_2_All_button.fontdetail[index],0x9075f5)
		check_2_All_button.font[index]:SetVisible(1)
	end
	local fontdetail_3 = {"M","F2","F3","F4","O"}--字体内容
	for index = 1,5 do
	    check_3_All_button.fontdetail[index] = fontdetail_2[index]
		check_3_All_button.font[index]:SetFontText(check_3_All_button.fontdetail[index],0x9075f5)
		check_3_All_button.font[index]:SetVisible(1)
	end
	local fontdetail_4 = {"CTRL+Q","CTRL+W","CTRL+E","CTRL+R","ALT+Q","ALT+W","ALT+E","ALT+R","ALT+T"}
	for index = 1,9 do
	    check_4_All_button.fontdetail[index] = fontdetail_4[index]
		check_4_All_button.font[index]:SetFontText(check_4_All_button.fontdetail[index],0x9075f5)
		check_4_All_button.font[index]:SetVisible(1)
	end
	
	
	
end

---设置所有按键文字显示---
function Keypress_ShowAllFont()
   Keypress_ShowAllFont_1()
   Keypress_ShowAllFont_2()
   Keypress_ShowAllFont_3()
end
function Keypress_ShowAllFont_1()
    for index,value in pairs(check_1_All_button.font) do
	    check_1_All_button.font[index]:SetVisible(1)
	end
end
function Keypress_ShowAllFont_2() --目前只能做到第11个
    for index = 1,11 do
	    check_2_All_button.font[index]:SetVisible(1)
	end
end
function Keypress_ShowAllFont_3() --目前只能做到第5个
    for index = 1,5 do
	    check_3_All_button.font[index]:SetVisible(1)
	end
end
function Keypress_ShowAllFont_4()
     for index = 1,9 do
	    check_4_All_button.font[index]:SetVisible(1)
	end
end


function Keypress_GetAKeyCharTuLua(word,KeyIndex)--接收消息并进行检测//进行修改
    for index,value in pairs(check_1_All_button.font) do--check_1
	    if(check_1_All_button.fontdetail[index] == word) then
		    check_1_All_button.fontdetail[index] =""
			check_1_All_button.font[index]:SetFontText(check_1_All_button.fontdetail[index],0x9075f5)
		end
	    if(check_1_All_button.correspondingA[index] == KeyIndex or check_1_All_button.correspondingB[index] == KeyIndex) then
		    check_1_All_button.fontdetail[index] = word
	        check_1_All_button.font[index]:SetFontText(check_1_All_button.fontdetail[index],0x9075f5)
			check_1_All_button.font[index]:SetVisible(1)
		end
	end	
	for index = 1,11 do--check_2
	    if(check_2_All_button.fontdetail[index] == word) then
		    check_2_All_button.fontdetail[index] =""
			check_2_All_button.font[index]:SetFontText(check_2_All_button.fontdetail[index],0x9075f5)
		end
	    if(check_2_All_button.correspondingA[index] == KeyIndex) then
		    check_2_All_button.fontdetail[index] = word
	        check_2_All_button.font[index]:SetFontText(check_2_All_button.fontdetail[index],0x9075f5)
			check_2_All_button.font[index]:SetVisible(1)
		end
	end
	for index = 1,5 do--check_3
	    if(check_3_All_button.fontdetail[index] == word) then
		    check_3_All_button.fontdetail[index] =""
			check_3_All_button.font[index]:SetFontText(check_3_All_button.fontdetail[index],0x9075f5)
		end
	    if(check_3_All_button.correspondingA[index] == KeyIndex) then
		    check_3_All_button.fontdetail[index] = word
	        check_3_All_button.font[index]:SetFontText(check_3_All_button.fontdetail[index],0x9075f5)
			check_3_All_button.font[index]:SetVisible(1)
		end
	end
end

function createcheck_1_yes(wnd)
    for index = 1,14 do
	    local posX,posY = check_1_All_button.frame[index]:GetPosition()
		posX = posX-250+16-posx_move
		posY = posY-240+63-posy_move
	    check_1_All_button.check[index] = wnd:AddImage(path_hero.."checkbox_hero.png",posX,posY,32,32)
	    posX = posX+6
		posY = posY-5
		check_1_All_button.yes[index] = check_1_All_button.check[index]:AddImage(path_hero.."checkboxYes_hero.png",0,0,32,32)
		check_1_All_button.yes[index]:SetTouchEnabled(0)
		check_1_All_button.yes[index]:SetVisible(0)
		check_1_All_button.check[index].script[XE_LBUP] = function()
		    if(check_1_All_button.yes[index]:IsVisible()) then
			    check_1_All_button.yes[index]:SetVisible(0)
				XLwantSetBrainPower(1,check_1_All_button.correspondingA[index],check_1_All_button.fontdetail[index]) --直接设置按键用于智能施法的切换
			else
                check_1_All_button.yes[index]:SetVisible(1)	
				check_1_All_button.font[index]:SetVisible(1)
				XLwantSetBrainPower(1,check_1_All_button.correspondingB[index],check_1_All_button.fontdetail[index]) --直接设置按键用于智能施法的切换
			end    
		end    
	end
	check_1_All_button.check[5]:SetVisible(0)
	check_1_All_button.check[14]:SetVisible(0)
end

function Keypress_InitCheck_2(wnd)
    for index = 1,19 do
	    local PosX = (index-1)%4*180+37
		local PosY = math.floor((index-1)/4)
		PosY = PosY*57+10
	    check_2_All_button.frame[index] = wnd:AddImage(path_setup.."quickframe_setup.png",PosX,PosY,64,64)

    end
	for index = 1,19 do
		if(index <= 11) then
		    check_2_All_button.font[index] = check_2_All_button.frame[index]:AddFont(check_2_All_button.fontdetail[index],15,8,3,-13,64,30,0x9075f5)
		else
            check_2_All_button.font[index] = check_2_All_button.frame[index]:AddFont(check_2_All_button.fontdetail[index],15,8,3,-13,64,30,0x5d5d5d)
        end		
	end
	for index = 1,19 do
	    local PosX = (index-1)%4*180+95
		local PosY = math.floor((index-1)/4)
		PosY = PosY*57+29
		wnd:AddFont(check_2_word[index],15, 0, PosX, PosY, 150, 20, 0x6970a0)
	end
	for index = 1,11 do
	    check_2_All_button.frame[index].script[XE_LBUP] = function()
		    if(check_2_All_button.font[index]:IsVisible()) then
			    Keypress_ShowAllFont_2()
			    check_2_All_button.font[index]:SetVisible(0)
				XLwantChangeKey(1,check_2_All_button.correspondingA[index])--传按键对应id 				
			else
                check_2_All_button.font[index]:SetVisible(1)
                XLwantChangeKey(0,check_2_All_button.correspondingA[index])--传按键对应id 						
			end
		end
	end	
	for index = 12,19 do
	    check_2_All_button.frame[index]:SetEnabled(0)
	end
end

function Keypress_InitCheck_3(wnd)
    for index = 1,5 do
	    local PosX = (index-1)%4*180+37
		local PosY = math.floor((index-1)/4)
		PosY = PosY*57+10
	    check_3_All_button.frame[index] = wnd:AddImage(path_setup.."quickframe_setup.png",PosX,PosY,64,64)
    end
	for index = 1,5 do
		check_3_All_button.font[index] = check_3_All_button.frame[index]:AddFont(check_3_All_button.fontdetail[index],15,8,3,-13,64,30,0x9075f5)
	end
	for index = 1,5 do
	    local PosX = (index-1)%4*180+95
		local PosY = math.floor((index-1)/4)
		PosY = PosY*57+29
		wnd:AddFont(check_3_word[index],15, 0, PosX, PosY, 150, 20, 0x6970a0)
	end
	for index = 1,5 do
	    check_3_All_button.frame[index].script[XE_LBUP] = function()
		    if(check_3_All_button.font[index]:IsVisible()) then
			    Keypress_ShowAllFont_3()
			    check_3_All_button.font[index]:SetVisible(0)
				XLwantChangeKey(1,check_3_All_button.correspondingA[index])--传按键对应id 				
			else
                check_3_All_button.font[index]:SetVisible(1)
                XLwantChangeKey(0,check_3_All_button.correspondingA[index])--传按键对应id 						
			end
		end
	end	
end


function Keypress_InitCheck_4(wnd)

	for index = 1,9 do		
		g_item_posx[index] = 400
		g_item_posy[index] = 28+(index-1)*70
	    check_4_All_button.frame[index] = wnd:AddImage(path_setup.."buttonGroup_setup.png",g_item_posx[index],g_item_posy[index],256,64)
	end
	for index = 1,9 do
	    local PosX = 140
		local PosY = 40+(index-1)*70
		check_4_All_button.word[index] = wnd:AddFont(check_4_All_button.wordfont[index],18, 0, PosX, PosY, 500, 20, 0x8f9bd7)
		check_4_All_button.font[index] = check_4_All_button.frame[index]:AddFont(check_4_All_button.fontdetail[index],18,8,0,-13,150,20,0x9075f5)
		if g_item_posy[index] >250 or g_item_posy[index] <16 then
			check_4_All_button.frame[index]:SetVisible(0)
			check_4_All_button.word[index]:SetVisible(0)
		else
			check_4_All_button.frame[index]:SetVisible(1)
			check_4_All_button.word[index]:SetVisible(1)
		end
	end
	
	Keypress_check_4_ADDFunc()--给所有按键添加功能
	-------显示滚动条
	local check_4_sliplineback = wnd:AddImage(path.."toggleBK_main.png",683,26,16,268)
	check_4_slipline = check_4_sliplineback:AddButton(path.."toggleBTN1_main.png",path.."toggleBTN2_main.png",path.."toggleBTN3_main.png",0,0,16,50)
	local ToggleT = check_4_sliplineback:AddImage(path.."TD1_main.png",0,-16,16,16)
	local ToggleD = check_4_sliplineback:AddImage(path.."TD1_main.png",0,268,16,16)
	
	XSetWindowFlag(check_4_slipline.id,1,1,0,218)
	
	check_4_slipline:ToggleBehaviour(XE_ONUPDATE, 1)
	check_4_slipline:ToggleEvent(XE_ONUPDATE, 1)
	
	check_4_slipline.script[XE_ONUPDATE] = function()
		if check_4_slipline._T == nil then
			check_4_slipline._T = 0
		end
		local L,T,R,B = XGetWindowClientPosition(check_4_slipline.id)
		if check_4_slipline._T ~= T then
			local length = 0
			if #check_4_All_button.frame <4 then
				length = 218
			else
				length = 218/math.ceil(#check_4_All_button.frame-4)
			end
			local Many = math.floor(T/length)
			updownCount = Many
			
			if Many_Equip ~= Many then
				for i,value in pairs(check_4_All_button.frame) do					
					local Li = g_item_posx[i]
					local Ti = g_item_posy[i]- Many*70
					check_4_All_button.frame[i]:SetPosition(Li, Ti )
					check_4_All_button.word[i]:SetPosition(Li-260,Ti+12)
					
					if Ti >250 or Ti <16 then
						check_4_All_button.frame[i]:SetVisible(0)
						check_4_All_button.word[i]:SetVisible(0)
					else
						check_4_All_button.frame[i]:SetVisible(1)
						check_4_All_button.word[i]:SetVisible(1)
					end
				end
				Many_Equip = Many
			end		
			check_4_slipline._T = T
		end
	end
	
	-------设置界面可以滑动
	XWindowEnableAlphaTouch(g_setup_keypress_ui.id)
	g_setup_keypress_ui:EnableEvent(XE_MOUSEWHEEL)
	g_setup_keypress_ui.script[XE_MOUSEWHEEL] = function()
		local updown  = XGetMsgParam0()
		local length = 0
		if #check_4_All_button.frame >4 then
			maxUpdown = math.ceil(#check_4_All_button.frame-4)
			length = 218/maxUpdown
		else
			maxUpdown = 0
			length = 218
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
		local btn_pos = length*updownCount

		check_4_slipline:SetPosition(0,btn_pos)
		check_4_slipline._T = btn_pos
		
		if updownCount >= 0 and updownCount <= maxUpdown then
			for i,value in pairs(check_4_All_button.frame) do					
				local Li = g_item_posx[i]
				local Ti = g_item_posy[i]- updownCount*70
				check_4_All_button.frame[i]:SetPosition(Li, Ti )
				check_4_All_button.word[i]:SetPosition(Li-260,Ti+12)
				
				if Ti >250 or Ti <16 then
					check_4_All_button.frame[i]:SetVisible(0)
					check_4_All_button.word[i]:SetVisible(0)
				else
					check_4_All_button.frame[i]:SetVisible(1)
					check_4_All_button.word[i]:SetVisible(1)
				end
			end
		end		
	end
end
function Keypress_check_4_ADDFunc()
	for index = 1,9 do
	    check_4_All_button.frame[index].script[XE_LBUP] = function()
		  
		    if(check_4_All_button.font[index]:IsVisible()) then
			    Keypress_ShowAllFont_4()
			    check_4_All_button.font[index]:SetVisible(0)
				XLwantChangeCombineKey(1,check_4_All_button.correspondingA[index])--传按键对应id 				
			else
                check_4_All_button.font[index]:SetVisible(1)
                XLwantChangeCombineKey(0,check_4_All_button.correspondingA[index])--传按键对应id 						
			end
		end
	end	
end
function Keypress_GetAKeyCharTuLuaCombine(word1,word2,KeyIndex)
   local tempword = word1.."+"..word2
   	for index = 1,9 do--check_3
	    if(check_4_All_button.fontdetail[index] == tempword) then
		    check_4_All_button.fontdetail[index] =""
			check_4_All_button.font[index]:SetFontText(check_4_All_button.fontdetail[index],0x9075f5)
		end
	    if(check_4_All_button.correspondingA[index] == KeyIndex) then
		    check_4_All_button.fontdetail[index] = tempword
	        check_4_All_button.font[index]:SetFontText(check_4_All_button.fontdetail[index],0x9075f5)
			check_4_All_button.font[index]:SetVisible(1)
		end
	end
end

function Keypress_OpenCheckSetAllvisible()
    for index = 1,14 do
	    check_1_All_button.font[index]:SetVisible(1)
	end
    for index2 = 1,11 do
	    check_2_All_button.font[index2]:SetVisible(1)
	end
	for index3 = 1,5 do
	    check_3_All_button.font[index3]:SetVisible(1)
	end
	for index4 = 1,9 do
	    check_4_All_button.font[index4]:SetVisible(1)
	end
end




--当界面显示时设置数据
function Keypress_OpenCheck_1(str_1,str_2,str_3,str_4,str_5,str_6,str_7,str_8,str_9,str_10,str_11,str_12,str_13,str_14,str_15,str_16,str_17,str_18,str_19,str_20,str_21,str_22,str_23,str_24,str_25,str_26,str_27,str_28)
    KeyPressCheck_1_Set(1,str_1,str_2)
	KeyPressCheck_1_Set(2,str_3,str_4)
	KeyPressCheck_1_Set(3,str_5,str_6)
	KeyPressCheck_1_Set(4,str_7,str_8)
	KeyPressCheck_1_Set(5,str_9,str_10)
	KeyPressCheck_1_Set(6,str_11,str_12)
	KeyPressCheck_1_Set(7,str_13,str_14)
	KeyPressCheck_1_Set(8,str_15,str_16)
	KeyPressCheck_1_Set(9,str_17,str_18)
	KeyPressCheck_1_Set(10,str_19,str_20)
	KeyPressCheck_1_Set(11,str_21,str_22)
	KeyPressCheck_1_Set(12,str_23,str_24)
	KeyPressCheck_1_Set(13,str_25,str_26)
	KeyPressCheck_1_Set(14,str_27,str_28)
end
function KeyPressCheck_1_Set(index,str_1,str_2)--只用于上方函数
    if(index == 5 or index ==14) then
	    check_1_All_button.fontdetail[index] = str_1
		check_1_All_button.font[index]:SetFontText(check_1_All_button.fontdetail[index],0x9075f5)
	    check_1_All_button.yes[index]:SetVisible(0)
		return 
    end
   	if(str_2 ~="" and str_1 == "") then --1
	    check_1_All_button.fontdetail[index] = str_2
        check_1_All_button.font[index]:SetFontText(check_1_All_button.fontdetail[index],0x9075f5)	
	    check_1_All_button.yes[index]:SetVisible(1)
	else
	    check_1_All_button.fontdetail[index] = str_1
		check_1_All_button.font[index]:SetFontText(check_1_All_button.fontdetail[index],0x9075f5)
	    check_1_All_button.yes[index]:SetVisible(0)
	end
end
function Keypress_OpenCheck_2(str_1,str_2,str_3,str_4,str_5,str_6,str_7,str_8,str_9,str_10,str_11)
    KeyPressCheck_2_Set(1,str_1)
	KeyPressCheck_2_Set(2,str_2)
	KeyPressCheck_2_Set(3,str_3)
	KeyPressCheck_2_Set(4,str_4)
	KeyPressCheck_2_Set(5,str_5)
	KeyPressCheck_2_Set(6,str_6)
	KeyPressCheck_2_Set(7,str_7)
	KeyPressCheck_2_Set(8,str_8)
	KeyPressCheck_2_Set(9,str_9)
	KeyPressCheck_2_Set(10,str_10)
	KeyPressCheck_2_Set(11,str_11)
end
function KeyPressCheck_2_Set(index,str_1)--只用于上方函数
    check_2_All_button.fontdetail[index] = str_1
	check_2_All_button.font[index]:SetFontText(check_2_All_button.fontdetail[index],0x9075f5)
	check_2_All_button.font[index]:SetVisible(1)
end

function Keypress_OpenCheck_3(str_1,str_2,str_3,str_4,str_5)
    KeyPressCheck_3_Set(1,str_1)
	KeyPressCheck_3_Set(2,str_2)
	KeyPressCheck_3_Set(3,str_3)
	KeyPressCheck_3_Set(4,str_4)
	KeyPressCheck_3_Set(5,str_5)
end
function KeyPressCheck_3_Set(index,str_1)--只用于上方函数
    check_3_All_button.fontdetail[index] = str_1
	check_3_All_button.font[index]:SetFontText(check_3_All_button.fontdetail[index],0x9075f5)
	check_3_All_button.font[index]:SetVisible(1)
end



function Keypress_OpenCheck_4(str_1,str_2,str_3,str_4,str_5,str_6,str_7,str_8,str_9,str_10,str_11,str_12,str_13,str_14,str_15,str_16,str_17,str_18)
    KeyPressCheck_4_Set(1,str_1,str_2)
    KeyPressCheck_4_Set(2,str_3,str_4)
    KeyPressCheck_4_Set(3,str_5,str_6)
    KeyPressCheck_4_Set(4,str_7,str_8)
    KeyPressCheck_4_Set(5,str_9,str_10)
	KeyPressCheck_4_Set(6,str_11,str_12)
    KeyPressCheck_4_Set(7,str_13,str_14)
    KeyPressCheck_4_Set(8,str_15,str_16)
    KeyPressCheck_4_Set(9,str_17,str_18)
end
function KeyPressCheck_4_Set(index,str1,str2)--只用于上方函数
    check_4_All_button.fontdetail[index] = str1.."+"..str2
	check_4_All_button.font[index]:SetFontText(check_4_All_button.fontdetail[index],0x9075f5)
	check_4_All_button.font[index]:SetVisible(1)
end


-------------------------------------------------------------------------------------------------------------------------------------------------------------


function Set_SetupKeypressIsVisible(flag) 
	if g_setup_keypress_ui ~= nil then
		if flag == 1 and g_setup_keypress_ui:IsVisible() == false then
		    XLwantGetKeyPressInfo(1,1)
			Keypress_LwantChageApage(1)
			Keypress_OpenCheckSetAllvisible()
			g_setup_keypress_ui:SetVisible(1)
			updownCount = 0
			maxUpdown = 0
			check_4_slipline:SetPosition(0,0)
			check_4_slipline._T = 0
			for i,value in pairs(check_4_All_button.frame) do					
				local Li = g_item_posx[i]
				local Ti = g_item_posy[i]
				check_4_All_button.frame[i]:SetPosition(Li, Ti )
				check_4_All_button.word[i]:SetPosition(Li-260,Ti+12)
				
				if Ti >250 or Ti <16 then
					check_4_All_button.frame[i]:SetVisible(0)
					check_4_All_button.word[i]:SetVisible(0)
				else
					check_4_All_button.frame[i]:SetVisible(1)
					check_4_All_button.word[i]:SetVisible(1)
				end
			end
		elseif flag == 0 and g_setup_keypress_ui:IsVisible() == true then
		    XLwantChangeKey(0,0)
			XLwantChangeCombineKey(0,0)
			XLKeypressLwantCancel(1)
			g_setup_keypress_ui:SetVisible(0)
		end
	end
end


function Get_SetupKeypressIsVisible()  
    if(g_setup_keypress_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end