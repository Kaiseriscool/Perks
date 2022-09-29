local PERK = {}
PERK.ID = "speed"
PERK.Name = "Run Speed"
PERK.Description = "Increase how fast you run"
PERK.Amount = 5
PERK.Icon = ""
PERK.OnBuy = function(ply)
    local amount = Perks:GetPerkAmount(PERK.ID, ply:SteamID())
    if amount == 0 then return end
    ply:SetRunSpeed( ply:GetRunSpeed() + (amount * 50) )
end

Perks.Perks[PERK.ID] = PERK

hook.Add("PlayerSpawn", "Perks:PlayerSpeed", function(ply)
    timer.Simple(1, function(arguments)
        PERK.OnBuy(ply) // fixes some stacking issue's    
    end)
end)