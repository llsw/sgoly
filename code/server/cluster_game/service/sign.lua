local skynet = require "skynet"
local sgoly_tool=require"sgoly_tool"
local dat_ser=require "sgoly_dat_ser"
require "sgoly_printf"
require "skynet.manager"
local sgoly_pack=require "sgoly_pack"
local CMD={}
function CMD.sign_in(fd,mes,name)      --签到
	if mes.TYPE=="query" then
	    	local bool1,req1 = dat_ser.query_sign(name) 
		    printI("this is sign1,%s",name)
		if bool1  then 
			local rqs={SESSION=mes.SESSION,ID="10",STATE=true,TYPE="query",LIST=req1}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
			return sgoly_pack.typereturn(mes,"10",req1)
		end
	elseif mes.TYPE=="signin" then
		    local lbo,t = dat_ser.query_sign(name) 
		    local tbo=sgoly_pack.istoday(t)
		    if tbo then
		    	return sgoly_pack.typereturn(mes,"10","今天已签到")
		    end
	    	local bool1,req1 = dat_ser.sign(name,os.date("%Y-%m-%d"))
	    	local bool2,signIn1 = dat_ser.get_award("signIn","1")
	    	local bool3,nowmoney=sgoly_tool.getMoney(name) 
	    	local bool4,req4=sgoly_tool.saveMoneyToRedis(name,nowmoney+signIn1)
		if bool1 and bool2 and bool3 and bool4 then 
			 		local lbo,t = dat_ser.query_sign(name) 
				    local tl=sgoly_pack.dateToWeek(t)
				    local max=sgoly_pack.seriLogin(tl)
			    if max==3 or max==5 or max==7  then
			    	local bool1,req1 = dat_ser.get_award("signIn",max)
			    	local bool3,nowmoney=sgoly_tool.getMoney(name)
			    	local bool2,req2=sgoly_tool.saveMoneyToRedis(name,nowmoney+req1)
			        sgoly_tool.getPackageFromRedis(name)
		            rqs={}
		            local num
		            local id 

			    	local bo3,req3=dat_ser.get_award("signInProp",max)
		    	    
		    	    if  bo3 then
		    	    	id=math.floor(req3 / 100000)
		    	    	num=req3%100000
		    	    	local bo3,re3=sgoly_tool.getPropFromRedis(name,id)
		    	    	num = num + re3
		    	    	sgoly_tool.setPropToRedis(name,id,num)
		    	    	rqs.PROPLIST={}
		    	    	rqs.PROPLIST[id]= num-re3
		    	    end
					if bool1 and bool2 then 
						rqs.SESSION=mes.SESSION
						rqs.ID="10"
						rqs.STATE=true
						rqs.TYPE="signin"
						rqs.MONEY=nowmoney+req1
						rqs.AWARDMONEY=req1+signIn1
						local req2_1=sgoly_pack.encode(rqs)
					    return req2_1
					else 
						return sgoly_pack.typereturn(mes,"10",req1..nowmoney..req2)
					end
				else
					local rqs={SESSION=mes.SESSION,ID="10",STATE=true,TYPE="signin",MONEY=nowmoney+signIn1,AWARDMONEY=signIn1,PROPLIST={}}
					local req2_1=sgoly_pack.encode(rqs)
				    return req2_1
				end
	    else 
			return sgoly_pack.typereturn(mes,"10","错误")
		end
	
	else 
		return sgoly_pack.typereturn(mes,"10","参数错误")
	end           
end



skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
    -- 要注册个服务的名字，以.开头
    skynet.register(".sign")
end)
