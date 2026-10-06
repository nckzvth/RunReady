local addonName, RR = ...
_G["RunReady"] = RR

RR.version = "1.0.0"
RR.title = "|cffffd100Run|r|cffffffffReady|r"

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

RR.DungeonArt = {
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

RR.DungeonArtCoords = {
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

function RR:InitializeConfig()
    if not RunReadyDB then
        RunReadyDB = {}
    end
    for k, v in pairs(defaultDB) do
        if RunReadyDB[k] == nil then
            RunReadyDB[k] = v
        end
    end
    RR.db = RunReadyDB

    if not RunReadyCharDB then
        RunReadyCharDB = {}
    end
    for k, v in pairs(defaultCharDB) do
        if RunReadyCharDB[k] == nil then
            RunReadyCharDB[k] = v
        end
    end
    RR.charDB = RunReadyCharDB
end

-- Slash Commands
SLASH_RunReady1 = "/dp"
SLASH_RunReady2 = "/RunReady"
SlashCmdList["RunReady"] = function(msg)
    local cmd = string.trim((msg or ""):lower())

    if cmd == "help" then
        print(RR.title .. " Commands:")
        print("  |cffffd100/dp|r - Toggle RunReady window")
        print("  |cffffd100/dp check|r - Quick audit for your current zone/dungeon")
        print("  |cffffd100/dp share|r - Share active dungeon quests to party")
        print("  |cffffd100/dp minimap|r - Toggle minimap button")
    elseif cmd == "minimap" then
        RR.db.showMinimapButton = not RR.db.showMinimapButton
        if RR.MinimapButton then
            if RR.db.showMinimapButton then RR.MinimapButton:Show() else RR.MinimapButton:Hide() end
        end
        print(RR.title .. ": Minimap button " .. (RR.db.showMinimapButton and "|cff00ff00shown|r" or "|cffff0000hidden|r"))
    elseif cmd == "share" then
        RR:ShareCurrentDungeonQuests()
    elseif cmd == "check" then
        RR:QuickAuditCurrentLocation()
    else
        if RR.MainFrame then
            if RR.MainFrame:IsShown() then
                RR.MainFrame:Hide()
            else
                RR.MainFrame:Show()
                RR.MainFrame:Refresh()
            end
        end
    end
end

function RR:EnsureDungeonData()
    if not RR.DungeonData or next(RR.DungeonData) == nil then
        RR.DungeonData = {}
        for k, v in pairs(RR.Dungeons_1_30 or {}) do RR.DungeonData[k] = v end
        for k, v in pairs(RR.Dungeons_30_60 or {}) do RR.DungeonData[k] = v end
    end
end

function RR:GetDungeon(key)
    RR:EnsureDungeonData()
    return RR.DungeonData and RR.DungeonData[key]
end

function RR:GetDungeonList()
    RR:EnsureDungeonData()
    local list = {}
    local faction = RR.Utils:GetPlayerFaction()
    local playerLevel = UnitLevel("player")

    for key, d in pairs(RR.DungeonData or {}) do
        local include = true
        if RR.db and RR.db.filterByFaction and (d.faction ~= "Both" and d.faction ~= faction) then
            include = false
        end
        if RR.db and RR.db.filterByLevel and playerLevel > 0 then
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
            RR:InitializeConfig()
            if RR.MainFrame then RR.MainFrame:Initialize() end
            if RR.MinimapButton then RR.MinimapButton:Initialize() end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(1.5, function()
            if RR.QuestScanner then RR.QuestScanner:RefreshCompletedQuests() end
        end)
    elseif event == "QUEST_ACCEPTED" or event == "QUEST_TURNED_IN" or event == "QUEST_LOG_UPDATE" then
        if RR.MainFrame and RR.MainFrame:IsShown() then
            RR.MainFrame:SelectDungeon(RR.charDB.selectedDungeon or "SFK")
        end
    end
end)
