import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\Data\Keys_Attunements.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

find_text = '''    [277507] = { -- Placeholder ID for Dalaran Sewer Key
        name = "Dalaran Sewer Key", dungeon = "City of Dalaran", source = "Heart of Disruption (Horde)", note = "Unlocks the Dalaran Sewers instance portal",
        chain = {
            name = "Dalaran Attunement",
            faction = "Horde",
            steps = {
                { step = 1, phase = "PRE-DUNGEON", questID = 0, title = "Prison Break In", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Accept the initial attunement quest." },
                { step = 2, phase = "PRE-DUNGEON", questID = 0, title = "Dalaran Patrols", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Follow up quest to patrol around Dalaran." },
                { step = 3, phase = "PRE-DUNGEON", questID = 0, title = "Blood in the Streets", pickupNPC = "Image of Archmage Modera", pickupLocation = "Alterac Mountains", action = "Turn in to the Image of Modera." },
                { step = 4, phase = "PRE-DUNGEON", questID = 0, title = "Heart of Disruption", pickupNPC = "Image of Archmage Modera", pickupLocation = "Alterac Mountains", action = "Complete the quest to receive the Dalaran Sewer Key." }
            }
        }
    }'''

replace_text = '''    [277507] = {
        name = "Dalaran Sewer Key", dungeon = "City of Dalaran", source = "Heart of Disruption (Horde)", note = "Unlocks the Dalaran Sewers instance portal",
        chain = {
            name = "Dalaran Attunement",
            faction = "Horde",
            steps = {
                { step = 1, phase = "PRE-DUNGEON", questID = 544, title = "Prison Break In", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Find the traitors and recover their artifacts, then return to Magus Voidglare." },
                { step = 2, phase = "PRE-DUNGEON", questID = 93680, title = "Key to the City", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Acquire the Grimy Key for Magus Wordeen Voidglare." },
                { step = 3, phase = "PRE-DUNGEON", questID = 556, title = "Stone Tokens", pickupNPC = "Keeper Bel'varil", pickupLocation = "Tarren Mill", action = "Bring 10 Worn Stone Tokens to Keeper Bel'varil." },
                { step = 4, phase = "PRE-DUNGEON", questID = 545, title = "Dalaran Patrols", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Kill 6 Dalaran Summoners and 12 Elemental Slaves." },
                { step = 5, phase = "PRE-DUNGEON", questID = 557, title = "Bracers of Binding", pickupNPC = "Keeper Bel'varil", pickupLocation = "Tarren Mill", action = "Bring 4 Bracers of Earth Binding to Keeper Bel'varil." },
                { step = 6, phase = "PRE-DUNGEON", questID = 92434, title = "Blood in the Streets", pickupNPC = "Magus Wordeen Voidglare", pickupLocation = "Tarren Mill", action = "Hand this quest in to Image of Archmage Modera outside Dalaran." },
                { step = 7, phase = "PRE-DUNGEON", questID = 96984, title = "Heart of Disruption", pickupNPC = "Image of Archmage Modera", pickupLocation = "Alterac Mountains", action = "Enter the City of Dalaran and collect the Arcane Mote. Provides Dalaran Sewer Key.", rewards = {{ itemID = 277507 }} }
            }
        }
    }'''

content = content.replace(find_text, replace_text)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
