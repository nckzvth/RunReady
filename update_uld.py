import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\Data\Dungeons_30_60.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

uld_new = '''      ["ULD"] = {
          key = "ULD",
          name = "Uldaman",
          minLevel = 35,
          recommendedLevel = 42,
          maxLevel = 45,
          zone = "Badlands",
          mapID = 1418,
          coords = { 41.8, 11.2 },
          faction = "Both",
          chains = {
              {
                  name = "Reclaimed Treasures",
                  faction = "Alliance",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 2278,
                          title = "Reclaimed Treasures",
                          pickupNPC = "Krom Stoutarm",
                          pickupLocation = "Ironforge",
                          action = "Retrieve the treasure from Uldaman.",
                          rewards = {
                              { itemID = 9390, name = "Stoutarm Crest", quality = 3 },
                              { itemID = 9391, name = "Restoring Balm", quality = 2 },
                          },
                      },
                  },
              },
              {
                  name = "Agmond's Fate",
                  faction = "Alliance",
                  steps = {
                      {
                          step = 1,
                          phase = "PRE-DUNGEON",
                          questID = 2240,
                          title = "Ironband Wants You!",
                          pickupNPC = "Prospector Stormhammer",
                          pickupLocation = "Ironforge",
                          action = "Speak with Prospector Ironband in Loch Modan.",
                      },
                      {
                          step = 2,
                          phase = "PRE-DUNGEON",
                          questID = 2241,
                          title = "Find Agmond",
                          pickupNPC = "Prospector Ironband",
                          pickupLocation = "Loch Modan",
                          action = "Find Prospector Agmond in the Badlands.",
                      },
                      {
                          step = 3,
                          phase = "PRE-DUNGEON",
                          questID = 2242,
                          title = "Murdaloc",
                          pickupNPC = "Prospector Agmond",
                          pickupLocation = "Badlands",
                          action = "Kill Murdaloc and 12 Stonevault Bonesnappers.",
                      },
                      {
                          step = 4,
                          phase = "IN-DUNGEON",
                          questID = 2279,
                          title = "Agmond's Fate",
                          pickupNPC = "Prospector Ironband",
                          pickupLocation = "Loch Modan",
                          action = "Retrieve Agmond's Remains from Uldaman.",
                          rewards = {
                              { itemID = 9393, name = "Agmond's Ender", quality = 3 },
                              { itemID = 9394, name = "Ironband's Buckler", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "Necklace of Trelane",
                  faction = "Alliance",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 2271,
                          title = "The Shattered Necklace",
                          pickupNPC = "Shattered Necklace (Item Drop)",
                          pickupLocation = "Uldaman",
                          action = "Bring the necklace to Talvash del Kissel in Ironforge.",
                      },
                      {
                          step = 2,
                          phase = "PRE-DUNGEON",
                          questID = 2281,
                          title = "Lore for a Price",
                          pickupNPC = "Talvash del Kissel",
                          pickupLocation = "Ironforge",
                          action = "Pay Talvash 5 silver.",
                      },
                      {
                          step = 3,
                          phase = "PRE-DUNGEON",
                          questID = 2282,
                          title = "Back to Uldaman",
                          pickupNPC = "Talvash del Kissel",
                          pickupLocation = "Ironforge",
                          action = "Return to Uldaman and collect the remains of the Paladin.",
                      },
                      {
                          step = 4,
                          phase = "IN-DUNGEON",
                          questID = 2283,
                          title = "Find the Gems",
                          pickupNPC = "Paladin's Remains",
                          pickupLocation = "Uldaman",
                          action = "Collect the Ruby, Sapphire, and Topaz.",
                      },
                      {
                          step = 5,
                          phase = "PRE-DUNGEON",
                          questID = 2284,
                          title = "Restoring the Necklace",
                          pickupNPC = "Talvash del Kissel",
                          pickupLocation = "Ironforge",
                          action = "Turn in the gems.",
                          rewards = {
                              { itemID = 9395, name = "Talvash's Enhancing Necklace", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "Power Stones",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 2276,
                          title = "Power Stones",
                          pickupNPC = "Rigmed",
                          pickupLocation = "Badlands",
                          action = "Collect 8 Dentrium Power Stones.",
                      },
                  },
              },
              {
                  name = "The Platinum Discs",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 2277,
                          title = "The Platinum Discs",
                          pickupNPC = "The Platinum Discs",
                          pickupLocation = "Uldaman",
                          action = "Bring the Platinum Discs to your faction's capital.",
                          rewards = {
                              { itemID = 9481, name = "Stonevault Bonebreaker", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "Necklace of Trelane (Horde)",
                  faction = "Horde",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 2280,
                          title = "Necklace of Trelane",
                          pickupNPC = "Dran Droffers",
                          pickupLocation = "Orgrimmar",
                          action = "Bring the necklace to Dran Droffers.",
                          rewards = {
                              { itemID = 9396, name = "Droffers' Necklace", quality = 3 },
                          },
                      },
                  },
              },
          },
      },
'''

pattern = re.compile(r'\["ULD"\] = \{.*?\["ZF"\] = \{', re.DOTALL)
content = pattern.sub(uld_new + '      ["ZF"] = {', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
