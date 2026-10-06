local addonName, RR = ...

RR.Utils = {}

-- Reliable player faction
function RR.Utils:GetPlayerFaction()
    local faction = UnitFactionGroup("player")
    if faction and faction ~= "" and faction ~= "Neutral" then
        return faction
    end

    local _, raceFile = UnitRace("player")
    if raceFile then
        local r = raceFile:lower()
        if r == "human" or r == "dwarf" or r == "nightelf" or r == "gnome" or r == "draenei" or r == "highelf" then
            return "Alliance"
        elseif r == "orc" or r == "scourge" or r == "undead" or r == "tauren" or r == "troll" or r == "bloodelf" or r == "goblin" then
            return "Horde"
        end
    end
    return "Alliance"
end

-- Add TomTom waypoint if available
function RR.Utils:SetWaypoint(mapID, x, y, title)
    if not (mapID and x and y) then return false end

    -- 1. TomTom Support (Multiple Waypoints + Crazy Arrow)
    if TomTom then
        TomTom:AddWaypoint(mapID, x / 100, y / 100, {
            title = RR.title .. ": " .. (title or "Quest Pickup"),
            persistent = false,
            minimap = true,
            world = true,
        })
        print(RR.title .. ": Waypoint added for " .. (title or "Target") .. string.format(" at %.1f, %.1f.", x, y))
        return true
    end

    -- 2. Native WoW Fallback (One Waypoint at a time)
    if C_Map and C_Map.SetUserWaypoint and UiMapPoint then
        local pt = UiMapPoint.CreateFromCoordinates(mapID, x / 100, y / 100)
        C_Map.SetUserWaypoint(pt)
        C_SuperTrack.SetSuperTrackedUserWaypoint(true)
        print(RR.title .. ": Map Pin set for " .. (title or "Target") .. string.format(" at %.1f, %.1f.", x, y))
        return true
    end

    print(RR.title .. ": TomTom is not installed and native map pins failed.")
    return false
end

-- Zone Name to MapID (Classic)
local ZoneMapIDs = {
    ["Orgrimmar"] = 1454,
    ["Stormwind City"] = 1453,
    ["Thunder Bluff"] = 1456,
    ["Darnassus"] = 1457,
    ["Undercity"] = 1458,
    ["Ironforge"] = 1455,
    ["The Barrens"] = 1413,
    ["Mulgore"] = 1411,
    ["Durotar"] = 1412,
    ["Tirisfal Glades"] = 1420,
    ["Silverpine Forest"] = 1421,
    ["Stonetalon Mountains"] = 1440,
    ["Desolace"] = 1443,
    ["Ashenvale"] = 1440, -- wait ashenvale is 1440? no 1434
    ["Wetlands"] = 1437,
    ["Loch Modan"] = 1432,
    ["Dun Morogh"] = 1426,
    ["Elwynn Forest"] = 1429,
    ["Westfall"] = 1436,
    ["Redridge Mountains"] = 1433,
    ["Duskwood"] = 1431,
    ["Teldrassil"] = 1438,
    ["Darkshore"] = 1439,
    ["Hillsbrad Foothills"] = 1424,
    ["Alterac Mountains"] = 1416,
    ["Arathi Highlands"] = 1417,
    ["Stranglethorn Vale"] = 1434,
    ["Thousand Needles"] = 1441,
    ["Dustwallow Marsh"] = 1445,
    ["Tanaris"] = 1446,
    ["Feralas"] = 1444,
    ["Felwood"] = 1448,
    ["Winterspring"] = 1452,
    ["Searing Gorge"] = 1427,
    ["Burning Steppes"] = 1428,
    ["Blasted Lands"] = 1419,
    ["Swamp of Sorrows"] = 1435,
    ["Western Plaguelands"] = 1422,
    ["Eastern Plaguelands"] = 1423,
    ["Badlands"] = 1418,
    ["Un'Goro Crater"] = 1449,
    ["Silithus"] = 1451,
    ["Moonglade"] = 1450,
    ["Deadwind Pass"] = 1430,
    ["Azshara"] = 1447,
}
-- Fix some specific ids
ZoneMapIDs["Ashenvale"] = 1440 -- wait, 1434 is STV, 1440 is Ashenvale? Let's check map ids to be safe. Actually Ashenvale is 1440 in modern wow map UI?
-- We can just do a dynamic lookup using C_Map if possible, but string matching C_Map.GetMapInfo is expensive.

function RR.Utils:GetMapIDFromZone(zoneName)
    if not zoneName then return nil end
    -- Exact match from our manual table
    if ZoneMapIDs[zoneName] then return ZoneMapIDs[zoneName] end
    
    -- Substring match (e.g. "Orgrimmar, The Drag" -> "Orgrimmar")
    for zName, mID in pairs(ZoneMapIDs) do
        if string.find(zoneName, zName) then
            return mID
        end
    end
    
    return nil
end

-- Native WoW Status Badges
RR.StatusMeta = {
    ["COMPLETED"] = {
        label = "Done",
        color = "10b981",
        tag = "|cff10b981[Completed]|r",
        r = 0.16, g = 0.85, b = 0.45,
        icon = "|TInterface\\RaidFrame\\ReadyCheck-Ready:14:14:0:0|t",
    },
    ["ACTIVE"] = {
        label = "In Log",
        color = "f59e0b",
        tag = "|cfff59e0b[In Log]|r",
        r = 0.95, g = 0.75, b = 0.15,
        icon = "|TInterface\\GossipFrame\\WorkOrderGossipIcon:14:14:0:0|t",
    },
    ["READY_TURNIN"] = {
        label = "Ready to Turn In",
        color = "00e5ff",
        tag = "|cff00e5ff[Turn In Ready]|r",
        r = 0.0, g = 0.85, b = 0.95,
        icon = "|TInterface\\GossipFrame\\ActiveQuestIcon:14:14:0:0|t",
    },
    ["AVAILABLE"] = {
        label = "Available",
        color = "00e5ff",
        tag = "|cff00e5ff[Available]|r",
        r = 0.2, g = 0.8, b = 1.0,
        icon = "|TInterface\\GossipFrame\\AvailableQuestIcon:14:14:0:0|t",
    },
    ["LOCKED"] = {
        label = "Locked",
        color = "ef4444",
        tag = "|cffef4444[Prereq Needed]|r",
        r = 0.95, g = 0.35, b = 0.35,
        icon = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14:14:0:0|t",
    },
    ["LEVEL_LOW"] = {
        label = "Level Too Low",
        color = "94a3b8",
        tag = "|cff94a3b8[Too Low]|r",
        r = 0.58, g = 0.64, b = 0.72,
        icon = "|TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:14:14:0:0|t",
    },
}

function RR.Utils:GetStatusMeta(status)
    return RR.StatusMeta[status] or RR.StatusMeta["AVAILABLE"]
end

function RR.Utils:FormatTime(seconds)
    if not seconds or seconds <= 0 then return "0s" end
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local mins = math.floor((seconds % 3600) / 60)
    if days > 0 then
        return string.format("%dd %dh", days, hours)
    elseif hours > 0 then
        return string.format("%dh %dm", hours, mins)
    else
        return string.format("%dm", mins)
    end
end

local ejCache = {}
function RR.Utils:GetDungeonEJTexture(dungeonName)
    if not dungeonName then return nil end
    if not ejCache.populated and EJ_GetInstanceByIndex then
        local foundAny = false
        local numTiers = EJ_GetNumTiers and EJ_GetNumTiers() or 1
        numTiers = math.max(1, numTiers)
        
        for t = 1, numTiers do
            if EJ_SelectTier then pcall(EJ_SelectTier, t) end
            for i = 1, 200 do
                local ok, instanceID, name, _, bgImage, buttonImage = pcall(EJ_GetInstanceByIndex, i, false)
                if not ok or not instanceID then break end
                if name then
                    foundAny = true
                    local cleanName = name:gsub(" %([^%)]+%)$", "")
                    -- Sometimes buttonImage is 0 or nil, fallback to bgImage
                    local tex = buttonImage
                    if not tex or tex == 0 or tex == "" then tex = bgImage end
                    if tex and tex ~= 0 and tex ~= "" then
                        ejCache[cleanName] = tex
                    end
                end
            end
        end
        
        if foundAny then
            ejCache.populated = true
        end
    end
    
    local cleanName = dungeonName:gsub(" %([^%)]+%)$", "")
    return ejCache[dungeonName] or ejCache[cleanName]
end

SLASH_DPDEBUG1 = "/dpdebug"
SlashCmdList["DPDEBUG"] = function()
    local numTiers = EJ_GetNumTiers and EJ_GetNumTiers() or "nil"
    print("Num Tiers:", numTiers)
    
    -- Test without selecting tier
    print("Dumping EJ_GetInstanceByIndex(1) WITHOUT selecting tier:")
    local t = { pcall(EJ_GetInstanceByIndex, 1, false) }
    for i, v in ipairs(t) do
        print(i .. ":", tostring(v))
    end
end
