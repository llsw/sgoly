local skynet = require "skynet"
local sgoly_tool=require"sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local md5 = require "md5"
local sgoly_pack=require "sgoly_pack"
local CMD={}
function CMD.safebox(fd,mes,name)
	if mes.TYPE=="query" then
	 --       local bool,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
		--    printI("this is safe1,%s",mes.NAME)
		-- if bool then 
		-- 	local rqs={SESSION=mes.session,ID="9",STATE=true,TYPE="query",SET="yes"}
		-- 	local req2_1=sgoly_pack.encode(rqs)
		--     return req2_1
		-- else 
	        return returnfalse(mes)
		-- end
	elseif mes.TYPE=="setpd" then
		--     local PASSWD=md5.sumhexa(mes.PASSWD)
	 --        local bool,rqs=sgoly_tool.getRankFromRedis()
		--     printI("this is safe2,%s",mes.NAME)
		-- if  bool then 
		-- 	local rqs={SESSION=mes.session,ID="9",STATE=true,TYPE="setpd"}
		-- 	local req2_1=sgoly_pack.encode(rqs)
		--     return req2_1
		-- else 
	        return returnfalse(mes)
		-- end
	elseif mes.TYPE=="reset" then
		--     local PASSWD=md5.sumhexa(mes.PASSWD)
	 --        local bool,rqs=sgoly_tool.getRankFromRedis()
		--     printI("this is safe3,%s",mes.NAME)
		-- if  bool then 
		-- 	local rqs={SESSION=mes.session,ID="9",STATE=true,TYPE="reset"}
		-- 	local req2_1=sgoly_pack.encode(rqs)
		--     return req2_1
		-- else 
	        return returnfalse(mes)
		-- end
	elseif mes.TYPE=="login" then
	 --       local bool,req1 = sgoly_tool.getStatementsFromRedis(mes.NAME, os.date("%Y-%m-%d"))
		--    printI("this is safe4,%s",mes.NAME)
		-- if bool then 
		-- 	local rqs={SESSION=mes.session,ID="9",STATE=true,TYPE="login"}
		-- 	local req2_1=sgoly_pack.encode(rqs)
		--     return req2_1
		-- else 
	        return returnfalse(mes)
		-- end
	elseif mes.TYPE=="save" then
	 --      local boo,money =sgoly_tool.getMoney(mes.NAME)
		--    printI("this is safe5,%s",mes.NAME)
		-- if bool then 
		--    local rqs={SESSION=mes.session,ID="9",STATE=true,TYPE="save",MONEY=money}
	 --       local req2_1=sgoly_pack.encode(rqs)
		--    return req2_1
		-- else 
	       return returnfalse(mes)
		-- end
	elseif mes.TYPE=="load" then
	 --       local boo,money =sgoly_tool.getMoney(mes.NAME)
		--    printI("this is safe4,%s",mes.NAME)
		-- if bool then 
		--    local rqs={SESSION=mes.session,ID="9",STATE=true,TYPE="load",MONEY=money}
		--    local req2_1=sgoly_pack.encode(rqs)
		--    return req2_1
		-- else 
	       return returnfalse(mes)
		-- end
	else 
		returnfalse(mes)
	end
end


function returnfalse(mes)
	        local req1={SESSION=mes.session,ID="9",STATE=false,MESSAGE="false"}
			local req1_1=sgoly_pack.encode(req1)
			return req1_1
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