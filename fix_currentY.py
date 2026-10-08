file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''    self.backBtn:SetText("< Back to Quests")
    self.backBtn:ClearAllPoints()
    self.backBtn:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", 14, -6)
    self.backBtn:Show()
    
    if not self.detailTitle then'''

replace_text = '''    self.backBtn:SetText("< Back to Quests")
    self.backBtn:ClearAllPoints()
    self.backBtn:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", 14, -6)
    self.backBtn:Show()
    
    local currentY = -48
    
    if not self.detailTitle then'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
