hook.Add("PIXEL.UI.FullyLoaded", "LoadPerks", function() 
    PIXEL.LoadDirectoryRecursive("perk_system")
end)
Perks = Perks or {}


print("[ Loaded Perks ] - Core")
