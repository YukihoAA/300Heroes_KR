 include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local Fontcastsoulcost = {}    		------铸魂消耗栏
local btn_Minus = {}				------铸魂材料减少按钮
local btn_add = {}					------铸魂材料增加按钮
local Curcost = {0,0,0}				------铸魂消耗道具
local Maxcost = {4,5,6}				------铸魂最大消耗道具
local CurrentFont = {}				------铸魂材料数量显示

local EquipName,EquipIcon = nil
local Current,Add,MaxResult = nil
local CurFont,AddFont,MaxFont = " "," "," "


local strSoulItem = {} --拖拽--目标item
strSoulItem.pic = nil
strSoulItem.type = nil
strSoulItem.onlyid = nil

local btn_Yes = nil


function InitEquip_StrSoulUI(wnd, bisopen)
	g_str_Soul_ui = CreateWindow(wnd.id, 200, 200, 450, 470)

	EquipName = g_str_Soul_ui:AddFont("装备名称装备名称",15,  8, 0, -6, 416, 20, 0x49d3f0)
	EquipName:SetVisible(0)
	EquipIcon = g_str_Soul_ui:AddImage(path_equip.."bag_equip.png",180,34,50,50)
	strSoulItem.pic = EquipIcon:AddImage(path_equip.."bag_equip.png",0,0,50,50)
	strSoulItem.pic:SetVisible(0)
	strSoulItem.pic.script[XE_RBUP] = function()
		if(strSoulItem.onlyid == nil or strSoulItem.onlyid == 0) then--id不存在 不响应
			return
	    end
		XEquip_StrSoul_EquipClickUp()--铸魂点击移除装备
	end
	
	
	g_str_Soul_ui:AddImage(path_equip.."HeadShine_equip.png",171,25,68,68)
	
	local NN = g_str_Soul_ui:AddFont("提示：仅铸魂型装备可进行铸魂",11, 0, 126, 133, 250, 20, 0x8295cf)
	NN:SetFontSpace(1,1)
	------装备铸魂
	g_str_Soul_ui:AddImage(path_equip.."CastSoul_equip.png", 178, 114, 64, 16)
	g_str_Soul_ui:AddFont("当前", 15, 0, 84, 158, 200, 20, 0x8295cf)
	g_str_Soul_ui:AddFont("增加", 15, 0, 193, 158, 200, 20, 0x8295cf)
	g_str_Soul_ui:AddFont("结果  |  最大", 15, 0, 284, 158, 200, 20, 0x8295cf)
	
	Current = g_str_Soul_ui:AddFont(CurFont, 15, 8, 0, 0, 205, 390, 0x83d1e6)
	Add = g_str_Soul_ui:AddFont(AddFont, 15, 8, 0, 0, 420, 390, 0x83d1e6)
	MaxResult = g_str_Soul_ui:AddFont(MaxFont, 15, 8, 0, 0, 650, 390, 0x83d1e6)
	
	g_str_Soul_ui:AddImage(path_equip.."CastSoulCoss_equip.png", 25, 245, 64, 16)
	for i=1,3 do
		Fontcastsoulcost[i] = g_str_Soul_ui:AddImage(path_equip.."bag_equip.png",107*i-31,274,50,50)
		Fontcastsoulcost[i]:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)	
		
		btn_Minus[i] = g_str_Soul_ui:AddButton(path_hero.."plus1_hero.png",path_hero.."plus2_hero.png",path_hero.."plus3_hero.png",107*i-32,335,16,16)
		btn_Minus[i]:SetEnabled(0)		
		CurrentFont[i] = btn_Minus[i]:AddFont("0", 15, 8, 0, 0, 50, 13, 0x00ff00)
		btn_add[i] = g_str_Soul_ui:AddButton(path_hero.."add1_hero.png",path_hero.."add2_hero.png",path_hero.."add3_hero.png",107*i+7,335,16,16)
		btn_add[i]:SetEnabled(0)
		btn_Minus[i].script[XE_LBUP] = function()
		    XClickPlaySound(5)
		    XEquip_StrSoul_Minus_XE_LBUP(i)
		end
		
		btn_add[i].script[XE_LBUP] = function()
		    XClickPlaySound(5)
		    XEquip_StrSoul_Plus_XE_LBUP(i)
		end
	end
	Fontcastsoulcost[1].changeimage("../UI/Icon/equip/linghunjingti_s.dds")--小型灵魂晶体
	Fontcastsoulcost[1]:SetTextTip("小型灵魂晶体")
	Fontcastsoulcost[2].changeimage("../UI/Icon/equip/linghunjingti_m.dds")--中型灵魂晶体
	Fontcastsoulcost[2]:SetTextTip("中型灵魂晶体")
	Fontcastsoulcost[3].changeimage("../UI/Icon/equip/linghunjingti_b.dds")--大型灵魂晶体
	Fontcastsoulcost[3]:SetTextTip("大型灵魂晶体")
	
	
	
	
	btn_Yes = g_str_Soul_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",167,400,83,35)
	btn_Yes:AddFont("确定", 15, 8, 0, 0, 83, 35, 0xbcbcc4)
	btn_Yes:SetEnabled(0)
	
	btn_Yes.script[XE_LBUP] = function()
	    XEquip_StrSoul_YseClick()
	end
	
	
	g_str_Soul_ui:SetVisible(bisopen)
end

function Equip_StrSoul_checkRect() --判断是否在包裹框
	if(CheckEquipPullResult(EquipIcon)) then
		return 1
	else
	    return 0
	end
end

function Equip_StrSoul_clean()
    --清空强化装备图片等信息
    strSoulItem.pic.changeimage() 
	strSoulItem.pic:SetVisible(0)
	strSoulItem.onlyid = 0
    strSoulItem.type = 0
	strSoulItem.pic:SetImageTip(0)
	EquipName:SetFontText("")
	EquipName:SetVisible(0)
	Current:SetFontText(" ",0x83d1e6)
	Add:SetFontText(" ",0x83d1e6)
	MaxResult:SetFontText(" ",0x83d1e6)
	for index = 1,3 do
	    Equip_StrSoul_SetTouchPlusEnable(index,0)
		Equip_StrSoul_SetTouchMinusEnable(index,0)
		CurrentFont[index]:SetFontText("0",0x00ff00)
	end
end


function Equip_StrSoul_pullPicXLUP()
    if(g_str_Soul_ui:IsVisible() == false) then
	    return
	end
    local tempRanking = Equip_StrSoul_checkRect() --判断是否在包裹框
	if(tempRanking == 1) then
        XEquip_StrSoul_DragIn(equipManage.itemOnlyID[pullPicType.id])--传给lua信息	
	end
end

function Equip_StrSoul_SmallpullPicXLUP()
   if(g_str_Soul_ui:IsVisible() == false and smallpullPic.pic:IsVisible() == true) then
	    return
	end
    local tempRanking = Equip_StrSoul_checkRect() --判断是否在包裹框
	if(tempRanking == 1) then
        XEquip_StrSoul_DragIn(smallpullPic.onlyId)--传给lua信息	
	end
end

function Equip_StrSoul_RClickUp(id)
    if(g_str_Soul_ui:IsVisible() == false or equipManage.type[id] ~= 3) then
	    return
	end
    XEquip_StrSoul_DragIn(equipManage.itemOnlyID[id])--传给lua信息
end

function Equip_StrSoul_Checktip()
    if(g_str_Soul_ui:IsVisible() == true) then
        for index,value in pairs(equipManage.CitemIndex) do
	        if(strSoulItem.onlyid == equipManage.itemOnlyID[index]) then
			    strSoulItem.pic:SetImageTip(equipManage.tip[index])
			end
	    end
    end	   
end




function Equip_StrSoul_changeinfo(onlyid,strPic,name,tip,itemAnimation) --当装备被拖入时进行切换数据

    strSoulItem.onlyid = onlyid
	strSoulItem.pic.changeimage("..\\"..strPic)--跟换图片
    strSoulItem.type = 10
	strSoulItem.pic:SetVisible(1)	
	EquipName:SetFontText(name,0x49d3f0)
	EquipName:SetVisible(1)
	strSoulItem.pic:SetImageTip(tip)
	for index = 1,3 do
	    Equip_StrSoul_SetTouchPlusEnable(index,1)
	end
	if(strSoulItem.pic:GetBoolImageAnimate() == 1 and itemAnimation == -1) then
	    strSoulItem.pic:CleanImageAnimate()
	elseif(itemAnimation ~= -1) then
	    strSoulItem.pic:EnableImageAnimate(1,itemAnimation,15,5)
    end    
end


function Equip_StrSoul_SetTouchPlusEnable(index,ibool)
    if(ibool == 1) then
	    btn_add[index]:SetEnabled(1)
	else
	    btn_add[index]:SetEnabled(0)
	end
end

function Equip_StrSoul_SetTouchMinusEnable(index,ibool)
    if(ibool == 1) then
	    btn_Minus[index]:SetEnabled(1)
	else
	    btn_Minus[index]:SetEnabled(0)
	end
end

function Equip_StrSoul_SetYesButtonEnable(ibool)
    if(ibool == 1) then
	    btn_Yes:SetEnabled(1)
	else
	    btn_Yes:SetEnabled(0)
	end
end

function Equip_StrSoul_SetfontiCurFont(iCurFont)
    Current:SetFontText(iCurFont,0x83d1e6)
end
function Equip_StrSoul_SetfontiAddFont(iAddFont)
	Add:SetFontText(iAddFont,0x83d1e6)
end
function Equip_StrSoul_SetfontiMaxFont(iMaxFont)
	MaxResult:SetFontText(iMaxFont,0x83d1e6)
end

function Equip_StrSoul_SetSoulNum(index,Num,iColor)
    CurrentFont[index]:SetFontText(Num,iColor)
end




























function SetEquip_StrSoulIsVisible(flag) 
	if g_str_Soul_ui ~= nil then
		if flag == 1 and g_str_Soul_ui:IsVisible() == false then
			g_str_Soul_ui:SetVisible(1)
			XEquip_StrSoul_ClickUp(1)--通知c++开启界面
		elseif flag == 0 and g_str_Soul_ui:IsVisible() == true then
			g_str_Soul_ui:SetVisible(0)
			Equip_StrSoul_clean()
			XEquip_StrSoul_EquipClickUp()--铸魂点击移除装备
		end
	end
end