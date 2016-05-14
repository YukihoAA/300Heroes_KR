include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")


	
local GemSynIcon = {}
local GemSynItem = {}
GemSynItem.kuang = {}
local showStoneSortAllFont_B = {"综合排序"}
local threeButton_B = {}

local Gem_PageInfo = nil
local CurPage = 1
local AllPage = 1

local GemSortListFont ={"显示全部","宝石","神器","专属","装备","英雄和皮肤"}
local BTN_GemSort = {}          -----合成目标按钮
local Font_GemSort = nil  	    -----合成目标内容
local GemSort_BK = nil      	-----合成目标背景
local GemSort = nil 			-----合成目标的下拉选单


local packageBlock = {} --包裹框用于存放宝石
packageBlock.pic = {} --包裹框的图片
packageBlock.id= {} --包裹框在装备库利的索引Id 0 为没有装备
packageBlock.type = {} --包裹框中是装备还是宝石 分别用 1和2 表示装备 和 宝石 0 代表没有装备 
packageBlock.itemCount = {} --物品数量

local stoneItem = {}
stoneItem.pic = {} --包裹框的图片
stoneItem.onlyid= {} --包裹框在装备库利的索引Id 0 为没有装备
stoneItem.type = {} --包裹框中是装备还是宝石 分别用 1和2 表示装备 和 宝石 0 代表没有装备 

local SuccessPer = nil

local btn_left = nil
local btn_right = nil

function InitEquip_GemSynUI(wnd, bisopen)
	g_equip_gemsyn_ui = CreateWindow(wnd.id, 200, 200, 860, 470)
	
	SuccessPer = g_equip_gemsyn_ui:AddFont(" ",15, 0, 167, 119, 250, 15, 0xfefe00)
	
	local stone_posx = {180,30,330,100,180,260}
	local stone_posy = {34,99,99,169,169,169}
	for i=1,6 do
		GemSynIcon[i] = g_equip_gemsyn_ui:AddImage(path_equip.."bag_equip.png",stone_posx[i],stone_posy[i],50,50)
		stoneItem.pic[i] = GemSynIcon[i]:AddImage(path_equip.."bag_equip.png",0,0,50,50)
	    stoneItem.pic[i]:SetVisible(0)
		stoneItem.pic[i].script[XE_RBUP] = function()
		    if(stoneItem.onlyid[i] == nil or stoneItem.onlyid[i] == " ") then--id不存在 不响应
			    return
	        end
			XEquip_GemSyn_Icon_CLickUP(i,stoneItem.onlyid[i])
		    Equip_GemSyn_Left_cleanOne_ItemInfo(i)
	    end
		if(i == 1) then
			GemSynIcon[i]:AddImage(path_equip.."HeadShine_equip.png",-9,-9,68,68)
		else
		    GemSynIcon[i]:AddImage(path_shop.."iconside_shop.png",-2,-2,54,54)		
		end
	end
	
	-- local  AA = g_equip_gemsyn_ui:AddFont("分解宝石需要把分解的宝石拖到最上方的格子，可分解成\n第一级的多个宝石",12, 0, 35, 8, 450, 50, 0x7787c3)
	-- AA:SetFontSpace(1,1)
	
	local BB = g_equip_gemsyn_ui:AddFont("提示：\n◆三个和以上的同级宝石才可进行合成，合成成功得到高一级宝石.\n◆使用相同属性的宝石合成成功，必然得到相同属性的高一级宝石.\n◆两个4级以上的同等级不同属性的宝石，可以融合成同等级不同品质的\n  双色宝石.\n◆分解宝石需要把要分解的宝石拖到最上方的格子，可分解成低一级的\n  多个宝石.",11, 0, 20, 360, 470, 200, 0x8295cf)
	BB:SetFontSpace(1,1)
	
	----背包栏
	for index = 1,49 do
		local PosX = (index-1)%7*54+460
		local PosY = math.ceil(index/7)*54	
		GemSynItem[index] = g_equip_gemsyn_ui:AddImage(path_equip.."bag_equip.png",PosX,PosY,50,50)
		packageBlock.pic[index] = GemSynItem[index]:AddImage(path_equip.."bag_equip.png",0,0,50,50)
		GemSynItem.kuang[index] = GemSynItem[index]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.pic[index]:SetVisible(0)
		packageBlock.pic[index].script[XE_DRAG] = function()
		    if(packageBlock.id[index] == nil or packageBlock.id[index] == 0) then--id不存在 不响应
			    return
			end
			game_equip_pullPic(packageBlock.id[index],packageBlock.pic[index])
			GemSynItem.kuang[index].changeimage(path_equip.."kuang3_equip.png")
		end
		
		packageBlock.pic[index].script[XE_ONHOVER] = function()
			GemSynItem.kuang[index].changeimage(path_equip.."kuang2_equip.png")
		end
		packageBlock.pic[index].script[XE_ONUNHOVER] = function()
			GemSynItem.kuang[index].changeimage(path_equip.."kuang_equip.png")
		end
		
		packageBlock.pic[index].script[XE_RBUP] = function()
            Equip_GemSyn_RClickUp(index)			
		end
	end
	for index = 1,49 do
	    packageBlock.itemCount[index] = packageBlock.pic[index]:AddFont("0",12,6,-50,-33,100,17,0xFFFFFF)
	    packageBlock.itemCount[index]:SetVisible(1)
		packageBlock.itemCount[index]:SetFontBackground()
	end

	----创建三个button
	local Button_font = {"合成","融合","分解"}
	for i=1,3 do
		threeButton_B[i] = g_equip_gemsyn_ui:AddButton(path_setup.."buy1_setup.png",path_setup.."buy2_setup.png",path_setup.."buy3_setup.png",130*i-90,260,83,35)
		threeButton_B[i]:AddFont(Button_font[i],15,8,0,0,83,35,0xbcbcc4)
		-- threeButton_B[i]:SetEnabled(0)
	end
	
	threeButton_B[1].script[XE_LBUP] = function()
	    XEquip_GemSyn_OK_ClickUP()
	end
	
	threeButton_B[2].script[XE_LBUP] = function()
	    XEquip_GemSyn_IN_ClickUP()
	end
	
	threeButton_B[3].script[XE_LBUP] = function()
	    XEquip_GemSyn_Decompose_ClickUP()
	end
   Equip_GemSyn_SetUseButton_3(1)
	

	-------左右翻页键
	btn_left = g_equip_gemsyn_ui:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png",603,430,27,36)
	XWindowEnableAlphaTouch(btn_left.id)
	local pageBK = btn_left:AddImage(path_setup.."yemadiban_mail.png", 27, 9, 42, 18)
	Gem_PageInfo = pageBK:AddFont(CurPage.."/"..AllPage,15, 8, -3, 0, 32, 18, 0xffffffff)
	btn_right = g_equip_gemsyn_ui:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png",673,430,27,36)
	XWindowEnableAlphaTouch(btn_right.id)
	btn_left.script[XE_LBUP] = function()
		if (CurPage > 1) then
			CurPage = CurPage - 1
			Equip_GemSyn_needEquipInfo()
		end
	end
	btn_right.script[XE_LBUP] = function()
		if (CurPage < AllPage) then
			CurPage = CurPage + 1
			Equip_GemSyn_needEquipInfo()
		end
	end
	----宝石选择
	-- g_equip_gemsyn_ui:AddImage(path_equip.."GemChose_equip.png", 460, 25, 64, 16)    
	local btn_Gembuy = g_equip_gemsyn_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png",470,16,100,32)
	btn_Gembuy:AddFont("宝石购买",12, 8, 0, 0, 100, 32, 0xffffff)
	btn_Gembuy.script[XE_LBUP] = function()
		XClickPlaySound(5)
		g_equip_GemBuy_ui:SetVisible(1)
		XEquip_GemBuyClickVisible(1)
	end
	-- g_equip_gemsyn_ui:AddFont("宝石排序",15, 0, 680, 20, 250, 20, 0xbeb5ee)
	-- GemSort = g_equip_gemsyn_ui:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",757,15,128,32)

	-- Font_GemSort = GemSort:AddFont(GemSortListFont[1], 12, 0, 8, 6, 100, 15, 0xbeb5ee)
	-- GemSort_BK = g_equip_gemsyn_ui:AddImage(path_hero.."listBK2_hero.png", 757, 45, 128, 256)
	-- GemSort_BK:SetVisible(0)
	
	-- for dis = 1,6 do
		-- BTN_GemSort[dis] = g_equip_gemsyn_ui:AddImage(path_hero.."listhover_hero.png",757,16+dis*29,128,32)
		-- GemSort_BK:AddFont(GemSortListFont[dis],12,0,8,dis*29-23,128,32,0xbeb5ee)
		-- BTN_GemSort[dis]:SetTransparent(0)	
		-- BTN_GemSort[dis]:SetTouchEnabled(0)
		-- -----------鼠标滑过
		-- BTN_GemSort[dis].script[XE_ONHOVER] = function()
			-- if GemSort_BK:IsVisible() == true then
				-- BTN_GemSort[dis]:SetTransparent(1)
			-- end
		-- end
		-- BTN_GemSort[dis].script[XE_ONUNHOVER] = function()
			-- if GemSort_BK:IsVisible() == true then
				-- BTN_GemSort[dis]:SetTransparent(0)
			-- end
		-- end
		-- BTN_GemSort[dis].script[XE_LBUP] = function()
			-- Font_GemSort:SetFontText(GemSortListFont[dis],0xbeb5ee)
			
			-- --onSearchEnter()
			-- GemSort:SetButtonFrame(0)
			-- GemSort_BK:SetVisible(0)
			-- for index,value in pairs(BTN_GemSort) do
				-- BTN_GemSort[index]:SetTransparent(0)
				-- BTN_GemSort[index]:SetTouchEnabled(0)
			-- end
		-- end
		
	-- end
	-- GemSort.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- if GemSort_BK:IsVisible() then
			-- GemSort_BK:SetVisible(0)
			-- for index,value in pairs(BTN_GemSort) do
				-- BTN_GemSort[index]:SetTransparent(0)
				-- BTN_GemSort[index]:SetTouchEnabled(0)
			-- end
		-- else
			-- GemSort_BK:SetVisible(1)
			-- for index,value in pairs(BTN_GemSort) do
				-- BTN_GemSort[index]:SetTransparent(0)
				-- BTN_GemSort[index]:SetTouchEnabled(1)
			-- end
		-- end
	-- end	
	g_equip_gemsyn_ui:SetVisible(0)
end

function Equip_GemSyn_needEquipInfo()
    if(g_equip_gemsyn_ui:IsVisible() == false) then
        return
	end	
	Equip_GemSyn_cleanALl_ItemInfo()
    local i = 0
	local j = 0
	
	AllPage = CaculatepageMax(equipTypeNumber[2],49)
	Gem_PageInfo:SetFontText(CurPage.."/"..AllPage,0xbeb5ee)
	
	if(CurPage == 1) then
		btn_left:SetEnabled(0)		   
    else
		btn_left:SetEnabled(1)				   
	end
	if(CurPage == AllPage) then
		btn_right:SetEnabled(0)
    else
		btn_right:SetEnabled(1)		   
    end
	
	for index,value in pairs(equipManage.CitemIndex) do
	    if(equipManage.type[index] == 10) then
		    j = j+1	
	        if(i<49 and j>((CurPage-1)*49)) then
                i=i+1				
	            packageBlock.pic[i].changeimage(equipManage.picPath[index])
		        packageBlock.pic[i]:SetVisible(1)
			    packageBlock.pic[i]:SetImageTip(equipManage.tip[index])
                packageBlock.id[i] = equipManage.id[index]
                packageBlock.type[i] = equipManage.type[index]
				packageBlock.itemCount[i]:SetFontText(equipManage.itemCount[index])
				if(equipManage.itemCount[index]>1) then
			        packageBlock.itemCount[i]:SetVisible(1)
		        else 
			        packageBlock.itemCount[i]:SetVisible(0)
		        end
				if(equipManage.itemAnimation[index] ~= -1) then
			       packageBlock.pic[i]:EnableImageAnimate(1,equipManage.itemAnimation[index],15,5)
			    end	
		    end	
		end	
	end
end

function Equip_GemSyn_cleanPage()
    CurPage = 1
	AllPage = 1
end

function Equip_GemSyn_cleanALl_ItemInfo()
    for index =1,49 do
	    packageBlock.pic[index].changeimage("") --包裹框的图片
		packageBlock.pic[index]:SetVisible(0)
		packageBlock.itemCount[index]:SetFontText("0",0xFFFFFF)
		packageBlock.pic[index]:SetImageTip(0)
		if(packageBlock.pic[index]:GetBoolImageAnimate() == 1) then
		    packageBlock.pic[index]:CleanImageAnimate()
		end
	end
	packageBlock.id = {}
    packageBlock.type = {}
end





---用于拖拽---
function Equip_GemSyn_bag_pullPicXLUP()
    if(g_equip_gemsyn_ui:IsVisible() == false or pullPicType.type ~=10) then
	    return
	end
    local tempRanking = Equip_GemSyn_checkRect() --判断是否在包裹框
	local oldranking = Equip_GemSyn_getPullPicIndexInPackage(pullPicType.id) --得到老的位置
	if(oldranking<=49 and oldranking>=1) then
	    GemSynItem.kuang[oldranking].changeimage(path_equip.."kuang_equip.png")	
    end	
	if(tempRanking == 0) then
	    return
	end
	
	if(oldranking~=0 and packageBlock.id[tempRanking] ~= 0 and packageBlock.id[tempRanking]~= nil) then
		Equip_GemSyn_change(oldranking,packageBlock.id[tempRanking])--如果在背包内存在		
	elseif(oldranking~=0 and (packageBlock.id[tempRanking] == 0 or packageBlock.id[tempRanking]== nil)) then
		Equip_GemSyn_cleanOne_ItemInfo(oldranking)
	end
    Equip_GemSyn_change(tempRanking,pullPicType.id) 
end

function Equip_GemSyn_checkRect() --判断是否在包裹框
    for i = 1,49 do
	    if(CheckEquipPullResult(GemSynItem[i])) then
		    return i
		end
	end
	return 0
end
function Equip_GemSyn_getPullPicIndexInPackage(id) --得到老的位置
   for i = 1,49 do
	    if(packageBlock.id[i]== id) then
		    return i
		end
	end
	return 0
end

function Equip_GemSyn_SetSuccessPer(word)
    SuccessPer:SetFontText(word,0xfefe00)
end



function Equip_GemSyn_change(ranking,id)--位置 在数据库里的id
    if(equipManage.type[id] ~=10) then
	    return
	end	
    packageBlock.id[ranking] = id
	packageBlock.pic[ranking].changeimage(equipManage.picPath[id])--跟换图片
    packageBlock.type[ranking] = equipManage.type[id]
	packageBlock.pic[ranking]:SetVisible(1)
	packageBlock.pic[ranking]:SetImageTip(equipManage.tip[id])
	packageBlock.itemCount[ranking]:SetFontText(equipManage.itemCount[id]) 
	if(equipManage.itemCount[id]>1) then
		packageBlock.itemCount[ranking]:SetVisible(1)
	else 
		packageBlock.itemCount[ranking]:SetVisible(0)
	end
	if(equipManage.itemAnimation[id] ~= -1) then
		packageBlock.pic[ranking]:EnableImageAnimate(1,equipManage.itemAnimation[id],15,5)             
    else
	    if(packageBlock.pic[ranking]:GetBoolImageAnimate() == 1) then
		    packageBlock.pic[ranking]:CleanImageAnimate()
		end
	end
end

function Equip_GemSyn_cleanOne_ItemInfo(ranking)
    packageBlock.pic[ranking].changeimage() --包裹框的图
	packageBlock.pic[ranking]:SetVisible(0)
	packageBlock.pic[ranking]:SetImageTip(0)
	packageBlock.itemCount[ranking]:SetFontText("0",0xFFFFFF)
	packageBlock.id[ranking] = 0
    packageBlock.type[ranking] = 0
end


function Equip_GemSyn_Left_checkRect() --left_判断是否在包裹框
    for index = 1,6 do
	    if(CheckEquipPullResult(GemSynIcon[index])) then
		    return index
	    end
	end	

	return 0
end

function Equip_GemSyn_Left_clean()--left
    --清空强化装备图片等信息
	for i = 1,6 do
        stoneItem.pic[i].changeimage() 
	    stoneItem.pic[i]:SetVisible(0)
	    stoneItem.onlyid[i] = nil
        stoneItem.type[i] = 0
		stoneItem.pic[i]:SetImageTip(0)
	end	
	Equip_GemSyn_SetUseButton_1(0)
	Equip_GemSyn_SetUseButton_2(0)
	SuccessPer:SetFontText(" ",0xfefe00)
end

function Equip_GemSyn_Left_pullPicXLUP()
    if(g_equip_gemsyn_ui:IsVisible() == false or pullPicType.type ~=10) then
	    return
	end
    local tempRanking = Equip_GemSyn_Left_checkRect() --判断是否在包裹框--left
	if(tempRanking ~= 0) then
        XEquip_GemSyn_StoneDragOn(tempRanking,equipManage.itemOnlyID[pullPicType.id])--上传第几个格子和绝对id
        SetitemChangeRanking(tempRanking-1)		
	end
end


function Equip_GemSyn_RClickUp(index)
	for tempRanking = 2,6 do
		if(stoneItem.onlyid[tempRanking] == 0 or stoneItem.onlyid[tempRanking] == nil or stoneItem.onlyid[tempRanking] == "0" or stoneItem.onlyid[tempRanking] == nil) then
		    XEquip_GemSyn_StoneDragOn(tempRanking,equipManage.itemOnlyID[packageBlock.id[index]])
			return
		end
    end		
end	

-- function Equip_GemSyn_Storage()
    -- if(g_equip_gemsyn_ui:IsVisible() == false) then
	    -- return
	-- end
	-- local itemChangeRank = GetitemChangeRanking()
	-- XEquip_GemSyn_StoneDragOn(itemChangeRank+1,equipManage.itemOnlyID[1])--传给lua信息
-- end


function Equip_GemSyn_Left_cleanOne_ItemInfo(ranking)--left
    stoneItem.pic[ranking].changeimage() --包裹框的图片
	stoneItem.pic[ranking]:SetVisible(0)
	stoneItem.onlyid[ranking] = nil
    stoneItem.type[ranking] = 0
	stoneItem.pic[ranking]:SetImageTip(0)
end



 function Equip_GemSyn_Left_changeByonlyId(strPic,onlyidid,ranking,tip,itemAnimation)--在数据库里的id--left
 
    stoneItem.onlyid[ranking] = onlyidid
	stoneItem.pic[ranking].changeimage("..\\"..strPic)--跟换图片
    stoneItem.type[ranking] = 10
	stoneItem.pic[ranking]:SetVisible(1)
	stoneItem.pic[ranking]:SetImageTip(tip)
	if(stoneItem.pic[ranking]:GetBoolImageAnimate() == 1 and itemAnimation == -1) then
	    stoneItem.pic[ranking]:CleanImageAnimate()
	elseif(itemAnimation ~= -1) then
	    stoneItem.pic[ranking]:EnableImageAnimate(1,itemAnimation,15,5)
    end  
end

function Equip_GemSyn_SetUseButton_1(ibool)
    if(ibool~=0) then
	    threeButton_B[1]:SetEnabled(1)
	else 
	    threeButton_B[1]:SetEnabled(0)
	end
end
function Equip_GemSyn_SetUseButton_2(ibool)
    if(ibool~=0) then
	    threeButton_B[2]:SetEnabled(1)
	else 
	    threeButton_B[2]:SetEnabled(0)
	end
end
function Equip_GemSyn_SetUseButton_3(ibool)
    if(ibool~=0) then
	    threeButton_B[3]:SetEnabled(1)
	else 
	    threeButton_B[3]:SetEnabled(0)
	end
end











function SetEquip_GemSynIsVisible(flag) 
	if g_equip_gemsyn_ui ~= nil then
		if flag == 1 and g_equip_gemsyn_ui:IsVisible() == false then
			g_equip_gemsyn_ui:SetVisible(1)
			Equip_GemSyn_needEquipInfo()
			XEquip_GemSyn_ClickUp()
		elseif flag == 0 and g_equip_gemsyn_ui:IsVisible() == true then
			g_equip_gemsyn_ui:SetVisible(0)
			Equip_GemSyn_cleanALl_ItemInfo()
			Equip_GemSyn_Left_clean()
			Equip_GemSyn_cleanPage()
			g_equip_GemBuy_ui:SetVisible(0) --宝石购买界面如果开启将他关掉
		end
	end
end