--# selene: allow(unused_variable)
---@diagnostic disable: unused-local

-- Display Keybindings registered with bindHotkeys() and Spoons
--
-- Spoons need to set the mapping in obj
--
-- Originally based on KSheet.spoon by ashfinal <ashfinal@gmail.com>
--
-- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/HSKeybindings.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/HSKeybindings.spoon.zip)
---@class spoon.HSKeybindings
local M = {}
spoon.HSKeybindings = M

-- Hide the cheatsheet webview
-- 
function M:hide() end

-- Show current application's keybindings in a webview
-- 
function M:show() end

