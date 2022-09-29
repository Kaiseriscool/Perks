function Perks:GetLevel(steamid)
    local data = sql.Query("SELECT * FROM PerksLevel WHERE steamid = "..sql.SQLStr(steamid)..";")
    return data and tonumber(data[1].level) or 1
end

function Perks:GetXP(steamid)
    local data = sql.Query("SELECT * FROM PerksLevel WHERE steamid = "..sql.SQLStr(steamid)..";")
    return data and tonumber(data[1].xp) or 0
end

function Perks:AddLevel(steamid)
    local data = sql.Query("SELECT * FROM PerksLevel WHERE steamid = "..sql.SQLStr(steamid)..";")
	if data then
        local level = Perks:GetLevel(steamid)+1
		sql.Query("UPDATE PerksLevel SET level = "..level.." WHERE steamid = "..sql.SQLStr(steamid)..";")
    else
		sql.Query("INSERT INTO PerksLevel (steamid, level, xp) VALUES("..sql.SQLStr(steamid)..", 1, 0)")
	end
    Perks:AddPerkPoints(steamid, 1)

    local ply = player.GetBySteamID(steamid)
    if not IsValid(ply) then return end
    ply:SetNWInt("Perks:Level", Perks:GetLevel(steamid))
end

function Perks:AddXP(steamid, amount)
    local data = sql.Query("SELECT * FROM PerksLevel WHERE steamid = "..sql.SQLStr(steamid)..";")
	if data then
        local add = Perks:GetXP(steamid)+amount
        local nextlvlxp = Perks.AddXPLevel*Perks:GetLevel(steamid)
		sql.Query("UPDATE PerksLevel SET xp = "..math.min(nextlvlxp, add).." WHERE steamid = "..sql.SQLStr(steamid)..";")
        if add >= nextlvlxp then
            -- we have flowover
            sql.Query("UPDATE PerksLevel SET xp = 0 WHERE steamid = "..sql.SQLStr(steamid)..";")

            Perks:AddLevel(steamid)
            Perks:AddXP(steamid, add-nextlvlxp)
        end
    else
		sql.Query("INSERT INTO PerksLevel (steamid, level, xp) VALUES("..sql.SQLStr(steamid)..", 1, "..amount..")")
        local add = Perks:GetXP(steamid)+amount
        local nextlvlxp = Perks.AddXPLevel*Perks:GetLevel(steamid)
        if addxp >= nextlvlxp then
            -- we have flowover
            Perks:AddLevel(steamid)
            Perks:AddXP(steamid, addxp-nextlvlxp)
        end
	end

    local ply = player.GetBySteamID(steamid)
    if not IsValid(ply) then return end
    ply:SetNWInt("Perks:XP", Perks:GetXP(steamid))
end

timer.Create("Perks:GiveXP" , 300 , 0 , function()
    for k , v in pairs(player.GetAll()) do 
    Perks:AddXP(v:SteamID(), Perks.RandomXP) 
    DarkRP.notify(v, 1, 3, "You have gotten "..Perks.RandomXP.." XP for playing the server.")
    end
end)

hook.Add("PlayerDeath" , "Perks:GiveXPDeath" , function(dead , _ , att)
    Perks:AddXP(att:SteamID(), Perks.PerKillXP) 
    DarkRP.notify(att, 1, 3, "You have gotten "..Perks.PerKillXP.." XP for killing "..dead:Nick().."")
end)