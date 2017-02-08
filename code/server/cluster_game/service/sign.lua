local skynet = require "skynet"
local sgoly_tool=require"sgoly_tool"
local dat_ser=require "sgoly_dat_ser"
require "sgoly_printf"
require "skynet.manager"
local md5 = require "md5"
local sgoly_pack=require "sgoly_pack"
local CMD={}
function CMD.sign_in(fd,mes,name)
	local c=os.date("%Y-%m-")..(tonumber(os.date("%d"))-1)
	local bool,uid=dat_ser.get_uid(name)
	printI("uid,%s",uid)
	if mes.TYPE=="query" then
	    	local bool1,req1 = dat_ser.query_sign(uid)
		    printI("this is sign1,%s",mes.NAME)
		if bool1  then 
			local rqs={SESSION=mes.session,ID="10",STATE=true,TYPE="query",LIST=req1}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
	        return returnfalse(mes,req1)
		end
	elseif mes.TYPE=="signin" then
	    	local bool1,req1 = dat_ser.sign(uid,os.date("%Y-%m-%d"))
		    printI("this is sign2,%s",mes.NAME)
		if bool1  then 
			local rqs={SESSION=mes.session,ID="10",STATE=true,TYPE="signin"}
			local req2_1=sgoly_pack.encode(rqs)
		    return req2_1
		else 
	        return returnfalse(mes,req1)
		end
	elseif mes.TYPE=="award" then
		    local bool3,req3 = dat_ser.query_sign(uid)
		    local weekday = dateToWeek(req3)
		    local seri=tostring(seriLogin(weekday))
		if seri==mes.DAY then
	    	local bool1,req1 = dat_ser.get_award("signIn",mes.DAY)
	    	local bool,req=sgoly_tool.getMoney(name)
	    	local bool2,req2=sgoly_tool.saveMoneyToRedis(name,req+req1)
		    printI("this is sign3,%s",mes.NAME)
			if bool1 and bool and bool2 then 
				local rqs={SESSION=mes.session,ID="10",STATE=true,TYPE="award",MONEY=req+req1}
				local req2_1=sgoly_pack.encode(rqs)
			    return req2_1
			else 
		        return returnfalse(mes,req1..req..req2)
			end
		else 
	        return returnfalse(mes,"领取失败")
		end
	else 
		returnfalse(mes,"参数错误")
	end           
end

function returnfalse(mes,msg)
	        local req1={SESSION=mes.session,ID="10",STATE=false,TYPE=mes.TYPE,MESSAGE=msg}
			local req1_1=sgoly_pack.encode(req1)
			return req1_1
end

function dateToWeek(dateT)

	local function dateToTime(date)
		local y,m,d = string.match(date,"(.+)-(.+)-(.+)")
			y = tonumber(y)
			m = tonumber(m)
			d = tonumber(d)
		local t = os.time({day = d, month = m, year = y})
		return t
	end
	local function dateToWeekday(date)
		local y,m,d = string.match(date,"(.+)-(.+)-(.+)")
			y = tonumber(y)
			m = tonumber(m)
			d = tonumber(d)
		local t = os.time({day = d, month = m, year = y})
		local weekday = os.date("%w", t)
		return tonumber(weekday)
	end
	local function dateToDay(t)

		local weekday = {0, 0, 0, 0, 0, 0, 0}
		local number = dateToWeekday(t[1])
		if number == 0 then
		 	number = 7
		end

		local count = 0

		for i = 1, 7 do
			if dateToTime(t[1]) - dateToTime(t[i]) >= 24 * 3600 * number then
				break
			end
			count = i
			local day = dateToWeekday(t[i])
			if day == 0 then
				day = 7
			end
			weekday[day] = 1
		end
		return weekday
	end

	return dateToDay(dateT)
end


function seriLogin(t)
	local max = 0
	local count = 0

	for i=1, 7 do
		if t[i] == 1 then
			count = count + 1
		end
		if t[i] == 0  or i == 7 then
			max = count
			count = 0 
		end
	end
	return max 
end
skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
	--skynet.error("this is maingame")
    -- 要注册个服务的名字，以.开头
    skynet.register(".sign")
end)
