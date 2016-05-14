include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-------装备总览
local font_list = {"全部","装备","宝石","道具"}
local check_list = {}
local check_yes = {}

local bag_wnd = {}
bag_wnd.kuang = {}
local bag_medicine = {}

local left,right =nil
local PageNumber = 1
local PageNumberMax = 1
local PageNumberFont = nil


local sort_btn,repair_btn = nil

local keyPressA,keyPressB,keyPressC = nil

--包裹框
local packageBlock = {} --包裹框用于存放装备
packageBlock.pic = {} --包裹框的图片
packageBlock.id= {} --包裹框在装备库利的索引Id 0 为没有装备
packageBlock.type = {} --包裹框中是装备还是宝石 分别用 1和2 表示装备 和 宝石 0 代表没有装备 
packageBlock.itemCount = {} --物品数量 

local destory = nil

local waterPackage = {}
waterPackage.pic = {} --包裹框的图片
waterPackage.onlyid = {} --药水的唯一id
waterPackage.itemCount = {} --物品数量 



-------装备全部物品界面
function InitBag_EquipInUI(wnd, bisopen)
	------------全部物品
	g_bag_equipIn_ui = CreateWindow(wnd.id, 600,200,410,500)
	
	
	for i=1,4 do
		g_bag_equipIn_ui:AddFont(font_list[i],12, 0, 15+71*i, 6, 100, 20, 0x8295cf)
		check_list[i] = g_bag_equipIn_ui:AddImage(path_equip.."DrawBK_equip.png",71*i-6,6,32,32)
		check_list[i]:SetTouchEnabled(1)
		check_yes[i] = check_list[i]:AddImage(path_equip.."Draw_equip.png",4,-2,32,32)
		check_yes[i]:SetTouchEnabled(0)
		check_yes[i]:SetVisible(0)
		check_list[i].script[XE_LBUP] = function()
			if (check_yes[i]:IsVisible() == false) then
				Equip_BagEquipIn_clean_allyes()
				check_yes[i]:SetVisible(1)
				Equip_BagEquipIn_cleanALl_ItemInfo()
				Equip_BagEquipIn_needEquipInfo()
			end
		end
	end
	check_yes[1]:SetVisible(1)
	-----背包栏	
	for i=1,35 do
		local posx = 54*((i-1)%7+1)+10
		local posy = math.ceil(i/7)*54-19
		
		bag_wnd[i] = g_bag_equipIn_ui:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		packageBlock.pic[i] = bag_wnd[i]:AddImage(path_equip.."bag_equip.png",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)	
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.itemCount[i] = packageBlock.pic[i]:AddFont("0",12,6,-50,-33,100,17,0xFFFFFF)
	    packageBlock.itemCount[i]:SetVisible(0)
		packageBlock.itemCount[i]:SetFontBackground()
		packageBlock.pic[i].script[XE_LBUP] = function()
		    if(packageBlock.id[i] == nil or packageBlock.id[i] == 0) then--id不存在 不响应
			    return
			end
			game_equip_pullPic(packageBlock.id[i],packageBlock.pic[i])
			bag_wnd.kuang[i].changeimage(path_equip.."kuang3_equip.png")
		end
		
		packageBlock.pic[i].script[XE_ONHOVER] = function()
			bag_wnd.kuang[i].changeimage(path_equip.."kuang2_equip.png")
		end
		packageBlock.pic[i].script[XE_ONUNHOVER] = function()
			bag_wnd.kuang[i].changeimage(path_equip.."kuang_equip.png")
		end
		
		packageBlock.pic[i].script[XE_RBUP] = function()
		    if(packageBlock.id[i] == nil or packageBlock.id[i] == 0) then--id不存在 不响应
			    return
			end
			XBagEquipOnIconRButtonUp(equipManage.itemOnlyID[packageBlock.id[i]])	
		end
	end	
	
	
	destory = g_bag_equipIn_ui:AddImage(path_equip.."destory_equip.png",65,334,32,32)
	XWindowEnableAlphaTouch(destory.id)
	g_bag_equipIn_ui:AddFont("物品销毁",11, 0, 85, 338, 100, 20, 0x8295cf)
    -- g_bag_equipIn_ui:AddFont("空间",12, 0, 365, 417, 100, 20, 0x8295cf)
	-- g_bag_equipIn_ui:AddFont("48/49",12, 0, 392, 417, 100, 20, 0x8295cf)
	
	left = g_bag_equipIn_ui:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png", 203, 304, 27, 36)
	XWindowEnableAlphaTouch(left.id)
	right = g_bag_equipIn_ui:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png", 273, 304, 27, 36)
	XWindowEnableAlphaTouch(right.id)		
	sort_btn = g_bag_equipIn_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png", 245, 339, 100, 32)
	sort_btn:AddFont("物品整理",12, 8, 0, 0, 100, 32, 0xffffff)
	repair_btn = g_bag_equipIn_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png", 345, 339, 100, 32)
	repair_btn:AddFont("物品修理",12, 8, 0, 0, 100, 32, 0xffffff)
	
	sort_btn.script[XE_LBUP] = function()
	    XEquip_BagEquipSortAll()
	end
	repair_btn.script[XE_LBUP] = function()
	    XEquip_BagEquipRpaireAll()
	end
	
	------药水快捷栏
	g_bag_equipIn_ui:AddImage(path_equip.."line_equip.png",100,370,512,2)
	g_bag_equipIn_ui:AddFont("药水快捷栏",15, 0, 60, 375, 100, 20, 0x8295cf)
	local Attention = g_bag_equipIn_ui:AddFont("提示：右键点击使用药剂，或拖入快捷栏",11, 0, 230, 377, 300, 20, 0x8295cf)
	Attention:SetFontSpace(1,1)
	for i=1,3 do
		local posx = 65*((i-1)%7+1)
		local posy = 400
		bag_medicine[i] = g_bag_equipIn_ui:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		waterPackage.pic[i] = bag_medicine[i]:AddImage(path_equip.."bag_equip.png",0,0,50,50)
		waterPackage.pic[i]:SetVisible(0)
		waterPackage.pic[i].script[XE_RBUP] = function()
		    XEquip_BagEquipIn_Waterclean(i)
		end
	end
	keyPressA = g_bag_equipIn_ui:AddFont("F2",15, 8, 0, -452, 180, 20, 0x8295cf)
	keyPressB = g_bag_equipIn_ui:AddFont("F3",15, 8, 0, -452, 310, 20, 0x8295cf)
	keyPressC = g_bag_equipIn_ui:AddFont("F4",15, 8, 0, -452, 440, 20, 0x8295cf)
	
	PageNumber = 1
    PageNumberMax = 1
	local pageBK = left:AddImage(path_setup.."yemadiban_mail.png", 27, 9, 42, 18)
    PageNumberFont = pageBK:AddFont(PageNumber.."/"..PageNumberMax,15, 8, 0, 0, 42, 18, 0xffffffff)
	
	left.script[XE_LBUP] = function()
		if(PageNumber > 1) then
		   PageNumber = PageNumber-1
		   PageNumberFont:SetFontText(PageNumber.."/"..PageNumberMax,0xbeb5ee)
		   Equip_BagEquipIn_needEquipInfo()
		end
	end

	right.script[XE_LBUP] = function()
		if(PageNumber < PageNumberMax) then
		   PageNumber = PageNumber+1
		   PageNumberFont:SetFontText(PageNumber.."/"..PageNumberMax,0xbeb5ee)
		   Equip_BagEquipIn_needEquipInfo()
		end
	end
	g_bag_equipIn_ui:SetVisible(bisopen)
end

function Equip_BagEquipIn_cleanpage()
    PageNumber =1
	PageNumberMax = 1
end


function Equip_BagEquipIn_clean_allyes()
    for i = 1,4 do
	    check_yes[i]:SetVisible(0)
	end
end

function Equip_BagEquipIn_needEquipInfo()	
    if(g_bag_equipIn_ui:IsVisible() == false) then
        return
	end	
	Equip_BagEquipIn_cleanALl_ItemInfo()

    if(check_yes[1]:IsVisible()) then
	    Equip_BagEquipIn_needEquipInfo_1()--全部
	elseif(check_yes[2]:IsVisible()) then
	    Equip_BagEquipIn_needEquipInfo_2()--装备
	elseif(check_yes[3]:IsVisible()) then
	    Equip_BagEquipIn_needEquipInfo_3()--宝石
	elseif(check_yes[4]:IsVisible()) then
	    Equip_BagEquipIn_needEquipInfo_4()--道具
	end
end

function Equip_BagEquipIn_needEquipInfo_1()--需要全部
	PageNumberMax = CaculatepageMax(#equipManage.CitemIndex,35)
	PageNumberFont:SetFontText(PageNumber.."/"..PageNumberMax,0xbeb5ee)
    local i = 0
	local j = 0
	
    for index,value in pairs(equipManage.CitemIndex) do
        j=j+1
		if(i<35 and j>((PageNumber-1)*35)) then	
            i=i+1
	        packageBlock.pic[i].changeimage(equipManage.picPath[index])
		    packageBlock.pic[i]:SetVisible(1)
		    packageBlock.pic[i]:SetImageTip(equipManage.tip[index])
            packageBlock.id[i] = equipManage.id[index]
            packageBlock.type[i] = equipManage.type[index]
		    packageBlock.itemCount[i]:SetFontText(equipManage.itemCount[index])
		    if(equipManage.itemCount[index]>1 and equipManage.type[index]~=3) then
			    packageBlock.itemCount[i]:SetVisible(1)
		    else 
			    packageBlock.itemCount[i]:SetVisible(0)
		    end
		end	
	end
end	
function Equip_BagEquipIn_needEquipInfo_2()--需要装备
	PageNumberMax = CaculatepageMax(equipTypeNumber[3],35)
	PageNumberFont:SetFontText(PageNumber.."/"..PageNumberMax,0xbeb5ee)
    local i = 0
	local j = 0
	
    for index,value in pairs(equipManage.CitemIndex) do
	    if(equipManage.type[index] == 3) then
            j=j+1
		    if(i<35 and j>((PageNumber-1)*35)) then	
                i=i+1
	            packageBlock.pic[i].changeimage(equipManage.picPath[index])
		        packageBlock.pic[i]:SetVisible(1)
		        packageBlock.pic[i]:SetImageTip(equipManage.tip[index])
                packageBlock.id[i] = equipManage.id[index]
                packageBlock.type[i] = equipManage.type[index]
		        packageBlock.itemCount[i]:SetFontText(equipManage.itemCount[index])
		        if(equipManage.itemCount[index]>1 and equipManage.type[index]~=3) then
			        packageBlock.itemCount[i]:SetVisible(1)
		        else 
			        packageBlock.itemCount[i]:SetVisible(0)
		        end
			end	
		end	
	end
end	
function Equip_BagEquipIn_needEquipInfo_3()--需要宝石
	PageNumberMax = CaculatepageMax(equipTypeNumber[2],35)
	PageNumberFont:SetFontText(PageNumber.."/"..PageNumberMax,0xbeb5ee)
    local i = 0
	local j = 0
	
    for index,value in pairs(equipManage.CitemIndex) do
	    if(equipManage.type[index] == 10) then
            j=j+1
		    if(i<35 and j>((PageNumber-1)*35)) then	
                i=i+1
	            packageBlock.pic[i].changeimage(equipManage.picPath[index])
		        packageBlock.pic[i]:SetVisible(1)
		        packageBlock.pic[i]:SetImageTip(equipManage.tip[index])
                packageBlock.id[i] = equipManage.id[index]
                packageBlock.type[i] = equipManage.type[index]
		        packageBlock.itemCount[i]:SetFontText(equipManage.itemCount[index])
		        if(equipManage.itemCount[index]>1 and equipManage.type[index]~=3) then
			        packageBlock.itemCount[i]:SetVisible(1)
		        else 
			        packageBlock.itemCount[i]:SetVisible(0)
		        end
			end	
		end	
	end
end	
function Equip_BagEquipIn_needEquipInfo_4()--需要药水
 	PageNumberMax = CaculatepageMax(equipTypeNumber[4],35)
	PageNumberFont:SetFontText(PageNumber.."/"..PageNumberMax,0xbeb5ee)
    local i = 0
	local j = 0
	
    for index,value in pairs(equipManage.CitemIndex) do
	    if(equipManage.type[index] ~= 10 or equipManage.type[index]~=3) then
            j=j+1
		    if(i<35 and j>((PageNumber-1)*35)) then	
                i=i+1
	            packageBlock.pic[i].changeimage(equipManage.picPath[index])
		        packageBlock.pic[i]:SetVisible(1)
		        packageBlock.pic[i]:SetImageTip(equipManage.tip[index])
                packageBlock.id[i] = equipManage.id[index]
                packageBlock.type[i] = equipManage.type[index]
		        packageBlock.itemCount[i]:SetFontText(equipManage.itemCount[index])
		        if(equipManage.itemCount[index]>1 and equipManage.type[index]~=3) then
			        packageBlock.itemCount[i]:SetVisible(1)
		        else 
			        packageBlock.itemCount[i]:SetVisible(0)
		        end
			end	
		end	
	end
end	




function Equip_BagEquipIn_cleanALl_ItemInfo()
    for index =1,35 do
		if packageBlock.pic[index] ~=nil then
			packageBlock.pic[index].changeimage() --包裹框的图片
		end
		packageBlock.pic[index]:SetVisible(0)
		packageBlock.itemCount[index]:SetFontText("0",0xFFFFFF)
	end
	packageBlock.id = {}
    packageBlock.type = {}
end


---用于拖拽

function Equip_BagEquipIn_PullPicDeleteXLUP() 
    if(g_bag_equipIn_ui:IsVisible() == false) then
	    return
	end
	if(CheckEquipPullResultDestory(destory)) then
        XEquip_BagEquip_DeleteItem(equipManage.itemOnlyID[pullPicType.id])
	end
end

function Equip_BagEquipIn_pullPicXLUP()
    if(g_bag_equipIn_ui:IsVisible() == false or pullPicType.id == 0 or pullPicType.id ==nil) then
	    return
	end
    local tempRanking = Equip_BagEquipIn_checkRect() --判断是否在包裹框
	local oldranking = Equip_BagEquipIn_getPullPicIndexInPackage(pullPicType.id) --得到老的位置
	if(oldranking<=35 and oldranking>=1) then
	    bag_wnd.kuang[oldranking].changeimage(path_equip.."kuang_equip.png")	
    end	
	if(tempRanking == 0) then
	    return
	end
	if(oldranking~=0 and packageBlock.id[tempRanking] ~= 0 and packageBlock.id[tempRanking]~= nil) then
		Equip_BagEquipIn_change(oldranking,packageBlock.id[tempRanking])--如果在背包内存在		
	elseif(oldranking~=0 and (packageBlock.id[tempRanking] == 0 or packageBlock.id[tempRanking]== nil)) then
		Equip_BagEquipIn_cleanOne_ItemInfo(oldranking)
	end
    Equip_BagEquipIn_change(tempRanking,pullPicType.id) 
end

function Equip_BagEquipIn_WaterXLUP()
    if(g_bag_equipIn_ui:IsVisible() == false) then
	    return
	end
	local tempRanking = Equip_BagEquipIn_waterbar_checkRect() --判断是否在包裹框
	if(tempRanking == 0) then
	    return
	end
	XEquip_BagEquipIn_DragIn(tempRanking,equipManage.itemOnlyID[pullPicType.id])
end


function Equip_BagEquipIn_checkRect() --判断是否在包裹框
    for i = 1,35 do
	    if(CheckEquipPullResult(bag_wnd[i])) then
		    return i
		end
	end
	return 0
end

function Equip_BagEquipIn_waterbar_checkRect()
    for i = 1,3 do
	    if(CheckEquipPullResult(bag_medicine[i])) then
		    return i
		end
	end
	return 0
end


function Equip_BagEquipIn_getPullPicIndexInPackage(id) --得到老的位置
   for i = 1,35 do
	    if(packageBlock.id[i]== id) then
		    return i
		end
	end
	return 0
end

function Equip_BagEquipIn_SetWaterBarImage(onlyidid,strPic,ranking,tip)
	waterPackage.pic[ranking].changeimage("..\\"..strPic)--跟换图片
	waterPackage.pic[ranking]:SetVisible(1)
	waterPackage.onlyid[ranking] = onlyidid
	waterPackage.pic[ranking]:SetImageTip(tip)
end

function Equip_BagEquipIn_SetWaterBarClean(ranking)
    waterPackage.pic[ranking].changeimage()--跟换图片
	waterPackage.pic[ranking]:SetVisible(0)
	waterPackage.onlyid[ranking] = nil
end



function Equip_BagEquipIn_change(ranking,id)--位置 在数据库里的id
    packageBlock.id[ranking] = id
	packageBlock.pic[ranking].changeimage(equipManage.picPath[id])--跟换图片
    packageBlock.type[ranking] = equipManage.type[id]
	packageBlock.pic[ranking]:SetVisible(1)
	packageBlock.pic[ranking]:SetImageTip(equipManage.tip[id])
	packageBlock.itemCount[ranking]:SetFontText(equipManage.itemCount[id]) 
	if(equipManage.itemCount[id]>1 and equipManage.type[index]~=3) then
		packageBlock.itemCount[ranking]:SetVisible(1)
	else 
		packageBlock.itemCount[ranking]:SetVisible(0)
	end
end
function Equip_BagEquipIn_cleanOne_ItemInfo(ranking)
    packageBlock.pic[ranking].changeimage() --包裹框的图片
	packageBlock.pic[ranking]:SetVisible(0)
	packageBlock.pic[ranking]:SetImageTip(0)
	packageBlock.itemCount[ranking]:SetFontText("0",0xFFFFFF)
	packageBlock.id[ranking] = 0
    packageBlock.type[ranking] = 0
end































