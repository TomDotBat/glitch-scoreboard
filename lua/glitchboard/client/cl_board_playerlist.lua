
local PANEL = {}

function PANEL:Init()
	local parent = self:GetParent()

	self:Dock(RIGHT)
	self:InvalidateLayout(true)
	self:SetWidth(parent:GetWide()*0.33)

	local header = vgui.Create("Panel", self, "gfScoreboardTitle")
    header:Dock(TOP)
	header:SetTall(ScrH()*0.075)

    function header:Paint(w, h)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(glitchboard_config.servername, "gfBoardServerTitle", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end

	self.playerScroller = vgui.Create( "DScrollPanel", self )
	self.playerScroller:Dock( FILL )

	self.players = {}
	for k,v in ipairs(player.GetAll()) do
		self.players[k] = self.playerScroller:Add("GFBoardPlayer")
		self.players[k]:SetPlayer(v)
	end

	local vbar = self.playerScroller:GetVBar()
	vbar:SetHideButtons(true)

	function vbar:Paint( w, h ) end

	function vbar.btnGrip:Paint( w, h )
		surface.SetDrawColor(glitchboard_config.backgroundCol)
		surface.DrawRect(0, 0, w, h)
	end

	local footer = vgui.Create("Panel", self, "gfScoreboardTitle")
    footer:Dock(BOTTOM)
	footer:SetTall(ScrH()*0.075)

    footer.players = "0/0"
    footer.tickrate = "0"

    function footer:Think()
    	self.players = tostring(player.GetCount()) .. "/" .. tostring(game.MaxPlayers())
    	self.tickrate = tostring(math.Round(1 / engine.TickInterval()))
    end

    function footer:Paint(w, h)
		surface.SetDrawColor(color_black)
		surface.DrawRect(0, 0, w, h)

		draw.SimpleText(self.players .. " players online · " .. glitchboard_config.serveraddress .. " · " .. self.tickrate .. "tps", "gfBoardFooter", w*.5, h*.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(glitchboard_config.backgroundCol)
	surface.DrawRect(0, 0, w, h)
end


function PANEL:RefreshPlayers()
	for k,v in ipairs(self.players) do
		v:Remove()
	end

	self.players = {}
	for k,v in ipairs(player.GetAll()) do
		self.players[k] = self.playerScroller:Add("GFBoardPlayer")
		self.players[k]:SetPlayer(v)
	end
end

vgui.Register("GFBoardPlayers", PANEL, "Panel")