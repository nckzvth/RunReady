import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''        node:Show()
        currentY = currentY - nodeHeight
    end

    for i = #targetChain.steps + 1, #self.detailNodes do'''

replace_text = '''        node:SetHeight(nodeHeight)
        node:Show()
        currentY = currentY - nodeHeight - 16
    end

    for i = #targetChain.steps + 1, #self.detailNodes do'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
