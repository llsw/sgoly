local skynet = require "skynet"
require "sgoly_printf"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local md5 = require "md5"
local tool = require "sgoly_tool"

skynet.start(function()
	printI(package.cpath)
	local lua_value = {true, {foo="bar"}} 
	local json_text = cjson.encode(lua_value)
	
	printI(json_text)
	local x = cjson.decode(json_text)

	printI(cjson.encode(x))

	local id = tool.getUuid()
	skynet.error(id)
	id = id + 1
	tool.saveUuid(id)
	id = tool.getUuid()
	skynet.error(id)
	skynet.exit()
	
end)