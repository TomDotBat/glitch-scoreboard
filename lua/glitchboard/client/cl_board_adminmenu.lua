
local PANEL = {}

function PANEL:Init()
	self:AddOption("Open Profile", function()
		if self.ply:IsBot() then return end
		gui.OpenURL("http://steamcommunity.com/profiles/" .. self.ply:SteamID64())
	end):SetIcon("icon16/application_link.png")

	self:AddOption("Copy Name", function()
		SetClipboardText(self.plyname)
	end):SetIcon("icon16/page_copy.png")
	
	self:AddOption("Copy SteamID", function()
		SetClipboardText(self.ply:SteamID())
	end):SetIcon("icon16/page_copy.png")
	
	self:AddOption("Copy SteamID64", function()
		SetClipboardText(self.ply:SteamID64())
	end):SetIcon("icon16/page_copy.png")


	self:AddSpacer()


	self:AddOption("Go To", function()
		RunConsoleCommand("ulx", "goto", self.plyname)
	end):SetIcon("icon16/arrow_right.png")
	
	self:AddOption("Bring", function()
		RunConsoleCommand("ulx", "bring", self.plyname)
	end):SetIcon("icon16/arrow_left.png")
	
	self:AddOption("Return", function()
		RunConsoleCommand("ulx", "return", self.plyname)
	end):SetIcon("icon16/arrow_redo.png")
	
	self:AddOption("Spectate", function()
		RunConsoleCommand("ulx", "spectate", self.plyname)
	end):SetIcon("icon16/magnifier.png")


	self:AddSpacer()


	self:AddOption("Freeze", function()
		RunConsoleCommand("ulx", "freeze", self.plyname)
	end):SetIcon("icon16/control_pause_blue.png")

	self:AddOption("Unfreeze", function()
		RunConsoleCommand("ulx", "unfreeze", self.plyname)
	end):SetIcon("icon16/control_pause.png")
	
	self:AddOption("Jail", function()
		RunConsoleCommand("ulx", "jail", self.plyname)
	end):SetIcon("icon16/lock.png")

	self:AddOption("Unjail", function()
		RunConsoleCommand("ulx", "unjail", self.plyname)
	end):SetIcon("icon16/lock_open.png")
	
	self:AddSpacer() 

	self:AddOption("Warn", function()
		Derma_StringRequest(
			"Warn Player",
			"Enter a warn reason",
			"Verbally abusing other players",
			function(reason)

			end, 
			function(reason) end,
			"Warn"
		)
	end):SetIcon("icon16/exclamation.png")
	
	self:AddOption("Kick", function()
		Derma_StringRequest(
			"Kick Player",
			"Enter a reason for kicking the player",
			"Chat Spam",
			function(reason)
				RunConsoleCommand("ulx", "kick", self:GetPlayerName(), reason)
			end, 
			function(reason) end,
			"Kick"
		)
	end):SetIcon("icon16/door_in.png")
	
	self:AddOption("Ban", function()
		Derma_StringRequest(
			"Ban Player",
			"Enter a ban length",
			"1m 2d 3h",
			function(length)
				Derma_StringRequest(
					"Ban Player",
					"Enter a reason for banning the player",
					"Mass RDM",
					function(reason)
						RunConsoleCommand("ulx", "ban", self:GetPlayerName(), length, reason)
					end, 
					function(reason) end,
					"Ban"
				)
			end, 
			function(length) end,
			"Continue"
		)
	end):SetIcon("icon16/cancel.png")
end

function PANEL:SetPlayer(ply)
	self.ply = ply
	self.plyname = ply:Name()
end

function PANEL:GetPlayerName()
	return self.plyname
end

vgui.Register("GFBoardAdminMenu", PANEL, "DMenu")