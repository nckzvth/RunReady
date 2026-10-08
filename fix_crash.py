import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''        local stepMeta = RR.Utils:GetQuestStatusMeta(s.questID)
        if s.questID == 0 then
            stepMeta = { label = "Event", color = "f59e0b", r = 0.96, g = 0.62, b = 0.04 }
        end'''

replace_text = '''        local stepMeta = { label = "Quest", color = "ffffff", r = 1, g = 1, b = 1 }
        if s.questID == 0 then
            stepMeta = { label = "Event", color = "f59e0b", r = 0.96, g = 0.62, b = 0.04 }
        end'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
