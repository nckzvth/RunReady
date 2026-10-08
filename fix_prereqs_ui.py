import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''        local phaseBadgeText = "|cff00e5ff[PRE-DUNGEON]|r"
        if s.phase == "IN-DUNGEON" then
            phaseBadgeText = "|cff3b82f6[IN-DUNGEON]|r"
        elseif s.phase == "ITEM DROP" then
            phaseBadgeText = "|cfff59e0b[ITEM DROP]|r"
        end
        node.reqs:SetText(phaseBadgeText)'''

replace_text = '''        local phaseBadgeText = "|cff00e5ff[PRE-DUNGEON]|r"
        if s.phase == "IN-DUNGEON" then
            phaseBadgeText = "|cff3b82f6[IN-DUNGEON]|r"
        elseif s.phase == "ITEM DROP" then
            phaseBadgeText = "|cfff59e0b[ITEM DROP]|r"
        end
        if s.preReqs then
            phaseBadgeText = phaseBadgeText .. "   |cff94a3b8" .. s.preReqs .. "|r"
        end
        node.reqs:SetText(phaseBadgeText)'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
