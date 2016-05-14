include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


local BagItem = {}     						---------背包道具
BagItem.kuang = {}
local BagCurPage = 1
local BagAllPage = 1
local Bag_PageInfo = nil



local expLength = 0.5
local CurExp = 11111
local MaxExp = 99999
local StrExp,Exp_font = nil
local MakeIcon = nil
local MakePic = nil

local EquipType,EquipSort = nil
local EquipType_BK,EquipSort_BK = nil
local Font_EquipType,Font_EquipSort = nil
local BTN_EquipType = {}
local BTN_EquipSort = {}
local EquipType_list = {"显示全部","普通装备","英雄专属","技能型装备","铸魂型装备","神器型装备"}
local EquipSort_list = {"综合排序","物理攻击","法术强度","攻击速度","冷却缩减","移动速度"}

--该单元只能放装备
local packageBlock = {} --包裹框用于存放装备
packageBlock.pic = {} --包裹框的图片
packageBlock.id= {} --包裹框在装备库利的索引Id 0 为没有装备
packageBlock.type = {} --包裹框中是装备还是宝石 分别用 1和2 表示装备 和 宝石 0 代表没有装备 

local ProduceTitle = nil

local btn_bagLeft = nil
local btn_bagRight = nil


function InitEquip_StrBagSoulUI(wnd, bisopen)
	g_str_BagSoul_ui = CreateWindow(wnd.id, 640, 200, 420, 470)
	
	-- g_str_BagSoul_ui:AddFont("装备类型",12, 0, 20, 25, 250, 20, 0xbeb5ee)
	-- g_str_BagSoul_ui:AddFont("属性排序",12, 0, 224, 25, 250, 20, 0xbeb5ee)
	ProduceTitle = g_str_BagSoul_ui:AddFont("铸造大师 Lv0",15, 0, 186, 390, 250, 20, 0x7787c3)
	
	for i=1,35 do
		local posx = 54*((i-1)%7+1)-34
		local posy = math.ceil(i/7)*54
	
		BagItem[i] = g_str_BagSoul_ui:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		packageBlock.pic[i] = BagItem[i]:AddImage(path_equip.."bag_equip.png",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)
		BagItem.kuang[i] = BagItem[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.pic[i].script[XE_DRAG] = function()
		    if(packageBlock.id[i] == nil or packageBlock.id[i] == 0) then--id不存在 不响应
			    return
			end
			game_equip_pullPic(packageBlock.id[i],packageBlock.pic[i])
			BagItem.kuang[i].changeimage(path_equip.."kuang3_equip.png")
		end
		packageBlock.pic[i].script[XE_ONHOVER] = function()
			BagItem.kuang[i].changeimage(path_equip.."kuang2_equip.png")
		end
		packageBlock.pic[i].script[XE_ONUNHOVER] = function()
			BagItem.kuang[i].changeimage(path_equip.."kuang_equip.png")
		end
		
		packageBlock.pic[i].script[XE_RBUP] = function()
			Equip_StrRebuild_RClickUp(packageBlock.id[i])
			Equip_StrSoul_RClickUp(packageBlock.id[i])
			Equip_StrStrength_RClickUp(packageBlock.id[i])
		end
	end
	
	btn_bagLeft = g_str_BagSoul_ui:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png",165,325,27,36)
	local pageBK = btn_bagLeft:AddImage(path_setup.."yemadiban_mail.png", 27, 9, 42, 18)	
	Bag_PageInfo = pageBK:AddFont(BagCurPage.."/"..BagAllPage,15, 8, -3, 0, 32, 18, 0xffffffff)
	
	btn_bagRight = g_str_BagSoul_ui:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png",235,325,27,36)
	XWindowEnableAlphaTouch(btn_bagLeft.id)
	XWindowEnableAlphaTouch(btn_bagRight.id)	
	local AA = g_str_BagSoul_ui:AddFont("更多战场装备到商城购买",11, 0, 260, 335, 250, 30, 0x8295cf)
	AA:SetFontSpace(1,1)
	
	btn_bagLeft.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if (BagCurPage > 1) then
			BagCurPage = BagCurPage - 1
			Equip_StrBagSoul_needEquipInfo()
		end
	end
	
	btn_bagRight.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if (BagCurPage < BagAllPage) then
			BagCurPage = BagCurPage + 1
			Equip_StrBagSoul_needEquipInfo()
		end
	end
	
	MakePic = g_str_BagSoul_ui:AddImage(path_equip.."0.png",20,382,50,50)
	MakeIcon = MakePic:AddImage(path_shop.."iconside_shop.png",0,0,54,54)	
	
	local StrExpBack = g_str_BagSoul_ui:AddImage(path_equip.."StrExpBK_equip.png",90,416,308,16)	

	-------铸造大师等级经验
	StrExp = StrExpBack:AddImage(path_equip.."StrExp_equip.png",0,0,308,16)
	StrExp:SetAddImageRect(StrExp.id, 0, 0, 308*(0/500), 16, 0 ,0, 308*(0/500), 16)
	Exp_font = StrExpBack:AddFontEx("0/500",15,8,0,0,308,16,0x7787c3)
	
	
	------两个下拉框
	-- EquipType = g_str_BagSoul_ui:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",85,20,128,32)
	-- Font_EquipType = EquipType:AddFont(EquipType_list[1], 12, 0, 8, 6, 100, 15, 0xbeb5ee)

	-- EquipType_BK = g_str_BagSoul_ui:AddImage(path_hero.."listBK2_hero.png", 85, 50, 128, 256)
	-- g_str_BagSoul_ui:SetAddImageRect(EquipType_BK.id,0,0,128,204,85,50,128,204)
	-- EquipType_BK:SetVisible(0)
	
	-- for dis = 1,6 do
		-- BTN_EquipType[dis] = g_str_BagSoul_ui:AddImage(path_hero.."listhover_hero.png",85,21+dis*29,128,32)
		-- EquipType_BK:AddFont(EquipType_list[dis],12,0,8,dis*29-23,128,32,0xbeb5ee)
		-- BTN_EquipType[dis]:SetTransparent(0)	
		-- BTN_EquipType[dis]:SetTouchEnabled(0)
		-- -----------鼠标滑过
		-- BTN_EquipType[dis].script[XE_ONHOVER] = function()
			-- if EquipType_BK:IsVisible() == true then
				-- BTN_EquipType[dis]:SetTransparent(1)
			-- end
		-- end
		-- BTN_EquipType[dis].script[XE_ONUNHOVER] = function()
			-- if EquipType_BK:IsVisible() == true then
				-- BTN_EquipType[dis]:SetTransparent(0)
			-- end
		-- end
		-- BTN_EquipType[dis].script[XE_LBUP] = function()
			-- Font_EquipType:SetFontText(EquipType_list[dis],0xbeb5ee)
			
			-- --onSearchEnter()
			-- EquipType:SetButtonFrame(0)
			-- EquipType_BK:SetVisible(0)
			-- for index,value in pairs(BTN_EquipType) do
				-- BTN_EquipType[index]:SetTransparent(0)
				-- BTN_EquipType[index]:SetTouchEnabled(0)
			-- end
		-- end
		
	-- end
	
	-- EquipType.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- if EquipType_BK:IsVisible() then
			-- EquipType_BK:SetVisible(0)
			-- for index,value in pairs(BTN_EquipType) do
				-- BTN_EquipType[index]:SetTransparent(0)
				-- BTN_EquipType[index]:SetTouchEnabled(0)
			-- end
		-- else
			-- EquipType_BK:SetVisible(1)
			-- for index,value in pairs(BTN_EquipType) do
				-- BTN_EquipType[index]:SetTransparent(0)
				-- BTN_EquipType[index]:SetTouchEnabled(1)
			-- end
		-- end
	-- end	

---------属性排序
	-- EquipSort = g_str_BagSoul_ui:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",288,20,128,32)
	-- Font_EquipSort = EquipSort:AddFont("综合排序", 12, 0, 18, 6, 100, 15, 0xbeb5ee)

	-- EquipSort_BK = g_str_BagSoul_ui:AddImage(path_hero.."listBK2_hero.png", 288, 50, 128, 256)
	-- g_str_BagSoul_ui:SetAddImageRect(EquipSort_BK.id,0,0,128,210,288,50,128,210)
	-- EquipSort_BK:SetVisible(0)
	
	-- for dis = 1,6 do
		-- BTN_EquipSort[dis] = g_str_BagSoul_ui:AddImage(path_hero.."listhover_hero.png",288,21+dis*29,128,32)
		-- EquipSort_BK:AddFont(EquipSort_list[dis],12,0,18,dis*29-23,128,32,0xbeb5ee)
		-- BTN_EquipSort[dis]:SetTransparent(0)	
		-- BTN_EquipSort[dis]:SetTouchEnabled(0)
		-- -----------鼠标滑过
		-- BTN_EquipSort[dis].script[XE_ONHOVER] = function()
			-- if EquipSort_BK:IsVisible() == true then
				-- BTN_EquipSort[dis]:SetTransparent(1)
			-- end
		-- end
		-- BTN_EquipSort[dis].script[XE_ONUNHOVER] = function()
			-- if EquipSort_BK:IsVisible() == true then
				-- BTN_EquipSort[dis]:SetTransparent(0)
			-- end
		-- end
		-- BTN_EquipSort[dis].script[XE_LBUP] = function()
			-- Font_EquipSort:SetFontText(EquipSort_list[dis],0xbeb5ee)
			
			-- --onSearchEnter()
			-- EquipSort:SetButtonFrame(0)
			-- EquipSort_BK:SetVisible(0)
			-- for index,value in pairs(BTN_EquipSort) do
				-- BTN_EquipSort[index]:SetTransparent(0)
				-- BTN_EquipSort[index]:SetTouchEnabled(0)
			-- end
		-- end
		
	-- end
	
	-- EquipSort.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- if EquipSort_BK:IsVisible() then
			-- EquipSort_BK:SetVisible(0)
			-- for index,value in pairs(BTN_EquipSort) do
				-- BTN_EquipSort[index]:SetTransparent(0)
				-- BTN_EquipSort[index]:SetTouchEnabled(0)
			-- end
		-- else
			-- EquipSort_BK:SetVisible(1)
			-- for index,value in pairs(BTN_EquipSort) do
				-- BTN_EquipSort[index]:SetTransparent(0)
				-- BTN_EquipSort[index]:SetTouchEnabled(1)
			-- end
		-- end
	-- end
	
	g_str_BagSoul_ui:SetVisible(bisopen)
end

function Equip_StrProduceSkillData(uLevel,uExp)
    	-------铸造大师等级经验
	CurExp = uExp
	if(uLevel == 0) then
	    MaxExp = 500
	elseif(uLevel == 1) then
	    MaxExp = 750
	elseif(uLevel == 2) then
        MaxExp = 1000
	elseif(uLevel == 3) then
        MaxExp = 1400
	elseif(uLevel == 4) then
        MaxExp = 2300
	elseif(uLevel == 5) then	
	    StrExp:SetAddImageRect(StrExp.id, 0, 0, 308, 16, 0 ,0, 308, 16)
		Exp_font:SetVisible(0)
		ProduceTitle:SetFontText("铸造大师 Lv"..uLevel, 0x7787c3)
	    MakePic.changeimage(path_equip..uLevel..".png")
		return
	end
	StrExp:SetAddImageRect(StrExp.id, 0, 0, 308*(CurExp/MaxExp), 16, 0 ,0, 308*(CurExp/MaxExp), 16)
	Exp_font:SetFontText(CurExp.."/"..MaxExp,0x7787c3)
	Exp_font:SetVisible(1)
	ProduceTitle:SetFontText("铸造大师 Lv"..uLevel, 0x7787c3)
	MakePic.changeimage(path_equip..uLevel..".png")
end


function IsFocusOn_EquipStrBagSoul()

	local flagA = (EquipType_BK:IsVisible() == true and EquipType:IsFocus() == false and BTN_EquipType[1]:IsFocus() == false and BTN_EquipType[2]:IsFocus() == false
		and BTN_EquipType[3]:IsFocus() == false and BTN_EquipType[4]:IsFocus() == false and BTN_EquipType[5]:IsFocus() == false and BTN_EquipType[6]:IsFocus() == false)

	if(flagA == true) then
		EquipType:SetButtonFrame(0)
		EquipType_BK:SetVisible(0)
		for index,value in pairs(BTN_EquipType) do
			BTN_EquipType[index]:SetTransparent(0)
			BTN_EquipType[index]:SetTouchEnabled(0)
		end
	end
	
	local flagB = (EquipSort_BK:IsVisible() == true and EquipSort:IsFocus() == false and BTN_EquipSort[1]:IsFocus() == false and BTN_EquipSort[2]:IsFocus() == false
		and BTN_EquipSort[3]:IsFocus() == false and BTN_EquipSort[4]:IsFocus() == false and BTN_EquipSort[5]:IsFocus() == false and BTN_EquipSort[6]:IsFocus() == false)

	if(flagB == true) then
		EquipSort:SetButtonFrame(0)
		EquipSort_BK:SetVisible(0)
		for index,value in pairs(BTN_EquipSort) do
			BTN_EquipSort[index]:SetTransparent(0)
			BTN_EquipSort[index]:SetTouchEnabled(0)
		end
	end
	
end

function SetEquip_StrBagSoulIsVisible(flag) 
	if g_str_BagSoul_ui ~= nil then
		if flag == 1 and g_str_BagSoul_ui:IsVisible() == false then
			g_str_BagSoul_ui:SetVisible(1)	
			Equip_StrBagSoul_needEquipInfo()
		elseif flag == 0 and g_str_BagSoul_ui:IsVisible() == true then
			g_str_BagSoul_ui:SetVisible(0)
			Equip_StrBagSoul_cleanALl_ItemInfo()
			Equip_StrBagSoul_cleanPackage()
		end
	end
end



function Equip_StrBagSoul_cleanPackage()
    BagCurPage = 1
	BagAllPage = 1
end


function Equip_StrBagSoul_needEquipInfo()	--装备
    if(g_str_BagSoul_ui:IsVisible() == false) then
        return
	end	
    Equip_StrBagSoul_cleanALl_ItemInfo()
    local i = 0
	local j = 0
	
	BagAllPage = CaculatepageMax(equipTypeNumber[3],35)
	Bag_PageInfo:SetFontText(BagCurPage.."/"..BagAllPage, 0xffbcbcc4)

	if(BagCurPage == 1) then
		btn_bagLeft:SetEnabled(0)		   
    else
		btn_bagLeft:SetEnabled(1)				   
	end
	if(BagCurPage == BagAllPage) then    
		btn_bagRight:SetEnabled(0)
    else
		btn_bagRight:SetEnabled(1)		   
    end
	
	for index,value in pairs(equipManage.CitemIndex) do
	    if(equipManage.type[index] == 3) then
		    j = j+1	
			if(i<35 and j>((BagCurPage-1)*35)) then	
                i=i+1			
	            packageBlock.pic[i].changeimage(equipManage.picPath[index])
		        packageBlock.pic[i]:SetVisible(1)
		    	packageBlock.pic[i]:SetImageTip(equipManage.tip[index])
                packageBlock.id[i] = equipManage.id[index]
                packageBlock.type[i] = equipManage.type[index]
				if(equipManage.itemAnimation[index] ~= -1) then
			       packageBlock.pic[i]:EnableImageAnimate(1,equipManage.itemAnimation[index],15,5)             
                end				
		    end	
		end	
	end
	
	Equip_StrRebuild_Checktip()--重铸tip重载
	Equip_StrStrength_Checktip()--强化重载
	Equip_StrSoul_Checktip() --铸魂重载
	
end

function Equip_StrBagSoul_cleanALl_ItemInfo() --装备
    for index =1,35 do
	    packageBlock.pic[index].changeimage() --包裹框的图片
		packageBlock.pic[index]:SetImageTip(0)
		if(packageBlock.pic[index]:GetBoolImageAnimate() == 1) then
		    packageBlock.pic[index]:CleanImageAnimate()
		end
	end
	packageBlock.id = {}
    packageBlock.type = {}
end



function Equip_StrBagSoul_pullPicXLUP()
    if(g_str_BagSoul_ui:IsVisible() == false) then
	    return
	end
    local tempRanking = Equip_StrBagSoul_checkRect() --判断是否在包裹框
	local oldranking = Equip_StrBagSoul_getIndexInPackage(pullPicType.id) --得到老的位置
	if(oldranking<=49 and oldranking>=1) then
	    BagItem.kuang[oldranking].changeimage(path_equip.."kuang_equip.png")	
    end	
	if(tempRanking == 0) then
	    return
	end
	
	if(oldranking~=0 and packageBlock.id[tempRanking] ~= 0 and packageBlock.id[tempRanking]~= nil) then
		Equip_StrBagSoul_change(oldranking,packageBlock.id[tempRanking])--如果在背包内存在		
	elseif(oldranking~=0 and (packageBlock.id[tempRanking] == 0 or packageBlock.id[tempRanking]== nil)) then
		Equip_StrBagSoul_cleanOne_ItemInfo(oldranking)
	end
    Equip_StrBagSoul_change(tempRanking,pullPicType.id) 
end





function Equip_StrBagSoul_checkRect() --判断是否在包裹框
    for i = 1,35 do
	    if(CheckEquipPullResult(BagItem[i])) then
		    return i
		end
	end
	return 0
end
function Equip_StrBagSoul_getIndexInPackage(id) --得到老的位置
   for i = 1,35 do
	    if(packageBlock.id[i]== id) then
		    return i
		end
	end
	return 0
end

function Equip_StrBagSoul_change(ranking,id)--位置 在数据库里的id
    packageBlock.id[ranking] = id
	packageBlock.pic[ranking].changeimage(equipManage.picPath[id])--跟换图片
    packageBlock.type[ranking] = equipManage.type[id]
	packageBlock.pic[ranking]:SetVisible(1)
	packageBlock.pic[ranking]:SetImageTip(equipManage.tip[id])
	if(equipManage.itemAnimation[id] ~= -1) then
		packageBlock.pic[ranking]:EnableImageAnimate(1,equipManage.itemAnimation[id],15,5)             
    else
	    if(packageBlock.pic[ranking]:GetBoolImageAnimate() == 1) then
		    packageBlock.pic[ranking]:CleanImageAnimate()
		end
	end
end
function Equip_StrBagSoul_cleanOne_ItemInfo(ranking)
    packageBlock.pic[ranking].changeimage() --包裹框的图片
	packageBlock.pic[ranking]:SetVisible(0)
	packageBlock.id[ranking] = 0
    packageBlock.type[ranking] = 0
	packageBlock.pic[ranking]:SetImageTip(0)
end
















