--[[
Best In Slot - Project Lazarus Edition
aquietone, Kroaking, dlilah, ...
Updated by Primal (Realist)
Inspired by TurboGear - Drel

2026+ - Incorporating various additions from WanteD fork by Kroaking

Tracker lua script for all the good stuff to have on Project Lazarus server.
]]
local meta			= {version = '1.0', name = string.match(string.gsub(debug.getinfo(1, 'S').short_src, '\\init.lua', ''), "[^\\]+$")}
local mq			= require('mq')
local ImGui			= require('ImGui')
-- Lazbis visual theme based on TurboGear v1.2.96 (drel-git/Turbo).
local lazbisTheme	= {}
lazbisTheme.push = function()
    local vars, colors = 0, 0
    local function pv(key, ...)
        if key and pcall(ImGui.PushStyleVar, key, ...) then vars = vars + 1 end
    end
    local function pc(key, ...)
        if key and pcall(ImGui.PushStyleColor, key, ...) then colors = colors + 1 end
    end
    pv(ImGuiStyleVar.WindowRounding, 7)
    pv(ImGuiStyleVar.FrameRounding, 4)
    pv(ImGuiStyleVar.GrabRounding, 4)
    pv(ImGuiStyleVar.TabRounding, 4)
    pv(ImGuiStyleVar.FramePadding, 7, 4)
    pv(ImGuiStyleVar.ItemSpacing, 7, 5)
    pc(ImGuiCol.Text, 0.78, 0.82, 0.88, 1)
    pc(ImGuiCol.TextDisabled, 0.50, 0.55, 0.62, 1)
    pc(ImGuiCol.WindowBg, 0.055, 0.058, 0.075, 1)
    pc(ImGuiCol.ChildBg, 0.090, 0.100, 0.120, 1)
    pc(ImGuiCol.PopupBg, 0.090, 0.100, 0.120, 1)
    pc(ImGuiCol.Border, 0.78, 0.58, 0.22, 0.78)
    pc(ImGuiCol.FrameBg, 0.130, 0.140, 0.170, 1)
    pc(ImGuiCol.FrameBgHovered, 0.180, 0.200, 0.240, 1)
    pc(ImGuiCol.FrameBgActive, 0.200, 0.230, 0.280, 1)
    pc(ImGuiCol.TitleBg, 0.070, 0.075, 0.095, 1)
    pc(ImGuiCol.TitleBgActive, 0.110, 0.130, 0.180, 1)
    pc(ImGuiCol.Tab, 0.130, 0.150, 0.190, 1)
    pc(ImGuiCol.TabHovered, 0.220, 0.380, 0.680, 1)
    pc(ImGuiCol.TabActive, 0.180, 0.320, 0.560, 1)
    pc(ImGuiCol.Header, 0.180, 0.320, 0.560, 0.55)
    pc(ImGuiCol.HeaderHovered, 0.220, 0.380, 0.680, 0.80)
    pc(ImGuiCol.HeaderActive, 0.180, 0.320, 0.560, 1)
    pc(ImGuiCol.Button, 0.20, 0.23, 0.29, 1)
    pc(ImGuiCol.ButtonHovered, 0.26, 0.38, 0.54, 1)
    pc(ImGuiCol.ButtonActive, 0.18, 0.32, 0.56, 1)
    pc(ImGuiCol.CheckMark, 0.85, 0.64, 0.25, 1)
    pc(ImGuiCol.TableHeaderBg, 0.125, 0.140, 0.170, 1)
    pc(ImGuiCol.TableRowBg, 0.075, 0.078, 0.092, 1)
    pc(ImGuiCol.TableRowBgAlt, 0.105, 0.110, 0.132, 1)
    pc(ImGuiCol.TableBorderStrong, 0.330, 0.370, 0.460, 1)
    pc(ImGuiCol.TableBorderLight, 0.230, 0.255, 0.320, 1)
    pc(ImGuiCol.Separator, 0.260, 0.300, 0.380, 1)
    pc(ImGuiCol.ScrollbarBg, 0.07, 0.08, 0.10, 1)
    pc(ImGuiCol.ScrollbarGrab, 0.27, 0.31, 0.38, 1)
    return { vars = vars, colors = colors }
end
lazbisTheme.pop = function(state)
    if state.colors > 0 then ImGui.PopStyleColor(state.colors) end
    if state.vars > 0 then ImGui.PopStyleVar(state.vars) end
end
local bisConfig		= require('bis')
local spellConfig	= require('spells')

-- DSK Type 12 focus reference: the Anguish items used to make each focus aug. Display only;
-- kept out of the BiS lists so it creates no loot-link announce matches.
local dskType12Focus = {
    {
        category = "Spell Utility",
        focus = "Alacrity of the Ikaav",
        effect = "Beneficial Spell Haste",
        items = {
            { name = "Earring of Dragonkin", slot = "Ear", id = 47288, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47288" },
            { name = "Glyphwielder's Sleeves of the Summoner", slot = "Arms", id = 70938, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70938" },
            { name = "Ritualchanter's Boots of the Ancestors", slot = "Feet", id = 70920, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70920" },
            { name = "Academic's Slippers of the Arcanists", slot = "Feet", id = 70934, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70934" },
            { name = "Mindreaver's Shoes of Coercion", slot = "Feet", id = 70948, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70948" },
            { name = "Dawnseeker's Boots of the Defender", slot = "Feet", id = 70871, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70871" },
            { name = "Faithbringer's Gloves of Conviction", slot = "Hands", id = 70863, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70863" },
            { name = "Everspring Mitts of the Tangled Briars", slot = "Hands", id = 70891, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70891" },
            { name = "Savagesoul Cap of the Wilds", slot = "Head", id = 70951, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70951" },
            { name = "Bladewhisper Chain Legguards of Journeys", slot = "Legs", id = 70880, source = "AMV or OOM", alla_url = "https://lazaruseq.com/alla/items/70880" },
        },
    },
    {
        category = "Spell Utility",
        focus = "Alacrity of the Aneuk",
        effect = "Detrimental Spell Haste",
        items = {
            { name = "Everspring Sleeves of the Tangled Briars", slot = "Arms", id = 70889, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70889" },
            { name = "Ring of Persecution", slot = "Ring", id = 47290, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47290" },
        },
    },
    {
        category = "Spell Utility",
        focus = "Ikaav Glare",
        effect = "Beneficial Spell Range",
        items = {
            { name = "Earring of Dark Conflict", slot = "Ear", id = 47289, source = "Jelvan", alla_url = "https://lazaruseq.com/alla/items/47289" },
            { name = "Dawnseeker's Coif of the Defender", slot = "Head", id = 70867, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70867" },
        },
    },
    {
        category = "Spell Utility",
        focus = "Aneuk Glare",
        effect = "Detrimental Spell Range",
        items = {
            { name = "Mindreaver's Armguards of Coercion", slot = "Arms", id = 70945, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70945" },
            { name = "Duskbringer's Plate Armguards of the Hateful", slot = "Arms", id = 70882, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70882" },
            { name = "Mask of Forbidden Rites", slot = "Face", id = 47299, source = "AMV", alla_url = "https://lazaruseq.com/alla/items/47299" },
            { name = "Glyphwielder's Gloves of the Summoner", slot = "Hands", id = 70940, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70940" },
            { name = "Academic's Gloves of the Arcanists", slot = "Hands", id = 70933, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70933" },
            { name = "Dawnseeker's Mitts of the Defender", slot = "Hands", id = 70870, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70870" },
        },
    },
    {
        category = "Spell Utility",
        focus = "Avariciousness of the Ikaav",
        effect = "Beneficial Mana Reduction",
        items = {
            { name = "Academic's Cap of the Arcanists", slot = "Head", id = 70930, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70930" },
            { name = "Ring of Deterrence", slot = "Ring", id = 47291, source = "AMV", alla_url = "https://lazaruseq.com/alla/items/47291" },
            { name = "Chains of Anguish", slot = "Waist", id = 47282, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47282" },
        },
    },
    {
        category = "Spell Utility",
        focus = "Avariciousness of the Aneuk",
        effect = "Detrimental Mana Reduction",
        items = {
            { name = "Dawnseeker's Sleeves of the Defender", slot = "Arms", id = 70868, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70868" },
            { name = "Plagueborn Cape", slot = "Back", id = 47306, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47306" },
            { name = "Duskbringer's Plate Helm of the Hateful", slot = "Head", id = 70881, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70881" },
            { name = "Bladewhisper Chain Wristband of Journeys", slot = "Wrist", id = 70876, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70876" },
        },
    },
    {
        category = "Healing / Pet",
        focus = "Blessing of Anguish",
        effect = "Healing",
        items = {
            { name = "Ritualchanter's Armguards of the Ancestors", slot = "Arms", id = 70917, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70917" },
            { name = "Everspring Slippers of the Tangled Briars", slot = "Feet", id = 70892, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70892" },
            { name = "Bladewhisper Chain Boots of Journeys", slot = "Feet", id = 70878, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70878" },
            { name = "Faithbringer's Leggings of Conviction", slot = "Legs", id = 70866, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70866" },
            { name = "Dawnseeker's Leggings of the Defender", slot = "Legs", id = 70873, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70873" },
            { name = "Savagesoul Wristband of the Wilds", slot = "Wrist", id = 70953, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70953" },
            { name = "Ring of Disdain", slot = "Ring", id = 47293, source = "AMV", alla_url = "https://lazaruseq.com/alla/items/47293" },
        },
    },
    {
        category = "Healing / Pet",
        focus = "Keeper's Blessing",
        effect = "Pet Healing",
        items = {
            { name = "Globe of Voltage", slot = "Range", id = 47298, source = "AMV", alla_url = "https://lazaruseq.com/alla/items/47298" },
            { name = "Blightbringer's Armband of the Grave", slot = "Wrist", id = 70924, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70924" },
            { name = "Glyphwielder's Wristband of the Summoner", slot = "Wrist", id = 70939, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70939" },
            { name = "Savagesoul Sleeves of the Wilds", slot = "Arms", id = 70952, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70952" },
        },
    },
    {
        category = "Spell Utility",
        focus = "Bulwark of the Dragorn",
        effect = "Beneficial Spell Duration",
        items = {
            { name = "Faithbringer's Armguards of Conviction", slot = "Arms", id = 70861, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70861" },
            { name = "Bladewhisper Chain Sleeves of Journeys", slot = "Arms", id = 70875, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70875" },
            { name = "Ring of the Beast", slot = "Ring", id = 47292, source = "Hanvar", alla_url = "https://lazaruseq.com/alla/items/47292" },
            { name = "Amice of Ill-Will", slot = "Shoulder", id = 47280, source = "AMV", alla_url = "https://lazaruseq.com/alla/items/47280" },
            { name = "Everspring Wristband of the Tangled Briars", slot = "Wrist", id = 70890, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70890" },
        },
    },
    {
        category = "Spell Utility",
        focus = "Vindication of the Dragorn",
        effect = "Detrimental Spell Duration",
        items = {
            { name = "Ritualchanter's Leggings of the Ancestors", slot = "Legs", id = 70922, source = "AMV or OOM", alla_url = "https://lazaruseq.com/alla/items/70922" },
            { name = "Cloak of Wailing Woes", slot = "Back", id = 47303, source = "Jelvan", alla_url = "https://lazaruseq.com/alla/items/47303" },
            { name = "Necklace of the Steadfast Spirit", slot = "Neck", id = 47275, source = "Ture", alla_url = "https://lazaruseq.com/alla/items/47275" },
            { name = "Belt of the Stagnant", slot = "Waist", id = 47284, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47284" },
            { name = "Blightbringer's Bracer of the Grave", slot = "Wrist", id = 70925, source = "AMV or OOM", alla_url = "https://lazaruseq.com/alla/items/70925" },
            { name = "Duskbringer's Plate Wristguard of the Hateful", slot = "Wrist", id = 70883, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70883" },
        },
    },
    {
        category = "Caster Damage",
        focus = "Thunder of Anguish",
        effect = "Magic Damage",
        items = {
            { name = "Aegis of the Dragorn Elders", slot = "Secondary", id = 47311, source = "Jelvan", alla_url = "https://lazaruseq.com/alla/items/47311" },
            { name = "Academic's Sleeves of the Arcanists", slot = "Arms", id = 70931, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70931" },
            { name = "Duskbringer's Plate Boots of the Hateful", slot = "Feet", id = 70885, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70885" },
            { name = "Blightbringer's Handguards of the Grave", slot = "Hands", id = 70926, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70926" },
            { name = "Bladewhisper Chain Cap of Journeys", slot = "Head", id = 70874, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70874" },
            { name = "Mindreaver's Leggings of Coercion", slot = "Legs", id = 70950, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70950" },
            { name = "Symbol of the Overlord", slot = "Range", id = 47295, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47295" },
            { name = "Dawnseeker's Wristguard of the Defender", slot = "Wrist", id = 70869, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70869" },
        },
    },
    {
        category = "Caster Damage",
        focus = "Fire of Anguish",
        effect = "Fire Damage",
        items = {
            { name = "Stud of Chilling Precision", slot = "Ear", id = 47285, source = "Ture", alla_url = "https://lazaruseq.com/alla/items/47285" },
            { name = "Glyphwielder's Leggings of the Summoner", slot = "Legs", id = 70943, source = "AMV or OOM", alla_url = "https://lazaruseq.com/alla/items/70943" },
        },
    },
    {
        category = "Caster Damage",
        focus = "Frost of Anguish",
        effect = "Ice Damage",
        items = {
            { name = "Cloak of Regretful Transgressions", slot = "Back", id = 47304, source = "Jelvan", alla_url = "https://lazaruseq.com/alla/items/47304" },
            { name = "Academic's Pants of the Arcanists", slot = "Legs", id = 70936, source = "AMV or OOM", alla_url = "https://lazaruseq.com/alla/items/70936" },
            { name = "Everspring Pants of the Tangled Briars", slot = "Legs", id = 70894, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70894" },
            { name = "Savagesoul Legguards of the Wilds", slot = "Legs", id = 70957, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70957" },
        },
    },
    {
        category = "Caster Damage",
        focus = "Plague of Anguish",
        effect = "Disease Damage",
        items = {
            { name = "Duskbringer's Plate Legguards of the Hateful", slot = "Legs", id = 70887, source = "AMV or OOM", alla_url = "https://lazaruseq.com/alla/items/70887" },
            { name = "Belt of Contempt", slot = "Waist", id = 47281, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47281" },
        },
    },
    {
        category = "Caster Damage",
        focus = "Venom of Anguish",
        effect = "Poison Damage",
        items = {
            { name = "Beaded Hoop of Demise", slot = "Ear", id = 47287, source = "AMV", alla_url = "https://lazaruseq.com/alla/items/47287" },
            { name = "Duskbringer's Plate Gloves of the Hateful", slot = "Hands", id = 70884, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70884" },
            { name = "Blightbringer's Pants of the Grave", slot = "Legs", id = 70929, source = "AMV or OOM", alla_url = "https://lazaruseq.com/alla/items/70929" },
            { name = "Ritualchanter's Wristband of the Ancestors", slot = "Wrist", id = 70918, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70918" },
        },
    },
    {
        category = "Melee / Physical",
        focus = "Cleave V",
        effect = "Cleave",
        items = {
            { name = "Savagesoul Sleeves of the Wilds", slot = "Arms", id = 70952, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70952" },
            { name = "Golem Stone Face Guard", slot = "Face", id = 47301, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47301" },
            { name = "Wrathbringer's Chain Boots of the Vindicator", slot = "Feet", id = 70962, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70962" },
            { name = "Whispering Boots of Shadows", slot = "Feet", id = 70913, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70913" },
            { name = "Gladiator's Plate Gloves of War", slot = "Hands", id = 70856, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70856" },
            { name = "Farseeker's Plate Gloves of Harmony", slot = "Hands", id = 70905, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70905" },
        },
    },
    {
        category = "Melee / Physical",
        focus = "Ferocity V",
        effect = "Double Attack",
        items = {
            { name = "Shoulderpads of Warfare", slot = "Shoulder", id = 47279, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47279" },
            { name = "Gladiator's Plate Boots of War", slot = "Feet", id = 70857, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70857" },
            { name = "Farseeker's Plate Legguards of Harmony", slot = "Legs", id = 70908, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70908" },
        },
    },
    {
        category = "Melee / Physical",
        focus = "Improved Dodge V",
        effect = "Improved Dodge",
        items = {
            { name = "Faithbringer's Boots of Conviction", slot = "Feet", id = 70864, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70864" },
            { name = "Whispering Pants of Shadows", slot = "Legs", id = 70915, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70915" },
            { name = "Savagesoul Legguards of the Wilds", slot = "Legs", id = 70957, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70957" },
            { name = "Shroud of Eternal Agony", slot = "Shoulder", id = 47278, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47278" },
        },
    },
    {
        category = "Melee / Physical",
        focus = "Improved Parry / Block V",
        effect = "Block and Parry",
        items = {
            { name = "Fiercehand Tabis of the Focused", slot = "Feet", id = 70899, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70899" },
            { name = "Savagesoul Gloves of the Wilds", slot = "Hands", id = 70954, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70954" },
            { name = "Choker of Imprisoned Visions", slot = "Neck", id = 47274, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47274" },
        },
    },
    {
        category = "Melee / Physical",
        focus = "Sharpshooting V",
        effect = "Ranged Accuracy",
        items = {
            { name = "Rigid Ring of Prowess", slot = "Ring", id = 47294, source = "OMM", alla_url = "https://lazaruseq.com/alla/items/47294" },
            { name = "Wrathbringer's Chain Sleeves of the Vindicator", slot = "Arms", id = 70959, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70959" },
            { name = "Bladewhisper Chain Wristband of Journeys", slot = "Wrist", id = 70876, source = "First Four Names", alla_url = "https://lazaruseq.com/alla/items/70876" },
        },
    },
}

-- DSK Hideous Hex focus augs: `shared` apply to every class, `byClass` is the class stat hex.
local dskHexFocus = { shared = {
  {name="Hideous Hex of Benevolent Efficiency", focus="Benevolent Efficiency", notes="-5% beneficial spell mana cost | +50 hp/mana/endur"},
  {name="Hideous Hex of Benevolent Extension", focus="Benevolent Extension", notes="+35% beneficial spell duration | +50 hp/mana/endur"},
  {name="Hideous Hex of Benevolent Alacrity", focus="Benevolent Alacrity", notes="-35% beneficial spell cast time | +50 hp/mana/endur"},
  {name="Hideous Hex of Malevolent Efficiency", focus="Malevolent Efficiency", notes="-5% detrimental spell mana cost | +50 hp/mana/endur"},
  {name="Hideous Hex of Malevolent Extension", focus="Malevolent Extension", notes="+35% detrimental spell duration | +50 hp/mana/endur"},
  {name="Hideous Hex of Malevolent Alacrity", focus="Malevolent Alacrity", notes="-35% detrimental spell cast time | +50 hp/mana/endur"},
  {name="Hideous Hex of Arcane Demise", focus="Arcane Demise", notes="+5% magic spell damage | +50 hp/mana/endur"},
  {name="Hideous Hex of Fiery Demise", focus="Fiery Demise", notes="+5% fire spell damage | +50 hp/mana/endur"},
  {name="Hideous Hex of Chilling Demise", focus="Chilling Demise", notes="+5% cold spell damage | +50 hp/mana/endur"},
  {name="Hideous Hex of Noxious Demise", focus="Noxious Demise", notes="+5% poison spell damage | +50 hp/mana/endur"},
  {name="Hideous Hex of Festering Demise", focus="Festering Demise", notes="+5% disease spell damage | +50 hp/mana/endur"},
  {name="Hideous Hex of Merciful Mending", focus="Merciful Mending", notes="+5% healing | +50 hp/mana/endur"},
  {name="Hideous Hex of Expanded Reach", focus="Expanded Reach", notes="+40% spell range | +50 hp/mana/endur"},
  {name="Hideous Hex of Nimble Elusion", focus="Nimble Elusion", notes="+60% dodge | +50 hp/mana/endur"},
  {name="Hideous Hex of Adept Guard", focus="Adept Guard", notes="+60% parry, +60% block | +50 hp/mana/endur"},
  {name="Hideous Hex of Visceral Malice", focus="Visceral Malice", notes="+250% melee critical damage | +50 hp/mana/endur"},
  {name="Hideous Hex of Wanton Assault", focus="Wanton Assault", notes="+18% double attack, +6% triple attack, +3% chance to hit | +50 hp/mana/endur"},
  {name="Hideous Hex of Lethal Barrage", focus="Lethal Barrage", notes="+20% archery and throwing chance to hit | +50 hp/mana/endur"},
  {name="Hideous Hex of Companion's Mercy", focus="Companion's Mercy", notes="+30% companion healing | +50 hp/mana/endur"},
}, byClass = {
  ["Enchanter"] = {name="Hideous Hex of Mental Prowess", focus="Mental Prowess", notes="No focus effect | +15 WIS/INT/CHA, +5 STR/STA/AGI/DEX, +130 hp, +360 mana, +13 ac, +10 resists"},
  ["Ranger"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Wizard"] = {name="Hideous Hex of Mental Prowess", focus="Mental Prowess", notes="No focus effect | +15 WIS/INT/CHA, +5 STR/STA/AGI/DEX, +130 hp, +360 mana, +13 ac, +10 resists"},
  ["Beastlord"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Necromancer"] = {name="Hideous Hex of Mental Prowess", focus="Mental Prowess", notes="No focus effect | +15 WIS/INT/CHA, +5 STR/STA/AGI/DEX, +130 hp, +360 mana, +13 ac, +10 resists"},
  ["Shaman"] = {name="Hideous Hex of Mental Prowess", focus="Mental Prowess", notes="No focus effect | +15 WIS/INT/CHA, +5 STR/STA/AGI/DEX, +130 hp, +360 mana, +13 ac, +10 resists"},
  ["Bard"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Monk"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Shadow Knight"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Rogue"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Warrior"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Berserker"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Paladin"] = {name="Hideous Hex of Physical Prowess", focus="Physical Prowess", notes="No focus effect | +15 STR/STA/AGI/DEX, +5 WIS/INT/CHA, +150 hp, +200 mana/endur, +15 ac"},
  ["Magician"] = {name="Hideous Hex of Mental Prowess", focus="Mental Prowess", notes="No focus effect | +15 WIS/INT/CHA, +5 STR/STA/AGI/DEX, +130 hp, +360 mana, +13 ac, +10 resists"},
  ["Cleric"] = {name="Hideous Hex of Mental Prowess", focus="Mental Prowess", notes="No focus effect | +15 WIS/INT/CHA, +5 STR/STA/AGI/DEX, +130 hp, +360 mana, +13 ac, +10 resists"},
  ["Druid"] = {name="Hideous Hex of Mental Prowess", focus="Mental Prowess", notes="No focus effect | +15 WIS/INT/CHA, +5 STR/STA/AGI/DEX, +130 hp, +360 mana, +13 ac, +10 resists"},
}}

-- DoN learned abilities (spells, songs, discs, combat abilities, auras), from TurboGear v1.2.96.
-- They are merged into the level 71 rows of the Spells tab, replacing the source of any spell already listed.
do
    local function ab(opts)
        return {
            display_name = opts[1] or opts.display_name,
            ability_type = opts[2] or opts.ability_type,
            learned_spell_id = opts[3] or opts.learned_spell_id,
            primary_teaching_item_id = opts[4] or opts.primary_teaching_item_id,
            source_type = opts[5] or opts.source_type, -- bundle | standalone
            source_name = opts[6] or opts.source_name,
            source_container_item_id = opts[7] or opts.source_container_item_id,
            required_level = opts[8] or opts.required_level or 71,
            alternate_teaching_item_ids = opts.alts or opts.alternate_teaching_item_ids,
            teaching_item_name = opts.teach_name or opts.teaching_item_name,
        }
    end

    -- Shorthand: display, type, spell_id, teach_id, source_type, source_name, container, level
    local B = function(name, atype, sid, tid, pack, cid, lvl, extra)
        extra = extra or {}
        return ab({
            name, atype, sid, tid, 'bundle', pack, cid, lvl or 71,
            alts = extra.alts,
            teach_name = extra.teach_name,
        })
    end

    local S = function(name, atype, sid, tid, lvl, extra)
        extra = extra or {}
        return ab({
            name, atype, sid, tid, 'standalone', 'Standalone', nil, lvl or 71,
            alts = extra.alts,
            teach_name = extra.teach_name,
        })
    end

    local donSpellCatalog = {
        ['Warrior'] = {
            S('Field Conqueror', 'Discipline', 25036, 88919, 71, { teach_name = 'Tome of Field Conqueror' }),
            S('Final Stand Discipline', 'Discipline', 10965, 79302, 71, { teach_name = 'Tome of Final Stand Discipline' }),
            S('Fourth Wind Discipline', 'Discipline', 15134, 80081, 71, { teach_name = 'Tome of Fourth Wind' }),
            S('Jeer', 'Combat Ability', 10848, 88909, 71, { teach_name = 'Tome of Jeer' }),
            S('Maelstrom Blade', 'Combat Ability', 10973, 79310, 71, { teach_name = 'Tome of Maelstrom Blade' }),
            S('Maximum Effort Discipline', 'Discipline', 15104, 80080, 71, { teach_name = 'Tome of Maximum Effort' }),
            S('Roaring Hatred', 'Combat Ability', 19537, 88910, 71, { teach_name = 'Tome of Roaring Hatred' }),
            S("Vanquisher's Aura", 'Aura', 14351, 88925, 71, { teach_name = "Tome of Vanquisher's Aura" }),
        },

        ['Cleric'] = {
            B('Aegis of Vie', 'Spell', 9742, 78079, 'Spell Pack: Aegis of Vie', 82661, 71, { teach_name = 'Spell: Aegis of Vie' }),
            B('Allegiance', 'Spell', 9730, 78067, 'Spell Pack: Allegiance', 82658, 71, { teach_name = 'Spell: Allegiance' }),
            B('Hand of Allegiance', 'Spell', 9809, 78146, 'Spell Pack: Allegiance', 82658, 71, { teach_name = 'Spell: Hand of Allegiance' }),
            B('Symbol of Elushar', 'Spell', 9709, 78046, 'Spell Pack: Allegiance', 82658, 71, { teach_name = 'Spell: Symbol of Elushar' }),
            B('Armor of the Sacred', 'Spell', 9703, 78040, 'Spell Pack: Armor of the Sacred', 82660, 71, { teach_name = 'Spell: Armor of the Sacred' }),
            S('Chromablast', 'Spell', 15140, 80284, 71, { teach_name = 'Spell: Chromablast' }),
            S('Divine Redemption', 'Spell', 25252, 124941, 71, { teach_name = 'Spell: Divine Redemption' }),
            S('Elixir of Redemption', 'Spell', 9812, 78149, 71, { teach_name = 'Spell: Elixir of Redemption' }),
            S('Sound of Zeal', 'Spell', 9749, 78086, 71, { teach_name = 'Spell: Sound of Zeal' }),
            S('Urgent Renewal', 'Spell', 15135, 80282, 71, { teach_name = 'Spell: Urgent Renewal' }),
            S('Vigilant Censure', 'Spell', 15137, 80283, 71, { teach_name = 'Spell: Vigilant Censure' }),
        },

        ['Paladin'] = {
            B('Armor of the Savior', 'Spell', 10197, 78534, 'Spell Pack: Armor of the Savior', 82810, 71, { teach_name = 'Spell: Armor of the Savior' }),
            B('Virtuous Fervor', 'Spell', 10215, 78552, 'Spell Pack: Virtuous Fervor', 82811, 71, { teach_name = 'Spell: Virtuous Fervor' }),
            B('Wave of the Stillmoon', 'Spell', 10206, 78543, 'Spell Pack: Wave of the Stillmoon', 82812, 71, { teach_name = 'Spell: Wave of the Stillmoon' }),
            S('Aegis of Righteousness', 'Discipline', 11854, 79399, 71, { teach_name = 'Tome of Aegis of Righteousness' }),
            S('Benevolent Aura', 'Aura', 15251, 81864, 71, { teach_name = 'Spell: Benevolent Aura' }),
            S("Brell's Unshakable Barricade", 'Spell', 15248, 81862, 71, { teach_name = "Spell: Brell's Unshakable Barricade" }),
            S('Force of the Sacred', 'Spell', 15240, 81861, 71, { teach_name = 'Spell: Force of the Sacred' }),
            S('Force of the Sentinel', 'Spell', 15249, 81863, 71, { teach_name = 'Spell: Force of the Sentinel' }),
            S('The Silent Decree', 'Spell', 10919, 78039, 71, { teach_name = 'Spell: The Silent Decree' }),
        },

        ['Ranger'] = {
            B('Call of Storms', 'Spell', 10134, 78471, 'Spell Pack: Call of Storms', 82815, 71, { teach_name = 'Spell: Call of Storms' }),
            B('Embers of the Delve', 'Spell', 10116, 78453, 'Spell Pack: Flame and Frost', 50150, 71, { teach_name = 'Spell: Embers of the Delve' }),
            B('Frost of the Ascent', 'Spell', 10104, 78441, 'Spell Pack: Flame and Frost', 50150, 71, { teach_name = 'Spell: Frost of the Ascent' }),
            B('Guard of Thundercrest', 'Spell', 15076, 116076, 'Spell Pack: Guard of Thundercrest', 82814, 71, { teach_name = 'Spell: Guard of Thundercrest' }),
            B('Snarl of the Predator', 'Spell', 10113, 78450, 'Spell Pack: Snarl of the Predator', 82813, 71, { teach_name = 'Spell: Snarl of the Predator' }),
            S('Eyes of the Drake', 'Spell', 15255, 81866, 71, { teach_name = 'Spell: Eyes of the Drake' }),
            S('Heartshatter', 'Spell', 15082, 116082, 71, { teach_name = 'Spell: Heartshatter' }),
            S('Swift Salve of the Stillmoon', 'Spell', 15257, 81867, 71, { teach_name = 'Spell: Swift Salve of the Stillmoon' }),
            S('Ward of the Stalker', 'Spell', 15254, 81865, 71, { teach_name = 'Spell: Ward of the Stalker' }),
        },

        ['Shadow Knight'] = {
            B('Cloak of the Corrupter', 'Spell', 10300, 78637, 'Spell Pack: Cloak of the Corrupter', 82807, 71, { teach_name = 'Spell: Cloak of the Corrupter' }),
            B('Shroud of the Accursed', 'Spell', 10251, 78588, 'Spell Pack: Shroud of the Accursed', 82808, 71, { teach_name = 'Spell: Shroud of the Accursed' }),
            B('Theft of Misery', 'Spell', 15073, 71777, 'Spell Pack: Theft of Misery', 82809, 71, { teach_name = 'Spell: Theft of Misery' }),
            S('Blood of the Harbinger', 'Spell', 15233, 80788, 71, { teach_name = 'Spell: Blood of the Harbinger' }),
            S("Grasp of Ju'rek", 'Spell', 10913, 78565, 71, { teach_name = "Spell: Grasp of Ju'rek" }),
            S('Soul Carapace', 'Discipline', 11866, 79408, 71, { teach_name = 'Tome of Soul Carapace' }),
            S("Terror of Lavaspinner's Lair", 'Spell', 10257, 78594, 71, { teach_name = "Spell: Terror of Lavaspinner's Lair" }),
            S('Touch of the Shadows', 'Spell', 15231, 80787, 71, { teach_name = 'Spell: Touch of the Shadows' }),
            S('Voice of Emoush', 'Spell', 15239, 81860, 71, { teach_name = 'Spell: Voice of Emoush' }),
        },

        ['Druid'] = {
            B('Blessing of Moss', 'Spell', 15280, 116280, 'Spell Pack: Clumped Moss', 82777, 71, { teach_name = 'Spell: Blessing of Moss' }),
            B('Mossy Vigor', 'Spell', 15235, 116235, 'Spell Pack: Clumped Moss', 82777, 71, { teach_name = 'Spell: Mossy Vigor' }),
            B('Blessing of Spiritoak', 'Spell', 9929, 78266, 'Spell Pack: Spiritoaks', 82688, 71, { teach_name = 'Spell: Blessing of Spiritoak' }),
            B('Spiritoak Skin', 'Spell', 9872, 78209, 'Spell Pack: Spiritoaks', 82688, 71, { teach_name = 'Spell: Spiritoak Skin' }),
            B("Sun's Blistering Corona", 'Spell', 9824, 78161, "Spell Pack: Sun's Blistering Corona", 82778, 71, { teach_name = "Spell: Sun's Blistering Corona" }),
            S('Ascent Frost', 'Spell', 15153, 80757, 71, { teach_name = 'Spell: Ascent Frost' }),
            S('Breath of the Ascent', 'Spell', 9863, 78200, 71, { teach_name = 'Spell: Breath of the Ascent' }),
            S('Dawnflame', 'Spell', 15156, 80758, 71, { teach_name = 'Spell: Dawnflame' }),
            S('Lunar Shadow', 'Spell', 15165, 80759, 71, { teach_name = 'Spell: Lunar Shadow' }),
            S("Nature Seeker's Behest", 'Spell', 10839, 117592, 71, { teach_name = "Spell: Nature Seeker's Behest" }),
            S("Sunburst Devotion", 'Spell', 15152, 80756, 71, { teach_name = 'Spell: Sunburst Devotion' }),
        },

        ['Monk'] = {
            S('Arcane Reprisal', 'Discipline', 10889, 79226, 71, { teach_name = 'Tome of Arcane Reprisal' }),
            S('Dragondance Discipline', 'Discipline', 15113, 88921, 71, { teach_name = 'Tome of Dragondance Discipline' }),
            S('Fists of Thundercrest', 'Combat Ability', 10854, 50117, 71, { teach_name = 'Tome of Fists of Thundercrest' }),
            S('Fourth Wind Discipline', 'Discipline', 15134, 80081, 71, { teach_name = 'Tome of Fourth Wind' }),
            S("Grandmaster's Aura", 'Aura', 15095, 80078, 71, { teach_name = "Tome of Grandmaster's Aura" }),
            S('Phantom Whispers', 'Combat Ability', 18904, 118654, 71, { teach_name = 'Tome of Phantom Whispers' }),
            S('Stormfist Discipline', 'Discipline', 11923, 79445, 71, { teach_name = 'Tome of Stormfist Discipline' }),
            S('Velocity Focus Discipline', 'Discipline', 15101, 80083, 71, { teach_name = 'Tome of Velocity Focus Discipline' }),
            S('Wheel of Fists', 'Combat Ability', 14797, 88901, 71, { teach_name = 'Tome of Wheel of Fists' }),
        },

        ['Bard'] = {
            B('Cantata of Nife', 'Song', 10948, 50158, 'Spell Pack: Cantata of Nife', 82821, 71, { teach_name = 'Song: Cantata of Nife' }),
            B('Chorus of Nife', 'Song', 10949, 50159, 'Spell Pack: Cantata of Nife', 82821, 71, { teach_name = 'Song: Chorus of Nife' }),
            B('Echoes of the Ancient', 'Song', 15081, 76562, 'Spell Pack: Echoes of the Ancient', 82823, 71, {
                alts = { 81936 },
                teach_name = 'Song: Echoes of the Ancient',
            }),
            B('Symphony of Sound', 'Song', 10936, 50155, 'Spell Pack: Symphony of Sound', 82822, 71, { teach_name = 'Song: Symphony of Sound' }),
            S('Arcane Reprisal', 'Discipline', 10889, 79226, 71, { teach_name = 'Tome of Arcane Reprisal' }),
            S('Endless Blades', 'Discipline', 10939, 50156, 71, { teach_name = 'Tome of Endless Blades' }),
            S("Niv's Symphonic", 'Song', 15264, 81935, 71, { teach_name = "Song: Niv's Symphonic" }),
            S('One Bard Band', 'Song', 35234, 78739, 71, { teach_name = 'Song: One Bard Band' }),
            S('Squall Blade Flourish', 'Combat Ability', 10940, 50157, 71, { teach_name = 'Song: Squall Blade' }),
        },

        ['Rogue'] = {
            S('Arcane Reprisal', 'Discipline', 10889, 79226, 71, { teach_name = 'Tome of Arcane Reprisal' }),
            S('Assailant Discipline', 'Discipline', 15117, 80087, 71, { teach_name = 'Tome of Assailant Discipline' }),
            S('Fourth Wind Discipline', 'Discipline', 15134, 80081, 71, { teach_name = 'Tome of Fourth Wind' }),
            S('Frenetic Stabbing Discipline', 'Discipline', 15119, 80088, 71, { teach_name = 'Tome of Frenetic Stabbing Discipline' }),
            S('Lithe Discipline', 'Discipline', 15102, 80085, 71, { teach_name = 'Tome of Lithe Discipline' }),
            S("Outlaw's Glare", 'Combat Ability', 40294, 88900, 71, { teach_name = "Tome of Outlaw's Glare" }),
            S('Pinpoint Weakness', 'Combat Ability', 15115, 88902, 71, { teach_name = 'Tome of Pinpoint Weakness' }),
            S('Twisted Fortune Discipline', 'Discipline', 10852, 50116, 71, { teach_name = 'Tome of Twisted Fortune Discipline' }),
            S('Vigorous Dagger Throw', 'Combat Ability', 10851, 79236, 71, { teach_name = 'Tome of Vigorous Dagger Throw' }),
        },

        ['Shaman'] = {
            B('Black Scorpion Companion', 'Spell', 10829, 117584, 'Spell Pack: Wild Companions', 50107, 71, { teach_name = 'Spell: Black Scorpion Companion' }),
            B('Blood Raptor Companion', 'Spell', 10832, 117587, 'Spell Pack: Wild Companions', 50107, 71, { teach_name = 'Spell: Blood Raptor Companion' }),
            B('Cunning Lioness Companion', 'Spell', 10823, 117581, 'Spell Pack: Wild Companions', 50107, 71, { teach_name = 'Spell: Cunning Lioness Companion' }),
            B('Gray Elephant Companion', 'Spell', 10824, 117583, 'Spell Pack: Wild Companions', 50107, 71, { teach_name = 'Spell: Gray Elephant Companion' }),
            B('Sea Cow Companion', 'Spell', 10833, 117591, 'Spell Pack: Wild Companions', 50107, 71, { teach_name = 'Spell: Sea Cow Companion' }),
            B('Wooly Rhino Companion', 'Spell', 10830, 117586, 'Spell Pack: Wild Companions', 50107, 71, { teach_name = 'Spell: Wooly Rhino Companion' }),
            B('Blood of Volkara', 'Spell', 10818, 55745, 'Spell Pack: Blood of Volkara', 82663, 71, { teach_name = 'Spell: Blood of Volkara' }),
            B('Stillmoon Focusing', 'Spell', 10005, 78342, 'Spell Pack: Stillmoon Focus', 82662, 71, { teach_name = 'Spell: Stillmoon Focusing' }),
            B('Talisman of the Stillmoon', 'Spell', 10056, 78393, 'Spell Pack: Stillmoon Focus', 82662, 71, { teach_name = 'Spell: Talisman of the Stillmoon' }),
            B('Talisman of Coalescence', 'Spell', 10821, 117580, 'Spell Pack: Talisman of Coalescence', 82664, 71, { teach_name = 'Spell: Talisman of Coalescence' }),
            B('Talisman of the Cougar', 'Spell', 15238, 116238, 'Spell Pack: Talisman of the Cougar', 82665, 71, { teach_name = 'Spell: Talisman of the Cougar' }),
            S('Breath of Shadows', 'Spell', 41232, 80285, 71, { teach_name = 'Spell: Breath of Shadows' }),
            S('Curse of Emoush', 'Spell', 15147, 80288, 71, { teach_name = 'Spell: Curse of Emoush' }),
            S('Shadowy Sloth', 'Spell', 15144, 80287, 71, { teach_name = 'Spell: Shadowy Sloth' }),
            S('Transcendental Torpor', 'Spell', 15141, 80286, 71, { teach_name = 'Spell: Transcendental Torpor' }),
        },

        ['Necromancer'] = {
            B('Dull Agony', 'Spell', 10910, 78814, 'Spell Pack: Dull Agony', 82806, 71, { teach_name = 'Spell: Dull Agony' }),
            B("Goner's Urgent Renewal", 'Spell', 10738, 79075, "Spell Pack: Goner's Urgent Renewal", 82800, 71, { teach_name = "Spell: Goner's Urgent Renewal" }),
            B('Sacrilege of the Wraith', 'Spell', 10476, 78808, 'Spell Pack: Sacrilege of the Wraith', 82805, 71, { teach_name = 'Spell: Sacrilege of the Wraith' }),
            S('Malignant Plague', 'Spell', 15230, 80786, 71, { teach_name = 'Spell: Malignant Plague' }),
            S('Molten Pyre', 'Spell', 15225, 80785, 71, { teach_name = 'Spell: Molten Pyre' }),
            S('Pestilent Pustules', 'Spell', 10906, 119599, 71, { teach_name = 'Spell: Pestilent Pustules' }),
            S('Ritual of Blood', 'Spell', 10482, 78819, 71, { teach_name = 'Spell: Ritual of Blood' }),
            S('Venom of the Accursed Nest', 'Spell', 10555, 78892, 71, { teach_name = 'Spell: Venom of the Accursed Nest' }),
            S('Yearning of Death', 'Spell', 15222, 80784, 71, { teach_name = 'Spell: Yearning of Death' }),
        },

        ['Wizard'] = {
            B('Bolster of the Sorcerer', 'Spell', 10773, 79110, 'Spell Pack: Bolster of the Sorcerer', 82795, 71, { teach_name = 'Spell: Bolster of the Sorcerer' }),
            B('Ethereal Weave', 'Spell', 10861, 79107, 'Spell Pack: Ethereal Weave', 82797, 71, { teach_name = 'Spell: Ethereal Weave' }),
            B('Supernal Skin', 'Spell', 10864, 79201, 'Spell Pack: Supernal Skin', 82796, 71, { teach_name = 'Spell: Supernal Skin' }),
            S('Arcane Sanctuary', 'Spell', 15180, 80763, 71, { teach_name = 'Spell: Arcane Sanctuary' }),
            S('Eruption of Telakemara', 'Spell', 15167, 80760, 71, { teach_name = 'Spell: Eruption of Telakemara' }),
            S('Ether Blaze', 'Spell', 11835, 79388, 71, { teach_name = 'Spell: Ether Blaze' }),
            S("Evoker's Pyromantic Blade", 'Spell', 15168, 80761, 71, { teach_name = "Spell: Evoker's Pyromantic Blade" }),
            S('Serenity Harvest', 'Spell', 10792, 79129, 71, { teach_name = 'Spell: Serenity Harvest' }),
            S('Wildmagic Salvo', 'Spell', 11840, 79390, 71, { teach_name = 'Spell: Wildmagic Salvo' }),
        },

        ['Magician'] = {
            B('Circle of Magmaskin', 'Spell', 10747, 79084, 'Spell Pack: Circle of Magmaskin', 82799, 71, { teach_name = 'Spell: Circle of Magmaskin' }),
            B("Goner's Urgent Renewal", 'Spell', 10738, 79075, "Spell Pack: Goner's Urgent Renewal", 82800, 71, { teach_name = "Spell: Goner's Urgent Renewal" }),
            B('Ward of the Conjurer', 'Spell', 10885, 78038, 'Spell Pack: Ward of the Conjurer', 82798, 71, { teach_name = 'Spell: Ward of the Conjurer' }),
            S('Blade Rend', 'Spell', 15191, 80766, 71, { teach_name = 'Spell: Blade Rend' }),
            S('Burning Bladestorm', 'Spell', 10890, 50144, 71, { teach_name = 'Spell: Burning Bladestorm' }),
            S('Fickle Inferno', 'Spell', 10754, 79091, 71, { teach_name = 'Spell: Fickle Inferno' }),
            S('Frantic Blaze', 'Spell', 15182, 80764, 71, { teach_name = 'Spell: Frantic Blaze' }),
            S('Grant Battle Materiel', 'Spell', 15192, 80779, 71, { teach_name = 'Spell: Grant Battle Materiel' }),
            S('Monolithic Strength', 'Spell', 15188, 80765, 71, { teach_name = 'Spell: Monolithic Strength' }),
        },

        ['Enchanter'] = {
            B('Edict of Tashan', 'Spell', 14515, 115515, 'Spell Pack: Edict of Tashan', 82804, 71, { teach_name = 'Spell: Edict of Tashan' }),
            B('Hastening of Ellowind', 'Spell', 10659, 78996, 'Spell Pack: Ellowind Hastening', 82802, 71, { teach_name = 'Spell: Hastening of Ellowind' }),
            B('Speed of Ellowind', 'Spell', 10602, 78939, 'Spell Pack: Ellowind Hastening', 82802, 71, { teach_name = 'Spell: Speed of Ellowind' }),
            B('Presidio of the Seer', 'Spell', 10583, 78920, 'Spell Pack: Presidio of the Seer', 82803, 71, { teach_name = 'Spell: Presidio of the Seer' }),
            B("Seer's Intuition", 'Spell', 10617, 78954, 'Spell Pack: Intuition', 82801, 71, { teach_name = "Spell: Seer's Intuition" }),
            B('Voice of Intuition', 'Spell', 10662, 78999, 'Spell Pack: Intuition', 82801, 71, { teach_name = 'Spell: Voice of Intuition' }),
            S('Boon of the Sentinel', 'Spell', 10902, 50149, 71, { teach_name = 'Spell: Boon of the Sentinel' }),
            S('Chromatic Chaos', 'Spell', 15212, 80781, 71, { teach_name = 'Spell: Chromatic Chaos' }),
            S('Hysteria', 'Spell', 15216, 80783, 71, { teach_name = 'Spell: Hysteria' }),
            S('Urgent Rune of Destiny', 'Spell', 15213, 80782, 71, { teach_name = 'Spell: Urgent Rune of Destiny' }),
            S('Whispers of Emoush', 'Spell', 10656, 80780, 71, { teach_name = 'Spell: Whispers of Emoush' }),
        },

        ['Beastlord'] = {
            B('Feral Exigency', 'Spell', 14099, 115099, "Spell Pack: Sha's Urgent Renewal", 82820, 71, { teach_name = 'Spell: Feral Exigency' }),
            B("Sha's Urgent Renewal", 'Spell', 14093, 115093, "Spell Pack: Sha's Urgent Renewal", 82820, 71, { teach_name = "Spell: Sha's Urgent Renewal" }),
            B('Growl of the Mountain Puma', 'Spell', 14170, 115170, 'Spell Pack: Growl of the Mountain Puma', 82819, 71, { teach_name = 'Spell: Growl of the Mountain Puma' }),
            B('Roaring Spirit of Tirranun', 'Spell', 10349, 78686, 'Spell Pack: Roaring Spirit of Tirranun', 82818, 71, { teach_name = 'Spell: Roaring Spirit of Tirranun' }),
            B('Spiritual Vibrance', 'Spell', 10339, 78676, 'Spell Pack: Spiritual Vibrance', 82817, 71, { teach_name = 'Spell: Spiritual Vibrance' }),
            S('Feral Mettle', 'Spell', 15261, 81933, 71, { teach_name = 'Spell: Feral Mettle' }),
            S('Ravenous Ice', 'Spell', 15263, 81934, 71, { teach_name = 'Spell: Ravenous Ice' }),
            S('Roaring Sleet', 'Spell', 10364, 78701, 71, { teach_name = 'Spell: Roaring Sleet' }),
            S('Spiritual Enlightenment', 'Spell', 15260, 81868, 71, { teach_name = 'Spell: Spiritual Enlightenment' }),
            S('Swift Salve of the Stillmoon', 'Spell', 15257, 81867, 71, { teach_name = 'Spell: Swift Salve of the Stillmoon' }),
        },

        ['Berserker'] = {
            S('Arcane Reprisal', 'Discipline', 10889, 79226, 71, { teach_name = 'Tome of Arcane Reprisal' }),
            S('Bloodcurdling Scream', 'Combat Ability', 10915, 79251, 71, { teach_name = 'Tome of Bloodcurdling Scream' }),
            S('Cleaving Madness Discipline', 'Discipline', 10860, 50120, 71, { teach_name = 'Tome of Cleaving Madness Discipline' }),
            S('Cry of Catastrophe', 'Combat Ability', 10857, 50118, 71, { teach_name = 'Tome of Cry of Catastrophe' }),
            S('Fourth Wind Discipline', 'Discipline', 15134, 80081, 71, { teach_name = 'Tome of Fourth Wind' }),
            S('Rancorous Flurry Discipline', 'Discipline', 15120, 80280, 71, { teach_name = 'Tome of Rancorous Flurry Discipline' }),
            S('Vigorous Axe Throw', 'Combat Ability', 10858, 50119, 71, { teach_name = 'Tome of Vigorous Axe Throw' }),
            S('Wounding Rage', 'Discipline', 15122, 80281, 71, { teach_name = 'Tome of Wounded Rage Discipline' }),
        },
    }

    for className, abilities in pairs(donSpellCatalog) do
        local classSpells = spellConfig[className]
        if classSpells then
            classSpells[71] = classSpells[71] or {}
            local existing = {}
            for index, text in ipairs(classSpells[71]) do
                local name = text:match('^([^|]+)')
                existing[name] = index
            end
            for _, ability in ipairs(abilities) do
                local name = ability.display_name
                if name and name ~= '' then
                    local source = ability.source_name
                    if not source or source == 'Standalone' then
                        source = ability.teaching_item_name or 'Dragons of Norrath'
                    end
                    local row = name .. '|' .. source
                    if existing[name] then
                        classSpells[71][existing[name]] = row
                    else
                        classSpells[71][#classSpells[71] + 1] = row
                        existing[name] = #classSpells[71]
                    end
                end
            end
        end
    end
end

-- Type 12 matrix rows (from TurboGear). `source` names both "Cryptic Clutch of X" and "Hideous Hex of X".
local type12Matrix = {
	rows = {
		{label = 'Increased Healing', source = 'Merciful Mending', color = 'healing'},
		{label = 'Extended Reach', source = 'Expanded Reach', color = 'beneficial'},
		{label = 'Beneficial Extension', source = 'Benevolent Extension', color = 'beneficial'},
		{label = 'Beneficial Mana Reduction', source = 'Benevolent Efficiency', color = 'beneficial'},
		{label = 'Beneficial Cast Time Reduction', source = 'Benevolent Alacrity', color = 'beneficial'},
		{label = 'Detrimental Extension', source = 'Malevolent Extension', color = 'detrimental'},
		{label = 'Detrimental Mana Reduction', source = 'Malevolent Efficiency', color = 'detrimental'},
		{label = 'Detrimental Cast Time Reduction', source = 'Malevolent Alacrity', color = 'detrimental'},
		{label = 'Magic Damage', source = 'Arcane Demise', color = 'magic'},
		{label = 'Fire Damage', source = 'Fiery Demise', color = 'fire'},
		{label = 'Ice Damage', source = 'Chilling Demise', color = 'ice'},
		{label = 'Poison Damage', source = 'Noxious Demise', color = 'poison'},
		{label = 'Disease Damage', source = 'Festering Demise', color = 'disease'},
		{label = 'Cleave', source = 'Visceral Malice', color = 'melee'},
		{label = 'Double Attack', source = 'Wanton Assault', color = 'melee'},
		{label = 'Ranged Accuracy', source = 'Lethal Barrage', color = 'melee'},
		{label = 'Improved Dodge', source = 'Nimble Elusion', color = 'defense'},
		{label = 'Block and Parry', source = 'Adept Guard', color = 'defense'},
	},
	colors = {
		healing = {0.46, 0.86, 0.46, 1.00},
		beneficial = {0.38, 0.76, 0.86, 1.00},
		detrimental = {0.62, 0.52, 0.80, 1.00},
		magic = {0.86, 0.48, 0.86, 1.00},
		fire = {0.96, 0.46, 0.30, 1.00},
		ice = {0.42, 0.66, 0.96, 1.00},
		poison = {0.46, 0.86, 0.40, 1.00},
		disease = {0.66, 0.66, 0.36, 1.00},
		melee = {0.96, 0.66, 0.30, 1.00},
		defense = {0.36, 0.60, 0.96, 1.00},
		DoN = {0.40, 0.86, 0.46, 1.00},
		DSK = {0.62, 0.58, 0.92, 1.00},
		['-'] = {0.50, 0.55, 0.62, 1.00},
		['...'] = {0.38, 0.42, 0.48, 1.00},
	},
}

local function donInventoryText(entry)
    if type(entry) == 'string' then return entry end
    if type(entry) ~= 'table' then return '' end
    local seen, parts = {}, {}
    local function add(value)
        if value ~= nil then
            local name = tostring(value)
            if name ~= '' and not seen[name] then
                seen[name] = true
                parts[#parts + 1] = name
            end
        end
    end
    -- The primary label is first, preserving LazBis's existing display rules.
    if entry.item then
        for part in tostring(entry.item):gmatch('[^/]+') do add(part) end
    end
    for _, name in ipairs(entry.names or {}) do add(name) end
    for _, id in ipairs(entry.ids or {}) do add(id) end
    return table.concat(parts, '/')
end
-- Keep Type 12 focus items in a separate catalog for their dedicated tab.
bisConfig.type12 = { Template = {}, Main = { Slots = {} } }
local focusSlots = {}
local donFocusReference, seenFocus = {}, {}
for i = 1, 12 do focusSlots[i] = 'Aug' .. i end
for className, bucket in pairs(bisConfig.don or {}) do
    if className ~= 'Main' and className ~= 'Template' and type(bucket) == 'table' then
        local foci = {}
        for _, slot in ipairs(focusSlots) do
            if bucket[slot] then
                local entry = bucket[slot]
                local crypticName = nil
                if type(entry) == 'table' then
                    for _, name in ipairs(entry.names or {}) do
                        if name:match('^Cryptic Clutch of ') then crypticName = name break end
                    end
                end
                if crypticName then foci[slot] = crypticName end
                if type(entry) == 'table' and entry.item and not seenFocus[entry.item] then
                    seenFocus[entry.item] = true
                    donFocusReference[#donFocusReference + 1] = entry
                end
                bucket[slot] = nil
            end
        end
        bisConfig.type12[className] = foci
    end
end
table.sort(donFocusReference, function(a, b) return a.item < b.item end)
for bucketName, bucket in pairs(bisConfig.don or {}) do
    if bucketName ~= 'Main' and type(bucket) == 'table' then
        for slot, entry in pairs(bucket) do
            if slot:match('^Pack%d+$') then
                bucket[slot] = nil -- learned spells belong in the Spells tab
            elseif type(entry) == 'table' then
                bucket[slot] = donInventoryText(entry)
            end
        end
    end
end
for className, bucket in pairs(bisConfig.type12) do
    if className ~= 'Main' and className ~= 'Template' then
        for slot, entry in pairs(bucket) do bucket[slot] = donInventoryText(entry) end
    end
end
local PackageMan	= require('mq/PackageMan')
local icons			= require('mq/icons')
local sql			= PackageMan.Require('lsqlite3')
local dbpath		= string.format('%s\\%s', mq.TLO.MacroQuest.Path('resources')(), 'lazbis.db')
local ok, actors	= pcall(require, 'actors')
if not ok then
	printf('Your version of MacroQuest does not support Lua Actors, exiting.')
	mq.exit()
end

-- UI States
local openGUI		= true
local shouldDrawGUI	= true
local minimizedGUI	= false
local currentTab	= nil

-- Character info storage
local gear				= {}
local type12Gear		= {}
local type12ScanQueue	= {}
local autoRefreshQueue = {}
local raidTiers = {
	cache = {}, queue = {},
	level = {anguish=1, dsk=2, don=3},
	gearSlots = {
		Head=true, Chest=true, Arms=true, Wrist1=true, Wrist2=true,
		Hands=true, Legs=true, Feet=true, Shoulder=true, Ear1=true,
		Ear2=true, Face=true, Neck=true, Back=true, Waist=true,
		Finger1=true, Finger2=true, MainHand=true, Secondary=true,
		Ranged=true,
	},
}
local group				= {}
local sortedGroup		= {}
-- Gear-tab toon column order state, kept in one table so functions that need it
-- (including the big bisGUI closure) only capture a single upvalue.
local gearOrder			= {
	order = {},		-- user-defined, persisted display order of toon names
	current = {},	-- current frame's toon order (built from .order), used by the Gear table
	rowWidth = 0,	-- measured width of the "Characters...Reorder Toons" row, used to center it
	dragName = nil,	-- toon whose Gear table header is currently being dragged
}
local itemChecks		= {}
local tradeskills		= {}
local emptySlots		= {}
local teams				= {}
local spellData			= {}
local groupSpellData	= {}

-- Item list information
local selectedItemList	= bisConfig.ItemLists[bisConfig.DefaultItemList.group][bisConfig.DefaultItemList.index]
local itemList			= bisConfig.sebilis
local selectionChanged	= true
local firstTimeLoad		= true
local settings			= {ShowSlots=true,ShowMissingOnly=false,AnnounceNeeds=false,AnnounceChannel='Group',Locked=false}
local orderedSkills		= {'Baking', 'Blacksmithing', 'Brewing', 'Fletching', 'Jewelry Making', 'Pottery', 'Tailoring'}
local recipeQuestIdx	= 1
local ingredientsArray	= {}
local reapplyFilter		= false
local slots				= {'charm','leftear','head','face','rightear','neck','shoulder','arms','back','leftwrist','rightwrist','ranged','hands','mainhand','offhand','leftfinger','rightfinger','chest','legs','feet','waist','powersource'}
local hideOwnedSpells	= false
-- Spells tab layout: each character gets its own fixed-width table, laid out
-- side by side inside a horizontally scrollable child window.
local SPELL_TABLE_HEIGHT	= 350
local spellColumnWidth		= 560

local server		= mq.TLO.EverQuest.Server()
local dbfmt			= "INSERT INTO Inventory VALUES ('%s','%s','%s','%s','%s','%s',%d,%d,'%s');\n"
local db
local actor
-- Like TurboGear, lazbis uses a named mailbox with the mailbox in every address, so messages also
-- reach clients on other computers. Messages go straight to a character; a running character that
-- doesn't answer a request within 5 seconds is switched to a broadcast to the whole mailbox, with
-- the recipient's name inside.
-- A mailbox address without a script only reaches that mailbox in the sender's own script, so
-- every message is addressed to both the window (lazbis) and the background helper (lazbis/bg).
local mail = {box = 'lazbis_mail', named = false, bcast = {}, pending = {}, heard = {}}
mail.scripts = {meta.name, meta.name .. '/bg'}
mail.broadcast = function(content)
	if not mail.named then actor:send(content) return end
	for _, script in ipairs(mail.scripts) do actor:send({mailbox = mail.box, script = script}, content) end
end
mail.direct = function(name, content)
	if not mail.named then actor:send({character = name}, content) return end
	for _, script in ipairs(mail.scripts) do actor:send({mailbox = mail.box, script = script, character = name}, content) end
end
mail.requests = {search = true, tsquery = true, searchempties = true, searchspells = true, dzquery = true, pingreq = true}
mail.me = function() return tostring(mq.TLO.Me.CleanName() or '') end
mail.send = function(name, content)
	content.to = name
	content.from = mail.me()
	if mail.bcast[name] then
		content.via = 'mailbox'
		mail.broadcast(content)
		return
	end
	content.via = nil
	if mail.requests[content.id] and mail.heard[name] and not mail.pending[name] then
		mail.pending[name] = {at = mq.gettime(), content = content}
	end
	mail.direct(name, content)
end
-- When the window closes, this character goes back to answering through its background helper.
-- /timed waits 2 seconds so the helper doesn't see the window still running and quit.
mail.handOff = function()
	if mail.handedOff then return end
	mail.handedOff = true
	mq.cmdf('/timed 20 /lua run %s/bg%s', meta.name, mail.runArgs or '')
end
mail.reply = function(msg, request, content)
	if request.via == 'mailbox' and request.from then mail.send(request.from, content) else msg:send(content) end
end
mail.received = function(content)
	if mail.requests[content.id] then mail.windowSeen = mq.gettime() end
	local who = content.from or content.Name
	if who then
		who = tostring(who)
		mail.heard[who] = mq.gettime()
		mail.pending[who] = nil
	end
	if content.via == 'mailbox' and content.from then mail.bcast[content.from] = true end
end
mail.tick = function()
	local now = mq.gettime()
	for name, request in pairs(mail.pending) do
		if now - request.at > 5000 then
			mail.pending[name] = nil
			mail.bcast[name] = true
			printf('\aglazbis\ax: \ay%s\ax did not answer directly, switching to the shared mailbox', name)
			mail.send(name, request.content)
		end
	end
end

local teamName		= ''
local showPopup		= false
local selectedTeam	= ''

-- Lockouts tab data. `lockout` matches a DZ timer's expedition name (its event name when index=3);
-- a leading '=' means an exact match, otherwise the timer only has to contain the text.
local lockouts = {
	order = {'Raid', 'TwoGroupRaid', 'Group', 'OldRaids'},
	labels = {Raid='Raids', TwoGroupRaid='2 Group', Group='1 Group', OldRaids='Old Raids', Custom='Custom'},
	ref = {
		Raid = {
			{name='Anguish', lockout='=Overlord Mata Muram', zone='Wall of Slaughter', index=3},
			{name='Crest', lockout='Threads_of_Chaos', zone='Qeynos Hills (BB)'},
			{name='DSK', lockout='=Dreadspire_HC', zone='Castle Mistmoore'},
			{name='Fippy', lockout='=Broken World', zone='HC Qeynos Hills (pond)'},
			{name='FUKU', lockout='The Fabled Undead Knight', zone='Unrest'},
			{name='Trak', lockout='Trakanon_Final', zone='HC Sebilis'},
			{name='Veksar', lockout='A Lake of Ill Omens', zone='Lake of Ill Omen'},
			{name='$$PAID$$ DSK', lockout='Dreadspire_HC [Time Keeper]', zone='Plane of Time'},
			{name='$$PAID$$ Fippy', lockout='Broken World [Time Keeper]', zone='Plane of Time'},
		},
		TwoGroupRaid = {
			{name='Crucible of the Brawler', lockout='Crucible of the Brawler', zone='Nightveil Sanctum'},
			{name='Crucible of the Occultist', lockout='Crucible of the Occultist', zone='Nightveil Sanctum'},
			{name='Crucible of the Physician', lockout='Crucible of the Physician', zone='Nightveil Sanctum'},
			{name='Crucible of the Warden', lockout='Crucible of the Warden', zone='Nightveil Sanctum'},
			{name='Manastone Source', lockout='Manastone Source', zone='HC Guk Bottom'},
			{name='The Crimson Curse', lockout='The Crimson Curse', zone='Chardok'},
			{name='VP Hardcore', lockout='VP Hardcore', zone='Nightveil Sanctum'},
		},
		Group = {
			{name='Ayonae', label='Ayonae Ro', lockout='Confront the Maestra', zone='Surefall Glade'},
			{name='Doll Maker', lockout='Doll Maker', zone='Kithicor Forest'},
			{name='Fenrir', lockout='Bloodfang', zone='West Karana'},
			{name='Finish Them Off', lockout='Finish them off', zone='Castle Mistmoore'},
			{name='Howling Stones', lockout='Echoes of Charasis', zone='The Overthere'},
			{name='Keepsakes', lockout='Keepsakes', zone='Surefall Glade'},
			{name='Lucian\'s Nightmare', lockout='Lucian\'s Nightmare', zone='Nightveil Sanctum'},
			{name='Selana', lockout='Moonshadow', zone='West Karana'},
			{name='Venril Sathir', lockout='Revenge on Venril Sathir', zone='Karnors Castle'},
		},
		OldRaids = {
			{name='Plane of Time', lockout='Quarm', zone='Plane of Time', index=3},
			{name='Riftseekers', lockout='Riftseeker', zone='Riftseeker'},
			{name='Tacvi', lockout='Tunat', zone='Txevu', index=3},
			{name='Txevu', lockout='Txevu', zone='Txevu'},
			{name='Trial of Adaptation', lockout='Proving Grounds: The Mastery of Adaptation', zone='MPG'},
			{name='Trial of Corruption', lockout='Proving Grounds: The Mastery of Corruption', zone='MPG'},
			{name='Trial of Endurance', lockout='Proving Grounds: The Mastery of Endurance', zone='MPG'},
			{name='Trial of Foresight', lockout='Proving Grounds: The Mastery of Foresight', zone='MPG'},
			{name='Trial of Hatred', lockout='Proving Grounds: The Mastery of Hatred', zone='MPG'},
			{name='Trial of Specialization', lockout='Proving Grounds: The Mastery of Specialization', zone='MPG'},
		},
	},
	-- DoN missions. Their replay timers are task timers, read from /tasktime; `ids` are task ids.
	don = {
		{id='raid', title='DoN Raid Events', note='Kindly + Tier 2 complete', timer='5d 12h', collapsed=false, rows={
			{name='Calling Emoush', ids={5580}},
			{name='Circle of Drakes', ids={5587}},
			{name='Fanning the Flames', ids={5500, 5501}},
			{name='Rampaging Monolith', ids={5586}},
			{name='Trial of Perseverance', ids={5053}},
			{name='Volkara\'s Bite', ids={5582}, aliases={'Volkara', 'Volkara [Raid Event]'}},
		}},
		{id='t1_missions', title='DoN Tier 1 Missions', note='Apprehensive', timer='4h', collapsed=true, rows={
			{name='Best Laid Plans', ids={4809, 74, 4811}},
			{name='Diseased Pumas', ids={5538, 75, 5540}},
			{name='Lair Unguarded', ids={4777, 5040}},
			{name='Lavaspinner\'s Locals', ids={5024, 76, 5027}},
			{name='Scrap Metal', ids={4883, 77}},
			{name='Signal Fires', ids={5074, 78, 5076}},
			{name='Sudden Tremors', ids={4929, 79, 4931}},
			{name='Tea for Thy Master', ids={4821, 80, 4823}},
		}},
		{id='t1_progression', title='DoN Tier 1 Progression', note='', timer='12h', collapsed=true, rows={
			{name='Children of Gimblax', ids={401}},
		}},
		{id='t2_missions', title='DoN Tier 2 Missions', note='Amiable + Tier 1 complete', timer='4h', collapsed=true, rows={
			{name='Animated Statue Plans', ids={5526, 82, 5528}},
			{name='Clues', ids={4865, 81}},
			{name='Forbin\'s Elixir', ids={5000, 89, 5003}},
			{name='Grounding the Drakes', ids={1119, 83, 1122}},
			{name='Infested', ids={1130, 84, 1133}},
			{name='Lavaspinner Hunting', ids={301, 85, 5512}},
			{name='Scales of Justice', ids={4815, 87, 4817}},
			{name='Splitting the Storm', ids={4801, 86, 4972}},
			{name='Storm Dragon Scales', ids={5532, 5533, 5536}},
			{name='The Drake Menace', ids={5016, 88, 5019}},
		}},
		{id='t2_progression', title='DoN Tier 2 Progression', note='', timer='12h', collapsed=true, rows={
			{name='Sickness of the Spirit', ids={4785}},
		}},
		{id='t3_missions', title='DoN Tier 3 Missions', note='Kindly + Tier 2 complete', timer='4h', collapsed=true, rows={
			{name='A Halfling\'s Greed', ids={5600, 90, 5603}},
			{name='Death Comes Swiftly', ids={4845, 91, 4847}},
			{name='Diving For Lavarocks', ids={5565, 5573}},
			{name='Dragon\'s Egg', ids={4889, 92}},
			{name='Flight of the Black Wing Drakes', ids={4980, 95, 4990}},
			{name='Holy Hour', ids={4774, 93}},
			{name='House of the Autumn Rose', ids={5068, 94, 5070}},
			{name='Lost Comrades', ids={4981, 96, 4992}},
			{name='Spider\'s Eye', ids={4895, 97}},
			{name='The Creator', ids={4795, 98, 4966}},
		}},
	},
	peers = {},					-- [character] = what that character last reported, resolved against the lists
	donState = {replays = {}, active = {}},	-- this character's own DoN replay timers and running missions
	form = {name = '', lockout = '', zone = '', duration = '', chars = {}, status = '', picker = {}},
	version = 0,				-- bumped whenever reported data or the custom list changes
}

local niceImg = mq.CreateTexture(mq.luaDir .. "/" .. meta.name .. "/bis.png")
local iconImg = mq.CreateTexture(mq.luaDir .. "/" .. meta.name .. "/icon_lazbis.png")

-- Default to e3bca if mq2mono is loaded, else use dannet
local broadcast			= '/e3bca'
local selectedBroadcast	= 1
local rebroadcast		= false
local isBackground		= false
local dumpInv			= false
local grouponly			= false
local argopts			= {['0']=function() isBackground=true end, debug=function() debug = true end, dumpinv=function() dumpInv = true end, group=function() grouponly = true broadcast = '/e3bcg' if not mq.TLO.Plugin('mq2mono')() then broadcast = '/dgge' end end}
local debug				= false
if not mq.TLO.Plugin('mq2mono')() then broadcast = '/dge' end

local function split(str, char)
	return string.gmatch(str, '[^' .. char .. ']+')
end

local function splitToTable(str, char)
	local t = {}
	for str in split(str, char) do
		table.insert(t, str)
	end
	return t
end

-- Stable numeric id derived from a string, used as ImGui table column user_id so that
-- Dear ImGui can identify a column (e.g. a specific toon) across frames/sessions
-- regardless of how many columns exist or what order they were declared in.
gearOrder.stableId = function(str)
	local hash = 5381
	for i = 1, #str do
		hash = bit32.band(hash * 33 + string.byte(str, i), 0xFFFFFFFF)
	end
	return hash
end

-- Extracts a width from either a plain number or an ImVec2-like {x=..,y=..} value,
-- since different ImGui size-returning calls may return either.
gearOrder.vecWidth = function(v)
	if type(v) == 'number' then return v end
	if type(v) == 'table' or type(v) == 'userdata' then
		local ok, x = pcall(function() return v.x end)
		if ok and type(x) == 'number' then return x end
	end
	return 0
end

-- Lockouts, adapted from TurboGear. Each character reports its raw DZ timers and DoN state;
-- the driver matches them against the instance lists, DoN missions and custom entries.
lockouts.trim = function(s)
	return (tostring(s or ''):gsub('^%s+', ''):gsub('%s+$', ''))
end

lockouts.parseSeconds = function(text)
	local lower = lockouts.trim(text):lower()
	if lower == '' then return nil end
	if lower:find('open', 1, true) or lower:find('expired', 1, true) then return 0 end
	local total, matched = 0, false
	for n, unit in lower:gmatch('(%d+)%s*([dhms])') do
		n = tonumber(n) or 0
		if unit == 'd' then total = total + n * 86400
		elseif unit == 'h' then total = total + n * 3600
		elseif unit == 'm' then total = total + n * 60
		else total = total + n end
		matched = true
	end
	if matched then return total end
	local a, b, c = lower:match('^(%d+):(%d+):(%d+)$')
	if a then return tonumber(a) * 3600 + tonumber(b) * 60 + tonumber(c) end
	a, b = lower:match('^(%d+):(%d+)$')
	if a then return tonumber(a) * 60 + tonumber(b) end
	return nil
end

lockouts.formatSeconds = function(seconds)
	local sec = math.max(0, math.floor(tonumber(seconds) or 0))
	local d = math.floor(sec / 86400) sec = sec % 86400
	local h = math.floor(sec / 3600) sec = sec % 3600
	local m = math.floor(sec / 60)
	if d > 0 then return string.format('%dD:%02dH:%02dM', d, h, m) end
	if h > 0 then return string.format('%dH:%02dM', h, m) end
	return string.format('%dM', m)
end

-- The DynamicZone TLO can be read with the Expedition window closed.
lockouts.readTimers = function()
	local rows, ok, now = {}, false, os.time()
	pcall(function()
		local dz = mq.TLO.DynamicZone
		local max = tonumber(dz.MaxTimers())
		if not max then return end
		ok = true
		for i = 1, math.min(max, 64) do
			pcall(function()
				local timer = dz.Timer(i)
				local expedition = lockouts.trim(timer.ExpeditionName() or '')
				local event = lockouts.trim(timer.EventName() or '')
				local seconds = tonumber(timer.Timer.TotalSeconds())
				if seconds and seconds > 0 and (expedition ~= '' or event ~= '') then
					rows[#rows + 1] = {expedition = expedition, event = event, expiresAt = now + math.floor(seconds)}
				end
			end)
		end
	end)
	return rows, ok
end

-- Fallback when the TLO can't be read: the Expedition window's list (1 = time left, 2 = expedition, 3 = event).
lockouts.readWindow = function()
	local rows, now = {}, os.time()
	pcall(function()
		local list = mq.TLO.Window('DynamicZoneWnd/DZ_TimerList')
		for i = 1, tonumber(list.Items()) or 0 do
			local seconds = lockouts.parseSeconds(list.List(i, 1)())
			local expedition = lockouts.trim(list.List(i, 2)() or '')
			local event = lockouts.trim(list.List(i, 3)() or '')
			if seconds and seconds > 0 and (expedition ~= '' or event ~= '') then
				rows[#rows + 1] = {expedition = expedition, event = event, expiresAt = now + seconds}
			end
		end
	end)
	return rows
end

lockouts.normalizeTitle = function(s)
	s = lockouts.trim(s):lower()
	s = s:gsub('^t[123]:%s*', '')
	s = s:gsub('%b[]', ' ')
	s = s:gsub("[`']", '')
	s = s:gsub('[^%w]+', ' ')
	return (s:gsub('^%s+', ''):gsub('%s+$', ''):gsub('%s+', ' '))
end

lockouts.donLookup = function(value)
	if not lockouts.donIndex then
		lockouts.donIndex = {}
		for _, section in ipairs(lockouts.don) do
			for _, row in ipairs(section.rows) do
				for _, id in ipairs(row.ids or {}) do lockouts.donIndex[tostring(id)] = row end
				lockouts.donIndex[lockouts.normalizeTitle(row.name)] = row
				for _, alias in ipairs(row.aliases or {}) do lockouts.donIndex[lockouts.normalizeTitle(alias)] = row end
			end
		end
	end
	value = lockouts.trim(value)
	if value == '' then return nil end
	return lockouts.donIndex[value] or lockouts.donIndex[lockouts.normalizeTitle(value)]
end

-- Chat lines: "'NAME' replay timer: 0d:3h:44m remaining." (from /tasktime) and
-- "You have received a replay timer for 'NAME': 0d:4h:0m remaining." (when a mission ends).
lockouts.ingestReplay = function(line)
	-- Greedy capture: names such as "Volkara's Bite" contain an apostrophe themselves.
	local raw, d, h, m = tostring(line or ''):match("'(.*)'.-(%d+)d:(%d+)h:(%d+)m remaining")
	if not raw then return nil end
	local row = lockouts.donLookup(raw)
	if not row then return nil end
	local expiresAt = os.time() + tonumber(d) * 86400 + tonumber(h) * 3600 + tonumber(m) * 60
	local replays = lockouts.donState.replays
	if not tonumber(replays[row.name]) or expiresAt > replays[row.name] then
		replays[row.name] = expiresAt
	end
	lockouts.dirty = true
	return row.name
end

lockouts.objectiveDone = function(status, current, required)
	status = tostring(status or ''):lower()
	if status == 'done' then return true end
	local a, b = status:match('^(%d+)%s*/%s*(%d+)$')
	if a and tonumber(b) > 0 then return tonumber(a) >= tonumber(b) end
	if current and required and required > 0 then return current >= required end
	return false
end

-- A finished mission stays in the journal with every objective Done, so only unfinished ones count.
lockouts.refreshActive = function()
	local state, now = lockouts.donState, os.time()
	local active, misses = {}, 0
	for i = 1, 64 do
		local readable, rec = pcall(function()
			local task = mq.TLO.Task(i)
			local title = task.Title()
			if not title or tostring(title) == '' then return nil end
			local found = {id = tonumber(task.ID()), title = tostring(title), seen = 0, unfinished = 0}
			pcall(function() found.seconds = tonumber(task.Timer.TotalSeconds()) end)
			local objMisses = 0
			for j = 1, 16 do
				local status, instruction, optional, current, required
				local objOk, obj = pcall(function() return task.Objective(j) end)
				if not objOk then found.seen = 0 break end
				pcall(function() status = obj.Status() end)
				pcall(function() instruction = obj.Instruction() end)
				pcall(function() optional = obj.Optional() end)
				pcall(function() current = tonumber(obj.CurrentCount()) end)
				pcall(function() required = tonumber(obj.RequiredCount()) end)
				if (status == nil or tostring(status) == '') and (instruction == nil or tostring(instruction) == '') and not current and not required then
					objMisses = objMisses + 1
					if objMisses >= 2 then break end
				else
					objMisses = 0
					found.seen = found.seen + 1
					if optional ~= true and not lockouts.objectiveDone(status, current, required) then
						found.unfinished = found.unfinished + 1
					end
				end
			end
			return found
		end)
		-- An unreadable journal is not an empty one: keep what we had.
		if not readable then return end
		if not rec then
			misses = misses + 1
			if misses >= 8 then break end
		else
			misses = 0
			local row = (rec.id and lockouts.donLookup(tostring(rec.id))) or lockouts.donLookup(rec.title)
			if row then
				if rec.seen == 0 then
					if type(state.active[row.name]) == 'table' then active[row.name] = state.active[row.name] end
				elseif rec.unfinished > 0 then
					active[row.name] = {id = rec.id, title = rec.title, expires_at = rec.seconds and (now + rec.seconds) or nil}
				end
			end
		end
	end
	state.active = active
	state.activeAt = now
	for name, expiresAt in pairs(state.replays) do
		if (tonumber(expiresAt) or 0) + 3600 < now then state.replays[name] = nil end
	end
end

lockouts.snapshot = function(groupId, fromTick)
	local rows, ok = lockouts.readTimers()
	local pending = nil
	if not ok then
		rows = lockouts.windowRows or {}
		if not fromTick then
			lockouts.wantWindowRead = true
			pending = true
		end
	end
	lockouts.refreshActive()
	local state = lockouts.donState
	local don = {capturedAt = state.capturedAt, activeAt = state.activeAt, replays = {}, active = {}}
	for name, expiresAt in pairs(state.replays) do don.replays[name] = expiresAt end
	for name, rec in pairs(state.active) do don.active[name] = {id = rec.id, title = rec.title, expires_at = rec.expires_at} end
	return {id = 'dzresult', Name = mq.TLO.Me.CleanName(), group = groupId, timers = rows, ok = ok, pending = pending, don = don}
end

-- content.tasktime: 'force' always runs /tasktime; 'auto' only if this character never has.
lockouts.onQuery = function(content, msg)
	lockouts.replyTo = content.from or lockouts.replyTo
	lockouts.replyGroup = content.group
	if content.tasktime == 'force' or (content.tasktime == 'auto' and not lockouts.donState.capturedAt) then
		lockouts.wantTasktime = true
	end
	mail.reply(msg, content, lockouts.snapshot(content.group))
end

-- Runs once a second in every character's main loop. Commands are only issued from here, never from a callback.
lockouts.tick = function()
	local now = mq.gettime()
	local push = false
	if lockouts.wantTasktime then
		lockouts.wantTasktime = false
		if not lockouts.settleAt and (not lockouts.lastTasktime or now - lockouts.lastTasktime >= 30000) then
			lockouts.lastTasktime = now
			lockouts.settleAt = now + 3000
			mq.cmd('/tasktime')
		end
	end
	-- /tasktime lists only locked missions, so capturedAt is stamped once its output has had time to arrive.
	if lockouts.settleAt and now >= lockouts.settleAt then
		lockouts.settleAt = nil
		lockouts.donState.capturedAt = os.time()
		push = true
	end
	if lockouts.wantWindowRead then
		lockouts.wantWindowRead = false
		if not lockouts.lastWindowRead or now - lockouts.lastWindowRead >= 60000 then
			lockouts.lastWindowRead = now
			pcall(function()
				mq.TLO.Window('DynamicZoneWnd').DoOpen()
				mq.delay(1)
				lockouts.windowRows = lockouts.readWindow()
				mq.TLO.Window('DynamicZoneWnd').DoClose()
			end)
		end
		push = true
	end
	if lockouts.dirty and not lockouts.settleAt then
		lockouts.dirty = false
		push = true
	end
	if push and lockouts.replyTo and actor then
		mail.send(lockouts.replyTo, lockouts.snapshot(lockouts.replyGroup, true))
	end
end

lockouts.serialize = function(value, indent)
	indent = indent or ''
	if type(value) == 'table' then
		local keys = {}
		for k in pairs(value) do keys[#keys + 1] = k end
		table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
		local parts = {}
		for _, k in ipairs(keys) do
			local key = type(k) == 'number' and ('[' .. k .. ']') or ('[' .. string.format('%q', tostring(k)) .. ']')
			parts[#parts + 1] = indent .. '\t' .. key .. ' = ' .. lockouts.serialize(value[k], indent .. '\t') .. ','
		end
		if #parts == 0 then return '{}' end
		return '{\n' .. table.concat(parts, '\n') .. '\n' .. indent .. '}'
	elseif type(value) == 'string' then
		return string.format('%q', value)
	end
	return tostring(value)
end

lockouts.cleanEntry = function(e)
	if type(e) ~= 'table' then return nil end
	local entry = {name = lockouts.trim(e.name), lockout = lockouts.trim(e.lockout), zone = lockouts.trim(e.zone), index = tonumber(e.index) or 2, custom = true}
	if type(e.characters) == 'table' then
		local chars = {}
		for _, c in ipairs(e.characters) do
			c = lockouts.trim(c)
			if c ~= '' then chars[#chars + 1] = c end
		end
		if #chars > 0 then entry.characters = chars end
	end
	if type(e.manualTimers) == 'table' then
		for charName, expiresAt in pairs(e.manualTimers) do
			if type(charName) == 'string' and charName ~= '' and tonumber(expiresAt) then
				entry.manualTimers = entry.manualTimers or {}
				entry.manualTimers[charName] = tonumber(expiresAt)
			end
		end
	end
	if entry.name == '' or (entry.lockout == '' and not entry.manualTimers) then return nil end
	return entry
end

lockouts.load = function()
	if lockouts.saved then return lockouts.saved end
	local saved = {entries = {}, hidden = {}, collapsed = {}, lockedOnly = false, showHidden = false}
	lockouts.file = lockouts.file or string.format('%s/lazbis_lockouts.lua', mq.configDir)
	local fh = io.open(lockouts.file, 'r')
	if fh then
		fh:close()
		local ok, data = pcall(dofile, lockouts.file)
		if ok and type(data) == 'table' then
			for _, e in ipairs(type(data.entries) == 'table' and data.entries or {}) do
				local entry = lockouts.cleanEntry(e)
				if entry then saved.entries[#saved.entries + 1] = entry end
			end
			for _, field in ipairs({'hidden', 'collapsed'}) do
				for key, value in pairs(type(data[field]) == 'table' and data[field] or {}) do
					if type(key) == 'string' and type(value) == 'boolean' then saved[field][key] = value end
				end
			end
			saved.lockedOnly = data.lockedOnly == true
			saved.showHidden = data.showHidden == true
		end
	end
	lockouts.saved = saved
	return saved
end

lockouts.save = function()
	local saved = lockouts.load()
	local ok, err = pcall(function()
		local fh = assert(io.open(lockouts.file, 'w'))
		fh:write('return ' .. lockouts.serialize(saved) .. '\n')
		fh:close()
	end)
	if not ok then printf('\arLazBis could not save %s: %s', tostring(lockouts.file), tostring(err)) end
	return ok
end

lockouts.addCustom = function(fields)
	local entry = {name = lockouts.trim(fields.name), lockout = lockouts.trim(fields.lockout), zone = lockouts.trim(fields.zone), index = fields.index, characters = fields.characters}
	if entry.name == '' then return false, 'Display name is required.' end
	local seconds = lockouts.parseSeconds(fields.duration or '')
	if fields.keepTimers and fields.duration == fields.keepDuration then
		entry.manualTimers = fields.keepTimers
	elseif seconds and seconds > 0 then
		local targets = (type(fields.characters) == 'table' and #fields.characters > 0) and fields.characters or {mq.TLO.Me.CleanName()}
		entry.manualTimers = {}
		for _, charName in ipairs(targets) do entry.manualTimers[charName] = os.time() + seconds end
	end
	entry = lockouts.cleanEntry(entry)
	if not entry then return false, 'Enter a DZ timer label, a duration, or both.' end
	local saved = lockouts.load()
	for _, existing in ipairs(saved.entries) do
		if existing.name == entry.name and existing.name ~= fields.replace then
			return false, string.format("'%s' already exists.", entry.name)
		end
	end
	local position = #saved.entries + 1
	for i, existing in ipairs(saved.entries) do
		if fields.replace and existing.name == fields.replace then
			table.remove(saved.entries, i)
			position = i
			break
		end
	end
	table.insert(saved.entries, position, entry)
	lockouts.save()
	lockouts.resolveAll()
	return true
end

lockouts.removeCustom = function(name)
	local saved = lockouts.load()
	for i, entry in ipairs(saved.entries) do
		if entry.name == name then
			table.remove(saved.entries, i)
			lockouts.save()
			lockouts.resolveAll()
			return entry
		end
	end
	return nil
end

lockouts.match = function(timers, key, column)
	key = lockouts.trim(key)
	local exact = key:sub(1, 1) == '='
	if exact then key = key:sub(2) end
	if key == '' then return nil end
	local lower, byEvent = key:lower(), tonumber(column) == 3
	local partial
	for _, row in ipairs(timers or {}) do
		local name = byEvent and row.event or row.expedition
		if type(name) == 'string' and name ~= '' then
			name = name:lower()
			if name == lower then return row end
			if not exact and not partial and name:find(lower, 1, true) then partial = row end
		end
	end
	return partial
end

lockouts.appliesTo = function(entry, charName)
	if type(entry.characters) ~= 'table' or #entry.characters == 0 then return true end
	local lower = tostring(charName or ''):lower()
	for _, c in ipairs(entry.characters) do
		if tostring(c):lower() == lower then return true end
	end
	return false
end

lockouts.resolve = function(name)
	local peer = lockouts.peers[name]
	if not peer then return end
	local locks = {Custom = {}, DoN = {}}
	for _, cat in ipairs(lockouts.order) do
		locks[cat] = {}
		for _, entry in ipairs(lockouts.ref[cat]) do
			local hit = lockouts.match(peer.timers, entry.lockout, entry.index)
			if hit then locks[cat][entry.name] = tonumber(hit.expiresAt) end
		end
	end
	for _, entry in ipairs(lockouts.load().entries) do
		local hit = entry.lockout ~= '' and lockouts.match(peer.timers, entry.lockout, entry.index)
		local expiresAt = hit and tonumber(hit.expiresAt) or nil
		if not expiresAt and entry.manualTimers then expiresAt = tonumber(entry.manualTimers[name]) end
		locks.Custom[entry.name] = expiresAt
	end
	-- DoN raid events may also show up as ordinary DZ timers.
	for _, row in ipairs(peer.timers) do
		local donRow = row.expedition ~= '' and lockouts.donLookup(row.expedition) or nil
		if donRow and (tonumber(row.expiresAt) or 0) > (locks.DoN[donRow.name] or 0) then
			locks.DoN[donRow.name] = tonumber(row.expiresAt)
		end
	end
	peer.locks = locks
	lockouts.version = lockouts.version + 1
end

lockouts.resolveAll = function()
	for name in pairs(lockouts.peers) do lockouts.resolve(name) end
	lockouts.version = lockouts.version + 1
end

lockouts.onResult = function(content)
	if type(content.Name) ~= 'string' then return end
	lockouts.peers[content.Name] = {
		timers = type(content.timers) == 'table' and content.timers or {},
		don = type(content.don) == 'table' and content.don or {},
		pending = content.pending == true,
	}
	lockouts.resolve(content.Name)
end

-- Returns 'nodata' | 'na' (custom entry not for this character) | 'locked', secondsLeft | 'open'
lockouts.cell = function(charName, cat, entry, now)
	if entry.custom and not lockouts.appliesTo(entry, charName) then return 'na' end
	local peer = lockouts.peers[charName]
	if not peer or not peer.locks or peer.pending then return 'nodata' end
	local expiresAt = peer.locks[cat] and peer.locks[cat][entry.name]
	if expiresAt and expiresAt > now then return 'locked', expiresAt - now end
	return 'open'
end

-- Returns 'nodata' | 'active', secondsLeft | 'locked', secondsLeft | 'unknown' (no /tasktime yet) | 'open'
lockouts.donCell = function(charName, row, now)
	local peer = lockouts.peers[charName]
	if not peer or not peer.locks then return 'nodata' end
	local state = peer.don
	local replayAt = math.max(tonumber(type(state.replays) == 'table' and state.replays[row.name]) or 0, peer.locks.DoN[row.name] or 0)
	local locked = replayAt > now
	local active = type(state.active) == 'table' and state.active[row.name]
	if type(active) == 'table' then
		-- A running mission is only believed for 15 minutes after the journal was last read.
		if now - (tonumber(state.activeAt or state.capturedAt) or 0) <= 900 then
			local expiresAt = tonumber(active.expires_at)
			return 'active', expiresAt and math.max(0, expiresAt - now) or nil
		end
		if not locked then return 'unknown' end
	end
	if locked then return 'locked', replayAt - now end
	if not tonumber(state.capturedAt) then return 'unknown' end
	return 'open'
end

lockouts.isTracked = function(row)
	local one = {row}
	for _, cat in ipairs(lockouts.order) do
		for _, entry in ipairs(lockouts.ref[cat]) do
			if lockouts.match(one, entry.lockout, entry.index) then return true end
		end
	end
	for _, entry in ipairs(lockouts.load().entries) do
		if entry.lockout ~= '' and lockouts.match(one, entry.lockout, entry.index) then return true end
	end
	return row.expedition ~= '' and lockouts.donLookup(row.expedition) ~= nil
end

lockouts.allTimers = function()
	local out, seen, now = {}, {}, os.time()
	local names = {}
	for name in pairs(lockouts.peers) do names[#names + 1] = name end
	table.sort(names)
	for _, name in ipairs(names) do
		for _, row in ipairs(lockouts.peers[name].timers) do
			local byEvent = row.expedition == ''
			local label = byEvent and row.event or row.expedition
			if label ~= '' and not seen[label] and (tonumber(row.expiresAt) or 0) > now then
				seen[label] = true
				out[#out + 1] = {label = label, index = byEvent and 3 or 2, row = row, owner = name, timer = lockouts.formatSeconds(row.expiresAt - now)}
			end
		end
	end
	table.sort(out, function(a, b) return a.label < b.label end)
	return out
end

lockouts.report = function(filter)
	local now = os.time()
	for _, cat in ipairs(lockouts.order) do
		if not filter or filter:lower() == cat:lower() then
			local output = ''
			for _, entry in ipairs(lockouts.ref[cat]) do
				output = output .. '\ay' .. entry.name .. '\ax \ar' .. cat .. '\ax (\ag' .. entry.zone .. '\ax): '
				for _, char in ipairs(group) do
					if char.Show and not char.Offline then
						local locked = lockouts.cell(char.Name, cat, entry, now) == 'locked'
						output = output .. (locked and '\ar' or '\ag') .. char.Name .. '\ax, '
					end
				end
				output = output .. '\n'
			end
			print(output)
		end
	end
end

-- Upgrade chains (bisConfig.Chains): owning a later item completes the earlier rows in the other lists.
local chains = {cache = {}}

chains.stageRow = function(stage, class)
	local listConfig = bisConfig[stage.list]
	if type(listConfig) ~= 'table' then return nil end
	local classItems, templateItems = listConfig[class] or {}, listConfig.Template or {}
	if stage.item then
		for _, bucket in ipairs({classItems, templateItems}) do
			for slot, item in pairs(bucket) do
				if type(item) == 'string' and item:match('^[^/|]+') == stage.item then return slot, item end
			end
		end
		return nil
	end
	local slot = (stage.slots and stage.slots[class]) or stage.slot
	local item = classItems[slot] or templateItems[slot]
	if type(item) ~= 'string' then return nil end
	return slot, item
end

-- Returns false, or {rows = {[slot] = {later = {{label=, name=, ids=}, ...} newest first, byName = name -> label}}}
chains.info = function(list, class)
	if not list or not class then return false end
	chains.cache[list] = chains.cache[list] or {}
	local info = chains.cache[list][class]
	if info ~= nil then return info end
	info = false
	for _, chain in ipairs(bisConfig.Chains or {}) do
		for rank, stage in ipairs(chain) do
			local slot = stage.list == list and chains.stageRow(stage, class)
			if slot then
				info = info or {rows = {}}
				local row = info.rows[slot] or {later = {}, byName = {}}
				info.rows[slot] = row
				for i = #chain, rank + 1, -1 do
					local laterStage = chain[i]
					local _, item = chains.stageRow(laterStage, class)
					item = item or laterStage.item
					if item then
						local entry = {label = laterStage.label, name = item:match('^[^/|]+'), ids = {}}
						for part in item:gmatch('[^/]+') do
							if tonumber(part) then entry.ids[#entry.ids + 1] = part end
						end
						row.later[#row.later + 1] = entry
						-- Rows completed from within their own list keep the plain "Found ..." tooltip.
						if laterStage.list ~= list then
							row.byName[entry.name] = row.byName[entry.name] or entry.label
						end
					end
				end
			end
		end
	end
	chains.cache[list][class] = info
	return info
end

chains.label = function(list, class, slot, actualName)
	local info = chains.info(list, class)
	local row = info and info.rows[slot]
	if row and actualName then return row.byName[actualName] end
	return nil
end

chains.findLater = function(row)
	for _, entry in ipairs(row.later) do
		local queries = {'=' .. entry.name}
		for _, id in ipairs(entry.ids) do queries[#queries + 1] = id end
		for _, query in ipairs(queries) do
			local found = mq.TLO.FindItem(query)
			local name = found()
			if name then return name, found.ItemSlot() end
			name = mq.TLO.FindItemBank(query)()
			if name then return name, 'Bank' end
		end
	end
	return nil
end

local function addCharacter(name, class, offline, show, msg)
	if not group[name] then
		if debug then printf('Add character: Name=%s Class=%s Offline=%s Show=%s, Msg=%s', name, class, offline, show, msg) end
		local char = {Name=name, Class=class, Offline=offline, Show=show, PingTime=mq.gettime()}
		group[name] = char
		table.insert(group, char)
		table.insert(sortedGroup, char.Name)
		table.sort(sortedGroup, function(a,b) return a < b end)
		if msg then
			selectionChanged = true
			mail.send(name, {id='hello',Name=mq.TLO.Me(),Class=mq.TLO.Me.Class.Name()})
		end
	elseif msg and group[name].Offline then
		if debug then printf('Add character: Name=%s Class=%s Offline=%s Show=%s, Msg=%s', name, class, offline, show, msg) end
		group[name].Offline = false
		group[name].PingTime=mq.gettime()
		if selectedBroadcast == 1 or (selectedBroadcast == 3 and mq.TLO.Group.Member(name)()) then
			group[name].Show = true
		end
	end
end

local function simpleExec(stmt)
	repeat
		local result = db:exec(stmt)
		if result ~= 0 then printf('Result: %s', result) end
		if result == sql.BUSY then print('\arDatebase was busy!') mq.delay(math.random(10,50)) end
	until result ~= sql.BUSY
end

local function initTables()
	local foundInventory = false
	local foundSettings = false
	local foundTradeskills = false
	local foundSpells = false
	local function versioncallback(udata,cols,values,names)
		for i=1,cols do
			if values[i] == 'Inventory' then
				foundInventory = true
			elseif values[i] == 'Settings' then
				foundSettings = true
			elseif values[i] == 'Tradeskills' then
				foundTradeskills = true
			elseif values[i] == 'Spells' then
				foundSpells = true
			end
		end
		return 0
	end
	repeat
		local result = db:exec([[SELECT name FROM sqlite_master WHERE type='table';]], versioncallback)
		if result == sql.BUSY then print('\arDatabase was busy!') mq.delay(math.random(10,50)) end
	until result ~= sql.BUSY

	if not foundInventory then
		simpleExec([[CREATE TABLE IF NOT EXISTS Inventory (Character TEXT NOT NULL, Class TEXT NOT NULL, Server TEXT NOT NULL, Slot TEXT NOT NULL, ItemName TEXT NOT NULL, Location TEXT NOT NULL, Count INTEGER NOT NULL, ComponentCount INTEGER NOT NULL, Category TEXT NOT NULL)]])
	end
	simpleExec([[DROP TABLE IF EXISTS Info]])
	if not foundSettings then
		simpleExec([[CREATE TABLE IF NOT EXISTS Settings (Key TEXT UNIQUE NOT NULL, Value TEXT NOT NULL)]])
	end
	if not foundTradeskills then
		simpleExec([[CREATE TABLE IF NOT EXISTS Tradeskills (Character TEXT NOT NULL, Class TEXT NOT NULL, Server TEXT NOT NULL, Tradeskill TEXT NOT NULL, Value INTEGER NOT NULL)]])
	end
	if not foundSpells then
		simpleExec([[CREATE TABLE IF NOT EXISTS Spells (Character TEXT NOT NULL, Class TEXT NOT NULL, Server TEXT NOT NULL, SpellName TEXT NOT NULL, Level INTEGER NOT NULL, Location TEXT NOT NULL)]])
	end
	-- check version and handle any migrations, none atm
	simpleExec(("INSERT INTO Settings VALUES ('Version', '%s') ON CONFLICT(Key) DO UPDATE SET Value = '%s'"):format(meta.version, meta.version))
end

local function settingsRowCallback(udata,cols,values,names)
	if values[1]:find('TEAM:') then
		-- printf('loaded team %s - %s', values[1], values[2])
		teams[values[1]] = {}
		for token in string.gmatch(values[2], "[^,]+") do
			-- print(token)
			table.insert(teams[values[1]], token)
		end
		return 0
	end
	if values[1] == 'GearColumnOrder' then
		gearOrder.order = {}
		for token in string.gmatch(values[2], "[^,]+") do
			table.insert(gearOrder.order, token)
		end
		return 0
	end
	local value = values[2]
	if value == 'true' then value = true
	elseif value == 'false' then value = false
	elseif tonumber(value) then value = tonumber(value) end
	settings[values[1]] = value
	return 0
end

local function initSettings()
	repeat
		local result = db:exec("SELECT * FROM Settings WHERE Key != 'Version'", settingsRowCallback)
		if result == sql.BUSY then print('\arDatabase was busy!') mq.delay(math.random(10,50)) end
	until result ~= sql.BUSY
end

local function initDB()
	db = sql.open(dbpath)
	if db then
		db:exec("PRAGMA journal_mode=WAL;")
		initTables()
		initSettings()
	end
end

local function exec(stmt, name, category, action)
	for i=1,10 do
		local wrappedStmt = ('BEGIN TRANSACTION;%s;COMMIT;'):format(stmt)
		if debug then printf('Exec: %s', wrappedStmt) end
		local result = db:exec(wrappedStmt)
		if result == sql.BUSY then
			print('\arDatabase was Busy!') mq.delay(math.random(100,1000))
		elseif result ~= sql.OK then
			printf('\ar%s failed for name: %s, category: %s, result: %s\n%s', action, name, category, result, wrappedStmt)
		elseif result == sql.OK then
			if debug then printf('Successfully %s for name: %s, category: %s', action, name, category) end
			break
		end
	end
end

local function clearAllDataForCharacter(name)
	local deleteStmt = ("DELETE FROM Inventory WHERE Character = '%s' AND Server = '%s'"):format(name, server)
	exec(deleteStmt, name, nil, 'deleted')
end

local function clearCategoryDataForCharacter(name, category)
	local deleteStmt = ("DELETE FROM Inventory WHERE Character = '%s' AND Server = '%s' AND Category = '%s'"):format(name, server, category)
	exec(deleteStmt, name, category, 'deleted')
end

local function clearTradeskillDataForCharacter(name)
local deleteStmt = ("DELETE FROM Tradeskills WHERE Character = '%s' AND Server = '%s'"):format(name, server)
	exec(deleteStmt, name, nil, 'deleted')
end

local function clearSpellDataForCharacter(name)
	local deleteStmt = ("DELETE FROM Spells WHERE Character = '%s' AND Server = '%s'"):format(name, server)
	exec(deleteStmt, name, nil, 'deleted')
end

local function resolveInvSlot(invslot)
	if invslot == 'Bank' then return ' (Bank)' end
	local numberinvslot = tonumber(invslot)
	if not numberinvslot then return '' end
	if numberinvslot >= 23 then
		return ' (in bag'..invslot - 22 ..')'
	else
		return ' ('..mq.TLO.InvSlot(invslot).Name()..')'
	end
end

local function buildInsertStmt(name, category)
	local stmt = "\n"
	local char = group[name]
	for slot,value in pairs(gear[name]) do
		local itemName = value.actualname
		local configSlot = slot ~= 'Wrist1' and slot ~= 'Wrist2' and slot or 'Wrists'
		if not itemName then
			itemName = itemList[char.Class] and (itemList[char.Class][configSlot] or itemList[char.Class][slot] or itemList.Template[configSlot] or itemList.Template[slot])
			if itemName and string.find(itemName, '/') then
				itemName = itemName:match("([^/]+)")
			end
		end
		if itemName then
			stmt = stmt .. dbfmt:format(name,char.Class,server,slot:gsub('\'','\'\''),itemName:gsub('\'','\'\''),resolveInvSlot(value.invslot):gsub('\'','\'\''),tonumber(value.count) or 0,tonumber(value.componentcount) or 0,category)
		end
	end
	return stmt
end

local function insertCharacterDataForCategory(name, category)
	local insertStmt = buildInsertStmt(name, category)
	exec(insertStmt, name, category, 'inserted')
end

local function rowCallback(udata,cols,values,names)
	if group[values[1]] and not group[values[1]].Offline then return 0 end
	addCharacter(values[1], values[2], true, false)
	gear[values[1]] = gear[values[1]] or {}
	gear[values[1]][values[4]] = {count=tonumber(values[7]), componentcount=tonumber(values[8]), actualname=values[6] and values[5], location=values[6]}
	return 0
end

local function loadInv(category)
	for _,char in ipairs(group) do
		if char.Offline then gear[char.Name] = {} end
	end
	repeat
		local result = db:exec(string.format("SELECT * FROM Inventory WHERE Category='%s' AND Server = '%s';", category, server), rowCallback)
		if result == sql.BUSY then print('\arDatabase was busy!') mq.delay(math.random(10,50)) end
	until result ~= sql.BUSY
	reapplyFilter = true
end

local function loadOfflineRaidTiers()
	local currentLevel = raidTiers.level[selectedItemList.id]
	if not currentLevel then return end
	for _, list in ipairs({'dsk', 'don'}) do
		if raidTiers.level[list] > currentLevel then
			repeat
			local result = db:exec(string.format("SELECT * FROM Inventory WHERE Category='%s' AND Server='%s';", list, server), function(_, _, values)
				local char = group[values[1]]
				if char and char.Offline then
					raidTiers.cache[char.Name] = raidTiers.cache[char.Name] or {}
					local bucket = raidTiers.cache[char.Name]
					bucket[list] = bucket[list] or {}
					bucket[list][values[4]] = {count=tonumber(values[7]) or 0, actualname=values[5], location=values[6]}
				end
				return 0
			end)
			if result == sql.BUSY then mq.delay(math.random(10,50)) end
		until result ~= sql.BUSY
		end
	end
end

local function tsRowCallback(udata,cols,values,names)
	if group[values[1]] and not group[values[1]].Offline then return 0 end
	addCharacter(values[1], values[2], true, false)
	tradeskills[values[1]] = tradeskills[values[1]] or {}
	tradeskills[values[1]][values[4]] = tonumber(values[5])
	return 0
end

local function loadTradeskillsFromDB()
	for _,char in ipairs(group) do
		if char.Offline then tradeskills[char.Name] = {} end
	end
	repeat
		local result = db:exec(string.format("SELECT * FROM Tradeskills WHERE Server = '%s';", server), tsRowCallback)
		if result == sql.BUSY then print('\arDatabase was busy!') mq.delay(math.random(10,50)) end
	until result ~= sql.BUSY
	reapplyFilter = true
end

local function spellRowCallback(udata,cols,values,names)
	if group[values[1]] and not group[values[1]].Offline then return 0 end
	addCharacter(values[1], values[2], true, false)
	groupSpellData[values[1]] = groupSpellData[values[1]] or {}
	table.insert(groupSpellData[values[1]], {values[5], values[4], values[6]})
	return 0
end

local function loadSpellsFromDB()
	for _,char in ipairs(group) do
		if char.Offline then groupSpellData[char.Name] = {} end
	end
	repeat
		local result = db:exec(string.format("SELECT * FROM Spells WHERE Server = '%s';", server), spellRowCallback)
		if result == sql.BUSY then print('\arDatabase was busy!') mq.delay(math.random(10,50)) end
	until result ~= sql.BUSY
	reapplyFilter = true
end

local foundItem = nil
local function singleRowCallback(udata,cols,values,names)
	foundItem = {Character=values[1], Count=tonumber(values[7]), ItemName=values[6] and values[5], ComponentCount=tonumber(values[8])}
end
local function loadSingleRow(category, charName, itemName)
	for _,char in ipairs(group) do
		if char.Offline then gear[char.Name] = {} end
	end
	repeat
		local result = db:exec(string.format("SELECT * FROM Inventory WHERE Category='%s' AND Server = '%s' AND Character = '%s' AND ItemName = '%s';", category, server, charName, itemName:gsub('\'','\'\'')), singleRowCallback)
		if result == sql.BUSY then print('\arDatabase was busy!') mq.delay(math.random(10,50)) end
	until result ~= sql.BUSY
end

local function doDumpInv(name, category)
	clearCategoryDataForCharacter(name, category)

	insertCharacterDataForCategory(name, category)
end

local function dumpTradeskills(name, skills)
	clearTradeskillDataForCharacter(name)
	-- name,class,server,skill,value
	local char = group[name]
	local stmt = "\n"
	for skill,value in pairs(skills) do
		stmt = stmt .. ("INSERT INTO Tradeskills VALUES ('%s','%s','%s','%s',%d);\n"):format(name, char.Class, server, skill, value)
	end
	exec(stmt, name, 'Tradeskills', 'inserted')
end

local function dumpSpells(name, spells)
	clearSpellDataForCharacter(name)
	if not spells then return end
	-- name,class,server,skill,value
	local char = group[name]
	local stmt = "\n"
	for _,missingSpell in ipairs(spells) do
		stmt = stmt .. ("INSERT INTO Spells VALUES ('%s','%s','%s','%s',%d,'%s');\n"):format(name, char.Class, server, missingSpell[2]:gsub('\'','\'\''), missingSpell[1], missingSpell[3] and missingSpell[3]:gsub('\'','\'\'') or '')
	end
	exec(stmt, name, 'Spells', 'inserted')
end

-- Augments fitted into worn gear are children of their host item. Reading the
-- augment's FindItem.ItemSlot alone may identify its socket, not the worn host.
local type12GearSlots = {'Charm','Left Ear','Head','Face','Right Ear','Neck','Shoulders','Arms','Back','Left Wrist','Right Wrist','Range','Hands','Primary','Secondary','Left Finger','Right Finger','Chest','Legs','Feet','Waist','Power Source','Ammo'}
local function wornAugmentNames()
    local names = {}
    for invslot = 0, 22 do
        pcall(function()
            local host = mq.TLO.Me.Inventory(invslot)
            if host and host() then
                for socketIndex = 1, 6 do
                    pcall(function()
                        local socket = host.AugSlot(socketIndex)
                        local aug = socket and socket.Item
                        if aug and aug() then
                            local name = aug.Name()
                            if name then
                                names[name] = {location=type12GearSlots[invslot + 1]}
                            end
                        end
                    end)
                end
            end
        end)
    end
    return names
end

local function type12ItemLocation(item, bank)
    local slot = tonumber(item.ItemSlot())
    local subslot = tonumber(item.ItemSlot2())
    if not slot then return bank and 'Bank' or 'Inventory' end
    local sub = subslot and subslot >= 0 and (' / slot ' .. (subslot + 1)) or ''
    if bank then
        if slot >= 2000 and slot <= 2023 then return 'Bank ' .. (slot - 1999) .. sub end
        if slot >= 2500 and slot <= 2505 then return 'Shared bank ' .. (slot - 2499) .. sub end
        return 'Bank'
    end
    if slot >= 0 and slot <= 22 then return type12GearSlots[slot + 1] end
    if slot >= 23 and slot <= 34 then return 'Bag ' .. (slot - 22) .. sub end
    if slot == 35 then return 'Cursor' end
    return 'Inventory'
end

-- Exact finished Cryptic Clutch names only: base foci and Vacant Vessels
-- do not satisfy the Type 12 ownership requirement.
local function searchType12Foci()
    local results = {}
    local wornAugs = wornAugmentNames()
    local classItems = bisConfig.type12[mq.TLO.Me.Class.Name()] or {}
    for slot, name in pairs(classItems) do
        local query = '=' .. name
        local carried = mq.TLO.FindItem(query)
        local banked = mq.TLO.FindItemBank(query)
        local status = 'missing'
        local location
        if wornAugs[name] then
            status = 'worn'
            location = wornAugs[name].location
        elseif carried and carried() then
            local invslot = tonumber(carried.ItemSlot())
            status = invslot and invslot >= 0 and invslot <= 22 and 'worn' or 'carried'
            location = type12ItemLocation(carried, false)
        elseif banked and banked() then
            status = 'carried'
            location = type12ItemLocation(banked, true)
        end
        results[slot] = {count=status == 'missing' and 0 or 1, status=status, location=location}
    end
    local function locate(name)
        if wornAugs[name] then return {status='worn', location=wornAugs[name].location} end
        local found = mq.TLO.FindItem('=' .. name)
        local banked = mq.TLO.FindItemBank('=' .. name)
        if found and found() then
            local invslot = tonumber(found.ItemSlot())
            return {status=invslot and invslot >= 0 and invslot <= 22 and 'worn' or 'carried', location=type12ItemLocation(found, false)}
        elseif banked and banked() then
            return {status='carried', location=type12ItemLocation(banked, true)}
        end
        return {status='missing'}
    end
    results.dskHex = {}
    for _, entry in ipairs(dskHexFocus.shared) do results.dskHex[entry.name] = locate(entry.name) end
    local classHex = dskHexFocus.byClass[mq.TLO.Me.Class.Name()]
    if classHex then results.dskHex[classHex.name] = locate(classHex.name) end
    results.don = {}
    for _, row in ipairs(type12Matrix.rows) do
        results.don[row.source] = locate('Cryptic Clutch of ' .. row.source)
    end
    return results
end

local function searchItemsInList(list)
	local classItems = bisConfig[list][mq.TLO.Me.Class.Name()]
	local templateItems = bisConfig[list].Template
	local results = {}
	for _,itembucket in ipairs({templateItems,classItems}) do
		for slot,item in pairs(itembucket) do
			local currentResult = 0
			local componentResult = 0
			local currentSlot = nil
			local actualName = nil
			if string.find(item, '/') then
				for itemName in split(item, '/') do
					local realName = itemName
					if string.find(itemName, '|') then
						local nameAndID = splitToTable(itemName, '|')
						realName = nameAndID[1]
						itemName = nameAndID[2]
					end
					if slot == 'Wrists' then
						local leftwrist = mq.TLO.Me.Inventory('leftwrist')
						local rightwrist = mq.TLO.Me.Inventory('rightwrist')
						if leftwrist.Name() == itemName or leftwrist.ID() == tonumber(itemName) then
							results['Wrist1'] = {count=1,invslot=9,actualname=leftwrist.Name()}
						elseif not results['Wrist1'] then
							results['Wrist1'] = {count=0,invslot='',actualname=nil}
						end
						if rightwrist.Name() == itemName or rightwrist.ID() == tonumber(itemName) then
							results['Wrist2'] = {count=1,invslot=10,actualname=rightwrist.Name()}
						elseif not results['Wrist2'] then
							results['Wrist2'] = {count=0,invslot='',actualname=nil}
						end
					else
						local searchString = itemName
						local findItem = mq.TLO.FindItem(searchString)
						local findItemBank = mq.TLO.FindItemBank(searchString)
						local count = mq.TLO.FindItemCount(searchString)() + mq.TLO.FindItemBankCount(searchString)()
						if slot == 'PSAugSprings' and itemName == '39071' and currentResult < 3 then
							currentResult = 0
						end
						if count > 0 and tonumber(itemName) and itemName ~= realName then
							actualName = realName
						end
						if count > 0 and not actualName then
							actualName = findItem() or findItemBank()
							currentSlot = findItem.ItemSlot() or (findItemBank() and 'Bank') or ''
						end
						currentResult = currentResult + count
					end
				end
			else
				local searchString = item
				currentResult = currentResult + mq.TLO.FindItemCount(searchString)() + mq.TLO.FindItemBankCount(searchString)()
				currentSlot = mq.TLO.FindItem(searchString).ItemSlot() or (mq.TLO.FindItemBank(searchString)() and 'Bank') or ''
			end
			if slot ~= 'Wrists' then
				if currentResult == 0 and bisConfig[list].Visible and bisConfig[list].Visible[slot] then
					local compItem = bisConfig[list].Visible[slot]
					componentResult = mq.TLO.FindItemCount(compItem)() + mq.TLO.FindItemBankCount(compItem)()
					currentSlot = mq.TLO.FindItem(compItem).ItemSlot() or (mq.TLO.FindItemBank(compItem)() and 'Bank') or ''
				end
				results[slot] = {count=currentResult, invslot=currentSlot, componentcount=componentResult>0 and componentResult or nil, actualname=actualName}
			else
				if bisConfig[list].Visible and bisConfig[list].Visible['Wrists'] then
					local compItem = bisConfig[list].Visible[slot]
					componentResult = mq.TLO.FindItemCount(compItem)() + mq.TLO.FindItemBankCount(compItem)()
					if results['Wrist1'].count == 0 and componentResult >= 1 then
						results['Wrist1'].count = 1 results['Wrist1'].componentcount = 1
						componentResult = componentResult - 1
					end
					if results['Wrist2'].count == 0 and componentResult >= 1 then
						results['Wrist2'].count = 1 results['Wrist2'].componentcount = 1
					end
				end
			end
		end
	end
	-- A later item in an upgrade chain completes this list's row (see bisConfig.Chains).
	local chainInfo = chains.info(list, mq.TLO.Me.Class.Name())
	if chainInfo then
		for slot, row in pairs(chainInfo.rows) do
			if results[slot] and (tonumber(results[slot].count) or 0) == 0 then
				local laterName, laterInvSlot = chains.findLater(row)
				if laterName then
					results[slot] = {count=1, invslot=laterInvSlot, actualname=laterName}
				end
			end
		end
	end
	return results
end

local function loadTradeskills()
	return {
		Blacksmithing = mq.TLO.Me.Skill('blacksmithing')(),
		Baking = mq.TLO.Me.Skill('baking')(),
		Brewing = mq.TLO.Me.Skill('brewing')(),
		Tailoring = mq.TLO.Me.Skill('tailoring')(),
		Pottery = mq.TLO.Me.Skill('pottery')(),
		['Jewelry Making'] = mq.TLO.Me.Skill('jewelry making')(),
		Fletching = mq.TLO.Me.Skill('fletching')(),
	}
end

local function loadSpellStatuses()
    local allSpells, missingSpells = {}, {}
    for _, level in ipairs({71,70,69,68,67,66}) do
        local levelSpells = spellConfig[mq.TLO.Me.Class()][level]
        for _, configured in ipairs(levelSpells) do
            local details = splitToTable(configured, '|')
            local name, source = details[1], details[2]
            local known = (mq.TLO.Me.Book(name)() or 0) ~= 0 or
                (mq.TLO.Me.CombatAbility(name)() or 0) ~= 0
            spellData[name] = known and 1 or 0
            allSpells[#allSpells + 1] = {level, name, source, known}
            if not known then
                missingSpells[#missingSpells + 1] = {level, name, source}
            end
        end
    end
    return allSpells, missingSpells
end

local function loadMissingSpells()
    local _, missingSpells = loadSpellStatuses()
    return missingSpells
end

-- Actor message handler
local function actorCallback(msg)
	local content = msg()
	if content.to and content.to:lower() ~= mail.me():lower() then return end
	mail.received(content)
	if debug then printf('<<< MSG RCVD: id=%s', content.id) end
	if content.id == 'hello' then
		if debug then printf('=== MSG: id=%s Name=%s Class=%s group=%s', content.id, content.Name, content.Class, content.group) end
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		if isBackground then return end
		addCharacter(content.Name, content.Class, false, true, msg)
	elseif content.id == 'search' then
		if debug then printf('=== MSG: id=%s list=%s', content.id, content.list) end
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		-- {id='search', list='dsk'}
		local results = content.list == 'type12' and searchType12Foci() or searchItemsInList(content.list)
		if debug then printf('>>> SEND MSG: id=%s Name=%s list=%s class=%s', content.id, mq.TLO.Me.CleanName(), content.list, mq.TLO.Me.Class.Name()) end
		mail.reply(msg, content, {id='result', Name=mq.TLO.Me.CleanName(), list=content.list, class=mq.TLO.Me.Class.Name(), results=results, group=content.group, tierOnly=content.tierOnly})
	elseif content.id == 'result' then
		if debug then printf('=== MSG: id=%s Name=%s list=%s class=%s', content.id, content.Name, content.list, content.class) end
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		if isBackground then return end
		-- {id='result', Name='name', list='dsk', class='Warrior', results={slot1=1, slot2=0}}
		local results = content.results
		if results == nil then return end
		if content.list == 'type12' then
			type12Gear[content.Name] = results
			return
		end
		if raidTiers.level[content.list] then
			raidTiers.cache[content.Name] = raidTiers.cache[content.Name] or {}
			raidTiers.cache[content.Name][content.list] = results
			reapplyFilter = true
		end
		if content.tierOnly or content.list ~= selectedItemList.id then return end
		local char = group[content.Name]
		gear[char.Name] = {}
		for slot,res in pairs(results) do
			if (bisConfig[content.list][content.class] and bisConfig[content.list][content.class][slot]) or bisConfig[content.list].Template[slot] then
				gear[char.Name][slot] = res
			elseif slot == 'Wrist1' or slot == 'Wrist2' then
				gear[char.Name][slot] = res
			end
		end
		if bisConfig[content.list].Visible ~= nil and bisConfig[content.list].Visible.Slots ~= nil then
			gear[char.Name].Visible = gear[char.Name].Visible or {}
			for slot in split(bisConfig[content.list].Visible.Slots, ',') do
				gear[char.Name].Visible[slot] = gear[char.Name][slot]
			end
		end
		reapplyFilter = true
		doDumpInv(char.Name, content.list)
	elseif content.id == 'tsquery' then
		if debug then printf('=== MSG: id=%s', content.id) end
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		local skills = loadTradeskills()
		if debug then printf('>>> SEND MSG: id=%s Name=%s Skills=%s', content.id, mq.TLO.Me.CleanName(), skills) end
		mail.reply(msg, content, {id='tsresult', Skills=skills, Name=mq.TLO.Me.CleanName(), group=content.group})
	elseif content.id == 'tsresult' then
		if debug then printf('=== MSG: id=%s Name=%s Skills=%s', content.id, content.Name, content.Skills) end
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		if isBackground then return end
		local char = group[content.Name]
		tradeskills[char.Name] = tradeskills[char.Name] or {}
		for name,skill in pairs(content.Skills) do
			tradeskills[char.Name][name] = skill
		end
		dumpTradeskills(char.Name, tradeskills[char.Name])
	elseif content.id == 'searchempties' then
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		local empties={}
		for i = 0, 21 do
			local slot = mq.TLO.InvSlot(i).Item
			if slot.ID() ~= nil then
				for j=1,6 do
					local augType = slot.AugSlot(j).Type()
					if augType and augType ~= 0 and augType ~= 20 and augType ~= 30 then
						local augSlot = slot.AugSlot(j).Item()
						if not augSlot then--and augType ~= 0 then
							-- empty aug slot
							table.insert(empties, ('%s: Slot %s, Type %s'):format(slots[i+1], j, augType))
						end
					end
				end
			else
				-- empty slot
				table.insert(empties, slots[i+1])
			end
		end
		if debug then printf('>>> SEND MSG: id=%s Name=%s empties=%s', content.id, mq.TLO.Me.CleanName(), empties) end
		mail.reply(msg, content, {id='emptiesresult', empties=empties, Name=mq.TLO.Me.CleanName(), group=content.group})
	elseif content.id == 'emptiesresult' then
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		if debug then printf('=== MSG: id=%s Name=%s empties=%s', content.id, content.Name, content.empties) end
		if isBackground then return end
		emptySlots[content.Name] = content.empties
		local message = 'Empties for ' .. content.Name .. ' - '
		if not content.empties then return end
		for _,empty in ipairs(content.empties) do
			message = message .. empty .. ', '
		end
	elseif content.id == 'searchspells' then
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		local allSpells, missingSpells = loadSpellStatuses()
		mail.reply(msg, content, {id='spellsresult', allSpells=allSpells, missingSpells=missingSpells, Name=mq.TLO.Me.CleanName(), group=content.group})
	elseif content.id == 'spellsresult' then
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		if content.Name == mq.TLO.Me.CleanName() then return end
		if isBackground then return end
		groupSpellData[content.Name] = content.allSpells or content.missingSpells
		dumpSpells(content.Name, content.missingSpells)
	elseif content.id == 'dzquery' then
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		lockouts.onQuery(content, msg)
	elseif content.id == 'dzresult' then
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		if isBackground then return end
		lockouts.onResult(content)
	elseif content.id == 'pingreq' then
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		mail.reply(msg, content, {id='pingresp', Name=mq.TLO.Me.CleanName(), time=mq.gettime(), group=content.group})
	elseif content.id == 'pingresp' then
		if content.group and content.group ~= mq.TLO.Group.Leader() then return end
		if content.Name == mq.TLO.Me.CleanName() then return end
		if not group[content.Name] then return end
		if isBackground then return end
		group[content.Name].Offline = false
		group[content.Name].PingTime = content.time
		if debug then printf('char pingtime updated %s %s', content.Name, content.time) end
	end
end

local function changeBroadcastMode(tempBroadcast)
	local origBroadcast = broadcast

	local bChanged = false
	if not grouponly then
		if not mq.TLO.Plugin('mq2mono')() then
			if tempBroadcast == 3 and broadcast ~= '/dgge' then
				broadcast = '/dgge'
				bChanged = true
			elseif broadcast ~= '/dge' then
				broadcast = '/dge'
				bChanged = true
			end
		else
			if tempBroadcast == 3 and broadcast ~= '/e3bcg' then
				broadcast = '/e3bcg'
				bChanged = true
			elseif broadcast ~= '/e3bca' then
				broadcast = '/e3bca'
				bChanged = true
			end
		end
	end
	if tempBroadcast == 1 or tempBroadcast == 3 then
		-- remove offline toons
		for _,char in ipairs(group) do
			if char.Offline or (tempBroadcast == 3 and not mq.TLO.Group.Member(char.Name)()) then
				char.Show = false
			elseif tempBroadcast == 1 or (tempBroadcast == 3 and mq.TLO.Group.Member(char.Name)()) then
				char.Show = true
			end
		end
		selectedTeam = ''
	elseif tempBroadcast == 2 then
		-- add offline toons
		for _,char in ipairs(group) do
			char.Show = true
		end
		selectedTeam = ''
	elseif tempBroadcast == 4 then
		selectedTeam = ''
	elseif type(tempBroadcast) ~= 'number' then
		for _,char in ipairs(group) do char.Show = false end
		for _,teamMember in ipairs(teams[tempBroadcast]) do
			for _,char in ipairs(group) do
				if teamMember == char.Name then char.Show = true end
			end
		end
	end
	if bChanged then
		rebroadcast = true
		mq.cmdf('%s /lua stop %s/bg', origBroadcast, meta.name)
	end
	selectedBroadcast = tempBroadcast
end

local function getItemColor(slot, count, visibleCount, componentCount)
	if componentCount and componentCount > 0 then
		return { 1, 1, 0 }
	end
	-- if slot == 'Wrists2' then
	--	 return { count == 2 and 0 or 1, count == 2 and 1 or 0, .1 }
	-- end
	return { count > 0 and 0 or 1, (count > 0 or visibleCount > 0) and 1 or 0, .1 }
end

local function higherRaidTier(char, slot, list)
	local currentLevel = raidTiers.level[list or selectedItemList.id]
	if not currentLevel or not raidTiers.gearSlots[slot] then return nil end
	local cached = raidTiers.cache[char.Name]
	if not cached then return nil end
	for _, list in ipairs({'don', 'dsk'}) do
		if raidTiers.level[list] > currentLevel then
			local configured = (bisConfig[list][char.Class] or {})[slot] or (bisConfig[list].Template or {})[slot]
			local found = cached[list] and cached[list][slot]
			if configured and found and (tonumber(found.count) or 0) > 0 then
				return list, found, configured:match('^[^/]+')
			end
		end
	end
end

local function raidTierCheckPending(char, slot)
	local currentLevel = raidTiers.level[selectedItemList.id]
	if not currentLevel or not raidTiers.gearSlots[slot] or char.Offline then return false end
	local cached = raidTiers.cache[char.Name] or {}
	for _, list in ipairs({'don', 'dsk'}) do
		if raidTiers.level[list] > currentLevel and not cached[list] then return true end
	end
	return false
end

local function slotRow(slot, tmpGear)
	-- local realSlot = slot ~= 'Wrists2' and slot or 'Wrists'
	local realSlot = slot
	ImGui.TableNextRow()
	ImGui.TableNextColumn()
	ImGui.Text('' .. slot)
	for _, char in ipairs(gearOrder.current) do
		if char.Show then
			ImGui.TableNextColumn()
			if (tmpGear[char.Name] ~= nil and tmpGear[char.Name][realSlot] ~= nil) then
				local configSlot = slot
				if configSlot == 'Wrist1' or configSlot == 'Wrist2' then
					if itemList[char.Class] and itemList[char.Class]['Wrists'] then configSlot = 'Wrists' end
				end
				local itemName = itemList[char.Class] and itemList[char.Class][configSlot] or itemList.Template[configSlot]
				if (itemName ~= nil) then
					if string.find(itemName, '/') then
						itemName = itemName:match("([^/]+)")
					end
					if string.find(itemName, '|') then
						itemName = itemName:match("([^|]+)")
					end
					local actualName = tmpGear[char.Name][realSlot].actualname
					if not actualName or string.find(actualName, '/') then
						actualName = itemName
					end
					local count, invslot = tmpGear[char.Name][realSlot].count, tmpGear[char.Name][realSlot].invslot
					local countVis = tmpGear[char.Name].Visible and tmpGear[char.Name].Visible[configSlot] and tmpGear[char.Name].Visible[configSlot].count or 0
					local componentcount = tmpGear[char.Name][realSlot].componentcount
					local upgradedList, upgradedItem, upgradedName
					if (tonumber(count) or 0) == 0 then
						upgradedList, upgradedItem, upgradedName = higherRaidTier(char, realSlot)
					end
					local color = upgradedList and {0, 1, 0.1} or getItemColor(slot, tonumber(count), tonumber(countVis), tonumber(componentcount))
					ImGui.PushStyleColor(ImGuiCol.Text, color[1], color[2], color[3], 1)
					if upgradedList then
						local label = upgradedList == 'don' and 'Tier 3' or 'Tier 2'
						local cut = gearOrder.cellText(string.format('%s [%s Complete]', itemName, label))
						ImGui.PopStyleColor()
						if ImGui.IsItemHovered() then
							ImGui.BeginTooltip()
							if cut then ImGui.Text('%s', itemName) end
							ImGui.Text('%s completed by %s:', selectedItemList.name, label)
							ImGui.Text('%s', upgradedItem.actualname or upgradedName)
							if upgradedItem.location then ImGui.Text('Location: %s', upgradedItem.location) end
							ImGui.EndTooltip()
						end
					elseif (tonumber(count) or 0) == 0 and raidTierCheckPending(char, realSlot) then
						ImGui.PopStyleColor()
						if gearOrder.cellText(string.format('%s [Checking tiers]', itemName), true) and ImGui.IsItemHovered() then
							ImGui.SetTooltip('%s', itemName)
						end
					elseif (tonumber(count) or 0) > 0 and actualName ~= itemName and chains.label(selectedItemList.id, char.Class, realSlot, actualName) then
						local chainLabel = chains.label(selectedItemList.id, char.Class, realSlot, actualName)
						local resolvedInvSlot = tmpGear[char.Name][realSlot].location or resolveInvSlot(invslot)
						local cut = gearOrder.cellText(string.format('%s [%s Complete]', itemName, chainLabel))
						ImGui.PopStyleColor()
						if ImGui.IsItemHovered() then
							ImGui.BeginTooltip()
							if cut then ImGui.Text('%s', itemName) end
							ImGui.Text('Completed by %s:', chainLabel)
							ImGui.TextColored(0,1,0,1,'%s%s', actualName, resolvedInvSlot)
							ImGui.EndTooltip()
						end
					elseif itemName == actualName then
						local resolvedInvSlot = tmpGear[char.Name][realSlot].location or resolveInvSlot(invslot)
						local lootDropper = color[2] == 0 and bisConfig.LootDroppers[actualName]
						local cellText = string.format('%s%s%s', itemName, settings.ShowSlots and resolvedInvSlot or '', lootDropper and ' ('..lootDropper..')' or '')
						local cut = gearOrder.cellText(cellText)
						ImGui.PopStyleColor()
						if ImGui.IsItemHovered() then
							if cut then ImGui.SetTooltip('%s', cellText) end
							if ImGui.IsMouseClicked(ImGuiMouseButton.Left) then mq.cmdf('/link %s', itemName) end
						end
					else
						local lootDropper = color[2] == 0 and bisConfig.LootDroppers[actualName]
						local resolvedInvSlot = tmpGear[char.Name][realSlot].location or resolveInvSlot(invslot)
						--ImGui.Text('%s%s', itemName, lootDropper and ' ('..lootDropper..')' or '')
						local cut = gearOrder.cellText(string.format('%s%s%s', itemName, settings.ShowSlots and resolvedInvSlot or '', lootDropper and ' ('..lootDropper..')' or ''))
						ImGui.PopStyleColor()
						if ImGui.IsItemHovered() then
							--local resolvedInvSlot = tmpGear[char.Name][realSlot].location or resolveInvSlot(invslot)
							ImGui.BeginTooltip()
							if cut then ImGui.Text('%s', itemName) end
							ImGui.Text('Found ') ImGui.SameLine() ImGui.TextColored(0,1,0,1,'%s', actualName) ImGui.SameLine() ImGui.Text('in slot %s', resolvedInvSlot)
							ImGui.EndTooltip()
						end
						if ImGui.IsItemHovered() and ImGui.IsMouseClicked(ImGuiMouseButton.Left) then
							mq.cmdf('/squelch /link %s', itemName)
						end
					end
				end
			end
		end
	end
end

local filter = ''
local filteredGear = {}
local filteredSlots = {}
local useFilter = false
local function filterGear(slots)
	filteredGear = {}
	filteredSlots = {}
	local lowerFilter = filter:lower()
	if slots then
		for _,category in ipairs(slots) do
			local catSlots = category.Slots
			for _,slot in ipairs(catSlots) do
				for _, char in ipairs(group) do
					if (gear[char.Name] ~= nil and gear[char.Name][slot] ~= nil) then
						local itemName = itemList[char.Class] and itemList[char.Class][slot] or itemList.Template[slot]
						local inherited = higherRaidTier(char, slot)
						if (itemName ~= nil) and itemName:lower():find(lowerFilter) and
							(not settings.ShowMissingOnly or (gear[char.Name][slot].count == 0 and not inherited)) then
							filteredGear[char.Name] = filteredGear[char.Name] or {Name=char.Name, Class=char.Class}
							filteredGear[char.Name][slot] = gear[char.Name][slot]
							if not filteredSlots[category.Name] then
								table.insert(filteredSlots, {Name=category.Name, Slots={slot}})
								filteredSlots[category.Name] = category.Name
							else
								for _,cat in ipairs(filteredSlots) do
									if cat.Name == category.Name then
										local addSlot = true
										for _,s in ipairs(cat.Slots) do
											if s == slot then
												addSlot = false
												break
											end
										end
										if addSlot then table.insert(cat.Slots, slot) end
										break
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local ingredientFilter = ''
local filteredIngredients = {}
local useIngredientFilter = false
local function filterIngredients()
	filteredIngredients = {}
	for _,ingredient in pairs(ingredientsArray) do
		if ingredient.Name:lower():find(ingredientFilter:lower()) then
			table.insert(filteredIngredients, ingredient)
		end
	end
end

local function DrawTextLink(label, url)
	ImGui.PushStyleColor(ImGuiCol.Text, ImGui.GetStyleColor(ImGuiCol.ButtonHovered))
	ImGui.Text(label)
	ImGui.PopStyleColor()

	if ImGui.IsItemHovered() then
		if ImGui.IsMouseClicked(ImGuiMouseButton.Left) then
			os.execute(('start "" "%s"'):format(url))
		end
		ImGui.BeginTooltip()
		ImGui.Text('%s', url)
		ImGui.EndTooltip()
	end
end

local ColumnID_Name = 1
local ColumnID_Location = 2
local current_sort_specs = nil
local function CompareWithSortSpecs(a, b)
	for n = 1, current_sort_specs.SpecsCount, 1 do
		local sort_spec = current_sort_specs:Specs(n)
		local delta = 0

		local sortA = a
		local sortB = b
		if sort_spec.ColumnUserID == ColumnID_Name then
			sortA = a.Name
			sortB = b.Name
		elseif sort_spec.ColumnUserID == ColumnID_Location then
			sortA = a.Location
			sortB = b.Location
		end
		if sortA < sortB then
			delta = -1
		elseif sortB < sortA then
			delta = 1
		else
			delta = 0
		end

		if delta ~= 0 then
			if sort_spec.SortDirection == ImGuiSortDirection.Ascending then
				return delta < 0
			end
			return delta > 0
		end
	end

	-- Always return a way to differentiate items.
	return a.Name < b.Name
end

local function updateSetting(name, value)
	settings[name] = value
	simpleExec(("INSERT INTO Settings VALUES ('%s', '%s') ON CONFLICT(Key) DO UPDATE SET Value = '%s'"):format(name, value, value))
end

gearOrder.save = function()
	local nameList = table.concat(gearOrder.order, ',')
	simpleExec(("INSERT INTO Settings VALUES ('GearColumnOrder', '%s') ON CONFLICT(Key) DO UPDATE SET Value = '%s'"):format(nameList, nameList))
end

-- Returns the toons currently in `group` arranged per the user's saved order.
-- Any toon not yet present in the saved order is appended (and the saved
-- order is updated/persisted) so newly-seen alts get a stable slot too.
gearOrder.get = function()
	local ordered = {}
	local seen = {}
	local orderChanged = false
	for _,name in ipairs(gearOrder.order) do
		local char = group[name]
		if char then
			table.insert(ordered, char)
			seen[name] = true
		end
	end
	for _,char in ipairs(group) do
		if not seen[char.Name] then
			table.insert(ordered, char)
			table.insert(gearOrder.order, char.Name)
			seen[char.Name] = true
			orderChanged = true
		end
	end
	if orderChanged then gearOrder.save() end
	return ordered
end

gearOrder.move = function(name, direction)
	local idx
	for i,n in ipairs(gearOrder.order) do
		if n == name then idx = i break end
	end
	if not idx then return end
	local swapIdx = idx + direction
	if swapIdx < 1 or swapIdx > #gearOrder.order then return end
	gearOrder.order[idx], gearOrder.order[swapIdx] = gearOrder.order[swapIdx], gearOrder.order[idx]
	gearOrder.save()
end

gearOrder.moveTo = function(name, targetName)
	local from, to
	for i,n in ipairs(gearOrder.order) do
		if n == name then from = i end
		if n == targetName then to = i end
	end
	if not from or not to then return false end
	if from ~= to then
		table.insert(gearOrder.order, to, table.remove(gearOrder.order, from))
		gearOrder.save()
	end
	return true
end

gearOrder.textWidth = function(text)
	local width = ImGui.CalcTextSize(text)
	return gearOrder.vecWidth(width)
end

-- The cut text is cached per cell width; measuring every cell on every frame would be slow.
gearOrder.fit = {cache = {}, widths = 0, entries = 0}
gearOrder.cellText = function(text, disabled)
	local fit = gearOrder.fit
	local width = math.floor(gearOrder.vecWidth(ImGui.GetContentRegionAvail()))
	local cache = fit.cache[width]
	if not cache then
		if fit.widths >= 16 or fit.entries >= 5000 then fit.cache, fit.widths, fit.entries = {}, 0, 0 end
		cache = {}
		fit.cache[width] = cache
		fit.widths = fit.widths + 1
	end
	local shown = cache[text]
	if shown == nil then
		shown = text
		if width > 0 and gearOrder.textWidth(text) > width then
			local room = width - gearOrder.textWidth('...')
			local low, high, best = 1, #text, 0
			while low <= high do
				local mid = math.floor((low + high) / 2)
				if gearOrder.textWidth(text:sub(1, mid)) <= room then
					best = mid
					low = mid + 1
				else
					high = mid - 1
				end
			end
			shown = text:sub(1, best):gsub('%s+$', '') .. '...'
		end
		cache[text] = shown
		fit.entries = fit.entries + 1
	end
	if disabled then ImGui.TextDisabled('%s', shown) else ImGui.Text('%s', shown) end
	return shown ~= text
end

-- Toon columns share the window width; under 150px each the table scrolls sideways instead.
gearOrder.beginTable = function(numColumns)
	local flags = bit32.bor(ImGuiTableFlags.BordersInner, ImGuiTableFlags.RowBg, ImGuiTableFlags.ScrollY)
	local needed = 190 + (numColumns - 1) * 150
	if needed > gearOrder.vecWidth(ImGui.GetContentRegionAvail()) then
		return ImGui.BeginTable('gear', numColumns, bit32.bor(flags, ImGuiTableFlags.ScrollX), 0, 0, needed)
	end
	return ImGui.BeginTable('gear', numColumns, flags)
end

gearOrder.dragSource = function(name, hint)
	if ImGui.BeginDragDropSource(ImGuiDragDropFlags.SourceAllowNullID) then
		gearOrder.dragName = name
		ImGui.SetDragDropPayload('LAZBIS_TOON', name)
		ImGui.Text('Move ' .. name)
		ImGui.EndDragDropSource()
	elseif hint and ImGui.IsItemHovered() and not ImGui.IsMouseDown(ImGuiMouseButton.Left) then
		ImGui.SetTooltip('Drag onto another character to reorder')
	end
end

gearOrder.dropTarget = function(name)
	if ImGui.BeginDragDropTarget() then
		local payload = ImGui.AcceptDragDropPayload('LAZBIS_TOON')
		if payload ~= nil then
			if not gearOrder.moveTo(payload.Data, name) then
				gearOrder.moveTo(gearOrder.dragName, name)
			end
			gearOrder.dragName = nil
		end
		ImGui.EndDragDropTarget()
	end
end

local function getAnnounceChannel()
	if settings.AnnounceChannel == 'Raid' then
		if mq.TLO.Raid.Members() > 0 then return '/rs ' else return '/g ' end
	elseif settings.AnnounceChannel == 'Group' then
		return '/g '
	elseif settings.AnnounceChannel == 'Guild' then
		return '/gu '
	elseif settings.AnnounceChannel == 'Say' then
		return '/say '
	end
end

local function VerticalSeparator()
	ImGui.PushStyleColor(ImGuiCol.Button, 0.20, 0.23, 0.29, 1)
	ImGui.PushStyleColor(ImGuiCol.ButtonActive, 0.18, 0.32, 0.56, 1)
	ImGui.PushStyleColor(ImGuiCol.ButtonHovered, 0.26, 0.38, 0.54, 1)
	ImGui.Button('##separator', 3, 0)
	ImGui.PopStyleColor(3)
end

local function LockButton(id, isLocked)
	local lockedIcon = settings.Locked and icons.FA_LOCK .. '##' .. id or icons.FA_UNLOCK .. '##' .. id
	if ImGui.Button(lockedIcon) then
		isLocked = not isLocked
	end
	return isLocked
end

local function drawCharacterMenus()
	ImGui.PushItemWidth(150)
	if ImGui.BeginCombo('##Characters', 'Characters', ImGuiComboFlags.HeightLarge) then
		for teamName,_ in pairs(teams) do
			local _,pressed = ImGui.Checkbox(teamName:gsub('TEAM:', 'Team: '), selectedTeam == teamName)
			if pressed then if selectedTeam ~= teamName then selectedTeam = teamName changeBroadcastMode(teamName) else selectedTeam = '' end end
		end
		local _,pressed = ImGui.Checkbox('All Online', selectedBroadcast == 1)
		if pressed then changeBroadcastMode(1) end
		_,pressed = ImGui.Checkbox('All Offline', selectedBroadcast == 2)
		if pressed then changeBroadcastMode(2) end
		_,pressed = ImGui.Checkbox('Group', selectedBroadcast == 3)
		if pressed then changeBroadcastMode(3) end
		for i,name in ipairs(sortedGroup) do
			local char = group[name]
			_,pressed = ImGui.Checkbox(char.Name, char.Show or false)
			if pressed then
				char.Show = not char.Show
				changeBroadcastMode(4)
			end
		end
		ImGui.EndCombo()
	end
	ImGui.PopItemWidth()
	ImGui.SameLine()
	if ImGui.Button('Save Character Set') then
		showPopup = true
		ImGui.OpenPopup('Save Team')
		ImGui.SetNextWindowSize(200, 90)
	end
	ImGui.SameLine()
	if ImGui.Button('Delete Character Set') then
		if selectedTeam ~= '' then
			simpleExec(("DELETE FROM Settings WHERE Key = '%s'"):format(selectedTeam))
			teams[selectedTeam] = nil
			selectedTeam = ''
		end
	end
	ImGui.SameLine()
	if ImGui.Button('Delete Selected Characters') then
		showPopup = true
		ImGui.OpenPopup('Delete Characters')
		ImGui.SetNextWindowSize(200, 90)
	end
	if ImGui.BeginPopupModal('Delete Characters') then
		if ImGui.Button('Proceed') then
			for _,char in ipairs(group) do
				if char.Show then
					simpleExec(("DELETE FROM Inventory WHERE Character = '%s' AND Server = '%s'"):format(char.Name, server))
				end
			end
			for i=#sortedGroup,1,-1 do
				if group[sortedGroup[i]].Show then table.remove(sortedGroup, i) end
			end
			for i=#group,1,-1 do
				local charName = group[i].Name
				if group[i].Show then table.remove(group, i) group[charName] = nil end
			end
			showPopup = false
			ImGui.CloseCurrentPopup()
		end
		ImGui.SameLine()
		if ImGui.Button('Cancel') then
			showPopup = false
			ImGui.CloseCurrentPopup()
		end
		ImGui.EndPopup()
	end
	if ImGui.BeginPopupModal('Save Team', showPopup) then
		teamName,_ = ImGui.InputText('Name', teamName)
		if ImGui.Button('Save') and teamName ~= '' then
			local nameList = ''
			local newTeam = {}
			for i,char in ipairs(group) do
				if char.Show then
					table.insert(newTeam, char.Name)
					nameList = nameList .. char.Name .. ','
				end
			end
			simpleExec(("INSERT INTO Settings VALUES ('TEAM:%s', '%s') ON CONFLICT(Key) DO UPDATE SET Value = '%s'"):format(teamName, nameList, nameList))
			teams['TEAM:'..teamName] = newTeam
			showPopup = false
			ImGui.CloseCurrentPopup()
			teamName = ''
		end
		ImGui.SameLine()
		if ImGui.Button('Cancel') then
			showPopup = false
			ImGui.CloseCurrentPopup()
			teamName = ''
		end
		ImGui.EndPopup()
	end
end

local WINDOW_FLAGS = ImGuiWindowFlags.HorizontalScrollbar
local classes = {Bard='BRD',Beastlord='BST',Berserker='BER',Cleric='CLR',Druid='DRU',Enchanter='ENC',Magician='MAG',Monk='MNK',Necromancer='NEC',Paladin='PAL',Ranger='RNG',Rogue='ROG',['Shadow Knight']='SHD',Shaman='SHM',Warrior='WAR',Wizard='WIZ'}
local crypticFocusNotes = {}
for _, entry in ipairs(donFocusReference) do
    for _, name in ipairs(entry.names or {}) do
        if name:match('^Cryptic Clutch of ') then crypticFocusNotes[name] = entry.notes end
    end
end
type12Matrix.cell = function(char, row)
	local scan = type12Gear[char.Name]
	if not scan then return {text = '...', tip = 'Waiting for ' .. char.Name .. "'s scan."} end
	local function found(name, hit)
		if hit.location then return string.format("Found '%s' in slot (%s)", name, hit.location) end
		return string.format("Found '%s'", name)
	end
	local crypticName = 'Cryptic Clutch of ' .. row.source
	local don = scan.don and scan.don[row.source]
	if not scan.don then
		-- Older lazbis versions only report the class's own foci.
		for slot, name in pairs(bisConfig.type12[char.Class] or {}) do
			if name == crypticName then don = scan[slot] end
		end
	end
	if don and don.status ~= 'missing' then return {text = 'DoN', tip = found(crypticName, don)} end
	local hexName = 'Hideous Hex of ' .. row.source
	local hex = scan.dskHex and scan.dskHex[hexName]
	if type(hex) == 'string' then hex = {status = hex} end
	if hex and hex.status ~= 'missing' then return {text = 'DSK', tip = found(hexName, hex)} end
	return {text = '-', tip = char.Name .. ' is missing this Type 12 aug.'}
end

type12Matrix.draw = function()
	local colors = type12Matrix.colors
	local chars = {}
	for _, char in ipairs(gearOrder.get()) do
		if char.Show then chars[#chars + 1] = char end
	end
	if #chars == 0 then
		lockouts.text(colors['-'], 'No characters shown.')
		return
	end
	local rows = {}
	for _, spec in ipairs(type12Matrix.rows) do
		local cells, allDon = {}, true
		for i, char in ipairs(chars) do
			cells[i] = type12Matrix.cell(char, spec)
			if cells[i].text ~= 'DoN' then allDon = false end
		end
		if not (settings.ShowMissingOnly and allDon) then rows[#rows + 1] = {spec = spec, cells = cells} end
	end
	if #rows == 0 then
		lockouts.text(colors.DoN, 'Every shown character has every DoN Type 12 aug.')
		return
	end
	local height = (#rows + 1) * (ImGui.GetTextLineHeightWithSpacing() + 2) + 8
	local flags = bit32.bor(ImGuiTableFlags.BordersInner, ImGuiTableFlags.RowBg, ImGuiTableFlags.ScrollX, ImGuiTableFlags.ScrollY)
	if ImGui.BeginTable('type12matrix', #chars + 1, flags, 0, height) then
		ImGui.TableSetupScrollFreeze(1, 1)
		ImGui.TableSetupColumn('Effect', ImGuiTableColumnFlags.WidthFixed, 210, gearOrder.stableId('Effect'))
		for _, char in ipairs(chars) do
			ImGui.TableSetupColumn(char.Name, ImGuiTableColumnFlags.WidthFixed, 86, gearOrder.stableId(char.Name))
		end
		ImGui.TableNextRow()
		ImGui.TableSetColumnIndex(0)
		lockouts.text(lockouts.ui.header, 'Effect')
		ImGui.PushStyleVar(ImGuiStyleVar.SelectableTextAlign, 0.5, 0.5)
		for i, char in ipairs(chars) do
			ImGui.TableSetColumnIndex(i)
			local color = lockouts.classColor(char.Class)
			ImGui.PushStyleColor(ImGuiCol.Text, color[1], color[2], color[3], color[4])
			ImGui.Selectable(char.Name .. '##type12hdr', false)
			ImGui.PopStyleColor()
			gearOrder.dragSource(char.Name, true)
			gearOrder.dropTarget(char.Name)
		end
		ImGui.PopStyleVar()
		for _, row in ipairs(rows) do
			ImGui.TableNextRow()
			ImGui.TableSetColumnIndex(0)
			lockouts.text(colors[row.spec.color], row.spec.label)
			if ImGui.IsItemHovered() then
				local notes = crypticFocusNotes['Cryptic Clutch of ' .. row.spec.source]
				ImGui.SetTooltip('%s', 'Cryptic Clutch of ' .. row.spec.source .. ' / Hideous Hex of ' .. row.spec.source .. (notes and ('\n' .. notes) or ''))
			end
			for i, cell in ipairs(row.cells) do
				ImGui.TableSetColumnIndex(i)
				lockouts.centered(colors[cell.text], cell.text)
				if ImGui.IsItemHovered() then ImGui.SetTooltip('%s', cell.tip) end
			end
		end
		ImGui.EndTable()
	end
end

type12Matrix.search = ''
type12Matrix.sourceColors = {
	category = {0.56, 0.84, 0.74, 1.00},
	focus = {0.66, 0.58, 0.90, 1.00},
	effect = {0.92, 0.94, 0.96, 1.00},
	item = {0.38, 0.76, 0.94, 1.00},
	dim = {0.50, 0.55, 0.62, 1.00},
	source = {0.95, 0.72, 0.30, 1.00},
}

type12Matrix.sourceMatches = function(row, q)
	if q == '' then return true end
	local hay = {row.category, row.focus, row.effect}
	for _, item in ipairs(row.items or {}) do
		hay[#hay + 1] = item.name
		hay[#hay + 1] = item.slot
		hay[#hay + 1] = item.source
	end
	for _, text in ipairs(hay) do
		if tostring(text or ''):lower():find(q, 1, true) then return true end
	end
	return false
end

type12Matrix.drawSources = function()
	local c = type12Matrix.sourceColors
	lockouts.text(lockouts.ui.header, 'Anguish source items')
	ImGui.SetNextItemWidth(320)
	type12Matrix.search = ImGui.InputTextWithHint('##type12search', 'Search focus, effect, item, source...', type12Matrix.search) or ''
	if type12Matrix.search ~= '' then
		ImGui.SameLine()
		if ImGui.Button('Clear##type12search') then type12Matrix.search = '' end
	end
	local q = type12Matrix.search:lower():match('^%s*(.-)%s*$') or ''
	local category, shown = nil, 0
	for _, row in ipairs(dskType12Focus) do
		if type12Matrix.sourceMatches(row, q) then
			if row.category ~= category then
				category = row.category
				ImGui.Spacing()
				lockouts.text(c.category, category or 'Other')
			end
			shown = shown + 1
			lockouts.text(c.focus, row.focus or row.effect or '?')
			if row.focus and row.effect then
				ImGui.SameLine()
				lockouts.text(c.effect, ' - ' .. row.effect)
			end
			for _, item in ipairs(row.items or {}) do
				lockouts.text(c.dim, '  -')
				ImGui.SameLine()
				lockouts.text(c.item, item.name or '?')
				if ImGui.IsItemHovered() then
					ImGui.SetTooltip('%s', 'Item ID ' .. tostring(item.id or '?') .. ' - click to link')
					if ImGui.IsMouseClicked(ImGuiMouseButton.Left) then mq.cmdf('/link %s', item.name) end
				end
				if item.slot then
					ImGui.SameLine()
					lockouts.text(c.dim, '(' .. item.slot .. ')')
				end
				if item.source then
					ImGui.SameLine()
					lockouts.text(c.source, ' - ' .. item.source)
				end
			end
		end
	end
	if shown == 0 then lockouts.text(c.dim, 'No Type 12 source rows matched the search.') end
end

local function drawType12Tab()
	if currentTab ~= 'Type 12 Foci' then selectionChanged = true end
	currentTab = 'Type 12 Foci'
	if ImGui.Button('Refresh##type12') then selectionChanged = true end
	ImGui.SameLine()
	lockouts.text(type12Matrix.colors['-'], 'DoN = Cryptic Clutch owned.  DSK = Hideous Hex owned, DoN missing.  - = missing.')
	type12Matrix.draw()
	ImGui.Spacing()
	ImGui.Separator()
	ImGui.Spacing()
	type12Matrix.drawSources()
	ImGui.Spacing()
	ImGui.Separator()
	if ImGui.TreeNodeEx('DSK Type 12 focus reference##dsk_type12') then
		ImGui.TextColored(0.85, 0.64, 0.25, 1, 'Finished Hideous Hex augments (hover for effects)')
		local hexEntries = {}
		for _, entry in ipairs(dskHexFocus.shared) do hexEntries[#hexEntries + 1] = entry end
		local seen = {}
		for _, entry in pairs(dskHexFocus.byClass) do
			if not seen[entry.name] then
				seen[entry.name] = true
				hexEntries[#hexEntries + 1] = entry
			end
		end
		for index, entry in ipairs(hexEntries) do
			ImGui.Text('%s', entry.name)
			if ImGui.IsItemHovered() then ImGui.SetTooltip('%s', entry.notes) end
		end
		ImGui.TreePop()
	end
	if ImGui.TreeNodeEx('DoN Type 12 focus reference##don_type12') then
		for _, entry in ipairs(donFocusReference) do
			local finishedName = entry.item
			for _, name in ipairs(entry.names or {}) do
				if name:match('^Cryptic Clutch of ') then finishedName = name break end
			end
			ImGui.Text('%s', finishedName)
			if entry.notes and ImGui.IsItemHovered() then ImGui.SetTooltip('%s', entry.notes) end
		end
		ImGui.TreePop()
	end
end

-- Lockouts tab (layout and colours adapted from TurboGear).
lockouts.ui = {
	headerBg = {0.10, 0.15, 0.22, 1.00},
	rowBase = {0.060, 0.075, 0.100, 0.74},
	rowAlt = {0.085, 0.095, 0.120, 0.74},
	rowHover = {0.13, 0.20, 0.29, 0.95},
	rowBusy = {0.14, 0.11, 0.08, 0.86},
	ready = {0.35, 0.68, 0.45, 0.82},
	locked = {1.00, 0.48, 0.36, 1.00},
	active = {0.34, 0.78, 0.90, 1.00},
	unknown = {0.45, 0.48, 0.54, 1.00},
	instance = {0.74, 0.77, 0.82, 1.00},
	zone = {0.48, 0.52, 0.60, 1.00},
	dim = {0.50, 0.55, 0.62, 1.00},
	amber = {0.95, 0.72, 0.30, 1.00},
	header = {0.78, 0.82, 0.88, 1.00},
	section = {
		Raid = {bg = {0.22, 0.16, 0.07, 0.94}, fg = {0.90, 0.68, 0.34, 1.00}},
		TwoGroupRaid = {bg = {0.05, 0.22, 0.24, 0.94}, fg = {0.40, 0.82, 0.82, 1.00}},
		Group = {bg = {0.06, 0.14, 0.28, 0.94}, fg = {0.44, 0.68, 1.00, 1.00}},
		OldRaids = {bg = {0.12, 0.18, 0.24, 0.94}, fg = {0.68, 0.76, 0.84, 1.00}},
		Custom = {bg = {0.17, 0.11, 0.22, 0.94}, fg = {0.76, 0.58, 0.86, 1.00}},
		raid = {bg = {0.22, 0.16, 0.07, 0.94}, fg = {0.88, 0.66, 0.30, 1.00}},
		t1_missions = {bg = {0.05, 0.24, 0.26, 0.94}, fg = {0.38, 0.84, 0.86, 1.00}},
		t1_progression = {bg = {0.06, 0.14, 0.30, 0.94}, fg = {0.40, 0.64, 1.00, 1.00}},
		t2_missions = {bg = {0.05, 0.20, 0.31, 0.94}, fg = {0.38, 0.76, 0.96, 1.00}},
		t2_progression = {bg = {0.07, 0.12, 0.25, 0.94}, fg = {0.46, 0.62, 0.96, 1.00}},
		t3_missions = {bg = {0.18, 0.10, 0.32, 0.94}, fg = {0.68, 0.52, 0.96, 1.00}},
	},
	badge = {
		locked = {bg = {0.22, 0.10, 0.08, 0.96}, border = {0.54, 0.18, 0.16, 0.76}, label = {0.84, 0.48, 0.42, 1.00}, value = {1.00, 0.57, 0.48, 1.00}},
		open = {bg = {0.08, 0.17, 0.11, 0.96}, border = {0.18, 0.42, 0.25, 0.76}, label = {0.48, 0.74, 0.54, 1.00}, value = {0.58, 0.92, 0.64, 1.00}},
		chars = {bg = {0.11, 0.14, 0.20, 0.96}, border = {0.24, 0.32, 0.44, 0.76}, label = {0.62, 0.68, 0.76, 1.00}, value = {0.82, 0.86, 0.92, 1.00}},
	},
	role = {
		tank = {0.58, 0.66, 0.76, 1.0}, healer = {0.431, 0.906, 0.718, 1.0}, melee = {0.992, 0.729, 0.455, 1.0},
		caster = {0.753, 0.518, 0.988, 1.0}, utility = {0.404, 0.910, 0.976, 1.0},
	},
	classRole = {
		Warrior = 'tank', Paladin = 'tank', ['Shadow Knight'] = 'tank',
		Cleric = 'healer', Shaman = 'healer', Druid = 'healer',
		Bard = 'utility', Enchanter = 'utility',
		Berserker = 'melee', Beastlord = 'melee', Monk = 'melee', Ranger = 'melee', Rogue = 'melee',
		Magician = 'caster', Necromancer = 'caster', Wizard = 'caster',
	},
}

lockouts.text = function(color, text)
	ImGui.TextColored(color[1], color[2], color[3], color[4], '%s', tostring(text or ''))
end

lockouts.textWidth = function(text)
	local width = ImGui.CalcTextSize(tostring(text or ''))
	return gearOrder.vecWidth(width)
end

lockouts.centered = function(color, text)
	local cellWidth = gearOrder.vecWidth(ImGui.GetContentRegionAvail())
	local textWidth = lockouts.textWidth(text)
	if textWidth > 0 and textWidth < cellWidth then
		ImGui.SetCursorPosX(ImGui.GetCursorPosX() + (cellWidth - textWidth) / 2)
	end
	lockouts.text(color, text)
end

lockouts.rightAligned = function(color, text)
	local cellWidth = gearOrder.vecWidth(ImGui.GetContentRegionAvail())
	local textWidth = lockouts.textWidth(text)
	if textWidth > 0 and textWidth + 8 < cellWidth then
		ImGui.SetCursorPosX(ImGui.GetCursorPosX() + cellWidth - textWidth - 8)
	end
	lockouts.text(color, text)
end

lockouts.u32 = function(color)
	return ImGui.GetColorU32(color[1], color[2], color[3], color[4])
end

lockouts.rowBg = function(color)
	pcall(function() ImGui.TableSetBgColor(ImGuiTableBgTarget.RowBg0, lockouts.u32(color)) end)
end

lockouts.classColor = function(class)
	return lockouts.ui.role[lockouts.ui.classRole[class] or ''] or lockouts.ui.header
end

lockouts.durationText = function(seconds)
	local sec = math.max(0, math.floor(tonumber(seconds) or 0))
	local parts = {}
	local d = math.floor(sec / 86400) sec = sec % 86400
	local h = math.floor(sec / 3600) sec = sec % 3600
	local m = math.floor(sec / 60)
	if d > 0 then parts[#parts + 1] = d .. 'd' end
	if h > 0 then parts[#parts + 1] = h .. 'h' end
	if m > 0 or #parts == 0 then parts[#parts + 1] = m .. 'm' end
	return table.concat(parts, ' ')
end

lockouts.isCollapsed = function(section)
	local value = lockouts.load().collapsed[section.id]
	if value == nil then return section.defaultCollapsed == true end
	return value
end

-- Rebuilt at most once a second, or when reported data, the custom list or the toons change.
lockouts.build = function(toons, now)
	local saved, ui = lockouts.load(), lockouts.ui
	local model = {sections = {}, locked = 0, open = 0}
	local function finishRow(section, row)
		local hidden = saved.hidden[row.key] == true
		for _, cell in ipairs(row.cells) do
			if cell.kind == 'locked' then
				cell.text = lockouts.formatSeconds(cell.remaining)
				cell.tip = 'Available in: ' .. cell.text
			elseif cell.kind == 'active' then
				cell.text = cell.remaining and ('Active ' .. lockouts.formatSeconds(cell.remaining)) or 'Active'
				cell.tip = cell.remaining and ('Mission in progress, ' .. lockouts.formatSeconds(cell.remaining) .. ' left') or 'Mission in progress'
			elseif cell.kind == 'unknown' then
				cell.text = '?'
				cell.tip = 'Replay timers not read yet. Refresh runs /tasktime on each character.'
			elseif cell.kind == 'na' then
				cell.text = '-'
			elseif cell.kind == 'nodata' then
				cell.text = '?'
				cell.tip = 'No lockout data from this character yet.'
			end
			if cell.kind == 'locked' or cell.kind == 'active' then
				row.locked = true
				if not hidden then model.locked = model.locked + 1 end
			elseif cell.kind == 'open' and not hidden then
				model.open = model.open + 1
			end
		end
		section.rows[#section.rows + 1] = row
	end
	local function instanceSection(cat, entries)
		local section = {id = cat, title = lockouts.labels[cat], style = ui.section[cat], rows = {}}
		for _, entry in ipairs(entries) do
			local row = {key = cat .. '|' .. entry.name, entry = entry, label = entry.label or entry.name, zone = entry.zone, cells = {}}
			for _, char in ipairs(toons) do
				local kind, remaining = lockouts.cell(char.Name, cat, entry, now)
				row.cells[#row.cells + 1] = {kind = kind, remaining = remaining}
			end
			finishRow(section, row)
		end
		model.sections[#model.sections + 1] = section
	end
	for _, cat in ipairs(lockouts.order) do instanceSection(cat, lockouts.ref[cat]) end
	if #saved.entries > 0 then instanceSection('Custom', saved.entries) end
	for _, don in ipairs(lockouts.don) do
		local section = {id = don.id, title = don.title, note = don.note, right = don.timer, style = ui.section[don.id], defaultCollapsed = don.collapsed, don = true, rows = {}}
		for _, donRow in ipairs(don.rows) do
			local row = {key = 'DoN|' .. donRow.name, label = donRow.name, cells = {}}
			for _, char in ipairs(toons) do
				local kind, remaining = lockouts.donCell(char.Name, donRow, now)
				row.cells[#row.cells + 1] = {kind = kind, remaining = remaining}
			end
			finishRow(section, row)
		end
		model.sections[#model.sections + 1] = section
	end
	return model
end

lockouts.drawCell = function(cell)
	local ui = lockouts.ui
	if cell.kind == 'open' then
		lockouts.centered(ui.ready, icons.FA_UNLOCK)
		return
	end
	local color = (cell.kind == 'locked' and ui.locked) or (cell.kind == 'active' and ui.active)
		or (cell.kind == 'nodata' and ui.amber) or (cell.kind == 'na' and ui.dim) or ui.unknown
	lockouts.centered(color, cell.text)
	if cell.tip and ImGui.IsItemHovered() then ImGui.SetTooltip('%s', cell.tip) end
end

lockouts.chip = function(label, value, style)
	value = tostring(value)
	local padX, padY = 7, 4
	local width = math.max(62, lockouts.textWidth(label .. ' ' .. value) + padX * 2)
	local height = ImGui.GetTextLineHeight() + padY * 2
	local drawn = pcall(function()
		local x, y = ImGui.GetCursorScreenPos()
		local draw = ImGui.GetWindowDrawList()
		draw:AddRectFilled(ImVec2(x, y), ImVec2(x + width, y + height), lockouts.u32(style.bg), 4.0)
		draw:AddRect(ImVec2(x, y), ImVec2(x + width, y + height), lockouts.u32(style.border), 4.0, 0, 1.0)
		draw:AddText(ImVec2(x + padX, y + padY), lockouts.u32(style.label), label)
		draw:AddText(ImVec2(x + padX + lockouts.textWidth(label .. ' '), y + padY), lockouts.u32(style.value), value)
	end)
	if drawn then ImGui.Dummy(width, height) else lockouts.text(style.label, label .. ' ' .. value) end
end

lockouts.drawChips = function(locked, open, chars)
	local badge = lockouts.ui.badge
	local specs = {{'Locked', locked, badge.locked}, {'Open', open, badge.open}, {'Chars', chars, badge.chars}}
	local total = 8 * (#specs - 1)
	for _, spec in ipairs(specs) do
		total = total + math.max(62, lockouts.textWidth(spec[1] .. ' ' .. tostring(spec[2])) + 14)
	end
	ImGui.SameLine()
	local avail = gearOrder.vecWidth(ImGui.GetContentRegionAvail())
	if avail > total then ImGui.SetCursorPosX(ImGui.GetCursorPosX() + avail - total) end
	for i, spec in ipairs(specs) do
		if i > 1 then ImGui.SameLine() end
		lockouts.chip(spec[1], spec[2], spec[3])
	end
end

lockouts.clearForm = function()
	local form = lockouts.form
	form.name, form.lockout, form.zone, form.duration, form.chars = '', '', '', '', {}
	form.index, form.editing, form.keepTimers, form.keepDuration = nil, nil, nil, nil
end

-- The entry stays in place until Save replaces it; an unchanged duration keeps its running timers.
lockouts.editCustom = function(entry)
	local form, me = lockouts.form, mq.TLO.Me.CleanName()
	form.name, form.lockout, form.zone, form.index = entry.name, entry.lockout, entry.zone, entry.index
	form.chars = {}
	for _, charName in ipairs(entry.characters or {}) do form.chars[charName] = true end
	local expiresAt
	for charName, at in pairs(entry.manualTimers or {}) do
		if charName == me then expiresAt = at break end
		if not expiresAt or at > expiresAt then expiresAt = at end
	end
	form.duration = (expiresAt and expiresAt > os.time()) and lockouts.durationText(expiresAt - os.time()) or ''
	form.editing, form.keepTimers, form.keepDuration = entry.name, entry.manualTimers, form.duration
	form.show, form.advanced = true, true
	form.status = string.format("Editing '%s' - change the fields and click Save.", entry.name)
end

lockouts.drawCustomPanel = function()
	local ui, form, saved = lockouts.ui, lockouts.form, lockouts.load()
	ImGui.Spacing()
	if ImGui.Button('Pick from DZ timers##lo_pick') then
		form.picker = lockouts.allTimers()
		ImGui.OpenPopup('##lo_dz_picker')
	end
	if ImGui.IsItemHovered() then ImGui.SetTooltip('Lists the DZ timers your characters currently have, so you can track one that is not on the list.') end
	ImGui.SameLine()
	if ImGui.Button('Add all from DZ timers##lo_addall') then
		local added = 0
		for _, timer in ipairs(lockouts.allTimers()) do
			if not lockouts.isTracked(timer.row) and lockouts.addCustom({name = timer.label, lockout = '=' .. timer.label, index = timer.index}) then
				added = added + 1
			end
		end
		form.status = added > 0 and string.format('Added %d new lockout%s.', added, added == 1 and '' or 's') or 'Every reported DZ timer is already tracked.'
	end
	ImGui.SameLine()
	form.advanced = ImGui.Checkbox('Advanced##lo_adv', form.advanced == true)

	if ImGui.BeginPopup('##lo_dz_picker') then
		if #form.picker == 0 then
			lockouts.text(ui.amber, 'No DZ timers reported.')
			lockouts.text(ui.dim, 'Refresh first; otherwise no character has a lockout running.')
		else
			lockouts.text(ui.dim, form.advanced and 'Click to fill the form:' or 'Click to add:')
			ImGui.Separator()
			for _, timer in ipairs(form.picker) do
				local label = string.format('%s  (%s, %s)', timer.label, timer.timer, timer.owner)
				if lockouts.isTracked(timer.row) then
					lockouts.text(ui.dim, label .. '  [tracked]')
				elseif ImGui.Selectable(label .. '##lo_pk_' .. timer.label, false) then
					if form.advanced then
						form.lockout, form.index = '=' .. timer.label, timer.index
						if form.name == '' then form.name = timer.label end
					else
						local ok, err = lockouts.addCustom({name = timer.label, lockout = '=' .. timer.label, index = timer.index})
						form.status = ok and string.format("Added '%s'.", timer.label) or err
					end
				end
			end
		end
		ImGui.EndPopup()
	end

	if form.advanced then
		lockouts.text(ui.dim, "Manual entry. Put '=' before the DZ timer label for an exact match. A duration starts a timer by hand.")
		ImGui.SetNextItemWidth(160)
		form.name = ImGui.InputTextWithHint('##lo_name', 'Display name', form.name) or ''
		ImGui.SameLine()
		ImGui.SetNextItemWidth(220)
		form.lockout = ImGui.InputTextWithHint('##lo_lockout', 'DZ timer label', form.lockout) or ''
		ImGui.SameLine()
		ImGui.SetNextItemWidth(130)
		form.duration = ImGui.InputTextWithHint('##lo_duration', 'Duration (e.g. 6d)', form.duration) or ''
		ImGui.SetNextItemWidth(160)
		form.zone = ImGui.InputTextWithHint('##lo_zone', 'Zone label (optional)', form.zone) or ''
		ImGui.SameLine()
		local selected = {}
		for charName, on in pairs(form.chars) do
			if on then selected[#selected + 1] = charName end
		end
		table.sort(selected)
		ImGui.SetNextItemWidth(220)
		if ImGui.BeginCombo('##lo_chars', #selected == 0 and 'All characters' or table.concat(selected, ', ')) then
			if ImGui.Selectable('All characters##lo_chars_all', #selected == 0) then form.chars = {} end
			ImGui.Separator()
			for _, charName in ipairs(sortedGroup) do
				local value, pressed = ImGui.Checkbox(charName .. '##lo_char', form.chars[charName] == true)
				if pressed then form.chars[charName] = value or nil end
			end
			ImGui.EndCombo()
		end
		ImGui.SameLine()
		if ImGui.Button((form.editing and 'Save' or 'Add') .. '###lo_add') then
			local ok, err = lockouts.addCustom({name = form.name, lockout = form.lockout, zone = form.zone, duration = form.duration,
				index = form.index, characters = #selected > 0 and selected or nil,
				replace = form.editing, keepTimers = form.keepTimers, keepDuration = form.keepDuration})
			if ok then
				form.status = string.format("%s '%s'%s.", form.editing and 'Saved' or 'Added', lockouts.trim(form.name),
					#selected > 0 and (' (' .. table.concat(selected, ', ') .. ')') or '')
				lockouts.clearForm()
			else
				form.status = err
			end
		end
		if form.editing then
			ImGui.SameLine()
			if ImGui.Button('Cancel##lo_cancel') then
				lockouts.clearForm()
				form.status = ''
			end
		end
	end

	if form.status ~= '' then lockouts.text(ui.dim, form.status) end

	if #saved.entries > 0 then
		ImGui.Separator()
		lockouts.text(ui.dim, 'Your custom lockouts:')
		local removeName, editEntry
		for i, entry in ipairs(saved.entries) do
			if ImGui.SmallButton('x##lo_del_' .. i) then removeName = entry.name end
			ImGui.SameLine()
			if ImGui.SmallButton('Edit##lo_edit_' .. i) then editEntry = entry end
			ImGui.SameLine()
			lockouts.text(ui.instance, entry.name .. (entry.zone ~= '' and (' (' .. entry.zone .. ')') or '')
				.. (entry.characters and (' [' .. table.concat(entry.characters, ', ') .. ']') or ' [all]'))
		end
		if removeName then
			lockouts.removeCustom(removeName)
			if form.editing == removeName then lockouts.clearForm() end
			form.status = string.format("Removed '%s'.", removeName)
		elseif editEntry then
			lockouts.editCustom(editEntry)
		end
	end
	ImGui.Spacing()
end

lockouts.drawSection = function(section, toons, saved)
	local ui, form = lockouts.ui, lockouts.form
	local visible = {}
	for _, row in ipairs(section.rows) do
		if (saved.showHidden or saved.hidden[row.key] ~= true) and (not saved.lockedOnly or row.locked) then
			visible[#visible + 1] = row
		end
	end
	if #visible == 0 then return end

	local collapsed = lockouts.isCollapsed(section)
	local fg = section.style.fg
	ImGui.TableNextRow()
	lockouts.rowBg(section.style.bg)
	ImGui.TableSetColumnIndex(0)
	local title = (collapsed and '[+] ' or '[-] ') .. section.title
	if section.note and section.note ~= '' then title = title .. '    ' .. section.note end
	ImGui.PushStyleColor(ImGuiCol.Text, fg[1], fg[2], fg[3], fg[4])
	local selected, pressed = ImGui.Selectable(title .. '###lo_sec_' .. section.id, false, ImGuiSelectableFlags.SpanAllColumns)
	ImGui.PopStyleColor()
	if selected or pressed then
		saved.collapsed[section.id] = not collapsed
		lockouts.save()
	end
	if ImGui.IsItemHovered() then lockouts.rowBg(ui.rowHover) end
	if ImGui.TableSetColumnIndex(#toons) then
		lockouts.rightAligned(fg, section.right or string.format('%d Instance%s', #visible, #visible == 1 and '' or 's'))
	end
	if collapsed then return end

	for index, row in ipairs(visible) do
		local hidden = saved.hidden[row.key] == true
		ImGui.TableNextRow()
		if section.don and row.locked then
			lockouts.rowBg(ui.rowBusy)
		else
			lockouts.rowBg(index % 2 == 0 and ui.rowAlt or ui.rowBase)
		end
		ImGui.TableSetColumnIndex(0)
		lockouts.text(hidden and ui.dim or ui.instance, hidden and ('(' .. row.label .. ')') or row.label)
		local hovered = ImGui.IsItemHovered()
		if ImGui.BeginPopupContextItem('##lo_ctx_' .. row.key) then
			if row.entry and row.entry.custom then
				if ImGui.MenuItem('Edit') then lockouts.editCustom(row.entry) end
				if ImGui.MenuItem('Delete') then
					lockouts.removeCustom(row.entry.name)
					if form.editing == row.entry.name then lockouts.clearForm() end
					form.status = string.format("Removed '%s'.", row.entry.name)
				end
				ImGui.Separator()
			end
			if ImGui.MenuItem(hidden and 'Show this lockout' or 'Hide this lockout') then
				saved.hidden[row.key] = (not hidden) or nil
				lockouts.save()
				lockouts.version = lockouts.version + 1
			end
			ImGui.EndPopup()
		end
		if row.zone and row.zone ~= '' then
			ImGui.SameLine(0, 3)
			lockouts.text(ui.zone, '(' .. row.zone .. ')')
			hovered = hovered or ImGui.IsItemHovered()
		end
		if hovered then lockouts.rowBg(ui.rowHover) end
		for i, cell in ipairs(row.cells) do
			if ImGui.TableSetColumnIndex(i) then lockouts.drawCell(cell) end
		end
	end
end

-- Returns true when every character should be asked for fresh data.
lockouts.draw = function(entered)
	local ui, saved, form = lockouts.ui, lockouts.load(), lockouts.form
	local refresh = entered == true
	drawCharacterMenus()
	ImGui.SameLine()
	if ImGui.Button('Refresh##lockouts') then
		refresh = true
		lockouts.forceTasktime = true
	end
	if ImGui.IsItemHovered() then
		ImGui.SetTooltip('Re-read lockouts on every character. Also runs /tasktime on each one to read DoN replay timers.')
	end

	local toons, names = {}, {}
	for _, char in ipairs(gearOrder.get()) do
		if char.Show and not char.Offline then
			toons[#toons + 1] = char
			names[#names + 1] = char.Name
		end
	end
	if #toons == 0 then
		lockouts.text(ui.amber, 'No online characters selected.')
		return refresh
	end

	local now, signature = os.time(), table.concat(names, ',')
	local model = lockouts.model
	if not model or model.at ~= now or model.version ~= lockouts.version or model.signature ~= signature then
		model = lockouts.build(toons, now)
		model.at, model.version, model.signature = now, lockouts.version, signature
		lockouts.model = model
	end

	local pressed
	saved.lockedOnly, pressed = ImGui.Checkbox('Locked Only##lockouts', saved.lockedOnly == true)
	if pressed then lockouts.save() end
	ImGui.SameLine()
	saved.showHidden, pressed = ImGui.Checkbox('Show Hidden##lockouts', saved.showHidden == true)
	if pressed then lockouts.save() end
	ImGui.SameLine()
	local allCollapsed = true
	for _, section in ipairs(model.sections) do
		if not lockouts.isCollapsed(section) then allCollapsed = false break end
	end
	if ImGui.Button((allCollapsed and 'Expand All' or 'Collapse All') .. '###lo_collapse_all') then
		for _, section in ipairs(model.sections) do saved.collapsed[section.id] = not allCollapsed end
		lockouts.save()
	end
	ImGui.SameLine()
	if ImGui.Button('Add Your Own Custom Lockouts##lockouts') then form.show = not form.show end
	lockouts.drawChips(model.locked, model.open, #toons)
	if form.show then lockouts.drawCustomPanel() end

	local avail = gearOrder.vecWidth(ImGui.GetContentRegionAvail())
	local needed = 300 + #toons * 100 + 24
	local footer = ImGui.GetTextLineHeight() + 10
	local flags = bit32.bor(ImGuiTableFlags.Borders, ImGuiTableFlags.RowBg, ImGuiTableFlags.ScrollY, ImGuiTableFlags.NoSavedSettings)
	ImGui.PushStyleColor(ImGuiCol.TableHeaderBg, ui.headerBg[1], ui.headerBg[2], ui.headerBg[3], ui.headerBg[4])
	ImGui.PushStyleColor(ImGuiCol.TableRowBg, ui.rowBase[1], ui.rowBase[2], ui.rowBase[3], ui.rowBase[4])
	ImGui.PushStyleColor(ImGuiCol.TableRowBgAlt, ui.rowAlt[1], ui.rowAlt[2], ui.rowAlt[3], ui.rowAlt[4])
	ImGui.PushStyleColor(ImGuiCol.TableBorderLight, 0.17, 0.21, 0.27, 0.72)
	ImGui.PushStyleColor(ImGuiCol.TableBorderStrong, 0.22, 0.30, 0.38, 0.95)
	ImGui.PushStyleColor(ImGuiCol.HeaderHovered, ui.rowHover[1], ui.rowHover[2], ui.rowHover[3], ui.rowHover[4])
	local opened
	if needed > avail then
		opened = ImGui.BeginTable('LockoutsMain', #toons + 1, bit32.bor(flags, ImGuiTableFlags.ScrollX), 0, -footer, needed)
	else
		opened = ImGui.BeginTable('LockoutsMain', #toons + 1, flags, 0, -footer)
	end
	if opened then
		-- A drawing error must not skip EndTable, so the body runs protected.
		local ok, err = pcall(function()
			ImGui.TableSetupColumn('Instance', ImGuiTableColumnFlags.WidthFixed, 300)
			for _, char in ipairs(toons) do
				ImGui.TableSetupColumn('##lo_col_' .. char.Name, ImGuiTableColumnFlags.WidthStretch, 1)
			end
			ImGui.TableSetupScrollFreeze(1, 1)
			ImGui.TableNextRow()
			lockouts.rowBg(ui.headerBg)
			ImGui.TableSetColumnIndex(0)
			lockouts.text(ui.header, 'Instance')
			for i, char in ipairs(toons) do
				if ImGui.TableSetColumnIndex(i) then
					lockouts.centered(lockouts.classColor(char.Class), char.Name)
					gearOrder.dragSource(char.Name, true)
					gearOrder.dropTarget(char.Name)
				end
			end
			for _, section in ipairs(model.sections) do
				lockouts.drawSection(section, toons, saved)
			end
		end)
		ImGui.EndTable()
		if not ok then lockouts.text(ui.amber, 'Lockouts table error: ' .. tostring(err)) end
	end
	ImGui.PopStyleColor(6)
	lockouts.text(ui.dim, 'Timer = locked (hover for details)  |  Unlock = available  |  Active = DoN mission in progress  |  ? = not read yet')
	return refresh
end

local function bisGUIContent()
	ImGui.SetNextWindowSize(ImVec2(800,500), ImGuiCond.FirstUseEver)
	if minimizedGUI then
		openGUI, shouldDrawGUI = ImGui.Begin('LazBis (' .. meta.version .. ')###BIS Check Mini', openGUI,
			bit32.bor(ImGuiWindowFlags.AlwaysAutoResize, ImGuiWindowFlags.NoResize, ImGuiWindowFlags.NoTitleBar))
	else
		local windowFlags = WINDOW_FLAGS
		if settings.Locked then windowFlags = bit32.bor(windowFlags, ImGuiWindowFlags.NoMove, ImGuiWindowFlags.NoResize) end
		openGUI, shouldDrawGUI = ImGui.Begin('LazBis ('.. meta.version ..')###BIS Check', openGUI, windowFlags)
	end
	if shouldDrawGUI then
		if minimizedGUI then
			if ImGui.ImageButton('MinimizeLazBis', iconImg:GetTextureID(), ImVec2(30, 30)) then
				minimizedGUI = false
			end
			if ImGui.IsItemHovered() then
				ImGui.SetTooltip("LazBis is Running")
			end
		else
			ImGui.PushStyleVar(ImGuiStyleVar.ScrollbarSize, 17)
			if ImGui.Button(icons.MD_FULLSCREEN_EXIT) then
				minimizedGUI = true
			end
			if ImGui.IsItemHovered() then
				ImGui.BeginTooltip()
				ImGui.Text('Minimize')
				ImGui.EndTooltip()
			end
			ImGui.SameLine()
			local oldLocked = settings.Locked
			settings.Locked = LockButton('bislocked', settings.Locked)
			if oldLocked ~= settings.Locked then
				updateSetting('Locked', settings.Locked)
			end
			ImGui.SameLine()
			if ImGui.BeginTabBar('bistabs') then
				if ImGui.BeginTabItem('Gear') then
					currentTab = 'Gear'
					local origSelectedItemList = selectedItemList
					ImGui.PushItemWidth(150)
					ImGui.SetNextWindowSize(150, 385)
					if ImGui.BeginCombo('Item List', selectedItemList.name) then
						for _, group in ipairs(bisConfig.Groups) do
							ImGui.TextColored(1, 1, 0, 1, group)
							ImGui.Separator()
							for i, list in ipairs(bisConfig.ItemLists[group]) do
								if ImGui.Selectable(list.name, selectedItemList.id == list.id) then
									selectedItemList = list
									settings['SelectedList'] = selectedItemList.id
									updateSetting('SelectedList', selectedItemList.id)
								end
							end
						end
						ImGui.EndCombo()
					end
					ImGui.PopItemWidth()

					itemList = bisConfig[selectedItemList.id]
					local slots = itemList.Main.Slots
					if selectedItemList.id ~= origSelectedItemList.id then
						selectionChanged = true
						filter = ''
						settings.ShowMissingOnly = false
						updateSetting('SelectedList', selectedItemList.id)
					end
					ImGui.SameLine()
					if ImGui.Button('Refresh') then selectionChanged = true end
					ImGui.SameLine()
					ImGui.PushItemWidth(300)
					local tmpFilter = ImGui.InputTextWithHint('##filter', 'Search...', filter)
					ImGui.PopItemWidth()
					ImGui.SameLine()
					ImGui.Text('Show:')
					ImGui.SameLine()
					local tmpShowSlots = ImGui.Checkbox('Slots', settings.ShowSlots)
					if tmpShowSlots ~= settings.ShowSlots then updateSetting('ShowSlots', tmpShowSlots) end
					ImGui.SameLine()
					local tmpShowMissingOnly = ImGui.Checkbox('Missing Only', settings.ShowMissingOnly)
					if tmpShowMissingOnly ~= settings.ShowMissingOnly or tmpFilter ~= filter or reapplyFilter then
						filter = tmpFilter
						if tmpShowMissingOnly ~= settings.ShowMissingOnly then updateSetting('ShowMissingOnly', tmpShowMissingOnly) end
						filterGear(slots)
						reapplyFilter = false
					end
					if filter ~= '' or settings.ShowMissingOnly then useFilter = true else useFilter = false end
					ImGui.SameLine()
					VerticalSeparator()
					ImGui.SameLine()
					ImGui.Text('Announce:')
					ImGui.SameLine()
					local tmpAnnounceNeeds = ImGui.Checkbox('##AnnounceNeeds', settings.AnnounceNeeds)
					if tmpAnnounceNeeds ~= settings.AnnounceNeeds then updateSetting('AnnounceNeeds', tmpAnnounceNeeds) end
					ImGui.SameLine()
					ImGui.PushItemWidth(90)
					if ImGui.BeginCombo('##Channel', settings.AnnounceChannel) then
						for i,name in ipairs({'Group','Raid','Guild','Say'}) do
							local selected = ImGui.Selectable(name, settings.AnnounceChannel == name)
							if selected and name ~= settings.AnnounceChannel then
								updateSetting('AnnounceChannel', name)
							end
						end
						ImGui.EndCombo()
					end
					ImGui.PopItemWidth()
					ImGui.SameLine()
					VerticalSeparator()
					
					local availWidth = gearOrder.vecWidth(ImGui.GetContentRegionAvail())
					local centerOffset = math.max(0, (availWidth - gearOrder.rowWidth) / 2)
					ImGui.SetCursorPosX(ImGui.GetCursorPosX() + centerOffset)

					ImGui.BeginGroup()
					drawCharacterMenus()

					gearOrder.current = gearOrder.get()
					ImGui.SameLine()
					if ImGui.Button('Reorder Toons') then
						ImGui.OpenPopup('Reorder Toons##popup')
					end
					ImGui.EndGroup()
					gearOrder.rowWidth = gearOrder.vecWidth(ImGui.GetItemRectSize())

					if ImGui.BeginPopup('Reorder Toons##popup') then
						ImGui.Text('Set the column order for the Gear tab:')
						local saveCloseWidth = 190
						local popupWidth = gearOrder.vecWidth(ImGui.GetContentRegionAvail())
						ImGui.SetCursorPosX(ImGui.GetCursorPosX() + math.max(0, (popupWidth - saveCloseWidth) / 2))
						if ImGui.Button('Save Order and Close', saveCloseWidth, 0) then
							gearOrder.save()
							ImGui.CloseCurrentPopup()
						end
						ImGui.Separator()
						for i,char in ipairs(gearOrder.current) do
							ImGui.PushID('reorder##'..char.Name)
							if ImGui.Button('^') then
								gearOrder.move(char.Name, -1)
							end
							ImGui.SameLine()
							if ImGui.Button('v') then
								gearOrder.move(char.Name, 1)
							end
							ImGui.SameLine()
							ImGui.Text(char.Name)
							ImGui.PopID()
						end
						ImGui.EndPopup()
					end
					local numColumns = 1
					for _,char in ipairs(group) do if char.Show then numColumns = numColumns + 1 end end
					if next(itemChecks) ~= nil then
						ImGui.Separator()
						if ImGui.Button('X##LinkedItems') then
							itemChecks = {}
						end
						ImGui.SameLine()
						ImGui.Text('Linked items:')
						if ImGui.BeginTable('linked items', numColumns, bit32.bor(ImGuiTableFlags.NoSavedSettings, ImGuiTableFlags.ScrollX, ImGuiTableFlags.ScrollY), -1.0, 115) then
							ImGui.TableSetupScrollFreeze(0, 1)
							ImGui.TableSetupColumn('ItemName', bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthFixed), 500, 0)
							for i,char in ipairs(group) do
								if char.Show then
									ImGui.TableSetupColumn(char.Name, bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthFixed), -1.0, 0)
								end
							end
							ImGui.TableHeadersRow()
			
							for itemName, _ in pairs(itemChecks) do
								ImGui.TableNextRow()
								ImGui.TableSetColumnIndex(0)
								if ImGui.Button('X##' .. itemName) then
									itemChecks[itemName] = nil
								end
								ImGui.SameLine()
								if ImGui.Button('Announce##'..itemName) then
									local message = getAnnounceChannel()
									local doSend = false
									message = message .. itemName .. ' - '
									for _,name in ipairs(sortedGroup) do
										local char = group[name]
										if itemChecks[itemName][char.Name] == false then
											-- message = message .. string.format('%s(%s)', char.Name, classes[char.Class]) .. ', '
											message = message .. char.Name .. ', '
											doSend = true
										end
									end
									if doSend then mq.cmd(message) end
								end
								ImGui.SameLine()
								ImGui.Text(itemName)
								if itemChecks[itemName] then
									for _,char in ipairs(group) do
										if char.Show then
											ImGui.TableNextColumn()
											if itemChecks[itemName][char.Name] ~= nil then
												local hasItem = itemChecks[itemName][char.Name]
												ImGui.PushStyleColor(ImGuiCol.Text, hasItem and 0 or 1, hasItem and 1 or 0, 0.1, 1)
												ImGui.Text(hasItem and 'HAVE' or 'NEED')
												ImGui.PopStyleColor()
											end
										end
									end
								end
							end
							ImGui.EndTable()
						end
					end
		
					if gearOrder.beginTable(numColumns) then
						ImGui.TableSetupScrollFreeze(1, 1)
						ImGui.TableSetupColumn('Item', bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthFixed), -1.0, gearOrder.stableId('Item'))
						for i,char in ipairs(gearOrder.current) do
							if char.Show then
								ImGui.TableSetupColumn(char.Name, bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthStretch), 1.0, gearOrder.stableId(char.Name))
							end
						end
						-- Headers are drawn manually (not TableHeadersRow) so they can be dragged to reorder the toons.
						ImGui.TableNextRow(ImGuiTableRowFlags.Headers)
						ImGui.PushID('gearhdr')
						if ImGui.TableSetColumnIndex(0) then ImGui.TableHeader('Item') end
						local hdrCol = 0
						for _,char in ipairs(gearOrder.current) do
							if char.Show then
								hdrCol = hdrCol + 1
								if ImGui.TableSetColumnIndex(hdrCol) then
									ImGui.TableHeader(char.Name)
									gearOrder.dragSource(char.Name)
									gearOrder.dropTarget(char.Name)
								end
							end
						end
						ImGui.PopID()
		
						local tmpSlots = slots
						local tmpGear = gear
						if useFilter then tmpSlots = filteredSlots tmpGear = filteredGear end
						if tmpSlots then
							for _,category in ipairs(tmpSlots) do
								local catName = category.Name
								ImGui.TableNextRow()
								ImGui.TableNextColumn()
								if ImGui.TreeNodeEx(catName, bit32.bor(ImGuiTreeNodeFlags.SpanFullWidth, ImGuiTreeNodeFlags.DefaultOpen)) then
									local catSlots = category.Slots
									for _,slot in ipairs(catSlots) do
										if slot ~= 'Wrists' then
											slotRow(slot, tmpGear)
										else
											slotRow('Wrist1', tmpGear)
											slotRow('Wrist2', tmpGear)
										end
									end
									ImGui.TreePop()
								end
								if catName == 'Powersource' and selectedItemList.id == 'questitems' then
									ImGui.TableNextRow()
									ImGui.TableNextColumn()
									if ImGui.TreeNodeEx('Tradeskills', bit32.bor(ImGuiTreeNodeFlags.SpanFullWidth, ImGuiTreeNodeFlags.DefaultOpen)) then
										for _,name in ipairs(orderedSkills) do
											ImGui.TableNextRow()
											ImGui.TableNextColumn()
											ImGui.Text(name)
											for _,char in ipairs(gearOrder.current) do
												if char.Show then
													ImGui.TableNextColumn()
													local skill = tradeskills[char.Name] and tradeskills[char.Name][name] or 0
													ImGui.TextColored(skill < 300 and 1 or 0, skill == 300 and 1 or 0, 0, 1, '%s', tradeskills[char.Name] and tradeskills[char.Name][name])
												end
											end
										end
										ImGui.TreePop()
									end
								end
							end
						end
						ImGui.EndTable()
					end
					ImGui.EndTabItem()
				end
				if ImGui.BeginTabItem('Empties') then
					currentTab = 'Empties'
					local hadEmpties = false
					for char,empties in pairs(emptySlots) do
						if empties then
							ImGui.PushID(char)
							hadEmpties = true
							if ImGui.TreeNode('%s', char) then
								for _,empty in ipairs(empties) do
									ImGui.Text(' - %s', empty)
								end
								ImGui.TreePop()
							end
							ImGui.PopID()
						end
					end
					if not hadEmpties then
						ImGui.ImageButton('NiceButton', niceImg:GetTextureID(), ImVec2(200, 200),ImVec2(0.0,0.0), ImVec2(.55, .7))
					end
					ImGui.EndTabItem()
				end
				if bisConfig.StatFoodRecipes and ImGui.BeginTabItem('Stat Food') then
					currentTab = 'Stat Food'
					if ImGui.BeginTabBar('##statfoodtabs') then
						if ImGui.BeginTabItem('Recipes') then
							for _,recipe in ipairs(bisConfig.StatFoodRecipes) do
								ImGui.PushStyleColor(ImGuiCol.Text, 0,1,1,1)
								local expanded = ImGui.TreeNode(recipe.Name)
								ImGui.PopStyleColor()
								if expanded then
									ImGui.Indent(30)
									for _,ingredient in ipairs(recipe.Ingredients) do
										ImGui.Text('%s%s', ingredient, bisConfig.StatFoodIngredients[ingredient] and ' - '..bisConfig.StatFoodIngredients[ingredient].Location or '')
										ImGui.SameLine()
										ImGui.TextColored(1,1,0,1,'(%s)', mq.TLO.FindItemCount('='..ingredient))
									end
									ImGui.Unindent(30)
									ImGui.TreePop()
								end
							end
							ImGui.EndTabItem()
						end
						if ImGui.BeginTabItem('Quests') then
							ImGui.PushItemWidth(300)
							if ImGui.BeginCombo('Quest', bisConfig.StatFoodQuests[recipeQuestIdx].Name) then
								for i,quest in ipairs(bisConfig.StatFoodQuests) do
									if ImGui.Selectable(quest.Name, recipeQuestIdx == i) then
										recipeQuestIdx = i
									end
								end
								ImGui.EndCombo()
							end
							ImGui.PopItemWidth()
		
							for _,questStep in ipairs(bisConfig.StatFoodQuests[recipeQuestIdx].Recipes) do
								ImGui.TextColored(0,1,1,1,questStep.Name)
								ImGui.Indent(25)
								for _,step in ipairs(questStep.Steps) do
									ImGui.Text('\xee\x97\x8c %s', step)
								end
								ImGui.Unindent(25)
							end
							ImGui.EndTabItem()
						end
						if ImGui.BeginTabItem('Ingredients') then
							ImGui.SameLine()
							ImGui.PushItemWidth(300)
							local tmpIngredientFilter = ImGui.InputTextWithHint('##ingredientfilter', 'Search...', ingredientFilter)
							ImGui.PopItemWidth()
							if tmpIngredientFilter ~= ingredientFilter then
								ingredientFilter = tmpIngredientFilter
								filterIngredients()
							end
							if ingredientFilter ~= '' then useIngredientFilter = true else useIngredientFilter = false end
							local tmpIngredients = ingredientsArray
							if useIngredientFilter then tmpIngredients = filteredIngredients end
		
							if ImGui.BeginTable('Ingredients', 3, bit32.bor(ImGuiTableFlags.BordersInner, ImGuiTableFlags.RowBg, ImGuiTableFlags.Reorderable, ImGuiTableFlags.NoSavedSettings, ImGuiTableFlags.ScrollX, ImGuiTableFlags.ScrollY, ImGuiTableFlags.Sortable)) then
								ImGui.TableSetupScrollFreeze(0, 1)
								ImGui.TableSetupColumn('Ingredient', bit32.bor(ImGuiTableColumnFlags.DefaultSort, ImGuiTableColumnFlags.WidthFixed), -1.0, ColumnID_Name)
								ImGui.TableSetupColumn('Location', bit32.bor(ImGuiTableColumnFlags.WidthFixed), -1.0, ColumnID_Location)
								ImGui.TableSetupColumn('Count', bit32.bor(ImGuiTableColumnFlags.NoSort, ImGuiTableColumnFlags.WidthFixed), -1.0, 0)
								ImGui.TableHeadersRow()
		
								local sort_specs = ImGui.TableGetSortSpecs()
								if sort_specs then
									if sort_specs.SpecsDirty then
										current_sort_specs = sort_specs
										table.sort(tmpIngredients, CompareWithSortSpecs)
										current_sort_specs = nil
										sort_specs.SpecsDirty = false
									end
								end

								for _,ingredient in ipairs(tmpIngredients) do
									ImGui.TableNextRow()
									ImGui.TableNextColumn()
									ImGui.Text(ingredient.Name)
									ImGui.TableNextColumn()
									ImGui.Text(ingredient.Location)
									ImGui.TableNextColumn()
									ImGui.Text('%s', mq.TLO.FindItemCount('='..ingredient.Name)())
								end
								ImGui.EndTable()
							end
							ImGui.EndTabItem()
						end
						ImGui.EndTabBar()
					end
					ImGui.EndTabItem()
				end
				if ImGui.BeginTabItem('Type 12 Foci') then
					drawType12Tab()
					ImGui.EndTabItem()
				end
				if ImGui.BeginTabItem('Spells') then
					currentTab = 'Spells'
					hideOwnedSpells = ImGui.Checkbox('Missing Only', hideOwnedSpells)
					ImGui.SameLine()
					if ImGui.Button('Refresh') then selectionChanged = true end
					ImGui.SameLine()
					ImGui.TextColored(0.50, 0.55, 0.62, 1, 'Online characters show learned and missing; offline records show missing')
					ImGui.SameLine()
					VerticalSeparator()
					ImGui.SameLine()
					drawCharacterMenus()
					ImGui.SameLine()
					VerticalSeparator()
					ImGui.SameLine()
					ImGui.PushItemWidth(120)
					local tmpSpellColWidth = ImGui.SliderInt('Table Width##spellcolwidth', spellColumnWidth, 420, 800)
					ImGui.PopItemWidth()
					if tmpSpellColWidth ~= spellColumnWidth then spellColumnWidth = tmpSpellColWidth end

					-- Place character tables in rows that fit the available tab width.
					ImGui.BeginChild('SpellsScrollRegion', -1, -1, false)
                    local available = ImGui.GetContentRegionAvail()
                    local availableWidth = tonumber(available) or 0
                    if type(available) == 'table' or type(available) == 'userdata' then
                        local ok, x = pcall(function() return available.x or available[1] end)
                        if ok then availableWidth = tonumber(x) or 0 end
                    end
                    if availableWidth <= 0 then
                        availableWidth = (ImGui.GetWindowWidth and ImGui.GetWindowWidth() or spellColumnWidth) - 24
                    end
                    local cardWidth = math.max(1, math.min(spellColumnWidth, availableWidth))
                    local gap, rowWidth = 8, 0
					local myName = mq.TLO.Me.CleanName()
					for _,char in ipairs(gearOrder.get()) do
						local isMe = char.Name == myName
						local data = groupSpellData[char.Name]
						if isMe or (char.Show and data) then
							if rowWidth > 0 and rowWidth + gap + cardWidth <= availableWidth then
								ImGui.SameLine()
								rowWidth = rowWidth + gap + cardWidth
							else
								rowWidth = cardWidth
							end
							ImGui.BeginGroup()
							ImGui.Text('%s', char.Name)
							gearOrder.dragSource(char.Name, true)
							if isMe then
								if ImGui.BeginTable('Spells', 2, bit32.bor(ImGuiTableFlags.BordersInner, ImGuiTableFlags.RowBg, ImGuiTableFlags.NoSavedSettings, ImGuiTableFlags.ScrollY), cardWidth, SPELL_TABLE_HEIGHT) then
									ImGui.TableSetupScrollFreeze(0, 1)
									ImGui.TableSetupColumn('Name', bit32.bor(ImGuiTableColumnFlags.WidthStretch), 6, 2)
									ImGui.TableSetupColumn('Location', bit32.bor(ImGuiTableColumnFlags.WidthStretch), 5, 3)
									ImGui.TableHeadersRow()

									for _,level in ipairs({71,70,69,68,67,66}) do
										ImGui.TableNextRow()
										ImGui.TableNextColumn()
										if ImGui.TreeNodeEx(level..'##'..mq.TLO.Me.CleanName(), bit32.bor(ImGuiTreeNodeFlags.SpanFullWidth, ImGuiTreeNodeFlags.DefaultOpen)) then
											local levelSpells = spellConfig[mq.TLO.Me.Class()][level]
											for _,spellName in ipairs(levelSpells) do
												local spellDetails = splitToTable(spellName, '|')
												spellName = spellDetails[1]
												local spellLocation = spellDetails[2]
												spellData[spellName] = spellData[spellName] or mq.TLO.Me.Book(spellName)() or mq.TLO.Me.CombatAbility(spellName)() or 0
												if not hideOwnedSpells or spellData[spellName] == 0 then
													ImGui.TableNextRow()
													ImGui.TableNextColumn()
													ImGui.TextColored(spellData[spellName] == 0 and 1 or 0, spellData[spellName] ~= 0 and 1 or 0, 0, 1, '%s', spellName)
													ImGui.TableNextColumn()
													ImGui.Text('%s', spellLocation)
													if ImGui.IsItemHovered() then ImGui.SetTooltip('%s', spellLocation) end
												end
											end
											ImGui.TreePop()
										end
									end
									ImGui.EndTable()
								end
							else
								if ImGui.BeginTable('Spells'..char.Name, 2, bit32.bor(ImGuiTableFlags.BordersInner, ImGuiTableFlags.RowBg, ImGuiTableFlags.NoSavedSettings, ImGuiTableFlags.ScrollY), cardWidth, SPELL_TABLE_HEIGHT) then
									ImGui.TableSetupScrollFreeze(0, 1)
									ImGui.TableSetupColumn('Name', bit32.bor(ImGuiTableColumnFlags.WidthStretch), 6, 2)
									ImGui.TableSetupColumn('Location', bit32.bor(ImGuiTableColumnFlags.WidthStretch), 5, 3)
									ImGui.TableHeadersRow()

									for _,level in ipairs({71,70,69,68,67,66}) do
										local hasMissing = false
										for _,entry in ipairs(data) do
											if tonumber(entry[1]) == level and (not hideOwnedSpells or not entry[4]) then
												hasMissing = true break
											end
										end
										if hasMissing then
										ImGui.TableNextRow()
										ImGui.TableNextColumn()
										if ImGui.TreeNodeEx(level..'##'..char.Name, bit32.bor(ImGuiTreeNodeFlags.SpanFullWidth, ImGuiTreeNodeFlags.DefaultOpen)) then
											for _,entry in ipairs(data) do
												if tonumber(entry[1]) == level and (not hideOwnedSpells or not entry[4]) then
													ImGui.TableNextRow()
													ImGui.TableNextColumn()
													ImGui.TextColored(entry[4] and 0.45 or 1, entry[4] and 0.90 or 0, entry[4] and 0.62 or 0, 1, '%s', entry[2])
													ImGui.TableNextColumn()
													ImGui.Text('%s', entry[3])
													if ImGui.IsItemHovered() then ImGui.SetTooltip('%s', entry[3]) end
												end
											end
											ImGui.TreePop()
										end
										end
									end
									ImGui.EndTable()
								end
							end
							ImGui.EndGroup()
							gearOrder.dropTarget(char.Name)
						end
					end
					ImGui.EndChild()
					ImGui.EndTabItem()
				end
				if ImGui.BeginTabItem('Lockouts') then
					if lockouts.draw(currentTab ~= 'Lockouts') then selectionChanged = true end
					currentTab = 'Lockouts'
					ImGui.EndTabItem()
				end
				for _,infoTab in ipairs(bisConfig.Info) do
					if ImGui.BeginTabItem(infoTab.Name) then
						currentTab = infoTab.Name
						ImGui.Text(infoTab.Text)
						ImGui.EndTabItem()
					end
				end
				if ImGui.BeginTabItem('Links') then
					currentTab = 'Links'
					for _,link in ipairs(bisConfig.Links) do
						DrawTextLink(link.label, link.url)
					end
					ImGui.EndTabItem()
				end
				ImGui.EndTabBar()
			end
			ImGui.PopStyleVar()
		end
	end
	ImGui.End()
	if not openGUI and not minimizedGUI then
		mail.handOff()
		mq.exit()
	end
end

local function bisGUI()
	local themeState = lazbisTheme.push()
	bisGUIContent()
	lazbisTheme.pop(themeState)
end

local function resolveGroupId()
	return grouponly and mq.TLO.Group.Leader() or nil
end

local function searchAll(refreshEveryTab)
	if refreshEveryTab then autoRefreshQueue = {} end
	local function request(name, content)
		if refreshEveryTab then
			autoRefreshQueue[#autoRefreshQueue + 1] = {name=name, content=content}
		else
			content.group = resolveGroupId()
			mail.send(name, content)
		end
	end
	if currentTab == 'Gear' or firstTimeLoad or refreshEveryTab then
		raidTiers.queue = {}
		if raidTiers.level[selectedItemList.id] then
			-- Check the highest tier first, so DoN completion appears early.
			for _, list in ipairs({'don', 'dsk'}) do
				if raidTiers.level[list] > raidTiers.level[selectedItemList.id] then
					for _, char in ipairs(group) do
						if not char.Offline then
							if refreshEveryTab then
								request(char.Name, {id='search', list=list, tierOnly=true})
							else
								raidTiers.queue[#raidTiers.queue + 1] = {name=char.Name, list=list}
							end
						end
					end
				end
			end
		end
		for _, char in ipairs(group) do
			if not char.Offline then
				request(char.Name, {id='search', list=selectedItemList.id})
				if selectedItemList.id == 'questitems' or firstTimeLoad or refreshEveryTab then request(char.Name, {id='tsquery'}) end
			end
		end
	end
	if currentTab == 'Empties' or firstTimeLoad or refreshEveryTab then
		for _, char in ipairs(group) do
			if not char.Offline then request(char.Name, {id='searchempties'}) end
		end
	end
    if currentTab == 'Type 12 Foci' or firstTimeLoad or refreshEveryTab then
        type12Gear[mq.TLO.Me.CleanName()] = searchType12Foci()
        type12ScanQueue = {}
        for _, char in ipairs(group) do
            if not char.Offline and char.Name ~= mq.TLO.Me.CleanName() then
                if refreshEveryTab then
                    request(char.Name, {id='search', list='type12'})
                else
                    type12ScanQueue[#type12ScanQueue + 1] = char.Name
                end
            end
        end
    end
	if currentTab == 'Spells' or firstTimeLoad or refreshEveryTab then
		for _, char in ipairs(group) do
			if not char.Offline then request(char.Name, {id='searchspells'}) end
		end
	end
	if currentTab == 'Lockouts' or firstTimeLoad or refreshEveryTab then
		-- 'force' (the Refresh button) runs /tasktime on every character; 'auto' only where it hasn't run yet.
		local tasktime = nil
		if currentTab == 'Lockouts' and not refreshEveryTab then
			tasktime = lockouts.forceTasktime and 'force' or 'auto'
		end
		lockouts.forceTasktime = false
		for _, char in ipairs(group) do
			if not char.Offline then request(char.Name, {id='dzquery', from=mq.TLO.Me.CleanName(), tasktime=tasktime}) end
		end
	end
end

local function doPing()
	for _,char in ipairs(group) do
		if not char.Offline then mail.send(char.Name, {id='pingreq', group=resolveGroupId()}) end
	end
end

local LINK_TYPES = nil
if mq.LinkTypes then
	LINK_TYPES = {
		[mq.LinkTypes.Item] = 'Item',
		[mq.LinkTypes.Player] = 'Player',
		[mq.LinkTypes.Spam] = 'Spam',
		[mq.LinkTypes.Achievement] = 'Achievement',
		[mq.LinkTypes.Dialog] = 'Dialog',
		[mq.LinkTypes.Command] = 'Command',
		[mq.LinkTypes.Spell] = 'Spell',
		[mq.LinkTypes.Faction] = 'Faction',
	}
end
-- Type 12 foci aren't in the BiS lists, so linked foci are checked here.
local type12Announce = {}

type12Announce.names = function()
	if type12Announce.lookup then return type12Announce.lookup end
	local lookup = {}
	for _, entry in ipairs(donFocusReference) do
		local focus
		for _, name in ipairs(entry.names or {}) do
			if name:match('^Cryptic Clutch of ') then focus = name:gsub('^Cryptic Clutch of ', '') break end
		end
		if focus then
			for part in tostring(entry.item or ''):gmatch('[^/]+') do
				if not tonumber(part) then lookup[part:lower()] = {name = part, focus = focus} end
			end
			for _, name in ipairs(entry.names or {}) do lookup[name:lower()] = {name = name, focus = focus} end
		end
	end
	local function addHex(entry)
		if entry and entry.name then lookup[entry.name:lower()] = {name = entry.name, focus = entry.focus, hex = true} end
	end
	for _, entry in ipairs(dskHexFocus.shared) do addHex(entry) end
	for _, entry in pairs(dskHexFocus.byClass) do addHex(entry) end
	type12Announce.lookup = lookup
	return lookup
end

-- nil until the character is scanned. Owning either finished form (Cryptic Clutch or Hex) covers the focus.
-- The Type 12 tab's foci apply to every class; the class-gated Prowess augs keep the class lists.
type12Announce.needs = function(char, hit)
	local scan = type12Gear[char.Name]
	if not scan then return nil end
	local focus = hit.focus
	for _, row in ipairs(type12Matrix.rows) do
		if row.source == focus then
			local cell = type12Matrix.cell(char, row)
			if cell.text == '...' then return nil end
			return cell.text == '-'
		end
	end
	local applies, have = false, false
	for slot, name in pairs(bisConfig.type12[char.Class] or {}) do
		if (name:gsub('^Cryptic Clutch of ', '')) == focus then
			if not hit.hex then applies = true end
			if scan[slot] and scan[slot].status ~= 'missing' then have = true end
		end
	end
	local function checkHex(entry)
		if entry and entry.focus == focus then
			if hit.hex and entry.name == hit.name then applies = true end
			local hex = scan.dskHex and scan.dskHex[entry.name]
			if type(hex) == 'string' then hex = {status = hex} end
			if hex and hex.status ~= 'missing' then have = true end
		end
	end
	for _, entry in ipairs(dskHexFocus.shared) do checkHex(entry) end
	checkHex(dskHexFocus.byClass[char.Class])
	return applies and not have
end

type12Announce.check = function(line, itemLinks, messages)
	local lookup = type12Announce.names()
	local linked = {}
	if next(itemLinks) then
		for name in pairs(itemLinks) do
			local hit = lookup[name:lower()]
			if hit then linked[#linked + 1] = hit end
		end
	else
		local lower, byFocus = line:lower(), {}
		for key, hit in pairs(lookup) do
			if lower:find(key, 1, true) and (not byFocus[hit.focus] or #hit.name > #byFocus[hit.focus].name) then
				byFocus[hit.focus] = hit
			end
		end
		for _, hit in pairs(byFocus) do linked[#linked + 1] = hit end
	end
	if #linked == 0 then return end
	local me, queued = mq.TLO.Me.CleanName(), {}
	for _, name in ipairs(sortedGroup) do
		local char = group[name]
		if char.Show and not type12Gear[char.Name] then
			if char.Name == me then
				type12Gear[me] = searchType12Foci()
			elseif not char.Offline and not queued[char.Name] then
				queued[char.Name] = true
				type12ScanQueue[#type12ScanQueue + 1] = char.Name
			end
		end
	end
	for _, hit in ipairs(linked) do
		for _, name in ipairs(sortedGroup) do
			local char = group[name]
			if char.Show then
				local needs = type12Announce.needs(char, hit)
				if needs ~= nil then
					itemChecks[hit.name] = itemChecks[hit.name] or {}
					itemChecks[hit.name][char.Name] = not needs
				end
				if needs then
					messages[hit.name] = messages[hit.name] or ((itemLinks[hit.name] or hit.name) .. ' - ')
					messages[hit.name] = messages[hit.name] .. char.Name .. ', '
				end
			end
		end
	end
end

local recentlyAnnounced = {}
local function sayCallback(line)
	local itemLinks = {}
	local foundAnyLinks = false
	if mq.ExtractLinks then
		local links = mq.ExtractLinks(line)
		for _,link in ipairs(links) do
			if link.type == mq.LinkTypes.Item then
				local item = mq.ParseItemLink(link.link)
				itemLinks[item.itemName] = link.link
				foundAnyLinks = true
			end
		end
	end
	if itemList == nil or group == nil or gear == nil or (mq.LinkTypes and not foundAnyLinks) then
		return
	end
	if string.find(line, 'Burns') then
		return
	end
	local currentZone = mq.TLO.Zone.ShortName()
	-- currentZone = 'anguish'
	local currentZoneList = bisConfig.ZoneMap[currentZone] and bisConfig.ItemLists[bisConfig.ZoneMap[currentZone].group][bisConfig.ZoneMap[currentZone].index]
	local scanLists = currentZoneList and {currentZoneList} or bisConfig.ItemLists['Raid Best In Slot']

	local messages, named = {}, {}
	for _,list in ipairs(scanLists) do
		for _, name in ipairs(sortedGroup) do
			local char = group[name]
			if char.Show then
				local classItems = bisConfig[list.id][char.Class]
				local templateItems = bisConfig[list.id].Template
				local visibleItems = bisConfig[list.id].Visible
				for _,itembucket in ipairs({classItems,templateItems,visibleItems}) do
					for slot,item in pairs(itembucket) do
						-- A class's own row replaces the template row for the same slot.
						if item and not (itembucket == templateItems and classItems and classItems[slot]) then
							for itemName in split(item, '/') do
								if string.find(line, itemName:gsub('-','%%-')) then
									local hasItem = gear[char.Name][slot] ~= nil and (gear[char.Name][slot].count > 0 or (gear[char.Name][slot].componentcount or 0) > 0)
									if not hasItem and list.id ~= selectedItemList.id then
										loadSingleRow(list.id, char.Name, itemName)
										if foundItem and (foundItem.Count > 0 or (foundItem.ComponentCount or 0) > 0) then hasItem = true end
										foundItem = nil
									end
									-- A higher raid tier's item completes the row, as on the Gear tab.
									if not hasItem and higherRaidTier(char, slot, list.id) then hasItem = true end
									itemChecks[itemName] = itemChecks[itemName] or {}
									itemChecks[itemName][char.Name] = hasItem
									if debug then printf('list.id=%s slot=%s item=%s hasItem=%s', list.id, slot, item, hasItem) end
									if not hasItem and not named[itemName .. '|' .. char.Name] then
										named[itemName .. '|' .. char.Name] = true
										if not messages[itemName] then
											if itemLinks[itemName] then messages[itemName] = itemLinks[itemName] .. ' - ' else messages[itemName] = itemName .. ' - ' end
										end
										messages[itemName] = messages[itemName] .. char.Name .. ', '
									end
								end
							end
						end
					end
				end
			end
		end
	end
	type12Announce.check(line, itemLinks, messages)
	if settings.AnnounceNeeds then
		for itemName,msg in pairs(messages) do
			if not recentlyAnnounced[itemName] or mq.gettime() - recentlyAnnounced[itemName] > 30000 then
				local prefix = getAnnounceChannel()
				mq.cmdf('%s%s', prefix, msg)
				recentlyAnnounced[itemName] = mq.gettime()
			end
		end
	end
end

local function lootedCallback(line, who, item)
	if who == 'You' then who = mq.TLO.Me.CleanName() end
	if not group[who] then return end
	local char = group[who]
	local currentZone = mq.TLO.Zone.ShortName()
	local listToScan = bisConfig.ZoneMap[currentZone] and bisConfig.ItemLists[bisConfig.ZoneMap[currentZone].group][bisConfig.ZoneMap[currentZone].index]
	if not listToScan then return end

	local classItems = bisConfig[listToScan.id][char.Class]
	local templateItems = bisConfig[listToScan.id].Template
	local visibleItems = bisConfig[listToScan.id].Visible
	for _,itembucket in ipairs({classItems,templateItems,visibleItems}) do
		for slot,itemLine in pairs(itembucket) do
			for itemName in split(itemLine, '/') do
				if itemName == item then
					if listToScan.id == selectedItemList.id then
						gear[char.Name][slot] = gear[char.Name][slot] or {count=0, componentcount=0, actualname=item}
						if visibleItems and visibleItems[slot] == item then
							gear[char.Name][slot].componentcount = (gear[char.Name][slot].componentcount or 0) + 1
						else
							gear[char.Name][slot].count = (gear[char.Name][slot].count or 0) + 1
						end
					end
					local stmt = dbfmt:format(char.Name,char.Class,server,slot:gsub('\'','\'\''),item:gsub('\'','\'\''),'',gear[char.Name] and gear[char.Name][slot].count or 0,gear[char.Name] and gear[char.Name][slot].componentcount or 0,listToScan.id)
					exec(stmt, char.Name, listToScan.id, 'inserted')
				end
			end
		end
	end
end

local function writeAllItemLists()
	local name = mq.TLO.Me.CleanName()
	addCharacter(name, mq.TLO.Me.Class.Name(), false, true)
	local insertStmt = ''
	for _,group in ipairs(bisConfig.Groups) do
		for _,list in ipairs(bisConfig.ItemLists[group]) do
			itemList = bisConfig[list.id]
			gear[name] = searchItemsInList(list.id)
			insertStmt = insertStmt .. buildInsertStmt(name, list.id)
		end
		clearAllDataForCharacter(name)
		exec(insertStmt, name, nil, 'inserted')
	end
	-- clear spell data
	clearSpellDataForCharacter(name)
	-- insert spell data
	dumpSpells(name, loadMissingSpells())
	-- clear tradeskill data
	clearTradeskillDataForCharacter(name)
	-- insert tradeskill data
	dumpTradeskills(mq.TLO.Me.CleanName(), loadTradeskills())
end

local function zonedCallback()
	local zone = mq.TLO.Zone.ShortName()
	-- Load item list for specific zone if inside raid instance for that zone
	if bisConfig.ZoneMap[zone] then
		local newItemList = bisConfig.ItemLists[bisConfig.ZoneMap[zone].group][bisConfig.ZoneMap[zone].index]
		if newItemList.id ~= selectedItemList.id then
			selectedItemList = newItemList
			itemList = bisConfig[selectedItemList.id]
			selectionChanged = true
			filter = ''
			printf('Switched BIS list to %s', zone)
		end
	end
end

local function bisCommand(...)
	local args = {...}
	if args[1] == 'missing' then
		local missingSpellsText = {}
		local classSpells = spellConfig[mq.TLO.Me.Class()]
		for _,level in ipairs({71,70,69,68,67,66}) do
			local levelSpells = classSpells[level]
			for _,spellName in ipairs(levelSpells) do
				if spellData[spellName] == 0 then
					table.insert(missingSpellsText, ('- %s: %s'):format(level, spellName))
				end
			end
		end
		printf('Missing Spells:\n%s', table.concat(missingSpellsText, '\n'))
	elseif args[1] == 'lockouts' then
		lockouts.report(args[2])
	end
end

local function resolveArgs(args)
	printf('\ag%s\ax started with \ay%d\ax arguments:', meta.name, #args)
	for i, arg in ipairs(args) do
		printf('args[%d]: %s', i, arg)
	end
	for _,arg in ipairs(args) do
		if argopts[arg] then
			argopts[arg]()
		end
	end
	if not isBackground then
		initDB()
	else
		openGUI = false
	end
	if dumpInv then
		writeAllItemLists()
		mq.exit()
	end
	if isBackground then openGUI = false end
end

local function init(args)
	resolveArgs(args)

	mail.runArgs = (resolveGroupId() and ' group' or '') .. (debug and ' debug' or '')
	if not isBackground then
		mq.cmdf('/squelch /lua stop %s/bg', meta.name)
		mq.delay(250)
	end
	local named, box = pcall(actors.register, mail.box, actorCallback)
	if named and box then
		actor, mail.named = box, true
	else
		printf('\arlazbis\ax: could not register the %s mailbox (%s); other characters may not see this one.', mail.box, tostring(box))
		actor = actors.register(actorCallback)
	end
	mq.event('lazbisReplayTimer', '#*#replay timer#*#', function(line) lockouts.ingestReplay(line) end)
	if isBackground then
		mq.delay(100)
		mail.broadcast({id='hello',Name=mq.TLO.Me(),Class=mq.TLO.Me.Class.Name(),group=resolveGroupId()})
		mail.windowSeen = mq.gettime()
		while true do
			mq.delay(1000)
			lockouts.tick()
			mq.doevents()
			-- Windows ping every 25 seconds; with none heard for 90, no window is open, so stop.
			if mq.gettime() - mail.windowSeen > 90000 then
				printf('\aglazbis\ax: no lazbis window has been heard from for 90 seconds, stopping the background helper.')
				mq.exit()
			end
		end
	end

	local zone = mq.TLO.Zone.ShortName()
	-- Load item list for specific zone if inside raid instance for that zone
	if bisConfig.ZoneMap[zone] then
		selectedItemList = bisConfig.ItemLists[bisConfig.ZoneMap[zone].group][bisConfig.ZoneMap[zone].index]
		itemList = bisConfig[selectedItemList.id]
	else
		-- Otherwise load the last list we were looking at
		if settings['SelectedList'] then
			for _, group in ipairs(bisConfig.Groups) do
				for _, list in ipairs(bisConfig.ItemLists[group]) do
					if list.id == settings['SelectedList'] then
						selectedItemList = list
						break
					end
				end
			end
		end
	end

	for name,ingredient in pairs(bisConfig.StatFoodIngredients) do
		table.insert(ingredientsArray, {Name=name, Location=ingredient.Location})
	end
	table.sort(ingredientsArray, function(a,b) return a.Name < b.Name end)

	addCharacter(mq.TLO.Me.CleanName(), mq.TLO.Me.Class.Name(), false, true)

	mq.cmdf('%s /lua stop %s/bg', broadcast, meta.name)
	mq.delay(500)
	mq.cmdf('%s /lua run %s/bg%s%s', broadcast, meta.name, resolveGroupId() and ' group' or '', debug and ' debug' or '')
	mq.delay(500)

	mq.event('meSayItems', 'You say, #*#', sayCallback, {keepLinks = true})
	mq.event('sayItems', '#*# says, #*#', sayCallback, {keepLinks = true})
	mq.event('rsayItems', '#*# tells the raid, #*#', sayCallback, {keepLinks = true})
	mq.event('rMeSayItems', 'You tell your raid, #*#', sayCallback, {keepLinks = true})
	mq.event('gsayItems', '#*# tells the group, #*#', sayCallback, {keepLinks = true})
	mq.event('gMeSayItems', 'You tell your party, #*#', sayCallback, {keepLinks = true})
	mq.event('zoned', 'You have entered #*#', zonedCallback)
	-- loot callback doesn't work right, just disable them for now
	-- mq.event('otherLootedItem', '#*#--#1# has looted a #2#.--#*#', lootedCallback, {keepLinks = true})
	-- mq.event('youLootedItem', '#*#--#1# have looted a #2#.--#*#', lootedCallback, {keepLinks = true})

	mq.imgui.init('BISCheck', bisGUI)

	mq.bind('/bis', bisCommand)
end

init({...})
local lastPingTime = mq.gettime() + 15000
local lastAutoRefreshTime = mq.gettime()
while openGUI do
	mq.delay(1000)
	if rebroadcast then
		gear = {}
		autoRefreshQueue = {}
		raidTiers.cache = {}
		raidTiers.queue = {}
		itemChecks = {}
		tradeskills = {}
		for _,c in ipairs(group) do if c.Name ~= mq.TLO.Me.CleanName() then c.Offline = true printf('set %s offline', c.Name) end end

		mq.delay(500)
		mq.cmdf('%s /lua run %s/bg%s%s', broadcast, meta.name, resolveGroupId() and ' group' or '', debug and ' debug' or '')
		mq.delay(500)
		selectionChanged = true
		rebroadcast = false
	end
	if selectionChanged then
		selectionChanged = false
		searchAll()
		if currentTab == 'Gear' or firstTimeLoad then
			loadInv(selectedItemList.id)
			loadOfflineRaidTiers()
		end
		if (currentTab == 'Gear' and selectedItemList.id == 'questitems') or firstTimeLoad then loadTradeskillsFromDB() end
		if currentTab == 'Spells' or firstTimeLoad then loadSpellsFromDB() end
		if firstTimeLoad then firstTimeLoad = false end
	end
	local now = mq.gettime()
	if now - lastAutoRefreshTime >= 300000 then
		lastAutoRefreshTime = now
		searchAll(true)
		loadInv(selectedItemList.id)
		loadOfflineRaidTiers()
		loadTradeskillsFromDB()
		loadSpellsFromDB()
	end
    -- Spread peer inventory scans over several ticks to keep ImGui responsive.
    for _ = 1, 2 do
        local name = table.remove(type12ScanQueue, 1)
        if not name then break end
        mail.send(name, {id='search', list='type12', group=resolveGroupId()})
    end
	local tierPeersThisTick = {}
	for _ = 1, math.min(#raidTiers.queue, 4) do
		local tierRequest = table.remove(raidTiers.queue, 1)
		if tierPeersThisTick[tierRequest.name] then
			raidTiers.queue[#raidTiers.queue + 1] = tierRequest
		else
			tierPeersThisTick[tierRequest.name] = true
			mail.send(tierRequest.name, {id='search', list=tierRequest.list,
				tierOnly=true, group=resolveGroupId()})
		end
	end
	-- Automatic refresh performs the same tab queries in small batches.
	local autoPeersThisTick = {}
	for _ = 1, math.min(#autoRefreshQueue, 4) do
		local request = table.remove(autoRefreshQueue, 1)
		if autoPeersThisTick[request.name] or tierPeersThisTick[request.name] then
			autoRefreshQueue[#autoRefreshQueue + 1] = request
		else
			autoPeersThisTick[request.name] = true
			request.content.group = resolveGroupId()
			mail.send(request.name, request.content)
		end
	end
	for itemName,lastAnnounced in pairs(recentlyAnnounced) do
		if mq.gettime() - lastAnnounced > 30000 then
			recentlyAnnounced[itemName] = nil
		end
	end
	local curTime = mq.gettime()
	if curTime - lastPingTime > 25000 then
		if debug then printf('send ping') end
		doPing()
		group[mq.TLO.Me.CleanName()].PingTime = curTime
		lastPingTime = curTime
	end
	for _,char in ipairs(group) do
		if curTime - char.PingTime > 90000 then
			if debug then printf('char hasnt responded %s %s %s', char.Name, curTime, char.PingTime) end
			char.Offline = true
		end
	end
	mail.tick()
	lockouts.tick()
	mq.doevents()
end
mail.handOff()
