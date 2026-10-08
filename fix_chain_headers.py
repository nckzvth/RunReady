import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''            self.detailNodes[i] = node
        end

        node:SetPoint("TOPLEFT", 14, currentY)
        node.title:SetText(q.title)'''

replace_text = '''            self.detailNodes[i] = node
        end

        if node.secHeader then node.secHeader:Hide() end

        node:SetPoint("TOPLEFT", 14, currentY)
        node.title:SetText(q.title)'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
