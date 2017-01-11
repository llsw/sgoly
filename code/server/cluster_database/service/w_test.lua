local skynet = require "skynet"
require "sgoly_printf"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local md5 = require "md5"

skynet.start(function()
	printI(package.cpath)
	local lua_value = {true, {foo="bar"}} 
	local json_text = cjson.encode(lua_value)
	for k, v in pairs(mds) do
	--printI(md5.update(json_text))
	skynet.error(k, v)
	end
	printI(json_text)
	skynet.exit()
	
end)