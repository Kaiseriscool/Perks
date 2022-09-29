hook.Add("PIXEL.UI.FullyLoaded", "LoadPerks", function() 
    PIXEL.LoadDirectoryRecursive("perk_system")
end)


print("[ Loaded Perks ] - Core")