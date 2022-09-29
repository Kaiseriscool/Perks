Perks.PerkPoints = Perks.PerkPoints or 0
Perks.PlayerPerks = Perks.PlayerPerks or {}
net.Receive("Perks:NetworkPerks", function()
    Perks.PerkPoints = net.ReadUInt(32)
    local bool = net.ReadBool()
    if bool then
        local int = net.ReadUInt(32)
        for i = 1, int do
            Perks.PlayerPerks[net.ReadString()] = net.ReadUInt(32)
        end
    end
end)

net.Receive("Perks:NetworkChange", function()
    local id, amount = net.ReadString(), net.ReadUInt(32)
    Perks.PlayerPerks[id] = amount
end)

net.Receive("Perks:PerkPointsChange", function()
    Perks.PerkPoints = net.ReadUInt(32)
end)

function Perks:OpenMenu()
    if IsValid(Perks.Menu) then Perks.Menu:Remove() end
    Perks.Menu = vgui.Create("PIXEL.Frame")
    Perks.Menu:SetTitle("Perk Points: "..LocalPlayer():GetNWInt("Perks:PerkPoints"))
    Perks.Menu:MakePopup()
	Perks.Menu:SetSize(800, 500)
    Perks.Menu:Center()
    Perks.Menu.Think = function(s)
        s:SetTitle("Perk Points: "..Perks.PerkPoints)
    end

    local panel = Perks.Menu:Add("Perks:PerkMenu")
    panel:Dock(FILL)
end

function Perks:GetXP()
    return LocalPlayer():GetNWInt("Perks:XP") or 0
end

function Perks:NextLevelXP()
    return Perks:GetLevel()*Perks.AddXPLevel
end

function Perks:GetLevel()
    return LocalPlayer():GetNWInt("Perks:Level") == 0 and 1 or LocalPlayer():GetNWInt("Perks:Level")
end

concommand.Add("perk_open", function()
    Perks:OpenMenu()
end)

concommand.Add("perks_ui_showbar", function(p , _ , args)
	if p != LocalPlayer() then return end
	--LocalPlayer():GetNWBool("ShouldShowBar" , true)
	if p:GetNWBool("ShouldShowBar") == false then
		p:SetNWBool("ShouldShowBar" , true)
		print(p:GetNWBool("ShouldShowBar"))
    elseif p:GetNWBool("ShouldShowBar") == true then
		p:SetNWBool("ShouldShowBar" , false)
		print(p:GetNWBool("ShouldShowBar"))
	end

end)


hook.Add("HUDPaint", "Perks:PerkBar", function()
    if LocalPlayer():GetNWBool("ShouldShowBar",true) then
    local w, h = ScrW(), ScrH()
    local w2, h2 = ScrW() * .75, 20
    local x, y = (w/2)-(w2/2), 20

    local percentage = (Perks:GetXP()/Perks:NextLevelXP())*100
    percentage = math.Round(percentage)
    draw.SimpleTextOutlined(Perks:GetXP().."XP / "..Perks:NextLevelXP().."XP [ "..(percentage).."% ]", PIXEL.GetRealFont("Perks:20"), w/2, 10, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)

    surface.SetDrawColor(PIXEL.Colors.Background)
    surface.DrawRect(x, y, w2, h2)

    local neww = w2-8
    neww = (neww/Perks:NextLevelXP())*Perks:GetXP()
    surface.SetDrawColor(PIXEL.Colors.Primary)
    surface.DrawRect(x+4, y+4, neww, h2-8)

    draw.SimpleTextOutlined(Perks:GetLevel(), PIXEL.GetRealFont("Perks:20"), x-5, y+(h2/2), color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER, 1, color_black)
    draw.SimpleTextOutlined(Perks:GetLevel()+1, PIXEL.GetRealFont("Perks:20"), x+w2+5, y+(h2/2), color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black)
  end
end)