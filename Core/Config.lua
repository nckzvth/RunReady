local addonName, DP = ...
_G["DungeonPrep"] = DP

DP.version = "1.0.0"
DP.title = "|cffffd100Dungeon|r|cffffffffPrep|r"

-- Default Global Settings
local defaultDB = {
    showMinimapButton = true,
    minimapPos = 215,
    autoAlertItemDrops = true,
    filterByFaction = true,
    filterByLevel = false,
    soundAlerts = true,
    frameScale = 1.0,
}

-- Default Character Settings
local defaultCharDB = {
    selectedDungeon = nil,
    customNotes = {},
}

DP.DungeonArt = {
    ["RFC"]         = "Interface\\Glues\\LoadingScreens\\LoadScreenRagefireChasm",
    ["HOT"]         = "Interface\\AddOns\\ForeverDungeonJournal\\Media\\HallOfThanes.tga",
    ["WC"]          = "Interface\\Glues\\LoadingScreens\\LoadScreenWailingCaverns",
    ["DM"]          = "Interface\\Glues\\LoadingScreens\\LoadScreenDeadmines",
    ["ROL"]         = "Interface\\AddOns\\ForeverDungeonJournal\\Media\\RuinsOfLordaeron.tga",
    ["SFK"]         = "Interface\\Glues\\LoadingScreens\\LoadScreenShadowFangKeep",
    ["BFD"]         = "Interface\\Glues\\LoadingScreens\\LoadScreenBlackFathomDeeps",
    ["STK"]         = 131870,
    ["EXC"]         = 7963777,
    ["GNO"]         = "Interface\\Glues\\LoadingScreens\\LoadScreenGnomeregan",
    ["RFK"]         = 131865,
    ["DAL"]         = 7963775,
    ["SM_GY"]       = "Interface\\AddOns\\ForeverDungeonJournal\\Media\\ScarletMonasteryGraveyardHome.tga",
    ["SM_LIB"]      = "Interface\\AddOns\\ForeverDungeonJournal\\Media\\ScarletMonasteryLibraryHome.tga",
}

DP.DungeonArtCoords = {
    ["RFC"]         = { 0.02, 0.98, 0.34, 0.74 },
    ["HOT"]         = { 0.03, 0.97, 0.15, 0.85 },
    ["WC"]          = { 0.02, 0.98, 0.34, 0.74 },
    ["DM"]          = { 0.02, 0.98, 0.34, 0.74 },
    ["ROL"]         = { 0.03, 0.97, 0.15, 0.85 },
    ["SFK"]         = { 0.02, 0.98, 0.34, 0.74 },
    ["BFD"]         = { 0.02, 0.98, 0.34, 0.74 },
    ["STK"]         = { 0.02, 0.98, 0.34, 0.74 },
    ["EXC"]         = { 0.00, 1.00, 0.30, 0.70 },
    ["GNO"]         = { 0.02, 0.98, 0.34, 0.74 },
    ["RFK"]         = { 0.02, 0.98, 0.34, 0.74 },
    ["DAL"]         = { 0.00, 1.00, 0.30, 0.70 },
    ["SM_GY"]       = { 0.02, 0.98, 0.15, 0.85 },
    ["SM_LIB"]      = { 0.00, 1.00, 0.15, 0.85 },
}

function DP:InitializeConfig()
    if not DungeonPrepDB then
        DungeonPrepDB = {}
    end
    for k, v in pairs(defaultDB) do
        if DungeonPrepDB[k] == nil then
            DungeonPrepDB[k] = v
        end
    end
    DP.db = DungeonPrepDB

    if not DungeonPrepCharDB then
        DungeonPrepCharDB = {}
    end
    for k, v in pairs(defaultCharDB) do
        if DungeonPrepCharDB[k] == nil then
            DungeonPrepCharDB[k] = v
        end
    end
    DP.charDB = DungeonPrepCharDB
end

-- Slash Commands
SLASH_DUNGEONPREP1 = "/dp"
SLASH_DUNGEONPREP2 = "/dungeonprep"
SlashCmdList["DUNGEONPREP"] = function(msg)
    local cmd = string.trim((msg or ""):lower())

    if cmd == "help" then
        print(DP.title .. " Commands:")
        print("  |cffffd100/dp|r - Toggle DungeonPrep window")
        print("  |cffffd100/dp check|r - Quick audit for your current zone/dungeon")
        print("  |cffffd100/dp share|r - Share active dungeon quests to party")
        print("  |cffffd100/dp minimap|r - Toggle minimap button")
    elseif cmd == "minimap" then
        DP.db.showMinimapButton = not DP.db.showMinimapButton
        if DP.MinimapButton then
            if DP.db.showMinimapButton then DP.MinimapButton:Show() else DP.MinimapButton:Hide() end
        end
        print(DP.title .. ": Minimap button " .. (DP.db.showMinimapButton and "|cff00ff00shown|r" or "|cffff0000hidden|r"))
    elseif cmd == "share" then
        DP:ShareCurrentDungeonQuests()
    elseif cmd == "check" then
        DP:QuickAuditCurrentLocation()
    else
        if DP.MainFrame then
            if DP.MainFrame:IsShown() then
                DP.MainFrame:Hide()
            else
                DP.MainFrame:Show()
                DP.MainFrame:Refresh()
            end
        end
    end
end

function DP:EnsureDungeonData()
    if not DP.DungeonData or next(DP.DungeonData) == nil then
        DP.DungeonData = {}
        for k, v in pairs(DP.Dungeons_1_30 or {}) do DP.DungeonData[k] = v end
        for k, v in pairs(DP.Dungeons_30_60 or {}) do DP.DungeonData[k] = v end
    end
end

function DP:GetDungeon(key)
    DP:EnsureDungeonData()
    return DP.DungeonData and DP.DungeonData[key]
end

function DP:GetDungeonList()
    DP:EnsureDungeonData()
    local list = {}
    local faction = DP.Utils:GetPlayerFaction()
    local playerLevel = UnitLevel("player")

    for key, d in pairs(DP.DungeonData or {}) do
        local include = true
        if DP.db and DP.db.filterByFaction and (d.faction ~= "Both" and d.faction ~= faction) then
            include = false
        end
        if DP.db and DP.db.filterByLevel and playerLevel > 0 then
            if playerLevel < (d.minLevel - 3) or playerLevel > (d.maxLevel + 10) then
                include = false
            end
        end
        if include then
            table.insert(list, d)
        end
    end

    table.sort(list, function(a, b)
        if a.minLevel == b.minLevel then
            return a.name < b.name
        end
        return a.minLevel < b.minLevel
    end)

    return list
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("QUEST_ACCEPTED")
eventFrame:RegisterEvent("QUEST_TURNED_IN")
eventFrame:RegisterEvent("QUEST_LOG_UPDATE")

eventFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "ADDON_LOADED" then
        local name = ...
        if name == addonName then
            DP:InitializeConfig()
            if DP.MainFrame then DP.MainFrame:Initialize() end
            if DP.MinimapButton then DP.MinimapButton:Initialize() end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(1.5, function()
            if DP.QuestScanner then DP.QuestScanner:RefreshCompletedQuests() end
        end)
    elseif event == "QUEST_ACCEPTED" or event == "QUEST_TURNED_IN" or event == "QUEST_LOG_UPDATE" then
        if DP.MainFrame and DP.MainFrame:IsShown() then
            DP.MainFrame:SelectDungeon(DP.charDB.selectedDungeon or "SFK")
        end
    end
end)
