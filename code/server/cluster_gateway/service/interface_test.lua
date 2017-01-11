local skynet = require "skynet"
require "sgoly_printf"
-- package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
-- local cjson = require "cjson"
-- local md5 = require "md5"
local tool = require "sgoly_tool"

skynet.start(function()

	local uuid = tool.getUuid()
	skynet.error(uuid)
	uuid = uuid + 1
	tool.updateUuid(uuid)
	
	uuid = tool.getUuid()
	skynet.error(uuid)
	
end)