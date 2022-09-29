local PERK = {}
PERK.ID = "jump"
PERK.Name = "Jump"
PERK.Description = "Increases jump height."
PERK.Amount = 5
PERK.Icon = "Rqlc59F"
PERK.OnBuy = function(ply)
    local amount = Perks:GetPerkAmount(PERK.ID, ply:SteamID())
    if amount == 0 then return end
    ply:SetJumpPower(ply:GetJumpPower()+(amount*25))
end

Perks.Perks[PERK.ID] = PERK

hook.Add("PlayerSpawn", "Perks:PlayerJump", function(ply)
    timer.Simple(1, function(arguments)
        PERK.OnBuy(ply) // fixes some stacking issue's    
    end)
end)