import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''    if self.activeScreen == "QUESTS" then
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
    end'''

replace_text = '''    if self.activeScreen == "QUESTS" or self.activeScreen == "PARTY" then
        self.progressFrame:Show()
        self.pinEntranceBtn:Show()
        local audit = RR.QuestScanner:AuditDungeon(RR.charDB.selectedDungeon)
        if audit and audit.dungeon then
            local d = audit.dungeon
            self.instanceTitle:SetText(d.name)
            local coordStr = d.coords and string.format("(%.1f, %.1f)", d.coords[1], d.coords[2]) or "Instance"
            local lvlStr = d.recommendedLevel and string.format("Level %d", d.recommendedLevel) or string.format("Level %d-%d", d.minLevel, d.maxLevel)
            self.instanceMeta:SetText(string.format("%s  |  Zone: %s %s  |  %s", lvlStr, d.zone, coordStr, d.faction))
        end
    elseif self.activeScreen == "KEYS" then
        self.progressFrame:Hide()
        self.pinEntranceBtn:Hide()
        if self.selectedKeyID and RR.KeysData[self.selectedKeyID] then
            local k = RR.KeysData[self.selectedKeyID]
            self.instanceTitle:SetText(k.name)
            self.instanceMeta:SetText("Source: " .. k.source)
        else
            self.instanceTitle:SetText("Keys & Attunements")
            self.instanceMeta:SetText("Permanent unlocks and attunements for your character")
        end
    end

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
    end'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
