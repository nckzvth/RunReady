local addonName, RR = ...

RR.KeysData = {
    [7146]  = { name = "Scarlet Key", dungeon = "Scarlet Monastery", source = "Doan's Strongbox (Library)", note = "Unlocks SM Armory and Cathedral doors" },
    [6893]  = { name = "Workshop Key", dungeon = "Gnomeregan", source = "Electrocutioner 6000", note = "Unlocks Gnomeregan back entrance workshop door" },
    [11000] = { name = "Shadowforge Key", dungeon = "Blackrock Depths", source = "Dark Iron Legacy Quest (Ghost)", note = "Unlocks internal gates, doors, and Shadowforge lock" },
    [13704] = { name = "Skeleton Key", dungeon = "Scholomance", source = "Scholomance Key Chain (Acolyte)", note = "Unlocks Scholomance viewing room and front gate" },
    [12382] = { name = "Key to the City", dungeon = "Stratholme", source = "Magistrate Barthilas", note = "Unlocks Stratholme East/Service entrance" },
    [18249] = { name = "Crescent Key", dungeon = "Dire Maul", source = "Pusillin (DM East)", note = "Unlocks Dire Maul West and North library doors" },
    [12344] = { name = "Seal of Ascension", dungeon = "Upper Blackrock Spire", source = "LBRS Gem Quest", note = "Unlocks Upper Blackrock Spire door" },
    -- Raid Attunements
    [16309] = { name = "Drakefire Amulet", dungeon = "Onyxia's Lair", source = "Alliance Windsor Chain", note = "Required in bags to enter Onyxia's Lair" },
    [16664] = { name = "Drakefire Amulet", dungeon = "Onyxia's Lair", source = "Horde Rexxar / Drakkisath Chain", note = "Required in bags to enter Onyxia's Lair" },
}

-- Check if player has the key in bags or keyring
function RR:HasKey(itemID)
    if not itemID then return false end

    -- Check bags
    local count = GetItemCount(itemID, true) or 0
    if count > 0 then return true end

    -- Check equipped (e.g. Seal of Ascension ring)
    for slot = 1, 19 do
        local id = GetInventoryItemID("player", slot)
        if id == itemID then return true end
    end

    return false
end
