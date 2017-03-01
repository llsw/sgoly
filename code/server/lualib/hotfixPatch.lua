local skynet = require "skynet"

_ENV.hello = function()
	skynet.error("hello")
end

for k, v in pairs(_P.lua) do
		print(k, v)
	end

local CMD = _P.lua.CMD  
CMD.TEST = function()
	-- hello()
    for k, v in pairs(_P) do
		print(k, v)
	end
	return  "7891" 
end 




-- local reload = package.loaded["testReload"]
-- reload.test = function ()
-- 	skynet.error("reload success")
-- end