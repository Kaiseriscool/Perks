local PERK = {}
PERK.ID = "armor"
PERK.Name = "Armor"
PERK.Description = "Increase how much armor you can gain."
PERK.Amount = 5
PERK.Icon = ""
PERK.OnBuy = function(ply)
    local amount = Perks:GetPerkAmount(PERK.ID, ply:SteamID())
    if amount == 0 then return end
    ply:SetArmor(ply:Armor()+(amount*40))
    ply:SetMaxArmor(ply:GetMaxArmor()+(amount*40))
end

Perks.Perks[PERK.ID] = PERK

hook.Add("PlayerSpawn", "Perks:PlayerArmor", function(ply)
    timer.Simple(1, function()
    PERK.OnBuy(ply) // fixes some stacking issue's    
    end)
end)
