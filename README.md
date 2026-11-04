# LazBis — Project Lazarus Edition
Gotta collect em all

## Credits
Version 1.0 updated by Primal (Realist), inspired by TurboGear by Drel.
Built on lazarus_bis by aquietone, with additions from Kroaking's WanteD fork.
Initial Anguish and DSK standalone scripts provided by Dlilah and ... from Verticordious.
Other lists provided by aquietone, Dlilah and ...

## Installation

You can install the script by doing either:
a. Clone the repository to your MacroQuest lua folder, or
b. Download the ZIP file and unzip it to your MacroQuest lua folder

Once installed, you should have:
```
macroquest/
  lua/
    lazbis/
      init.lua
      bis.lua
      bg.lua
      spells.lua
```

The first time the script is run, it will prompt to install the lsqlite3 LuaRock dependency from the MacroQuest LuaRocks server. This is needed to support the offline data.

### Updating from an older version
1. Replace your whole `lazbis` folder.
2. If you have them, delete `turbo_theme.lua`, `don_spell_catalog.lua`, `dsk_hex_focus.lua` and `dsk_type12_focus.lua`. They are now built into `init.lua`.
3. Stop old copies on every character: `/e3bcaa /lua stop lazbis`
4. Start it again on your main character: `/lua run lazbis`

## Usage

Run the script with `/lua run lazbis`. It starts a background helper (`lazbis/bg`) on your other characters, and you can open the window on any character, or on several at once.

Start-up options:
- `/lua run lazbis group` limits everything to your group, keyed off the group leader, so several groups can each run their own window.
- `/lua run lazbis debug` prints message traffic to the MacroQuest console, for troubleshooting.
- `/lua run lazbis dumpinv` saves this character's inventory to the database and exits.

Commands:
- `/bis lockouts` prints your characters' lockouts.
- `/bis missing` prints this character's missing spells.

You can add a startup command to `ingame.cfg` to have the script update the database whenever a character logs in, to keep offline data mostly accurate.
In your `mq/config/ingame.cfg` (create one if it doesn't exist) add:
```
/docommand /timed ${Math.Random[10,100]} /lua run lazbis dumpinv
```
The `/timed ${Math.Random[10,100]}` is just to help avoid database conflicts from multiple toons logging in. The script should retry as well anyways.

## Overview
Lazarus BIS provides a live item tracker for all of your logged in characters.
It also writes the data to a local sqlite3 db to support showing offline characters as well.

### Features

- Track who has what items across all currently logged in characters for Anguish, DSK, Dragons of Norrath, FUKU, HC zones, Hand aug, Nightveil, Pre-Anguish, Quest items, Sebilis, Fungal augs, Veksar and Vendor items.
- Track who has what items across offline characters who have run the script at some point in time.
- Tiered raid lists: Anguish (Tier 1), DSK (Tier 2) and Dragons of Norrath (Tier 3). A higher-tier item marks the lower-tier row complete.
- Upgrade chains: a later epic completes the earlier epic rows (1.5, 2.0, 2.5, 2.75), and DoN Icons / DSK Codexes complete the FUKU and DSK clicky rows.
- Dragons of Norrath extras: Epic group (Scales of the Lava Dragon and the 2.75), a Reward row with each class's finished legendary item, and Avarice charms counting for Duality of Desire.
- Type 12 Foci tab: a table of 18 focus effects by character showing DoN (Cryptic Clutch), DSK (Hideous Hex) or missing, plus a searchable list of the Anguish gear behind each DSK focus.
- Spells tab with missing spells per character, including DoN spells and tomes.
- Lockouts tab with live countdown timers, custom lockouts, and DoN raids, missions and progression read from replay timers.
- Drag a character's column header (or tile) to reorder characters. The order is saved and shared between tabs.
- Columns fit the window. Long names are cut with "..." (hover for the full text) and the Item column stays pinned.
- Shows who needs an item if the item is linked in chat, including Type 12 foci.
- Announce who needs an item into chat when an item is linked in chat. Characters covered by a higher-tier item or upgrade chain aren't named.
- Filter what rows are displayed using the search bar. You can search by any item name text in the table such as "infused flux".
- Show what slots each character has items in. Uncheck the box "Show slots" to hide slot information.
- Only show items which characters are missing. Check the box "Show Missing Only" to filter out items you already have.
- Show all characters or only grouped characters. In case you have extra characters logged in like buffers which you don't want to track, you can show only grouped characters from the dropdown menu.
- Tooltips when hovering over items if the item is showing green because of some other item.
- Full stat food, quest and recipe info for the stat food quest on Project Lazarus.

### How it works

When you start the script on a character, it broadcasts to the rest of your characters to start the background helper (`/lua run lazbis/bg`).
It uses `/e3bca` by default as long as you have the `mq2mono` plugin (E3Next users). Otherwise it uses `/dge` from MQ2DanNet.
The window and the helpers talk through MacroQuest's built-in actor messaging on a shared `lazbis_mail` mailbox, so characters on another computer (for example over E3 proxy) can report in too. If a character doesn't answer a direct message, lazbis switches it to the shared mailbox automatically.
Characters send updated info when the script starts, whenever you click the `refresh` button or when you switch what list you are viewing.
Closing the window restarts that character's helper, and helpers stop on their own about 90 seconds after the last lazbis window is closed.

The character which initially started the script will persist all information which it receives from your bots into a local database for querying offline characters later.

![](./images/need.png)
![](./images/sebilis.png)
![](./images/veksar.png)
![](./images/dsk.png)
