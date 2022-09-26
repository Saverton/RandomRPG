# PROJECT TITLE : Random RPG

# PROJECT DESCRIPTION : 
  This application is a top-down RPG game that can be played through the LOVE2D engine. The game is played similar to the original Legend of Zelda (1986) (https://en.wikipedia.org/wiki/The_Legend_of_Zelda_(video_game)). Once a "world" has been created, the player is free to roam around the overworld, fighting monsters, hunting treasure, completing basic quests, and visiting shops. Eventually, players will stumble upon dungeons which, when entered, transport the player to a new "underworld" composed by a randomly generated labyrinth of rooms that contain enemies, treasure, or both! As of now, there is no ultimate objective in the game that is recognized in the code. There are three dungeons that generate currently (in random locations), each with their own difficulty. completing all three dungeons would be considered "beating" the game in its current state. In it's current testing phase, running the game will cause an immediate loading of a world in debug mode, which allows for some shortcut controls for feature testing. pressing the 'r' key in debug mode will generate and load a new world instantly in debug mode. pressing the 'm' key in debug mode will automatically increase the player's money count by 10. pressing the 'b' key in debug mode will give the player some stronger items to help against tougher foes or test inventory management.
  # BROAD FEATURE LIST
    - Randomly generated overworld map
    - Enemies that spawn according to the rules of the current 'level' or 'map'
    - A combat system with attack types, stat boosts, a knockback system, a leveling system, and a loot system
    - an inventory system that allows for reordering or deletion of items
    - npc characters that will give tips to the player, hold a shop, or offer a quest
    - the ability to save a game and reload it from the title screen
    - ability to transfer a player between multiple maps
    - randomly generated dungeons with key-door system, a start room, and an end/treasure room
    - custom (wip) soundtrack
  # FUTURE CONTENT LIST
    - More enemies, biomes, map features, items, etc.
    - More dungeon styles
    - Improved soundtrack
    - Underground region similar to overworld, but generated differently
    - Visual polish in the dungeon (adding door frames, stencils, better camera boundaries)
    - game completion state / objective
    
# HOW TO RUN : 
  Download the Love2d engine (https://love2d.org/) and find the folder that contains the application 'love.exe'. Using a command line interface or by dragging the project file onto the 'love.exe' application, run the project folder in 'love.exe'. This should start the game automatically in debug mode, which is further detailed in the 'PROJECT DESCRIPTION' section.

# HOW TO USE : 
  Run the application as described above. Normal game controls are as follows:
  # CONTROLS
    - 'w'/'up arrow' = move up OR navigate up in menu
    - 'a'/'left arrow' = move left
    - 's'/'down arrow' = move down OR navigate down in menu
    - 'd'/'right arrow' = move right
    - 'spacebar' = use item OR interact with NPC OR interact with map element (i.e. chest)
    - 'spacebar'/'enter'/'return' = select menu item OR proceed in dialogue
    - 'escape' = exit application (in start menu only!) OR pause game OR exit current menu
    
# CREDITS 
  - Implements built-in libraries from Love2d engine (https://love2d.org/)
  - OOP class library (https://github.com/vrld/hump)
  - 'push' library that resizes content to fit a window of a different scale than the scale used in game (https://github.com/Ulydev/push)
  - the knife timer management library (https://github.com/airstruck/knife)
  - a few classes written by Colton Ogden in his GD50 projects (https://cs50.harvard.edu/games/2018/)
  - music written by Tyler Tebo
  
# HOW TO CONTRIBUTE
  - Download and play if you feel like; send any error messages/bugs you find to me
  - suggest features to be added

# LICENSE
MIT License

Copyright (c) 2022 Scott Meadows

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
