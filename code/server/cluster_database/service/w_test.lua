local skynet = require "skynet"
require "sgoly_printf"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local md5 = require "md5"
local tool = require "sgoly_tool"
require "sgoly_query"

local netpack = require "netpack"
local socketdriver = require "socketdriver"
local MSG = {}


	-- function MSG.open(fd, msg)
		
	-- 	socketdriver.nodelay(fd)
	-- 	socketdriver.start(fd)
	-- end

	-- function MSG.data(fd, msg, sz)
	-- 	skynet.error(msg, sz)
	-- 	skynet.error(netpack.tostring(msg, sz))
	-- end


	-- skynet.register_protocol {
	-- 	name = "socket",
	-- 	id = skynet.PTYPE_SOCKET,	-- PTYPE_SOCKET = 6
	-- 	unpack = function ( msg, sz )
	-- 		skynet.error("test1")
	-- 		return netpack.filter( queue, msg, sz)
	-- 	end,
	-- 	dispatch = function (_, _, q, type, ...)
	-- 		skynet.error("test2")
	-- 		if type then
	-- 			skynet.error("type:", type)
	-- 			MSG[type](...)
	-- 		end
	-- 	end
	-- }

skynet.start(function()
	printI(package.cpath)
	local lua_value = {true, {foo="bar"}} 
	local json_text = cjson.encode(lua_value)
	
	printI(json_text)
	local x = cjson.decode(json_text)

	printI(cjson.encode(x))

	-- -- redis_query({"hset", "user:1234", "test", 5000000})
	-- -- skynet.error(redis_query({"hget", "user:1234", "test"}))
	-- local t = redis_query({"keys", "user:*"})
	-- for k,v in pairs(t) do
	-- 	skynet.error(k,v)
	-- 	skynet.error(k,string.match(v,"user:(.+)"))
	-- end
	--tool.saveMoneyToRedis("interface", 1000)
	-- tool.saveStatementsToRedis("interface", 10000, 10, 3, 5000, 4000)


	-- local address = "0.0.0.0"
	-- local port = 8889
	-- skynet.error(string.format("Listen on %s:%d", address, port))
	-- socket = socketdriver.listen(address, port)
	-- socketdriver.start(socket)

	local t = redis_query({"hgetall","statements:interface"})
	local rt = tool.multipleToTable(t)

	for k,v in pairs(rt) do
			skynet.error(k,v)
	end

	--skynet.error(redis_query({"hget","statements:interface", "winNum"}))

	skynet.exit()
	
end)