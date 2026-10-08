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
    [999999] = { -- Placeholder ID for Dalaran Sewer Key
        name = "Dalaran Sewer Key", dungeon = "City of Dalaran", source = "Heart of Disruption (Horde)", note = "Unlocks the Dalaran Sewers instance portal",
        chain = {
            name = "Dalaran Attunement",
            faction = "Horde",
            steps = {
                { step = 1, phase = "PRE-DUNGEON", questID = 0, title = "Prison Break In", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Accept the initial attunement quest." },
                { step = 2, phase = "PRE-DUNGEON", questID = 0, title = "Dalaran Patrols", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Follow up quest to patrol around Dalaran." },
                { step = 3, phase = "PRE-DUNGEON", questID = 0, title = "Blood in the Streets", pickupNPC = "Image of Archmage Modera", pickupLocation = "Alterac Mountains", action = "Turn in to the Image of Modera." },
                { step = 4, phase = "PRE-DUNGEON", questID = 0, title = "Heart of Disruption", pickupNPC = "Image of Archmage Modera", pickupLocation = "Alterac Mountains", action = "Complete the quest to receive the Dalaran Sewer Key." }
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