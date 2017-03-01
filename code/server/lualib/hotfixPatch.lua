local skynet = require "skynet"

---------------添加变量------------
local _E = _ENV._P.lua._ENV
_E.hello={2}

local CMD = _P.lua.CMD  
CMD.TEST = function()
	skynet.error(hello[1])
    return "TEST"
end 

-------------添加函数-------------
-- local _E = _ENV._P.lua._ENV
-- _E.hello=function ()
-- 	skynet.error("zxczxczxc")
-- end

-- local CMD = _P.lua.CMD  
-- CMD.TEST = function()
-- 	hello()
--     return "TEST"
-- end 


-- local CMD = _P.lua.CMD  
-- CMD.TEST =nil


-------------更新模块函数--------
-- local reload = package.loaded["testReload"]
-- reload.test = function ()
-- 	skynet.error("reload success")
-- end