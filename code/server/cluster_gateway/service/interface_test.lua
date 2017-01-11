local skynet = require "skynet"
require "sgoly_printf"
-- package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
-- local cjson = require "cjson"
-- local md5 = require "md5"
require "sgoly_query"

skynet.start(function()

	local res = redis_query({"get", "uuid"})
	res = tonumber(res)
	skynet.error(res, type(res))
	
end)