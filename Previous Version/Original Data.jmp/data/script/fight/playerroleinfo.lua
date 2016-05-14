include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


----C界面

local wnd_propoty = {}
local font_propoty = {"生  命  值:","法  力  值:","生命回复:","法力回复:","攻  击  力:","法术强度:",
"护甲穿透:","法术穿透:","生命偷取:","法术吸血:","攻击速度:","冷却缩减:","暴  击  率:","护       甲:",
"攻击距离:","法术抗性:","移动速度:","韧       性:","伤害加深:","伤害减免:"}

local font_ui = {}
local font_num = {"4797 / 4797","1250 / 1250","17","18","650","850","5 | 50%","7 | 80%","20%","50%","1.25","20%","18%","661","530","450","522","105","10%","28%"}

local Back = nil
local pullPosX = 100
local pullPosY = 100

function InitPlayerRoleInfo_ui(wnd,bisopen)
	n_playerRoleInfo_ui = CreateWindow(wnd.id, (1280-318)/2, (800-482)/2, 318, 482)
	InitMain_PlayerRoleInfo(n_playerRoleInfo_ui)
	n_playerRoleInfo_ui:SetVisible(bisopen)
end

function InitMain_PlayerRoleInfo(wnd)
	Back = wnd:AddImage(path_equip.."Cwnd.png",0,0,318,482)
	--点击可点穿
	DisableRButtonClick(Back.id)

	------关闭、装备、属性
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",275,15,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
				
		XClickBagValue(0)
	end	
	for i=1,20 do
		local posx = 117+((i+1)%2)*144
		local posy = 250+math.ceil(i/2)*33
		wnd_propoty[i] = n_playerRoleInfo_ui:AddFont(font_propoty[i] ,11, 0, posx-100, posy-200, 100, 20, 0x8295cf)
		font_ui[i] = wnd_propoty[i]:AddFont(font_num[i] ,11, 0, 60, 0, 100, 20, 0x6ffefc)
	end
	
	Back.script[XE_LBDOWN] = function()
	    n_playerRoleInfo_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = n_playerRoleInfo_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	Back.script[XE_LBUP] = function()
	    n_playerRoleInfo_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	n_playerRoleInfo_ui.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(n_playerRoleInfo_ui:IsVisible()) then
		    local x = XGetCursorPosX()
			local y = XGetCursorPosY()
			local w,h = Back:GetWH()
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
		    n_playerRoleInfo_ui:SetAbsolutePosition(PosX,PosY)
		else
	        n_playerRoleInfo_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
end

function ReDraw_PlayerRoleInfo(Belong)
	if Belong==0 then
		wnd_propoty[2]:SetFontText("法  力  值",0x8295cf)
		wnd_propoty[4]:SetFontText("法力回复",0x8295cf)
		wnd_propoty[2]:SetVisible(1)
		wnd_propoty[4]:SetVisible(1)
	elseif Belong==1 then
		wnd_propoty[2]:SetFontText("怒  气  值",0x8295cf)
		wnd_propoty[4]:SetFontText("怒气回复",0x8295cf)
		wnd_propoty[2]:SetVisible(1)
		wnd_propoty[4]:SetVisible(1)
	elseif Belong==2 then
		wnd_propoty[2]:SetFontText("能  量  值",0x8295cf)
		wnd_propoty[4]:SetFontText("能量回复",0x8295cf)
		wnd_propoty[2]:SetVisible(1)
		wnd_propoty[4]:SetVisible(1)
	else
		wnd_propoty[2]:SetVisible(0)
		wnd_propoty[4]:SetVisible(0)
	end
end

function ReDraw_GameHPMP(hp,mp)
	font_ui[1]:SetFontText(hp,0x6ffefc)
	font_ui[2]:SetFontText(mp,0x6ffefc)
end
function ReDraw_GameHPMPRecover(hp_recover,mp_recover)
	font_ui[3]:SetFontText(hp_recover,0x6ffefc)
	font_ui[4]:SetFontText(mp_recover,0x6ffefc)
end
function ReDraw_GamePhyMagicAttack(phycialAttack,magicAttack)
	font_ui[5]:SetFontText(phycialAttack,0x6ffefc)
	font_ui[6]:SetFontText(magicAttack,0x6ffefc)
end
function ReDraw_GameArmorPhen(armorPhen,magicArmorPhen)
	font_ui[7]:SetFontText(armorPhen,0x6ffefc)
	font_ui[8]:SetFontText(magicArmorPhen,0x6ffefc)
end
function ReDraw_GamePhyMagDrink(phycialDrink,magicDrink)
	font_ui[9]:SetFontText(phycialDrink,0x6ffefc)
	font_ui[10]:SetFontText(magicDrink,0x6ffefc)
end
function ReDraw_GameAttackSpeedCoolDown(attackSpeed,coolDown)
	font_ui[11]:SetFontText(attackSpeed,0x6ffefc)
	font_ui[12]:SetFontText(coolDown,0x6ffefc)
end
function ReDraw_GameCriticalArmor(critical,Armor)
	font_ui[13]:SetFontText(critical,0x6ffefc)
	font_ui[14]:SetFontText(Armor,0x6ffefc)
end
function ReDraw_GameAttackRangeMagArmor(attackRange,magicAromr)
	font_ui[15]:SetFontText(attackRange,0x6ffefc)
	font_ui[16]:SetFontText(magicAromr,0x6ffefc)
end
function ReDraw_GameMoveSpeedRenxing(moveSpeed,renxing)
	font_ui[17]:SetFontText(moveSpeed,0x6ffefc)
	font_ui[18]:SetFontText(renxing,0x6ffefc)
end
function ReDraw_GameDmgMoreOrLess(dmgMore,dmgLess)
	font_ui[19]:SetFontText(dmgMore,0x6ffefc)
	font_ui[20]:SetFontText(dmgLess,0x6ffefc)
end
function SetPlayerRoleInfoIsVisible(flag) 
	if n_playerRoleInfo_ui ~= nil then
		if flag == 1 and n_playerRoleInfo_ui:IsVisible() == false then
			n_playerRoleInfo_ui:SetVisible(1)
		elseif flag == 0 and n_playerRoleInfo_ui:IsVisible() == true then
			n_playerRoleInfo_ui:SetVisible(0)
		end
	end
end

function GetPlayerRoleInfoIsVisible()
    if n_playerRoleInfo_ui==nil then
		return 0
	else
		if n_playerRoleInfo_ui:IsVisible()==true then
		   return 1
		else
		   return 0 
		end
	end
	
end