-- Include
include("../Data/Script/Common/include.lua")

-- Member
local bag_wnd = {}
bag_wnd.kuang = {}

local packageBlock = {} -- 包裹框用于存放装备
packageBlock.pic = {} 	-- 包裹框的图片
packageBlock.id= {} 	-- 包裹框在装备库利的索引Id 0 为没有装备
packageBlock.type = {} 	-- 包裹框中是装备还是宝石 分别用 1和2 表示装备 和 宝石 0 代表没有装备 
packageBlock.itemCount = {} -- 物品数量
packageBlock.lock = {}	-- 锁

local left,right =nil
local PageNumber = 1
local PageNumberMax = 2
local PageNumberFont = nil
local sort_btn,repair_btn = nil

local V1 = nil
local V2 = nil
local V3 = nil
local V4 = nil
local V5 = nil

local V1Back = nil
local V2Back = nil
local V3Back = nil
local V4Back = nil
local V5Back = nil

local StorageSize = 20

-- Init
function InitBagStorage_EquipUI( wnd, bisopen)
	g_BagStorage_ui = CreateWindow(wnd.id, 250,150,720,695)
	InitBagStorage(g_BagStorage_ui)
	g_BagStorage_ui:SetVisible(bisopen)
end

-- 
function InitBagStorage(wnd)
	-- BackGround
	local BackGround = wnd:AddImage(path_equip.."storageBack_equip.png", 0, 0, 412, 497)
	
	BackGround:AddImage(path_equip.."storage_equip.png",185,15,49,26)
	
	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",370,6,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		local mapid = XGetMapId()
		if(mapid == 1) then
		    checkStorage_Setclose_Outside()
		else
		    checkStorage_Setclose_Inside()
		end
	end
	
	V1Back = BackGround:AddImage(path_equip.."storageVipBack_equip.png", 11, 213, 392, 113)
	V2Back = BackGround:AddImage(path_equip.."storageVipBack_equip.png", 11, 332, 392, 113)
    V3Back = BackGround:AddImage(path_equip.."storageVipBack_equip.png", 11, 70, 392, 113)
    V4Back = BackGround:AddImage(path_equip.."storageVipBack_equip.png", 11, 188, 392, 113)
    V5Back = BackGround:AddImage(path_equip.."storageVipBack_equip.png", 11, 306, 392, 113)
    V3Back:SetVisible(0)	
    V4Back:SetVisible(0)
    V5Back:SetVisible(0)
	-- VipIcon
	V1 = BackGround:AddImage(path_info.."VIP1.png", 290, 218, 128, 128)
	V2 = BackGround:AddImage(path_info.."VIP2.png", 290, 337, 128, 128)
	V3 = BackGround:AddImage(path_info.."VIP3.png", 290, 75, 128, 128)
	V4 = BackGround:AddImage(path_info.."VIP4.png", 290, 195, 128, 128)
	V5 = BackGround:AddImage(path_info.."VIP5.png", 290, 315, 128, 128)
	V3:SetVisible(0)
	V4:SetVisible(0)
	V5:SetVisible(0)
	
	for i=1, 20 do
		local posx = 54*((i-1)%7)+15
		local posy = math.ceil(i/7)*54-9
		
		bag_wnd[i] = BackGround:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		packageBlock.pic[i] = bag_wnd[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)
		packageBlock.lock[i] = bag_wnd[i]:AddImage(path_info.."lock_info.png", -2, -2, 64, 64)
		packageBlock.lock[i]:SetVisible(0)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.pic[i].script[XE_DRAG] = function()
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
		    if(g_bag_equip_ui:IsVisible() == true) then
			    local mndex = GetBagEquip_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,0,i,mndex)
                end	
			elseif(g_bag_expend_ui:IsVisible()==true) then
			    local mndex = GetBagExpand_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,4,i,mndex)
                end	
			elseif(g_bag_expend2_ui:IsVisible()==true) then
			    local mndex = GetBagExpand2_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,5,i,mndex)
                end	
			end
		end
	end
	
	
	for i=21, 30 do
		local posx = 54*(((i-20)-1)%5)+15
		local posy = math.ceil((i-20)/5)*54+163
		
        bag_wnd[i] = BackGround:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		packageBlock.pic[i] = bag_wnd[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)	
		packageBlock.lock[i] = bag_wnd[i]:AddImage(path_info.."lock_info.png", -2, -2, 64, 64)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.lock[i]:SetVisible(1)

		
		packageBlock.pic[i].script[XE_DRAG] = function()
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
		    if(g_bag_equip_ui:IsVisible() == true) then
			    local mndex = GetBagEquip_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,0,i,mndex)
                end	
			elseif(g_bag_expend_ui:IsVisible()==true) then
			    local mndex = GetBagExpand_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,4,i,mndex)
                end	
			elseif(g_bag_expend2_ui:IsVisible()==true) then
			    local mndex = GetBagExpand2_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,5,i,mndex)
                end	
			end
		end
	end
	

	for i=31, 40 do
		local posx = 54*(((i-20)-1)%5)+15
		local posy = math.ceil((i-20)/5)*54+173
		
        bag_wnd[i] = BackGround:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		packageBlock.pic[i] = bag_wnd[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)	
		packageBlock.lock[i] = bag_wnd[i]:AddImage(path_info.."lock_info.png", -2, -2, 64, 64)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.lock[i]:SetVisible(1)
		packageBlock.pic[i].script[XE_DRAG] = function()
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
		    if(g_bag_equip_ui:IsVisible() == true) then
			    local mndex = GetBagEquip_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,0,i,mndex)
                end	
			elseif(g_bag_expend_ui:IsVisible()==true) then
			    local mndex = GetBagExpand_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,4,i,mndex)
                end	
			elseif(g_bag_expend2_ui:IsVisible()==true) then
			    local mndex = GetBagExpand2_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,5,i,mndex)
                end	
			end
		end
	end
	
	for i=41, 50 do
		local posx = 54*(((i-40)-1)%5)+15
		local posy = math.ceil((i-40)/5)*54+20
		
        bag_wnd[i] = BackGround:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		bag_wnd[i]:SetVisible(0)
		packageBlock.pic[i] = bag_wnd[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.lock[i] = bag_wnd[i]:AddImage(path_info.."lock_info.png", -2, -2, 64, 64)
		packageBlock.lock[i]:SetVisible(1)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.pic[i].script[XE_DRAG] = function()
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
		    if(g_bag_equip_ui:IsVisible() == true) then
			    local mndex = GetBagEquip_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,0,i,mndex)
                end	
			elseif(g_bag_expend_ui:IsVisible()==true) then
			    local mndex = GetBagExpand_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,4,i,mndex)
                end	
			elseif(g_bag_expend2_ui:IsVisible()==true) then
			    local mndex = GetBagExpand2_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,5,i,mndex)
                end	
			end
		end
	end
	
	for i=51, 60 do
		local posx = 54*(((i-40)-1)%5)+15
		local posy = math.ceil((i-40)/5)*54+30
		
        bag_wnd[i] = BackGround:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		bag_wnd[i]:SetVisible(0)
		packageBlock.pic[i] = bag_wnd[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.lock[i] = bag_wnd[i]:AddImage(path_info.."lock_info.png", -2, -2, 64, 64)
		packageBlock.lock[i]:SetVisible(1)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.pic[i].script[XE_DRAG] = function()
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
		    if(g_bag_equip_ui:IsVisible() == true) then
			    local mndex = GetBagEquip_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,0,i,mndex)
                end	
			elseif(g_bag_expend_ui:IsVisible()==true) then
			    local mndex = GetBagExpand_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,4,i,mndex)
                end	
			elseif(g_bag_expend2_ui:IsVisible()==true) then
			    local mndex = GetBagExpand2_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,5,i,mndex)
                end	
			end
		end
	end
	
	for i=61, 70 do
		local posx = 54*(((i-40)-1)%5)+15
		local posy = math.ceil((i-40)/5)*54+40
		
        bag_wnd[i] = BackGround:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		bag_wnd[i]:SetVisible(0)
		packageBlock.pic[i] = bag_wnd[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.lock[i] = bag_wnd[i]:AddImage(path_info.."lock_info.png", -2, -2, 64, 64)
		packageBlock.lock[i]:SetVisible(1)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.pic[i].script[XE_DRAG] = function()
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
		    if(g_bag_equip_ui:IsVisible() == true) then
			    local mndex = GetBagEquip_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,0,i,mndex)
                end	
			elseif(g_bag_expend_ui:IsVisible()==true) then
			    local mndex = GetBagExpand_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,4,i,mndex)
                end	
			elseif(g_bag_expend2_ui:IsVisible()==true) then
			    local mndex = GetBagExpand2_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagEquip_change(2,5,i,mndex)
                end	
			end
		end
	end
	
	for i = 1,70 do
	    packageBlock.itemCount[i] = packageBlock.pic[i]:AddFont("0",12,6,-50,-33,100,17,0xFFFFFF)
	    packageBlock.itemCount[i]:SetVisible(0)
		packageBlock.itemCount[i]:SetFontBackground()
	end
	

	
	left = BackGround:AddButton(path_info.."L1_info.png",path_info.."L2_info.png",path_info.."L3_info.png", 158, 447, 27,36)
	XWindowEnableAlphaTouch(left.id)
	left:SetEnabled(0)
	right = BackGround:AddButton(path_info.."R1_info.png",path_info.."R2_info.png",path_info.."R3_info.png", 228, 447, 27,36)
	XWindowEnableAlphaTouch(right.id)
	local pageBK = left:AddImage(path_setup.."yemadiban_mail.png", 27, 9, 42, 18)	
    PageNumberFont = pageBK:AddFont("1/2",15, 8, -3, 0, 32, 18, 0xffffffff)
	
	left.script[XE_LBUP] = function()
		if(PageNumber == 2) then
			PageNumber = 1
			PageNumberFont:SetFontText("1/2",0xffffffff)
			ResetUi_Storage(PageNumber)
			left:SetEnabled(0)
			right:SetEnabled(1)
		end
	end

	right.script[XE_LBUP] = function()
		if(PageNumber == 1) then
			PageNumber = 2
			PageNumberFont:SetFontText("2/2",0xffffffff)
			ResetUi_Storage(PageNumber)
			left:SetEnabled(1)
			right:SetEnabled(0)
		end
	end
end

-- ResetUi
function ResetUi_Storage( cTempPageNum)
	if PageNumber==1 then
		V1:SetVisible(1)
		V2:SetVisible(1)
		V3:SetVisible(0)
		V4:SetVisible(0)
		V5:SetVisible(0)
		V1Back:SetVisible(1)
		V2Back:SetVisible(1)
		V3Back:SetVisible(0)
		V4Back:SetVisible(0)
		V5Back:SetVisible(0)
		for i=1, 40 do
			bag_wnd[i]:SetVisible(1)
		end
		for i=41, #bag_wnd do
			bag_wnd[i]:SetVisible(0)
		end
	elseif PageNumber==2 then
		V1:SetVisible(0)
		V2:SetVisible(0)
		V3:SetVisible(1)
		V4:SetVisible(1)
		V5:SetVisible(1)
		V1Back:SetVisible(0)
		V2Back:SetVisible(0)
		V3Back:SetVisible(1)
		V4Back:SetVisible(1)
		V5Back:SetVisible(1)
		for i=1, 40 do
			bag_wnd[i]:SetVisible(0)
		end
		for i=41, #bag_wnd do
			bag_wnd[i]:SetVisible(1)
		end
	end
end

function SetEquip_BagStorageSize()
    local vip = XGetPlayerVip()
	StorageSize = 20 + vip*10
	-- log("storage"..StorageSize)
	for i = 1,StorageSize do
	    packageBlock.lock[i]:SetVisible(0)
	end
end

function Equip_BagStorage_needEquipInfo()--需要全部 导入数据
    if(g_BagStorage_ui:IsVisible() == false) then
        return
	end	
	Equip_BagStorage_cleanALl_ItemInfo()--equipManage.CpackCindex = {}
    for index,value in pairs(equipManage.CitemIndex) do
	    local packCindex = equipManage.CpackCindex[index]+1
	    if(equipManage.bagType[index] == 2 and equipManage.CpackCindex[index] <=StorageSize) then
	        packageBlock.pic[packCindex].changeimageMultiple(equipManage.picPath[index],equipManage.picPath1[index],equipManage.picPath2[index])
		    packageBlock.pic[packCindex]:SetVisible(1)
		    packageBlock.pic[packCindex]:SetImageTip(equipManage.tip[index])
            packageBlock.id[packCindex] = equipManage.id[index]
            packageBlock.type[packCindex] = equipManage.type[index]
		    packageBlock.itemCount[packCindex]:SetFontText(equipManage.itemCount[index])
		    if(equipManage.itemCount[index]>1 and equipManage.type[index]~=3) then
			    packageBlock.itemCount[packCindex]:SetVisible(1)
		    else 
			    packageBlock.itemCount[packCindex]:SetVisible(0)
		    end
			if(equipManage.itemAnimation[index] ~= -1) then
			    packageBlock.pic[packCindex]:EnableImageAnimate(1,equipManage.itemAnimation[index],15,5)
			end	
		end	
	end
end	
function Equip_BagStorage_cleanALl_ItemInfo()
    for index =1,StorageSize do
	    packageBlock.pic[index].changeimage() --包裹框的图片
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

function Equip_BagStorage_pullPicXLUP()
    if(g_BagStorage_ui:IsVisible() == false or pullPicType.id == 0 or pullPicType.id ==nil) then
	    return
	end
    local tempRanking = Equip_BagStorage_checkRect() --判断是否在包裹框
	local oldBag = equipManage.bagType[pullPicType.id]
	local oldranking = equipManage.CpackCindex[pullPicType.id]+1  --得到老的位置
    	
	if(oldranking<=StorageSize and oldranking>=1 and oldBag == 2) then
	    bag_wnd.kuang[oldranking].changeimage(path_equip.."kuang_equip.png")	
    end	
	if(tempRanking == 0) then
	    return
	end
	XEquip_BagStorage_change(oldBag,2,oldranking,tempRanking)
end
function Equip_BagStorage_checkRect()
    for i = 1,StorageSize do
	    if(bag_wnd[i]:IsVisible() == true and CheckEquipPullResult(bag_wnd[i])) then
		    return i
		end
	end
	return 0
end
function Equip_BagStorage_getPullPicIndexInPackage(id) --得到老的位置
   for i = 1,StorageSize do
	    if(packageBlock.id[i] == id) then
		    return i
		end
	end
	return 0
end
function GetBagStorage_empty()
    for index = 1,StorageSize do
	    if(packageBlock.id[index] == 0 or packageBlock.id[index] == nil) then
		    return index
		end
	end
	return 0
end





-- SetUiVIsible
function SetBagStorageIsVisible( flag)
	if g_BagStorage_ui ~= nil then
		if flag==1 and g_BagStorage_ui:IsVisible()==false then
			g_BagStorage_ui:SetVisible(1)
			SetEquip_BagStorageSize()
			Equip_BagStorage_needEquipInfo()
		elseif flag==0 and g_BagStorage_ui:IsVisible()==true then
			g_BagStorage_ui:SetVisible(0)
			Equip_BagStorage_cleanALl_ItemInfo()
		end
	end
end

function Bag_StorageSetPosition(x,y)
    g_BagStorage_ui:SetPosition(x,y)
end

-- GetVisible
function GetBagStorageIsVisible()
	return g_BagStorage_ui:IsVisible()
end

function SetBagStorageVisibleAuto()
	if g_BagStorage_ui ~= nil then
		if g_BagStorage_ui:IsVisible()==false then
			g_BagStorage_ui:SetVisible(1)
		else
			g_BagStorage_ui:SetVisible(0)
		end
	end
end