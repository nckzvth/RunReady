import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Make card a Button
find_btn = '''        local card = self.keyCards[i]
        if not card then
            card = CreateFrame("Frame", nil, self.screenContent)'''

replace_btn = '''        local card = self.keyCards[i]
        if not card then
            card = CreateFrame("Button", nil, self.screenContent)
            card:SetHighlightTexture("Interface\\\\QuestFrame\\\\UI-QuestTitleHighlight", "ADD")'''
content = content.replace(find_btn, replace_btn)

# Make it clickable and dynamic icons
find_text = '''        card.title:SetText(k.name .. "  |cff64748b(" .. k.dungeon .. ")|r")
        card.source:SetText("Source: " .. k.source)
        card.usage:SetText("Unlocks: " .. k.note)

        card:Show()'''

replace_text = '''        card.title:SetText(k.name .. "  |cff64748b(" .. k.dungeon .. ")|r")
        card.source:SetText("Source: " .. k.source)
        card.usage:SetText("Unlocks: " .. k.note)

        local iconPath = "Interface\\\\Icons\\\\INV_Misc_Key_03"
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
            Frame:RenderKeyDetail()
        end)

        card:Show()'''
content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
