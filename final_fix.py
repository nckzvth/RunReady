import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\UI\MainFrame.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Fix RefreshActiveScreen routing
find_routing = '''    elseif self.activeScreen == "KEYS" then
        self:RenderKeys()
    end'''

replace_routing = '''    elseif self.activeScreen == "KEYS" then
        if self.selectedKeyID then
            self:RenderKeyDetail()
        else
            self:RenderKeys()
        end
    end'''

content = content.replace(find_routing, replace_routing)

# 2. Fix OnClick in RenderKeys to call RefreshActiveScreen
find_onclick = '''        card:SetScript("OnClick", function()
            Frame.selectedKeyID = k.itemID
            Frame:RenderKeyDetail()
        end)'''

replace_onclick = '''        card:SetScript("OnClick", function()
            Frame.selectedKeyID = k.itemID
            Frame:RefreshActiveScreen()
        end)'''

content = content.replace(find_onclick, replace_onclick)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
