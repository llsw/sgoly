local skynet = require "skynet"

local CMD = _P.lua.CMD  
CMD.TEST1 = function()
	hello()
    return "TEST1"
end 




-- local reload = package.loaded["testReload"]
-- reload.test = function ()
-- 	skynet.error("reload success")
-- end