include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------装备总览
local Click_btn = nil
local Click_Font = nil

local Click_btnB = nil
local Click_FontB = nil

local checkA = nil
local checkB = nil
local checkC = nil
local checkD = nil
local checkE = nil
local checkF = nil
local font_list = {"第一套配装","第二套配装","第三套配装","背包","时效背包I","时效背包II","仓库"}

local checkG = nil
local checkGLight = nil

function InitEquip_allUI(wnd, bisopen)
	g_equip_all_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainEquip_all(g_equip_all_ui)
	g_equip_all_ui:SetVisible(bisopen)
end
function InitMainEquip_all(wnd)
	
	wnd:AddImage(path_equip.."BK2_equip.png",97,208,317,476)
	wnd:AddImage(path_equip.."BK2_equip.png",410,208,317,476)
	wnd:AddImage(path_equip.."BK3_equip.png",745,188,512,512)
	
	checkA = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check1_equip.png",112,157,256,64)
	checkA:AddFont(font_list[1],15, 0, 57, 15, 100, 20, 0x625b7c)
	checkA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(112,157)
		Click_Font:SetFontText(font_list[1])
		SetBagHeroBagNow(1)
		Equip_BattleBag_draw()	
        Equip_BattleBag_SetBtnFontSetvisible(0)		
		XBagChangeSendMsg(1,Equip_BagHero_GetHeroID())
	end
	checkB = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check1_equip.png",312,157,256,64)
	checkB:AddFont(font_list[2],15, 0, 57, 15, 100, 20, 0x625b7c)
	checkB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(312,157)
		Click_Font:SetFontText(font_list[2])
		SetBagHeroBagNow(2)
		Equip_BattleBag_draw()		
		XneedBagOpenTime(2)
		XBagChangeSendMsg(2,Equip_BagHero_GetHeroID())
	end
	checkC = wnd:AddButton(path_equip.."check1_equip.png",path_equip.."check2_equip.png",path_equip.."check1_equip.png",512,157,256,64)
	checkC:AddFont(font_list[3],15, 0, 57, 15, 100, 20, 0x625b7c)
	checkC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(512,157)
		Click_Font:SetFontText(font_list[3])
		SetBagHeroBagNow(3)
		Equip_BattleBag_draw()
		XneedBagOpenTime(3)
		XBagChangeSendMsg(3,Equip_BagHero_GetHeroID())
	end
	
	-- 全部物品
	checkD = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB1_equip.png",753,152,128,64)
	checkD:AddFont(font_list[4],15, 8, 0, 0, 110, 50, 0x625b7c)
	checkD.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btnB:SetPosition(753,152)
		Click_FontB:SetFontText(font_list[4])
		
		SetBagEquipIsVisible(1)
		SetBagExpendIsVisible(0)
		SetBagExpend2IsVisible(0)
	end
	-- 时效1
	checkE = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB1_equip.png",850,152,128,64)
	checkE:AddFont(font_list[5],15, 8, 0, 0, 110, 50, 0x625b7c)
	checkE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btnB:SetPosition(850,152)
		Click_FontB:SetFontText(font_list[5])
		
		SetBagEquipIsVisible(0)
		SetBagExpendIsVisible(1)
		SetBagExpend2IsVisible(0)
	end
	
	checkF = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB1_equip.png",947,152,128,64)
	checkF:AddFont(font_list[6],15, 8, 0, 0, 110, 50, 0x625b7c)
	checkF.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btnB:SetPosition(947,152)
		Click_FontB:SetFontText(font_list[6])
		
		SetBagEquipIsVisible(0)
		SetBagExpendIsVisible(0)
		SetBagExpend2IsVisible(1)
	end
	
	
	Click_btn = wnd:AddImage(path_equip.."check3_equip.png",112,157,256,64)
	Click_Font = Click_btn:AddFont(font_list[1],15, 0, 57, 15, 100, 20, 0xbcbcc4)
	
	Click_btnB = wnd:AddImage(path_equip.."checkB3_equip.png",753,152,128,64)
	Click_FontB = Click_btnB:AddFont(font_list[4],15, 8, 0, 0, 110, 50, 0xffffff)
	
	InitBag_ValueUI(G_login_ui,0)
	InitBag_HeroUI(G_login_ui,0)
	
	----------配装UI
	InitBag_EquipUI(G_login_ui,0)
	InitBag_ExpendUI(G_login_ui,0)
	InitBag_Expend_2_UI(G_login_ui,0)
	
	-- Storage
	InitBagStorage_EquipUI(G_login_ui, 0)
	
	checkG = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB1_equip.png",1044,152,128,64)
	checkG:AddFont(font_list[7],15, 0, 33, 15, 100, 20, 0x625b7c)
    checkGLight = wnd:AddImage(path_equip.."checkB3_equip.png",1044,152,128,64)
	checkGLight:AddFont(font_list[7],15, 0, 33, 15, 100, 20, 0xbcbcc4)
	checkGLight:SetVisible(0)
	checkGLight:SetTouchEnabled(0)
	checkG.script[XE_LBUP] = function()
	    if(checkGLight:IsVisible() == true) then
	        SetBagStorageIsVisible(0)
			checkGLight:SetVisible(0)
	    else
		    Bag_StorageSetPosition(340,186)
		    SetBagStorageIsVisible(1)
			checkGLight:SetVisible(1)
	    end
	end
end
function checkStorage_Setclose_Outside()
    SetBagStorageIsVisible(0)
	checkGLight:SetVisible(0)
end


function Equip_allDragXLUP()
    if(g_equip_all_ui:IsVisible() == false or pullPicType.id == 0 or pullPicType.id == nil or g_bag_hero_ui:IsVisible() == false) then
	    return
	end
    local tempRanking = Equip_allDragCheckRect() --判断是否在包裹框
	if(tempRanking == 100) then
	    return
	end	
	XEquip_BagButton_change(tempRanking,equipManage.itemOnlyID[pullPicType.id])
end

function Equip_allDragCheckRect()
	if(CheckEquip_All_ResultByPic(checkD)) then
		return 0
	elseif(CheckEquip_All_ResultByPic(checkE))then
	    return 4
	elseif(CheckEquip_All_ResultByPic(checkF)) then
	    return 5
	else
	    return 100
	end	
end







function SetEquip_allIsVisible(flag) 
	if g_equip_all_ui ~= nil then
		if flag == 1 and g_equip_all_ui:IsVisible() == false then
			g_equip_all_ui:SetVisible(1)
			
			-------第一套配装
			Click_btn:SetPosition(112,157)
			Click_Font:SetFontText(font_list[1])
			
			-- font_num = {"4797 / 4797","1250 / 1250","17","18","650","850","5 | 50%","7 | 80%","20%","50%","1.25","20%","18%","661","530","450","522","105","10%","28%"}
			-- for i,v in pairs(font_ui) do
				-- font_ui[i]:SetFontText(font_num[i],0x6ffefc)
			-- end
			
			-------全部物品
			Click_btnB:SetPosition(753,152)
			Click_FontB:SetFontText(font_list[4])
			Bag_ValueSetPosition(100,200)		
			SetBagValueIsVisible(1)
			Bag_HeroSetPosition(410,208)
			SetBagEquipIsVisible(1)
			SetBagExpendIsVisible(0)
			SetBagExpend2IsVisible(0)
			SetBagHeroIsVisible(1)
			Xgame_equip_checkClickUp()
		elseif flag == 0 and g_equip_all_ui:IsVisible() == true then
			g_equip_all_ui:SetVisible(0)
			SetBagValueIsVisible(0)
			SetBagHeroIsVisible(0)
			SetBagEquipIsVisible(0)
			SetBagExpendIsVisible(0)
			SetBagExpend2IsVisible(0)
			SetBagStorageIsVisible(0)
			checkGLight:SetVisible(0)
		end
	end
end

function GetEquip_allIsVisible()  
    if(g_equip_all_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end


