include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

------小地图界面
local A,B,C,D,E,pressBtn,pressDir,BTN_SIDE = nil
local CheckC_ui,CheckE_ui = nil
local Equip_cure = {}
local Equip_cureEquip = {}
local Equip_cureEquipCount = {}
Equip_cureEquip.picpath = {}
Equip_cureEquip.onlyid = {}

local BTN_LIST = {}
local press_index = 0
local BTN_posx = {75,107,139,171,203,235}
local BTN_posy = {6,6,6,6,6,6}
local BTN_normal = {path_fight.."BTNA.png",path_fight.."BTNB.png",path_fight.."BTNC.png",path_fight.."BTND.png",path_fight.."BTNE.png",path_fight.."BTNF.png"}
local BTN_hover = {path_fight.."BTNA_1.png",path_fight.."BTNB_1.png",path_fight.."BTNC_1.png",path_fight.."BTND_1.png",path_fight.."BTNE_1.png",path_fight.."BTNF_1.png"}

local friendInfomationPromot = nil

function InitMinimap_ui(wnd,bisopen)
	n_minimap_ui = CreateWindow(wnd.id, 1920-290, 1080-274, 290, 274)
	InitMain_Minimap(n_minimap_ui)
	n_minimap_ui:SetVisible(bisopen)
end

function InitMain_Minimap(wnd)
	wnd:AddMiniMap(38,35,257,245)
	wnd:AddImage(path_fight.."minimap.png",0,0,290,274)	
	
	A = wnd:AddButton(path_fight.."fun_A.png",path_fight.."fun_A1.png",path_fight.."fun_A.png",40,-20,38,40)
	B = wnd:AddButton(path_fight.."fun_B.png",path_fight.."fun_B1.png",path_fight.."fun_B.png",72,-20,38,40)
	D = wnd:AddButton(path_fight.."fun_D.png",path_fight.."fun_D1.png",path_fight.."fun_D.png",218,-20,38,40)
	E = wnd:AddButton(path_fight.."fun_E.png",path_fight.."fun_E1.png",path_fight.."fun_E.png",250,-20,38,40)
	
	pressBtn = wnd:AddImage(path_fight.."fun2.png",0,-20,38,40)
	pressDir = pressBtn:AddImage(path_shop.."up2_rec.png",6,-10,24,16)
	pressBtn:SetVisible(0)
	
	A.script[XE_LBUP] = function()	
		XClickPlaySound(5)
		XClickMinimapAttack(1)		----发集合信号
	end
	B.script[XE_LBUP] = function()	
		XClickPlaySound(5)		
		XClickMinimapWithdraw(1)	----发小心信号
	end
	D.script[XE_LBUP] = function()	
		XClickPlaySound(5)
		XClickMinimapKaka(1)		----咔咔相机
	end
	E.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XClickMinimapMenu(1)		----菜单功能栏
	end
	

	
	----菜单工具栏
	CheckE_ui = CreateWindow(wnd.id, 14, -70, 270, 50)
	CheckE_ui:AddImage(path_fight.."hpmp.png",66,2,212,44)
		
	for i=1,6 do
		BTN_LIST[i] = CheckE_ui:AddButton(BTN_normal[i],BTN_hover[i],BTN_normal[i],BTN_posx[i],BTN_posy[i],38,38)	
		BTN_LIST[i].script[XE_LBUP] = function()
			XClickPlaySound(5)
			ClickWndVisible(i)
		end
	end
	friendInfomationPromot = BTN_LIST[3]:AddImage(path.."friendMes_hall.png",15,-3,19,20)
	friendInfomationPromot:SetTextTip("模备脚没档馒！")
	friendInfomationPromot:SetVisible(0)
	friendInfomationPromot.script[XE_LBUP] = function()
	    BTN_LIST[3]:TriggerBehaviour(XE_LBUP)--模拟点击
	end	
	CheckE_ui:SetVisible(0)
end

function SetMiniMapFriendPromotVisible(flag)
	if flag == 1 and friendInfomationPromot:IsVisible()==false then
		friendInfomationPromot:SetVisible(1)
	elseif flag == 0 and friendInfomationPromot:IsVisible()==true then
		friendInfomationPromot:SetVisible(0)
	end
end	

function SetMinimapScale(scale)
	if scale > 0 and n_minimap_ui ~= nil then
		n_minimap_ui:SetWindowScale(scale,scale,4)
	end
end

function MiniMap_ReciveTip(attacktip,withdrawtip,tip,kakatip,menutip)
	A:SetImageTip(attacktip)
	B:SetImageTip(withdrawtip)
	D:SetImageTip(kakatip)
	E:SetImageTip(menutip)
end

function MiniMap_ReciveMenuTip(SignalSettingtip,beibaotip,haoyoutip,xitongshezhitip,mailtip,titletip)
	BTN_LIST[1]:SetImageTip(SignalSettingtip)
	BTN_LIST[2]:SetImageTip(beibaotip)
	BTN_LIST[3]:SetImageTip(haoyoutip)
	BTN_LIST[4]:SetImageTip(xitongshezhitip)
	BTN_LIST[5]:SetImageTip(mailtip)
	BTN_LIST[6]:SetImageTip(titletip)
end

-----------点击按钮显示界面
function ClickWndVisible(index)
	if index ==1 then		
		XClickMinimapSignalSetting(1)		----信号设置
	elseif index ==2 then
		XClickMinimapBag(1)					----战场背包
		SetEquip_InsideIsVisible(1)	
        --XClickMinimapMenu(1)		----菜单功能栏
	elseif index ==3 then
		XClickMinimapFriend(1)				----好友界面
	elseif index ==4 then
		XClickMinimapSystemSetting(1)		----系统设置
		SetEquip_InsideIsVisible(0)	
	elseif index ==5 then
		XClickMinimapEmail(1)				----邮件界面
	elseif index ==6 then
		XClickMinimapTitle(1)				----成就界面
	end
end
-------------菜单功能栏是否可见
function SetMinimap_MenuIsVisible(flag)
	if CheckE_ui ~= nil then
		if flag == 1 and CheckE_ui:IsVisible() == false then
			local l,t,r,b = XGetWindowClientPosition(E.id)
			pressBtn:SetPosition(l,t)
			--pressBtn:SetPosition(250,-20)
			pressBtn:SetVisible(1)			
			CheckE_ui:SetVisible(1)
		elseif flag == 0 and CheckE_ui:IsVisible() == true then
			CheckE_ui:SetVisible(0)
			pressBtn:SetVisible(0)	
		end
	end
end

--------------5设置按钮是否可用
function SetMinimapEnabled_Attack(flag)
	A:SetEnabled(flag)
end
function SetMinimapEnabled_Withdraw(flag)
	B:SetEnabled(flag)
end

function SetMinimapEnabled_Kaka(flag)
	D:SetEnabled(flag)
end
function SetMinimapEnabled_Menu(flag)
	E:SetEnabled(flag)
end
--------------6功能按钮是否可用
function SetMinimapEnabled_SingalSetting(flag)
	BTN_LIST[1]:SetEnabled(flag)
end
function SetMinimapEnabled_Bag(flag)
	BTN_LIST[2]:SetEnabled(flag)
end
function SetMinimapEnabled_Friend(flag)
	BTN_LIST[3]:SetEnabled(flag)
end
function SetMinimapEnabled_SystemSetting(flag)
	BTN_LIST[4]:SetEnabled(flag)
end
function SetMinimapEnabled_Email(flag)
	BTN_LIST[5]:SetEnabled(flag)
end
function SetMinimapEnabled_Title(flag)
	BTN_LIST[6]:SetEnabled(flag)
end

-- 设置显示
function SetMinimapIsVisible(flag) 
	if n_minimap_ui ~= nil then
		if flag == 1 and n_minimap_ui:IsVisible() == false then
			n_minimap_ui:CreateResource()
			n_minimap_ui:SetVisible(1)
			CheckE_ui:SetVisible(0)
			pressBtn:SetVisible(0)
		elseif flag == 0 and n_minimap_ui:IsVisible() == true then
			n_minimap_ui:DeleteResource()
			n_minimap_ui:SetVisible(0)
		end
	end
end

function GetMinimapIsVisible() 
	if n_minimap_ui~=nil and n_minimap_ui:IsVisible() then
		return 1
	else
		return 0
	end
end