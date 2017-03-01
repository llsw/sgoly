local skynet = require "skynet"
local CMD = {}
local reload = require "testReload"

function CMD.TEST() 
    reload.test()
    for k, v in pairs(_ENV) do
		print(k, v)
	end
    return "TEST"
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local f = assert(CMD[cmd], cmd .. "not found")
        skynet.retpack(f(...))
    end)
    -- skynet.register(".test")
end)