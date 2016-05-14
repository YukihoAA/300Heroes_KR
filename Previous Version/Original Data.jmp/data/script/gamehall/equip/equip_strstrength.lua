include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local Star = {}    							------强化过的星星
local StarUn = {}    						------没强化过的星星（不亮）
local EquipLV = 0							------当前装备等级
local StrCost = {}							------强化消耗
local StrCostFont = {}
local StrNeedEX = nil
local StrNeedEXTop = nil
local IsStrUseYes = nil

local EquipName,EquipIcon,Cur_property,Next_property = nil
local Cur_font = "旧属性"
local Next_font = "新属性"

local Cur_font_skill ="旧属性"
local Next_font_skill ="新属性"

local strengthItem = {} --拖拽--目标item
strengthItem.pic = nil
strengthItem.onlyid = nil
strengthItem.type = nil

local EquipSkillUpdate = nil

local EquipQualityUpdate = nil

local ShowType = 0 --0都不显示,1显示技能,2显示属性


local MedalNum = {0,0,0} --战场奖牌--竞技场奖牌--装备升级符


function InitEquip_StrStrengthUI(wnd, bisopen)
	g_str_Strength_ui = CreateWindow(wnd.id, 200, 200, 450, 470)
	
	EquipName = g_str_Strength_ui:AddFont("装备名称装备名称",15,  8, 0, -6, 416, 20, 0x49d3f0)
	EquipName:SetVisible(0)
	EquipIcon = g_str_Strength_ui:AddImage(path_equip.."bag_equip.png",180,34,50,50)
	strengthItem.pic = EquipIcon:AddImage(path_equip.."bag_equip.png",0,0,50,50)
	strengthItem.pic:SetVisible(0)
	strengthItem.pic.script[XE_RBUP] = function()
		if(strengthItem.onlyid == nil) then--id不存在 不响应
			return
	    end
		XEquip_StrStrength_EquipClickUp()
	end
	
	
	
	g_str_Strength_ui:AddImage(path_equip.."HeadShine_equip.png",171,25,68,68)
	g_str_Strength_ui:AddImage(path_equip.."NowLV_equip.png", 83, 130, 64, 16)
	g_str_Strength_ui:AddImage(path_equip.."NextLV_equip.png", 280, 130, 64, 16)
	g_str_Strength_ui:AddImage(path_equip.."StrCost_equip.png", 25, 255, 64, 16)
	
	----星星
	for i=1,15 do
		StarUn[i] = g_str_Strength_ui:AddImage(path_equip.."StarUn_equip.png",36+i*21,99,32,32)
		Star[i] = g_str_Strength_ui:AddImage(path_equip.."Star_equip.png",36+i*21,99,32,32)
		Star[i]:SetVisible(0)
	end
	
	
	Cur_property = g_str_Strength_ui:AddFont(Cur_font, 12, 0, 80, 150, 150, 100, 0x8295cf)
	Cur_property:SetFontSpace(1,0)
	Cur_property:SetVisible(0)--初始文字不可见
	Next_property = g_str_Strength_ui:AddFont(Next_font, 12, 0, 274, 150, 150, 100, 0x8295cf)
	Next_property:SetFontSpace(1,0)
	Next_property:SetVisible(0)--初始文字不可见
	
	------强化消耗
	for i=1,3 do
		StrCost[i] = g_str_Strength_ui:AddImage(path_equip.."bag_equip.png",14+i*70,287,50,50)
		StrCost[i]:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)	
		StrCostFont[i] = StrCost[i]:AddFont("12/99",12, 8, 22, -60, 100, 15, 0x49d3f0)
	end
	Equip_StrStrength_medalClean()
	StrCost[1].changeimage("../UI/Icon/equip/jiangpai1.dds")--战场奖牌
	StrCost[1]:SetTextTip("战场奖牌")
	StrCost[2].changeimage("../UI/Icon/equip/jiangpai2.dds")--竞技场奖牌
	StrCost[2]:SetTextTip("竞技场奖牌")
	StrCost[3].changeimage("../UI/Icon/equip/shengjifu.dds")--装备升级符
	StrCost[3]:SetTextTip("装备升级符")
	
	StrNeedEX = g_str_Strength_ui:AddImage(path_equip.."bag_equip.png",326,287,50,50)
	StrNeedEXTop = StrNeedEX:AddImage(path_equip.."bag_equip.png",0,0,50,50)
	StrNeedEXTop:SetVisible(0)
	StrNeedEX:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)	

	

	
	--使用强化幸运卡
	local IsStrUse = StrNeedEX:AddImage(path_equip.."DraWBK_equip.png",-16,78,32,32)
	IsStrUse:SetTouchEnabled(1)
	IsStrUseYes = IsStrUse:AddImage(path_equip.."Draw_equip.png",2,-2,32,32)
	IsStrUseYes:SetTouchEnabled(0)	
	IsStrUseYes:SetVisible(0)
	local AM1 = StrNeedEX:AddFont("使用强化幸运卡",11, 0, 11, 81, 200, 20, 0x8295cf)
	AM1:SetFontSpace(1,1)
	IsStrUse.script[XE_LBUP] = function()
	    if(IsStrUseYes:IsVisible() == true) then
		    XlwantUseLuckyCard(2) --2为不使用
		else
		    XlwantUseLuckyCard(1)
		end
	end
	
	
	
	
	EquipSkillUpdate = g_str_Strength_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",90,400,83,35)
	EquipSkillUpdate:AddFont("技能升级", 15, 8, 0, 0, 83, 35, 0xbcbcc4)
	EquipSkillUpdate.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XEquipSkillUpdate_XE_LBUP(1,strengthItem.onlyid)
	end	
	EquipSkillUpdate.script[XE_ONHOVER] = function()
		if(strengthItem.onlyid == nil or strengthItem.onlyid == 0) then--id不存在 不响应
			return
	    end
		Cur_property:SetFontText(Cur_font_skill,0x8295cf)
		Next_property:SetFontText(Next_font_skill,0x8295cf)
		Cur_property:SetVisible(1)
		Next_property:SetVisible(1)
		ShowType = 1
	end
	EquipSkillUpdate:SetEnabled(0)--初始设置不可响应时间
	
	
	
	
	
	EquipQualityUpdate = g_str_Strength_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",243,400,83,35)
	EquipQualityUpdate:AddFont("属性升级", 15, 8, 0, 0, 83, 35, 0xbcbcc4)
	EquipQualityUpdate.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XEquipQualityUpdate_XE_LBUP(1,strengthItem.onlyid)
	end	
	EquipQualityUpdate.script[XE_ONHOVER] = function()
		if(strengthItem.onlyid == nil or strengthItem.onlyid == 0) then--id不存在 不响应
			return
	    end
		Cur_property:SetFontText(Cur_font,0x8295cf)
		Next_property:SetFontText(Next_font,0x8295cf)
		Cur_property:SetVisible(1)
		Next_property:SetVisible(1)
		ShowType = 2
	end
	EquipQualityUpdate:SetEnabled(0)--初始设置不可响应时间
	local AM2 = g_str_Strength_ui:AddFont("有主动技能的装备强化",11, 0, 65, 443, 250, 20, 0x8295cf)	
	AM2:SetFontSpace(1,1)
	g_str_Strength_ui:SetVisible(bisopen)
end

function Equip_StrStrength_Checktip()
    if(g_str_Strength_ui:IsVisible() == true) then
        for index,value in pairs(equipManage.CitemIndex) do
	        if(strengthItem.onlyid == equipManage.itemOnlyID[index]) then
			    strengthItem.pic:SetImageTip(equipManage.tip[index])
			end
	    end
    end	   
end

function Equip_StrStrength_checkYes(ibool)
    if(ibool == 1) then
	    IsStrUseYes:SetVisible(1)
	else
	    IsStrUseYes:SetVisible(0)
	end	
end


function Equip_StrStrength_checkRect() --判断是否在包裹框
	if(CheckEquipPullResult(EquipIcon)) then
		return 1
	else
	    return 0
	end
end

function Equip_StrStrength_clean()
    --清空强化装备图片等信息
    strengthItem.pic.changeimage() 
	strengthItem.pic:SetVisible(0)
	strengthItem.onlyid = nil
    strengthItem.type = 0
	strengthItem.pic:SetImageTip(0)
	EquipName:SetFontText(" ")
	EquipName:SetVisible(0)
	for i = 1,15 do
	    Star[i]:SetVisible(0)
	end	
	Equip_StrStrength_Qualityvisible(0)
	Equip_StrStrength_Skillvisible(0)
	--文字输出端清空
	Cur_property:SetFontText(" ")
	Next_property:SetFontText(" ")
	Cur_property:SetVisible(0)
	Next_property:SetVisible(0)
	
	Cur_font = "旧属性"
    Next_font = "新属性"

    Cur_font_skill ="旧属性"
    Next_font_skill ="新属性"
	--清空奖牌数量
	Equip_StrStrength_medalClean()
	ShowType = 0
	StrNeedEXTop:SetVisible(0)
end



function Equip_StrStrength_pullPicXLUP()
    if(g_str_Strength_ui:IsVisible() == false) then
	    return
	end
    local tempRanking = Equip_StrStrength_checkRect() --判断是否在包裹框
	if(tempRanking == 1) then
	    Equip_StrStrength_clean()
        XEquip_StrStrength_NeedItemRaiseInfo(1,equipManage.itemOnlyID[pullPicType.id])	
	end
end

function Equip_StrStrength_RClickUp(id)
    if(g_str_Strength_ui:IsVisible() == false or equipManage.type[id] ~= 3) then
	    return
	end
	Equip_StrStrength_clean()
    XEquip_StrStrength_NeedItemRaiseInfo(1,equipManage.itemOnlyID[id])		
end


function Equip_StrStrength_changeinfo(onlyid,strPic,name,tip,itemAnimation) --当装备被拖入时进行切换数据	
    if(g_str_Strength_ui:IsVisible() == false) then
	    return
	end
    strengthItem.onlyid = onlyid
	strengthItem.pic.changeimage("..\\"..strPic)--跟换图片
    strengthItem.type = 10
	strengthItem.pic:SetVisible(1)	
	EquipName:SetFontText(name,0x49d3f0)
	EquipName:SetVisible(1)
	strengthItem.pic:SetImageTip(tip)
	if(strengthItem.pic:GetBoolImageAnimate() == 1 and itemAnimation == -1) then
	    strengthItem.pic:CleanImageAnimate()
	elseif(itemAnimation ~= -1) then
	    strengthItem.pic:EnableImageAnimate(1,itemAnimation,15,5)
    end    
 end
 
 

function Equip_StrStrength_SetDataLevel(ilevel)
    --添加星星
	if(g_str_Strength_ui:IsVisible()==false) then
	    return
	end	
    local tilevel = ilevel
	for i = 1,tilevel do
	    Star[i]:SetVisible(1)
	end	
	if(ilevel == 15 and strengthItem.pic:GetBoolImageAnimate() == 0) then
	    strengthItem.pic:EnableImageAnimate(1,6,15,5)
    end   
	Equip_StrStrength_SetNeedEX(ilevel)
end

function Equip_StrStrength_SetData_Word(word_1,word_2,index)
    if(index == 2) then
	    Cur_font = word_1
        Next_font = word_2
	elseif(index == 1) then
	    Cur_font_skill = word_1
	    Next_font_skill = word_2	
	end
end

function Equip_StrStrength_Qualityvisible(index)
    if(index == 1) then
        EquipQualityUpdate:SetEnabled(1)
	else
        EquipQualityUpdate:SetEnabled(0)
	end
end

function Equip_StrStrength_Skillvisible(index)
    if(index == 1) then
        EquipSkillUpdate:SetEnabled(1)
	else
        EquipSkillUpdate:SetEnabled(0)
	end
end

function Equip_StrStrength_medalCost(num_1,num_2,num_3)
    Equip_StrStrength_checkin()
    StrCostFont[1]:SetFontText(num_1.."/"..MedalNum[1],0x49d3f0)
	StrCostFont[2]:SetFontText(num_2.."/"..MedalNum[2],0x49d3f0)
	StrCostFont[3]:SetFontText(num_3.."/"..MedalNum[3],0x49d3f0)
	for i = 1,3 do
		StrCostFont[i]:SetVisible(1)
	end
end

function Equip_StrStrength_medalClean()
    for i = 1,3 do
	    StrCostFont[i]:SetFontText("0/"..MedalNum[i],0x49d3f0)
	end
end

function Equip_StrStrength_checkin()
    MedalNum[1],MedalNum[2],MedalNum[3] = game_equip_getMadel()
	StrCostFont[1]:SetFontText("0/"..MedalNum[1],0x49d3f0)
	StrCostFont[2]:SetFontText("0/"..MedalNum[2],0x49d3f0)
	StrCostFont[3]:SetFontText("0/"..MedalNum[3],0x49d3f0)
end
function Equip_StrStrength_MedalNumClean()
    for i = 1,3 do
	    MedalNum[i] = 0
	end
end

function Equip_StrStrength_ShowlevelUP()
	if(ShowType == 1) then
	    Cur_property:SetFontText(Cur_font_skill,0x8295cf)
		Next_property:SetFontText(Next_font_skill,0x8295cf)
		Cur_property:SetVisible(1)
		Next_property:SetVisible(1)
    elseif(ShowType == 2) then
	    Cur_property:SetFontText(Cur_font,0x8295cf)
		Next_property:SetFontText(Next_font,0x8295cf)
		Cur_property:SetVisible(1)
		Next_property:SetVisible(1)
	end	
end

function Equip_StrStrength_SetNeedEX(ilevel)
    if(ilevel<15 and ilevel>= 0) then		
		StrNeedEXTop.changeimage("../UI/Icon/other/ico_"..(ilevel+7501)..".dds")
	    StrNeedEXTop:SetVisible(1)
	else
	    StrNeedEXTop:SetVisible(0)
	end
end
function Equip_StrStrength_SetNeedEXTip(tip)
    StrNeedEXTop:SetImageTip(tip)
end



function Equip_SetCheckButton(index)
    IsStrUseYes:SetVisible(index)
end




function SetEquip_StrStrengthIsVisible(flag) 
	if g_str_Strength_ui ~= nil then
		if flag == 1 and g_str_Strength_ui:IsVisible() == false then
			g_str_Strength_ui:SetVisible(1)	
			Equip_StrStrength_checkin()
			XEquip_StrStrength_ClickUp(1)--通知c++开启界面
		elseif flag == 0 and g_str_Strength_ui:IsVisible() == true then
			g_str_Strength_ui:SetVisible(0)
			Equip_StrStrength_clean()
			XEquip_StrStrength_EquipClickUp()
			Equip_StrStrength_MedalNumClean()
			CancelAutaStrength()
		end
	end
end
