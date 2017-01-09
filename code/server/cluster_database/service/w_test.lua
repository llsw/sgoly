local skynet = require "skynet"
require "sgoly_printf"
-- package.path = "/usr/local/share/lua/5.3/?.lua;/usr/local/share/lua/5.3/?/init.lua;/usr/local/lib/lua/5.3/?.lua;/usr/local/lib/lua/5.3/?/init.lua;./?.lua;./?/init.lua;" .. package.path
-- package.cpath = "" .. package.cpath
--local cjson = require "cjson"

skynet.start(function()
	printI(package.cpath)
	-- local lua_value = {true, {foo="bar"}} 
	-- local json_text = cjson.encode(lua_value)

	-- printI(json_text)
	skynet.exit()
	
end)