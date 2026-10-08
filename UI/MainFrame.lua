local addonName, RR = ...

RR.MainFrame = CreateFrame("Frame", "RunReadyMainFrame", UIParent, "BackdropTemplate")
local Frame = RR.MainFrame

-- State
Frame.activeScreen = "QUESTS"     -- "QUESTS", "PARTY", "KEYS"
Frame.activeBracket = "BETA"    -- "BETA", "LAUNCH", "ALL"

Frame.linePool = {}
Frame.activeLines = {}

RR.DungeonIcons = {
    ["RFC"]         = "Interface\\Icons\\Spell_Fire_Fire",
    ["HOT"]         = "Interface\\Icons\\INV_Hammer_08",           -- Hall of Thanes (Forever)
    ["WC"]          = "Interface\\Icons\\Spell_Nature_HealingTouch",
    ["DM"]          = "Interface\\Icons\\INV_Hammer_16",           -- Deadmines
    ["ROL"]         = "Interface\\Icons\\Spell_Shadow_ShadowPact", -- Ruins of Lordaeron (Forever)
    ["SFK"]         = "Interface\\Icons\\Spell_Shadow_DarkSummoning",
    ["BFD"]         = "Interface\\Icons\\Spell_Frost_Frost",
    ["STK"]         = "Interface\\Icons\\INV_Misc_Key_03",         -- Stockade
    ["EXC"]         = "Interface\\Icons\\INV_Misc_Rubble_01",      -- Excavation Site (Forever)
    ["GNO"]         = "Interface\\Icons\\INV_Misc_Gear_01",        -- Gnomeregan
    ["RFK"]         = "Interface\\Icons\\INV_Misc_Bone_01",
    ["SM_GY"]       = "Interface\\Icons\\Spell_Holy_GuardiansSpirit",
    ["SM_LIB"]      = "Interface\\Icons\\INV_Misc_Book_09",
    ["DAL"]         = "Interface\\Icons\\Spell_Arcane_PortalDalaran", -- City of Dalaran (Forever)
    ["SM_ARM"]      = "Interface\\Icons\\INV_Shield_06",
    ["SM_CATH"]     = "Interface\\Icons\\Spell_Holy_RighteousFury",
    ["RFD"]         = "Interface\\Icons\\Spell_Shadow_DeathScream",
    ["ULD"]         = "Interface\\Icons\\INV_Misc_StoneTablet_01",
    ["ZF"]          = "Interface\\Icons\\INV_Misc_MonsterScales_02",
    ["MARA"]        = "Interface\\Icons\\Spell_Nature_NaturesBlessing",
    ["ST"]          = "Interface\\Icons\\Spell_Shadow_SummonVoidWalker",
    ["BRD"]         = "Interface\\Icons\\Spell_Fire_Incinerate",
    ["LBRS"]        = "Interface\\Icons\\INV_Misc_Head_Dragon_01",
    ["UBRS"]        = "Interface\\Icons\\INV_Misc_Head_Dragon_02",
    ["STRAT"]       = "Interface\\Icons\\Spell_Holy_Renew",
    ["SCHOLO"]      = "Interface\\Icons\\Spell_Shadow_Haunting",
    ["DM_DIREMAUL"] = "Interface\\Icons\\Spell_Arcane_PortalDarnassus",
}

-- Line drawing engine for flowcharts
function Frame:GetLine(parent)
    local line = table.remove(self.linePool)
    if not line then
        line = parent:CreateTexture(nil, "ARTWORK")
    else
        line:SetParent(parent)
    end
    table.insert(self.activeLines, line)
    line:Show()
    return line
end

function Frame:ClearLines()
    for _, line in ipairs(self.activeLines) do
        line:Hide()
        table.insert(self.linePool, line)
    end
    self.activeLines = {}
end

function Frame:DrawOrthogonalConnector(parent, x1, y1, x2, y2, r, g, b, a)
    local midX = math.floor((x1 + x2) / 2)
    
    -- Segment 1: Horizontal from x1 to midX at y1
    local l1 = self:GetLine(parent)
    l1:SetColorTexture(r, g, b, a or 0.8)
    l1:SetPoint("TOPLEFT", parent, "TOPLEFT", math.min(x1, midX), y1)
    l1:SetSize(math.max(math.abs(midX - x1), 2), 2)
    
    -- Segment 2: Vertical from y1 to y2 at midX
    local l2 = self:GetLine(parent)
    l2:SetColorTexture(r, g, b, a or 0.8)
    l2:SetPoint("TOPLEFT", parent, "TOPLEFT", midX - 1, math.max(y1, y2))
    l2:SetSize(2, math.max(math.abs(y2 - y1), 2))
    
    -- Segment 3: Horizontal from midX to x2 at y2
    local l3 = self:GetLine(parent)
    l3:SetColorTexture(r, g, b, a or 0.8)
    l3:SetPoint("TOPLEFT", parent, "TOPLEFT", math.min(midX, x2), y2)
    l3:SetSize(math.max(math.abs(x2 - midX), 2), 2)
end

local function CreateNativeTab(parent, label, width)
    local tab = CreateFrame("Button", nil, parent)
    tab:SetSize(width, 28)
    
    tab.left = tab:CreateTexture(nil, "BACKGROUND")
    tab.left:SetSize(20, 28)
    tab.left:SetPoint("TOPLEFT")
    
    tab.right = tab:CreateTexture(nil, "BACKGROUND")
    tab.right:SetSize(20, 28)
    tab.right:SetPoint("TOPRIGHT")
    
    tab.middle = tab:CreateTexture(nil, "BACKGROUND")
    tab.middle:SetPoint("TOPLEFT", tab.left, "TOPRIGHT")
    tab.middle:SetPoint("BOTTOMRIGHT", tab.right, "BOTTOMLEFT")
    
    tab.text = tab:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
    tab.text:SetPoint("CENTER", 0, -2)
    tab.text:SetText(label)
    
    tab.UpdateState = function(self, active)
        if self:IsEnabled() == false then return end
        if active then
            self.left:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
            self.left:SetTexCoord(0, 0.15625, 0, 1)
            self.right:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
            self.right:SetTexCoord(0.84375, 1, 0, 1)
            self.middle:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-ActiveTab")
            self.middle:SetTexCoord(0.15625, 0.84375, 0, 1)
            self.text:ClearAllPoints()
            self.text:SetPoint("CENTER", 0, -1)
            self.text:SetTextColor(1, 1, 1)
        else
            self.left:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
            self.left:SetTexCoord(0, 0.15625, 0, 1)
            self.right:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
            self.right:SetTexCoord(0.84375, 1, 0, 1)
            self.middle:SetTexture("Interface\\OptionsFrame\\UI-OptionsFrame-InActiveTab")
            self.middle:SetTexCoord(0.15625, 0.84375, 0, 1)
            self.text:ClearAllPoints()
            self.text:SetPoint("CENTER", 0, -4)
            self.text:SetTextColor(1, 0.82, 0)
        end
    end
    
    tab:HookScript("OnDisable", function(self)
        self.text:SetTextColor(0.5, 0.5, 0.5)
        self.left:SetDesaturated(true)
        self.middle:SetDesaturated(true)
        self.right:SetDesaturated(true)
    end)
    
    tab:UpdateState(false)
    return tab
end

-- ====================================================
-- INITIALIZATION: MODERN EXPANSIVE UI (1060 x 660)
-- ====================================================
function Frame:Initialize()
    self:SetSize(1200, 680)
    self:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    self:SetMovable(true)
    self:EnableMouse(true)
    self:RegisterForDrag("LeftButton")
    self:SetClampedToScreen(true)
    self:SetFrameStrata("DIALOG")
    self:SetFrameLevel(100)

    self:SetScript("OnDragStart", function(s) s:StartMoving() end)
    self:SetScript("OnDragStop", function(s) s:StopMovingOrSizing() end)
    
    -- Make the frame closeable via the ESC key
    tinsert(UISpecialFrames, "RunReadyMainFrame")

    -- Classic Native WoW Frame Look (Dungeon Journal Style)
    self:SetBackdrop({
        bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true, tileSize = 256, edgeSize = 32,
        insets = { left = 8, right = 8, top = 8, bottom = 8 }
    })
    self:SetBackdropColor(1, 1, 1, 1)

    -- ====================================================
    -- TOP NAVIGATION BAR (Height 46px)
    -- ====================================================

    -- Close Button (Sleek red 'X' button on far top right)
    self.closeBtn = CreateFrame("Button", nil, self, "UIPanelCloseButton")
    self.closeBtn:SetSize(22, 22)
    self.closeBtn:SetPoint("TOPRIGHT", -8, -12)

    -- Action & Navigation Bar (Docked to the left of the close button with NO overlap!)
    self.shareBtn = CreateFrame("Button", nil, self, "UIPanelButtonTemplate")
    self.shareBtn:SetSize(95, 22)
    self.shareBtn:SetPoint("RIGHT", self.closeBtn, "LEFT", -12, 0)
    self.shareBtn:SetText("Share Quests")
    self.shareBtn:SetScript("OnClick", function()
        RR:ShareCurrentDungeonQuests(RR.charDB.selectedDungeon)
    end)

    self.titleText = self:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.titleText:SetPoint("RIGHT", self.shareBtn, "LEFT", -16, 0)
    self.titleText:SetText("|cff00e5ffRun|r|cffffffffReady|r")

    -- Screen Switcher Tabs will be attached to rightArea

    -- Top divider removed

    -- ====================================================
    -- LEFT SIDEBAR: Dungeon Selector & Category Tabs (Width 250px)
    -- ====================================================
    self.sidebar = CreateFrame("Frame", nil, self, "BackdropTemplate")
    self.sidebar:SetPoint("TOPLEFT", 10, -48)
    self.sidebar:SetPoint("BOTTOMLEFT", 10, 10)
    self.sidebar:SetWidth(250)
    self.sidebar:SetBackdrop({
        bgFile = "Interface\\FrameGeneral\\UI-Background-Marble",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 256, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    self.sidebar:SetBackdropColor(1, 1, 1, 1)

    -- Top Level Bracket Tabs
    self.bracketTabs = {}
    local bDefs = {
        { key = "BETA",   label = "Beta", width = 110 },
        { key = "ALL",    label = "All",  width = 110 },
    }
    local prevAnchor = nil
    for _, bd in ipairs(bDefs) do
        local btn = CreateNativeTab(self.sidebar, bd.label, bd.width)
        if not prevAnchor then
            btn:SetPoint("BOTTOMLEFT", self.sidebar, "TOPLEFT", 12, -2)
        else
            btn:SetPoint("LEFT", prevAnchor, "RIGHT", 4, 0)
        end
        if bd.key == "ALL" then
            btn:Disable()
        end
        btn:SetScript("OnClick", function()
            if bd.key == "ALL" then return end
            Frame.activeBracket = bd.key
            Frame:UpdateBracketTabs()
            Frame:PopulateDungeonList(true)
        end)
        self.bracketTabs[bd.key] = btn
        prevAnchor = btn
    end

    -- Scrollable Instance List (Generous 34px row height!)
    self.dungeonScroll = CreateFrame("ScrollFrame", "DP_DungeonListScroll", self.sidebar, "UIPanelScrollFrameTemplate")
    self.dungeonScroll:SetPoint("TOPLEFT", 6, -8)
    self.dungeonScroll:SetPoint("BOTTOMRIGHT", -28, 12)
    
    if DP_DungeonListScrollTop then DP_DungeonListScrollTop:Hide() end
    if DP_DungeonListScrollBottom then DP_DungeonListScrollBottom:Hide() end
    if DP_DungeonListScrollMiddle then DP_DungeonListScrollMiddle:Hide() end

    self.dungeonContent = CreateFrame("Frame", nil, self.dungeonScroll)
    self.dungeonContent:SetSize(218, 500)
    self.dungeonScroll:SetScrollChild(self.dungeonContent)

    self.dungeonButtons = {}

    -- ====================================================
    -- RIGHT CONTENT AREA (Width 780px)
    -- ====================================================
    self.rightArea = CreateFrame("Frame", nil, self, "BackdropTemplate")
    self.rightArea:SetPoint("TOPLEFT", self.sidebar, "TOPRIGHT", 8, 0)
    self.rightArea:SetPoint("BOTTOMRIGHT", -10, 10)
    self.rightArea:SetBackdrop({
        bgFile = "Interface\\FrameGeneral\\UI-Background-Marble",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 256, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    self.rightArea:SetBackdropColor(1, 1, 1, 1)

    -- Screen Switcher Tabs
    self.screenTabs = {}
    local tabDefs = {
        { key = "QUESTS", label = "Quests",          width = 80 },
        { key = "PARTY",  label = "Party Sync",      width = 90 },
        { key = "KEYS",   label = "Keys & Locks",    width = 98 },
    }
    local rightPrev = nil
    for _, td in ipairs(tabDefs) do
        local tab = CreateNativeTab(self, td.label, td.width)
        if not rightPrev then
            tab:SetPoint("BOTTOMLEFT", self.rightArea, "TOPLEFT", 16, -2)
        else
            tab:SetPoint("LEFT", rightPrev, "RIGHT", 4, 0)
        end
        tab.screenKey = td.key
        tab:SetScript("OnClick", function()
            Frame:SwitchScreen(td.key)
        end)
        self.screenTabs[td.key] = tab
        rightPrev = tab
    end

    -- Top Showcase Header Bar (Height 58px)
    self.showcase = CreateFrame("Frame", nil, self.rightArea, "BackdropTemplate")
    self.showcase:SetPoint("TOPLEFT", 6, -6)
    self.showcase:SetPoint("TOPRIGHT", -6, -6)
    self.showcase:SetHeight(58)
    self.showcase:SetBackdrop({
        bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 256, edgeSize = 12,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
    })
    self.showcase:SetBackdropColor(1, 1, 1, 1)

    -- Left: Large Instance Title & Meta
    self.instanceTitle = self.showcase:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    self.instanceTitle:SetPoint("TOPLEFT", 12, -8)
    self.instanceTitle:SetText("Shadowfang Keep")

    self.instanceMeta = self.showcase:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    self.instanceMeta:SetPoint("TOPLEFT", self.instanceTitle, "BOTTOMLEFT", 0, -4)
    self.instanceMeta:SetTextColor(0.65, 0.75, 0.85)

    -- Center/Right: Visual Attune Progress Bar
    self.progressFrame = CreateFrame("Frame", nil, self.showcase, "BackdropTemplate")
    self.progressFrame:SetPoint("RIGHT", -250, 0)
    self.progressFrame:SetSize(240, 16)
    self.progressFrame:SetBackdrop({
        bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 16, edgeSize = 6,
        insets = { left = 1, right = 1, top = 1, bottom = 1 }
    })
    self.progressFrame:SetBackdropColor(0.02, 0.03, 0.05, 0.9)
    self.progressFrame:SetBackdropBorderColor(0.3, 0.35, 0.45, 0.8)

    self.progressBar = CreateFrame("StatusBar", nil, self.progressFrame)
    self.progressBar:SetPoint("TOPLEFT", 2, -2)
    self.progressBar:SetPoint("BOTTOMRIGHT", -2, 2)
    self.progressBar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    self.progressBar:SetStatusBarColor(0.10, 0.75, 0.40)
    self.progressBar:SetMinMaxValues(0, 100)
    self.progressBar:SetValue(0)

    self.progressText = self.progressBar:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    self.progressText:SetPoint("CENTER", 0, 0)
    self.progressText:SetText("0 / 0 Ready (0%)")

    -- Far Right: Pin Entrance Waypoint Button
    self.pinEntranceBtn = CreateFrame("Button", nil, self.showcase, "UIPanelButtonTemplate")
    self.pinEntranceBtn:SetSize(110, 22)
    self.pinEntranceBtn:SetPoint("RIGHT", -10, 0)
    self.pinEntranceBtn:SetText("Pin Entrance")
    self.pinEntranceBtn:SetScript("OnClick", function()
        local d = RR:GetDungeon(RR.charDB.selectedDungeon)
        if d and d.coords and d.mapID then
            RR.Utils:SetWaypoint(d.mapID, d.coords[1], d.coords[2], d.name .. " Entrance")
        end
    end)

    -- Collect Quests Button
    self.collectQuestsBtn = CreateFrame("Button", nil, self.showcase, "UIPanelButtonTemplate")
    self.collectQuestsBtn:SetSize(110, 22)
    self.collectQuestsBtn:SetPoint("RIGHT", self.pinEntranceBtn, "LEFT", -4, 0)
    self.collectQuestsBtn:SetText("GPS Tour")
    self.collectQuestsBtn:Hide() -- Disabled for now
    self.collectQuestsBtn:SetScript("OnClick", function()
        local dID = RR.charDB.selectedDungeon
        local d = RR:GetDungeon(dID)
        if not d then return end
        
        local results = RR.QuestScanner:AuditDungeon(dID)
        local count = 0
        if results and results.chains then
            for _, ch in ipairs(results.chains) do
                for _, sEntry in ipairs(ch.steps) do
                    local s = sEntry.data
                    local status = sEntry.status
                    if status == "AVAILABLE" or status == "READY_TURNIN" then
                        local coords = (status == "READY_TURNIN") and s.turninCoords or s.pickupCoords
                        if coords then
                            local locStr = (status == "READY_TURNIN") and (s.turninNPC or s.turninLocation) or (s.pickupNPC or s.pickupLocation)
                            local mapID = s.pickupMapID or RR.Utils:GetMapIDFromZone(locStr) or RR.Utils:GetMapIDFromZone(s.pickupLocation) or d.mapID
                            if mapID then
                                RR.Utils:SetWaypoint(mapID, coords[1], coords[2], s.title)
                                count = count + 1
                            end
                        end
                    end
                end
            end
        end
        if count > 0 then
            if TomTom then
                print("|cff00e5ffRunReady:|r Added " .. count .. " waypoints to TomTom!")
            else
                print("|cff00e5ffRunReady:|r Without TomTom, WoW only allows 1 map pin at a time. Install TomTom for the full GPS Tour!")
            end
        else
            print("|cff00e5ffRunReady:|r No available quests found with coordinates.")
        end
    end)

    -- Scrollable Screen Content
    self.screenScroll = CreateFrame("ScrollFrame", "DP_ScreenScroll", self.rightArea, "UIPanelScrollFrameTemplate")
    self.screenScroll:SetPoint("TOPLEFT", self.showcase, "BOTTOMLEFT", 2, -6)
    self.screenScroll:SetPoint("BOTTOMRIGHT", -28, 12)

    if DP_ScreenScrollTop then DP_ScreenScrollTop:Hide() end
    if DP_ScreenScrollBottom then DP_ScreenScrollBottom:Hide() end
    if DP_ScreenScrollMiddle then DP_ScreenScrollMiddle:Hide() end

    self.screenContent = CreateFrame("Frame", nil, self.screenScroll)
    self.screenContent:SetSize(920, 520)
    self.screenScroll:SetScrollChild(self.screenContent)

    local function AutoHideScrollbar(self, xrange, yrange)
        local scrollbar = _G[self:GetName() .. "ScrollBar"]
        if scrollbar then
            if math.floor(yrange or 0) > 0 then
                scrollbar:Show()
            else
                scrollbar:Hide()
            end
        end
    end
    self.dungeonScroll:HookScript("OnScrollRangeChanged", AutoHideScrollbar)
    self.screenScroll:HookScript("OnScrollRangeChanged", AutoHideScrollbar)

    -- Dynamic Pools
    self.flowStepNodes = {}
    self.flowChainHeaders = {}
    self.flowSummaryBar = nil
    self.giverCards = {}
    self.partyRows = {}
    self.keyCards = {}
    self.detailNodes = {}

    self:Hide()
end

-- ====================================================
-- TABS & NAVIGATION STATE
-- ====================================================
function Frame:SwitchScreen(screenKey)
    self.activeScreen = screenKey
    for key, tab in pairs(self.screenTabs) do
        if tab.UpdateState then
            tab:UpdateState(key == screenKey)
        end
    end
    self:RefreshActiveScreen()
end

function Frame:UpdateBracketTabs()
    for key, tab in pairs(self.bracketTabs) do
        if tab.UpdateState then
            tab:UpdateState(key == self.activeBracket)
        end
    end
end

function Frame:Refresh()
    self:UpdateBracketTabs()
    self:SwitchScreen(self.activeScreen or "QUESTS")
    self:PopulateDungeonList(false)

    local defaultDungeon = RR.charDB.selectedDungeon or "SFK"
    self:SelectDungeon(defaultDungeon)
end

function Frame:PopulateDungeonList(autoSelectFirst)
    local fullList = RR:GetDungeonList()
    local filtered = {}

    for _, d in ipairs(fullList) do
        if self.activeBracket == "BETA" then
            if d.recommendedLevel and d.recommendedLevel <= 36 then
                table.insert(filtered, d)
            end
        else
            table.insert(filtered, d)
        end
    end

    table.sort(filtered, function(a, b)
        local lvlA = a.recommendedLevel or a.minLevel or 0
        local lvlB = b.recommendedLevel or b.minLevel or 0
        if lvlA == lvlB then
            return a.name < b.name
        end
        return lvlA < lvlB
    end)

    local rowHeight = 48
    local totalHeight = #filtered * (rowHeight + 4)
    self.dungeonContent:SetHeight(math.max(totalHeight, 400))

    local hasCurrent = false

    for i, d in ipairs(filtered) do
        local btn = self.dungeonButtons[i]
        if not btn then
            btn = CreateFrame("Button", nil, self.dungeonContent, "BackdropTemplate")
            btn:SetSize(214, rowHeight)
            btn:SetBackdrop({
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = false, edgeSize = 12,
                insets = { left = 2, right = 2, top = 2, bottom = 2 }
            })

            -- Full Art Background
            btn.bg = btn:CreateTexture(nil, "BACKGROUND")
            btn.bg:SetPoint("TOPLEFT", 2, -2)
            btn.bg:SetPoint("BOTTOMRIGHT", -2, 2)
            btn.bg:SetTexCoord(0, 1, 0, 0.5) -- Crop to center

            -- Darken overlay for text readability
            btn.overlay = btn:CreateTexture(nil, "ARTWORK")
            btn.overlay:SetAllPoints(btn.bg)
            btn.overlay:SetColorTexture(0, 0, 0, 0.6)

            -- Accent indicator on left edge
            btn.accent = btn:CreateTexture(nil, "OVERLAY")
            btn.accent:SetPoint("TOPLEFT", 2, -2)
            btn.accent:SetPoint("BOTTOMLEFT", 2, 2)
            btn.accent:SetWidth(4)
            btn.accent:SetColorTexture(0.0, 0.85, 0.95, 0.0)

            btn.text = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            btn.text:SetPoint("TOPLEFT", 8, -6)
            btn.text:SetPoint("RIGHT", -36, 0)
            btn.text:SetJustifyH("LEFT")
            
            btn.levelText = btn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            btn.levelText:SetPoint("BOTTOMLEFT", 8, 6)
            btn.levelText:SetTextColor(0.8, 0.7, 0.5)

            btn.badge = btn:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            btn.badge:SetPoint("BOTTOMRIGHT", -6, 6)
            btn.badge:SetJustifyH("RIGHT")

            btn:SetScript("OnEnter", function(s)
                s.overlay:SetColorTexture(0, 0, 0, 0.4)
            end)
            btn:SetScript("OnLeave", function(s)
                if RR.charDB.selectedDungeon ~= s.dungeonKey then
                    s.overlay:SetColorTexture(0, 0, 0, 0.6)
                else
                    s.overlay:SetColorTexture(0, 0, 0, 0.2)
                end
            end)
            btn:SetScript("OnClick", function(s)
                self:SelectDungeon(s.dungeonKey)
            end)

            self.dungeonButtons[i] = btn
        end

        btn:SetPoint("TOPLEFT", 0, -((i - 1) * (rowHeight + 4)))
        btn.dungeonKey = d.key

        if d.key == RR.charDB.selectedDungeon then 
            hasCurrent = true 
            btn.overlay:SetColorTexture(0, 0, 0, 0.2)
        else
            btn.overlay:SetColorTexture(0, 0, 0, 0.6)
        end

        local artPath = RR.DungeonArt[d.key]
        if artPath then
            btn.bg:SetTexture(artPath)
            local c = RR.DungeonArtCoords[d.key]
            if c then
                btn.bg:SetTexCoord(c[1], c[2], c[3], c[4])
            else
                btn.bg:SetTexCoord(0, 1, 0, 0.5)
            end
        else
            btn.bg:SetColorTexture(0.18, 0.22, 0.30, 0.8)
        end

        local nameStr = d.name
        if d.isForeverExclusive then
            nameStr = d.name .. " |cff00e5ff*|r"
        end
        btn.text:SetText(nameStr)
        if d.recommendedLevel then
            btn.levelText:SetText(string.format("Level %d", d.recommendedLevel))
        else
            btn.levelText:SetText(string.format("Level %d - %d", d.minLevel, d.maxLevel))
        end

        local audit = RR.QuestScanner:AuditDungeon(d.key)
        if audit then
            local readyTotal = audit.activeCount + audit.readyTurninCount + audit.completedCount
            if audit.totalCount > 0 and readyTotal == audit.totalCount then
                btn.badge:SetText("|cff10b981" .. readyTotal .. "/" .. audit.totalCount .. "|r")
            elseif readyTotal > 0 then
                btn.badge:SetText(string.format("|cfff59e0b%d/%d|r", readyTotal, audit.totalCount))
            else
                btn.badge:SetText(string.format("|cff64748b0/%d|r", audit.totalCount))
            end
        else
            btn.badge:SetText("")
        end

        if d.key == RR.charDB.selectedDungeon then
            btn:SetBackdropColor(0.06, 0.16, 0.24, 0.95)
            btn:SetBackdropBorderColor(0.0, 0.85, 0.95, 1.0)
            btn.accent:SetColorTexture(0.0, 0.85, 0.95, 1.0)
        else
            btn:SetBackdropColor(0.03, 0.04, 0.06, 0.7)
            btn:SetBackdropBorderColor(0.18, 0.22, 0.28, 0.6)
            btn.accent:SetColorTexture(0.0, 0.85, 0.95, 0.0)
        end

        btn:SetScript("OnClick", function()
            Frame:SelectDungeon(d.key)
        end)
        btn:Show()
    end

    for j = #filtered + 1, #self.dungeonButtons do
        self.dungeonButtons[j]:Hide()
    end

    if autoSelectFirst and not hasCurrent and #filtered > 0 then
        self:SelectDungeon(filtered[1].key)
    end
end

function Frame:SelectDungeon(dungeonKey)
    RR.charDB.selectedDungeon = dungeonKey
    self.selectedQuestID = nil
    local audit = RR.QuestScanner:AuditDungeon(dungeonKey)
    if not audit then return end

    local d = audit.dungeon

    self.instanceTitle:SetText(d.name)
    local coordStr = d.coords and string.format("(%.1f, %.1f)", d.coords[1], d.coords[2]) or "Instance"
    local lvlStr = d.recommendedLevel and string.format("Level %d", d.recommendedLevel) or string.format("Level %d-%d", d.minLevel, d.maxLevel)
    self.instanceMeta:SetText(string.format("%s  |  Zone: %s %s  |  %s", lvlStr, d.zone, coordStr, d.faction))

    -- Update Progress Bar
    local readyTotal = audit.activeCount + audit.readyTurninCount + audit.completedCount
    local pct = audit.totalCount > 0 and math.floor((readyTotal / audit.totalCount) * 100) or 0
    self.progressBar:SetValue(pct)
    if pct >= 100 then
        self.progressBar:SetStatusBarColor(0.10, 0.80, 0.40)
    elseif pct > 0 then
        self.progressBar:SetStatusBarColor(0.95, 0.65, 0.10)
    else
        self.progressBar:SetStatusBarColor(0.30, 0.35, 0.45)
    end
    self.progressText:SetText(string.format("%d / %d Ready (%d%%)", readyTotal, audit.totalCount, pct))

    -- Update Left Sidebar Highlights
    for _, btn in ipairs(self.dungeonButtons) do
        if btn.dungeonKey == dungeonKey then
            btn:SetBackdropColor(0.06, 0.16, 0.24, 0.95)
            btn:SetBackdropBorderColor(0.0, 0.85, 0.95, 1.0)
            btn.accent:SetColorTexture(0.0, 0.85, 0.95, 1.0)
        else
            btn:SetBackdropColor(0.03, 0.04, 0.06, 0.7)
            btn:SetBackdropBorderColor(0.18, 0.22, 0.28, 0.6)
            btn.accent:SetColorTexture(0.0, 0.85, 0.95, 0.0)
        end
    end

    self:RefreshActiveScreen()
end

-- ====================================================
-- REWARD THUMBNAILS ENGINE
-- ====================================================
function Frame:GetRewardButton(parent, index)
    if not parent.rewardButtons then
        parent.rewardButtons = {}
    end
    local btn = parent.rewardButtons[index]
    if not btn then
        btn = CreateFrame("Button", nil, parent)
        btn:SetSize(24, 24)

        btn.icon = btn:CreateTexture(nil, "ARTWORK")
        btn.icon:SetAllPoints(btn)
        btn.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)

        local hl = btn:CreateTexture(nil, "HIGHLIGHT")
        hl:SetAllPoints(btn)
        hl:SetColorTexture(1.0, 1.0, 1.0, 0.25)

        parent.rewardButtons[index] = btn
    end
    return btn
end

function Frame:RenderRewardThumbnails(node, rewards)
    if node.rewardButtons then
        for _, btn in ipairs(node.rewardButtons) do
            btn:Hide()
        end
    end

    if not rewards or #rewards == 0 then return end

    local thumbSpacing = 4
    for rIdx, rew in ipairs(rewards) do
        local rBtn = self:GetRewardButton(node, rIdx)
        rBtn:ClearAllPoints()
        
        -- Anchor in a horizontal row above the status badge
        if rIdx == 1 then
            rBtn:SetPoint("BOTTOMRIGHT", -8, 24)
        else
            rBtn:SetPoint("RIGHT", node.rewardButtons[rIdx - 1], "LEFT", -thumbSpacing, 0)
        end

        local icon = rew.icon
        local itemID = rew.itemID
        if not icon or icon == "" then
            if itemID and itemID > 0 then
                if C_Item and C_Item.RequestLoadItemDataByID then
                    pcall(C_Item.RequestLoadItemDataByID, itemID)
                end
                if C_Item and C_Item.GetItemInfoInstant then
                    local _, _, _, _, instIcon = C_Item.GetItemInfoInstant(itemID)
                    if instIcon then icon = instIcon end
                end
                if not icon and GetItemIcon then
                    icon = GetItemIcon(itemID)
                end
            end
            if not icon then
                icon = "Interface\\Icons\\INV_Misc_QuestionMark"
            end
        end
        rBtn.icon:SetTexture(icon)

        local itemID = rew.itemID
        local itemName = rew.name
        rBtn:SetScript("OnEnter", function(self)
            GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
            local hasLoaded = false
            if itemID and itemID > 0 then
                if C_Item and C_Item.RequestLoadItemDataByID then
                    pcall(C_Item.RequestLoadItemDataByID, itemID)
                end
                local _, itemLink = GetItemInfo(itemID)
                if itemLink then
                    GameTooltip:SetHyperlink(itemLink)
                    hasLoaded = true
                else
                    GameTooltip:SetHyperlink("item:" .. itemID)
                    hasLoaded = true
                end
            end
            if not hasLoaded then
                GameTooltip:AddLine(itemName or "Quest Reward", r, g, b)
                if itemID then
                    GameTooltip:AddLine("Item ID: " .. tostring(itemID), 0.5, 0.5, 0.5)
                end
            end

            GameTooltip:AddLine("|cff64748bShift-click to link in chat|r", 0.7, 0.7, 0.7)
            GameTooltip:Show()
        end)
        rBtn:SetScript("OnLeave", function()
            GameTooltip:Hide()
        end)

        rBtn:SetScript("OnClick", function()
            if IsShiftKeyDown() and ChatEdit_InsertLink and itemID then
                local _, itemLink = GetItemInfo(itemID)
                if itemLink then
                    ChatEdit_InsertLink(itemLink)
                else
                    ChatEdit_InsertLink("item:" .. itemID)
                end
            end
        end)

        rBtn:Show()
    end
end

function Frame:RefreshActiveScreen()
    self.screenScroll:SetVerticalScroll(0)
    self:ClearLines()
    if self.flowStepNodes then
        for _, n in ipairs(self.flowStepNodes) do n:Hide() end
    end
    if self.flowChainHeaders then
        for _, h in ipairs(self.flowChainHeaders) do h:Hide() end
    end
    if self.flowSummaryBar then self.flowSummaryBar:Hide() end
    if self.flowEmptyText then self.flowEmptyText:Hide() end
    if self.backBtn then self.backBtn:Hide() end
    if self.detailTitle then self.detailTitle:Hide() end
    for _, g in ipairs(self.giverCards) do g:Hide() end
    for _, dn in ipairs(self.detailNodes) do dn:Hide() end
    for _, r in ipairs(self.partyRows) do r:Hide() end
    for _, k in ipairs(self.keyCards) do k:Hide() end

    if self.activeScreen == "QUESTS" then
        if self.selectedQuestID then
            self:RenderChainDetail() -- Detail View
        else
            self:RenderQuestOverview() -- Master View
        end
    elseif self.activeScreen == "PARTY" then
        self:RenderPartySync()
    elseif self.activeScreen == "KEYS" then
        if self.selectedKeyID then
            self:RenderKeyDetail()
        else
            self:RenderKeys()
        end
    end
end

function Frame:GetStepNode(index)
    if not self.flowStepNodes then self.flowStepNodes = {} end
    local node = self.flowStepNodes[index]
    if not node then
        node = CreateFrame("Button", nil, self.screenContent, "BackdropTemplate")
        node:SetBackdrop({
            bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 10,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })

        node.questIcon = node:CreateTexture(nil, "ARTWORK")
        node.questIcon:SetSize(28, 28)
        node.questIcon:SetPoint("TOPLEFT", 8, -8)

        node.title = node:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        node.title:SetPoint("TOPLEFT", node.questIcon, "TOPRIGHT", 8, 0)
        node.title:SetPoint("RIGHT", node, "RIGHT", -8, 0)
        node.title:SetJustifyH("LEFT")
        node.title:SetJustifyV("TOP")
        node.title:SetWordWrap(true)
        node.title:SetSpacing(2)

        node.location = node:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        node.location:SetPoint("TOPLEFT", node.title, "BOTTOMLEFT", 0, -6)
        node.location:SetPoint("RIGHT", node, "RIGHT", -8, 0)
        node.location:SetJustifyH("LEFT")
        node.location:SetJustifyV("TOP")
        node.location:SetTextColor(0.65, 0.75, 0.85)
        node.location:SetWordWrap(true)
        node.location:SetSpacing(2)

        node.phaseBadge = node:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        node.phaseBadge:SetPoint("BOTTOMLEFT", node, "BOTTOMLEFT", 8, 8)
        node.phaseBadge:SetJustifyH("LEFT")

        node.statusBadge = node:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        node.statusBadge:SetPoint("BOTTOMRIGHT", node, "BOTTOMRIGHT", -8, 8)
        node.statusBadge:SetJustifyH("RIGHT")

        self.flowStepNodes[index] = node
    end
    return node
end

function Frame:GetSummaryBar()
    if not self.flowSummaryBar then
        local bar = CreateFrame("Frame", nil, self.screenContent, "BackdropTemplate")
        bar:SetSize(890, 36)
        bar:SetBackdrop({
            bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 8,
            insets = { left = 2, right = 2, top = 2, bottom = 2 }
        })
        bar:SetBackdropColor(0.03, 0.05, 0.08, 0.95)
        bar:SetBackdropBorderColor(0.0, 0.85, 0.95, 0.8)

        bar.readiness = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        bar.readiness:SetPoint("LEFT", 12, 0)
        bar.readiness:SetJustifyH("LEFT")

        bar.lockout = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        bar.lockout:SetPoint("RIGHT", -12, 0)
        bar.lockout:SetJustifyH("RIGHT")

        self.flowSummaryBar = bar
    end
    return self.flowSummaryBar
end

-- ====================================================
-- SCREEN 1: PRE-QUEST CHAIN FLOWCHART (Natural Chains Engine)
-- Explicit WHAT and WHEN with NO branch length normalization
-- ====================================================
function Frame:RenderFlowchart()
    local audit = RR.QuestScanner:AuditDungeon(RR.charDB.selectedDungeon)
    if not audit then return end

    local d = audit.dungeon
    local chains = audit.chains or {}
    local numChains = #chains

    if self.selectedQuestID then
        local filtered = {}
        for _, ch in ipairs(chains) do
            local hasMatch = false
            for _, step in ipairs(ch.steps) do
                if step.data.questID == self.selectedQuestID then
                    hasMatch = true
                    break
                end
            end
            if hasMatch then
                table.insert(filtered, ch)
            end
        end
        chains = filtered
        numChains = #chains
    end

    if numChains == 0 then
        if not self.flowEmptyText then
            self.flowEmptyText = self.screenContent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            self.flowEmptyText:SetPoint("TOPLEFT", 30, -70)
            self.flowEmptyText:SetWidth(460)
            self.flowEmptyText:SetJustifyH("LEFT")
            self.flowEmptyText:SetText("|cff94a3b8No pre-requisite quests or external attunements required for this dungeon.\nYou can head directly inside!|r")
        end
        self.flowEmptyText:Show()
        return
    else
        if self.flowEmptyText then self.flowEmptyText:Hide() end
    end

    -- Top Summary & Lockout Bar
    local sumBar = self:GetSummaryBar()

    if self.selectedQuestID then
        if not self.backBtn then
            self.backBtn = CreateFrame("Button", nil, self.screenContent, "UIPanelButtonTemplate")
            self.backBtn:SetSize(120, 26)
            self.backBtn:SetText("< Back to Quests")
            self.backBtn:SetScript("OnClick", function()
                Frame.selectedQuestID = nil
                Frame:RefreshActiveScreen()
            end)
        end
        self.backBtn:Show()
        self.backBtn:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", 14, -6)
        sumBar:SetPoint("TOPLEFT", self.backBtn, "BOTTOMLEFT", 0, -6)
    else
        if self.backBtn then self.backBtn:Hide() end
        sumBar:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", 14, -6)
    end

    -- Lockout Detection
    local isLocked = false
    local resetStr = nil
    for instIdx = 1, GetNumSavedInstances() do
        local name, id, reset, diff, locked = GetSavedInstanceInfo(instIdx)
        if name == d.name or (d.instanceName and name == d.instanceName) then
            if locked then
                isLocked = true
                resetStr = RR.Utils:FormatResetTime(reset)
                break
            end
        end
    end

    local readyTotal = audit.activeCount + audit.readyTurninCount + audit.completedCount
    local pct = audit.totalCount > 0 and math.floor((readyTotal / audit.totalCount) * 100) or 0
    local readinessBadge = "|cff38bdf8[IN PROGRESS]|r"
    if audit.totalCount > 0 and audit.completedCount == audit.totalCount then
        readinessBadge = "|cff10b981[ALL COMPLETED]|r"
    elseif audit.totalCount > 0 and readyTotal == audit.totalCount then
        readinessBadge = "|cff10b981[READY FOR DUNGEON]|r"
    end

    sumBar.readiness:SetText(string.format("%s  |cffffffffReadiness:|r %d / %d Quests Ready (%d%%)  |  |cff94a3b8%d Active Chains|r",
        readinessBadge, readyTotal, audit.totalCount, pct, numChains))

    if isLocked then
        sumBar:SetBackdropColor(0.18, 0.05, 0.05, 0.98)
        sumBar:SetBackdropBorderColor(0.85, 0.25, 0.25, 1.0)
        sumBar.lockout:SetText(resetStr and ("|cffef4444Instance Locked (Resets in " .. resetStr .. ")|r") or "|cffef4444Instance Locked|r")
    else
        sumBar:SetBackdropColor(0.03, 0.05, 0.08, 0.95)
        sumBar:SetBackdropBorderColor(0.0, 0.85, 0.95, 0.8)
        sumBar.lockout:SetText("|cff10b981Lockout: Available (Unsaved)|r")
    end
    sumBar:Show()

    -- Masonry Layout Dimensions (Chains in side-by-side columns)
    local nodeWidth = 420
    local nodeHeight = 110
    local nodeGap = 28
    local chainColWidth = 420
    local chainColGap = 24
    local chainHeaderHeight = 24
    
    local startY = self.selectedQuestID and -90 or -52
    local maxWidth = 900
    local maxCols = math.floor(maxWidth / (chainColWidth + chainColGap))
    if maxCols < 1 then maxCols = 1 end

    local colY = {}
    for i=1, maxCols do colY[i] = startY end

    local globalNodeIdx = 0

    for cIdx, ch in ipairs(chains) do
        -- Find the shortest column
        local shortestCol = 1
        local shortestY = colY[1]
        for i=2, maxCols do
            if colY[i] > shortestY then -- > because Y is negative, closer to 0 is higher
                shortestCol = i
                shortestY = colY[i]
            end
        end

        local startX = 14 + (shortestCol - 1) * (chainColWidth + chainColGap)
        local currentY = shortestY

        -- Chain Section Header
        local chHeader = self.flowChainHeaders[cIdx]
        if not chHeader then
            chHeader = self.screenContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            chHeader:SetJustifyH("LEFT")
            self.flowChainHeaders[cIdx] = chHeader
        end
        chHeader:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", startX, currentY)
        chHeader:SetWidth(chainColWidth)

        local factionTag = ""
        if ch.faction == "Horde" then
            factionTag = "|cffef4444[Horde]|r "
        elseif ch.faction == "Alliance" then
            factionTag = "|cff3b82f6[Alliance]|r "
        end

        local statusTag = string.format("|cff64748b[%d Steps]|r", ch.totalSteps)
        if ch.isComplete then
            statusTag = "|cff10b981[ALL COMPLETE]|r"
        elseif ch.completedSteps and ch.completedSteps > 0 then
            statusTag = string.format("|cfff59e0b[%d/%d Complete]|r", ch.completedSteps, ch.totalSteps)
        end

        chHeader:SetText(string.format("%s|cffffffffChain %d: %s|r  %s", factionTag, cIdx, ch.name, statusTag))
        chHeader:Show()

        currentY = currentY - chainHeaderHeight - 8

        local prevNodeX, prevNodeY = nil, nil

        -- Render Steps for this Chain
        for sIdx, sEntry in ipairs(ch.steps) do
            local s = sEntry.data
            local status = sEntry.status
            local stepMeta = RR.Utils:GetStatusMeta(status)
            
            local nodeX = startX
            local nodeY = currentY

            globalNodeIdx = globalNodeIdx + 1
            local node = self:GetStepNode(globalNodeIdx)
            node:SetSize(nodeWidth, nodeHeight)
            node:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", nodeX, nodeY)

            -- Vertical Arrow Connector from Previous Step
            if prevNodeX and prevNodeY then
                local lr, lg, lb, la = 0.25, 0.30, 0.40, 0.6
                if status == "COMPLETED" then
                    lr, lg, lb, la = 0.10, 0.80, 0.40, 0.9
                elseif status == "ACTIVE" or status == "READY_TURNIN" then
                    lr, lg, lb, la = 0.95, 0.65, 0.10, 0.9
                end

                local line = self:GetLine(self.screenContent)
                line:SetColorTexture(lr, lg, lb, la)
                -- Line goes from bottom of previous node to top of current node
                local lineX = nodeX + 32 -- centered under icon
                local lineY1 = prevNodeY - nodeHeight
                line:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", lineX, lineY1)
                line:SetSize(2, nodeGap)
                line:Show()
            end

            -- Card Background Styling by Status
            if status == "COMPLETED" then
                node:SetBackdropColor(0.03, 0.12, 0.06, 0.95)
                node:SetBackdropBorderColor(0.16, 0.75, 0.35, 0.9)
            elseif status == "READY_TURNIN" then
                node:SetBackdropColor(0.08, 0.14, 0.05, 0.95)
                node:SetBackdropBorderColor(0.30, 0.85, 0.20, 1.0)
            elseif status == "ACTIVE" then
                node:SetBackdropColor(0.12, 0.09, 0.03, 0.95)
                node:SetBackdropBorderColor(0.95, 0.65, 0.15, 0.9)
            elseif status == "AVAILABLE" then
                node:SetBackdropColor(0.03, 0.06, 0.10, 0.95)
                node:SetBackdropBorderColor(0.20, 0.30, 0.40, 0.7)
            else
                node:SetBackdropColor(0.05, 0.05, 0.05, 0.7)
                node:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.5)
            end

            local phaseBadgeText = "|cff00e5ff[PRE-DUNGEON]|r"
            if s.phase == "IN-DUNGEON" then
                phaseBadgeText = "|cff3b82f6[IN-DUNGEON]|r"
            elseif s.phase == "ITEM DROP" then
                phaseBadgeText = "|cfff59e0b[ITEM DROP]|r"
            end
            node.phaseBadge:SetText(phaseBadgeText)

            -- Top Badge 2: Status
            node.statusBadge:SetText("|cff" .. stepMeta.color .. "[" .. stepMeta.label .. "]|r")

            -- Title
            node.title:SetText(s.title or ("Quest #" .. tostring(s.questID or "???")))
            
            local who = s.pickupNPC
            local where = s.pickupLocation
            if status == "READY_TURNIN" or status == "COMPLETED" then
                who = s.turninNPC or who
                where = s.turninLocation or where
            end
            local coords = (status == "READY_TURNIN" or status == "COMPLETED") and s.turninCoords or s.pickupCoords

            node.location:SetText(string.format("Contact: %s\nLocation: %s", who or "Unknown", where or "World"))

            -- Quest Icon
            if s.phase == "ITEM DROP" then
                node.questIcon:SetTexture("Interface\\\\Icons\\\\INV_Misc_Bag_10")
            elseif s.phase == "IN-DUNGEON" then
                node.questIcon:SetTexture("Interface\\\\Icons\\\\Spell_Frost_Stun")
            else
                node.questIcon:SetTexture("Interface\\\\Icons\\\\Quest_Available")
            end

            -- Render Verified Reward Thumbnails
            self:RenderRewardThumbnails(node, s.rewards)

            -- Tooltip & Waypoint Interaction
            node:SetScript("OnEnter", function(selfRef)
                GameTooltip:SetOwner(selfRef, "ANCHOR_TOPLEFT")
                GameTooltip:AddLine(s.title or "Quest Step", 1, 1, 1)
                GameTooltip:AddLine(string.format("Chain: %s (Step %d of %d)", ch.name, sIdx, #ch.steps), 0.7, 0.8, 0.9)
                GameTooltip:AddLine("Phase: " .. (s.phase or "QUEST"), 1, 0.8, 0.2)
                GameTooltip:AddLine("Status: " .. stepMeta.label, stepMeta.r, stepMeta.g, stepMeta.b)
                if sEntry.statusNote and sEntry.statusNote ~= "" then
                    GameTooltip:AddLine("Note: " .. sEntry.statusNote, 0.9, 0.4, 0.4)
                end
                if s.action then
                    GameTooltip:AddLine("Action: " .. s.action, 0.8, 0.8, 0.8, true)
                end
                if who or where then
                    GameTooltip:AddLine(string.format("Contact: %s (%s)", who, where), 0.5, 0.8, 1.0)
                end
                if coords then
                    GameTooltip:AddLine(string.format("Coordinates: %.1f, %.1f", coords[1], coords[2]), 0.6, 0.6, 0.6)
                    GameTooltip:AddLine("|cff00e5ffClick to set waypoint|r", 0, 0.9, 1)
                end
                GameTooltip:Show()
            end)
            node:SetScript("OnLeave", function() GameTooltip:Hide() end)
            node:SetScript("OnClick", function()
                if coords then
                    local locStr = (status == "READY_TURNIN") and (s.turninNPC or s.turninLocation) or (s.pickupNPC or s.pickupLocation)
                    local mapID = s.pickupMapID or RR.Utils:GetMapIDFromZone(locStr) or RR.Utils:GetMapIDFromZone(s.pickupLocation) or d.mapID
                    if mapID then
                        RR.Utils:SetWaypoint(mapID, coords[1], coords[2], s.title)
                    end
                end
            end)

            node:Show()

            prevNodeX = nodeX
            prevNodeY = nodeY

            currentY = currentY - nodeHeight - nodeGap
        end
        
        -- Update column height
        colY[shortestCol] = currentY - 40 -- bottom padding before next chain in this col
    end
    
    local finalY = colY[1]
    for i=2, maxCols do
        if colY[i] < finalY then
            finalY = colY[i]
        end
    end
    self.screenContent:SetHeight(math.max(math.abs(finalY) + 40, 520))
    self.screenContent:SetWidth(920)

    -- Hide Unused Step Nodes from Pool
    if self.flowStepNodes then
        for i = globalNodeIdx + 1, #self.flowStepNodes do
            self.flowStepNodes[i]:Hide()
        end
    end
    -- Hide Unused Chain Headers
    if self.flowChainHeaders then
        for i = numChains + 1, #self.flowChainHeaders do
            self.flowChainHeaders[i]:Hide()
        end
    end
end

-- ====================================================
-- ====================================================
-- SCREEN 2: ACTIVE QUEST GIVERS DIRECTORY
-- ====================================================
function Frame:RenderQuestOverview()
    local audit = RR.QuestScanner:AuditDungeon(RR.charDB.selectedDungeon)
    if not audit then return end

    local d = audit.dungeon

    table.sort(audit.quests, function(a, b)
        local lvlA = a.data.minLevel or 0
        local lvlB = b.data.minLevel or 0
        if lvlA == lvlB then
            return a.data.title < b.data.title
        end
        return lvlA < lvlB
    end)

    local cardHeight = 72
    local cardWidth = 890
    self.screenContent:SetHeight(math.max(#audit.quests * (cardHeight + 4) + 30, 480))

    -- Ensure we hide old giver cards
    for _, g in ipairs(self.giverCards) do g:Hide() end

    for i, qEntry in ipairs(audit.quests) do
        local q = qEntry.data
        local card = self.giverCards[i]
        if not card then
            card = CreateFrame("Button", nil, self.screenContent)
            card:SetSize(cardWidth, cardHeight)
            
            card.bg = card:CreateTexture(nil, "BACKGROUND")
            card.bg:SetAllPoints()
            card.bg:SetColorTexture(1, 1, 1, 0.0)
            
            card.divider = card:CreateTexture(nil, "ARTWORK")
            card.divider:SetPoint("BOTTOMLEFT", 4, 0)
            card.divider:SetPoint("BOTTOMRIGHT", -4, 0)
            card.divider:SetHeight(1)
            card.divider:SetColorTexture(1, 1, 1, 0.05)

            card:SetScript("OnEnter", function(self)
                self.bg:SetColorTexture(1, 1, 1, 0.04)
            end)
            card:SetScript("OnLeave", function(self)
                self.bg:SetColorTexture(1, 1, 1, 0.0)
            end)

            card.icon = card:CreateTexture(nil, "ARTWORK")
            card.icon:SetSize(32, 32)
            card.icon:SetPoint("TOPLEFT", 12, -12)

            card.title = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            card.title:SetPoint("TOPLEFT", card.icon, "TOPRIGHT", 12, 0)
            card.title:SetTextColor(1, 0.82, 0)

            card.coords = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            card.coords:SetPoint("TOPRIGHT", -120, -12)
            card.coords:SetTextColor(0.0, 0.85, 0.95)

            card.loc = card:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            card.loc:SetPoint("TOPLEFT", card.icon, "TOPRIGHT", 12, -18)

            card.quest = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            card.quest:SetPoint("TOPLEFT", card.icon, "TOPRIGHT", 12, -34)
            card.quest:SetTextColor(0.16, 0.85, 0.45)

            card.wptBtn = CreateFrame("Button", nil, card, "UIPanelButtonTemplate")
            card.wptBtn:SetSize(90, 22)
            card.wptBtn:SetPoint("TOPRIGHT", -10, -10)
            card.wptBtn:SetText("Waypoint")

            card.rewardIcons = {}
            for j = 1, 4 do
                local riBtn = CreateFrame("Button", nil, card)
                riBtn:SetSize(28, 28)
                riBtn:SetPoint("BOTTOMRIGHT", card, "BOTTOMRIGHT", -12 - ((j-1)*32), 12)
                riBtn:Hide()
                
                riBtn.icon = riBtn:CreateTexture(nil, "ARTWORK")
                riBtn.icon:SetAllPoints()
                
                riBtn:SetScript("OnEnter", function(self)
                    if self.itemLink or self.itemID then
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        if self.itemLink then
                            GameTooltip:SetHyperlink(self.itemLink)
                        else
                            GameTooltip:SetItemByID(self.itemID)
                              if Item and Item.CreateFromItemID then local itm = Item:CreateFromItemID(self.itemID) if not itm:IsItemDataCached() then itm:ContinueOnItemLoad(function() if GameTooltip:GetOwner() == self then GameTooltip:SetItemByID(self.itemID) GameTooltip:Show() end end) end end
                        end
                        GameTooltip:Show()
                    end
                end)
                riBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
                
                card.rewardIcons[j] = riBtn
            end

            self.giverCards[i] = card
        end

        card:SetSize(cardWidth, cardHeight)
        card:SetPoint("TOPLEFT", 10, -((i - 1) * (cardHeight + 4)))
        if qEntry.isChain and qEntry.actualActiveTitle and qEntry.actualActiveTitle ~= q.title then
            card.title:SetText(q.title .. " |cff999999(Lead-in: " .. qEntry.actualActiveTitle .. ")|r")
        else
            card.title:SetText(q.title)
        end
        
        local pickupStr = q.pickupNPC or "Unknown"
        local locStr = q.pickupLocation or "Outside"
        card.loc:SetText(pickupStr .. " (" .. locStr .. ")")
        
        if q.pickupCoords and q.pickupCoords[1] and q.pickupCoords[2] then
            card.coords:SetText(string.format("(%.1f, %.1f)", q.pickupCoords[1], q.pickupCoords[2]))
        else
            card.coords:SetText("")
        end
        card.quest:SetText(q.action or q.note or "")

        card:SetScript("OnClick", function()
            Frame.selectedQuestID = q.questID
            Frame:RefreshActiveScreen()
        end)

        if q.pickupCoords and q.pickupCoords[1] and q.pickupCoords[2] then
            card.wptBtn:Show()
            card.wptBtn:SetScript("OnClick", function()
                local npcName = q.pickupNPC or q.title
                local mapID = RR.Utils:GetMapIDFromZone(npcName) or d.mapID
                RR.Utils:SetWaypoint(mapID, q.pickupCoords[1], q.pickupCoords[2], q.title)
            end)
        else
            card.wptBtn:Hide()
        end

        for j = 1, 4 do card.rewardIcons[j]:Hide() end
        if q.rewards then
            for j, r in ipairs(q.rewards) do
                if j <= 4 then
                    local riBtn = card.rewardIcons[j]
                    riBtn:Show()
                    riBtn.itemID = r.itemID
                    riBtn.itemLink = r.itemLink
                    riBtn.icon:SetTexture("Interface\\Icons\\INV_Box_01")
                    if r.icon then
                        riBtn.icon:SetTexture(r.icon)
                    elseif C_Item and C_Item.GetItemIconByID then
                        riBtn.icon:SetTexture(C_Item.GetItemIconByID(r.itemID))
                    elseif GetItemIcon then
                        riBtn.icon:SetTexture(GetItemIcon(r.itemID))
                    end
                end
            end
        end

        if qEntry.status == "COMPLETED" then
            card.icon:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready")
        elseif qEntry.status == "ACTIVE" then
            card.icon:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon")
        else
            card.icon:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon")
        end

        card:Show()
    end
    
    self.screenScroll:UpdateScrollChildRect()
end

-- ====================================================
-- SCREEN 3: PARTY SYNC MATRIX (From Mockup)
-- ====================================================
function Frame:RenderChainDetail()
    local audit = RR.QuestScanner:AuditDungeon(RR.charDB.selectedDungeon)
    if not audit then return end

    local targetChain = nil
    for _, ch in ipairs(audit.chains or {}) do
        for _, step in ipairs(ch.steps) do
            if step.data.questID == self.selectedQuestID then
                targetChain = ch
                break
            end
        end
        if targetChain then break end
    end

    if not targetChain then return end

    if not self.backBtn then
        self.backBtn = CreateFrame("Button", nil, self.screenContent, "UIPanelButtonTemplate")
        self.backBtn:SetSize(120, 26)
        self.backBtn:SetText("< Back to Quests")
        self.backBtn:SetScript("OnClick", function()
            Frame.selectedQuestID = nil
            Frame:RefreshActiveScreen()
        end)
    end
    self.backBtn:Show()
    self.backBtn:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", 14, -6)

    local currentY = -48
    
    if not self.detailTitle then
        self.detailTitle = self.screenContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
        self.detailTitle:SetPoint("TOPLEFT", 14, currentY)
    end
    self.detailTitle:Show()
    self.detailTitle:SetText("|cffffd100" .. targetChain.name .. "|r")
    
    currentY = currentY - 32
    local width = 880

    for i, stepEntry in ipairs(targetChain.steps) do
        local q = stepEntry.data
        local node = self.detailNodes[i]
        if not node then
            node = CreateFrame("Frame", nil, self.screenContent)
            node:SetWidth(width)
            
            node.divider = node:CreateTexture(nil, "ARTWORK")
            node.divider:SetPoint("TOPLEFT", 0, 0)
            node.divider:SetPoint("TOPRIGHT", 0, 0)
            node.divider:SetHeight(1)
            node.divider:SetColorTexture(1, 1, 1, 0.05)

            node.title = node:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            node.title:SetPoint("TOPLEFT", 12, -16)
            node.title:SetTextColor(1, 0.82, 0)
            
            node.reqs = node:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            node.reqs:SetPoint("TOPLEFT", node.title, "BOTTOMLEFT", 0, -4)
            
            node.icon = node:CreateTexture(nil, "ARTWORK")
            node.icon:SetSize(24, 24)
            node.icon:SetPoint("TOPRIGHT", -12, -16)
            
            node.objLbl = node:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            node.objLbl:SetPoint("TOPLEFT", 12, -50)
            node.objLbl:SetText("Objective")
            
            node.objText = node:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            node.objText:SetPoint("TOPLEFT", node.objLbl, "BOTTOMLEFT", 0, -4)
            node.objText:SetWidth(600)
            node.objText:SetJustifyH("LEFT")
            
            node.startLbl = node:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            node.startLbl:SetPoint("TOPLEFT", 12, -100)
            node.startLbl:SetText("Starts at")
            
            node.startText = node:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            node.startText:SetPoint("TOPLEFT", node.startLbl, "BOTTOMLEFT", 0, -4)

            node.rewardIcons = {}
            for j = 1, 4 do
                local riBtn = CreateFrame("Button", nil, node)
                riBtn:SetSize(28, 28)
                riBtn:SetPoint("TOPLEFT", node.startText, "BOTTOMLEFT", (j-1)*32, -8)
                riBtn:Hide()
                
                riBtn.icon = riBtn:CreateTexture(nil, "ARTWORK")
                riBtn.icon:SetAllPoints()
                
                riBtn:SetScript("OnEnter", function(self)
                    if self.itemLink or self.itemID then
                        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                        if self.itemLink then
                            GameTooltip:SetHyperlink(self.itemLink)
                        else
                            GameTooltip:SetItemByID(self.itemID)
                              if Item and Item.CreateFromItemID then local itm = Item:CreateFromItemID(self.itemID) if not itm:IsItemDataCached() then itm:ContinueOnItemLoad(function() if GameTooltip:GetOwner() == self then GameTooltip:SetItemByID(self.itemID) GameTooltip:Show() end end) end end
                        end
                        GameTooltip:Show()
                    end
                end)
                riBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
                
                node.rewardIcons[j] = riBtn
            end

            self.detailNodes[i] = node
        end

        node:SetPoint("TOPLEFT", 14, currentY)
        node.title:SetText(q.title)
        
        local reqStr = ""
        if q.minLevel then reqStr = reqStr .. "Available from Level " .. q.minLevel .. "   " end
        if targetChain.faction == "Alliance" then reqStr = reqStr .. "|TInterface\\Timer\\Alliance-Logo:14|t "
        elseif targetChain.faction == "Horde" then reqStr = reqStr .. "|TInterface\\Timer\\Horde-Logo:14|t " end
        node.reqs:SetText(reqStr)

        if stepEntry.status == "COMPLETED" then
            node.icon:SetTexture("Interface\\RAIDFRAME\\ReadyCheck-Ready")
        elseif stepEntry.status == "ACTIVE" then
            node.icon:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon")
        else
            node.icon:SetTexture("Interface\\GossipFrame\\AvailableQuestIcon")
        end
        
        node.objText:SetText(q.action or q.note or "")
        
        local pickupStr = q.pickupNPC or "Unknown"
        local locStr = q.pickupLocation or "Outside"
        node.startText:SetText(pickupStr .. " (" .. locStr .. ")")
        
        local nodeHeight = 130
        for j = 1, 4 do node.rewardIcons[j]:Hide() end
        if q.rewards and #q.rewards > 0 then
            nodeHeight = 160
            for j, r in ipairs(q.rewards) do
                if j <= 4 then
                    local riBtn = node.rewardIcons[j]
                    riBtn:Show()
                    riBtn.itemID = r.itemID
                    riBtn.itemLink = r.itemLink
                    riBtn.icon:SetTexture("Interface\\Icons\\INV_Box_01")
                    if r.icon then
                        riBtn.icon:SetTexture(r.icon)
                    elseif C_Item and C_Item.GetItemIconByID then
                        riBtn.icon:SetTexture(C_Item.GetItemIconByID(r.itemID))
                    elseif GetItemIcon then
                        riBtn.icon:SetTexture(GetItemIcon(r.itemID))
                    end
                end
            end
        end
        
        node:SetHeight(nodeHeight)
        node:Show()
        
        currentY = currentY - nodeHeight - 16
    end

    self.screenContent:SetHeight(math.abs(currentY) + 30)
    self.screenScroll:UpdateScrollChildRect()
end

function Frame:RenderPartySync()
    local audit = RR.QuestScanner:AuditDungeon(RR.charDB.selectedDungeon)
    if not audit then return end

    local d = audit.dungeon
    local roster = {}
    table.insert(roster, {
        unit = "player",
        name = UnitName("player"),
        class = select(2, UnitClass("player")),
        level = UnitLevel("player"),
        isPlayer = true,
    })

    local numMembers = GetNumGroupMembers() or 0
    local isRaid = IsInRaid()
    if IsInGroup() then
        local count = isRaid and numMembers or (numMembers - 1)
        for i = 1, count do
            local u = isRaid and ("raid" .. i) or ("party" .. i)
            if UnitExists(u) and not UnitIsUnit(u, "player") then
                table.insert(roster, {
                    unit = u,
                    name = UnitName(u),
                    class = select(2, UnitClass(u)),
                    level = UnitLevel(u),
                    isPlayer = false,
                })
            end
        end
    end

    local rowHeight = 40
    local rowWidth = 890
    self.screenContent:SetHeight(math.max(#roster * (rowHeight + 6) + 40, 480))

    for i, m in ipairs(roster) do
        local row = self.partyRows[i]
        if not row then
            row = CreateFrame("Frame", nil, self.screenContent, "BackdropTemplate")
            row:SetSize(rowWidth, rowHeight)
            row:SetBackdrop({
                bgFile = "Interface\\FrameGeneral\\UI-Background-Rock",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = true, tileSize = 16, edgeSize = 8,
                insets = { left = 2, right = 2, top = 2, bottom = 2 }
            })

            row.classTag = row:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            row.classTag:SetPoint("LEFT", 12, 0)
            row.classTag:SetWidth(85)
            row.classTag:SetJustifyH("LEFT")

            row.nameText = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            row.nameText:SetPoint("LEFT", row.classTag, "RIGHT", 8, 0)
            row.nameText:SetWidth(140)
            row.nameText:SetJustifyH("LEFT")

            row.readinessText = row:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            row.readinessText:SetPoint("LEFT", row.nameText, "RIGHT", 8, 0)
            row.readinessText:SetWidth(120)
            row.readinessText:SetJustifyH("LEFT")

            row.missingText = row:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            row.missingText:SetPoint("LEFT", row.readinessText, "RIGHT", 8, 0)
            row.missingText:SetPoint("RIGHT", -90, 0)
            row.missingText:SetJustifyH("LEFT")

            row.pushBtn = CreateFrame("Button", nil, row, "UIPanelButtonTemplate")
            row.pushBtn:SetSize(75, 22)
            row.pushBtn:SetPoint("RIGHT", -8, 0)
            row.pushBtn:SetText("Push")

            self.partyRows[i] = row
        end

        row:SetSize(rowWidth, rowHeight)
        row:SetPoint("TOPLEFT", 10, -((i - 1) * (rowHeight + 6)))
        row:SetBackdropColor(0.03, 0.04, 0.07, 0.85)
        row:SetBackdropBorderColor(0.20, 0.25, 0.35, 0.75)

        local colorStr = RAID_CLASS_COLORS and RAID_CLASS_COLORS[m.class] and RAID_CLASS_COLORS[m.class].colorStr or "ffffffff"
        row.classTag:SetText(string.format("|c%s[%s]|r", colorStr, m.class or "PLAYER"))
        row.nameText:SetText(m.name or "Unknown")

        if m.isPlayer and audit then
            local readyTotal = audit.activeCount + audit.readyTurninCount + audit.completedCount
            row.readinessText:SetText(string.format("|cff10b981%d/%d Ready|r", readyTotal, audit.totalCount))
            row.missingText:SetText("|cff10b981All Quests Acquired|r")
            row.pushBtn:Hide()
        else
            row.readinessText:SetText("|cfff59e0bPending|r")
            row.missingText:SetText("|cff94a3b8Awaiting Addon Sync|r")
            row.pushBtn:Show()
            row.pushBtn:SetScript("OnClick", function()
                RR:ShareCurrentDungeonQuests(d.key)
            end)
        end

        row:Show()
    end
    self.screenScroll:UpdateScrollChildRect()
end

-- ====================================================
-- SCREEN 4: KEYS & DUNGEON LOCKS
-- ====================================================
function Frame:RenderKeys()
    local audit = RR.QuestScanner:AuditDungeon(RR.charDB.selectedDungeon)
    local dName = audit and audit.dungeon.name or ""

    local keysList = {}
    for itemID, info in pairs(RR.KeysData or {}) do
        local isMatch = dName:find(info.dungeon) or info.dungeon:find(dName)
        table.insert(keysList, {
            itemID = itemID,
            name = info.name,
            dungeon = info.dungeon,
            source = info.source,
            note = info.note,
            hasKey = RR:HasKey(itemID),
            isCurrent = isMatch,
        })
    end

    table.sort(keysList, function(a, b)
        if a.isCurrent and not b.isCurrent then return true end
        if not a.isCurrent and b.isCurrent then return false end
        return a.name < b.name
    end)

    local cardHeight = 68
    local cardWidth = 890
    self.screenContent:SetHeight(math.max(#keysList * (cardHeight + 6) + 30, 480))

    for i, k in ipairs(keysList) do
        local card = self.keyCards[i]
        if not card then
            card = CreateFrame("Button", nil, self.screenContent)
            card:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
            card:SetSize(cardWidth, cardHeight)
            
            card.bg = card:CreateTexture(nil, "BACKGROUND")
            card.bg:SetAllPoints()
            card.bg:SetColorTexture(1, 1, 1, 0.0)
            
            card.divider = card:CreateTexture(nil, "ARTWORK")
            card.divider:SetPoint("BOTTOMLEFT", 4, 0)
            card.divider:SetPoint("BOTTOMRIGHT", -4, 0)
            card.divider:SetHeight(1)
            card.divider:SetColorTexture(1, 1, 1, 0.05)

            card.icon = card:CreateTexture(nil, "ARTWORK")
            card.icon:SetSize(32, 32)
            card.icon:SetPoint("TOPLEFT", 10, -10)
            card.icon:SetTexture("Interface\\Icons\\INV_Misc_Key_03")

            card.title = card:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            card.title:SetPoint("TOPLEFT", card.icon, "TOPRIGHT", 10, 0)

            card.badge = card:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            card.badge:SetPoint("TOPRIGHT", -12, -10)

            card.source = card:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            card.source:SetPoint("TOPLEFT", card.icon, "TOPRIGHT", 10, -18)
            card.source:SetTextColor(0.4, 0.6, 0.4)

            card.usage = card:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
            card.usage:SetPoint("TOPLEFT", card.icon, "TOPRIGHT", 10, -32)
            card.usage:SetWidth(650)
            card.usage:SetJustifyH("LEFT")

            self.keyCards[i] = card
        end

        card:SetSize(cardWidth, cardHeight)
        card:SetPoint("TOPLEFT", 10, -((i - 1) * (cardHeight + 4)))

        if k.hasKey then
            card.badge:SetText("|cff10b981[In Bags / Keyring]|r")
            card.icon:SetDesaturated(false)
            card.icon:SetVertexColor(1, 1, 1)
        else
            card.badge:SetText("|cffef4444[Missing Key]|r")
            card.icon:SetDesaturated(true)
            card.icon:SetVertexColor(0.6, 0.6, 0.6)
        end

        card.title:SetText(k.name .. "  |cff64748b(" .. k.dungeon .. ")|r")
        card.source:SetText("Source: " .. k.source)
        card.usage:SetText("Unlocks: " .. k.note)

        local iconPath = "Interface\\Icons\\INV_Misc_Key_03"
        if k.itemID and k.itemID > 0 then
            if C_Item and C_Item.RequestLoadItemDataByID then
                pcall(C_Item.RequestLoadItemDataByID, k.itemID)
            end
            if C_Item and C_Item.GetItemInfoInstant then
                local _, _, _, _, instIcon = C_Item.GetItemInfoInstant(k.itemID)
                if instIcon then iconPath = instIcon end
            elseif C_Item and C_Item.GetItemIconByID then
                local dbIcon = C_Item.GetItemIconByID(k.itemID)
                if dbIcon then iconPath = dbIcon end
            end
        end
        card.icon:SetTexture(iconPath)
        
        card:SetScript("OnEnter", function(self)
            if k.itemID and k.itemID > 0 then
                GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
                GameTooltip:SetItemByID(k.itemID)
                if Item and Item.CreateFromItemID then
                    local item = Item:CreateFromItemID(k.itemID)
                    if not item:IsItemDataCached() then
                        item:ContinueOnItemLoad(function()
                            if GameTooltip:GetOwner() == self then
                                GameTooltip:SetItemByID(k.itemID)
                                GameTooltip:Show()
                            end
                        end)
                    end
                end
                GameTooltip:Show()
            end
        end)
        card:SetScript("OnLeave", function() GameTooltip:Hide() end)
        
        card:SetScript("OnClick", function()
            Frame.selectedKeyID = k.itemID
            Frame:RefreshActiveScreen()
        end)

        card:Show()
    end

    for i = #keysList + 1, #self.keyCards do
        if self.keyCards[i] then self.keyCards[i]:Hide() end
    end
    self.screenScroll:UpdateScrollChildRect()
end

function Frame:RenderKeyDetail()
    local keyData = RR.KeysData[self.selectedKeyID]
    if not keyData or not keyData.chain then return end

    local targetChain = keyData.chain

    if not self.backBtn then
        self.backBtn = CreateFrame("Button", nil, self.screenContent, "UIPanelButtonTemplate")
        self.backBtn:SetSize(120, 26)
        self.backBtn:SetScript("OnClick", function()
            Frame.selectedQuestID = nil
            Frame.selectedKeyID = nil
            Frame:RefreshActiveScreen()
        end)
    end
    self.backBtn:SetText("< Back to Quests")
    self.backBtn:Show()
    self.backBtn:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", 14, -6)
    self.backBtn:SetText("< Back to Keys")

    local currentY = -48
    
    if not self.detailTitle then
        self.detailTitle = self.screenContent:CreateFontString(nil, "OVERLAY", "GameFontHighlightHuge")
        self.detailTitle:SetPoint("TOPLEFT", 14, currentY)
    end
    self.detailTitle:Show()
    self.detailTitle:SetText("|cffffd100" .. targetChain.name .. " Attunement|r")
    
    currentY = currentY - 32
    local width = 880

    if not self.detailNodes then self.detailNodes = {} end
    for i, s in ipairs(targetChain.steps) do
        local node = self.detailNodes[i]
        if not node then
            node = CreateFrame("Frame", nil, self.screenContent)
            node:SetWidth(width)
            
            node.divider = node:CreateTexture(nil, "ARTWORK")
            node.divider:SetPoint("TOPLEFT", 0, 0)
            node.divider:SetPoint("TOPRIGHT", 0, 0)
            node.divider:SetHeight(1)
            node.divider:SetColorTexture(1, 1, 1, 0.05)

            node.title = node:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
            node.title:SetPoint("TOPLEFT", 12, -16)
            node.title:SetTextColor(1, 0.82, 0)
            
            node.reqs = node:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
            node.reqs:SetPoint("TOPLEFT", node.title, "BOTTOMLEFT", 0, -4)
            
            node.icon = node:CreateTexture(nil, "ARTWORK")
            node.icon:SetSize(24, 24)
            node.icon:SetPoint("TOPRIGHT", -12, -16)
            
            node.objLbl = node:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            node.objLbl:SetPoint("TOPLEFT", 12, -50)
            node.objLbl:SetText("Objective")
            
            node.objText = node:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            node.objText:SetPoint("TOPLEFT", node.objLbl, "BOTTOMLEFT", 0, -4)
            node.objText:SetWidth(600)
            node.objText:SetJustifyH("LEFT")
            
            node.startLbl = node:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            node.startLbl:SetPoint("TOPLEFT", 12, -100)
            node.startLbl:SetText("Starts at")
            
            node.startText = node:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            node.startText:SetPoint("TOPLEFT", node.startLbl, "BOTTOMLEFT", 0, -4)

            node.rewardIcons = {}
            for j = 1, 4 do
                local riBtn = CreateFrame("Button", nil, node)
                riBtn:SetSize(28, 28)
                riBtn:SetPoint("TOPLEFT", node.startText, "BOTTOMLEFT", (j-1)*32, -8)
                riBtn:Hide()
                
                riBtn.icon = riBtn:CreateTexture(nil, "ARTWORK")
                riBtn.icon:SetAllPoints()
                
                riBtn:SetScript("OnEnter", function(selfRef)
                    if selfRef.itemLink or selfRef.itemID then
                        GameTooltip:SetOwner(selfRef, "ANCHOR_RIGHT")
                        if selfRef.itemLink then
                            GameTooltip:SetHyperlink(selfRef.itemLink)
                        else
                            GameTooltip:SetItemByID(selfRef.itemID)
                            if Item and Item.CreateFromItemID then local itm = Item:CreateFromItemID(selfRef.itemID) if not itm:IsItemDataCached() then itm:ContinueOnItemLoad(function() if GameTooltip:GetOwner() == selfRef then GameTooltip:SetItemByID(selfRef.itemID) GameTooltip:Show() end end) end end
                        end
                        GameTooltip:Show()
                    end
                end)
                riBtn:SetScript("OnLeave", function() GameTooltip:Hide() end)
                
                node.rewardIcons[j] = riBtn
            end

            self.detailNodes[i] = node
        end

        node:SetPoint("TOPLEFT", 14, currentY)
        node.title:SetText(s.title or "Key Step")
        
        local phaseBadgeText = "|cff00e5ff[PRE-DUNGEON]|r"
        if s.phase == "IN-DUNGEON" then
            phaseBadgeText = "|cff3b82f6[IN-DUNGEON]|r"
        elseif s.phase == "ITEM DROP" then
            phaseBadgeText = "|cfff59e0b[ITEM DROP]|r"
        end
        node.reqs:SetText(phaseBadgeText)

        if s.questID == 0 then
            node.icon:SetTexture("Interface\\Icons\\INV_Misc_Note_01")
        else
            node.icon:SetTexture("Interface\\GossipFrame\\ActiveQuestIcon")
        end
        
        node.objText:SetText(s.action or "")
        
        local pickupStr = s.pickupNPC or "Unknown"
        local locStr = s.pickupLocation or "Outside"
        node.startText:SetText(pickupStr .. " (" .. locStr .. ")")
        
        local nodeHeight = 130
        for j = 1, 4 do node.rewardIcons[j]:Hide() end
        if s.rewards and #s.rewards > 0 then
            nodeHeight = 160
            for j, r in ipairs(s.rewards) do
                if j <= 4 then
                    local riBtn = node.rewardIcons[j]
                    riBtn:Show()
                    riBtn.itemID = r.itemID
                    riBtn.itemLink = r.itemLink
                    riBtn.icon:SetTexture("Interface\\Icons\\INV_Box_01")
                    if r.icon then
                        riBtn.icon:SetTexture(r.icon)
                    elseif C_Item and C_Item.GetItemIconByID then
                        riBtn.icon:SetTexture(C_Item.GetItemIconByID(r.itemID))
                    elseif GetItemIcon then
                        riBtn.icon:SetTexture(GetItemIcon(r.itemID))
                    end
                end
            end
        end

        node:Show()
        currentY = currentY - nodeHeight
    end

    for i = #targetChain.steps + 1, #self.detailNodes do
        if self.detailNodes[i] then self.detailNodes[i]:Hide() end
    end
    
    self.screenContent:SetHeight(math.abs(currentY) + 20)
    self.screenScroll:UpdateScrollChildRect()
end
