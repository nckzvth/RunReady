local addonName, RR = ...

RR.KeysData = {
    [7146]  = { 
        name = "Scarlet Key", dungeon = "Scarlet Monastery", source = "Doan's Strongbox (Library)", note = "Unlocks SM Armory and Cathedral doors",
        chain = {
            name = "Scarlet Key",
            faction = "Both",
            steps = {
                { step = 1, phase = "IN-DUNGEON", questID = 0, title = "Loot Doan's Strongbox", pickupNPC = "Doan's Strongbox", pickupLocation = "Scarlet Monastery (Library)", action = "Kill Arcanist Doan and loot the small box behind him." }
            }
        }
    },
    [6893]  = { 
        name = "Workshop Key", dungeon = "Gnomeregan", source = "Electrocutioner 6000", note = "Unlocks Gnomeregan back entrance workshop door",
        chain = {
            name = "Workshop Key",
            faction = "Both",
            steps = {
                { step = 1, phase = "IN-DUNGEON", questID = 0, title = "Defeat Electrocutioner 6000", pickupNPC = "Electrocutioner 6000", pickupLocation = "Gnomeregan", action = "Kill Electrocutioner 6000 and loot the key." }
            }
        }
    },
    [11000] = { 
        name = "Shadowforge Key", dungeon = "Blackrock Depths", source = "Dark Iron Legacy Quest (Ghost)", note = "Unlocks internal gates, doors, and Shadowforge lock",
        chain = {
            name = "Dark Iron Legacy",
            faction = "Both",
            steps = {
                { step = 1, phase = "PRE-DUNGEON", questID = 4296, title = "Dark Iron Legacy", pickupNPC = "Franclorn Forgewright", pickupLocation = "Blackrock Mountain", action = "Speak to Franclorn Forgewright while a ghost to receive the quest." },
                { step = 2, phase = "IN-DUNGEON", questID = 4296, title = "Dark Iron Legacy", pickupNPC = "Fineous Darkvire", pickupLocation = "Blackrock Depths", action = "Kill Fineous Darkvire, loot Ironfel, and place it on the Shrine of Thaurissan." }
            }
        }
    },
    [277507] = {
        name = "Dalaran Sewer Key", dungeon = "City of Dalaran", source = "Heart of Disruption (Horde)", note = "Unlocks the Dalaran Sewers instance portal",
        chain = {
            name = "Dalaran Attunement",
            faction = "Horde",
            steps = {
                { step = 1, phase = "PRE-DUNGEON", sectionHeader = "Magus Voidglare's Initial Quests", questID = 544, title = "Prison Break In", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Find the traitors and recover their artifacts, then return to Magus Voidglare." },
                { step = 2, phase = "PRE-DUNGEON", questID = 93680, title = "Key to the City", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Acquire the Grimy Key for Magus Wordeen Voidglare." },
                { step = 3, phase = "PRE-DUNGEON", sectionHeader = "Keeper Bel'varil's Initial Quest", questID = 556, title = "Stone Tokens", pickupNPC = "Keeper Bel'varil", pickupLocation = "Tarren Mill", action = "Bring 10 Worn Stone Tokens to Keeper Bel'varil." },
                { step = 4, phase = "PRE-DUNGEON", sectionHeader = "Follow-ups (Requires Previous)", questID = 545, title = "Dalaran Patrols", preReqs = "Requires: Prison Break In, Key to the City", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Kill 6 Dalaran Summoners and 12 Elemental Slaves." },
                { step = 5, phase = "PRE-DUNGEON", questID = 557, title = "Bracers of Binding", preReqs = "Requires: Stone Tokens", pickupNPC = "Keeper Bel'varil", pickupLocation = "Tarren Mill", action = "Bring 4 Bracers of Earth Binding to Keeper Bel'varil." },
                { step = 6, phase = "PRE-DUNGEON", sectionHeader = "The Final Assembly (Requires All Follow-ups)", questID = 92434, title = "Blood in the Streets", preReqs = "Requires: Dalaran Patrols, Bracers of Binding", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Hand this quest in to Image of Archmage Modera outside Dalaran." },
                { step = 7, phase = "PRE-DUNGEON", questID = 96984, title = "Heart of Disruption", preReqs = "Requires: Blood in the Streets", pickupNPC = "Image of Archmage Modera", pickupLocation = "Alterac Mountains", action = "Enter the City of Dalaran and collect the Arcane Mote. Provides Dalaran Sewer Key.", rewards = {{ itemID = 277507 }} }
            }
        }
    }
}

function RR:HasKey(itemID)
    if not itemID then return false end
    local count = GetItemCount(itemID, true) or 0
    if count > 0 then return true end
    for slot = 1, 19 do
        local id = GetInventoryItemID("player", slot)
        if id == itemID then return true end
    end
    return false
end