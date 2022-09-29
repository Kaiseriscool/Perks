function Perks:CreateDatabase()
    sql.Query("CREATE TABLE IF NOT EXISTS Perks (id TEXT, steamid TEXT, amount INTEGER)")
    sql.Query("CREATE TABLE IF NOT EXISTS LPerkPoints (steamid TEXT, amount INTEGER)")
    sql.Query("CREATE TABLE IF NOT EXISTS PerksLevel (steamid TEXT, level INTEGER, xp INTEGER)")
end
Perks:CreateDatabase()

function Perks:GetPerkAmount(id, steamid)
    local data = sql.Query("SELECT * FROM Perks WHERE steamid = "..sql.SQLStr(steamid).." AND id = "..sql.SQLStr(id)..";")
    return data and tonumber(data[1].amount) or 0
end

util.AddNetworkString("Perks:NetworkChange")
function Perks:AddPerk(id, steamid)
    local data = sql.Query("SELECT * FROM Perks WHERE steamid = "..sql.SQLStr(steamid).." AND id = "..sql.SQLStr(id)..";")
	if data then
		sql.Query("UPDATE Perks SET amount = "..(math.min(Perks:GetPerkAmount(id, steamid)+1, Perks.Perks[id].Amount)).." WHERE steamid = "..sql.SQLStr(steamid).." AND id = "..sql.SQLStr(id)..";")
	else
		sql.Query("INSERT INTO Perks (id, steamid, amount) VALUES("..sql.SQLStr(id)..", "..sql.SQLStr(steamid)..", 1)")
	end

    local ply = player.GetBySteamID(steamid)
    if not IsValid(ply) then return end

    net.Start("Perks:NetworkChange")
    net.WriteString(id)
    net.WriteUInt(Perks:GetPerkAmount(id, steamid), 32)
    net.Send(ply)
end

function Perks:RemovePerk(id, steamid)
    local data = sql.Query("SELECT * FROM Perks WHERE steamid = "..sql.SQLStr(steamid).." AND id = "..sql.SQLStr(id)..";")
	if not data then return end
	sql.Query("UPDATE Perks SET amount = "..(math.max(Perks:GetPerkAmount(id, steamid)-1, 0)).." WHERE steamid = "..sql.SQLStr(steamid).." AND id = "..sql.SQLStr(id)..";")

    local ply = player.GetBySteamID(steamid)
    if not IsValid(ply) then return end

    net.Start("Perks:NetworkChange")
    net.WriteString(id)
    net.WriteUInt(Perks:GetPerkAmount(id, steamid), 32)
    net.Send(ply)
end

function Perks:GetPerkPoints(steamid)
    local data = sql.Query("SELECT * FROM LPerkPoints WHERE steamid = "..sql.SQLStr(steamid)..";")
    return data and tonumber(data[1].amount) or 0
end

util.AddNetworkString("Perks:PerkPointsChange")
function Perks:AddPerkPoints(steamid, amt)
    local data = sql.Query("SELECT * FROM LPerkPoints WHERE steamid = "..sql.SQLStr(steamid)..";")
	if data then
        local amount = Perks:GetPerkPoints(steamid) + amt
		sql.Query("UPDATE LPerkPoints SET amount = "..(math.max(amount, 0)).." WHERE steamid = "..sql.SQLStr(steamid)..";")
	else
		sql.Query("INSERT INTO LPerkPoints (steamid, amount) VALUES("..sql.SQLStr(steamid)..", "..amt..")")
	end

    local ply = player.GetBySteamID(steamid)
    if not IsValid(ply) then return end

    net.Start("Perks:PerkPointsChange")
    net.WriteUInt(Perks:GetPerkPoints(steamid), 32)
    net.Send(ply)
end