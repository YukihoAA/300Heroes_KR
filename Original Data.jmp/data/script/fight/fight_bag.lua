include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

--------自身装备界面

-----角色等级及经验条
local HeroLvInfo = {}
HeroLvInfo.Lv = {}				-----当前等级
HeroLvInfo.CurExp = {}			-----当前经验
HeroLvInfo.NextLvExp = {}		-----下一等级需要经验
HeroLvInfo.Pre = {}				-----当前经验百分比


local Me_Equip = {}
local Me_EquipBlock = {}
local Me_EquipNum = {}
Me_Equip.onlyId = {}
Me_Equip.picPath = {}
local Me_forbidden = {}			-----战场内非专属标识
local Me_forbidden_bg = {}		-----战场内非专属遮罩
-----文字内容部分
local PhycialMagic = {"256","0","2.35","300","30","15"}
local Font_attack = {}	
--local Font_attackBG = {}				
local Money_Font = nil
local Shop_money = nil
local Shop_Font = nil

local Me_exp = nil				-----经验条
local HeroLv_Font = nil			-----当前等级
local HeroPre_Font = nil         -----当前经验百分比
local HeroHead_Pic = nil			-----英雄头像

local soulchangeFont = {"灵魂契约","隐藏契约"}
local btn_soulChange = nil
local btn_soulChangeFont = nil

local Hero_Death = nil
local Hero_DeathTime = nil

smallpullPic = {} --用于拖拽的区块  公有拖拽图片
smallpullPic.pullPosX = 0 --拖拽的X坐标
smallpullPic.pullPosY = 0--拖拽的y坐标
smallpullPic.pic = nil --拖拽图片
smallpullPic.onlyId = 0

local CheckC_ui= nil
local Equip_cure = {}
local Equip_cureEquip = {}
local Equip_cureEquipCount = {}
Equip_cureEquip.picpath = {}
Equip_cureEquip.onlyid = {}

--创建一个小型拖拽区块
function Fightbag_creatSmallpullPic(wnd)--创建拖拽区块
    smallpullPic.pic = wnd:AddImage(path_equip.."bag_equip.png",0,0,32,32)
	smallpullPic.pic.changeimage()
	smallpullPic.pic:SetVisible(0)--需要人为开启
	smallpullPic.pic:SetTouchEnabled(0)--需要人为开启
	smallpullPic.pic:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息

	
	smallpullPic.pic.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(smallpullPic.pic:IsVisible()) then
		    local PosX = XGetCursorPosX()-smallpullPic.pullPosX
		    local PosY = XGetCursorPosY()-smallpullPic.pullPosY
		    smallpullPic.pic:SetPosition(PosX,PosY)
		end
	end
	
	smallpullPic.pic.script[XE_LBUP] = function()--当鼠标左键抬起
	    if(smallpullPic.pic:IsVisible()) then
		    Fightbag_SmallpullPicXELP()
			waterbag_SmallpullPicXELP()
			Equip_StrSoul_SmallpullPicXLUP()
		    Fightbag_cleanSmallpullPic() --拖拽清空
		end
	end		
end

function Fightbag_cleanSmallpullPic()--创建拖拽区块
    smallpullPic.pullPosX = 0
	smallpullPic.pullPosY = 0
	smallpullPic.pic:SetVisible(0)
	smallpullPic.pic:SetTouchEnabled(0)
	smallpullPic.pic.changeimage()
	smallpullPic.onlyId = 0
	smallpullPic.pic:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
end


function Fightbag_SmallpullPicbyUstID(picPath,ustid,tempic) ---直接设置
    local tempPosX,tempPosY = tempic:GetPosition()--GetPosition和XgetCursorPosX得到的都是绝对坐标
	smallpullPic.pic:SetVisible(1) --让假图片显示
	smallpullPic.pic:SetTouchEnabled(1) --让假图片响应
	smallpullPic.pic:SetPosition(XGetCursorPosX() - 16,XGetCursorPosY()-16) --设置初始
	smallpullPic.pullPosX = 16 --设置焦点距离X
	smallpullPic.pullPosY = 16 --设置焦点距离Y
	smallpullPic.onlyId = ustid  ----这里用类型id代替
	smallpullPic.pic.changeimage(picPath) --更换图片\
	smallpullPic.pic:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
	smallpullPic.pic:TriggerBehaviour(XE_LBDOWN)--模拟点击
end	

function Fightbag_SmallpullPicXELP()
    if(n_fightbag_ui:IsVisible() == false or smallpullPic.onlyId == 0 or smallpullPic.onlyId == nil) then
	    return
	end
    local tempRanking = EquipeBag_checkRect() --判断是否在包裹框
	local oldranking = Fightbag_GetOldRanking(smallpullPic.onlyId)
	if(tempRanking == 0 or oldranking == 0) then
	    return
	end	
	XEquip_FightBag_ChangePos(tempRanking,oldranking)
end


function Fightbag_LargepullPicXELP()
    if(n_fightbag_ui:IsVisible() == false or pullPicType.id == 0 or pullPicType.id == nil) then
	    return
	end
    local tempRanking = EquipeBag_checkRect() --判断是否在包裹框
	if(tempRanking == 0) then
	    return
	end	
    XEquip_fightBag_DragIn(tempRanking,equipManage.itemOnlyID[pullPicType.id])--传给lua信息
end



function Fightbag_GetOldRanking(onlyidid)
    if(onlyidid ==0 or onlyidid ==nil) then
	    return 0
	end	
    for index = 1,6 do
	    if(Me_Equip.onlyId[index] == onlyidid) then
		    return index
		end
	end
	return 0
end

function EquipeBag_checkRect()
    for i = 1,6 do
	    if(CheckEquipPullResultSmallPic(Me_Equip[i])) then
		    return i
		end
	end
	return 0
end


function InitFightbag_ui(wnd,bisopen)
	n_fightbag_ui = CreateWindow(wnd.id, 0, 1080-127, 321, 127)
	InitMain_Fightbag(n_fightbag_ui)
	n_fightbag_ui:SetVisible(bisopen)
end

local BK_MYBAG, SIDE_MYBAG = nil
local ICON_BK = {path_fight.."me.png",path_fight.."me2.png"}
local ICON_SIDE = {path_fight.."self_headside.png",path_fight.."self_headside2.png"}

function InitMain_Fightbag(wnd)
	
	BK_MYBAG = wnd:AddImage(path_fight.."me.png",0,0,321,127)
	HeroHead_Pic = wnd:AddImage(path_fight.."target_icon.png",9,20,63,63)
	Hero_Death = HeroHead_Pic:AddImage(path_fight.."herodeath.png", 0, 0, 63, 63)
	
	Hero_Death:SetVisible(0)
	Hero_Death:SetTouchEnabled(0)
	HeroHead_Pic.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if n_playerRoleInfo_ui:IsVisible() == false then
			XClickBagValue(1)
		else
			XClickBagValue(0)
		end
	end	
		
	HeroLvInfo.Pre = 1.0
	Me_exp = wnd:AddImage(path_fight.."Me_exp.png",8,96,66,7)
	Me_expBG = wnd:AddImage(path_fight.."Me_exp.png",8,96,66,7)
	Me_expBG:SetTransparent(0)
	Me_exp:SetAddImageRect(Me_exp.id, 0, 0, 66*HeroLvInfo.Pre*0.01, 7, 8 ,96, 66*HeroLvInfo.Pre*0.01, 7)
		
	local posx = {136,175,214,136,175,214}
	local posy = {18,18,18,57,57,57}
	
	for i=1,6 do 
		Me_Equip[i] = wnd:AddImage(path_fight.."Me_equip.png",posx[i],posy[i],32,32)
		--Me_EquipBlock[i] = wnd:AddImage(path_fight.."farshop_side.png",posx[i]-1,posy[i]-1,34,34)
		Me_forbidden_bg[i] = Me_Equip[i]:AddImage(path_fight.."skill_nolearn.png",0,0,32,32)
		Me_forbidden_bg[i]:SetTouchEnabled(0)
		Me_forbidden_bg[i]:SetVisible(0)
		Me_forbidden[i] = Me_Equip[i]:AddImage(path.."punish1_hall.png",2,2,28,28) 
		Me_forbidden[i]:SetTouchEnabled(0)
		Me_Equip[i]:SetVisible(0)
		Me_forbidden[i]:SetVisible(0)
		Me_Equip[i].script[XE_LBUP] = function()
		    if(Me_Equip.onlyId[i] == 0 or Me_Equip.onlyId[i] == nil) then
			    return
			end
            XFightBag_ButtonXLUPuse(i)
		end
		
		Me_Equip[i].script[XE_DRAG] = function()
		    if(Me_Equip.onlyId[i] == 0 or Me_Equip.onlyId[i] == nil) then
			    return
			end
            Fightbag_SmallpullPicbyUstID(Me_Equip.picPath[i],Me_Equip.onlyId[i],Me_Equip[i])
		end
		
		Me_Equip[i].script[XE_RBUP] = function()--当鼠标左键抬起
		    if(g_bag_hero_ui:IsVisible()==true) then
			    XEquip_fightBag_NeedClean(i)
		    end
		end	
	end	
	
	local shop_btn = wnd:AddButton(path_fight.."shop.png",path_fight.."shop_1.png",path_fight.."shop_2.png",133,92,117,30)
	Shop_money = shop_btn:AddImage(path_shop.."money_shop.png",10,-1,64,64)
	shop_btn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if Shop_money:IsVisible()== true then
			XClickLolShop(1)			---商店
		else
			if n_shop_inside_ui:IsVisible() then
				SetShop_InsideIsVisible(0)		
			else
				SetShop_InsideIsVisible(1)		
			end
		end
	end
	
	
	btn_soulChange = wnd:AddButton(path_fight.."soul.png",path_fight.."soul_1.png",path_fight.."soul_2.png",4,90,72,29)
	btn_soulChange.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if n_soulchange_ui:IsVisible() then
			XClickSoulChangeIsopen(0)
			btn_soulChangeFont:SetFontText(soulchangeFont[1],0xe3e38d)
		else
			Refresh_SoulChange()
			XClickSoulChangeIsopen(1)
			btn_soulChangeFont:SetFontText(soulchangeFont[2],0xe3e38d)
		end
	end
	SIDE_MYBAG = wnd:AddImage(path_fight.."self_headside.png",0,0,321,127)
	-----文字
	Hero_DeathTime = Hero_Death:AddFontEx("0", 15, 8, 0, -21, 63, 20, 0xffffff)
	HeroLv_Font = wnd:AddFont("18",12,8,-52,-65,22,24,0xffffff)

	for i=1,6 do
		Font_attack[i] = wnd:AddFont(PhycialMagic[i],12,0,92,18*i-3,100,13,0xffffff)
		XWindowEnableAlphaTouch(Font_attack[i].id,0)
		Font_attack[i]:MoveWindow(92,18*i-3,40,13);
		Font_attack[i]:SetTouchEnabled(1)
	end
	local expme = HeroLvInfo.Pre
	HeroPre_Font = wnd:AddFont(expme.."%",11,8,0,-105,80,20,0xffffff)
	for i=1,6 do 
		Me_EquipNum[i] = Me_Equip[i]:AddFont("0",12,0,19,18,50,20,0xffffff)
		Me_EquipNum[i]:SetFontBackground()	
	end
	Money_Font = Shop_money:AddFontEx("0",15,0,35,6,200,20,0xe3e38d)
	Shop_money:SetVisible(0)
	Shop_Font = shop_btn:AddFontEx("商城",15,0,40,5,200,20,0xe3e38d)
	Shop_Font:SetVisible(0)
	btn_soulChangeFont = btn_soulChange:AddFontEx(soulchangeFont[1],15,8,0,0,72,29,0xe3e38d)
	
	CheckC_ui = CreateWindow(wnd.id, 258, 0, 50, 270)
	
	local posy = {19,55,91}
	for i=1,3 do
		Equip_cure[i] = CheckC_ui:AddImage(path_fight.."equipBack.png",0,posy[i],30,30)
		Equip_cureEquip[i] = Equip_cure[i]:AddImage(path_fight.."equipBack.png",0,0,30,30)
		Equip_cureEquip[i]:SetVisible(0)	
		Equip_cureEquip[i].script[XE_LBUP] = function()
		    XEquip_CureUse(i)
		end
		Equip_cureEquip[i].script[XE_DRAG] = function()
		    Fightbag_SmallpullPicbyUstID(Equip_cureEquip.picpath[i],Equip_cureEquip.onlyid[i],Equip_cureEquip[i])
		end
		
	end
	for i = 1,3 do
	    Equip_cureEquipCount[i] = Equip_cureEquip[i]:AddFont("0",11,6,1,-14,30,15,0xFFFFFF)
		Equip_cureEquipCount[i]:SetFontBackground()
	end
	CheckC_ui:SetVisible(1)
end
----------------------------------------------------------------------------------------------
-------------药水通信
function C_Setimage(strPic,onlyidid,ranking,Num,tip)
	Equip_cureEquip[ranking].changeimage("..\\"..strPic)--跟换图片
	Equip_cureEquip[ranking]:SetImageTip(tip)
	Equip_cureEquip[ranking]:SetVisible(1)
	Equip_cureEquip.picpath[ranking] = "..\\"..strPic
	Equip_cureEquip.onlyid[ranking] = onlyidid
    Equip_cureEquipCount[ranking]:SetFontText(Num)
	Equip_cureEquipCount[ranking]:SetVisible(1)
end
function C_SetimageClean(ranking)
	Equip_cureEquip[ranking].changeimage()--跟换图片
	Equip_cureEquip[ranking]:SetVisible(0)
    Equip_cureEquipCount[ranking]:SetFontText(0)
	Equip_cureEquipCount[ranking]:SetVisible(0)
    Equip_cureEquip.picpath[ranking] = 0
	Equip_cureEquip.onlyid[ranking] = 0
end

-----药水CD
function C_SetimageCD(ranking,CDtime,Starttime)
	Equip_cureEquip[ranking]:SetImageColdTimeFontSize(30)
	Equip_cureEquip[ranking]:SetImageColdTimeFontColor(0xffebd912)
	Equip_cureEquip[ranking]:SetImageColdTimeType(0)
	Equip_cureEquip[ranking]:SetImageColdTimeEx(CDtime,Starttime)
end

-- function CheckC_uiSetVisible(ibool)	
	-- if ibool == 1 then
		-- CheckC_ui:SetVisible(1)
		-- BK_MYBAG.changeimage(ICON_BK[2])
		-- SIDE_MYBAG.changeimage(ICON_SIDE[2])
	-- else		
		-- CheckC_ui:SetVisible(0)
		-- BK_MYBAG.changeimage(ICON_BK[1])
		-- SIDE_MYBAG.changeimage(ICON_SIDE[1])
	-- end
-- end

function waterbag_SmallpullPicXELP()
    if(CheckC_ui:IsVisible() == false or smallpullPic.onlyId == 0 or smallpullPic.onlyId == nil) then
	    return
	end
    local tempRanking = waterBag_checkRect() --判断是否在包裹框
	local oldranking = waterbag_GetOldRanking(smallpullPic.onlyId)
	if(tempRanking == 0 or oldranking == 0) then
	    return
	end	
	XWater_FightBag_ChangePos(tempRanking,oldranking)
end

function waterbag_LargepullPicXELP()
    if(CheckC_ui:IsVisible() == false or pullPicType.id == 0 or pullPicType.id == nil) then
	    return
	end
    local tempRanking = waterBag_checkRect() --判断是否在包裹框
	if(tempRanking == 0) then
	    return
	end	
    XEquip_BagEquipIn_DragIn(tempRanking,equipManage.itemOnlyID[pullPicType.id])
end

function waterBag_checkRect()
    for i = 1,3 do
	    if(CheckEquipPullResultSmallPic(Equip_cure[i])) then
		    return i
		end
	end
	return 0
end

function waterbag_GetOldRanking(onlyidid)
    if(onlyidid ==0 or onlyidid ==nil) then
	    return 0
	end	
    for index = 1,3 do
	    if(Equip_cureEquip.onlyid[index] == onlyidid) then
		    return index
		end
	end
	return 0
end

function SetMinimap_DragIsVisible(flag)
    if flag == 1 and CheckC_ui:IsVisible() == false then
			XClickMinimapMedicine(1)	----药水栏	
			CheckC_ui:SetVisible(1)
			BK_MYBAG.changeimage(ICON_BK[2])
			SIDE_MYBAG.changeimage(ICON_SIDE[2])
	end	
end

function SetMinimapUnvisible_Medicine(flag)
	CheckC_ui:SetVisible(flag)
	if flag==1 then
		BK_MYBAG.changeimage(ICON_BK[2])
		SIDE_MYBAG.changeimage(ICON_SIDE[2])
	else
		BK_MYBAG.changeimage(ICON_BK[1])
		SIDE_MYBAG.changeimage(ICON_SIDE[1])
	end
end
----------------------------------------------------------------------------------------------




















------清除自身装备UI
function Clear_MyEquipInfo()
	for i=1,6 do
	    Me_Equip[i].changeimage()
		Me_Equip[i]:SetVisible(0)
        Me_Equip.onlyId[i] = nil
        Me_Equip.picPath[i] = nil		
		Me_forbidden[i]:SetVisible(0)
		Me_forbidden_bg[i]:SetVisible(0)
	end
end
-----接收C++传来的装备信息 
function FightBag_ReciveEquipInfo(EquipPic,itemonlyid,Index,count,tip,bProfession)
    EquipPic = "..\\"..EquipPic	--图片路径
	if EquipPic ~= "..\\" then
	    if count >= 2 then
		    Me_EquipNum[Index+1]:SetFontText(count,0xffffff)
		    Me_EquipNum[Index+1]:SetVisible(1)
	    else
		    Me_EquipNum[Index+1]:SetVisible(0)
	    end	
		Me_Equip[Index+1].changeimage(EquipPic)
		Me_Equip[Index+1]:SetImageTip(tip)
		Me_Equip[Index+1]:SetVisible(1)	
		if bProfession == 0 then
			Me_forbidden[Index+1]:SetVisible(1)
			Me_forbidden_bg[Index+1]:SetVisible(1)
		else 
			Me_forbidden[Index+1]:SetVisible(0)
			Me_forbidden_bg[Index+1]:SetVisible(0)
		end	
		Me_Equip.onlyId[Index+1] = itemonlyid --图片唯一id
        Me_Equip.picPath[Index+1] = EquipPic --图片路径	
	end
end

-----装备激活和闪闪状态
function FightBag_ReciveEquipAnimate(index,isvisible)
	Me_Equip[index+1]:EnableImageAnimate(isvisible,6)
end

-----接c++传来的装备CD信息
function FightBag_ReciveEquipCDInfo(index,CDtime,starttime)
	Me_Equip[index+1]:SetImageColdTimeFontSize(30)
	Me_Equip[index+1]:SetImageColdTimeFontColor(0xffebd912)
	Me_Equip[index+1]:SetImageColdTimeType(0)
	Me_Equip[index+1]:SetImageColdTimeEx(CDtime,starttime)
end

-----接收玩家角色属性数据
function FightBag_RecivePlayerInfo(att,magatt,def,magdef,attspeed,movespeed)
	PhycialMagic[1] = string.format("%d",att)		
	PhycialMagic[2] = string.format("%d",magatt)		
	PhycialMagic[3] = string.format("%0.2f",attspeed)
	PhycialMagic[4] = string.format("%d",movespeed)
	PhycialMagic[5] = string.format("%d",def)	
	PhycialMagic[6] = string.format("%d",magdef)
	for i=1,6 do
		Font_attack[i]:SetFontText(PhycialMagic[i],0xffffff)
	end	
end

-----玩家角色属性TIP
function FightBag_RecivePlayerInfoTip(att,magatt,def,magdef,attspeed,movespeed)

	Font_attack[1]:SetTextTip(att)
	Font_attack[2]:SetTextTip(magatt)
	Font_attack[3]:SetTextTip(attspeed)
	Font_attack[4]:SetTextTip(movespeed)
	Font_attack[5]:SetTextTip(def)
	Font_attack[6]:SetTextTip(magdef)
end

----------商城还是商店
function Chose_ShopType(m_type)
	if m_type ==1 then
		Shop_money:SetVisible(1)
		Shop_Font:SetVisible(0)
	else
		Shop_money:SetVisible(0)
		Shop_Font:SetVisible(1)
	end
end
----------灵魂契约还是经验
function Chose_SoulChangeType(m_type)
	if m_type ==1 then
		btn_soulChange:SetVisible(1)
		Me_exp:SetVisible(0)
		HeroPre_Font:SetVisible(0)
	else
		btn_soulChange:SetVisible(0)
		Me_exp:SetVisible(1)
		HeroPre_Font:SetVisible(1)
	end
end
-----接收玩家场内金钱
function FightBag_ReciveMoney(money)
	Money_Font:SetFontText(money,0xe3e38d)
end

-----接收玩家场内等级经验
function FightBag_ReciveLvAndExp(Lv,CurExp,NextExp,Pre,exptip)
	HeroLvInfo.Lv = Lv			
	HeroLvInfo.CurExp = CurExp		
	HeroLvInfo.NextLvExp = NextExp
	HeroLvInfo.Pre = string.format("%0.1f",Pre)
	HeroLv_Font:SetFontText(HeroLvInfo.Lv,0xffffff)
	HeroPre_Font:SetFontText(HeroLvInfo.Pre.."%",0xffffff)
	Me_exp:SetAddImageRect(Me_exp.id, 0, 0, 66*HeroLvInfo.Pre*0.01, 7, 8 ,96, 66*HeroLvInfo.Pre*0.01, 7)
	Me_expBG:SetImageTip(exptip)
end

-----接收玩家场内头像
function FightBag_ReciveHead(headpic,x,y,w,h)
	headpic = "..\\"..headpic
	if headpic ~= "..\\" then
		HeroHead_Pic.changeimage(headpic)
		--HeroHead_Pic:SetAddImageRect(HeroHead_Pic.id,x,y,w,h,9,20,63,63)
	end
end

-----设置死亡时间遮罩
function FightBag_SetDearth(cVisible,ctime)
	--log("\n cVisible="..cVisible.."   ctime="..ctime)
	Hero_DeathTime:SetFontText(ctime, 0xf8901d)
	Hero_Death:SetVisible(cVisible)
	-- Hero_DeathTime:SetVisible(cVisible)
end

-- 设置显示
function SetFightbagIsVisible(flag) 
	if n_fightbag_ui ~= nil then
		if flag == 1 and n_fightbag_ui:IsVisible() == false then
			n_fightbag_ui:CreateResource()
			n_fightbag_ui:SetVisible(1)
		elseif flag == 0 and n_fightbag_ui:IsVisible() == true then
			n_fightbag_ui:DeleteResource()
			n_fightbag_ui:SetVisible(0)
			SetSoulChangeIsVisible(0)
		end
	end
end

function GetFightbagIsVisible()  
    if( n_fightbag_ui ~= nil and n_fightbag_ui:IsVisible()) then
		return 1
    else
		return 0
    end
end