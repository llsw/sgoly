
--[[
 * @brief: db_connetction.lua

 * @author:	  kun si
 * @date:	2016-12-20
--]]

local skynet = require "skynet"
local skynet_queue = require "skynet.queue"
local lock = skynet_queue()
local queue = require "sgoly_queue"
local mysql = require "mysql"
require "sgoly_printf"
--!
--! @brief      类模板
--!
--! @param      父类
--!
--! @return     类模板
--!
--! @author     云风
--! 
local _class={}
function class(super)
	local class_type = {}
	class_type.ctor = false
	class_type.super = super
	class_type.new = function(...) 
			local obj = {}
			do
				local create
				create = function(c,...)
					if c.super then
						create(c.super,...)
					end
					if c.ctor then
						c.ctor(obj,...)
					end
				end
 
				create(class_type,...)
			end
			setmetatable(obj,{ __index = _class[class_type] })
			return obj
		end
	local vtbl = {}
	_class[class_type] = vtbl
 
	setmetatable(class_type,{__newindex =
		function(t,k,v)
			vtbl[k] = v
		end
	})
 
	if super then
		setmetatable(vtbl,{__index=
			function(t,k)
				local ret =_class[super][k]
				vtbl[k] = ret
				return ret
			end
		})
	end
 
	return class_type
end

local dbcPool = class()

--[[
	数据库连接池配置
--]]
dbcPool.conf = nil 		--连接配置
dbcPool.pool = nil 		--连接池队列 
dbcPool.totalNum = nil	--最大连接数 
dbcPool.usedNum = 0		--已经使用的连接数
dbcPool.threshold = nil	--使用警告阀值
dbcPool.pingTime = nil	--激活连接周期
dbcPool.lock = false	--连接池队列锁
dbcPool.addNum = nil	--额外添加的连接数

--!
--! @brief      push a db connection to pool queue
--!
--! @param      q     connection queue
--! @param      db    db connection
--! @param      l     lock
--!
--! @return     1(error) or 0(no error) 
--!
--! @author     kun si
--! @date       2016-12-20
--!
local function pushPool(q, db, l)

	if queue.isFull(q) then
		return 1 
	else
		while l do
			skynet.sleep(0.1 * 100)
		end
		l = true
		queue.push(q, db)
		l = false
		return 0
	end
end
--!
--! @brief      pop a db connection from pool queue
--!
--! @param      q     connection queue
--! @param      l     lock
--!
--! @return     a db connection
--!
--! @author     kun si
--! @date       2016-12-20
--!
local function popPool(q, l)
	if queue.isEmpty(q) then
		return 1
	else
		while l do
			skynet.sleep(0.1 * 100)
		end
		l = true
		local db = queue.pop(q)
		l = false
		return db 
	end
end


local function ping(pool, time)
	while true do
		for k, v in pairs(pool) do
			if type(v) == "table" then
				v:query("select 1")
				printI("Activity MySQL DBC[%d]", k)
			end
		end
		skynet.sleep(time * 100)
	end
end

--!
--! @brief      fork a thread to activity db connection
--!
--! @param      nil
--!
--! @return     nil
--!
--! @author     kun si
--! @date       2016-12-20
--!
function dbcPool:ping()
	local pool = self.pool
	local time = self.pingTime
	skynet.fork(ping, pool, time)
end

--!
--! @brief      add  connections to pool
--!
--! @param      dbconnection pool
--!
--! @return     nil
--!
--! @author     kun si
--! @date       2016-12-20
--!
local function addConnect(dbcP)
	local old_totalNum = dbcP.totalNum
	dbcP.totalNum = dbcP.totalNum + dbcP.addNum
	queue.setMaxLen(dbcP.pool, dbcP.totalNum)
	local count = 0
	for i = 1, dbcP.addNum do
		local db = mysql.connect(dbcP.conf)
		if db ~= nil and lock(pushPool, dbcP.pool, db, dbcP.lock) == 1 then
			printE("MySQL addConnect[%d] to pool is fail!", i)
		else
			count = count + 1
		end
	end
	dbcP.totalNum = dbcP.totalNum + count
	printI("MySQL DBPool real totalNum is [%d]", dbcP.totalNum)
end

--!
--! @brief      init a connection pool
--!
--! @param      dbConf  The database conf
--!
--! @return     nil
--!
--! @author     kun si
--! @date       2016-12-20
--!
function dbcPool:init(dbConf)
	self.totalNum = 15 or dbConf.totalNum
	self.conf = nil or dbConf
	self.threshold = 0.7 or dbConf.threshold
	self.pingTime = 3600 or dbConf.pingTime
	self.pool = queue.new(self.totalNum)
	self.addNum = 5 or dbConf.addNum
	self.lock = false
	local count = 0
	for i = 1 , self.totalNum do
		local db = mysql.connect(dbConf)
		if not db then
			printE("Create MySQL DBC[%d] fail", i)
		else
			if lock(pushPool, self.pool, db, self.lock) == 1 then
				printE("MySQL DBPool if full")
				break
			else
				count = count + 1

			end
		end
	end
	printI("MySQL DBPool useful is %d", count)
	self:ping()
end

--!
--! @brief      Gets the db.
--!
--! @return     The db.
--!
--! @author     kun si
--! @date       2016-12-20
--!
function dbcPool:get()
	if queue.isEmpty(self.pool) then
		printE("MySQL getDB fail. DBPool is empty!")
		return nil
	else
		local db = lock(popPool, self.pool, self.lock)

		if db == 1 then
			printE("MySQL getDB fail")
			return nil
		else
			printI("MySQL getDB success")
			if  self.usedNum >= (self.threshold * self.totalNum) then
				skynet.fork(addConnect, self)
			end
			self.usedNum = self.usedNum + 1
			return db
		end
	end
end

--!
--! @brief      free db
--!
--! @param      db    The database
--!
--! @return     nil
--!
--! @author     kun si
--! @date       2016-12-20
--!
function dbcPool:free(db)
	if lock(pushPool, self.pool, db, self.lock) == 1 then
		printE("MySQL DBPool if full")
	else
		self.usedNum = self.usedNum - 1
	end
end

return dbcPool