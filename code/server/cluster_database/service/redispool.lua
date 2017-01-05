
--[[
 * @brief: redispool.lua

 * @author:	  kun si
 * @date:	2017-01-05
--]]

local skynet = require "skynet"
require "skynet.manager"
local redis = require "redis"
local crypt = require "crypt"
local dbPool = require "sgoly_redis_connection"
local service_config = require "sgoly_service_config"
require "sgoly_printf"
local CMD = {}
local dbc 


function CMD.start()
	local dbconf = service_config["database_redis_6379_config"]
	local rwho = "interface"
	local rauth = dbconf["auth"]
	rauth = crypt.base64decode(rauth)
	rauth = crypt.aesdecode(rauth,rwho,"")
	dbconf.auth = rauth

	dbc = dbPool.new()
	dbc:init(dbconf)

	-- local db = dbc:get()
	-- if  db then
	-- 	db:flushdb()
	-- 	dbc:free(db)
	-- end
	
end


function CMD.set(dbn, key, value)
	local db = dbc:get()
	local retsult = db:set(key,value)
	dbc:free(db)	
	return retsult
end

function CMD.get(dbn, key)
	local db = dbc:get()
	local retsult = db:get(key)
	dbc:free(db)	
	return retsult
end

function CMD.hmset(dbn, key, t)
	local data = {}
	for k, v in pairs(t) do
		table.insert(data, k)
		table.insert(data, v)
	end

	local db = dbc:get()
	local result = db:hmset(key, table.unpack(data))
	dbc:free(db)
	return result
end

function CMD.hmget(dbn, key, ...)
	if not key then return end

	local db = dbc:get()
	local result = db:hmget(key, ...)
	dbc:free(db)	
	return result
end

function CMD.hset(dbn, key, filed, value)
	local db = dbc:get()
	local result = db:hset(key,filed,value)
	dbc:free(db)	
	return result
end

function CMD.hget(dbn, key, filed)
	local db = dbc:get()
	local result = db:hget(key, filed)
	dbc:free(db)	
	return result
end

function CMD.hgetall(dbn, key)
	local db = dbc:get()
	local result = db:hgetall(key)
	dbc:free(db)	
	return result
end

function CMD.zadd(dbn, key, score, member)
	local db = dbc:get()
	local result = db:zadd(key, score, member)
	dbc:free(db)
	return result
end

function CMD.keys(dbn, key)
	local db = dbc:get()
	local result = db:keys(key)
	dbc:free(db)
	return result
	
end

function CMD.zrange(dbn, key, from, to)
	local db = dbc:get()
	local result = db:zrange(key, from, to)
	dbc:free(db)
	return result
end

function CMD.zrevrange(dbn, key, from, to ,scores)
	local result
	local db = dbc:get()
	if not scores then
		result = db:zrevrange(key,from,to)
	else
		result = db:zrevrange(key,from,to,scores)
	end
	dbc:free(db)
	return result
end

function CMD.zrank(dbn, key, member)
	local db = dbc:get()
	local result = db:zrank(key,member)
	dbc:free(db)
	return result
end

function CMD.zrevrank(dbn, key, member)
	local db = dbc:get()
	local result = db:zrevrank(key,member)
		dbc:free(db)
	return result
end

function CMD.zscore(dbn, key, score)
	local db = dbc:get()
	local result = db:zscore(key,score)
	dbc:free(db)
	return result
end

function CMD.zcount(dbn, key, from, to)
	local db = dbc:get()
	local result = db:zcount(key,from,to)
	dbc:free(db)
	return result
end

function CMD.zcard(dbn, key)
	local db = dbc:get()
	local result = db:zcard(key)
	dbc:free(db)
	return result
end

function CMD.incr(dbn, key)
	local db = dbc:get()
	local result = db:incr(key)
		dbc:free(db)
	return result
end

function CMD.del(dbn, key)
	local db = dbc:get()
	local result = db:del(key)
	dbc:free(db)
	
	return result
end
	

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".redispool")
end)
