import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# Fix 1: Initialize self.detailNodes in RenderKeyDetail
find_nodes = '''    local width = 880

    for i, s in ipairs(targetChain.steps) do
        local node = self.detailNodes[i]'''

replace_nodes = '''    local width = 880

    if not self.detailNodes then self.detailNodes = {} end
    for i, s in ipairs(targetChain.steps) do
        local node = self.detailNodes[i]'''

content = content.replace(find_nodes, replace_nodes)

# Fix 2: Set text back to Back to Quests in RenderChainDetail
find_backBtn = '''    if not self.backBtn then
        self.backBtn = CreateFrame("Button", nil, self.screenContent, "UIPanelButtonTemplate")
        self.backBtn:SetSize(120, 26)
        self.backBtn:SetText("< Back to Quests")
        self.backBtn:SetScript("OnClick", function()
            Frame.selectedQuestID = nil
            Frame.selectedKeyID = nil
            Frame:RefreshActiveScreen()
        end)
    end
    self.backBtn:Show()'''

replace_backBtn = '''    if not self.backBtn then
        self.backBtn = CreateFrame("Button", nil, self.screenContent, "UIPanelButtonTemplate")
        self.backBtn:SetSize(120, 26)
        self.backBtn:SetScript("OnClick", function()
            Frame.selectedQuestID = nil
            Frame.selectedKeyID = nil
            Frame:RefreshActiveScreen()
        end)
    end
    self.backBtn:SetText("< Back to Quests")
    self.backBtn:Show()'''

content = content.replace(find_backBtn, replace_backBtn)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
