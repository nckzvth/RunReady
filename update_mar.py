import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\Data\Dungeons_30_60.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

mar_new = '''      ["MAR"] = {
          key = "MAR",
          name = "Maraudon",
          minLevel = 46,
          recommendedLevel = 48,
          maxLevel = 55,
          zone = "Desolace",
          mapID = 1434,
          coords = { 29.0, 62.4 },
          faction = "Both",
          chains = {
              {
                  name = "Scepter of Celebras",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "PRE-DUNGEON",
                          questID = 7044,
                          title = "Legends of Maraudon",
                          pickupNPC = "Cavindra",
                          pickupLocation = "Desolace",
                          action = "Recover the Celebrian Diamond and Celebrian Rod from Maraudon.",
                      },
                      {
                          step = 2,
                          phase = "IN-DUNGEON",
                          questID = 7046,
                          title = "The Scepter of Celebras",
                          pickupNPC = "Celebras the Redeemed",
                          pickupLocation = "Maraudon",
                          action = "Help Celebras create the Scepter.",
                          rewards = {
                              { itemID = 17191, name = "Scepter of Celebras", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "Corruption of Earth and Seed",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 7066,
                          title = "Corruption of Earth and Seed",
                          pickupNPC = "Selendra",
                          pickupLocation = "Desolace",
                          action = "Defeat Princess Theradras.",
                          rewards = {
                              { itemID = 17743, name = "Thrash Blade", quality = 3 },
                              { itemID = 17744, name = "Resurgence Rod", quality = 3 },
                              { itemID = 17745, name = "Verdant Keeper's Aim", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "Vyletongue Corruption",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 7065,
                          title = "Vyletongue Corruption",
                          pickupNPC = "Vark Battlescar",
                          pickupLocation = "Desolace",
                          action = "Collect 10 Cerulean Vials from Vyletongue Satyrs.",
                      },
                  },
              },
              {
                  name = "The Pariah's Instructions",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 7064,
                          title = "The Pariah's Instructions",
                          pickupNPC = "Centaur Pariah",
                          pickupLocation = "Desolace",
                          action = "Retrieve the Amulet of Spirits from the Nameless Prophet.",
                          rewards = {
                              { itemID = 17746, name = "Mark of the Chosen", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "Shadowshard Fragments",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 7067,
                          title = "Shadowshard Fragments",
                          pickupNPC = "Uthel'nay",
                          pickupLocation = "Orgrimmar",
                          action = "Collect 10 Shadowshard Fragments.",
                      },
                  },
              },
              {
                  name = "Seed of Life",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 7068,
                          title = "Seed of Life",
                          pickupNPC = "Zaetar's Spirit",
                          pickupLocation = "Maraudon",
                          action = "Bring the Seed of Life to Remulos in Moonglade.",
                          rewards = {
                              { itemID = 17747, name = "Ring of the Woodlands", quality = 3 },
                          },
                      },
                  },
              },
          },
      },
'''

pattern = re.compile(r'\["MAR"\] = \{.*?\["ST"\] = \{', re.DOTALL)
content = pattern.sub(mar_new + '      ["ST"] = {', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
