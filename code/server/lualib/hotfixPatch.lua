local skynet = require "skynet"
_P.lua._ENV.hello = function()
	print("hello")
end
print(hello)
local CMD = _P.lua.CMD  
CMD.TEST = function()
	print(_ENV.hello)
	return  "7891" 
end 





-- local reload = package.loaded["testReload"]
-- reload.test = function ()
-- 	skynet.error("reload success")
-- end