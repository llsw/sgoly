local skynet = require "skynet"
local CMD = _P.lua.CMD  
CMD.TEST = function()
	skynet.error(1234)  
	return  "789" 
end 



local reload = package.loaded["testReload"]
reload.test = function ()
	skynet.error("reload success")
end