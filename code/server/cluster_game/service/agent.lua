local skynet = require "skynet"
local socket = require "socket"
local cluster= require "cluster"
require "skynet.manager"
local sgoly_tool=require "sgoly_tool"
local sgoly_pack=require "sgoly_pack"
local crypt     = require "crypt"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local agent = {}

local connection = {}


function agent.main(fd,mes)
	skynet.error(mes)
	skynet.error(mes.SESSION,mes.ID,mes.TYPE,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY,mes.COST)
	if mes.ID=="4" then
	   local req=skynet.call(connection[fd].maingame,"lua","calc",fd,mes.SESSION,mes.TYPE,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY,mes.COST,connection[fd].name)
	   return req
	elseif mes.ID=="5" then
	   local req1=skynet.call(connection[fd].stats,"lua","tongji",fd,mes.SESSION,mes.TYPE,connection[fd].name)
	   return req1
	elseif mes.ID=="6" then
		local req2=exit(fd,mes)
		return req2
    else  
   	local req3={SESSION=mes.SESSION,ID=mes.ID,STATE=false,MESSAGE="未知错误"}
	local result1_2 = sgoly_pack.encode(req)
	return result1_2
end
end

function exit(fd,mes)
	local bool,res=sgoly_tool.saveMoneyFromRdisToMySQL(connection[fd].name)
	local bool1,res1=sgoly_tool.saveStatmentsFromRdisToMySQL(connection[fd].name,os.date("%Y-%m-%d"))
		if bool and bool1 then
			local req2={SESSION=mes.SESSION,
			      TYPE=mes.TYPE,
			 	  ID=mes.ID,
			 	  STATE=true
			 	}
	        local result2_1 = sgoly_pack.encode(req2)
	        skynet.error("用户退出")
            return result2_1
        else
        	local req2_1 ={ SESSION=mes.SESSION,
        					ID=mes.ID,
							STATE=false,
							MESSAGE=res.." "..res1} 	
	        local result2_2 = sgoly_pack.encode(req2_1)
            return result2_2
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

function agent.errorexit( fd )	
	if connection[fd] then
		return skynet.call(connection[fd].maingame,"lua","autosave",fd,connection[fd].name)
	else
	    return "no login".." "..fd
    end
end

function agent.close( fd )
	-- body
	if connection[fd] then
		local bool,res=sgoly_tool.saveMoneyFromRdisToMySQL(connection[fd].name)
		local bool1,res1=sgoly_tool.saveStatmentsFromRdisToMySQL(connection[fd].name,os.date("%Y-%m-%d"))
		if bool  and bool1 then 
	    return  "suss"
	    else
		return "false"
	    end
    else 
    	return "no login".." " ..fd
    end
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(agent[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".agent")
end)