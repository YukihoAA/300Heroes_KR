include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


-----目标的数据
local TargetInfo = {}	
TargetInfo.hp = {}					-----当前生命值
TargetInfo.prehp = {}				-----当前生命值百分比
TargetInfo.mp = {}					-----当前法力值
TargetInfo.premp = {}               -----当前法力值百分比
TargetInfo.pic = {}                 -----目标头像
TargetInfo.lv = {}					-----目标等级
TargetInfo.mpkinds = 0				-----目标蓝条类型（无蓝条，法力，怒气，能量）

local T_Equip = {}
local T_forbidden = {} 				-----装备失效标识
local T_forbidden_bg = {}			-----装备失效遮罩
local T_EquipCount = {}
local Font_attack = {}
local PhycialMagic = {256,2.35,35,0,300,60}
local Hp = 0
local MaxHp = 0
local Mp = 0
local MaxMp = 0
local T_lv = nil
local T_lvIcon = nil
local T_HP = nil
local T_MP = nil
local T_TYPE = {path_fight.."T_MP.png",path_fight.."T_ENERGY.png",path_fight.."T_DENDER.png"}

local Target_hp = nil
local Target_mp = nil
local HeroHeadPic = nil			-----回执英雄头像
--------buff状态
local buff_icon_father = {}
local buff_icon = {}
local buff_type = {}
local buff_lay = {}
local buff_time = {}

local BuffInfo = {}
BuffInfo.pictureName = {}
BuffInfo.buffId = {}

local BuffType = {path_fight.."goodbuff_fight.png",path_fight.."badbuff_fight.png"}

function InitFighttaget_ui(wnd,bisopen)
	n_fighttarget_ui = CreateWindow(wnd.id, 0, 0, 293, 116)
	InitMain_Fighttaget(n_fighttarget_ui)
	n_fighttarget_ui:SetVisible(bisopen)
end

function InitMain_Fighttaget(wnd)

	local Target = wnd:AddImage(path_fight.."target.png",0,0,293,116)
	HeroHeadPic = wnd:AddImage(path_fight.."target_icon.png",8,8,63,63)
	local T_side = wnd:AddImage(path_fight.."target_head.png",5,5,68,68)
	
	--点击可点穿
	DisableRButtonClick(Target.id)
	DisableRButtonClick(HeroHeadPic.id)
	
	T_lvIcon = T_side:AddImage(path_fight.."target_lv.png",48,48,18,18)
	
	for i=1,6 do 
		T_Equip[i] = wnd:AddImage(path_fight.."target_icon.png",53+28*i,8,24,24)
		T_forbidden_bg[i] = T_Equip[i]:AddImage(path_fight.."skill_nolearn.png",0,0,24,24)
		T_forbidden_bg[i]:SetTouchEnabled(0)
		T_forbidden_bg[i]:SetVisible(0)
		T_forbidden[i] = T_Equip[i]:AddImage(path.."punish1_hall.png",2,2,20,20) 
		T_forbidden[i]:SetTouchEnabled(0)
		T_forbidden[i]:SetVisible(0)
		T_Equip[i]:SetVisible(0)
	end
	
	T_HP = wnd:AddImage(path_fight.."T_HP.png",7,75,239,9)
	T_HP:SetAddImageRect(T_HP.id, 0, 0, 239, 9, 7 ,75, 239, 9)
	--------目标是耗蓝还是能量怒气
	T_MP = wnd:AddImage(T_TYPE[1],7,87,239,9)
	T_MP:SetAddImageRect(T_MP.id, 0, 0, 239, 9, 7 ,87, 239, 9)
	
	------BUFF状态
	for i=1,20 do
		local buff_posx = 30*i-30
		local buff_posy = 112
	
		buff_icon[i] = wnd:AddImage(path_fight.."target_icon.png",buff_posx,buff_posy,24,24)	
		buff_type[i] = buff_icon[i]:AddImage(BuffType[1],-1,-1,26,26)		
		buff_icon[i]:SetVisible(0)
	end
			
	---文字
	T_lv = T_lvIcon:AddFont("1",12,8,0,0,18,20,0xffffff)
	for i=1,6 do
		T_EquipCount[i] = T_Equip[i]:AddFont("0",12,0,13,12,50,20,0xffffff)
		T_EquipCount[i]:SetFontBackground()
	end
	Target_hp = wnd:AddFont(Hp.."/"..MaxHp,11,8,0,-70,260,20,0xffffff)
	Target_mp = wnd:AddFont(Mp.."/"..MaxMp,11,8,0,-82,260,20,0xffffff)
	
	local posx = {81,137,193,81,137,193}
	local posy = {38,38,38,56,56,56}	
	for i=1,6 do
		Font_attack[i] = wnd:AddFont(PhycialMagic[i],12,0,posx[i]+15,posy[i]-3,50,20,0xffffff)
	end
	for i=1,20 do
		buff_lay[i] = buff_icon[i]:AddFont(i,11,6,0,0,30,16,0xffffff)
		buff_lay[i]:MoveWindow(-4,8,28,14)
		buff_lay[i]:SetFontBackground()
		buff_lay[i]:SetVisible(0)
	end
	
end
------清除目标装备UI
function Clear_TargetEquipInfo()
	for i=1,6 do
		T_Equip[i]:SetVisible(0)
		T_EquipCount[i]:SetVisible(0)		
	end
end
-----接收C++传来的装备信息 
function FightTarget_ReciveEquipInfo(EquipPic,Index,count,tip,bProfession)
	if count >= 2 then
		T_EquipCount[Index+1]:SetFontText(count,0xffffff)
		T_EquipCount[Index+1]:SetVisible(1)
	else
		T_EquipCount[Index+1]:SetVisible(0)
	end	
	EquipPic = "..\\"..EquipPic	--图片路径
	T_Equip[Index+1]:SetImageTip(tip)
	if EquipPic ~= "..\\" then
		T_Equip[Index+1].changeimage(EquipPic)
		T_Equip[Index+1]:SetVisible(1)	
		if bProfession == 0 then
			T_forbidden[Index+1]:SetVisible(1)
			T_forbidden_bg[Index+1]:SetVisible(1)
		else 
			T_forbidden[Index+1]:SetVisible(0)
			T_forbidden_bg[Index+1]:SetVisible(0)
		end	
	end
end

------清除目标装备UI
function Clear_TargetValueInfo()
	for i=1,6 do
		Font_attack[i]:SetVisible(0)	
	end
	T_lvIcon:SetVisible(0)
end
-----接收目标属性
function FightTarget_ReciveTargetInfo(att,magic,attspeed,movespeed,def,magdef,lv,isPlayer)
	PhycialMagic[1] = att	
	PhycialMagic[2] = attspeed
	PhycialMagic[3] = def
	PhycialMagic[4] = magic
	PhycialMagic[5] = movespeed
	PhycialMagic[6] = magdef
	for i=1,6 do
		Font_attack[i]:SetFontText(PhycialMagic[i],0xffffff)
		Font_attack[i]:SetVisible(1)
	end
	TargetInfo.lv = lv
	T_lv:SetFontText(TargetInfo.lv,0xffffff)
	if isPlayer==1 then
		T_lvIcon:SetVisible(1)
	else
		T_lvIcon:SetVisible(0)
	end
end

-----接收敌人场内头像
function FightTarget_ReciveHead(headpic,tip)
	HeroHeadPic.changeimage(headpic)
	HeroHeadPic:SetImageTip(tip)
end

 -----装备闪闪效果
function FightTarget_ReciveEquipAnimate(index,isvisible)
	T_Equip[index+1]:EnableImageAnimate(isvisible,6)
end

------清除目标装备UI
function Clear_TargetHPMPInfo()
	T_HP:SetVisible(0)	
	Target_hp:SetVisible(0)
	T_MP:SetVisible(0)
	Target_mp:SetVisible(0)
end
-----接收敌人的血量和蓝量数据
function FightTarget_ReciveHPMP(hp,prehp,mp,premp,mpkind)
	TargetInfo.hp = hp
	TargetInfo.prehp = prehp
	TargetInfo.mp = mp
	TargetInfo.premp = premp
	TargetInfo.mpkinds = mpkind
	if TargetInfo.prehp>1 then
		TargetInfo.prehp = 1
	end
	if TargetInfo.premp>1 then
		TargetInfo.premp = 1
	end
	T_HP:SetAddImageRect(T_HP.id, 0, 0, 239*TargetInfo.prehp, 9, 7 ,75, 239*TargetInfo.prehp, 9)
	Target_hp:SetFontText(TargetInfo.hp,0xffffff)
	T_HP:SetVisible(1)
	Target_hp:SetVisible(1)
	if mpkind==0 then
		T_MP:SetVisible(0)
		Target_mp:SetVisible(0)
	elseif mpkind==1 then
		T_MP.changeimage(T_TYPE[1])
		T_MP:SetAddImageRect(T_MP.id, 0, 0, 239*TargetInfo.premp, 9, 7 ,87, 239*TargetInfo.premp, 9)
		T_MP:SetVisible(1)
		Target_mp:SetFontText(TargetInfo.mp,0xffffff)
		Target_mp:SetVisible(1)
	elseif mpkind==2 then
		T_MP.changeimage(T_TYPE[2])
		T_MP:SetAddImageRect(T_MP.id, 0, 0, 239*TargetInfo.premp, 9, 7 ,87, 239*TargetInfo.premp, 9)
		T_MP:SetVisible(1)
		Target_mp:SetFontText(TargetInfo.mp,0xffffff)
		Target_mp:SetVisible(1)
	elseif mpkind==3 then
		T_MP.changeimage(T_TYPE[3])
		T_MP:SetAddImageRect(T_MP.id, 0, 0, 239*TargetInfo.premp, 9, 7 ,87, 239*TargetInfo.premp, 9)
		T_MP:SetVisible(1)
		Target_mp:SetFontText(TargetInfo.mp,0xffffff)
		Target_mp:SetVisible(1)
	end	
	
end
------清除目标装备UI
function Clear_BuffInfo()
	BuffInfo = {}
	BuffInfo.pictureName = {}
	BuffInfo.buffId = {}
	for i=1,20 do
		buff_icon[i]:SetVisible(0)	
		buff_lay[i]:SetVisible(0)
		buff_type[i]:SetVisible(0)
	end
end
function FightTarget_ReciveBuffInfo(pictureName,buffId,layer,Type,index,tip)
	BuffInfo.pictureName[index+1] = "..\\"..pictureName
	BuffInfo.buffId[index+1] = buffId
	
	buff_icon[index+1].changeimage(BuffInfo.pictureName[index+1])
	buff_icon[index+1]:SetImageTip(tip)
	buff_icon[index+1]:SetVisible(1)

	
	buff_lay[index+1]:SetFontText(layer,0xffffff)
	-- if layer>1 then
		-- buff_lay[index+1]:SetVisible(1)
	-- else
		-- buff_lay[index+1]:SetVisible(0)
	-- end
	if Type ==1 then
		buff_type[index+1].changeimage(BuffType[1])
		buff_type[index+1]:SetVisible(1)
		if layer>1 then
			buff_lay[index+1]:SetVisible(1)
		else
			buff_lay[index+1]:SetVisible(0)
		end
	elseif Type ==2 then
		buff_type[index+1].changeimage(BuffType[2])
		buff_type[index+1]:SetVisible(1)
		if layer>1 then
			buff_lay[index+1]:SetVisible(1)
		else
			buff_lay[index+1]:SetVisible(0)
		end
	else
		buff_type[index+1]:SetVisible(0)
		buff_lay[index+1]:SetVisible(0)
	end
end
function FightTarget_BuffSetTime(index,Time,StartTime)
	buff_icon[index+1]:SetImageColdTimeFontSize(13)
	buff_icon[index+1]:SetImageColdTimeType(1)
	buff_icon[index+1]:SetImageColdTimeEx(Time,StartTime)	
end




-- 设置显示
function SetFighttagetIsVisible(flag) 
	if n_fighttarget_ui ~= nil then
		if flag == 1 and n_fighttarget_ui:IsVisible() == false then
			n_fighttarget_ui:CreateResource()
			n_fighttarget_ui:SetVisible(1)
		elseif flag == 0 and n_fighttarget_ui:IsVisible() == true then
			n_fighttarget_ui:DeleteResource()
			n_fighttarget_ui:SetVisible(0)
		end
	end
end

function GetFighttagetIsVisible()  
    if(n_fighttarget_ui ~= nil and n_fighttarget_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end