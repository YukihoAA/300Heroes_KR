include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

-- 装备总览
local bag_wnd = {}
bag_wnd.kuang = {}

local destory = nil
local sort_btn,repair_btn = nil

-- 包裹框
local packageBlock = {} 		-- 包裹框用于存放装备
packageBlock.pic = {} 			-- 包裹框的图片
packageBlock.id= {} 			-- 包裹框在装备库利的索引Id 0 为没有装备
packageBlock.type = {} 			-- 包裹框中是装备还是宝石 分别用 1和2 表示装备 和 宝石 0 代表没有装备 
packageBlock.itemCount = {} 	-- 物品数量
packageBlock.picpath = {}

local EquipRedemptionBtn = nil

-- 装备全部物品界面
function InitBag_EquipUI(wnd, bisopen)
	-- 全部物品
	g_bag_equip_ui = CreateWindow(wnd.id, 700,220,410,460)
	for i=1,42 do
		local posx = 54*((i-1)%7+1)+10
		local posy = math.ceil(i/7)*54-44
		
		bag_wnd[i] = g_bag_equip_ui:AddImage(path_equip.."bag_equip.png",posx,posy,50,50)
		packageBlock.pic[i] = bag_wnd[i]:AddImageMultiple(path_equip.."bag_equip.png","","",0,0,50,50)
		packageBlock.pic[i]:SetVisible(0)
		bag_wnd.kuang[i] = bag_wnd[i]:AddImage(path_equip.."kuang_equip.png",0,0,50,50)
		packageBlock.pic[i].script[XE_DRAG] = function()
		    if(packageBlock.id[i] == nil or packageBlock.id[i] == 0) then
				-- id不存在 不响应
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
		
		packageBlock.pic[i].script[XE_SHIFTLBUP] = function()
			local mapid = XGetMapId()
			if mapid == 1 then
				AddItemToChatOut(equipManage.name[packageBlock.id[i]],equipManage.itemOnlyID[packageBlock.id[i]],equipManage.CitemIndex[packageBlock.id[i]])
			else
				AddItemToChatIn(equipManage.name[packageBlock.id[i]],equipManage.itemOnlyID[packageBlock.id[i]],equipManage.CitemIndex[packageBlock.id[i]])
			end
		end
		
		packageBlock.pic[i].script[XE_RBUP] = function()
		    if(packageBlock.id[i] == nil or packageBlock.id[i] == 0) then
				-- id不存在 不响应
			    return
			end
			
			if(g_BagStorage_ui:IsVisible() == true) then
			    local mndex = GetBagStorage_empty()
			    if(mndex == 0) then
				   return
				else
                    XEquip_BagStorage_change(0,2,i,mndex)
                end	
			elseif(packageBlock.type[i]~=3 and packageBlock.type[i] ~= 10 and packageBlock.type[i]~=5 and packageBlock.type[i]~=0) then
			    XBagEquipOnIconRButtonUp(equipManage.itemOnlyID[packageBlock.id[i]])			
			elseif(packageBlock.type[i]==3) then
			    local mapid = XGetMapId()
				local tempRanking = Equip_BattleBag_GetEmptyBlock()
			    if(mapid == 1) then
			        local BagNow = Equip_BattleBag_GetBagNow()
				    
				    if(tempRanking == 0) then
				        return
				    end	
			        if(BagNow == 2) then
			            tempRanking = tempRanking+6
			        elseif(BagNow == 3) then
			            tempRanking = tempRanking+12
			        end	
					-- 传给lua信息
                    XEquip_BattleBag_DragIn(tempRanking,equipManage.itemOnlyID[packageBlock.id[i]])
				else
					-- 传给lua信息
				    XEquip_fightBag_DragIn(tempRanking,equipManage.itemOnlyID[packageBlock.id[i]])
				end	
			end
		end
	end
	
	for i=1,42 do
	    packageBlock.itemCount[i] = packageBlock.pic[i]:AddFont("0",12,6,-50,-33,100,17,0xFFFFFF)
	    packageBlock.itemCount[i]:SetVisible(0)
		packageBlock.itemCount[i]:SetFontBackground()
	end
	
	destory = g_bag_equip_ui:AddImage(path_equip.."destory_equip.png",65,400,32,32)
	XWindowEnableAlphaTouch(destory.id)
	g_bag_equip_ui:AddFont("物品销毁",11, 0, 85, 404, 100, 20, 0x8295cf)

	sort_btn = g_bag_equip_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png", 245, 395, 100, 32)
	sort_btn:AddFont("物品整理",12, 8, 0, 0, 100, 32, 0xffffff)
	sort_btn.script[XE_LBUP] = function()
		XClickPlaySound(5)
	    XEquip_BagEquipSortAll()	-- 需要区分
	end
	
	
	repair_btn = g_bag_equip_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png", 345, 395, 100, 32)
	repair_btn:AddFont("全部修理",12, 8, 0, 0, 100, 32, 0xffffff)
	repair_btn.script[XE_LBUP] = function()
		XClickPlaySound(5)
	    XEquip_BagEquipRpaireAll()	-- 需要区分
	end
	g_bag_equip_ui:SetVisible(bisopen)
	
	EquipRedemptionBtn = g_bag_equip_ui:AddButton(path_setup.."btn1_mail.png",path_setup.."btn2_mail.png",path_setup.."btn3_mail.png", 145, 395, 100, 32)
	EquipRedemptionBtn:AddFont( "物品赎回", 12, 8, 0, 0, 100, 32, 0xffffff)
	EquipRedemptionBtn:SetVisible(1)
	EquipRedemptionBtn.script[XE_LBUP] = function()
		XClickPlaySound(5)
		SetEquipRedemptionIsVisible(1)
	end
end

function ControlRedemptionButtonVisible( iCount)
	if iCount > 0 then
		EquipRedemptionBtn:SetVisible(1)
	else
		EquipRedemptionBtn:SetVisible(0)
	end
end

function GetBagEquip_empty()
    for index = 1,42 do
	    if(packageBlock.id[index] == 0 or packageBlock.id[index] == nil) then
		    return index
		end
	end
	return 0
end

function SetBagEquipIsVisible(flag)  
	if g_bag_equip_ui ~= nil then
		if flag == 1 and g_bag_equip_ui:IsVisible() == false then
			-- log("\nVisible!!!")
			XCheckIsShowRedemptionUi()
			g_bag_equip_ui:SetVisible(1)
			Equip_BagEquip_needEquipInfo()
			EquipChangeBag(0)
		elseif flag == 0 and g_bag_equip_ui:IsVisible() == true then
			-- log("\nUnVisible!!!")
			g_bag_equip_ui:SetVisible(0)
			Equip_BagEquip_cleanALl_ItemInfo()
		end
	end
end

function Equip_BagEquip_cleanALl_ItemInfo()
    for index =1,42 do
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

-- 需要全部 导入第一个背包数据
function Equip_BagEquip_needEquipInfo()
    if(g_bag_equip_ui:IsVisible() == false) then
        return
	end	
	Equip_BagEquip_cleanALl_ItemInfo()
    for index,value in pairs(equipManage.CitemIndex) do
	    local packCindex = equipManage.CpackCindex[index]+1
	    if(equipManage.bagType[index] == 0 and equipManage.CpackCindex[index] <=42) then
		    if packageBlock.picpath[packCindex] ~= equipManage.picPath[index] then
	           packageBlock.pic[packCindex].changeimageMultiple(equipManage.picPath[index],equipManage.picPath1[index],equipManage.picPath2[index])
			   packageBlock.picpath[packCindex] = equipManage.picPath[index]
			end   
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

-- 用于拖拽
function Equip_BagEquip_pullPicXLUP()
    if(g_bag_equip_ui:IsVisible() == false or pullPicType.id == 0 or pullPicType.id ==nil) then
	    return
	end
    local tempRanking = Equip_BagEquip_checkRect() 					-- 判断是否在包裹框
	local oldBag = equipManage.bagType[pullPicType.id]
	local oldranking = equipManage.CpackCindex[pullPicType.id]+1  	-- 得到老的位置	
	
	if(oldranking<=42 and oldranking>=1 and oldBag == 0) then
	    bag_wnd.kuang[oldranking].changeimage(path_equip.."kuang_equip.png")	
    end	
	if(tempRanking == 0) then
	    return
	end
	XEquip_BagEquip_change(oldBag,0,oldranking,tempRanking)
end

function Equip_BagEquip_PullPicDeleteXLUP()  
    if(g_bag_equip_ui:IsVisible() == false) then
	    return
	end
	if(CheckEquipPullResultDestory(destory)) then
       XEquip_BagEquip_DeleteItem(equipManage.itemOnlyID[pullPicType.id])
	end
end

function Equip_BagEquip_checkRect() -- 判断是否在包裹框
    for i = 1,42 do
	    if(CheckEquipPullResult(bag_wnd[i])) then
		    return i
		end
	end
	return 0
end

function getPullPicIndexInPackage(id) -- 得到老的位置
   for i = 1,42 do
	    if(packageBlock.id[i] == id) then
		    return i
		end
	end
	return 0
end



function Bag_EquipSetPosition(x,y)
	g_bag_equip_ui:SetPosition(x,y)
end