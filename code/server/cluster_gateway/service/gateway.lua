local skynet = require "skynet"
local driver = require "socketdriver"
local gateserver = require "sgoly_gateserver"
local cluster = require"cluster"
local crypt = require"crypt"
local sgoly_pack=require "sgoly_pack"
local code = require"sgoly_cluster_code"
require "sgoly_printf"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local skynet_queue = require "skynet.queue"
local lock = skynet_queue()
local connection = {}


local handler = {}

function handler.open(source, conf)
	printD("Gateway open source[%d]", source)
end

function handler.message(fd, msg)
	if msg then
		printD("client %s says:",fd)
		local mes=sgoly_pack.decode(msg)
		if mes.ID~="1" and mes.ID~="2"  then
			mes.NAME=tonumber(mes.NAME)
		end
		local getMsgTime = os.clock()
		printD("======================MSG start============================")
		printD("[%s] Get a Msg session[%s] cluster[%s] service[%s cmd[%s] id[%s] name[%s] time[%s]", os.date("%H:%M:%S", os.time()),
			mes.SESSION, mes.CLUSTER, mes.SERVICE, mes.CMD,mes.ID, mes.NAME, getMsgTime)
		local cnode=tonumber(mes.CLUSTER)
		local snode=tonumber(mes.SERVICE)
		cluster.call("cluster_game",".agent","setline",fd)
		local req=cluster.call(code[cnode],code[snode],mes.CMD,fd,mes)
		printD("End handle a Msg session[%s]  name[%s]  handlerCostTime[%s]",
			mes.SESSION, mes.NAME, os.clock() - getMsgTime)
		if req~=nil then 
		  driver.send(fd,req)
		  printD("[%s] End send a Msg session[%s]  name[%s]  totleCostTime[%s]", os.date("%H:%M:%S", os.time()),
			mes.SESSION, mes.NAME, os.clock() - getMsgTime)
        end
        printD("----------------------MSG end------------------------------")
    end
end


function handler.connect(fd,addr)
	gateserver.openclient(fd)
	printD("Client fd[%d] connect gateway", fd)
	local session=1
	local ses=tostring("fd-"..fd..":session*"..session)
	local rep={SESSION=ses,ID="0"}
	local str1=sgoly_pack.encode(rep)
    driver.send(fd,str1)
    connection[fd] = {fd = fd}
end

function handler.disconnect(fd)
	local req1=cluster.call("cluster_game",".agent","errorexit",fd)
    printD("save 自动模式".." " ..req1)
	local req=cluster.call("cluster_game",".agent","close",fd)
	printD("save 普通模式".." " ..req)
	printD("Client fd[%d] disconnect gateway", fd)
	connection[fd] = nil
end

function handler.error(fd, msg)
	printE("Gateway error fd[%d] msg[%s]", fd, msg)
end

function handler.warning(fd, size)
	printE("Gateway warning fd[%d] size[%s]", fd, size)	
end

local CMD = {}
function CMD.seclose(fd,mes,boo)    
    if boo==true then               --服务器关闭
		driver.send(fd,mes)
		gateserver.closeclient(fd)
    else                            --服务器关闭通告
    	driver.send(fd,mes)
    end
end


function CMD.heart(fd,name,session)
	skynet.fork(handlerfork,fd,name,session)
end

function inform(msg)
	msg={ID="8",STATE=false,MESSAGE=msg}
	msg = sgoly_pack.encode(msg)
	for k, v in pairs(connection) do
		driver.send(k, msg)
	end	
end

function CMD.informClient(msg)
	skynet.fork(inform, msg)
end

function handlerfork(fd,name,session)
	while true do
		skynet.sleep(2000)
		local line =  cluster.call("cluster_game",".agent","getline",fd)
		printD("name[%s] fd[%d] sleep end", name, fd)
		if  line==false then
			printD("line=false")
			break
		end
		local timeBetween = os.time() - line

		if(timeBetween > 20) then
			printD("==================HeartBeat start====================")
			printD(" TimeBetween[%d] HeartBeat name[%s] fd[%d]", timeBetween, name, fd)
			local req={ID="13",TYPE="heart"}
			local req2_1=sgoly_pack.encode(req)
		    driver.send(fd,req2_1)
		    printD("Time[%s] End send a heartbeat  name[%s]  Time[%s]", os.clock(), 
			 name)
		    printD("------------------HeartBeat end-----------------------")
    	end

    	if(timeBetween > 50) then
    		break
    	end
    end
    gateserver.closeclient(fd)
    printD(">50s name[%s] fd[%d]", name, fd)
end
function handler.command(cmd, source, ...)
	local f = assert(CMD[cmd])
	return f(...)
end

gateserver.start(handler)


        