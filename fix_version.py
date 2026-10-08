import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\RunReady.toc'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

content = re.sub(r'## Version: .*', '## Version: 1.0.19', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
