
local blur = Material("pp/blurscreen")
local function DrawBlurRect(x, y, w, h, amount, density)
    surface.SetDrawColor(color_white)
    surface.SetMaterial(blur)

    for i = 1, density do
		blur:SetFloat("$blur", (i / 3) * (amount or 6))
        blur:Recompute()
        render.UpdateScreenEffectTexture()
        render.SetScissorRect(x, y, x + w, y + h, true)
        surface.DrawTexturedRect(0 * -1, 0 * -1, ScrW(), ScrH())
        render.SetScissorRect(0, 0, 0, 0, false)
    end
end

local function createBoard()
	local ply = LocalPlayer()

	local scrw, scrh = ScrW(), ScrH()

	gfScoreboard = vgui.Create("Panel", nil, "gfScoreboard")
    gfScoreboard:SetPos(0, 0)
    gfScoreboard:SetSize(scrw, scrh)
    gfScoreboard:MakePopup()
    gfScoreboard:SetPopupStayAtBack(true)
    gfScoreboard:ParentToHUD()

    function gfScoreboard:Paint(w,h)
		DrawBlurRect(0, 0, scrw, scrh, 3, 6)
    end

    gfScoreboard.workingArea = vgui.Create("Panel", gfScoreboard, "gfScoreboardWorkArea")
    gfScoreboard.workingArea:SetPos(scrw*0.125, scrh*0.075)
    gfScoreboard.workingArea:SetSize(scrw*0.75, scrh*0.85)
    gfScoreboard.workingArea:MakePopup()

    gfScoreboard.map = vgui.Create("GFBoardMap", gfScoreboard.workingArea, "gfScoreboardMap")
    gfScoreboard.playerlist = vgui.Create("GFBoardPlayers", gfScoreboard.workingArea, "gfScoreboardPlayers")
end

if IsValid(gfScoreboard) then
    gfScoreboard:Remove()
end
gfScoreboard = nil

local function hideDefault()
	GAMEMODE.ScoreboardShow = nil
    GAMEMODE.ScoreboardHide = nil
end
hook.Add("Initialize", "GFBoardHideSBox", hideDefault)
hook.Add("OnReloaded", "GFBoardHideSBox", hideDefault)

hook.Add("ScoreboardShow", "GFBoardShow", function()
    if (gfScoreboard) then
        gfScoreboard.playerlist:RefreshPlayers()
        gfScoreboard:SetVisible(true)
        gfScoreboard:SetAlpha(0)
        gfScoreboard:AlphaTo(255, 0.1)
    else
        createBoard()
    end
end)

hook.Add("ScoreboardHide", "GFBoardHide", function()
    if (gfScoreboard) then
        gfScoreboard:AlphaTo(0, 0.1, 0, function()
            gfScoreboard:SetVisible(false)
        end)
    end
end)