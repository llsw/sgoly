local skynet = require "skynet"
local sgoly_pack=require "sgoly_pack"
local sgoly_tool=require "sgoly_tool"
require "sgoly_printf"
require "skynet.manager"
local CMD={}

function CMD.shoplist(fd,mes)
	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
	sgoly_pack.returnfalse(mes,"15",msg)
end




skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
    -- 要注册个服务的名字，以.开头
    skynet.register(".shop")
end)