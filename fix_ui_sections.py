import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''            self.detailNodes[i] = node
        end

        node:SetPoint("TOPLEFT", 14, currentY)
        node.title:SetText(s.title or "Key Step")'''

replace_text = '''            self.detailNodes[i] = node
        end

        if s.sectionHeader then
            if not node.secHeader then
                node.secHeader = node:CreateFontString(nil, "OVERLAY", "GameFontHighlightLarge")
                node.secHeader:SetTextColor(0.0, 0.85, 0.95)
            end
            node.secHeader:SetText(s.sectionHeader)
            node.secHeader:SetPoint("BOTTOMLEFT", node, "TOPLEFT", 0, 10)
            node.secHeader:Show()
            currentY = currentY - 36
        else
            if node.secHeader then node.secHeader:Hide() end
        end

        node:SetPoint("TOPLEFT", 14, currentY)
        node.title:SetText(s.title or "Key Step")'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
