local skynet = require "skynet"
local sgoly_pack=require "sgoly_pack"
local sgoly_tool=require "sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local CMD={}



function CMD.ranklist(fd,mes)
	if mes.TYPE=="yesSERIES" then
	-- local bool,rqs=sgoly_tool.
	-- if bool then 
	--     local req={SESSION=session,ID="7",mes.TYPE="yesSERIES",STATE=true,
	--         LIST={NUM=,NAME="name",CONUTS=rqs,WINNUM=rqs}}
	--     local req1=sgoly_pack.encode(req)
	--     return req1
 -- --        end
 --    elseif  mes.TYPE=="daySERIES"   then
 --    --  local bool,rqs=sgoly_tool.
	-- -- if bool then 
	--    local req2={SESSION=session,ID="7",mes.TYPE="daySERIES",STATE=true,--,COUNTS=rqs}
	--    LIST={NUM="1",NAME="name",CONUTS=rqs,WINNUM=rqs}}
	--    local req2_1=sgoly_pack.encode(req2)
	--     return req2_1
 --    --     end
 --    elseif	mes.TYPE=="yesALLMONEY" then
 --    --  local bool,rqs=sgoly_tool.
	-- -- if bool then 
	--     local req3={SESSION=session,ID="7",mes.TYPE="yesALLMONEY",STATE=true,--,WINNUM=rqs}
	--     LIST={NUM="1",NAME="name",CONUTS=rqs,WINNUM=rqs}}
	--     local req3_1=sgoly_pack.encode(req3)
	--     return req3_1
 --    --     end
 --    elseif	mes.TYPE=="yesALLMONEY" then
 --    --  local bool,rqs=sgoly_tool.
	-- -- if bool then 
	--     local req4={SESSION=session,ID="7",mes.TYPE="yesALLMONEY",STATE=true,
	--     LIST={NUM="1",NAME="name",CONUTS=rqs,WINNUM=rqs}}
	--     local req4_1=sgoly_pack.encode(req4)
	--     return req4_1
 --        end
	-- -- else 
	-- 	local req5={SESSION=session,ID="7",STATE=false}--,--MESSAGE=rqs}
	-- 	local req5_1=sgoly_pack.encode(req5)
	-- 	return req5_1
	return true
    else 
   	   return  false
   	end
end
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--skynet.error("this is maingame")
    -- 要注册个服务的名字，以.开头
    skynet.register(".rank")
end)