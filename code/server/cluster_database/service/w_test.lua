local skynet = require "skynet"
require "sgoly_printf"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"

skynet.start(function()
	printI(package.cpath)
	local lua_value = {true, {foo="bar"}} 
	local json_text = cjson.encode(lua_value)

	printI(json_text)
	skynet.exit()
	
end)