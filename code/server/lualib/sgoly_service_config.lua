--[[
	命名方式：节点名_自定义_config
	使用方法: local service_config = require "sgoly_service_config"
	local config = service_config.节点名_自定义_config
--]]

local service_config = {}

service_config["database_mysql_config"] = {
	dbType = "MySQL",	--
	totalNum = 15, 		-- mysql最大连接数
	host = "192.168.100.137",	-- mysql数据库IP
	port = 3306,		-- mysql数据库端口
	database = "sgoly",	-- mysql数据库
	user = "interface",	-- mysql数据库用户名
	max_packet_size = 1024 * 1024,
	password = "H3/I/BdJecGOn5uP3ygKk/n4cSZM2OzPvwD3phcyELs=", -- mysql数据库密码
}

service_config["database_redis_6379_config"] = {
	dbType = "Redis",	--
	totalNum = 15,		--
	host = "192.168.100.137",	--
	port = 6379,		--
	db = 0,            	--
	auth = "jM+x3GFfjj2fQm4x9mWUtGZejd+2S1jfgm8FIo58apU=",
}

service_config["gateway_server"] = {
	host = "0.0.0.0:7000"	
      
}

service_config["log_config"] = {
	info = true,
	debug = true,
	error = true
}

return service_config