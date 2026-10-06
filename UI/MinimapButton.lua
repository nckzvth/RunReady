local addonName, RR = ...

RR.MinimapButton = CreateFrame("Button", "RunReadyMinimapButton", Minimap)
local Btn = RR.MinimapButton

function Btn:Initialize()
    self:SetSize(31, 31)
    self:SetFrameStrata("MEDIUM")
    self:SetFrameLevel(8)
    self:EnableMouse(true)
    self:SetMovable(true)

    -- Native circular border
    self.border = self:CreateTexture(nil, "OVERLAY")
    self.border:SetSize(52, 52)
    self.border:SetPoint("TOPLEFT")
    self.border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")

    -- Icon (Dungeon portal icon)
    self.icon = self:CreateTexture(nil, "BACKGROUND")
    self.icon:SetSize(18, 18)
    self.icon:SetPoint("CENTER", 0, 1)
    self.icon:SetTexture("Interface\\AddOns\\RunReady\\UI\\MinimapIcon.tga")

    self:RegisterForClicks("LeftButtonUp", "RightButtonUp")
    self:RegisterForDrag("LeftButton")

    self:SetScript("OnDragStart", function(s)
        s.isDragging = true
    end)
    self:SetScript("OnDragStop", function(s)
        s.isDragging = false
    end)

    self:SetScript("OnUpdate", function(s)
        if s.isDragging then
            local mx, my = Minimap:GetCenter()
            local px, py = GetCursorPosition()
            local scale = UIParent:GetEffectiveScale()
            px, py = px / scale, py / scale
            local angle = math.deg(math.atan2(py - my, px - mx))
            RR.db.minimapPos = angle
            s:UpdatePosition()
        end
    end)

    self:SetScript("OnClick", function(s, button)
        if button == "LeftButton" then
            if RR.MainFrame:IsShown() then
                RR.MainFrame:Hide()
            else
                RR.MainFrame:Show()
                RR.MainFrame:Refresh()
            end
        elseif button == "RightButton" then
            RR:ShareCurrentDungeonQuests()
        end
    end)

    self:SetScript("OnEnter", function(s)
        GameTooltip:SetOwner(s, "ANCHOR_LEFT")
        GameTooltip:AddLine(RR.title, 1, 0.82, 0)
        GameTooltip:AddLine(" ")
        GameTooltip:AddLine("|cffffd100Left-Click:|r Open Dungeon Readiness Window", 0.8, 0.8, 0.8)
        GameTooltip:AddLine("|cffffd100Right-Click:|r 1-Click Share Dungeon Quests to Party", 0.8, 0.8, 0.8)
        GameTooltip:AddLine("|cffffd100Drag:|r Move Minimap Icon", 0.8, 0.8, 0.8)
        GameTooltip:Show()
    end)
    self:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    self:UpdatePosition()

    if not RR.db.showMinimapButton then
        self:Hide()
    end
end

function Btn:UpdatePosition()
    local angle = math.rad(RR.db.minimapPos or 215)
    local radius = (Minimap:GetWidth() / 2) + 5
    local x = math.cos(angle) * radius
    local y = math.sin(angle) * radius
    self:SetPoint("CENTER", Minimap, "CENTER", x, y)
end
