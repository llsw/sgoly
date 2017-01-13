local skynet = require "skynet"
require "sgoly_printf"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local md5 = require "md5"
local tool = require "sgoly_tool"
require "sgoly_query"

skynet.start(function()
	printI(package.cpath)
	local lua_value = {true, {foo="bar"}} 
	local json_text = cjson.encode(lua_value)
	
	printI(json_text)
	local x = cjson.decode(json_text)

	printI(cjson.encode(x))

	-- redis_query({"hset", "user:1234", "test", 5000000})
	-- skynet.error(redis_query({"hget", "user:1234", "test"}))
	local t = redis_query({"keys", "user:*"})
	for k,v in pairs(t) do
		skynet.error(k,v)
		skynet.error(k,string.match(v,"user:(.+)"))
	end
	
	skynet.exit()
	
end)