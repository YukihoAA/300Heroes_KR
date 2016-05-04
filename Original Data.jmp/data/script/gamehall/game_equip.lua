include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


-------------装备界面UI
local btn_equip_allEquip = nil
local btn_equip_strEquip = nil
local btn_equip_stoneInlay = nil
local btn_equip_synthesize = nil
local btn_ListBK = nil

 ----装备的各种数据-----------------------------------做成公共数据
equipManage = {}--装备数据库
equipManage.name = {} --装备名称
equipManage.id = {} --装备图片在库里的ID
equipManage.CitemIndex = {} --物品自身的类型Id
equipManage.CpackCindex = {} --物品在服务器包裹中的位置
equipManage.picPath = {} --装备图片路径
equipManage.picPath1 = {}
equipManage.picPath2 = {}

equipManage.type = {}--物品类型
equipManage.itemCount = {}--物品数量
equipManage.itemOnlyID = {} --id 应为lua不支持int64 暂时使用char*代替
equipManage.tip = {} --装备的Tip
equipManage.bagType = {}
equipManage.itemAnimation = {}
-- equipManage.money = {} --装备价格
-- equipManage.attack = {}  --攻击力
-- equipManage.defense = {}  --防御力
-- equipManage.magicattack = {}  --法伤
-- equipManage.magicdefense = {}  --法术抗性
-- equipManage.normal = {}  --是否普通装备
-- equipManage.heroEquip = {}  --是否英雄装备
-- equipManage.skillequip = {}  --是否技能型装备
-- equipManage.repeatEquip = {}  --是否铸魂型装备
-- equipManage.GodEquip={}  --是否是神器
-- equipManage.HaveStoneEquip={}  --是否已经镶嵌宝石
--------------很重要的逻辑-----------------


pullPicType = {} --用于拖拽的区块  公有拖拽图片
pullPicType.pullPosX = 0 --拖拽的X坐标
pullPicType.pullPosY = 0--拖拽的y坐标
pullPicType.pic = nil --拖拽图片
pullPicType.id = 0 --拖拽图片索引信息ID 0 表示没有图片
pullPicType.type = 0 --图片类型是装备还是宝石 分别用 1和2 表示装备 和 宝石 0 代表没有装备 
pullPicType.ustID = 0


equipTypeNumber = {0,0,0,0,0} --1为礼包 --10为宝石 --3为装备 --else其他 --5为炼金消耗品



local itemChangeRanking = 0--用于更换背包是使用
local EventCase = 0
local itemUsingOnlyId = 0
--1.场外删除
--2.场外拖入
--3.场内删除
--4.战场药水拖入
--5.战场装备场内拖入
--6.场外使用
--7.场内使用

function SetitemChangeRanking(index)
    itemChangeRanking = index
end
function GetitemChangeRanking()
    return itemChangeRanking
end
function SetEventCase(index)
    EventCase = index
end
function GetEventCase()
    return EventCase
end
function SetitemUsingOnlyId(onlyid)
    itemUsingOnlyId = onlyid
end
function GetitemUsingOnlyId()
    return itemUsingOnlyId
end

function EquipOutCreateResource()
	g_game_equip_ui:CreateResource()
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
function EquipOutDeleteResource()
	g_game_equip_ui:DeleteResource()
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

function InitGame_EquipUI(wnd, bisopen)
	g_game_equip_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	InitMainGame_Equip(g_game_equip_ui)
	g_game_equip_ui:SetVisible(bisopen)
end

function InitMainGame_Equip(wnd)

	--底图背景
	wnd:AddImage(path_shop.."BK_shop.png",0,0,1280,800)
	--上边栏
	wnd:AddImage(path.."upBK_hall.png",0,0,1280,54)
	wnd:AddImage(path.."upLine2_hall.png",0,54,1280,35)
	for i=1,3 do
		wnd:AddImage(path.."linecut_hall.png",163+110*i,60,2,32)
	end
	btn_ListBK = wnd:AddImage(path_start.."ListBK_start.png",150,53,256,38)

	InitEquip_allUI(g_game_equip_ui, 0)					--装备总览
	InitEquip_strUI(g_game_equip_ui, 0)					--装备强化
	InitEquip_stoneInlayUI(g_game_equip_ui, 0)			--宝石镶嵌
	InitEquip_synthesizeUI(g_game_equip_ui, 0)			--物品合成
	
	--装备总览
	btn_equip_allEquip = wnd:AddCheckButton(path_equip.."indexA1_equip.png",path_equip.."indexA2_equip.png",path_equip.."indexA3_equip.png",165,53,110,33)
	XWindowEnableAlphaTouch(btn_equip_allEquip.id)
	btn_equip_allEquip.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(135,53)
		
		SetEquip_allIsVisible(1)
		SetEquip_strIsVisible(0)
		SetEquip_stoneInlayIsVisible(0)
		SetEquip_synthesizeIsVisible(0)
		
		btn_equip_strEquip:SetCheckButtonClicked(0)
		btn_equip_stoneInlay:SetCheckButtonClicked(0)
		btn_equip_synthesize:SetCheckButtonClicked(0)
		
	end
	--装备强化
	btn_equip_strEquip = wnd:AddCheckButton(path_equip.."indexB1_equip.png",path_equip.."indexB2_equip.png",path_equip.."indexB3_equip.png",275,53,110,33)
	XWindowEnableAlphaTouch(btn_equip_strEquip.id)
	btn_equip_strEquip.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(245,53)
		SetEquip_allIsVisible(0)
		SetEquip_strIsVisible(1)
		SetEquip_stoneInlayIsVisible(0)
		SetEquip_synthesizeIsVisible(0)
			
		btn_equip_allEquip:SetCheckButtonClicked(0)
		btn_equip_stoneInlay:SetCheckButtonClicked(0)
		btn_equip_synthesize:SetCheckButtonClicked(0)
	end
	--宝石镶嵌
	btn_equip_stoneInlay = wnd:AddCheckButton(path_equip.."indexC1_equip.png",path_equip.."indexC2_equip.png",path_equip.."indexC3_equip.png",385,53,110,33)
	XWindowEnableAlphaTouch(btn_equip_stoneInlay.id)
	btn_equip_stoneInlay.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(355,53)
		
		SetEquip_allIsVisible(0)
		SetEquip_strIsVisible(0)
		SetEquip_stoneInlayIsVisible(1)
		SetEquip_synthesizeIsVisible(0)
			
		btn_equip_allEquip:SetCheckButtonClicked(0)
		btn_equip_strEquip:SetCheckButtonClicked(0)
		btn_equip_synthesize:SetCheckButtonClicked(0)
		
	end
	--物品合成
	btn_equip_synthesize = wnd:AddCheckButton(path_equip.."indexD1_equip.png",path_equip.."indexD2_equip.png",path_equip.."indexD3_equip.png",495,53,110,33)
	XWindowEnableAlphaTouch(btn_equip_synthesize.id)
	btn_equip_synthesize.script[XE_LBDOWN] = function()
		XClickPlaySound(5)
		btn_ListBK:SetPosition(465,53)
	
		SetEquip_allIsVisible(0)
		SetEquip_strIsVisible(0)
		SetEquip_stoneInlayIsVisible(0)
		SetEquip_synthesizeIsVisible(1)
		
		btn_equip_allEquip:SetCheckButtonClicked(0)
		btn_equip_strEquip:SetCheckButtonClicked(0)
		btn_equip_stoneInlay:SetCheckButtonClicked(0)
		
		Reset_EquipSynthesizeBagPage()
	end
end


function EquipChangeBag(index)
	XGame_EquipChangeBag(index)
end
-----------------------非常重要的函数 用于仓库的转换---------------------

-- function EquipChangeBagById(index)
    -- if(equipManage.bagType[index] ==nil) then
	    -- return
	-- end	
	-- local bagid = equipManage.bagType[index]
	-- local onlyid = equipManage.itemOnlyID[index]
    -- XGame_EquipChangeBag(bagid,onlyid,itemChangeRanking)
-- end


--------------------------------------测试用-------------------------------

function EquipInfo_Receivetolua(strPic,strPic1,strPic2,strName,itemtype,index,itemCount,itempackindex,itemOnlyID,tip,ibagtype,itemAnimation)---在这里接收所有的数据
	local indexE = #equipManage.CitemIndex+1--武器库A
	equipManage.picPath[indexE] = "..\\"..strPic	--图片路径
	equipManage.picPath1[indexE] = "..\\"..strPic1	--图片路径
    equipManage.picPath2[indexE] = "..\\"..strPic2   --图片路径
		
	equipManage.name[indexE] = strName --item名字
	equipManage.id[indexE] = indexE --item在本类的id  当做vector indexE索引值
	equipManage.CitemIndex[indexE] = index --item交互的id
	equipManage.type[indexE] = itemtype --item类型
    equipManage.itemCount[indexE] = itemCount
	equipManage.CpackCindex[indexE] = itempackindex --物品在服务器包裹中的位置
	equipManage.itemOnlyID[indexE] = itemOnlyID --唯一id
	equipManage.tip[indexE] = tip--Tip
	equipManage.bagType[indexE] = ibagtype
	equipManage.itemAnimation[indexE] = itemAnimation
	if(itemtype == 1) then
	    equipTypeNumber[1] = equipTypeNumber[1]+1
	elseif(itemtype == 10) then
	    equipTypeNumber[2] = equipTypeNumber[2]+1
	elseif(itemtype == 3) then
	    equipTypeNumber[3] = equipTypeNumber[3]+1
	else
	    equipTypeNumber[4] = equipTypeNumber[4]+1
		if(itemtype == 5) then
		    equipTypeNumber[5] = equipTypeNumber[5]+1
		end
	end
end
function EquipInfo_EquipSetilevel(ilevel)
    local indexE = #equipManage.CitemIndex
	equipManage.itemlevel[indexE] = ilevel
end

function CaculatepageMax(count,PackageMax)
    if(count == 0) then
        return 1
	else	
        return math.ceil(count/PackageMax)
	end	
end

--------------------------------------测试用-------------------------------
----从装备库里找一个没有被用过的id存放数据---
function findEquipManageEmpty()
   local i = 1
   while(equipManage.id[i]~=nil and equipManage.id[i]~=0) do
       i=i+1
   end
   return i
end

function equipManage_cleanALl_ItemInfo()
    equipManage.name = {} --装备名称
    equipManage.id = {} --装备图片在库里的ID
    equipManage.CitemIndex = {} --物品自身的类型Id
    equipManage.CpackCindex = {} --物品在服务器包裹中的位置
    equipManage.picPath = {} --装备图片路径
    equipManage.picPath1 = {}
    equipManage.picPath2 = {}
    equipManage.type = {}--物品类型
    equipManage.itemCount = {}--物品数量
    equipManage.itemOnlyID = {} --id 应为lua不支持int64 暂时使用char*代替
	equipManage.tip = {}--Tip
	equipManage.bagType = {}
	equipManage.itemAnimation = {}
	for index =1,5 do
	    equipTypeNumber[index] = 0
	end 
end


function game_equip_cleanpullPicType()--清空拖拽图片
    pullPicType.pullPosX = 0
	pullPicType.pullPosY = 0
	pullPicType.pic:SetVisible(0)
	pullPicType.pic:SetTouchEnabled(0)
	pullPicType.pic.changeimage()
	pullPicType.id = 0
	pullPicType.type = 0
	pullPicType.ustID = 0
	pullPicType.pic:ToggleEvent(XE_ONUPDATE, 0)	-- 添加消息	
end
function game_equip_creatpullPic(wnd)--创建拖拽区块
    pullPicType.pic = wnd:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
	pullPicType.pic.changeimage()
	pullPicType.pic:SetVisible(0)--需要人为开启
	pullPicType.pic:SetTouchEnabled(0)--需要人为开启
	pullPicType.pic:ToggleBehaviour(XE_ONUPDATE, 1)	-- 添加消息
	--pullPicType.pic:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
	
	pullPicType.pic.script[XE_ONUPDATE] = function()--当鼠标移动时 --响应拖拽
		if(pullPicType.pic:IsVisible()) then
		    local PosX = XGetCursorPosX()-pullPicType.pullPosX
		    local PosY = XGetCursorPosY()-pullPicType.pullPosY
		    pullPicType.pic:SetPosition(PosX,PosY)
		end
	end
	
	pullPicType.pic.script[XE_LBUP] = function()--当鼠标左键抬起
	    if(pullPicType.pic:IsVisible()) then
		    Equip_allDragXLUP()
			Equip_allInsideDragXLUP()
			Fightbag_LargepullPicXELP() --场内装备拖拽-》拖入
			waterbag_LargepullPicXELP() --场内药水拖拽-》拖入
            Equip_BattleBag_XELP_inGame()--场内装备-》场内套装	
			Equip_BattleBag_XELP() --场外装备总览-》套装  			
			Equip_BagStorage_pullPicXLUP() --场外仓库拖拽			
		    Equip_BagEquip_pullPicXLUP()  --装备总览-》全部物品 
			Equip_BagEquip_PullPicDeleteXLUP() --背包-》删除物品
			Equip_BagExpand_pullPicXLUP() --扩展背包1-》全部物品 
			Equip_BagExpand_PullPicDeleteXLUP()  --扩展背包1》删除物品
			Equip_BagExpand2_pullPicXLUP() --扩展背包2-》全部物品 
			Equip_BagExpand2_PullPicDeleteXLUP() --扩展背包2-》删除物品			
			Equip_StrBagSoul_pullPicXLUP() --装备强化-》右边包裹
			Equip_StrStrength_pullPicXLUP() --装备强化-》强化界面
			Equip_StrRebuild_pullPicXLUP() --装备强化-》重铸界面
			Equip_StrSoul_pullPicXLUP()--装备强化-》铸魂界面
			Equip_StrMake_pullPicXLUP() --装备强化-》炼金界面
			Equip_StrCost_pullPicXLUP() --装备强化-》炼金界面消耗品
			Equip_GemSyn_bag_pullPicXLUP()  --宝石镶嵌-》宝石合成-》右边包裹
			Equip_GemSyn_Left_pullPicXLUP()  --宝石镶嵌-》宝石合成-》左边格子
			Equip_GemInlay_PA_pullPicXLUP()  --宝石镶嵌-》宝石镶嵌-》右边包裹A
			Equip_GemInlay_PB_pullPicXLUP()  --宝石镶嵌-》宝石镶嵌-》右边包裹B
			Equip_GemInlay_Left_PA_pullPicXLUP() --宝石镶嵌-》宝石镶嵌-》左边包裹A
			Equip_GemInlay_Left_PB_pullPicXLUP() --宝石镶嵌-》宝石镶嵌-》左边包裹B
			Equip_Make_PA_pullPicXLUP() --炼金-》右边背包
			Equip_Make_PB_pullPicXLUP() --炼金-》右边背包
			Equip_SynEquip_pullPicXLUP()  --物品合成-》右边格子
		    game_equip_cleanpullPicType() --拖拽清空
		end
	end	
end


function game_equip_pullPic(id,tempic) ---根据id设置
    local tempPosX,tempPosY = tempic:GetPosition()--GetPosition和XgetCursorPosX得到的都是绝对坐标
	pullPicType.pic:SetVisible(1) --让假图片显示
	pullPicType.pic:SetTouchEnabled(1) --让假图片响应
	pullPicType.pic:SetPosition(XGetCursorPosX()-25,XGetCursorPosY()-25) --设置初始
	pullPicType.pullPosX = 25 --设置焦点距离X
	pullPicType.pullPosY = 25--设置焦点距离Y
	pullPicType.id = id  --设置图片库Id
	pullPicType.type = equipManage.type[id] --设置图片的类型
	pullPicType.pic.changeimageMultiple(equipManage.picPath[id],equipManage.picPath1[id],equipManage.picPath2[id]) --更换图片\
	pullPicType.pic:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
	pullPicType.pic:TriggerBehaviour(XE_LBDOWN)--模拟点击
end	

function game_equip_pullPicbyUstID(picPath,picPath1,picPath2,ustid,tempic) ---直接设置
    local tempPosX,tempPosY = tempic:GetPosition()--GetPosition和XgetCursorPosX得到的都是绝对坐标
	pullPicType.pic:SetVisible(1) --让假图片显示
	pullPicType.pic:SetTouchEnabled(1) --让假图片响应
	pullPicType.pic:SetPosition(XGetCursorPosX()-25,XGetCursorPosY()-25) --设置初始
	pullPicType.pullPosX = 25 --设置焦点距离X
	pullPicType.pullPosY = 25 --设置焦点距离Y
	pullPicType.ustID = ustid  ----这里用类型id代替
	pullPicType.pic.changeimageMultiple(picPath,picPath1,picPath2) --更换图片\
	pullPicType.pic:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
	pullPicType.pic:TriggerBehaviour(XE_LBDOWN)--模拟点击
end	

function game_equip_pullPicbyUstIDandType(picPath,ustid,itype,tempic)
    local tempPosX,tempPosY = tempic:GetPosition()--GetPosition和XgetCursorPosX得到的都是绝对坐标
	pullPicType.pic:SetVisible(1) --让假图片显示
	pullPicType.pic:SetTouchEnabled(1) --让假图片响应
	pullPicType.pic:SetPosition(XGetCursorPosX()-25,XGetCursorPosY()-25) --设置初始
	pullPicType.pullPosX = 25 --设置焦点距离X
	pullPicType.pullPosY = 25 --设置焦点距离Y
	pullPicType.ustID = ustid  ----这里用类型id代替
	pullPicType.type = itype 
	pullPicType.pic.changeimage(picPath) --更换图片\
	pullPicType.pic:ToggleEvent(XE_ONUPDATE, 1)	-- 添加消息	
	pullPicType.pic:TriggerBehaviour(XE_LBDOWN)--模拟点击
end




function game_equip_getMadel()--返回奖牌数量
    local medal_1 = 0
	local medal_2 = 0
	local medal_3 = 0
    for i,value in pairs(equipManage.CitemIndex) do
	    if(equipManage.CitemIndex[i] == 40001) then
		    medal_1 = medal_1 + equipManage.itemCount[i]
		elseif(equipManage.CitemIndex[i] == 40002) then
		    medal_2 = medal_2 + equipManage.itemCount[i]
		elseif(equipManage.CitemIndex[i] == 40003) then
		    medal_3 = medal_3 + equipManage.itemCount[i]	
		end	
	end
	return medal_1,medal_2,medal_3
end

function game_equip_GetRankingidByonlyId(onlyid)
    for i,value in pairs(equipManage.CitemIndex) do
	    if(equipManage.itemOnlyID[i] == onlyid) then
		    return i
		end
	end
	return 0
end








function CheckEquipPullResultByRect(top,buttom,left,right)
    local PosX = XGetCursorPosX()
	local PosY = XGetCursorPosY()
	if(PosX>left and PosX<right and PosY>top and PosY<buttom) then
	    return true
    else 
	    return false
    end
end

function CheckEquipPullResultDestory(pic)
    local PosX = XGetCursorPosX()
	local PosY = XGetCursorPosY()
	local BlockX,BlockY = pic:GetPosition()
	if(PosX>BlockX and PosX<BlockX+120 and PosY>BlockY-15 and PosY<BlockY+50) then
	    return true
    else 
	    return false
    end
end

function CheckEquipPullResultSmallPic(pic)
    local PosX = XGetCursorPosX()
	local PosY = XGetCursorPosY()
	local BlockX,BlockY = pic:GetPosition()
	if(PosX>BlockX and PosX<BlockX+32 and PosY>BlockY and PosY<BlockY+32) then
	    return true
    else 
	    return false
    end
end

function CheckEquip_All_ResultByPic(RectCheck)
    local x,y,w,h = RectCheck:GetRect()
	local PosX = XGetCursorPosX()
	local PosY = XGetCursorPosY()

	if(PosX>x and PosX<w and PosY>y and PosY<h) then
	    return true
    else 
	    return false
    end
end


function CheckEquipPullResult(pic)
    local PosX = XGetCursorPosX()
	local PosY = XGetCursorPosY()
	local BlockX,BlockY = pic:GetPosition()
	if(PosX>BlockX and PosX<BlockX+52 and PosY>BlockY and PosY<BlockY+52) then
	    return true
    else 
	    return false
    end
end

------------设置显示
function SetGameEquipIsVisible(flag) 
	if g_game_equip_ui ~= nil then
		if flag == 1 and g_game_equip_ui:IsVisible() == false then	

			EquipOutCreateResource()
		
			g_game_equip_ui:SetVisible(1)
			SetFourpartUIVisiable(3)
			
			SetEquip_allIsVisible(1)
			SetEquip_strIsVisible(0)
			SetEquip_stoneInlayIsVisible(0)
			SetEquip_synthesizeIsVisible(0)
		
			btn_ListBK:SetPosition(135,53)
			btn_ListBK:SetVisible(1)
			
			btn_equip_allEquip:SetCheckButtonClicked(1)
			btn_equip_strEquip:SetCheckButtonClicked(0)
			btn_equip_stoneInlay:SetCheckButtonClicked(0)
			btn_equip_synthesize:SetCheckButtonClicked(0)
			Xgame_equip_checkClickUp()
			
		elseif flag == 0  and g_game_equip_ui:IsVisible() == true then
		
			EquipOutDeleteResource()
		
			g_game_equip_ui:SetVisible(0)
			SetEquip_allIsVisible(0)
			SetEquip_strIsVisible(0)
			SetEquip_stoneInlayIsVisible(0)
			SetEquip_synthesizeIsVisible(0)
			Xgame_equip_checkReturn()
		end
	end	
end

function GetGameEquipIsVisible()  
    if g_game_equip_ui~=nil and g_game_equip_ui:IsVisible()==true then
		return 1
    else
		return 0
    end
end