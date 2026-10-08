import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\Data\Keys_Attunements.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''                { step = 1, phase = "PRE-DUNGEON", questID = 544, title = "Prison Break In", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Find the traitors and recover their artifacts, then return to Magus Voidglare." },
                { step = 2, phase = "PRE-DUNGEON", questID = 93680, title = "Key to the City", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Acquire the Grimy Key for Magus Wordeen Voidglare." },
                { step = 3, phase = "PRE-DUNGEON", questID = 556, title = "Stone Tokens", pickupNPC = "Keeper Bel'varil", pickupLocation = "Tarren Mill", action = "Bring 10 Worn Stone Tokens to Keeper Bel'varil." },
                { step = 4, phase = "PRE-DUNGEON", questID = 545, title = "Dalaran Patrols", preReqs = "Requires: Prison Break In, Key to the City", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Kill 6 Dalaran Summoners and 12 Elemental Slaves." },
                { step = 5, phase = "PRE-DUNGEON", questID = 557, title = "Bracers of Binding", preReqs = "Requires: Stone Tokens", pickupNPC = "Keeper Bel'varil", pickupLocation = "Tarren Mill", action = "Bring 4 Bracers of Earth Binding to Keeper Bel'varil." },
                { step = 6, phase = "PRE-DUNGEON", questID = 92434, title = "Blood in the Streets", preReqs = "Requires: Dalaran Patrols, Bracers of Binding", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Hand this quest in to Image of Archmage Modera outside Dalaran." },
                { step = 7, phase = "PRE-DUNGEON", questID = 96984, title = "Heart of Disruption", preReqs = "Requires: Blood in the Streets", pickupNPC = "Image of Archmage Modera", pickupLocation = "Alterac Mountains", action = "Enter the City of Dalaran and collect the Arcane Mote. Provides Dalaran Sewer Key.", rewards = {{ itemID = 277507 }} }'''

replace_text = '''                { step = 1, phase = "PRE-DUNGEON", sectionHeader = "Magus Voidglare's Initial Quests", questID = 544, title = "Prison Break In", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Find the traitors and recover their artifacts, then return to Magus Voidglare." },
                { step = 2, phase = "PRE-DUNGEON", questID = 93680, title = "Key to the City", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Acquire the Grimy Key for Magus Wordeen Voidglare." },
                { step = 3, phase = "PRE-DUNGEON", sectionHeader = "Keeper Bel'varil's Initial Quest", questID = 556, title = "Stone Tokens", pickupNPC = "Keeper Bel'varil", pickupLocation = "Tarren Mill", action = "Bring 10 Worn Stone Tokens to Keeper Bel'varil." },
                { step = 4, phase = "PRE-DUNGEON", sectionHeader = "Follow-ups (Requires Previous)", questID = 545, title = "Dalaran Patrols", preReqs = "Requires: Prison Break In, Key to the City", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Kill 6 Dalaran Summoners and 12 Elemental Slaves." },
                { step = 5, phase = "PRE-DUNGEON", questID = 557, title = "Bracers of Binding", preReqs = "Requires: Stone Tokens", pickupNPC = "Keeper Bel'varil", pickupLocation = "Tarren Mill", action = "Bring 4 Bracers of Earth Binding to Keeper Bel'varil." },
                { step = 6, phase = "PRE-DUNGEON", sectionHeader = "The Final Assembly (Requires All Follow-ups)", questID = 92434, title = "Blood in the Streets", preReqs = "Requires: Dalaran Patrols, Bracers of Binding", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Hand this quest in to Image of Archmage Modera outside Dalaran." },
                { step = 7, phase = "PRE-DUNGEON", questID = 96984, title = "Heart of Disruption", preReqs = "Requires: Blood in the Streets", pickupNPC = "Image of Archmage Modera", pickupLocation = "Alterac Mountains", action = "Enter the City of Dalaran and collect the Arcane Mote. Provides Dalaran Sewer Key.", rewards = {{ itemID = 277507 }} }'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
