local skynet = require "skynet"
local driver = require "socketdriver"
local gateserver = require "sgoly_gateserver"
local cluster = require"cluster"
local crypt = require"crypt"
local code = require"sgoly_cluster_code"
local sgoly_tool=require"sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local md5 = require "md5"
local sgoly_pack=require "sgoly_pack"
local code =require "sgoly_cluster_code"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local CMD={}
function CMD.safe_in(fd,session,type,name)
	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
	local mes.PASSWD=md5.sumhexa(mes.PASSWD)
	if mes.TYPE=="daySERIES" then
	    	local bool1,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
	        local bool,rqs=sgoly_tool.getRankFromRedis(mes.NAME,tonumber(req1.serialWinNum), "serialWinNum",os.date("%Y-%m-%d"))
		    printI("this is rank1,%s",mes.NAME)
		if bool1 and bool then 
			rqs.SESSION=mes.session
			rqs.ID="7"
			rqs.STATE=true
			rqs.TYPE="daySERIES"
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
	        local req5={SESSION=mes.session,ID="7",STATE=false,MESSAGE="false"}--,--MESSAGE=rqs}
			local req5_1=sgoly_pack.encode(req5)
			return req5_1
		end
	end
end
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--skynet.error("this is maingame")
    -- 要注册个服务的名字，以.开头
    skynet.register(".safe")
end)