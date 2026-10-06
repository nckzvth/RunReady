local _, RR = ...
RR.Objectives = CreateFrame("Frame")
RR.Objectives:RegisterEvent("NAME_PLATE_UNIT_ADDED")
RR.Objectives:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
RR.Objectives:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
RR.Objectives:RegisterEvent("PLAYER_ENTERING_WORLD")

local dungeonObjectives = {}
local dropBosses = {}
local activeNameplates = {}

function RR.Objectives:UpdateDungeonObjectives()
    wipe(dungeonObjectives)
    wipe(dropBosses)
    
    local key = RR.charDB and RR.charDB.selectedDungeon
    if not key then return end
    
    local audit = RR.QuestScanner:AuditDungeon(key)
    if not audit then return end
    
    for _, qEntry in ipairs(audit.quests) do
        local q = qEntry.data
        if qEntry.status == "ACTIVE" then
            -- Parse boss drops (e.g. "Item start: Glowing Shard, dropped by Mutanus the Devourer")
            if q.pickupNPC then
                local item, boss = q.pickupNPC:match("Item start: (.-), dropped by (.*)")
                if boss then
                    dropBosses[boss] = { itemName = item, questTitle = q.title }
                    dungeonObjectives[boss] = q.title
                end
            end
            
            -- Parse kill objectives (e.g. "Kill 7 Deviate Ravagers, 7 Deviate Vipers...")
            local action = q.action or q.note or ""
            
            -- Simple parsing of "Kill X [Name]" or "Collect X [Name]"
            for mob in action:gmatch("%d+ ([%a%s'-]+)") do
                local cleanName = mob:gsub("^and%s+", ""):gsub("%s+and%s*$", ""):match("^%s*(.-)%s*$")
                if cleanName and cleanName ~= "" then
                    dungeonObjectives[cleanName] = q.title
                end
            end
        end
    end
end

-- Nameplate Indicator
local function SetupNameplateIndicator(frame, unit)
    local attachFrame = frame.UnitFrame or frame
    if not frame.dpIndicator then
        frame.dpIndicator = attachFrame:CreateTexture(nil, "OVERLAY")
        frame.dpIndicator:SetSize(24, 24)
        frame.dpIndicator:SetPoint("BOTTOM", attachFrame, "TOP", 0, 8)
        frame.dpIndicator:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon")
    end
    
    local name = UnitName(unit)
    if dungeonObjectives[name] then
        frame.dpIndicator:Show()
    else
        frame.dpIndicator:Hide()
    end
end

RR.Objectives:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        self:UpdateDungeonObjectives()
    elseif event == "NAME_PLATE_UNIT_ADDED" then
        local unit = ...
        local nameplate = C_NamePlate.GetNamePlateForUnit(unit)
        if nameplate then
            activeNameplates[unit] = nameplate
            SetupNameplateIndicator(nameplate, unit)
        end
    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local unit = ...
        local nameplate = activeNameplates[unit]
        if nameplate and nameplate.dpIndicator then
            nameplate.dpIndicator:Hide()
        end
        activeNameplates[unit] = nil
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
        if subevent == "UNIT_DIED" and destName then
            if dropBosses[destName] then
                local info = dropBosses[destName]
                RaidNotice_AddMessage(RaidWarningFrame, "âš ï¸ DON'T FORGET TO LOOT: " .. info.itemName .. " âš ï¸", {r=0, g=1, b=1})
                PlaySound(8959) -- RaidWarning sound
            end
        end
    end
end)

-- Tooltip Hook
GameTooltip:HookScript("OnTooltipSetUnit", function(self)
    local name, unit = self:GetUnit()
    if not name then return end
    
    if dungeonObjectives[name] then
        self:AddLine("|cff00e5ff[RunReady]|r Objective: " .. dungeonObjectives[name])
        self:Show()
    end
end)

-- Make sure we update objectives when the UI selects a new dungeon
if RR.MainFrame and RR.MainFrame.SelectDungeon then
    hooksecurefunc(RR.MainFrame, "SelectDungeon", function(self, key)
        RR.Objectives:UpdateDungeonObjectives()
    end)
end
