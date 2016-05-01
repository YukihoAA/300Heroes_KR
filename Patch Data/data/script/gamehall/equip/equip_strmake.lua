include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


local Cur_property,Next_property = nil

local EquipName,EquipIcon = nil

local makeCostIcon = nil

local btn_recover,btn_make = nil --两个按键

local Cur_font = ""
local Next_font = ""

local strMakeItem = {} --装备
strMakeItem.pic = nil
strMakeItem.onlyid = nil

local strCostItem = {} --装备
strCostItem.pic = nil
strCostItem.onlyid = nil



function InitEquip_StrMakeUI(wnd, bisopen)
	g_str_Make_ui = CreateWindow(wnd.id, 200, 200, 450, 470)
	
	EquipName = g_str_Make_ui:AddFont("装备名称",15,  8, 0, -6, 416, 20, 0x49d3f0)
	EquipName:SetVisible(0)
	EquipIcon = g_str_Make_ui:AddImage(path_equip.."bag_equip.png",180,34,50,50)
	strMakeItem.pic = EquipIcon:AddImage(path_equip.."bag_equip.png",0,0,50,50)
	strMakeItem.pic:SetVisible(0)
	strMakeItem.pic.script[XE_RBUP] = function()
	    XstrMakeItemClickRUP()
	end
	
	
	g_str_Make_ui:AddImage(path_equip.."HeadShine_equip.png",171,25,68,68)
	g_str_Make_ui:AddImage(path_equip.."strRefine_equip.png", 178, 114, 64, 16)
	g_str_Make_ui:AddImage(path_equip.."RefineCost_equip.png",25,245,64,16)
	makeCostIcon = g_str_Make_ui:AddImage(path_equip.."bag_equip.png",183,274,50,50)
	strCostItem.pic = makeCostIcon:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
	strCostItem.pic:SetVisible(0)
	strCostItem.pic.script[XE_RBUP] = function()
	    XstrCostItemClickRUP()
	end
	
    g_str_Make_ui:AddImage(path_shop.."iconside_shop.png",181,272,54,54)	
	--两个按键
	btn_recover = g_str_Make_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",90,400,83,35)
	btn_recover:AddFont("还原", 15, 8, 0, 0, 83, 35, 0xbcbcc4)
	btn_recover:SetEnabled(0)
	btn_make = g_str_Make_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",243,400,83,35)
	btn_make:AddFont("炼金", 15, 8, 0, 0, 83, 35, 0xbcbcc4)
	btn_make:SetEnabled(0)
	--属性更改输出
	Cur_property = g_str_Make_ui:AddFont(Cur_font, 12, 0, 60, 150, 150, 100, 0x49d3f0)
	Cur_property:SetFontSpace(1,0)
	Next_property = g_str_Make_ui:AddFont(Next_font, 12, 0, 230, 150, 150, 100, 0x49d3f0)
	Next_property:SetFontSpace(1,0)
	
	btn_recover.script[XE_LBUP] = function()
	    Xbtn_recoverXELBUP()
	end
	
	btn_make.script[XE_LBUP] = function()
	    Xbtn_makeXELBUP()
	end
	
	

	g_str_Make_ui:SetVisible(bisopen)
end

function Equip_StrMake_checkRect() --判断是否在包裹框
	if(CheckEquipPullResult(EquipIcon)) then
		return 1
	else
	    return 0
	end
end

function Equip_StrCost_checkRect() --判断是否在包裹框
	if(CheckEquipPullResult(makeCostIcon)) then
		return 1
	else
	    return 0
	end
end

function Equip_StrMake_clean()
    --清空强化装备图片等信息
	strMakeItem.pic.changeimage()
    strMakeItem.onlyid = 0
    strMakeItem.type = 0
	strMakeItem.pic:SetImageTip(0)
	strMakeItem.pic:SetVisible(0)
	
	strCostItem.pic.changeimage()
    strCostItem.onlyid = 0
    strCostItem.type = 0
	strCostItem.pic:SetImageTip(0)	
	strCostItem.pic:SetVisible(0)
	
	Cur_property:SetFontText("")
	Next_property:SetFontText("")
	btn_recover:SetEnabled(0)
	btn_make:SetEnabled(0)
	EquipName:SetFontText("")
	EquipName:SetVisible(0)
	
end


function Equip_StrMake_changeinfo(onlyid,strPic,name,tip,itemAnimation) --当装备被拖入时进行切换数据
    if(g_str_Make_ui:IsVisible() == false) then
	    return
	end
    strMakeItem.onlyid = onlyid
	strMakeItem.pic.changeimage("..\\"..strPic)--跟换图片
    strMakeItem.type = 3
	strMakeItem.pic:SetVisible(1)	
	EquipName:SetFontText(name,0x49d3f0)
	EquipName:SetVisible(1)
	strMakeItem.pic:SetImageTip(tip)
	if(strMakeItem.pic:GetBoolImageAnimate() == 1 and itemAnimation == -1) then
	    strMakeItem.pic:CleanImageAnimate()
	elseif(itemAnimation ~= -1) then
	    strMakeItem.pic:EnableImageAnimate(1,itemAnimation,15,5)
    end    
end

function Equip_StrCost_clean()
	strCostItem.pic.changeimage()
    strCostItem.onlyid = 0
    strCostItem.type = 0
	strCostItem.pic:SetImageTip(0)	
	strCostItem.pic:SetVisible(0)
	btn_recover:SetEnabled(0)
	btn_make:SetEnabled(0)
	Cur_property:SetFontText("")
	Next_property:SetFontText("")
end

function Equip_StrMake_Cost_changeinfo(onlyid,strPic,strPic1,strPic2,tip) --当装备被拖入时进行切换数据
    if(g_str_Make_ui:IsVisible() == false) then
	    return
	end
    strCostItem.onlyid = onlyid
	strCostItem.pic.changeimageMultiple("..\\"..strPic,"..\\"..strPic1,"..\\"..strPic2)--跟换图片
    strCostItem.type = 3
	strCostItem.pic:SetVisible(1)	
	strCostItem.pic:SetImageTip(tip)
end

-------------------------------------------------------------------------------------------
function Equip_StrMake_pullPicXLUP()
    if(g_str_Make_ui:IsVisible() == false or pullPicType.type ~=3) then
	    return
	end
	local tempRanking = Equip_StrMake_checkRect() --判断是否在包框
	if(tempRanking == 1) then
	    Equip_StrMake_clean()
        XEquip_Make_DragIn(1,equipManage.itemOnlyID[pullPicType.id])
	end
end

function Equip_StrCost_pullPicXLUP()
    if(g_str_Make_ui:IsVisible() == false or pullPicType.type ~=5) then
	    return
	end
	local tempRanking = Equip_StrCost_checkRect() --判断是否在包裹框
	if(tempRanking == 1) then
	    Equip_StrCost_clean()
        XEquip_Make_DragIn(1,equipManage.itemOnlyID[pullPicType.id])	
	end
end
-------------------------------------------------------------------------------------------
function Equip_StrMake_RClickUp(id)
    if(g_str_Make_ui:IsVisible() == false or equipManage.type[id] ~= 3) then
	    return
	end
    XEquip_Make_DragIn(1,equipManage.itemOnlyID[id])
end

function Equip_StrCost_RClickUp(id)
    if(g_str_Make_ui:IsVisible() == false or equipManage.type[id] ~= 5) then
	    return
	end
    XEquip_Make_DragIn(1,equipManage.itemOnlyID[id]) 
end

-- function Equip_StrMake_Storage()
    -- if(g_str_Make_ui:IsVisible() == false) then
	    -- return
	-- end
	-- local itemChangeRank = GetitemChangeRanking()
	-- XEquip_Make_DragIn(1,equipManage.itemOnlyID[itemChangeRank+1]) 
-- end

-------------------------------------------------------------------------------------------

function Equip_StrMake_ShowAttrClean()
    if(g_str_Make_ui:IsVisible() == false) then
	    return
	end
	Cur_property:SetFontText("")
	Next_property:SetFontText("")
end

function Equip_StrMake_ShowAttr(word1,word2)
    if(g_str_Make_ui:IsVisible() == false) then
	    return
	end
	Cur_property:SetFontText(word1)
	Next_property:SetFontText(word2)
end
function Equip_StrMake_SetRecoverEnable(ibool)
    if(g_str_Make_ui:IsVisible() == false) then
	    return
	end
	btn_recover:SetEnabled(ibool)
end	
function Equip_StrMake_SetMakeEnable(ibool)
    if(g_str_Make_ui:IsVisible() == false) then
	    return
	end
	btn_make:SetEnabled(ibool)
end	

function Equip_StrMake_Checktip()
    if(g_str_Make_ui:IsVisible() == true) then
        for index,value in pairs(equipManage.CitemIndex) do
	        if(strMakeItem.onlyid == equipManage.itemOnlyID[index]) then
			    strMakeItem.pic:SetImageTip(equipManage.tip[index])
			end
	    end
    end	   
end



function SetEquip_StrMakeIsVisible(flag) 
	if g_str_Make_ui ~= nil then
		if flag == 1 and g_str_Make_ui:IsVisible() == false then
			g_str_Make_ui:SetVisible(1)
			XEquipMakeClick()
		elseif flag == 0 and g_str_Make_ui:IsVisible() == true then
			g_str_Make_ui:SetVisible(0)
			Equip_StrMake_clean()
			XstrMakeItemClickRUP()
		end
	end
end