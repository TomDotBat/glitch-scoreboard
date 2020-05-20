
local PANEL = {}

function PANEL:Init()
	self:Dock(TOP)
	self:InvalidateLayout(true)
	self:SetTall(ScrH()*.035)

	self.showAdmin = glitchboard_config.isadmin(LocalPlayer())
end

function PANEL:Paint(w, h)
	if !self.ply or !IsValid(self.ply) then 
		self:Remove()
		return 
	end

	surface.SetAlphaMultiplier(0.6)
	surface.SetDrawColor(team.GetColor(self.ply:Team()))
	surface.DrawRect(0, 0, w, h)
	surface.SetAlphaMultiplier(1)

	surface.SetFont("gfBoardPlyName")
	local x = w*.12
	draw.SimpleText(self.ply:Name(), "gfBoardPlyName", x, h*.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	x = x + surface.GetTextSize(self.ply:Name()) + w*.02

	draw.SimpleText(team.GetName(self.ply:Team()), "gfBoardPlySub", x, h*.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
	
	surface.SetFont("gfBoardPlySub")
	x = w-surface.GetTextSize("Ping: " .. self.ply:Ping() .. "ms")-(w*0.03)
	draw.SimpleText("Ping: " .. self.ply:Ping() .. "ms", "gfBoardPlySub",x, h*.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetFont("gfBoardPlySub")
	x = x-surface.GetTextSize("D: " .. self.ply:Deaths())-(w*0.03)
	draw.SimpleText("D: " .. self.ply:Deaths(), "gfBoardPlySub",x, h*.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

	surface.SetFont("gfBoardPlySub")
	x = x-surface.GetTextSize("K: " .. self.ply:Frags())-(w*0.03)
	draw.SimpleText("K: " .. self.ply:Frags(), "gfBoardPlySub",x, h*.5, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
end

function PANEL:SetPlayer(ply)
	self.ply = ply
	local w,h = self:GetWide(), self:GetTall()

	if self.avatar then self.avatar:Remove() end

	self.avatar = vgui.Create("GFBoardAvatar", self)
	self.avatar:SetPlayer(ply, h)
	self.avatar:SetMaskSize(h*.42)
	self.avatar:SetSize(h, h)
	self.avatar:SetPos(w*0.16, 0)

	if self.button then self.button:Remove() end

	self.button = vgui.Create("DButton", self)
	self.button:Dock(FILL)
	self.button:Center()
	self.button:SetVisible(true)
	self.button:SetText("")

	self.button.alpha = 0

	function self.button:Paint(w, h)
		if self:IsHovered() then
			self.alpha = Lerp(FrameTime() * 10, self.alpha, 50)
		else
			self.alpha = Lerp(FrameTime() * 10, self.alpha, 0)
		end

		surface.SetDrawColor(Color(255, 255, 255, self.alpha))
		surface.DrawRect(0, 0, w, h)
	end

	local isAdmin = self.showAdmin
	function self.button:DoClick()
		if isAdmin then
			local adminmenu = vgui.Create("GFBoardAdminMenu", gfScoreboard)
			adminmenu:SetPlayer(ply)
			adminmenu:Open(nil, nil, nil, self)
		else
			if ply:IsBot() then return end
			gui.OpenURL("https://glitchfire.com/index.php?t=user&id=" .. ply:SteamID64())
		end
	end
end

vgui.Register("GFBoardPlayer", PANEL, "Panel")