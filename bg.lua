-- lazbis background helper: answers the lazbis window on other characters.
-- It runs as its own script (/lua run lazbis/bg) so /lua run lazbis can still open the window here.
local mq = require('mq')

local function running(name)
	local found = false
	pcall(function()
		for pid in tostring(mq.TLO.Lua.PIDs() or ''):gmatch('%d+') do
			local script = mq.TLO.Lua.Script(tonumber(pid))
			if tostring(script.Name() or ''):lower() == name and tostring(script.Status() or ''):upper() == 'RUNNING' then
				found = true
			end
		end
	end)
	return found
end

if running('lazbis') then
	print('\aglazbis\ax: the lazbis window is open on this character, so the background helper is not needed.')
	return
end

-- lazbis works out its own name from a backslash path, so keep this one in backslashes.
local src = (debug.getinfo(1, 'S').source or ''):gsub('^@', '')
local base = src:gsub('[/\\][^/\\]*$', ''):gsub('/', '\\') .. '\\'
package.path = base .. '?.lua;' .. package.path

local chunk, err = loadfile(base .. 'init.lua')
if not chunk then error('[lazbis/bg] could not load lazbis/init.lua: ' .. tostring(err)) end
chunk('0', ...)
