local skynet = require "skynet"
local socket = require "socket"
local cluster= require "cluster"
require "skynet.manager"
local crypt     = require "crypt"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local agent = {}

local connection = {}


function agent.main(fd,mes)
	skynet.error(mes)
	skynet.error(mes.SESSION,mes.ID,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY,mes.COST)
	if mes.ID=="4" then
	   local req=skynet.call(connection[fd].maingame,"lua","calc",fd,mes.SESSION,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY,mes.COST,connection[fd].name)
	   return req
	elseif mes.ID=="5" then
	   local req1=skynet.call(connection[fd].stats,"lua","tongji",fd,mes.SESSION,mes.TYPE,connection[fd].name)
	   return req1
   else  
   	local who="123456"
   	local req={SESSION=mes.SESSION,ID=mes.ID,STATE=false,MESSAGE="未知错误"}
	local result1=cjson.encode(req)
	local result1_1=crypt.aesencode(result1,who,"")
	local result1_2 = crypt.base64encode(result1_1)
	return result1_2
end
end

function agent.start(fd,name)
	  local maingame = skynet.newservice("maingame")
	  local stats = skynet.newservice("stats")
	  local c = {
	  		name = name,
	  		maingame = maingame,
	  		stats=stats
			}
	  connection[fd] = c 
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(agent[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".agent")
end)