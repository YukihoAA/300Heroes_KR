include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------装备强化
local Click_btn = nil
local Click_Font = {}

local checkA = nil
local checkB = nil
local checkC = nil
local checkD = nil
local checkE = nil
local checkF = nil
local checkG = nil
local checkH = nil

local checkBag = nil
local checkBagLight = nil
local checkExpand = nil
local checkExpandLight = nil
local checkExpand2 = nil
local checkExpand2Light = nil
local checkStorage = nil
local checkStorageLight = nil



local btn_A,btn_B = nil

local ppx = 23

local Back = nil
local pullPosX = 100
local pullPosY = 100

function EquipInCreateResource()
	n_equip_inside_ui:CreateResource()
	g_bag_value_ui:CreateResource()
	g_bag_hero_ui:CreateResource()
	g_bag_equip_ui:CreateResource()
	g_bag_expend_ui:CreateResource()
	g_bag_expend2_ui:CreateResource()
	g_BagStorage_ui:CreateResource()
	g_str_Strength_ui:CreateResource()
	g_str_Rebuild_ui:CreateResource()
	g_str_Soul_ui:CreateResource()
	g_str_Make_ui:CreateResource()
	g_str_BagSoul_ui:CreateResource()
	g_str_BagMake_ui:CreateResource()
	g_equip_geminlay_ui:CreateResource()
	g_equip_gemsyn_ui:CreateResource()
	g_syn_equip_ui:CreateResource()	
end
function EquipInDeleteResource()
	n_equip_inside_ui:DeleteResource()
	g_bag_value_ui:DeleteResource()
	g_bag_hero_ui:DeleteResource()
	g_bag_equip_ui:DeleteResource()
	g_bag_expend_ui:DeleteResource()
	g_bag_expend2_ui:DeleteResource()
	g_BagStorage_ui:DeleteResource()
	g_str_Strength_ui:DeleteResource()
	g_str_Rebuild_ui:DeleteResource()
	g_str_Soul_ui:DeleteResource()
	g_str_Make_ui:DeleteResource()
	g_str_BagSoul_ui:DeleteResource()
	g_str_BagMake_ui:DeleteResource()
	g_equip_geminlay_ui:DeleteResource()
	g_equip_gemsyn_ui:DeleteResource()
	g_syn_equip_ui:DeleteResource()	
end

function InitEquip_InsideUI(wnd, bisopen)
	n_equip_inside_ui = CreateWindow(wnd.id, (1280-870)/2, (800-518)/2, 870, 518)
	InitMainEquip_Inside(n_equip_inside_ui)
	n_equip_inside_ui:SetVisible(bisopen)
end
function InitMainEquip_Inside(wnd)
	Back = wnd:AddImage(path_equip.."BK1_equip.png",9,8,884,524)

	------关闭、装备、属性
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",855,7,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		SetEquip_InsideIsVisible(0)
	end
	btn_A = wnd:AddCheckButton(path_equip.."flag1_equip.png",path_equip.."flag2_equip.png",path_equip.."flag3_equip.png",0,72,64,64)
	btn_A.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_B:SetCheckButtonClicked(0)
		
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(1)
		-- Bag_HeroSetPosition(270,185)
		SetBagEquipInIsVisible(1)
	end
	btn_B = wnd:AddCheckButton(path_equip.."flag4_equip.png",path_equip.."flag5_equip.png",path_equip.."flag6_equip.png",0,106,64,64)
	btn_B.script[XE_LBDOWN] = function()
		XClickPlaySound(5)		
		btn_A:SetCheckButtonClicked(0)	

		SetBagValueIsVisible(1)
		--Bag_ValueSetPosition(270,200)
		SetBagHeroIsVisible(0)
		SetBagEquipInIsVisible(1)
	end
	
		
	-------界面按钮
	checkA = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",10+ppx,0,128,64)
	checkA:AddFont("装备总览",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkA.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(10+ppx,0)
		for i,v in pairs(Click_Font) do
			if i==1 then
				Click_Font[i]:SetVisible(1)
			else
				Click_Font[i]:SetVisible(0)
			end
		end	
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(1)
		--Bag_HeroSetPosition(270,185)
		SetBagEquipInIsVisible(1)
		SetBagExpendIsVisible(0)		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(0)
		SetEquip_StrBagMakeIsVisible(0)		
		SetEquip_GemInlayIsVisible(0)
		SetEquip_GemSynIsVisible(0)		
		SetSynEquipIsVisible(0)
		
		btn_A:SetVisible(1)
		btn_B:SetVisible(1)
		btn_A:SetCheckButtonClicked(1)	
		btn_B:SetCheckButtonClicked(0)	
	end
	checkB = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",106+ppx,0,128,64)
	checkB:AddFont("强化",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkB.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(106+ppx,0)
		for i,v in pairs(Click_Font) do
			if i==2 then
				Click_Font[i]:SetVisible(1)
			else
				Click_Font[i]:SetVisible(0)
			end
		end	
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(0)
		SetBagEquipInIsVisible(0)	
		SetBagExpendIsVisible(0)		
		SetEquip_StrStrengthIsVisible(1)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(1)
		SetEquip_StrBagMakeIsVisible(0)
		SetEquip_GemInlayIsVisible(0)
		SetEquip_GemSynIsVisible(0)
		SetSynEquipIsVisible(0)
		
		btn_A:SetVisible(0)
		btn_B:SetVisible(0)
	end
	checkC = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",202+ppx,0,128,64)
	checkC:AddFont("重铸",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkC.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(202+ppx,0)
		for i,v in pairs(Click_Font) do
			if i==3 then
				Click_Font[i]:SetVisible(1)
			else
				Click_Font[i]:SetVisible(0)
			end
		end	
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(0)
		SetBagEquipInIsVisible(0)
		SetBagExpendIsVisible(0)		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(1)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(1)
		SetEquip_StrBagMakeIsVisible(0)
		SetEquip_GemInlayIsVisible(0)
		SetEquip_GemSynIsVisible(0)
		SetSynEquipIsVisible(0)
		
		btn_A:SetVisible(0)
		btn_B:SetVisible(0)		
	end
	checkD = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",298+ppx,0,128,64)
	checkD:AddFont("铸魂",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkD.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(298+ppx,0)
		for i,v in pairs(Click_Font) do
			if i==4 then
				Click_Font[i]:SetVisible(1)
			else
				Click_Font[i]:SetVisible(0)
			end
		end	
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(0)
		SetBagEquipInIsVisible(0)
		SetBagExpendIsVisible(0)		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(1)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(1)
		SetEquip_StrBagMakeIsVisible(0)
		SetEquip_GemInlayIsVisible(0)
		SetEquip_GemSynIsVisible(0)
		SetSynEquipIsVisible(0)
		
		btn_A:SetVisible(0)
		btn_B:SetVisible(0)
	end
	checkE = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",394+ppx,0,128,64)
	checkE:AddFont("炼金",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkE.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(394+ppx,0)
		for i,v in pairs(Click_Font) do
			if i==5 then
				Click_Font[i]:SetVisible(1)
			else
				Click_Font[i]:SetVisible(0)
			end
		end	
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(0)
		SetBagEquipInIsVisible(0)
		SetBagExpendIsVisible(0)		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(1)
		SetEquip_StrBagSoulIsVisible(0)
		SetEquip_StrBagMakeIsVisible(1)
		SetEquip_GemInlayIsVisible(0)
		SetEquip_GemSynIsVisible(0)
		SetSynEquipIsVisible(0)
		
		btn_A:SetVisible(0)
		btn_B:SetVisible(0)		
	end
	checkF = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",488+ppx,0,128,64)
	checkF:AddFont("宝石镶嵌",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkF.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(488+ppx,0)
		for i,v in pairs(Click_Font) do
			if i==6 then
				Click_Font[i]:SetVisible(1)
			else
				Click_Font[i]:SetVisible(0)
			end
		end
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(0)
		SetBagEquipInIsVisible(0)
		SetBagExpendIsVisible(0)		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(0)
		SetEquip_StrBagMakeIsVisible(0)
		SetEquip_GemInlayIsVisible(1)
		SetEquip_GemSynIsVisible(0)
		SetSynEquipIsVisible(0)
		
		btn_A:SetVisible(0)
		btn_B:SetVisible(0)
	end
	checkG = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",584+ppx,0,128,64)
	checkG:AddFont("宝石合成",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkG.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(584+ppx,0)
		for i,v in pairs(Click_Font) do
			if i==7 then
				Click_Font[i]:SetVisible(1)
			else
				Click_Font[i]:SetVisible(0)
			end
		end	
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(0)
		SetBagEquipInIsVisible(0)
		SetBagExpendIsVisible(0)		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(0)
		SetEquip_StrBagMakeIsVisible(0)
		SetEquip_GemInlayIsVisible(0)
		SetEquip_GemSynIsVisible(1)
		SetSynEquipIsVisible(0)
		
		btn_A:SetVisible(0)
		btn_B:SetVisible(0)		
	end
	checkH = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",680+ppx,0,128,64)
	checkH:AddFont("物品合成",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkH.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Click_btn:SetPosition(680+ppx,0)
		for i,v in pairs(Click_Font) do
			if i==8 then
				Click_Font[i]:SetVisible(1)
			else
				Click_Font[i]:SetVisible(0)
			end
		end	
		SetBagValueIsVisible(0)
		SetBagHeroIsVisible(0)
		SetBagEquipInIsVisible(0)
		SetBagExpendIsVisible(0)		
		SetEquip_StrStrengthIsVisible(0)
		SetEquip_StrRebuildIsVisible(0)
		SetEquip_StrSoulIsVisible(0)
		SetEquip_StrMakeIsVisible(0)
		SetEquip_StrBagSoulIsVisible(0)
		SetEquip_StrBagMakeIsVisible(0)
		SetEquip_GemInlayIsVisible(0)
		SetEquip_GemSynIsVisible(0)
		SetSynEquipIsVisible(1)
		
		btn_A:SetVisible(0)
		btn_B:SetVisible(0)
	end
	
	Click_btn = wnd:AddImage(path_equip.."checkB3_equip.png",10+ppx,0,128,64)
	local Font_list = {"装备总览","强化","重铸","铸魂","炼金","宝石镶嵌","宝石合成","物品合成"}
	local Font_posx = {30,146,242,338,434,508,604,700}
	for i=1,8 do
		Click_Font[i] = wnd:AddFont(Font_list[i],15, 0, Font_posx[i]+ppx, 15, 100, 20, 0xbcbcc4)
		if i==1 then
			Click_Font[i]:SetVisible(1)
		else
			Click_Font[i]:SetVisible(0)
		end
	end
	
	
	checkBag = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",430+ppx,50,128,64)
	checkBag:AddFont("背包",15, 0, 40, 15, 100, 20, 0x625b7c)
	checkExpand = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",526+ppx,50,128,64)
	checkExpand:AddFont("时效背包I",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkExpand2 = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",622+ppx,50,128,64)
	checkExpand2:AddFont("时效背包II",15, 0, 20, 15, 100, 20, 0x625b7c)
	checkStorage = wnd:AddButton(path_equip.."checkB1_equip.png",path_equip.."checkB2_equip.png",path_equip.."checkB3_equip.png",718+ppx,50,128,64)
	checkStorage:AddFont("仓库",15, 0, 40, 15, 100, 20, 0x625b7c)
	
	checkBagLight = checkBag:AddImage(path_equip.."checkB3_equip.png",0,0,128,64)
	checkBagLight:AddFont("背包",15, 0, 40, 15, 100, 20, 0xbcbcc4)
	checkBagLight:SetVisible(1)
	checkBagLight:SetTouchEnabled(0)
	

	checkExpandLight = checkExpand:AddImage(path_equip.."checkB3_equip.png",0,0,128,64)
	checkExpandLight:AddFont("时效背包I",15, 0, 20, 15, 100, 20, 0xbcbcc4)
	checkExpandLight:SetVisible(0)
	checkExpandLight:SetTouchEnabled(0)
	

	checkExpand2Light = checkExpand2:AddImage(path_equip.."checkB3_equip.png",0,0,128,64)
	checkExpand2Light:AddFont("时效背包II",15, 0, 20, 15, 100, 20, 0xbcbcc4)
	checkExpand2Light:SetVisible(0)
	checkExpand2Light:SetTouchEnabled(0)
	

	checkStorageLight = checkStorage:AddImage(path_equip.."checkB3_equip.png",0,0,128,64)
	checkStorageLight:AddFont("仓库",15, 0, 40, 15, 100, 20, 0xbcbcc4)
	checkStorageLight:SetVisible(0)	
	checkStorageLight:SetTouchEnabled(0)
	

	checkBag.script[XE_LBUP] = function()
	    if(g_bag_equip_ui:IsVisible() == false) then
	        SetEquip_InsideSetLight(1)
			if(g_bag_expend_ui:IsVisible() == true) then
			   SetBagExpendIsVisible(0)
			elseif(g_bag_expend2_ui:IsVisible() == true) then
			   SetBagExpend2IsVisible(0)
			end  
            SetBagEquipIsVisible(1)			
		end
	end
	checkExpand.script[XE_LBUP] = function()
	    if(g_bag_expend_ui:IsVisible() == false) then
	        SetEquip_InsideSetLight(2)
			if(g_bag_equip_ui:IsVisible() == true) then
			   SetBagEquipIsVisible(0)
			elseif(g_bag_expend2_ui:IsVisible() == true) then
			   SetBagExpend2IsVisible(0)
			end  
            SetBagExpendIsVisible(1)			
		end
	end
	checkExpand2.script[XE_LBUP] = function()
        if(g_bag_expend2_ui:IsVisible() == false) then
	        SetEquip_InsideSetLight(3)
			if(g_bag_equip_ui:IsVisible() == true) then
			   SetBagEquipIsVisible(0)
			elseif(g_bag_expend_ui:IsVisible() == true) then
			   SetBagExpendIsVisible(0)
			end  
            SetBagExpend2IsVisible(1)			
		end
	end
	checkStorage.script[XE_LBUP] = function()
	    if(g_BagStorage_ui:IsVisible() == false) then
		    SetEquip_InsideSetLight(4)
			local BlockX,BlockY = n_equip_inside_ui:GetPosition()
			Bag_StorageSetPosition(BlockX+7,BlockY+35)
			SetBagStorageIsVisible(1)
		else
		    SetEquip_InsideSetLight(4)
			SetBagStorageIsVisible(0)
		end
	end	
	
	n_equip_inside_ui:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	
    Back.script[XE_LBDOWN] = function()
	    n_equip_inside_ui:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
		local L,T = n_equip_inside_ui:GetPosition()
		pullPosX = XGetCursorPosX()-L
		pullPosY = XGetCursorPosY()-T
	end
	Back.script[XE_LBUP] = function()
	    n_equip_inside_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
	end	
	n_equip_inside_ui.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(n_equip_inside_ui:IsVisible()) then
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

            GetPositionAndSet(g_bag_equip_ui,n_equip_inside_ui,PosX,PosY)
            GetPositionAndSet(g_bag_expend_ui,n_equip_inside_ui,PosX,PosY)
            GetPositionAndSet(g_bag_expend2_ui,n_equip_inside_ui,PosX,PosY)
            GetPositionAndSet(g_BagStorage_ui,n_equip_inside_ui,PosX,PosY)
            GetPositionAndSet(g_bag_hero_ui,n_equip_inside_ui,PosX,PosY)
            GetPositionAndSet(g_bag_value_ui,n_equip_inside_ui,PosX,PosY)
            GetPositionAndSet(g_equip_gemsyn_ui,n_equip_inside_ui,PosX,PosY)
            GetPositionAndSet(g_equip_geminlay_ui,n_equip_inside_ui,PosX,PosY)	

            GetPositionAndSet(g_str_BagMake_ui,n_equip_inside_ui,PosX,PosY)	
            GetPositionAndSet(g_str_BagSoul_ui,n_equip_inside_ui,PosX,PosY)	
            GetPositionAndSet(g_str_Make_ui,n_equip_inside_ui,PosX,PosY)	
            GetPositionAndSet(g_str_Rebuild_ui,n_equip_inside_ui,PosX,PosY)	
            GetPositionAndSet(g_str_Soul_ui,n_equip_inside_ui,PosX,PosY)	
			
            GetPositionAndSet(g_str_Strength_ui,n_equip_inside_ui,PosX,PosY)	
            GetPositionAndSet(g_syn_equip_ui,n_equip_inside_ui,PosX,PosY)	
            GetPositionAndSet(g_equip_synthesize_ui,n_equip_inside_ui,PosX,PosY)				
			
		    n_equip_inside_ui:SetAbsolutePosition(PosX,PosY)
		else
	        n_equip_inside_ui:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
		end
	end
end

function GetPositionAndSet(g_ui,g_ui2,posx,posy)--子--父--父新坐标
    local L,T = g_ui:GetPosition()--子
	local L1,T1 = g_ui2:GetPosition()--父
	g_ui:SetPosition(posx+(L-L1),posy+(T-T1))
end

function checkStorage_Setclose_Inside()
    checkStorageLight:SetVisible(0)
	SetBagStorageIsVisible(0)
end

function SetEquip_InsideSetLight(index)
    if(index == 0) then
        checkBagLight:SetVisible(0)
	   	checkExpandLight:SetVisible(0)
		checkExpand2Light:SetVisible(0)
		checkStorageLight:SetVisible(0)	
		checkBag:SetVisible(0)
		checkExpand:SetVisible(0)
		checkExpand2:SetVisible(0)
		checkStorage:SetVisible(0)
	elseif(index == 1) then
	    checkBagLight:SetVisible(1)
	   	checkExpandLight:SetVisible(0)
		checkExpand2Light:SetVisible(0)
	elseif(index == 2) then
	    checkBagLight:SetVisible(0)
	   	checkExpandLight:SetVisible(1)
		checkExpand2Light:SetVisible(0)
	elseif(index == 3) then
	    checkBagLight:SetVisible(0)
	   	checkExpandLight:SetVisible(0)
		checkExpand2Light:SetVisible(1)
	elseif(index == 4) then
	    if(checkStorageLight:IsVisible() == false) then
	        checkStorageLight:SetVisible(1)
		else	
		    checkStorageLight:SetVisible(0)
		end	
	end
end


function Equip_allInsideDragXLUP()
    if(n_equip_inside_ui:IsVisible() == false or pullPicType.id == 0 or pullPicType.id == nil or g_bag_hero_ui:IsVisible() == false) then
	    return
	end
    local tempRanking = Equip_allInsideDragCheckRect() --判断是否在包裹框
	if(tempRanking == 100) then
	    return
	end	
	XEquip_BagButton_change(tempRanking,equipManage.itemOnlyID[pullPicType.id])
end

function Equip_allInsideDragCheckRect()
	if(CheckEquip_All_ResultByPic(checkBag)) then
		return 0
	elseif(CheckEquip_All_ResultByPic(checkExpand))then
	    return 4
	elseif(CheckEquip_All_ResultByPic(checkExpand2)) then
	    return 5
	else
	    return 100
	end	
end




function SetClickHeroInfoDown()
	btn_A:SetVisible(1)
	btn_B:SetVisible(1)
	btn_A:SetCheckButtonClicked(0)	
	btn_B:SetCheckButtonClicked(1)
end

function SetEquip_InsideIsVisible(flag) 
	if n_equip_inside_ui ~= nil then
		if flag == 1 and n_equip_inside_ui:IsVisible() == false then
		
			EquipInCreateResource()
		
			n_equip_inside_ui:SetVisible(1)
			
			Click_btn:SetPosition(10+ppx,0)
			for i,v in pairs(Click_Font) do
				if i==1 then
					Click_Font[i]:SetVisible(1)
				else
					Click_Font[i]:SetVisible(0)
				end
			end	
			--Bag_HeroSetPosition(270,185)
			SetBagHeroIsVisible(1)			
			SetBagEquipInIsVisible(1)			
			
			btn_A:SetVisible(1)
			btn_B:SetVisible(1)
			btn_A:SetCheckButtonClicked(1)	
			btn_B:SetCheckButtonClicked(0)	
			
		elseif flag == 0 and n_equip_inside_ui:IsVisible() == true then
		
			EquipInDeleteResource()
		
			n_equip_inside_ui:SetVisible(0)
			
			SetBagValueIsVisible(0)
			SetBagHeroIsVisible(0)
			SetBagEquipInIsVisible(0)
			SetBagExpendIsVisible(0)
			
			SetEquip_StrStrengthIsVisible(0)
			SetEquip_StrRebuildIsVisible(0)
			SetEquip_StrSoulIsVisible(0)
			SetEquip_StrMakeIsVisible(0)
			SetEquip_StrBagSoulIsVisible(0)
			SetEquip_StrBagMakeIsVisible(0)
			
			SetEquip_GemInlayIsVisible(0)
			SetEquip_GemSynIsVisible(0)
			
			SetSynEquipIsVisible(0)
			Xgame_equip_checkReturn()
		end
	end
end
-- windowswidth = nil
-- windowsheight = nil
function SetBagEquipInIsVisible(flag) 
	if g_bag_equip_ui ~= nil then
		if flag == 1 and g_bag_equip_ui:IsVisible() == false and g_bag_expend_ui:IsVisible() == false and g_bag_expend2_ui:IsVisible() == false  then
			local L,T = n_equip_inside_ui:GetPosition()
	        Bag_EquipSetPosition(L+396, T+94)
			Bag_BagExpendSetPosition(L+395, T+95)
			Bag_BagExpend2SetPosition(L+395, T+95)
			SetBagEquipIsVisible(1)
			checkBag:SetVisible(1)
		    checkExpand:SetVisible(1)
		    checkExpand2:SetVisible(1)
		    checkStorage:SetVisible(1)
			SetEquip_InsideSetLight(1)
		elseif flag == 0 and (g_bag_equip_ui:IsVisible() == true or g_bag_expend_ui:IsVisible() == true or g_bag_expend2_ui:IsVisible() == true) then			
		   
		    SetBagEquipIsVisible(0)
			SetBagExpendIsVisible(0)
			SetBagExpend2IsVisible(0)
			SetBagStorageIsVisible(0)
			SetEquip_InsideSetLight(0)
			Bag_EquipSetPosition(700, 220)
			Bag_BagExpendSetPosition(700, 220)
			Bag_BagExpend2SetPosition(700, 220)
		end
	end
end


function GetEquip_InsideIsVisible()  
    if n_equip_inside_ui~=nil and n_equip_inside_ui:IsVisible()==true then
       return 1
    else
       return 0	   
    end
end