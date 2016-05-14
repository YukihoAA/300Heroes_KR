include("../Data/Script/Common/include.lua")
include("../Data/Script/Common/window.lua")

local check_list = {}
local check_pattern = {}
local font_list = {"角色","场景","角色","场景","特效","地形","特效","地形","动画渲染","天气雾效","垂直同步"}	

-- 全屏
local Fbtn_showAll = nil
local FFont_showAll = nil
local FshowAll_BK = nil
local FBTN_showAllBK = nil
local FBTN_showAllFont = "1920x1080"
-- 窗口
local Sbtn_showAll = nil
local SFont_showAll = nil
local SshowAll_BK = nil
local SBTN_showAllBK = {}
local SBTN_showFontDetail = {}
local SBTN_showAllFont = {"1280x800","1280x960","1920x1080","1920x1080","1920x1080","1920x1080"}

-- 场景
local btn_Scene = nil
local Font_Scene = nil
local Scene_BK = nil
local BTN_SceneBK = {}
local BTN_SceneFont = {"最低","低","中等","高","最高"}
-- 模型
local btn_Model = nil
local Font_Model = nil
local Model_BK = nil
local BTN_ModelBK = {}
local BTN_ModelFont = {"最低","低","中等","高","最高"}
-- 贴图
local btn_Shader = nil
local Font_Shader = nil
local Shader_BK = nil
local BTN_ShaderBK = {}
local BTN_ShaderFont = {"最低","低","中等","高","最高"}
-- 地图
local btn_Map = nil
local Font_Map = nil
local Map_BK = nil
local BTN_MapBK = {}
local BTN_MapFont = {"最低","低","中等","高","最高"}

local posx_move = -240
local posy_move = -150
local index_showAll = 0

-- 画面设置四个档
local SFaceLevel_Button = nil
local SFaceLevel_Font = nil
local SFaceLevel_BackGround = nil
local SFaceLevel_ShowAm = {}
local SFaceLevel_FontList = {}
local SFaceSet_Font = {"自定义", "速度优先", "流畅画质", "标准画质", "高级画质", "最佳画质"}
local SFaceLevel_SelIndex = 0
local IsClickChuiZhiTongBu = 0
local UnEnableClickImage = nil

function InitSetup_FaceUI(wnd, bisopen)
	g_setup_face_ui = CreateWindow(wnd.id, (1920-1920)/2, (1080-1080)/2, 1920, 1080)
	InitMainSetup_Face(g_setup_face_ui)
	g_setup_face_ui:SetVisible(bisopen)
end

function InitMainSetup_Face(wnd)
	wnd:AddImage(path_setup.."BK_setup.png",0,0,793,486)
	wnd:AddImage(path_setup.."facefont1_setup.png",592+posx_move,162+posy_move,128,32)
	wnd:AddImage(path_setup.."facefont2_setup.png",250+posx_move,175+posy_move,746,66)
	wnd:AddImage(path_setup.."facefont3_setup.png",250+posx_move,285+posy_move,746,66)

	local btn_close = wnd:AddButton(path_shop.."close1_rec.png",path_shop.."close2_rec.png",path_shop.."close3_rec.png",985+posx_move,160+posy_move,35,35)
	btn_close.script[XE_LBUP] = function()
		XClickPlaySound(5)
		Set_SetupIsVisible(0)
		XcancelOnButtonClick_Face(0)
	end
	
	-- local btn_cancel = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",815+posx_move,560+posy_move,164,49)
	-- btn_cancel:AddFont("取消",15, 0, 65, 15, 100, 20, 0xffffff)
	-- btn_cancel.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- XcancelOnButtonClick_Face(1)
	-- end
	
	local AM = wnd:AddFont("提示：仅窗口模式可修改分辨率",11, 0, 715+posx_move, 293+posy_move, 400, 20, 0xc23452)
	AM:SetFontSpace(1,1)
	-- 小框框
	wnd:AddImage(path_setup.."kuang_setup.png",260+posx_move,375+posy_move,256,128)
	wnd:AddImage(path_setup.."kuang_setup.png",465+posx_move,375+posy_move,256,128)
	
	-- 画面设置滑动条
	-- wnd:AddImage(path_setup.."set1_setup.png",720+posx_move,405+posy_move,512,16)
	-- AA = wnd:AddImage(path_setup.."set2_setup.png",720+posx_move,406+posy_move,485,16)

	-- local AAA = wnd:AddImage(path_setup.."set3_setup.png",720+posx_move,405+posy_move,512,16)
	-- AAA:SetTouchEnabled(0)

	-- wnd:AddFont("自定义",15, 0, 696+posx_move, 432+posy_move, 100, 20, 0x8f9bd7)
	-- wnd:AddFont("低",15, 0, 809+posx_move, 432+posy_move, 100, 20, 0x8f9bd7)
	-- wnd:AddFont("中",15, 0, 909+posx_move, 432+posy_move, 100, 20, 0x8f9bd7)
	-- wnd:AddFont("高",15, 0, 990+posx_move, 432+posy_move, 100, 20, 0x8f9bd7)
	-- FaceSetType[1] = AA:AddImage(path_setup.."checkbox_setup.png", -1, 0, 16, 16)
	-- FaceSetType[2] = AA:AddImage(path_setup.."checkbox_setup.png", 94, 0, 16, 16)
	-- FaceSetType[3] = AA:AddImage(path_setup.."checkbox_setup.png", 194, 0, 16, 16)
	-- FaceSetType[4] = AA:AddImage(path_setup.."checkbox_setup.png", 274, 0, 16, 16)
	
	-- ABCD = wnd:AddImage(path_setup.."set1_setup.png", 718+posx_move, 404+posy_move, 8, 32)
	
	-- for i = 1, 4 do
		-- FaceSetType[i]:SetTransparent(0)
		-- FaceSetType[i].script[XE_LBUP] = function()
			-- if i == 1 then
				-- XSetEffectScrollBarPos(1, 0)
				-- AA:SetAddImageRect(AA.id,0,0,0,16,720+posx_move,405+posy_move,0,16)
				-- ABCD:SetPosition(718+posx_move,404+posy_move)
			-- elseif i == 2 then
				-- XSetEffectScrollBarPos(1, 1)
				-- AA:SetAddImageRect(AA.id,0,0,100,16,720+posx_move,405+posy_move,100,16)
				-- ABCD:SetPosition(818+posx_move,404+posy_move)
			-- elseif i == 3 then
				-- XSetEffectScrollBarPos(1, 3)
				-- AA:SetAddImageRect(AA.id,0,0,200,16,720+posx_move,405+posy_move,200,16)
				-- ABCD:SetPosition(918+posx_move,404+posy_move)
			-- elseif i == 4 then
				-- XSetEffectScrollBarPos(1, 5)
				-- AA:SetAddImageRect(AA.id,0,0,280,16,720+posx_move,405+posy_move,280,16)
				-- ABCD:SetPosition(998+posx_move,404+posy_move)
			-- end
		-- end
	-- end
	
	-----分辨率（写2个，位置一致）
	----全屏分辨率
	Fbtn_showAll = wnd:AddImage(path_hero.."herolist1_hero.png",820+posx_move,253+posy_move,128,32)
	FFont_showAll = Fbtn_showAll:AddFont(FBTN_showAllFont,12,0,3,6,100,15,0xbeb5ee)
	FshowAll_BK = wnd:AddImage(path_hero.."listBK2_hero.png",820+posx_move,283+posy_move,128,512)
	wnd:SetAddImageRect(FshowAll_BK.id,0,0,128,30,820+posx_move,283+posy_move,128,30)
	FshowAll_BK:SetVisible(0)
	
	FBTN_showAllBK = wnd:AddImage(path_hero.."listhover_hero.png",820+posx_move,283+posy_move,128,32)
	FshowAll_BK:AddFont(FBTN_showAllFont,12,0,3,6,128,32,0xbeb5ee)
	FBTN_showAllBK:SetTransparent(0)
	FBTN_showAllBK:SetTouchEnabled(0)
	
	-- -----------鼠标滑过
	-- FBTN_showAllBK.script[XE_ONHOVER] = function()
		-- if FshowAll_BK:IsVisible() == true then
			-- FBTN_showAllBK:SetTransparent(1)
		-- end
	-- end
	-- FBTN_showAllBK.script[XE_ONUNHOVER] = function()
		-- if FshowAll_BK:IsVisible() == true then
			-- FBTN_showAllBK:SetTransparent(0)
		-- end
	-- end
	-- FBTN_showAllBK.script[XE_LBUP] = function()
		-- FFont_showAll:SetFontText(FBTN_showAllFont,0xbeb5ee)
					
		-- --onSearchEnter()
		-- Fbtn_showAll:SetButtonFrame(0)
		-- FshowAll_BK:SetVisible(0)
		-- FBTN_showAllBK:SetTransparent(0)
		-- FBTN_showAllBK:SetTouchEnabled(0)
	-- end
	-- Fbtn_showAll.script[XE_LBUP] = function()
		-- XClickPlaySound(5)
		-- if FshowAll_BK:IsVisible() then
			-- FshowAll_BK:SetVisible(0)
			-- FBTN_showAllBK:SetTransparent(0)
			-- FBTN_showAllBK:SetTouchEnabled(0)
		-- else
			-- FshowAll_BK:SetVisible(1)
			-- FBTN_showAllBK:SetTransparent(0)
			-- FBTN_showAllBK:SetTouchEnabled(1)
		-- end
	-- end
	
	-- 10选项
	local aabb = wnd:AddImage(path_setup.."option_setup.png",290+posx_move,253+posy_move,128,32)
	aabb:AddFont("全屏模式",15, 0, 21, 5, 100, 20, 0xc7bdf6)
	aabb = wnd:AddImage(path_setup.."option_setup.png",495+posx_move,253+posy_move,128,32)
	aabb:AddFont("窗口模式",15, 0, 21, 5, 100, 20, 0xc7bdf6)
	aabb = wnd:AddImage(path_setup.."option_setup.png",715+posx_move,253+posy_move,128,32)
	aabb:AddFont("分辨率",15, 0, 23, 5, 100, 20, 0xc7bdf6)
	aabb = wnd:AddImage(path_setup.."option_setup.png",275+posx_move,362+posy_move,128,32)
	aabb:AddFont("开启反射",15, 0, 21, 5, 100, 20, 0xc7bdf6)
	aabb = wnd:AddImage(path_setup.."option_setup.png",480+posx_move,362+posy_move,128,32)
	aabb:AddFont("开启阴影",15, 0, 21, 5, 100, 20, 0xc7bdf6)
	
	
	aabb = wnd:AddImage(path_setup.."optionsmall_setup.png",663+posx_move,437+posy_move,128,32)
	aabb:AddFont("场景细节",12, 0, 16, 4, 100, 20, 0xc7bdf6)
	aabb = wnd:AddImage(path_setup.."optionsmall_setup.png",847+posx_move,437+posy_move,128,32)
	aabb:AddFont("模型细节",12, 0, 16, 4, 100, 20, 0xc7bdf6)
	aabb = wnd:AddImage(path_setup.."optionsmall_setup.png",663+posx_move,507+posy_move,128,32)
	aabb:AddFont("贴图细节",12, 0, 16, 4, 100, 20, 0xc7bdf6)
	aabb = wnd:AddImage(path_setup.."optionsmall_setup.png",847+posx_move,507+posy_move,128,32)
	aabb:AddFont("地图细节",12, 0, 16, 4, 100, 20, 0xc7bdf6)
	
	-- 四个细节下拉列表框
	-- 贴图细节
	btn_Shader = wnd:AddTwoButton(path_setup.."listB1_setup.png", path_setup.."listB2_setup.png", path_setup.."listB1_setup.png",751+posx_move,508+posy_move,128,32)
	Font_Shader = btn_Shader:AddFont(BTN_ShaderFont[1],12,0,20,4,100,15,0xbeb5ee)
	
	btn_Shader.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if Shader_BK:IsVisible() then
			Shader_BK:SetVisible(0)
			for index,value in pairs(BTN_ShaderBK) do
				BTN_ShaderBK[index]:SetTransparent(0)
				BTN_ShaderBK[index]:SetTouchEnabled(0)
			end
		else
			ReSetCheckButtonState_facesetup()
			btn_Shader:SetButtonFrame(1)
			Shader_BK:SetVisible(1)
			for index,value in pairs(BTN_ShaderBK) do
				BTN_ShaderBK[index]:SetTransparent(0)
				BTN_ShaderBK[index]:SetTouchEnabled(1)
			end
		end
	end
	-- 地图细节
	btn_Map = wnd:AddTwoButton(path_setup.."listB1_setup.png", path_setup.."listB2_setup.png", path_setup.."listB1_setup.png",935+posx_move,508+posy_move,128,32)
	Font_Map = btn_Map:AddFont(BTN_MapFont[1],12,0,20,4,100,15,0xbeb5ee)
	
	btn_Map.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if Map_BK:IsVisible() then
			Map_BK:SetVisible(0)
			for index,value in pairs(BTN_MapBK) do
				BTN_MapBK[index]:SetTransparent(0)
				BTN_MapBK[index]:SetTouchEnabled(0)
			end
		else
			ReSetCheckButtonState_facesetup()
			btn_Map:SetButtonFrame(1)
			Map_BK:SetVisible(1)
			for index,value in pairs(BTN_MapBK) do
				BTN_MapBK[index]:SetTransparent(0)
				BTN_MapBK[index]:SetTouchEnabled(1)
			end
		end
	end
	-- 场景细节
	btn_Scene = wnd:AddTwoButton(path_setup.."listB1_setup.png", path_setup.."listB2_setup.png", path_setup.."listB1_setup.png",751+posx_move,437+posy_move,128,32)
	Font_Scene = btn_Scene:AddFont(BTN_SceneFont[1],12,0,20,4,100,15,0xbeb5ee)
	
	btn_Scene.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if Scene_BK:IsVisible() then
			Scene_BK:SetVisible(0)
			for index,value in pairs(BTN_SceneBK) do
				BTN_SceneBK[index]:SetTransparent(0)
				BTN_SceneBK[index]:SetTouchEnabled(0)
			end
		else
			ReSetCheckButtonState_facesetup()
			btn_Scene:SetButtonFrame(1)
			Scene_BK:SetVisible(1)
			for index,value in pairs(BTN_SceneBK) do
				BTN_SceneBK[index]:SetTransparent(0)
				BTN_SceneBK[index]:SetTouchEnabled(1)
			end
		end
	end
	-- 模型细节
	btn_Model = wnd:AddTwoButton(path_setup.."listB1_setup.png", path_setup.."listB2_setup.png", path_setup.."listB1_setup.png",935+posx_move,437+posy_move,128,32)
	Font_Model = btn_Model:AddFont(BTN_ModelFont[1],12,0,20,4,100,15,0xbeb5ee)
	
	btn_Model.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if Model_BK:IsVisible() then
			Model_BK:SetVisible(0)
			for index,value in pairs(BTN_ModelBK) do
				BTN_ModelBK[index]:SetTransparent(0)
				BTN_ModelBK[index]:SetTouchEnabled(0)
			end
		else
			ReSetCheckButtonState_facesetup()
			btn_Model:SetButtonFrame(1)
			Model_BK:SetVisible(1)
			for index,value in pairs(BTN_ModelBK) do
				BTN_ModelBK[index]:SetTransparent(0)
				BTN_ModelBK[index]:SetTouchEnabled(1)
			end
		end
	end
	
	-- 15个勾选框
	local check_posx = {405,608,388,592,324,414,529,619,324,414,529,619,358,488,619}
	local check_posy = {255,255,364,364,408,408,408,408,448,448,448,448,506,506,506}
	
	for i=1,15 do
		check_list[i] = wnd:AddImage(path_hero.."checkbox_hero.png",check_posx[i]+posx_move,check_posy[i]+posy_move,32,32)
		check_list[i]:SetTouchEnabled(1)
		check_pattern[i] = check_list[i]:AddImage(path_hero.."checkboxYes_hero.png",5,-1,32,32)
		check_pattern[i]:SetTouchEnabled(0)
		check_pattern[i]:SetVisible(1)
		if i==2 then
			check_pattern[2]:SetVisible(0)
			Fbtn_showAll:SetVisible(1)
		end
		check_list[i].script[XE_LBUP] = function()
			SshowAll_BK:SetVisible(0)
			if ( check_pattern[i]:IsVisible() ) then
				XClickCheckButtonEffect_Set(1, i-1, 0)
				check_pattern[i]:SetVisible(0)
				if i==1 then
					check_pattern[2]:SetVisible(1)
					Fbtn_showAll:SetVisible(0)
					Sbtn_showAll:SetVisible(1)
				elseif i==2 then
					check_pattern[1]:SetVisible(1)
					Fbtn_showAll:SetVisible(1)
					Sbtn_showAll:SetVisible(0)
				end
			else
				XClickCheckButtonEffect_Set(1, i-1, 1)
				XSetDisplay_ResolutionCurSelIndex(1, 0)
				check_pattern[i]:SetVisible(1)
				if i==1 then
					check_pattern[2]:SetVisible(0)
					Fbtn_showAll:SetVisible(1)
					Sbtn_showAll:SetVisible(0)
				elseif i==2 then
					check_pattern[1]:SetVisible(0)
					Fbtn_showAll:SetVisible(0)
					Sbtn_showAll:SetVisible(1)
				end
			end
			
			if i==15 then
				IsClickChuiZhiTongBu = 1
			end
			
			SFaceLevel_Button:SetButtonFrame(0)
			SFaceLevel_BackGround:SetVisible(0)
			for index,value in pairs(SFaceLevel_ShowAm) do
				SFaceLevel_ShowAm[index]:SetTransparent(0)
				SFaceLevel_ShowAm[index]:SetTouchEnabled(0)
			end
			-- 全屏和窗口互斥
		end
	end
	
	local font_posx = {283,372,488,577,283,372,488,577,290,422,552}
	local font_posy = {411,411,411,411,450,450,450,450,511,511,511}
	
	for i=1,11 do
		wnd:AddFont(font_list[i],15, 0, font_posx[i]+posx_move, font_posy[i]+posy_move, 100, 20, 0x8f9bd7)
	end
	
	UnEnableClickImage = wnd:AddImage(path_setup.."UnEnabled.png", 9, 202, 777, 278)
	
	
	local btn_back = wnd:AddButton(path_setup.."back1_setup.png",path_setup.."back2_setup.png",path_setup.."back3_setup.png",290+posx_move,560+posy_move,164,49)
	btn_back:AddFont("返回设置",15, 0, 50, 14, 100, 20, 0xffffff)
	btn_back.script[XE_LBUP] = function()
		XClickPlaySound(5)
		XSetFaceUiVisible_Tab(1,0)
		XcancelOnButtonClick_Face(1)
	end
	
	local btn_apply = wnd:AddButton(path_setup.."apply1_setup.png",path_setup.."apply2_setup.png",path_setup.."apply3_setup.png",815+posx_move,560+posy_move,164,49)
	btn_apply:AddFont("确认",15, 0, 65, 15, 100, 20, 0xffffff)
	btn_apply.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if IsClickChuiZhiTongBu==1 then
			XconfirmOnButtonClick_Face(1)
		end
		XconfirmOnButtonClick_Face(1)
		IsClickChuiZhiTongBu = 0
	end
	
	aabb = wnd:AddImage(path_setup.."option_setup.png",715+posx_move,362+posy_move,128,32)
	aabb:AddFont("画面设置",15, 0, 21, 5, 100, 20, 0xc7bdf6)
	
	Shader_BK = wnd:AddImage(path_setup.."listB3_setup.png",751+posx_move,533+posy_move,128,256)
	wnd:SetAddImageRect(Shader_BK.id,0,0,128,140,751+posx_move,533+posy_move,128,140)
	Shader_BK:SetVisible(0)
	
	for dis = 1,5 do
		BTN_ShaderBK[dis] = wnd:AddImage(path_setup.."listB4_setup.png",751+posx_move,504+dis*29+posy_move,128,32)
		Shader_BK:AddFont(BTN_ShaderFont[dis],12,0,20,dis*29-25,128,32,0xbeb5ee)
		BTN_ShaderBK[dis]:SetTransparent(0)
		BTN_ShaderBK[dis]:SetTouchEnabled(0)
		-----------鼠标滑过
		BTN_ShaderBK[dis].script[XE_ONHOVER] = function()
			if Shader_BK:IsVisible() == true then
				BTN_ShaderBK[dis]:SetTransparent(1)
			end
		end
		BTN_ShaderBK[dis].script[XE_ONUNHOVER] = function()
			if Shader_BK:IsVisible() == true then
				BTN_ShaderBK[dis]:SetTransparent(0)
			end
		end
		BTN_ShaderBK[dis].script[XE_LBUP] = function()
			XPicturedetailOnComboBoxSelChange(1, dis-1)
			Font_Shader:SetFontText(BTN_ShaderFont[dis],0xbeb5ee)

			--onSearchEnter()
			btn_Shader:SetButtonFrame(0)
			Shader_BK:SetVisible(0)
			for index,value in pairs(BTN_ShaderBK) do
				BTN_ShaderBK[index]:SetTransparent(0)
				BTN_ShaderBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	Map_BK = wnd:AddImage(path_setup.."listB3_setup.png",935+posx_move,533+posy_move,128,256)
	wnd:SetAddImageRect(Map_BK.id,0,0,128,140,935+posx_move,533+posy_move,128,140)
	Map_BK:SetVisible(0)
	
	for dis = 1,5 do
		BTN_MapBK[dis] = wnd:AddImage(path_setup.."listB4_setup.png",935+posx_move,504+dis*29+posy_move,128,32)
		Map_BK:AddFont(BTN_MapFont[dis],12,0,20,dis*29-25,128,32,0xbeb5ee)
		BTN_MapBK[dis]:SetTransparent(0)
		BTN_MapBK[dis]:SetTouchEnabled(0)
		-----------鼠标滑过
		BTN_MapBK[dis].script[XE_ONHOVER] = function()
			if Map_BK:IsVisible() == true then
				BTN_MapBK[dis]:SetTransparent(1)
			end
		end
		BTN_MapBK[dis].script[XE_ONUNHOVER] = function()
			if Map_BK:IsVisible() == true then
				BTN_MapBK[dis]:SetTransparent(0)
			end
		end
		BTN_MapBK[dis].script[XE_LBUP] = function()
			XTerraindetailOnComboBoxSelChange(1, dis-1)
			Font_Map:SetFontText(BTN_MapFont[dis],0xbeb5ee)

			--onSearchEnter()
			btn_Map:SetButtonFrame(0)
			Map_BK:SetVisible(0)
			for index,value in pairs(BTN_MapBK) do
				BTN_MapBK[index]:SetTransparent(0)
				BTN_MapBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	Scene_BK = wnd:AddImage(path_setup.."listB3_setup.png",751+posx_move,462+posy_move,128,256)
	wnd:SetAddImageRect(Scene_BK.id,0,0,128,140,751+posx_move,462+posy_move,128,140)
	Scene_BK:SetVisible(0)
	
	for dis = 1,5 do
		BTN_SceneBK[dis] = wnd:AddImage(path_setup.."listB4_setup.png",751+posx_move,433+dis*29+posy_move,128,32)
		Scene_BK:AddFont(BTN_SceneFont[dis],12,0,20,dis*29-25,128,32,0xbeb5ee)
		BTN_SceneBK[dis]:SetTransparent(0)
		BTN_SceneBK[dis]:SetTouchEnabled(0)
		-----------鼠标滑过
		BTN_SceneBK[dis].script[XE_ONHOVER] = function()
			if Scene_BK:IsVisible() == true then
				BTN_SceneBK[dis]:SetTransparent(1)
			end
		end
		BTN_SceneBK[dis].script[XE_ONUNHOVER] = function()
			if Scene_BK:IsVisible() == true then
				BTN_SceneBK[dis]:SetTransparent(0)
			end
		end
		BTN_SceneBK[dis].script[XE_LBUP] = function()
			XMapdetailOnComboBoxSelChange(1, dis-1)
			Font_Scene:SetFontText(BTN_SceneFont[dis],0xbeb5ee)

			--onSearchEnter()
			btn_Scene:SetButtonFrame(0)
			Scene_BK:SetVisible(0)
			for index,value in pairs(BTN_SceneBK) do
				BTN_SceneBK[index]:SetTransparent(0)
				BTN_SceneBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	Model_BK = wnd:AddImage(path_setup.."listB3_setup.png",935+posx_move,462+posy_move,128,256)
	wnd:SetAddImageRect(Model_BK.id,0,0,128,140,935+posx_move,462+posy_move,128,140)
	Model_BK:SetVisible(0)
	
	for dis = 1,5 do
		BTN_ModelBK[dis] = wnd:AddImage(path_setup.."listB4_setup.png",935+posx_move,433+dis*29+posy_move,128,32)
		Model_BK:AddFont(BTN_ModelFont[dis],12,0,20,dis*29-25,128,32,0xbeb5ee)
		BTN_ModelBK[dis]:SetTransparent(0)
		BTN_ModelBK[dis]:SetTouchEnabled(0)
		-----------鼠标滑过
		BTN_ModelBK[dis].script[XE_ONHOVER] = function()
			if Model_BK:IsVisible() == true then
				BTN_ModelBK[dis]:SetTransparent(1)
			end
		end
		BTN_ModelBK[dis].script[XE_ONUNHOVER] = function()
			if Model_BK:IsVisible() == true then
				BTN_ModelBK[dis]:SetTransparent(0)
			end
		end
		BTN_ModelBK[dis].script[XE_LBUP] = function()
			XBuilddetailOnComboBoxSelChange(1, dis-1)
			Font_Model:SetFontText(BTN_ModelFont[dis],0xbeb5ee)

			--onSearchEnter()
			btn_Model:SetButtonFrame(0)
			Model_BK:SetVisible(0)
			for index,value in pairs(BTN_ModelBK) do
				BTN_ModelBK[index]:SetTransparent(0)
				BTN_ModelBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	-- 画面设置
	SFaceLevel_Button = wnd:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",820+posx_move,362+posy_move,128,32)
	SFaceLevel_Font = SFaceLevel_Button:AddFont("顶级配置",12,0,3,6,100,15,0xbeb5ee)
	
	SFaceLevel_BackGround = wnd:AddImage(path_hero.."listBK2_hero.png",820+posx_move,392+posy_move,128,512)
	wnd:SetAddImageRect(SFaceLevel_BackGround.id,0,0,128,175,820+posx_move,392+posy_move,128,175)
	SFaceLevel_BackGround:SetVisible(0)
	
	for dis = 1,6 do
		SFaceLevel_ShowAm[dis] = wnd:AddImage(path_hero.."listhover_hero.png",820+posx_move,363+dis*29+posy_move,128,32)
		SFaceLevel_FontList[dis] = SFaceLevel_BackGround:AddFont(SFaceSet_Font[dis],12,0,3,dis*29-23,128,32,0xbeb5ee)
		SFaceLevel_ShowAm[dis]:SetTransparent(0)
		SFaceLevel_ShowAm[dis]:SetTouchEnabled(0)
		
		-- 鼠标滑过
		SFaceLevel_ShowAm[dis].script[XE_ONHOVER] = function()
			-- log("\nSFaceLevel_ShowAm = "..dis)
			if SFaceLevel_BackGround:IsVisible() == true then
				SFaceLevel_ShowAm[dis]:SetTransparent(1)
			end
		end
		SFaceLevel_ShowAm[dis].script[XE_ONUNHOVER] = function()
			if SFaceLevel_BackGround:IsVisible() == true then
				SFaceLevel_ShowAm[dis]:SetTransparent(0)
			end
		end
		SFaceLevel_ShowAm[dis].script[XE_LBUP] = function()
			if SFaceLevel_BackGround:IsVisible() then
				XSetEffectScrollBarPos(1, dis-1)
				SFaceLevel_Font:SetFontText(SFaceSet_Font[dis],0xbeb5ee)
				if dis==1 then
					UnEnableClickImage:SetVisible(0)
				else
					UnEnableClickImage:SetVisible(1)
				end
				SFaceLevel_SelIndex = dis
				
				-- onSearchEnter()
				SFaceLevel_Button:SetButtonFrame(0)
				SFaceLevel_BackGround:SetVisible(0)
				for index,value in pairs(SFaceLevel_ShowAm) do
					SFaceLevel_ShowAm[index]:SetTransparent(0)
					SFaceLevel_ShowAm[index]:SetTouchEnabled(0)
				end
			end
		end
	end
	
	SFaceLevel_Button.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if SFaceLevel_BackGround:IsVisible() then
			SFaceLevel_BackGround:SetVisible(0)
			for index,value in pairs(SFaceLevel_ShowAm) do
				SFaceLevel_ShowAm[index]:SetTransparent(0)
				SFaceLevel_ShowAm[index]:SetTouchEnabled(0)
			end
		else
			ReSetCheckButtonState_facesetup()
			SFaceLevel_Button:SetButtonFrame(1)
			SFaceLevel_BackGround:SetVisible(1)
			for index,value in pairs(SFaceLevel_ShowAm) do
				SFaceLevel_ShowAm[index]:SetTransparent(0)
				SFaceLevel_ShowAm[index]:SetTouchEnabled(1)
			end
		end
	end
	
	-- 窗口分辨率
	Sbtn_showAll = wnd:AddTwoButton(path_hero.."herolist1_hero.png", path_hero.."herolist2_hero.png", path_hero.."herolist1_hero.png",820+posx_move,253+posy_move,128,32)
	SFont_showAll = Sbtn_showAll:AddFont(SBTN_showAllFont[1],12,0,3,6,100,15,0xbeb5ee)
	Sbtn_showAll:SetVisible(0)
	
	SshowAll_BK = wnd:AddImage(path_hero.."listBK2_hero.png",820+posx_move,281+posy_move,128,512)
	wnd:SetAddImageRect(SshowAll_BK.id,0,0,128,88,820+posx_move,281+posy_move,128,88)
	SshowAll_BK:SetVisible(0)
	
	for dis = 1,6 do
		SBTN_showAllBK[dis] = wnd:AddImage(path_hero.."listhover_hero.png",820+posx_move,254+dis*29+posy_move,128,32)
		SBTN_showFontDetail[dis] = SshowAll_BK:AddFont(SBTN_showAllFont[dis],12,0,3,dis*29-23,128,32,0xbeb5ee)
		SBTN_showAllBK[dis]:SetTransparent(0)
		SBTN_showAllBK[dis]:SetTouchEnabled(0)
		
		-- 鼠标滑过
		SBTN_showAllBK[dis].script[XE_ONHOVER] = function()
			if SshowAll_BK:IsVisible() == true then
				SBTN_showAllBK[dis]:SetTransparent(1)
			end
		end
		SBTN_showAllBK[dis].script[XE_ONUNHOVER] = function()
			if SshowAll_BK:IsVisible() == true then
				SBTN_showAllBK[dis]:SetTransparent(0)
			end
		end
		SBTN_showAllBK[dis].script[XE_LBUP] = function()
			XSetDisplay_ResolutionCurSelIndex(1, dis-1)
			SFont_showAll:SetFontText(SBTN_showAllFont[dis],0xbeb5ee)
			index_showAll = dis
			
			--onSearchEnter()
			Sbtn_showAll:SetButtonFrame(0)
			SshowAll_BK:SetVisible(0)
			for index,value in pairs(SBTN_showAllBK) do
				SBTN_showAllBK[index]:SetTransparent(0)
				SBTN_showAllBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	Sbtn_showAll.script[XE_LBUP] = function()
		XClickPlaySound(5)
		if SshowAll_BK:IsVisible() then
			SshowAll_BK:SetVisible(0)
			for index,value in pairs(SBTN_showAllBK) do
				SBTN_showAllBK[index]:SetTransparent(0)
				SBTN_showAllBK[index]:SetTouchEnabled(0)
			end
		else
			ReSetCheckButtonState_facesetup()
			Sbtn_showAll:SetButtonFrame(1)
			SshowAll_BK:SetVisible(1)
			for index,value in pairs(SBTN_showAllBK) do
				SBTN_showAllBK[index]:SetTransparent(0)
				SBTN_showAllBK[index]:SetTouchEnabled(1)
			end
		end
	end
end

-- 画面设置
function IsFocusOn_SetupFace()
	if (g_setup_face_ui:IsVisible() == true) then
		
		-- 分辨率下拉选项框
		local flagA = (SshowAll_BK:IsVisible() == true and Sbtn_showAll:IsFocus() == false and SBTN_showAllBK[1]:IsFocus() == false and SBTN_showAllBK[2]:IsFocus() == false
		and SBTN_showAllBK[3]:IsFocus() == false and SBTN_showAllBK[4]:IsFocus() == false and SBTN_showAllBK[5]:IsFocus() == false and SBTN_showAllBK[6]:IsFocus() == false)

		if(flagA == true) then
			Sbtn_showAll:SetButtonFrame(0)
			SshowAll_BK:SetVisible(0)
			for index,value in pairs(SBTN_showAllBK) do
				SBTN_showAllBK[index]:SetTransparent(0)
				SBTN_showAllBK[index]:SetTouchEnabled(0)
			end
		end

		------下拉选项框
		local flagB = (FshowAll_BK:IsVisible() == true and Fbtn_showAll:IsFocus() == false and FBTN_showAllBK:IsFocus() == false)

		if(flagB == true) then
			Fbtn_showAll:SetButtonFrame(0)
			FshowAll_BK:SetVisible(0)
			FBTN_showAllBK:SetTransparent(0)
			FBTN_showAllBK:SetTouchEnabled(0)
		end
		----场景细节
		local flagC = (Scene_BK:IsVisible() == true and btn_Scene:IsFocus() == false and BTN_SceneBK[1]:IsFocus() == false and BTN_SceneBK[2]:IsFocus() == false
		and BTN_SceneBK[3]:IsFocus() == false and BTN_SceneBK[4]:IsFocus() == false and BTN_SceneBK[5]:IsFocus() == false)

		if(flagC == true) then
			btn_Scene:SetButtonFrame(0)
			Scene_BK:SetVisible(0)
			for index,value in pairs(BTN_SceneBK) do
				BTN_SceneBK[index]:SetTransparent(0)
				BTN_SceneBK[index]:SetTouchEnabled(0)
			end
		end
		-----模型细节
		local flagD = (Model_BK:IsVisible() == true and btn_Model:IsFocus() == false and BTN_ModelBK[1]:IsFocus() == false and BTN_ModelBK[2]:IsFocus() == false
		and BTN_ModelBK[3]:IsFocus() == false and BTN_ModelBK[4]:IsFocus() == false and BTN_ModelBK[5]:IsFocus() == false)

		if(flagD == true) then
			btn_Model:SetButtonFrame(0)
			Model_BK:SetVisible(0)
			for index,value in pairs(BTN_ModelBK) do
				BTN_ModelBK[index]:SetTransparent(0)
				BTN_ModelBK[index]:SetTouchEnabled(0)
			end
		end
		----贴图细节
		local flagE = (Shader_BK:IsVisible() == true and btn_Shader:IsFocus() == false and BTN_ShaderBK[1]:IsFocus() == false and BTN_ShaderBK[2]:IsFocus() == false
		and BTN_ShaderBK[3]:IsFocus() == false and BTN_ShaderBK[4]:IsFocus() == false and BTN_ShaderBK[5]:IsFocus() == false)

		if(flagE == true) then
			btn_Shader:SetButtonFrame(0)
			Shader_BK:SetVisible(0)
			for index,value in pairs(BTN_ShaderBK) do
				BTN_ShaderBK[index]:SetTransparent(0)
				BTN_ShaderBK[index]:SetTouchEnabled(0)
			end
		end
		----地图细节
		local flagF = (Map_BK:IsVisible() == true and btn_Map:IsFocus() == false and BTN_MapBK[1]:IsFocus() == false and BTN_MapBK[2]:IsFocus() == false
		and BTN_MapBK[3]:IsFocus() == false and BTN_MapBK[4]:IsFocus() == false and BTN_MapBK[5]:IsFocus() == false)

		if(flagF == true) then
			btn_Map:SetButtonFrame(0)
			Map_BK:SetVisible(0)
			for index,value in pairs(BTN_MapBK) do
				BTN_MapBK[index]:SetTransparent(0)
				BTN_MapBK[index]:SetTouchEnabled(0)
			end
		end
	end
	
	
end


function InitEffect_SetCheckButtonType( c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12, c13, c14, c15)
	check_pattern[1]:SetVisible(c1)
	check_pattern[2]:SetVisible(c2)
	check_pattern[3]:SetVisible(c3)
	check_pattern[4]:SetVisible(c4)
	check_pattern[5]:SetVisible(c5)
	check_pattern[6]:SetVisible(c6)
	check_pattern[7]:SetVisible(c7)
	check_pattern[8]:SetVisible(c8)
	check_pattern[9]:SetVisible(c9)
	check_pattern[10]:SetVisible(c10)
	check_pattern[11]:SetVisible(c11)
	check_pattern[12]:SetVisible(c12)
	check_pattern[13]:SetVisible(c13)
	check_pattern[14]:SetVisible(c14)
	check_pattern[15]:SetVisible(c15)
	
	if (check_pattern[1]:IsVisible()) then
		check_pattern[1]:SetVisible(1)
		check_pattern[2]:SetVisible(0)
		Fbtn_showAll:SetVisible(1)
		Sbtn_showAll:SetVisible(0)
	else
		check_pattern[1]:SetVisible(0)
		check_pattern[2]:SetVisible(1)
		Fbtn_showAll:SetVisible(0)
		Sbtn_showAll:SetVisible(1)
	end
end

function InitEffect_SetCheckBoxList( cMapdetailIndex, cBuilddetailIndex, cPicturedetailIndex, cTerraindetailIndex)
	-- 场景细节
	Font_Scene:SetFontText(BTN_SceneFont[cMapdetailIndex+1],0xbeb5ee)
	btn_Scene:SetButtonFrame(0)
	Scene_BK:SetVisible(0)
	for index,value in pairs(BTN_SceneBK) do
		BTN_SceneBK[index]:SetTransparent(0)
		BTN_SceneBK[index]:SetTouchEnabled(0)
	end
	
	-- 模型细节
	Font_Model:SetFontText(BTN_SceneFont[cBuilddetailIndex+1],0xbeb5ee)
	btn_Model:SetButtonFrame(0)
	Model_BK:SetVisible(0)
	for index,value in pairs(BTN_ModelBK) do
		BTN_ModelBK[index]:SetTransparent(0)
		BTN_ModelBK[index]:SetTouchEnabled(0)
	end
	
	-- 贴图细节
	Font_Shader:SetFontText(BTN_SceneFont[cPicturedetailIndex+1],0xbeb5ee)
	btn_Shader:SetButtonFrame(0)
	Shader_BK:SetVisible(0)
	for index,value in pairs(BTN_ShaderBK) do
		BTN_ShaderBK[index]:SetTransparent(0)
		BTN_ShaderBK[index]:SetTouchEnabled(0)
	end
	
	-- 地形细节
	Font_Map:SetFontText(BTN_SceneFont[cTerraindetailIndex+1],0xbeb5ee)
	btn_Map:SetButtonFrame(0)
	Map_BK:SetVisible(0)
	for index,value in pairs(BTN_MapBK) do
		BTN_MapBK[index]:SetTransparent(0)
		BTN_MapBK[index]:SetTouchEnabled(0)
	end
end

function SetCurSelDisplayResolutionIndex( cIndex)
	-- log("\ncIndex = " .. cIndex)
	SFont_showAll:SetFontText(SBTN_showAllFont[cIndex+1],0xbeb5ee)
	index_showAll = cIndex+1

	Sbtn_showAll:SetButtonFrame(0)
	SshowAll_BK:SetVisible(0)
	for index,value in pairs(SBTN_showAllBK) do
		SBTN_showAllBK[index]:SetTransparent(0)
		SBTN_showAllBK[index]:SetTouchEnabled(0)
	end
end

function InitSCROLLBAREX_Effect( cIndex)
	SFaceLevel_Font:SetFontText(SFaceSet_Font[cIndex+1], 0xbeb5ee)
	
	if cIndex==0 then
		UnEnableClickImage:SetVisible(0)
	else
		UnEnableClickImage:SetVisible(1)
	end
end

-- 通信分辨率的问题
function Clear_Resolution()
	SBTN_showAllFont = {}
	for i,v in pairs(SBTN_showFontDetail) do
		SBTN_showFontDetail[i]:SetVisible(0)
		SBTN_showAllBK[i]:SetVisible(0)
	end
end

function SendResolutionToLua(ResolutionFont)
	local size = 0
	if SBTN_showAllFont == {} then
		size = 1
	else
		size = #SBTN_showAllFont+1
	end
	 
	SBTN_showAllFont[size] = ResolutionFont
	SBTN_showFontDetail[size]:SetFontText(ResolutionFont,0xbeb5ee)
	SBTN_showFontDetail[size]:SetVisible(1)
	SBTN_showAllBK[size]:SetVisible(1)
end

function SetFullScreenResolution(res)
	FFont_showAll:SetFontText(res,0xbeb5ee)
end


function Set_SetupFaceIsVisible(flag) 
	if g_setup_face_ui ~= nil then
		if flag == 1 and g_setup_face_ui:IsVisible() == false then
			ReSetBackGroundUiState()
			g_setup_face_ui:SetVisible(1)
		elseif flag == 0 and g_setup_face_ui:IsVisible() == true then
			g_setup_face_ui:SetVisible(0)
			ReSetBackGroundUiState()
			IsClickChuiZhiTongBu = 0
		end
	end
end

function Get_SetupFaceIsVisible()  
    if(g_setup_face_ui:IsVisible()) then
       -- XGameHeroSkinIsOpen(1)
    else
       -- XGameHeroSkinIsOpen(0)
    end
end

function ReSetBackGroundUiState()
	Scene_BK:SetVisible(0)
	Model_BK:SetVisible(0)
	Shader_BK:SetVisible(0)
	Map_BK:SetVisible(0)
	SFaceLevel_BackGround:SetVisible(0)
	SshowAll_BK:SetVisible(0)
	
	for index,value in pairs(BTN_SceneBK) do
		BTN_SceneBK[index]:SetTransparent(0)
		BTN_SceneBK[index]:SetTouchEnabled(0)
	end
	for index,value in pairs(BTN_ModelBK) do
		BTN_ModelBK[index]:SetTransparent(0)
		BTN_ModelBK[index]:SetTouchEnabled(0)
	end
	for index,value in pairs(BTN_ShaderBK) do
		BTN_ShaderBK[index]:SetTransparent(0)
		BTN_ShaderBK[index]:SetTouchEnabled(0)
	end
	for index,value in pairs(SFaceLevel_ShowAm) do
		SFaceLevel_ShowAm[index]:SetTransparent(0)
		SFaceLevel_ShowAm[index]:SetTouchEnabled(0)
	end
	for index,value in pairs(SBTN_showAllBK) do
		SBTN_showAllBK[index]:SetTransparent(0)
		SBTN_showAllBK[index]:SetTouchEnabled(0)
	end
end

function ReSetCheckButtonState_facesetup()
	Sbtn_showAll:SetButtonFrame(0)
	SshowAll_BK:SetVisible(0)
	for index,value in pairs(SBTN_showAllBK) do
		SBTN_showAllBK[index]:SetTransparent(0)
		SBTN_showAllBK[index]:SetTouchEnabled(0)
	end
	btn_Model:SetButtonFrame(0)
	Model_BK:SetVisible(0)
	for index,value in pairs(BTN_ModelBK) do
		BTN_ModelBK[index]:SetTransparent(0)
		BTN_ModelBK[index]:SetTouchEnabled(0)
	end
	btn_Scene:SetButtonFrame(0)
	Scene_BK:SetVisible(0)
	for index,value in pairs(BTN_SceneBK) do
		BTN_SceneBK[index]:SetTransparent(0)
		BTN_SceneBK[index]:SetTouchEnabled(0)
	end
	btn_Map:SetButtonFrame(0)
	Map_BK:SetVisible(0)
	for index,value in pairs(BTN_MapBK) do
		BTN_MapBK[index]:SetTransparent(0)
		BTN_MapBK[index]:SetTouchEnabled(0)
	end
	btn_Shader:SetButtonFrame(0)
	Shader_BK:SetVisible(0)
	for index,value in pairs(BTN_ShaderBK) do
		BTN_ShaderBK[index]:SetTransparent(0)
		BTN_ShaderBK[index]:SetTouchEnabled(0)
	end
	SFaceLevel_Button:SetButtonFrame(0)
	SFaceLevel_BackGround:SetVisible(0)
	for index,value in pairs(SFaceLevel_ShowAm) do
		SFaceLevel_ShowAm[index]:SetTransparent(0)
		SFaceLevel_ShowAm[index]:SetTouchEnabled(0)
	end 
end