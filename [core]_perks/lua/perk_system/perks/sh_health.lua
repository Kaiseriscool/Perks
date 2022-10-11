local PERK = {}
PERK.ID = "health"
PERK.Name = "Healthy"
PERK.Description = " Increase overall health."
PERK.Amount = 5
PERK.Icon = ""
PERK.OnBuy = function(ply)
    local amount = Perks:GetPerkAmount(PERK.ID, ply:SteamID())
    if amount == 0 then return end
    ply:SetHealth(ply:Health()+(amount*20))
    ply:SetMaxHealth(ply:GetMaxHealth()+(amount*20))
end

Perks.Perks[PERK.ID] = PERK

hook.Add("PlayerSpawn", "Perks:PlayerHealth", function(ply)
    timer.Simple(1, function()
        PERK.OnBuy(ply) // fixes some stacking issue's    
    end)
end)
