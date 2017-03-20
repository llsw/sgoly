local skynet = require "skynet"
local sgoly_pack=require "sgoly_pack"
local sgoly_tool=require "sgoly_tool"
local dat_ser=require "sgoly_dat_ser"
require "sgoly_printf"
require "skynet.manager"
local CMD={}
local prop = {150000,80000,30000}
function CMD.shoplist(fd,mes)                   --商城
	if mes.TYPE=="look"   then                  --查看背包 
		local bool,req = sgoly_tool.getPackageFromRedis(mes.NAME)
		local bool1,req1 = dat_ser.get_recharge(mes.NAME)
		req1 =  req1[1].recharge
		if bool and req1[1] then
		    local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="look",PROPLIST=req,FIRST=req1}
		    local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
	    else
	    	return sgoly_pack.typereturn(mes,"16","查看失败")
		end
	elseif mes.TYPE=="buy" then					--购买道具
		if mes.PROPID=="4" then
			local bo,money=sgoly_tool.getMoney(mes.NAME)
			local bo1,re=sgoly_tool.saveMoneyToRedis(mes.NAME,money+mes.PROPNUM)
			if bo and bo1 then
			   local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="buy",PROPID=mes.PROPID,PROPNUM=money+mes.PROPNUM}
			   local req2_1=sgoly_pack.encode(rqs)
			   dat_ser.update_recharge(mes.NAME,tonumber(mes.FIRST))
			   return req2_1
			else
		    	return sgoly_pack.typereturn(mes,"16",money..re)
	    	end  
		else
		    sgoly_tool.getPackageFromRedis(mes.NAME)
			local bool1,req1=sgoly_tool.getPropFromRedis(mes.NAME, mes.PROPID)
			local bo,money=sgoly_tool.getMoney(mes.NAME)
			local cost = prop[tonumber(mes.PROPID)]
			if money<cost*mes.PROPNUM then
				return sgoly_pack.typereturn(mes,"16","金币不足")
			end
			if  req1==nil then
				req1 = mes.PROPNUM
			else
				req1 = req1+mes.PROPNUM
	        end
			local bool,req=sgoly_tool.setPropToRedis(mes.NAME,mes.PROPID,req1)
			local bo1,re=sgoly_tool.saveMoneyToRedis(mes.NAME,money-cost*mes.PROPNUM)
			if bool and bo1 then
		       local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="buy",PROPID=mes.PROPID,PROPNUM=req1,MONEY=money-cost*mes.PROPNUM}
			   local req2_1=sgoly_pack.encode(rqs)
			   return req2_1
		    else
		    	return sgoly_pack.typereturn(mes,"16",req..re)
	    	end
	    end
    elseif mes.TYPE=="use" then                    --使用道具
    	local bool,req = sgoly_tool.getPackageFromRedis(mes.NAME)
    	-- local bool2,usenum = sgoly_tool.getPropFromRedis(mes.NAME, mes.PROPID)
    	-- if usenum>5 then
    	-- 	return sgoly_pack.typereturn(mes,"16","道具使用次数已达本日上限")
    	-- end
    	local bool1,req1=sgoly_tool.getPropFromRedis(mes.NAME, mes.PROPID)
    	if bool1==false then
    		return sgoly_pack.typereturn(mes,"16","道具使用失败")
    	end
    	if req1==0 then
    		return sgoly_pack.typereturn(mes,"16","道具数量为0")
    	end
		local bool,req=sgoly_tool.setPropToRedis(mes.NAME,mes.PROPID, req1-1)
		if bool then
	       local rqs={SESSION=mes.SESSION,ID="16",STATE=true,TYPE="use",PROPID=mes.PROPID,PROPNUM=req1-1}
		   local req2_1=sgoly_pack.encode(rqs)
		   return req2_1
	    else
	    	return sgoly_pack.typereturn(mes,"16",req)
    	end
    else
    	return sgoly_pack.typereturn(mes,"16","参数错误")
    end
end


skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
    -- 要注册个服务的名字，以.开头
    skynet.register(".shop")
end)