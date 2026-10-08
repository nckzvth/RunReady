import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = re.search(r'function Frame:RenderKeyDetail\(\).*?self\.screenScroll:UpdateScrollChildRect\(\)\s*end', content, re.DOTALL)
if find_text:
    replace_text = '''function Frame:RenderKeyDetail()
    local keyData = RR.KeysData[self.selectedKeyID]
    if not keyData or not keyData.chain then return end

    local targetChain = keyData.chain

    if not self.backBtn then
        self.backBtn = CreateFrame("Button", nil, self.screenContent, "UIPanelButtonTemplate")
        self.backBtn:SetSize(120, 26)
        self.backBtn:SetText("< Back to Quests")
        self.backBtn:SetScript("OnClick", function()
            Frame.selectedQuestID = nil
            Frame.selectedKeyID = nil
            Frame:RefreshActiveScreen()
        end)
    end
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
            node.icon:SetTexture("Interface\\\\Icons\\\\INV_Misc_Note_01")
        else
            node.icon:SetTexture("Interface\\\\GossipFrame\\\\ActiveQuestIcon")
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
                    riBtn.icon:SetTexture("Interface\\\\Icons\\\\INV_Box_01")
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
end'''
    content = content[:find_text.start()] + replace_text + content[find_text.end():]
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
else:
    print("Could not find RenderKeyDetail")
