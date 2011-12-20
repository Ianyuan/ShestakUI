﻿local T, C, L = unpack(select(2, ...))
if C.chat.enable ~= true then return end

----------------------------------------------------------------------------------------
--	Style chat frame(by Tukz)
----------------------------------------------------------------------------------------
local UIChat = CreateFrame("Frame")
local _G = _G
local origs = {}
local type = type

-- Function to rename channel and other stuff
local AddMessage = function(self, text, ...)
	if type(text) == "string" then
		local _, size = self:GetFont()
		size = math.floor(size + 5)
		text = text:gsub("|h%[(%d+)%. .-%]|h", "|h[%1]|h")
		text = text:gsub("(|T[^:]+:)(%d+:*%d*)", ("%%1%d:%1$d"):format(size))
	end
	return origs[self](self, text, ...)
end

-- Global strings
_G.CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h["..L_CHAT_BATTLEGROUND.."]|h %s:\32"
_G.CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h["..L_CHAT_BATTLEGROUND_LEADER.."]|h %s:\32"
_G.CHAT_BN_WHISPER_GET = L_CHAT_BN_WHISPER.." %s:\32"
_G.CHAT_GUILD_GET = "|Hchannel:Guild|h["..L_CHAT_GUILD.."]|h %s:\32"
_G.CHAT_OFFICER_GET = "|Hchannel:o|h["..L_CHAT_OFFICER.."]|h %s:\32"
_G.CHAT_PARTY_GET = "|Hchannel:Party|h["..L_CHAT_PARTY.."]|h %s:\32"
_G.CHAT_PARTY_LEADER_GET = "|Hchannel:party|h["..L_CHAT_PARTY_LEADER.."]|h %s:\32"
_G.CHAT_PARTY_GUIDE_GET = CHAT_PARTY_LEADER_GET
_G.CHAT_RAID_GET = "|Hchannel:raid|h["..L_CHAT_RAID.."]|h %s:\32"
_G.CHAT_RAID_LEADER_GET = "|Hchannel:raid|h["..L_CHAT_RAID_LEADER.."]|h %s:\32"
_G.CHAT_RAID_WARNING_GET = "["..L_CHAT_RAID_WARNING.."] %s:\32"
_G.CHAT_SAY_GET = "%s:\32"
_G.CHAT_WHISPER_GET = L_CHAT_WHISPER.." %s:\32"
_G.CHAT_YELL_GET = "%s:\32"
_G.CHAT_FLAG_AFK = "|cffFF0000"..L_CHAT_AFK.."|r "
_G.CHAT_FLAG_DND = "|cffE7E716"..L_CHAT_DND.."|r "
_G.CHAT_FLAG_GM = "|cff4154F5"..L_CHAT_GM.."|r "
_G.ERR_FRIEND_ONLINE_SS = "|Hplayer:%s|h[%s]|h "..L_CHAT_COME_ONLINE_COLOR
_G.ERR_FRIEND_OFFLINE_S = "%s "..L_CHAT_GONE_OFFLINE_COLOR
_G.ACHIEVEMENT_BROADCAST = "%s! %s!"
_G.ACHIEVEMENT_BROADCAST_SELF = "%s!"
_G.PLAYER_SERVER_FIRST_ACHIEVEMENT = "|Hplayer:%s|h[%s]|h! $a!"
_G.SERVER_FIRST_ACHIEVEMENT = "%s! $a!"
if T.client == "ruRU" then
	_G.FACTION_STANDING_DECREASED = "Отношение |3-7(%s) -%d."
	_G.FACTION_STANDING_INCREASED = "Отношение |3-7(%s) +%d."
end

-- Hide friends micro button
FriendsMicroButton:Kill()

-- Hide chat bubble menu button
ChatFrameMenuButton:Kill()

-- Set chat style
local function SetChatStyle(frame)
	local id = frame:GetID()
	local chat = frame:GetName()

	-- Removes crap from the bottom of the chatbox so it can go to the bottom of the screen
	_G[chat]:SetClampedToScreen(false)

	-- Stop the chat chat from fading out
	_G[chat]:SetFading(false)

	-- Move the chat edit box
	_G[chat.."EditBox"]:ClearAllPoints()
	_G[chat.."EditBox"]:Point("BOTTOMLEFT", ChatFrame1, "TOPLEFT", -10, 23)
	_G[chat.."EditBox"]:Point("BOTTOMRIGHT", ChatFrame1, "TOPRIGHT", 11, 23)

	-- Hide textures
	for j = 1, #CHAT_FRAME_TEXTURES do
		_G[chat..CHAT_FRAME_TEXTURES[j]]:SetTexture(nil)
	end

	-- Removes Default ChatFrame Tabs texture
	_G[format("ChatFrame%sTabLeft", id)]:Kill()
	_G[format("ChatFrame%sTabMiddle", id)]:Kill()
	_G[format("ChatFrame%sTabRight", id)]:Kill()

	_G[format("ChatFrame%sTabSelectedLeft", id)]:Kill()
	_G[format("ChatFrame%sTabSelectedMiddle", id)]:Kill()
	_G[format("ChatFrame%sTabSelectedRight", id)]:Kill()

	_G[format("ChatFrame%sTabHighlightLeft", id)]:Kill()
	_G[format("ChatFrame%sTabHighlightMiddle", id)]:Kill()
	_G[format("ChatFrame%sTabHighlightRight", id)]:Kill()

	-- Killing off the new chat tab selected feature
	_G[format("ChatFrame%sTabSelectedLeft", id)]:Kill()
	_G[format("ChatFrame%sTabSelectedMiddle", id)]:Kill()
	_G[format("ChatFrame%sTabSelectedRight", id)]:Kill()

	-- Kills off the new method of handling the Chat Frame scroll buttons as well as the resize button
	-- Note: This also needs to include the actual frame textures for the ButtonFrame onHover
	_G[format("ChatFrame%sButtonFrameUpButton", id)]:Kill()
	_G[format("ChatFrame%sButtonFrameDownButton", id)]:Kill()
	_G[format("ChatFrame%sButtonFrameBottomButton", id)]:Kill()
	_G[format("ChatFrame%sButtonFrameMinimizeButton", id)]:Kill()
	_G[format("ChatFrame%sButtonFrame", id)]:Kill()

	-- Kills off the retarded new circle around the editbox
	_G[format("ChatFrame%sEditBoxFocusLeft", id)]:Kill()
	_G[format("ChatFrame%sEditBoxFocusMid", id)]:Kill()
	_G[format("ChatFrame%sEditBoxFocusRight", id)]:Kill()

	_G[format("ChatFrame%sTabGlow", id)]:Kill()
	
	-- Kill off editbox artwork
	local a, b, c = select(6, _G[chat.."EditBox"]:GetRegions()) a:Kill() b:Kill() c:Kill()

	-- Disable alt key usage
	_G[chat.."EditBox"]:SetAltArrowKeyMode(false)

	-- Hide editbox on login
	_G[chat.."EditBox"]:Hide()

	-- Script to hide editbox instead of fading editbox to 0.35 alpha via IM Style
	_G[chat.."EditBox"]:HookScript("OnEditFocusGained", function(self) self:Show() end)
	_G[chat.."EditBox"]:HookScript("OnEditFocusLost", function(self) self:Hide() end)

	-- Hide edit box every time we click on a tab
	_G[chat.."Tab"]:HookScript("OnClick", function() _G[chat.."EditBox"]:Hide() end)

	-- Create our own texture for edit box
	if C.chat.background == true then
		local EditBoxBackground = CreateFrame("Frame", "ChatEditBoxBackground", _G[chat.."EditBox"])
		EditBoxBackground:CreatePanel("Transparent", 1, 1, "LEFT", _G[chat.."EditBox"], "LEFT", 0, 0)
		EditBoxBackground:ClearAllPoints()
		EditBoxBackground:Point("TOPLEFT", _G[chat.."EditBox"], "TOPLEFT", 7, -5)
		EditBoxBackground:Point("BOTTOMRIGHT", _G[chat.."EditBox"], "BOTTOMRIGHT", -7, 5)
		EditBoxBackground:SetFrameStrata("LOW")
		EditBoxBackground:SetFrameLevel(1)

		local function colorize(r, g, b)
			EditBoxBackground:SetBackdropBorderColor(r, g, b)
		end

		-- Update border color according where we talk
		hooksecurefunc("ChatEdit_UpdateHeader", function()
			local type = _G[chat.."EditBox"]:GetAttribute("chatType")
			if type == "CHANNEL" then
				local id = GetChannelName(_G[chat.."EditBox"]:GetAttribute("channelTarget"))
				if id == 0 then
					colorize(unpack(C.media.border_color))
				else
					colorize(ChatTypeInfo[type..id].r, ChatTypeInfo[type..id].g, ChatTypeInfo[type..id].b)
				end
			else
				colorize(ChatTypeInfo[type].r, ChatTypeInfo[type].g, ChatTypeInfo[type].b)
			end
		end)
	end

	-- Rename combat log tab
	if _G[chat] == _G["ChatFrame2"] then
		FCF_SetWindowName(_G[chat], GUILD_BANK_LOG)
		CombatLogQuickButtonFrame_Custom:StripTextures()
		CombatLogQuickButtonFrame_Custom:CreateBackdrop("Transparent")
		CombatLogQuickButtonFrame_Custom.backdrop:Point("TOPLEFT", 1, -2)
		CombatLogQuickButtonFrame_Custom.backdrop:Point("BOTTOMRIGHT", 0, -4)
		T.SkinCloseButton(CombatLogQuickButtonFrame_CustomAdditionalFilterButton, CombatLogQuickButtonFrame_Custom.backdrop, "+")
		CombatLogQuickButtonFrame_CustomProgressBar:ClearAllPoints()
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("TOPLEFT", CombatLogQuickButtonFrame_Custom.backdrop, 2, -2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetPoint("BOTTOMRIGHT", CombatLogQuickButtonFrame_Custom.backdrop, -2, 2)
		CombatLogQuickButtonFrame_CustomProgressBar:SetStatusBarTexture(C.media.texture)
	end

	if _G[chat] ~= _G["ChatFrame2"] then
		origs[_G[chat]] = _G[chat].AddMessage
		_G[chat].AddMessage = AddMessage
		-- Custom timestamps color
		_G.TIMESTAMP_FORMAT_HHMM = T.RGBToHex(unpack(C.chat.time_color)).."[%I:%M]|r "
		_G.TIMESTAMP_FORMAT_HHMMSS = T.RGBToHex(unpack(C.chat.time_color)).."[%I:%M:%S]|r "
		_G.TIMESTAMP_FORMAT_HHMMSS_24HR = T.RGBToHex(unpack(C.chat.time_color)).."[%H:%M:%S]|r "
		_G.TIMESTAMP_FORMAT_HHMMSS_AMPM = T.RGBToHex(unpack(C.chat.time_color)).."[%I:%M:%S %p]|r "
		_G.TIMESTAMP_FORMAT_HHMM_24HR = T.RGBToHex(unpack(C.chat.time_color)).."[%H:%M]|r "
		_G.TIMESTAMP_FORMAT_HHMM_AMPM = T.RGBToHex(unpack(C.chat.time_color)).."[%I:%M %p]|r "
	end

	frame.skinned = true
end

-- Setup chatframes 1 to 10 on login
local function SetupChat(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local frame = _G[format("ChatFrame%s", i)]
		SetChatStyle(frame)
	end

	-- Remember last channel
	local var
	if C.chat.sticky == true then
		var = 1
	else
		var = 0
	end
	ChatTypeInfo.SAY.sticky = var
	ChatTypeInfo.PARTY.sticky = var
	ChatTypeInfo.GUILD.sticky = var
	ChatTypeInfo.OFFICER.sticky = var
	ChatTypeInfo.RAID.sticky = var
	ChatTypeInfo.RAID_WARNING.sticky = var
	ChatTypeInfo.BATTLEGROUND.sticky = var
	ChatTypeInfo.WHISPER.sticky = var
	ChatTypeInfo.BN_WHISPER.sticky = var
	ChatTypeInfo.CHANNEL.sticky = var
end

local function SetupChatPosAndFont(self)
	for i = 1, NUM_CHAT_WINDOWS do
		local chat = _G[format("ChatFrame%s", i)]
		local id = chat:GetID()
		local _, fontSize = FCF_GetChatWindowInfo(id)

		-- Min. size for chat font
		if fontSize < 11 then
			FCF_SetChatWindowFontSize(nil, chat, 11)
		else
			FCF_SetChatWindowFontSize(nil, chat, fontSize)
		end

		-- Font and font style for chat
		chat:SetFont(C.font.chat_font, fontSize, C.font.chat_font_style)
		chat:SetShadowOffset(C.font.chat_font_shadow and 1 or 0, C.font.chat_font_shadow and -1 or 0)

		-- Force chat position
		if i == 1 then
			chat:ClearAllPoints()
			chat:Size(C.chat.width, C.chat.height)
			if C.chat.background == true then
				chat:Point(C.position.chat[1], C.position.chat[2], C.position.chat[3], C.position.chat[4], C.position.chat[5] + 4)
			else
				chat:Point(C.position.chat[1], C.position.chat[2], C.position.chat[3], C.position.chat[4], C.position.chat[5])
			end
			FCF_SavePositionAndDimensions(chat)
		elseif i == 2 then
			if C.chat.combatlog == true then
				FCF_DockFrame(ChatFrame2)
			else
				FCF_UnDockFrame(ChatFrame2)
				chat:ClearAllPoints()
				chat:Point("TOPRIGHT", UIParent, "BOTTOMLEFT", -200, -200)
			end
		end
	end

	-- Reposition battle.net popup over chat #1
	BNToastFrame:HookScript("OnShow", function(self)
		self:ClearAllPoints()
		self:Point(unpack(C.position.bn_popup))
	end)
end

UIChat:RegisterEvent("ADDON_LOADED")
UIChat:RegisterEvent("PLAYER_ENTERING_WORLD")
UIChat:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" then
		if addon == "Blizzard_CombatLog" then
			self:UnregisterEvent("ADDON_LOADED")
			SetupChat(self)
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		SetupChatPosAndFont(self)
	end
end)

-- Setup temp chat (BN, WHISPER) when needed
local function SetupTempChat()
	local frame = FCF_GetCurrentChatFrame()
	if frame.skinned then return end
	SetChatStyle(frame)
end
hooksecurefunc("FCF_OpenTemporaryWindow", SetupTempChat)