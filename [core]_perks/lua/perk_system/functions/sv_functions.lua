util.AddNetworkString("Perks:PurchasePerk")
net.Receive("Perks:PurchasePerk", function(len, ply)
    local id = net.ReadString()
    if Perks:GetPerkAmount(id, ply:SteamID()) >= Perks.Perks[id].Amount then DarkRP.notify(ply, 1, 3, "Already maxed") return end
    if Perks:GetPerkPoints(ply:SteamID()) < 1 then DarkRP.notify(ply, 1, 3, "You cannot afford this") return end
    Perks:AddPerk(id, ply:SteamID())
    Perks:AddPerkPoints(ply:SteamID(), -1)
    DarkRP.notify(ply, 1, 3, "Successfully purchased!")
    Perks.Perks[id].OnBuy(ply)
end)

util.AddNetworkString("Perks:NetworkPerks")
hook.Add("PlayerInitialSpawn", "Perks:PlayerJoined", function(ply)
    local data = sql.Query("SELECT * FROM Perks WHERE steamid = "..sql.SQLStr(ply:SteamID())..";")
    net.Start("Perks:NetworkPerks")
    net.WriteUInt(Perks:GetPerkPoints(ply:SteamID()), 32)
    net.WriteBool(data and true or false)
    if data then
        net.WriteUInt(#data, 32)
        for k, v in ipairs(data) do
            net.WriteString(v.id)
            net.WriteUInt(v.amount, 32)
        end
        net.Send(ply)
    end

    ply:SetNWInt("Perks:XP", Perks:GetXP(ply:SteamID()))
    ply:SetNWInt("Perks:Level", Perks:GetLevel(ply:SteamID()))
end)

hook.Add("PlayerButtonDown" , "Perks:OpenUI" , function(p , but )

    if not ( IsFirstTimePredicted() ) then return end
    if but == KEY_F8 then
    p:RunConsoleCommand("perk_open")
   -- Perks:OpenMenu()
    print("Meth.Sol")
    end

end)