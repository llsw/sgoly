local skynet = require "skynet"
local service_config = require "sgoly_service_config"


--[[
	封装好的输出函数
	输出到控制台和日志文件
	一个是info
	一个是error
--]]

function printI(str, ...)
	if(service_config["log_config"].info) then
		skynet.error("[INFO]", string.format(str, ...))
		LOG_INFO(str, ...)
	end
end

function printE(str, ...)
	if(service_config["log_config"].error) then
		skynet.error("[ERROR]", string.format(str, ...))
		LOG_ERROR(str, ...)
	end
end

function printD(str, ...)
	if(service_config["log_config"].debug) then
		skynet.error("[DEBUG]", string.format(str, ...))
		LOG_DEBUG(str, ...)
	end
end

function LOG_DEBUG(fmt, ...)
	local msg = string.format(fmt, ...)
	local info = debug.getinfo(2)
	if info then
		msg = string.format("[%s:%d] %s", info.short_src, info.currentline, msg)
	end
	skynet.send(".log", "lua", "debug", SERVICE_NAME, msg)
end

function LOG_INFO(fmt, ...)
	local msg = string.format(fmt, ...)
	local info = debug.getinfo(2)
	if info then
		msg = string.format("[%s:%d] %s", info.short_src, info.currentline, msg)
	end
	skynet.send(".log", "lua", "info", SERVICE_NAME, msg)
end

function LOG_WARNING(fmt, ...)
	local msg = string.format(fmt, ...)
	local info = debug.getinfo(2)
	if info then
		msg = string.format("[%s:%d] %s", info.short_src, info.currentline, msg)
	end
	skynet.send(".log", "lua", "warning", SERVICE_NAME, msg)
end

function LOG_ERROR(fmt, ...)
	local msg = string.format(fmt, ...)
	local info = debug.getinfo(2)
	if info then
		msg = string.format("[%s:%d] %s", info.short_src, info.currentline, msg)
	end
	skynet.send(".log", "lua", "error", SERVICE_NAME, msg)
end

function LOG_FATAL(fmt, ...)
	local msg = string.format(fmt, ...)
	local info = debug.getinfo(2)
	if info then
		msg = string.format("[%s:%d] %s", info.short_src, info.currentline, msg)
	end
	skynet.send(".log", "lua", "fatal", SERVICE_NAME, msg)
end

function xpcall_error()
	printE(debug.traceback())
end

