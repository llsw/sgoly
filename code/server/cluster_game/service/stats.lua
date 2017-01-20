local skynet = require "skynet"
local driver = require "socketdriver"
local gateserver = require "sgoly_gateserver"
local cluster = require"cluster"
local crypt = require"crypt"
local code = require"sgoly_cluster_code"
local sgoly_tool=require"sgoly_tool"
require "sgoly_printf"
local sgoly_pack=require "sgoly_pack"
local code =require "sgoly_cluster_code"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local CMD={}
function CMD.tongji(fd,session,type,name)
	if type=="today" then
		local bool,res=sgoly_tool.getStatementsFromRedis(name,os.date("%Y-%m-%d"))
		if bool then
			local  req={SESSION=session,
			            ID="5",
			            TYPE="today",
			            STATE=true,
			            winMoney=tonumber(res.winMoney),
			            costMoney=tonumber(res.costMoney),
			            playNum=tonumber(res.playNum),
			            winNum=tonumber(res.winNum),
			            serialWinNum=tonumber(res.serialWinNum),
			            maxWinMoney=tonumber(res.maxWinMoney)
			        }
			skynet.error(req.SESSION,req.winMoney,req.costMoney,req.playNum,req.winNum,req.serialWinNum,req.maxWinMoney)
			local result1_2 = sgoly_pack.encode(req)
		    return result1_2
		elseif not bool then
			local req1 = {SESSION=session,
			              ID="5",
			              TYPE="today",
			              STATE=false,
			              MESSAGE=res
			          }
			local result2_2 = sgoly_pack.encode(req1)
		    return result2_2          
	    end
	elseif type=="yesterday" then
		local a=os.date("%Y-%m-")
		local b=tonumber(os.date("%d"))-1
		local c=a..b
		local bool,res=sgoly_tool.getStatementsFromRedis(name,c)
		if bool then
			local  reqy={SESSION=session,
			            ID="5",
			            TYPE="yesterday",
			            STATE=true,
			            winMoney=tonumber(res.winMoney),
			            costMoney=tonumber(res.costMoney),
			            playNum=tonumber(res.playNum),
			            winNum=tonumber(res.winNum),
			            serialWinNum=tonumber(res.serialWinNum),
			            maxWinMoney=tonumber(res.maxWinMoney)
			        }
			skynet.error(reqy.SESSION,reqy.winMoney,reqy.costMoney,reqy.playNum,reqy.winNum,reqy.serialWinNum,reqy.maxWinMoney)
			local resulty = sgoly_pack.encode(reqy)
		    return resulty
		elseif not bool then
			local reqy1 = {SESSION=session,
			              ID="5",
			              TYPE="yesterday",
			              STATE=false,
			              MESSAGE=res
			          }
			local resulty1 = sgoly_pack.encode(reqy1)
		    return resulty1          
	    end
	elseif type=="history"   then
		local bool,res=sgoly_tool.getCountStatementsFromRedis(name)
		if bool then
			local  reqh={SESSION=session,
			            ID="5",
			            TYPE="history",
			            STATE=true,
			            winMoney=tonumber(res.winMoney),
			            costMoney=tonumber(res.costMoney),
			            playNum=tonumber(res.playNum),
			            winNum=tonumber(res.winNum),
			            serialWinNum=tonumber(res.serialWinNum),
			            maxWinMoney=tonumber(res.maxWinMoney)
			        }
			skynet.error(reqh.SESSION,reqh.winMoney,reqh.costMoney,reqh.playNum,reqh.winNum,reqh.serialWinNum,reqh.maxWinMoney)
			local resulth = sgoly_pack.encode(reqh)
		    return resulth
		elseif not bool then
			local reqh1 = {SESSION=session,
			              ID="5",
			              TYPE="history",
			              STATE=false,
			              MESSAGE=res
			          }
			local resulth1 = sgoly_pack.encode(reqh1)
		    return resulth1         
	    end
	end
	
	local req3 = {SESSION=session,
			      ID="5",
			      TYPE="type",
			      STATE=false,
                  MESSAGE="error"
			     }
    local result3_2 = sgoly_pack.encode(req3)
    return result3_2 
end
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--skynet.error("this is maingame")
    -- 要注册个服务的名字，以.开头
    -- skynet.register(".stats")
end)
