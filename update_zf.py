import re

file_path = r'D:\Games\World of Warcraft\_classic_beta_\Interface\AddOns\RunReady\Data\Dungeons_30_60.lua'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

zf_new = '''      ["ZF"] = {
          key = "ZF",
          name = "Zul'Farrak",
          minLevel = 44,
          recommendedLevel = 46,
          maxLevel = 50,
          zone = "Tanaris",
          mapID = 1446,
          coords = { 39.2, 21.4 },
          faction = "Both",
          chains = {
              {
                  name = "Scarab Shells",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "PRE-DUNGEON",
                          questID = 2864,
                          title = "Tran'rek",
                          pickupNPC = "Krazek",
                          pickupLocation = "Stranglethorn Vale",
                          action = "Bring the load of smelting gear to Tran'rek in Gadgetzan.",
                      },
                      {
                          step = 2,
                          phase = "IN-DUNGEON",
                          questID = 2865,
                          title = "Scarab Shells",
                          pickupNPC = "Tran'rek",
                          pickupLocation = "Tanaris (Gadgetzan)",
                          pickupCoords = { 51.6, 26.8 },
                          action = "Collect 5 Unscratched Scarab Shells inside Zul'Farrak.",
                          rewards = {
                              { itemID = 9523, name = "Booty Bay Boot", quality = 2 },
                          },
                      },
                  },
              },
              {
                  name = "Troll Temper",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 3042,
                          title = "Troll Temper",
                          pickupNPC = "Trenton Lighthammer",
                          pickupLocation = "Tanaris (Gadgetzan)",
                          action = "Collect 20 vials of Troll Temper inside Zul'Farrak.",
                      },
                  },
              },
              {
                  name = "Divino-matic Rod",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 2768,
                          title = "Divino-matic Rod",
                          pickupNPC = "Chief Engineer Bilgewhizzle",
                          pickupLocation = "Tanaris (Gadgetzan)",
                          action = "Recover the Divino-matic Rod from Sergeant Bly in Zul'Farrak.",
                      },
                  },
              },
              {
                  name = "Tiara of the Deep",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 2770,
                          title = "Tiara of the Deep",
                          pickupNPC = "Tabetha",
                          pickupLocation = "Dustwallow Marsh",
                          action = "Loot the Tiara of the Deep from Hydromancer Velratha in Zul'Farrak.",
                          rewards = {
                              { itemID = 9484, name = "Gemshale Pauldrons", quality = 3 },
                              { itemID = 9524, name = "Spellshifter Wand", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "The Prophecy of Mosh'aru",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "PRE-DUNGEON",
                          questID = 3520,
                          title = "Screecher Spirits",
                          pickupNPC = "Yeh'kinya",
                          pickupLocation = "Tanaris (Steamwheedle Port)",
                          action = "Capture the spirits of 3 Vale Screechers in Feralas.",
                      },
                      {
                          step = 2,
                          phase = "IN-DUNGEON",
                          questID = 3528,
                          title = "The Prophecy of Mosh'aru",
                          pickupNPC = "Yeh'kinya",
                          pickupLocation = "Tanaris (Steamwheedle Port)",
                          action = "Loot the First and Second Mosh'aru Tablets from Zul'Farrak.",
                          rewards = {
                              { itemID = 9485, name = "Mason's Fraternity Ring", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "Gahz'rilla",
                  faction = "Both",
                  steps = {
                      {
                          step = 1,
                          phase = "IN-DUNGEON",
                          questID = 2772,
                          title = "Gahz'rilla",
                          pickupNPC = "Wizzle Brassbolts",
                          pickupLocation = "Thousand Needles (Shimmering Flats)",
                          action = "Summon and defeat Gahz'rilla. Requires the Mallet of Zul'Farrak.",
                          rewards = {
                              { itemID = 9508, name = "Carrot on a Stick", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "The Spider God",
                  faction = "Horde",
                  steps = {
                      {
                          step = 1,
                          phase = "PRE-DUNGEON",
                          questID = 3371,
                          title = "Venom Bottles",
                          pickupNPC = "Apothecary Lydon",
                          pickupLocation = "Tarren Mill (Hillsbrad Foothills)",
                          action = "Deliver the bottles to Krusk in Tarren Mill.",
                      },
                      {
                          step = 2,
                          phase = "IN-DUNGEON",
                          questID = 3372,
                          title = "The Spider God",
                          pickupNPC = "Master Gadrin",
                          pickupLocation = "Durotar (Sen'jin Village)",
                          action = "Read the name from the Tablet of Theka in Zul'Farrak.",
                          rewards = {
                              { itemID = 9525, name = "Band of the Great Tortoise", quality = 3 },
                              { itemID = 9526, name = "Fingers of Ma'ruk", quality = 3 },
                          },
                      },
                  },
              },
              {
                  name = "Nekrum's Medallion",
                  faction = "Alliance",
                  steps = {
                      {
                          step = 1,
                          phase = "PRE-DUNGEON",
                          questID = 2866,
                          title = "Witherbark Cages",
                          pickupNPC = "Gryphon Master Talonaxe",
                          pickupLocation = "The Hinterlands (Aerie Peak)",
                          action = "Examine the Witherbark cages.",
                      },
                      {
                          step = 2,
                          phase = "PRE-DUNGEON",
                          questID = 2871,
                          title = "Altar of Zul",
                          pickupNPC = "Gryphon Master Talonaxe",
                          pickupLocation = "The Hinterlands",
                          action = "Investigate the Altar of Zul.",
                      },
                      {
                          step = 3,
                          phase = "PRE-DUNGEON",
                          questID = 2872,
                          title = "Thadius Grimshade",
                          pickupNPC = "Gryphon Master Talonaxe",
                          pickupLocation = "The Hinterlands",
                          action = "Travel to the Blasted Lands to speak with Thadius Grimshade.",
                      },
                      {
                          step = 4,
                          phase = "IN-DUNGEON",
                          questID = 2873,
                          title = "Nekrum's Medallion",
                          pickupNPC = "Thadius Grimshade",
                          pickupLocation = "Blasted Lands",
                          action = "Obtain Nekrum's Medallion in Zul'Farrak.",
                          rewards = {
                              { itemID = 9525, name = "Band of the Great Tortoise", quality = 3 },
                              { itemID = 9526, name = "Fingers of Ma'ruk", quality = 3 },
                          },
                      },
                  },
              },
          },
      },
'''

pattern = re.compile(r'\["ZF"\] = \{.*?\["MAR"\] = \{', re.DOTALL)
content = pattern.sub(zf_new + '      ["MAR"] = {', content)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
