local skynet = require "skynet"
local socket = require "socket"
local cluster= require "cluster"
require "skynet.manager"
require "sgoly_printf"
local sgoly_tool=require "sgoly_tool"
local sgoly_pack=require "sgoly_pack"
local agent = {}

local connection = {}


function agent.main(fd,mes)
	printI("this is agent,%s,%s,%s,%s,%s,%s,%s,%s",mes.SESSION,mes.ID,mes.TYPE,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY,mes.COST)
	if mes.ID=="4" then       --主游戏
	   local req=skynet.call(connection[fd].maingame,"lua","calc",fd,mes.SESSION,mes.TYPE,mes.BOTTOM,mes.TIMES,mes.COUNTS,mes.MONEY,mes.COST,connection[fd].name)
	   return req
	elseif mes.ID=="5" then   --统计面板
	   local req1=skynet.call(connection[fd].stats,"lua","tongji",fd,mes.SESSION,mes.TYPE,connection[fd].name)
	   return req1
	elseif mes.ID=="6" then   --正常退出
		local req2=exit(fd,mes)
		return req2  
	elseif mes.ID=="9" then   --保险柜
		local req3=skynet.call(connection[fd].safe,"lua","safebox",fd,mes,connection[fd].name)
		return req3 	
	elseif mes.ID=="10" then   --签到
		local req4=skynet.call(connection[fd].sign,"lua","sign_in",fd,mes,connection[fd].name)
		return req4 
    else  
	   	local req3={SESSION=mes.SESSION,ID=mes.ID,STATE=false,MESSAGE="未知错误"}
		local result1_2 = sgoly_pack.encode(req)
		return result1_2
end
end

function exit(fd,mes)   --用户正常退出
	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
	local bool,res=sgoly_tool.saveMoneyFromRdisToMySQL(connection[fd].name)
	local bool1,res1=sgoly_tool.saveStatmentsFromRdisToMySQL(connection[fd].name,os.date("%Y-%m-%d"))
	local bool2,res2=sgoly_tool.saveStatmentsFromRdisToMySQL(connection[fd].name,c)
	local bool3,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
	local bool4,rqs=sgoly_tool.getRankFromRedis(mes.NAME,tonumber(req1.serialWinNum), "serialWinNum",os.date("%Y-%m-%d"))
	local bool5,req3 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
	local bool6,rqs3_1=sgoly_tool.getRankFromRedis(mes.NAME,tonumber(req2.winMoney), "winMoney",os.date("%Y-%m-%d"))
		if bool and bool1 and bool3 and bool4 then
			local req2={SESSION=mes.SESSION,
			      TYPE=mes.TYPE,
			 	  ID=mes.ID,
			 	  STATE=true
			 	}
	        local result2_1 = sgoly_pack.encode(req2)
	        printI("%s用户退出",connection[fd].name)
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
	   local safe = skynet.newservice("safe")
	  local sign = skynet.newservice("sign")
	  local c = {
	  		name = name,
	  		maingame = maingame,
	  		stats=stats,
	  		safe=safe,
	  		line=os.time(),
	  		sign=sign
			}
	  connection[fd] = c 
end

function agent.errorexit( fd )	 --用户玩自动模式强制退出
	if connection[fd] then
		return skynet.call(connection[fd].maingame,"lua","autosave",fd,connection[fd].name)
	else
	    return "no login".." "..fd
    end
end

function agent.close( fd )        --用户玩普通模式强制退出
	-- body
	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
	if connection[fd] then
		local bool,res=sgoly_tool.saveMoneyFromRdisToMySQL(connection[fd].name)
		local bool1,res1=sgoly_tool.saveStatmentsFromRdisToMySQL(connection[fd].name,os.date("%Y-%m-%d"))
		local bool2,res2=sgoly_tool.saveStatmentsFromRdisToMySQL(connection[fd].name,c)
		local bool3,req1 = sgoly_tool.getStatementsFromRedis(connection[fd].name, os.date("%Y-%m-%d"))
		local bool4,rqs=sgoly_tool.getRankFromRedis(connection[fd].name,tonumber(req1.serialWinNum), "serialWinNum",os.date("%Y-%m-%d"))
	    local bool5,req3 = sgoly_tool.getStatementsFromRedis(connection[fd].name, os.date("%Y-%m-%d"))
		local bool6,rqs3_1=sgoly_tool.getRankFromRedis(connection[fd].name,tonumber(req2.winMoney), "winMoney",os.date("%Y-%m-%d"))
		if bool  and bool1 then
			-- cluster.call("cluster_login",".login","release",fd,connection[fd].name)
		     connection[fd]=nil
	   		 return  "suss"
	    else
	    	-- cluster.call("cluster_login",".login","release",fd,connection[fd].name)
	    	connection[fd]=nil
			return "false"
	    end
    else 
    	-- cluster.call("cluster_login",".login","release",fd,connection[fd].name)
    	connection[fd]=nil
    	return "no login".." " ..fd
    end     
end

function agent.sclose(bool)
	if bool ==true then
		for k,v in pairs(connection) do
			printI("this is connection %s",k)
			local req3={ID="8",STATE=true}
			local result1_2 = sgoly_pack.encode(req3)
		    cluster.call("cluster_gateway",".gateway","seclose",k,result1_2,true)
		end
    else
    	for k,v in pairs(connection) do
		printI("this is connection,%s",k)
		local req1={ID="8",STATE=false,MESSAGE="服务器将于五分钟后关闭"}
		local result2_2 = sgoly_pack.encode(req1)
	    cluster.call("cluster_gateway",".gateway","seclose",k,result2_2,false)
	    end
	end
end

function agent.setline(fd)
	if connection[fd]~=nil  then
		if connection[fd]~=nil  then
			printI("this is setline")
		   connection[fd].line=os.time()
		end
	end
end


function agent.getline(fd)
	if connection[fd]==nil then
		return false
	else
	 return connection[fd].line
	end
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(agent[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	skynet.register(".agent")
end)