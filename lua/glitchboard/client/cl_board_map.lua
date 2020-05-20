
local PANEL = {}

gfGPSTarget = nil

local deltaX, deltaY = 0, 0
local lastX, lastY = 0, 0
hook.Add("HUDPaint", "gfBoardDeltas", function()
	local x, y = input.GetCursorPos()
	deltaX, deltaY = lastX - x, lastY - y
	lastX, lastY = x, y
end)

function PANEL:Init()
	local parent = self:GetParent()

	self:Dock(LEFT)
    self:SetWidth(parent:GetTall())
    self:SetMouseInputEnabled(true)

	self.targetZoom = 1.1
	self.mapZoom = 1.1
	self.offsetX, self.offsetY = 0, 0
	self.targetX, self.targetY = 0, 0

    hook.Add("CreateMove", "gfMapScroller", function(cmd)
    	if vgui.GetHoveredPanel() != self then return end
        if (input.WasMousePressed(MOUSE_WHEEL_UP)) then
			self.targetZoom = self.targetZoom + 0.1
			if self.targetZoom > 4 then self.targetZoom = 4 end
        elseif (input.WasMousePressed(MOUSE_WHEEL_DOWN)) then
			self.targetZoom = self.targetZoom - 0.1
			if self.targetZoom < 1.1 then self.targetZoom = 1.1 end
        end
	end)
end

function PANEL:Think()
	self.areaNum = gfGetAreaNum(LocalPlayer():EyePos())
end

function PANEL:GetMapCenter(w, h)
	return w*.5 + self.offsetX, h*.5 + self.offsetY
end

function PANEL:WorldToMap(pos, w, h)
	local mapScale = (w / 1024)*0.051*self.mapZoom
	local x,y = self:GetMapCenter(w, h)
	x,y = x + pos.x*mapScale, y - pos.y*mapScale

	return x,y
end

function PANEL:MapToWorld(x, y, w, h)
	local mapScale = (w / 1024)*0.051*self.mapZoom
	local rx,ry = self:GetMapCenter(w, h)
	rx,ry = (x - rx)/mapScale, -((y - ry)/mapScale)

	return rx,ry
end

function PANEL:Paint(w, h)
	self.mapZoom = Lerp(FrameTime() * 20, self.mapZoom, self.targetZoom)
	self.offsetX = self.targetX--Lerp(FrameTime() * 10, self.offsetX, self.targetX)
	self.offsetY = self.targetY--Lerp(FrameTime() * 10, self.offsetY, self.targetY)

	self.iconSize = (ScrH() * self.mapZoom) * 0.018

	surface.SetDrawColor(glitchboard_config.backgroundCol)
	surface.DrawRect(0, 0, w, h)

	--Draw Minimap
	surface.SetDrawColor(glitchhhud_config.mapCol)
	surface.SetMaterial(gfMapTextures[self.areaNum])
	surface.DrawTexturedRect(self.offsetX + (w-(w*self.mapZoom))*.5, self.offsetY + (h-(h*self.mapZoom))*.5, w*self.mapZoom, h*self.mapZoom)
	--surface.DrawOutlinedRect(self.offsetX + (w-(w*self.mapZoom))*.5, self.offsetY + (h-(h*self.mapZoom))*.5, w*self.mapZoom, h*self.mapZoom)

	--Draw Local Player
	local ply = LocalPlayer()
	local plyAngs = ply:GetAngles()
	local plyPos = ply:EyePos()
    local plyX, plyY = self:WorldToMap(plyPos, w, h)

    surface.SetDrawColor(color_white)
    surface.SetMaterial(glitchhhud_config.icons["Player"])
    surface.DrawTexturedRectRotated(plyX, plyY, self.iconSize, self.iconSize, plyAngs.y-90)

    --Draw Waypoints
    local waypointSize = self.iconSize * 1.1
    local halfWaypointSize = waypointSize*.5
    for k,v in next, ents.FindByClass("minimap_waypoint_*") do
    	local worldPos = v:GetPos()

    	if gfGetAreaNum(worldPos) != self.areaNum then continue end

    	local mapX, mapY = self:WorldToMap(worldPos, w, h)

        local color = v:GetWaypointColor();
        surface.SetDrawColor(Color(color.x, color.y, color.b, 255));
        surface.SetMaterial(glitchhhud_config.icons[v:GetWaypointMaterial()]);
        surface.DrawTexturedRect(mapX - halfWaypointSize, mapY - halfWaypointSize, waypointSize, waypointSize);
    end


    --Draw GPS Target
    if gfGPSTarget then
    	if gfGPSTarget.z != self.areaNum then return end

    	local mapX, mapY = self:WorldToMap(gfGPSTarget, w, h)
	    surface.SetDrawColor(glitchhhud_config.gpsPointCol)
	    surface.SetMaterial(glitchhhud_config.icons["Pin"])
	    surface.DrawTexturedRect(mapX - halfWaypointSize, mapY - halfWaypointSize, waypointSize, waypointSize)
    end
end

function PANEL:OnCursorMoved(x, y)
	if (input.IsMouseDown(MOUSE_LEFT)) then
		self.targetX, self.targetY = self.targetX - deltaX, self.targetY - deltaY
		if self.targetX > 1000 then self.targetX = 1000 end
		if self.targetX < -1000 then self.targetX = -1000 end

		if self.targetY > 1000 then self.targetY = 1000 end
		if self.targetY < -1000 then self.targetY = -1000 end
	end
end

function PANEL:OnMousePressed(key)
	if key == MOUSE_RIGHT then
		local w,h = self:GetWide(), self:GetTall()
		local x,y = self:CursorPos()
		local rx, ry = self:MapToWorld(x, y, w, h)
		
		local new = Vector(rx, ry)

		if gfGPSTarget then
			local temp = gfGPSTarget
			temp.z = 0
			if gfGPSTarget:DistToSqr(new) < 60000 then
				gfGPSTarget = false
				return
			end
		end

		gfGPSTarget = new
		gfGPSTarget.z = self.areaNum
	end
end

vgui.Register("GFBoardMap", PANEL, "Panel")