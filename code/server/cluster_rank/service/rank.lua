local skynet = require "skynet"
local sgoly_pack=require "sgoly_pack"
local sgoly_tool=require "sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local CMD={}



function CMD.ranklist(fd,mes)
	if type=="yesSERIES" then
	-- TYPE="yesSERIES/ daySERIES/yesALLMONEY/dayALLMONEY"
	--  local bool,rqs=sgoly_tool.
	-- if bool then 
	--    local req={SESSION=session,ID="7",TYPE="yesSERIES",STATE=true,MESSAGE=rqs}
	--     local req=sgoly_pack.encode(rqs)
	--     return req
    --     end
    elseif  type=="daySERIES"   then
    elseif	type=="yesALLMONEY" then
    elseif	type=="yesALLMONEY" then
	-- else 
	-- 	local req2={SESSION=session,ID="7",STATE=false,MESSAGE=rqs}
	-- 	local req2_1=sgoly_pack.encode(req2)
	-- 	return req2_1
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