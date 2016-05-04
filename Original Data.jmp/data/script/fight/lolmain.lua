include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local Lvup = {}

-- 接收血条蓝条
local HP = nil
local MP = nil
local HP_RECOVER = "+0.0"
local MP_RECOVER = "+0.0"
local HP_FONT = nil	
local MP_FONT = nil
local HP_REC = nil
local MP_REC = nil
local SHIELD_FONT = nil
local Shield = "  " 
local HPprecent = 0
local MPprecent = 0

-- 绘制部分
local MAIN_HP = nil
local MAIN_MP = nil

local Skill_Main = {}
local Skill_Main_Active = {}
local Skill_CD = {}
-- local Skill_tip = {}
local Skill_Main_ColdTime = {5,5,5,5}
local Skill_NoLearn = {}				-- 技能未学习
local Skill_NoMp = {}					-- 技能没蓝
local Key_Mfont = {"Q","W","E","R"}
local Key_main = {}
local icon_Main = {}
local Fream_Main = {}

local Key_Nfont = "T"
local Key_N = nil
local icon_N = path_fight.."Me_equip.png"
local Skill_N = nil

-- 眼
local Eye = {}
Eye.picpath = path_fight.."recall_fight.png"
Eye.BtnUnable = nil
Eye.Btn = nil
Eye.skillID = nil
Eye.coldTime = nil

-- 回城
local Backup = {}
Backup.picpath = path_fight.."recall_fight.png"
Backup.Btn = nil
Backup.skillID = nil

-- 召唤师技能
local Summoner = {}
Summoner.picpath = {}
Summoner.BtnUnable = {}
Summoner.Btn = {}
Summoner.skillID = {}

-- 技能加点
local SkillUp = {}
SkillUp.Btn = {}
SkillUp.BtnUnable ={}
SkillUp.IsAble = {}
SkillUp.Points = 0
SkillUp.SkillUpNotice = nil

local Skill_assist = {}
local Key_Afont = {"B","Z","D","F"}
local Key_assist = {}
local posx_assist = {530,569,872,911}
local icon_assist = {path_fight.."Me_equip.png",path_fight.."Me_equip.png",path_fight.."Me_equip.png",path_fight.."Me_equip.png"}

-- 技能点
local maxLv = {5,5,5,5}

-- 最大技能等级和当前技能等级
local SkillMaxLv = {}
local SkillCurLv = {}

-- 扩展技能（目前只有柯南具备）
local SkillEx = {}
SkillEx.Btn = {}
SkillEx.Pic = {}
-- 被动技能遮罩
local Skill_N_NoLearn = nil
local Skill_N_NoMp = nil

local CDFontcolor = {0xffebd912} 

local mposy = 0

function InitLolmain_ui(wnd,bisopen)
	n_lolmain_ui = CreateWindow(wnd.id, (1920-1470)/2, 1080-87, 1470, 87)
	InitMain_Lolmain(n_lolmain_ui)
	n_lolmain_ui:SetVisible(bisopen)
end

function InitMain_Lolmain(wnd)
	local TempImage = wnd:AddImage(path_fight.."lolmain.png",0,0,1470,87)
	DisableRButtonClick( TempImage.id)
	SkillUp.BtnUnable[1] = wnd:AddImage(path_fight.."levelup.png",598+54,-40,44,44)
	SkillUp.BtnUnable[1]:SetTransparent(0)
	SkillUp.BtnUnable[1]:SetTouchEnabled(0)
	
	for i=1,5 do
		-- 樱满集专用第五个！集哥威武...
		if i == 5 then
			SkillUp.Btn[i] = wnd:AddButton(path_fight.."levelup.png",path_fight.."levelup1.png",path_fight.."levelup.png",598+54*4,-35-43,44,44)
		else	
			SkillUp.Btn[i] = wnd:AddButton(path_fight.."levelup.png",path_fight.."levelup1.png",path_fight.."levelup.png",598+54*i,-40,44,44)
		end
		SkillUp.Btn[i].script[XE_LBUP] = function()	
			XClickPlaySound(5)
			XSkillUpLButtonDown(1,i-1)
		end
		SkillUp.Btn[i].script[XE_ONHOVER] = function()
			XSetImageTipPos(1)
		end
		SkillUp.Btn[i].script[XE_ONUNHOVER] = function()
			XSetImageTipPos(0)
		end
	end
	
	-- 回城 
	Backup.Btn = wnd:AddImage(Backup.picpath,posx_assist[1],35+mposy,32,32)
	DisableRButtonClick( Backup.Btn.id)
	Backup.Btn:SetTouchEnabled(1)	
	Backup.Btn.script[XE_LBDOWN] = function()	
		XBackOnLButtonUp(1)
	end
	
	-- 眼
	Eye.Btn = wnd:AddImage(Eye.picpath,posx_assist[2],35+mposy,32,32)
	DisableRButtonClick( Eye.Btn.id)
	Eye.BtnUnable = Eye.Btn:AddImage(path_fight.."skill_nomp_S.png",-3,-3,39,38)
	Eye.BtnUnable:SetTouchEnabled(0)
	Eye.BtnUnable:SetVisible(0)
	DisableRButtonClick( Eye.BtnUnable.id)
	Eye.Btn:SetTouchEnabled(1)	
	Eye.Btn.script[XE_ONHOVER] = function()
		XEyeMouseOn(1)
		XSetImageTipPos(1)
	end
	Eye.Btn.script[XE_ONUNHOVER] = function()
		XEyeMouseLeave(1)
		XSetImageTipPos(0)
	end
	Eye.Btn.script[XE_LBUP] = function()	
		XEyeLButtonUp(1)
		Eye.Btn:EnableImageFlash(1,50)
	end
	
	-- 初始化技能等级底图
	for	i = 1,4 do
		SkillMaxLv[i] = wnd:AddImage(path_fight.."maxLv_5_0.png",593+54*i,58+mposy,56,8)	
	end
	
	-- 召唤师技能
	for i =1,2 do
		Summoner.Btn[i] = wnd:AddImage(icon_assist[i],posx_assist[i+2],35+mposy,32,32)
		DisableRButtonClick( Summoner.Btn[i].id)
		Summoner.BtnUnable[i] = Summoner.Btn[i]:AddImage(path_fight.."skill_nomp_S.png",-3,-3,39,38)
		DisableRButtonClick( Summoner.BtnUnable[i].id)
		Summoner.BtnUnable[i]:SetTouchEnabled(0)
		Summoner.BtnUnable[i]:SetVisible(0)
		Summoner.Btn[i]:SetTouchEnabled(1)	
		Summoner.Btn[i].script[XE_ONHOVER] = function()
			XHotkeyMouseOn(1,i-1,1)
			XSetImageTipPos(1)
		end
		Summoner.Btn[i].script[XE_ONUNHOVER] = function()
			XHotkeyMouseLeave(1)
			XSetImageTipPos(0)
		end
		Summoner.Btn[i].script[XE_LBUP] = function()	
			XSummonerSkillLButtonUp(1,i-1)
			Summoner.Btn[i]:EnableImageFlash(1,50)
		end
	end
	
	-- 英雄技能
	for i=1,4 do
		Skill_Main[i] = wnd:AddImage(icon_Main[i],596+54*i,3+mposy,48,48)
		DisableRButtonClick( Skill_Main[i].id)
		Skill_Main_Active[i] = Skill_Main[i]:AddImage(path_fight.."skill_nolearn.png",0,0,48,48)
		Skill_Main_Active[i]:SetTransparent(0)
		Skill_Main_Active[i]:SetTouchEnabled(0)
		Skill_NoLearn[i] = Skill_Main[i]:AddImage(path_fight.."skill_nolearn.png",-3,-3,56,55)
		Skill_NoLearn[i]:SetTouchEnabled(0)
		Skill_NoLearn[i]:SetVisible(0)
		Skill_NoMp[i] = Skill_Main[i]:AddImage(path_fight.."skill_nomp.png",-3,-3,56,55)
		Skill_NoMp[i]:SetTouchEnabled(0)
		Skill_NoMp[i]:SetVisible(0)
		
		Skill_Main[i].script[XE_ONHOVER] = function()
			XHotkeyMouseOn(1,i-1,0)
			XSetImageTipPos(1)
		end
		Skill_Main[i].script[XE_ONUNHOVER] = function()
			XHotkeyMouseLeave(1)
			XSetImageTipPos(0)
		end
		Skill_Main[i].script[XE_LBUP] = function()	
			XHotkeyLButtonUp(1,i-1)
			Skill_Main[i]:EnableImageFlash(1,50)
		end	
	end
	
	-- 英雄扩展技能(目前只有柯南)
	for i = 1,3 do
		SkillEx.Btn[i] = wnd:AddImage(SkillEx.Pic[i],623+54*i,3-200,48,48) 
		SkillEx.Btn[i]:AddImage(path_fight.."skill_B.png",-3,-3,56,55) 
		SkillEx.Btn[i]:SetVisible(0)
		SkillEx.Btn[i]:SetTouchEnabled(1)
		SkillEx.Btn[i].script[XE_LBUP] = function()	
			XSkillExLButtonUp(1,i-1)
			SkillEx.Btn[i]:EnableImageFlash(1,50)
		end	
	end
	
	-- 被动技能
	Skill_N = wnd:AddImage(icon_N,611,20+mposy,32,32) 
	Skill_N_NoLearn = Skill_N:AddImage(path_fight.."skill_nolearn_S.png",-3,-3,39,38)
	Skill_N_NoLearn:SetTouchEnabled(0)
	Skill_N_NoLearn:SetVisible(0)
	Skill_N_NoMp = Skill_N:AddImage(path_fight.."skill_nomp_S.png",-3,-3,39,38)
	Skill_N_NoMp:SetTouchEnabled(0)
	Skill_N_NoMp:SetVisible(0)
	Skill_N:SetTouchEnabled(1)
	DisableRButtonClick( Skill_N.id)
	Skill_N.script[XE_LBUP] = function()	
		XTalentLButtonUp(1)
		Skill_N:EnableImageFlash(1,50)
	end
	Skill_N.script[XE_ONHOVER] = function()	
		XTalentMouseOn(1)
		XSetImageTipPos(1)
	end
	Skill_N.script[XE_ONUNHOVER] = function()	
		XTalentMouseLeave(1)
		XSetImageTipPos(0)
	end
	
	-- 血蓝条和数值显示
	MAIN_HP = wnd:AddImage(path_fight.."T_HP.png",513,73+mposy,218,10)
	MAIN_HP:SetAddImageRect(MAIN_HP.id, 0, 0, 218*HPprecent, 10, 513 ,73+mposy, 218*HPprecent, 10)	
	MAIN_MP = wnd:AddImage(path_fight.."T_MP.png",740,73+mposy,218,10)
	MAIN_MP:SetAddImageRect(MAIN_MP.id, 0, 0, 218*MPprecent, 10, 740 ,73+mposy, 218*MPprecent, 10)	
	
	local Skill_Frame = wnd:AddImage(path_fight.."Skill_BK.png",0,0,1470,87)
	Skill_Frame:SetTouchEnabled(0)
	
	SkillUp.SkillUpNotice = wnd:AddFontEx("升 级！ + "..SkillUp.Points,15,0,710,-55,200,20,0xe3e38d)
	SkillUp.SkillUpNotice:SetVisible(0)

	Key_assist[1] = Backup.Btn:AddFont(Key_Afont[1],15,0,-5,15,20,20,0xb4ffff)
	Key_assist[1]:SetFontBackground()

	Key_assist[2] = Eye.Btn:AddFont(Key_Afont[2],15,0,-5,15,20,20,0xb4ffff)
	Key_assist[2]:SetFontBackground()
	
	for i =1,2 do
		Key_assist[i+2] = Summoner.Btn[i]:AddFont(Key_Afont[i+2],15,0,-5,15,20,20,0xb4ffff)
		Key_assist[i+2]:SetFontBackground()
	end

	for i=1,4 do
		Key_main[i] = Skill_Main[i]:AddFont(Key_Mfont[i],15,0,-3,30,20,20,0xb4ffff)
		Key_main[i]:SetFontBackground()
	end		

	Key_N = Skill_N:AddFont(Key_Nfont,15,0,-3,15,20,20,0xb4ffff)
	Key_N:SetVisible(0)
	
	HP_FONT = wnd:AddFont(HP,11,8,0,-68,1250,20,0xffffff)
	MP_FONT = wnd:AddFont(MP,11,8,0,-68,1700,20,0xffffff)
	SHIELD_FONT = wnd:AddFont(Shield,11,8,0,-68,1072,20,0xffffff)
	SHIELD_FONT:SetVisible(0)
	HP_REC = wnd:AddFont(HP_RECOVER,11,8,0,-68,1428,20,0xffffff)
	MP_REC = wnd:AddFont(MP_RECOVER,11,8,0,-68,1888,20,0xffffff)
	
end


-- 接收眼
function LoLMain_ReciveEye(picpath,skillID,skill_tip,backtip)
	Eye.picpath = "..\\"..picpath
	Eye.Btn.changeimage(Eye.picpath)
	Eye.Btn:SetImageTip(skill_tip)
	Backup.Btn:SetImageTip(backtip)
end

-- 接收技能升级加点
function LoLMain_ReciveSkillUp(index,isCanSkillUp,Points,tip)
	SkillUp.Points = Points
	SkillUp.IsAble[index+1] = isCanSkillUp
	local idx = index
	if SkillUp.Points == 0 then
		SkillUp.SkillUpNotice:SetVisible(0)
		for i = 1,5 do
			SkillUp.Btn[i]:SetVisible(0)
		end
	else
		SkillUp.SkillUpNotice:SetFontText("升 级！ + "..SkillUp.Points,0xe3e38d)
		SkillUp.SkillUpNotice:SetVisible(1)
		if	SkillUp.IsAble[index+1] == 1 then
			SkillUp.Btn[index+1]:SetVisible(1)
			SkillUp.Btn[index+1]:SetImageTip(tip)
		else
			if idx == 4 then
				SkillUp.Btn[index+1]:SetVisible(0)
			else
				SkillUp.Btn[index+1]:SetVisible(0)
			end
		end
	end
end

function LoLMain_SkillAllSetEnablefalse()
	for i = 1,4 do 
		SkillUp.Btn[i]:SetVisible(0)
	end
end

function LoLMain_SkillAllSetOneSkillEnableTrue(index)
	SkillUp.Btn[index]:SetVisible(1)
end

-- 初始化英雄技能等级显示
function LoLMain_ReciveMaxSkillLv(index,MaxLv)
	local idx = index + 1
	maxLv[idx] = MaxLv
end

-- 英雄技能等级变更
function LoLMain_ReciveSkillLvChange(index,curlv)
	local curLv = curlv

	if curLv == -1 then 
		for i = 1,4 do
			SkillMaxLv[i].changeimage(path_fight.."maxLv_"..maxLv[i].."_0.png")
		end
	elseif curLv == 0 then
		SkillMaxLv[index+1].changeimage(path_fight.."maxLv_"..maxLv[index+1].."_0.png")
	elseif curLv ~= 0 then 
		if curLv > maxLv[index+1] then
			curLv = maxLv[index+1]
		end
		SkillMaxLv[index+1].changeimage(path_fight.."maxLv_"..maxLv[index+1].."_"..curLv..".png")
	end	
end

-- 小悟空被动技能快捷键显示
function LoLMain_ReciveTalentKey(isVisible)
	local TalentKeyCanSee = isVisible
	if TalentKeyCanSee == 1 then
		Key_N:SetVisible(1)
	elseif TalentKeyCanSee == 0 then
		Key_N:SetVisible(0)
	end 
end

-- 未学技能遮罩
function LoLMain_ReciveIsLearn(index,isLearn)
	local IsLearn = isLearn
	local idx = index
	if idx == 5 then
		if IsLearn == 1 then 
			Skill_N_NoLearn:SetVisible(0)
		elseif IsLearn == 0 then
			Skill_N_NoLearn:SetVisible(1)
		end
	else
		if IsLearn == 1 then 
			Skill_NoLearn[idx]:SetVisible(0)
		elseif IsLearn == 0 then
			Skill_NoLearn[idx]:SetVisible(1)
		end
	end	
end

-- 无蓝技能遮罩
function LoLMain_ReciveIsEnoughMp(index,isMpEnough)
	local IsMpEnough = isMpEnough
	local idx = index
	if idx == 5 then
		if IsMpEnough == 1 then 
			Skill_N_NoMp:SetVisible(0)
		elseif IsMpEnough == 0 then
			Skill_N_NoMp:SetVisible(1)
		end
	else
		if IsMpEnough == 1 then 
			Skill_NoMp[idx]:SetVisible(0)
		elseif IsMpEnough == 0 then
			Skill_NoMp[idx]:SetVisible(1)
		end
	end	
end

-- 召唤师技能特殊状态遮罩
function LoLMain_ReciveSummonerCover(index,isCover)
	local IsCover = isCover
	local idx = index
	if IsCover == 1 then 
		Summoner.BtnUnable[idx]:SetVisible(1)
	elseif IsCover == 0 then
		Summoner.BtnUnable[idx]:SetVisible(0)
	end
end

-- 眼特殊状态遮罩
function LoLMain_ReciveEyeCover(isCover)
	local IsCover = isCover
	if IsCover == 1 then 
		Eye.BtnUnable:SetVisible(1)
	elseif IsCover == 0 then
		Eye.BtnUnable:SetVisible(0)
	end
end

-- 接收技能图片
function LoLMain_ReciveSkillImg(picpath,index,skill_tip)
	icon_Main[index+1] = "..\\"..picpath
	Skill_Main[index+1].changeimage(icon_Main[index+1])
	Skill_Main[index+1]:SetImageTip(skill_tip)
end

-- 眼冷却
function LoLMain_ReciveEyeCD(CDtime)
	Eye.Btn:SetImageColdTimeFontSize(30)
	Eye.Btn:SetImageColdTimeFontColor(0xffebd912)
	Eye.Btn:SetImageColdTimeType(0)
	Eye.Btn:SetImageColdTime(CDtime)
end
 
-- 切换英雄或者Clearskillcd
function LoLMain_ClearSkillCD()
	for i = 1,4 do 
		Skill_Main[i]:SetImageColdTime(0)
	end 
	Skill_N:SetImageColdTime(0)
	for i = 1,2 do
		Summoner.Btn[i]:SetImageColdTime(0)
	end
end

function LoLMain_ReciveSkillAnimate(index,isvisible)
	Skill_Main_Active[index+1]:EnableImageAnimate(isvisible,0,25,5)
end

function LoLMain_ReciveSkillFlash(index)
	Skill_Main[index+1]:EnableImageFlash(1,50)
end

function LoLMain_ReciveSummonerSkillFlash(index)
	Summoner.Btn[index+1]:EnableImageFlash(1,50)
end

function LoLMain_ReciveEyeFlash()
	Eye.Btn:EnableImageFlash(1,50)
end

-- 英雄二段技能冷却
function LoLMain_ReciveSecSkillCD(index,CDtime,color,starttime)	
	XSetImageValidColdTime(Skill_Main[index+1].id, CDtime, starttime)
end 

-- 英雄技能冷却
function LoLMain_ReciveSkillCD(index,CDtime,color,starttime)	
	Skill_Main[index+1]:SetImageColdTimeFontSize(30)
	Skill_Main[index+1]:SetImageColdTimeType(0)
	Skill_Main[index+1]:SetImageColdTimeNeedMask(color)
	if color == 1 then 	
		Skill_Main[index+1]:SetImageColdTimeFontColor(0xffebd912)
	elseif color == 0 then	
		Skill_Main[index+1]:SetImageColdTimeFontColor(0xff33d95e)
	end
	Skill_Main[index+1]:SetImageColdTimeEx(CDtime,starttime,1)

end 

-- 召唤师技能冷却
function LoLMain_ReciveSummonerSkillCD(index,CDtime)
	Summoner.Btn[index+1]:SetImageColdTimeFontSize(30)
	Summoner.Btn[index+1]:SetImageColdTimeFontColor(0xffebd912)
	Summoner.Btn[index+1]:SetImageColdTimeType(0)
	Summoner.Btn[index+1]:SetImageColdTime(CDtime)
end

function LoLMain_ReciveTalentSkillCD(CDtime)
	Skill_N:SetImageColdTimeFontSize(30)
	Skill_N:SetImageColdTimeFontColor(0xffebd912)
	Skill_N:SetImageColdTimeType(0)
	Skill_N:SetImageColdTime(CDtime)	
end

-- 技能扩展
function LoLMain_ReciveSkillEx(picpath,index,tip)
	SkillEx.Pic[index+1] = "..\\"..picpath
	SkillEx.Btn[index+1].changeimage(SkillEx.Pic[index+1])
	SkillEx.Btn[index+1]:SetImageTip(tip)
end	
	
-- 技能扩展是否显示
function LoLMain_ReciveSkillExIsVisible(isVisible)
	local SkillExIsVisible = isVisible
	if SkillExIsVisible == 0 then 
		for i = 1,3 do 
			SkillEx.Btn[i]:SetImageTip(0)
			SkillEx.Btn[i]:SetVisible(0)			
		end
	else 
		for i = 1,3 do 
			SkillEx.Btn[i]:SetVisible(1)
		end	
	end
end
	
-- 接收被动技能图片
function LoLMain_ReciveTalentImg(picpath,skill_tip)
	icon_N = "..\\"..picpath
	Skill_N.changeimage(icon_N)
	Skill_N:SetImageTip(skill_tip)
end

-- 接收召唤师技能图片
function LoLMain_ReciveSummonerSkillImg(picpath,index,skill_tip)
	Summoner.picpath[index+1] = "..\\"..picpath
	Summoner.Btn[index+1].changeimage(Summoner.picpath[index+1])
	Summoner.Btn[index+1]:SetImageTip(skill_tip)
end

-- 刷新快捷键FONT
function LoLMain_ClearKeyFont()
	for i = 1,4 do
		Key_assist[i]:SetFontText(" ",0xb4ffff)
		Key_main[i]:SetFontText(" ",0xb4ffff)
	end
	Key_N:SetFontText(" ",0xb4ffff)		
end

-- 接收修改键位后的按键信息，用于显示技能快捷键
function LoLMain_ReciveKeyFont(index,font)
	local idx = index
	local KeyFont = font
	if idx == 85 then
		Key_assist[1]:SetFontText(KeyFont,0xb4ffff)
	elseif idx == 117 then
		Key_assist[2]:SetFontText(KeyFont,0xb4ffff)	
	elseif idx == 86 then
		if KeyFont~="" then
			Key_assist[3]:SetFontText(KeyFont,0xb4ffff)	
		else
			Key_assist[3]:SetFontText("",0xb4ffff)
		end
	elseif idx == 87 then
		if KeyFont~="" then
			Key_assist[4]:SetFontText(KeyFont,0xb4ffff)	
		else
			Key_assist[4]:SetFontText("",0xb4ffff)	
		end
	elseif idx == 31 then
		if KeyFont~="" then
			Key_main[1]:SetFontText(KeyFont,0xb4ffff)	
		else 
			Key_main[1]:SetFontText("",0xb4ffff)
		end
	elseif idx == 32 then
		if KeyFont~="" then
			Key_main[2]:SetFontText(KeyFont,0xb4ffff)
		else	
			Key_main[2]:SetFontText("",0xb4ffff)
		end	
	elseif idx == 33 then
		if KeyFont~="" then
			Key_main[3]:SetFontText(KeyFont,0xb4ffff)	
		else	
			Key_main[3]:SetFontText("",0xb4ffff)
		end	
	elseif idx == 34 then
		if KeyFont~="" then
			Key_main[4]:SetFontText(KeyFont,0xb4ffff)	
		else	
			Key_main[4]:SetFontText("",0xb4ffff)
		end		
	elseif idx == 35 and KeyFont~="" then
		Key_N:SetFontText(KeyFont,0xb4ffff)
	end
end

-- 英雄护盾值显示
function LoLMain_ReciveShield(isShield,shield)
	if isShield == 1 then
		SHIELD_FONT:SetFontText(shield,0xb4ffff)
		SHIELD_FONT:SetVisible(1)
	else
		SHIELD_FONT:SetVisible(0)
	end 
end

-- 自己的血条蓝条显示
function LoLMain_ReciveHpAndMp(hp,hpPre,mp,mpPre,hprecover,mprecover,mpkind)
	HP = hp
	MP = mp
	HPprecent = hpPre
	MPprecent = mpPre
	HP_RECOVER = hprecover
	MP_RECOVER = mprecover

	if HPprecent>1 then
		HPprecent = 1
	end
	if MPprecent>1 then
		MPprecent = 1
	end
	if mpkind ~= 0 then
		if MPprecent ~= 0 then
			MAIN_MP:SetVisible(1)
			MP_FONT:SetVisible(1)
		end		
	else
		MAIN_MP:SetVisible(0)
		MP_FONT:SetVisible(0)
		MP_REC:SetVisible(0)
	end
	if mpkind == 1 then
		MAIN_MP.changeimage(path_fight.."T_MP.png")
		MP_REC:SetVisible(1)
	elseif mpkind == 2 then
		MP_REC:SetVisible(0)
		MAIN_MP.changeimage(path_fight.."T_ENERGY.png")
	elseif mpkind == 3 then
		MP_REC:SetVisible(0)
		MAIN_MP.changeimage(path_fight.."T_DENDER.png")
	end
	if HPprecent ~= 0 then
		HP_FONT:SetFontText(HP,0xffffff)
		MAIN_HP:SetAddImageRect(MAIN_HP.id, 0, 0, 218*(HPprecent), 10, 513 ,73+mposy, 218*(HPprecent), 10)
		HP_REC:SetFontText(HP_RECOVER,0xffffff)
		MAIN_MP:SetAddImageRect(MAIN_MP.id, 0, 0, 218*(MPprecent), 10, 740 ,73+mposy, 218*(MPprecent), 10)	
		MP_FONT:SetFontText(MP,0xffffff)
		MP_REC:SetFontText(MP_RECOVER,0xffffff)
	else
		HP_FONT:SetFontText(HP,0xffffff)
		MAIN_HP:SetAddImageRect(MAIN_HP.id, 0, 0, 218*(HPprecent), 10, 513 ,73+mposy, 218*(HPprecent), 10)
		HP_REC:SetFontText(HP_RECOVER,0xffffff)
		MAIN_MP:SetAddImageRect(MAIN_MP.id, 0, 0, 218*(MPprecent), 10, 740 ,73+mposy, 218*(MPprecent), 10)	
		MP_FONT:SetFontText(MP,0xffffff)
		MP_REC:SetFontText(MP_RECOVER,0xffffff)
	end
end


function SetEffectMainTutorial(cIsEnabled)
	SkillUp.BtnUnable[1]:EnableImageAnimateEX(cIsEnabled, 7, 70, 5, 50, 5, -40)
end

-- 设置显示
function SetLolmainIsVisible(flag) 
	if n_lolmain_ui ~= nil then
		if flag == 1 and n_lolmain_ui:IsVisible() == false then
			n_lolmain_ui:CreateResource()
			n_lolmain_ui:SetVisible(1)
		elseif flag ==0 and n_lolmain_ui:IsVisible() == true then 
			n_lolmain_ui:DeleteResource()
			n_lolmain_ui:SetVisible(0)
		end
	end
end

function GetLolmainIsVisible()  
    if(n_lolmain_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function GetMainSkillUiPos()
	local l,t,r,b = Skill_N:GetPosition()
	XGetMainSkillUiPos(l,t,r,b)
end