file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if 'function Frame:RenderChainDetail()' in line:
        chain_start = i
        break

for i in range(chain_start, len(lines)):
    if 'if not self.backBtn then' in lines[i]:
        # Replace the block
        lines[i] = '    if not self.backBtn then\n'
        lines[i+1] = '        self.backBtn = CreateFrame("Button", nil, self.screenContent, "UIPanelButtonTemplate")\n'
        lines[i+2] = '        self.backBtn:SetSize(120, 26)\n'
        lines[i+3] = '        self.backBtn:SetScript("OnClick", function()\n'
        lines[i+4] = '            Frame.selectedQuestID = nil\n'
        lines[i+5] = '            Frame.selectedKeyID = nil\n'
        lines[i+6] = '            Frame:RefreshActiveScreen()\n'
        lines[i+7] = '        end)\n'
        lines[i+8] = '    end\n'
        lines[i+9] = '    self.backBtn:SetText("< Back to Quests")\n'
        lines[i+10] = '    self.backBtn:ClearAllPoints()\n'
        lines[i+11] = '    self.backBtn:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", 14, -6)\n'
        lines[i+12] = '    self.backBtn:Show()\n'
        break

for i, line in enumerate(lines):
    if 'function Frame:RenderKeyDetail()' in line:
        key_start = i
        break

for i in range(key_start, len(lines)):
    if 'if not self.backBtn then' in lines[i]:
        # Replace the block
        lines[i] = '    if not self.backBtn then\n'
        lines[i+1] = '        self.backBtn = CreateFrame("Button", nil, self.screenContent, "UIPanelButtonTemplate")\n'
        lines[i+2] = '        self.backBtn:SetSize(120, 26)\n'
        lines[i+3] = '        self.backBtn:SetScript("OnClick", function()\n'
        lines[i+4] = '            Frame.selectedQuestID = nil\n'
        lines[i+5] = '            Frame.selectedKeyID = nil\n'
        lines[i+6] = '            Frame:RefreshActiveScreen()\n'
        lines[i+7] = '        end)\n'
        lines[i+8] = '    end\n'
        lines[i+9] = '    self.backBtn:SetText("< Back to Keys")\n'
        lines[i+10] = '    self.backBtn:ClearAllPoints()\n'
        lines[i+11] = '    self.backBtn:SetPoint("TOPLEFT", self.screenContent, "TOPLEFT", 14, -6)\n'
        lines[i+12] = '    self.backBtn:Show()\n'
        # The original code might have an extra self.backBtn:SetText("< Back to Keys") line here, we should blank it out if it exists
        if 'self.backBtn:SetText("< Back to Keys")' in lines[i+13] or 'self.backBtn:SetText("< Back to Quests")' in lines[i+13]:
            lines[i+13] = '\n'
        if 'self.backBtn:SetText("< Back to Keys")' in lines[i+14]:
            lines[i+14] = '\n'
        break

with open(file_path, 'w', encoding='utf-8') as f:
    f.writelines(lines)
