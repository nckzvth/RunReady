local addonName, RR = ...

RR.ItemWatcher = {}

-- Important in-dungeon quest items that players commonly miss looting
RR.InDungeonQuestItems = {
    -- Wailing Caverns
    [10441] = { name = "Glowing Shard", dungeon = "Wailing Caverns", boss = "Mutanus the Devourer", questID = 6981, note = "Starts quest: The Glowing Shard (Turn in at Ratchet / Spire)" },
    -- Deadmines
    [1972]  = { name = "The Unsent Letter", dungeon = "The Deadmines", boss = "Edwin VanCleef", questID = 373, note = "Starts the Barov / Stockades chain!" },
    -- Gnomeregan
    [9326]  = { name = "Grime-Encrusted Ring", dungeon = "Gnomeregan", boss = "Trash Mobs", questID = 2945, note = "Wash at Sparklematic 5200 inside dungeon" },
    [9327]  = { name = "Thermaplugg's Safe Key", dungeon = "Gnomeregan", boss = "Mekgineer Thermaplugg", questID = 2943, note = "Loot safe inside Thermaplugg's room" },
    -- Zul'Farrak
    [9523]  = { name = "Vial of Troll Temper", dungeon = "Zul'Farrak", boss = "Shadow Hunters / Hexxers", questID = 3042, note = "Don't leave before looting 20 Troll Tempers!" },
    -- Maraudon
    [17702] = { name = "Celebrian Diamond", dungeon = "Maraudon", boss = "Lord Vyletongue", questID = 7044, note = "Part 1 of Scepter of Celebras" },
    [17703] = { name = "Celebrian Rod", dungeon = "Maraudon", boss = "Noxxion", questID = 7044, note = "Part 2 of Scepter of Celebras" },
    -- Sunken Temple
    [10662] = { name = "Filled Egg of Hakkar", dungeon = "Sunken Temple", boss = "Avatar of Hakkar", questID = 3528, note = "Loot Avatar of Hakkar body for Essence Fountain" },
}

local watcherFrame = CreateFrame("Frame")
watcherFrame:RegisterEvent("LOOT_OPENED")
watcherFrame:RegisterEvent("CHAT_MSG_LOOT")

watcherFrame:SetScript("OnEvent", function(self, event, ...)
    if not (RR.db and RR.db.autoAlertItemDrops) then return end

    if event == "LOOT_OPENED" then
        local numItems = GetNumLootItems() or 0
        for i = 1, numItems do
            local link = GetLootSlotLink(i)
            if link then
                local itemID = tonumber(link:match("item:(%d+)"))
                if itemID and RR.InDungeonQuestItems[itemID] then
                    local info = RR.InDungeonQuestItems[itemID]
                    RR.ItemWatcher:TriggerAlert(info.name, info.dungeon, info.note)
                end
            end
        end

    elseif event == "CHAT_MSG_LOOT" then
        local message = ...
        if message then
            for itemID, info in pairs(RR.InDungeonQuestItems) do
                if message:find(info.name) then
                    -- Someone looted or received the item
                    break
                end
            end
        end
    end
end)

function RR.ItemWatcher:TriggerAlert(itemName, dungeonName, note)
    PlaySound(8959) -- Raid Warning / Quest Objective sound
    RaidNotice_AddMessage(RaidWarningFrame, string.format("|cffffd100[RunReady]|r Quest Item: |cff00e5ff%s|r!", itemName), ChatTypeInfo["RAID_WARNING"])
    print(RR.title .. string.format(": |cffffaa00Loot Alert!|r |cff00e5ff%s|r dropped in %s! %s", itemName, dungeonName, note or ""))
end
