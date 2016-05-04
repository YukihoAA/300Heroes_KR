include("../Data/Script/Common/include.lua")

-- Member
local m_EquipBackgroundImage = {}			-- 每个物品的Icon
local m_EquipBackgroundImageCount = {}		-- 用来表示物品个数
local m_EquipBackgroundImageFrame = {}		-- 每个物品Icon的框框
local LastSelImageIndex = 0					-- 最后一次选中的物品index
local m_RedemptionType = 0					-- 赎回物品类型		0 装备		1 宝石
local EquipReturnButton = nil				-- 装备购回  CheckButton1
local StoneReturnButton = nil				-- 宝石购回  CheckButton2
local IsChange1 = false						-- 控制CheckButton1是否切换图片
local IsChange2 = true						-- 控制CheckButton2是否切换图片

-- Data
local m_EquipInfo = {}						-- C++中的索引
m_EquipInfo.OnlyId = {}						-- 物品唯一id
m_EquipInfo.IconPath = {}					-- 物品图片路径
m_EquipInfo.Tip = {}						-- 物品tip
m_EquipInfo.IsShowAni = {}					-- 是否播放帧动画
m_EquipInfo.ItemCount = {}					-- 物品个数
local m_BuyShopIcon = nil					-- 可以购买的道具图片
local m_BuyShopIconCount = nil				-- 当前个数

-- 初始化
function Init_EquipRedemptionUI( wnd, bisopen)
	g_equip_redemption_ui = CreateWindow(wnd.id, 0, 0, 1280, 800)
	g_equip_redemption_ui:EnableBlackBackgroundTop(1)
	Init_EquipRedemption(g_equip_redemption_ui)
	g_equip_redemption_ui:SetVisible(bisopen)
end

-- 初始化UI
function Init_EquipRedemption(wnd)
	-- BackGround Is FatherNode
	local BackGround = wnd:AddImage( path_equip .. "storageBack_equip.png", 1280/2-412/2, 800/2-497/2+37, 412, 497)
	
	EquipReturnButton = BackGround:AddImage( path_equip .. "checkB3_equip.png", 0, -35, 128, 64)
	EquipReturnButton:AddFont( "装备购回", 15, 8, 0, 0, 110, 50, 0xffffff)
	StoneReturnButton = BackGround:AddImage( path_equip .. "checkB1_equip.png", 99, -35, 128, 64)
	StoneReturnButton:AddFont( "宝石购回", 15, 8, 0, 0, 110, 50, 0xffffff)
	
	-- 装备赎回
	EquipReturnButton.script[XE_ONHOVER] = function()
		if IsChange1 then
			EquipReturnButton.changeimage( path_equip .. "checkB2_equip.png" )
		end
	end
	EquipReturnButton.script[XE_ONUNHOVER] = function()
		if IsChange1 then
			EquipReturnButton.changeimage( path_equip .. "checkB1_equip.png" )
		end
	end
	EquipReturnButton.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- SendMsg
		m_RedemptionType = 0
		XSendShuHuiBagMsg( m_RedemptionType )
		
		IsChange1 = false
		IsChange2 = true
		EquipReturnButton.changeimage( path_equip .. "checkB3_equip.png" )
		StoneReturnButton.changeimage( path_equip .. "checkB1_equip.png" )
		
		-- 把选中状态的图片还原
		if LastSelImageIndex ~= 0 then
			m_EquipBackgroundImageFrame[LastSelImageIndex].changeimage( path_equip .. "kuang_equip.png")
			LastSelImageIndex = 0
		end
	end
	
	-- 宝石赎回
	StoneReturnButton.script[XE_ONHOVER] = function()
		if IsChange2 then
			StoneReturnButton.changeimage( path_equip .. "checkB2_equip.png" )
		end
	end
	StoneReturnButton.script[XE_ONUNHOVER] = function()
		if IsChange2 then
			StoneReturnButton.changeimage( path_equip .. "checkB1_equip.png" )
		end
	end
	StoneReturnButton.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- SendMsg
		m_RedemptionType = 1
		XSendShuHuiBagMsg( m_RedemptionType )
		
		IsChange2 = false
		IsChange1 = true
		StoneReturnButton.changeimage( path_equip .. "checkB3_equip.png" )
		EquipReturnButton.changeimage( path_equip .. "checkB1_equip.png" )
		
		-- 把选中状态的图片还原
		if LastSelImageIndex ~= 0 then
			m_EquipBackgroundImageFrame[LastSelImageIndex].changeimage( path_equip .. "kuang_equip.png")
			LastSelImageIndex = 0
		end
	end
	
	for i=1, 35 do
	
		local posx = 54*((i-1)%7)+20
		local posy = math.ceil(i/7)*54-7
		
		m_EquipBackgroundImage[i] = BackGround:AddImage( path_equip .. "bag_equip.png", posx, posy, 50, 50)
		m_EquipBackgroundImageCount[i] = m_EquipBackgroundImage[i]:AddFont( "0", 12, 6, -50, -33, 100, 17, 0xffffff)
		m_EquipBackgroundImageCount[i]:SetVisible(0)
		m_EquipBackgroundImageCount[i]:SetFontBackground()
		m_EquipBackgroundImageFrame[i] = m_EquipBackgroundImage[i]:AddImage( path_equip .. "kuang_equip.png", 0, 0, 50, 50)
		m_EquipBackgroundImageFrame[i]:SetTouchEnabled(0)
		
		m_EquipBackgroundImage[i].script[XE_LBUP] = function()
			-- 左键点下
			XClickPlaySound(5)
			local tempnum = tonumber( m_EquipInfo.OnlyId[i] )
			if tempnum > 0 and i ~= LastSelImageIndex then
				m_EquipBackgroundImageFrame[i].changeimage( path_equip .. "kuang3_equip.png")
				if LastSelImageIndex ~= 0 then
					m_EquipBackgroundImageFrame[LastSelImageIndex].changeimage( path_equip .. "kuang_equip.png")
				end
				LastSelImageIndex = i
			end
		end
		
	end
	
	local PromptingFont = BackGround:AddFont( "提示：\n· 每次购回需要消耗一张购回券\n· 最多可存储35件可购回道具(时效道具除外)\n· 赎回列表中的道具可能会不定期清除，请及时赎回道具", 12, 0, 15, 345, 250, 100, 0x8295cf)
	
	local BuyReturn = BackGround:AddButton( path_setup .. "btn1_mail.png", path_setup .. "btn2_mail.png", path_setup .. "btn3_mail.png", 285, 425, 100, 32)
	BuyReturn:AddFont( "购回", 15, 8, 0, 0, 100, 32)
	BuyReturn.script[XE_LBUP] = function()
		-- 左键点下
		XClickPlaySound(5)
		if LastSelImageIndex == 0 then
			-- 没有选中
			XShowMessageBoxFormLua( "请选中一个物品进行赎回！")
		else
			-- 选中了
			XClickRedemptionButton( m_EquipInfo.OnlyId[LastSelImageIndex], m_RedemptionType)
		end
	end
	
	m_BuyShopIcon = BackGround:AddImage( "..\\UI\\Icon\\equip\\shuhui.dds", 298, 360, 50, 50)
	XSetSomeOneItemTip( m_BuyShopIcon.id, 10)
	m_BuyShopIcon:AddImage( path_equip .. "kuang3_equip.png", 0, 0, 50, 50)
	m_BuyShopIconCount = m_BuyShopIcon:AddFont( "x1", 15, 0, 50, 33, 50, 20, 0xffffff)
	m_BuyShopIcon.script[XE_LBUP] = function()
		XClickPlaySound(5)
		-- 第二个参数是无效的
		XShopClickBuyItem( 1, 0, 10)
	end
	
	local CloseUI = BackGround:AddButton( path_shop .. "close1_rec.png", path_shop .. "close2_rec.png", path_shop .. "close3_rec.png", 365, 10, 35, 35)
	CloseUI.script[XE_LBUP] = function()
		-- 关闭UI
		XClickPlaySound(5)
		SetEquipRedemptionIsVisible(0)
	end
	
end

-- SetVisible
function SetEquipRedemptionIsVisible(flag)
	if g_equip_redemption_ui ~= nil then
		ReSetButtonState()
		if flag == 1 and g_equip_redemption_ui:IsVisible() == false then
			-- 打开
			g_equip_redemption_ui:CreateResource()
			XSendShuHuiBagMsg( m_RedemptionType )		-- 0 装备  1 宝石
			g_equip_redemption_ui:SetVisible(1)
		elseif flag == 0 and g_equip_redemption_ui:IsVisible() == true then
			-- 关闭
			g_equip_redemption_ui:SetVisible(0)
			for i=1, #m_EquipBackgroundImage do
				-- 每次关闭把赎回列表中的图片清空一下
				m_EquipBackgroundImage[i].changeimage( path_equip .. "bag_equip.png")
			end
			g_equip_redemption_ui:DeleteResource()
		end
	end
end

-- 得到赎回界面是否可见
function GetEquipRedemptionVisible()
	if g_equip_redemption_ui ~= nil and g_equip_redemption_ui:IsVisible() then
		return 1
	else
		return 0
	end
end

-- 重置UI状态
function ReSetButtonState()
	ClearEquipRedemptionAllData()
	IsChange1 = false
	IsChange2 = true
	m_RedemptionType = 0
	if EquipReturnButton ~= nil and StoneReturnButton ~= nil then
		EquipReturnButton.changeimage( path_equip .. "checkB3_equip.png" )
		StoneReturnButton.changeimage( path_equip .. "checkB1_equip.png" )
	end
end

-- 得到赎回的物品数据
function GetEquipRedemptionInfo( cOnlyId, cIconPath, cTip, cIndex, cIsShowAni, cItemCount)
	m_EquipInfo[cIndex] = cIndex-1
	m_EquipInfo.OnlyId[cIndex] = cOnlyId
	m_EquipInfo.IconPath[cIndex] = cIconPath
	m_EquipInfo.Tip[cIndex] = cTip
	m_EquipInfo.IsShowAni[cIndex] = cIsShowAni
	m_EquipInfo.ItemCount[cIndex] = cItemCount
end

-- 清除数据
function ClearEquipRedemptionAllData()
	m_EquipInfo = {}
	m_EquipInfo.OnlyId = {}
	m_EquipInfo.IconPath = {}
	m_EquipInfo.Tip = {}
	m_EquipInfo.IsShowAni = {}
	m_EquipInfo.ItemCount = {}
	if LastSelImageIndex ~= 0 then
		m_EquipBackgroundImageFrame[LastSelImageIndex].changeimage( path_equip .. "kuang_equip.png")
		LastSelImageIndex = 0
	end
	LastSelImageIndex = 0
end

-- 绘制
function RefeashEquipRedemption_Call()
	for i=1, #m_EquipBackgroundImage do
		if m_EquipInfo.IconPath[i] == nil or m_EquipInfo.IconPath[i] == "" then
			m_EquipBackgroundImage[i].changeimage( path_equip .. "bag_equip.png")
			XSetImageTip( m_EquipBackgroundImage[i].id, 0)
		else
			m_EquipBackgroundImage[i].changeimage( "..\\" .. m_EquipInfo.IconPath[i])
			XSetImageTip( m_EquipBackgroundImage[i].id, m_EquipInfo.Tip[i])
		end
		XEnableImageAnimate( m_EquipBackgroundImage[i].id, m_EquipInfo.IsShowAni[i], 6, 25, -3)
		
		if m_EquipInfo.ItemCount[i] > "1" then
			m_EquipBackgroundImageCount[i]:SetFontText( m_EquipInfo.ItemCount[i], 0xffffff)
			m_EquipBackgroundImageCount[i]:SetVisible(1)
		else
			m_EquipBackgroundImageCount[i]:SetVisible(0)
		end
	end
end

-- 设置每件物品的个数
function SetRedemptionItemCount( iCount)
	m_BuyShopIconCount:SetFontText( "x" .. iCount, 0xffffff)
end