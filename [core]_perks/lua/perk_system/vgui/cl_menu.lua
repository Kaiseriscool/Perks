PIXEL.RegisterFont("Perks:20", "Open Sans SemiBold", 20)
PIXEL.RegisterFont("Perks:15", "Open Sans SemiBold", 15)

local PANEL = {}
function PANEL:Init()
    self.ScrollPanel = self:Add("PIXEL.ScrollPanel")
    self.ScrollPanel:Dock(FILL)
    self.ScrollPanel.VBar:SetWide(0)

    for k, v in pairs(Perks.Perks) do
        local panel = self.ScrollPanel:Add("DPanel")
        panel:Dock(TOP)
        panel:DockMargin(0, 0, 0, 5)
        panel:SetTall(80)
        panel.Paint = function(s, w, h)
            draw.RoundedBox(5, 0, 0, w, h, PIXEL.Colors.Header)
        end
        panel.PerformLayout = function(s, w, h)
            panel.Icon:SetWide(h)
        end

        panel.Icon = panel:Add("DPanel")
        panel.Icon:Dock(LEFT)
        panel.Icon.Paint = function(s, w, h)
            PIXEL.DrawImgur(0, 0, w, h, v.Icon, color_white)
        end

        local name = panel:Add("PIXEL.Label")
        name:Dock(TOP)
        name:DockMargin(5, 0, 0, 0)
        name:SetText(v.Name)
        name:SetFont("Perks:20")
        name:SizeToContents()

        local description = panel:Add("PIXEL.Label")
        description:Dock(TOP)
        description:DockMargin(5, 0, 0, 0)
        description:SetText(v.Description)
        description:SetFont("Perks:15")
        description:SizeToContents()

        local levels = panel:Add("PIXEL.Button")
        levels:Dock(FILL)
        levels:DockMargin(5, 0, 5, 5)
        levels.Paint = function(s, w, h)
            local font, playeramount = "Perks:20", Perks.PlayerPerks[v.ID] and tonumber(Perks.PlayerPerks[v.ID]) or 0
            if playeramount >= v.Amount then
                PIXEL.DrawRoundedBox(14, 0, 0, w, h, PIXEL.Colors.Primary)
                PIXEL.DrawSimpleText("MAXED", font, w/2, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
            else
                PIXEL.DrawSimpleText(playeramount, font, 5, h/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
                PIXEL.DrawSimpleText(v.Amount, font, w-5, h/2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

                surface.SetFont(PIXEL.GetRealFont(font))
                local w1, h1 = surface.GetTextSize(playeramount)
                local w2, h2 = surface.GetTextSize(v.Amount)

                w = w-w1-w2-20
                PIXEL.DrawRoundedBox(14, w1+8, 0, w, h, PIXEL.Colors.Scroller)
                PIXEL.DrawRoundedBox(14, w1+8, 0, (w/v.Amount)*playeramount, h, PIXEL.Colors.Primary)
            end
        end
        levels.DoClick = function(s)
            net.Start("Perks:PurchasePerk")
            net.WriteString(v.ID)
            net.SendToServer()
        end
    end
end
vgui.Register("Perks:PerkMenu", PANEL, "EditablePanel")
