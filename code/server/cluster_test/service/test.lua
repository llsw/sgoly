local skynet = require "skynet"
require "skynet.manager"
local CMD = {}

function CMD.test1()
	print("test1")
	i = 1 
	skynet.fork(function ()
		sknet.sleep(10 * 100)
		skynet.retpack("test")
	end)
end

function CMD.test2()
	print("test2")
	skynet.retpack("test")
end


skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		f(...)
	end)

end)