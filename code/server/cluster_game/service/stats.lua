local skynet = require "skynet"
local driver = require "socketdriver"
local gateserver = require "sgoly_gateserver"
local cluster = require"cluster"
local crypt = require"crypt"
local code = require"sgoly_cluster_code"
local sgoly_tool=require"sgoly_tool"
require "sgoly_printf"
local code =require "sgoly_cluster_code"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local CMD={}
function CMD.tongji(fd,session,type,name)
	if type=="today" then
		-- local bool=true
		-- local res={nickname="abcd",winMoney=1000,costMoney=2000,playNum=10,
		-- winNum=1,serialWinNum=1,maxWinMoney=1000}
		local bool,res=sgoly_tool.getStatementsFromRedis(name)
		if bool then
			local  req={SESSION=session,
			            ID="5",
			            TYPE="today",
			            STATE=true,
			            winMoney=res.winMoney,
			            costMoney=res.costMoney,
			            playNum=res.playNum,
			            winNum=res.winNum,
			            serialWinNum=res.serialWinNum,
			            maxWinMoney=res.maxWinMoney
			        }
			local result1_2 = sendreq(req)
		    return result1_2
		elseif not bool then
			local req1 = {SESSION=session,
			              ID="5",
			              TYPE="today",
			              STATE=false,
		-- 	              MESSAGE=res
			          }
			local result2_2 = sendreq(req1)
		    return result2_2          
	    end
	elseif type=="yesterday" then
	elseif type=="history"   then
	end  
end

function sendreq(req)
    local who="123456"
	local result1=cjson.encode(req)
	local result1_1=crypt.aesencode(result1,who,"")
	local result1_2 = crypt.base64encode(result1_1)
	return result1_2
end
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--skynet.error("this is maingame")
    -- 要注册个服务的名字，以.开头
    skynet.register(".stats")
end)
