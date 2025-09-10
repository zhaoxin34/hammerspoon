--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Show a popup window with the currently selected word in lexicon, notes, online help
--
-- The spoon uses hs.urlevent.openURL("dict://" .. text)
--
-- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/LookupSelection.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/LookupSelection.spoon.zip)
---@class spoon.LookupSelection
local M = {}
spoon.LookupSelection = M

-- Binds hotkeys for LookupSelection
--
-- Parameters:
--  * mapping - A table containing hotkey modifier/key details for the following items:
--   * `lexicon` - open in lexicon app
--   * `neue_notiz` -  create new note in notes app
--   * `hsdocs` -  display online help
--
-- Sample value for `mapping`:
-- ```
--  {
--     lexicon = { { "ctrl", "alt", "cmd" }, "L" },
--     neue_notiz = { { "ctrl", "alt", "cmd" }, "N" },
--     hsdocs = { { "ctrl", "alt", "cmd" }, "H" },
--  }
-- ```
function M:bindHotkeys(mapping, ...) end

-- Logger object used within the Spoon. Can be accessed to set the default log level for the messages coming from the Spoon.
M.logger = nil

-- Get the current selected text in the frontmost window and display a translation popup with the translation between the specified languages
--
-- Returns:
--  * The LookupSelection object
function M:openLexicon() end

