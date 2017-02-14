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
	printI("Gateway open source[%d]", source)
end

function handler.message(fd, msg)
	if msg then
		printI("client %s says:",fd)
		local mes=sgoly_pack.decode(msg)
		if mes.ID~="1" and mes.ID~="2"  then
			mes.NAME=tonumber(mes.NAME)
		end
		printI("%s %s %s %s %s %s %s",mes.SESSION,mes.CLUSTER,mes.SERVICE,mes.CMD,mes.ID,mes.NAME,mes.PASSWD)
		local cnode=tonumber(mes.CLUSTER)
		local snode=tonumber(mes.SERVICE)
		cluster.call("cluster_game",".agent","setline",fd)
		local req=cluster.call(code[cnode],code[snode],mes.CMD,fd,mes)
		if req~=nil then 
		  printI("this is req to client")
		  driver.send(fd,req)
        end
    end
end


function handler.connect(fd,addr)
	gateserver.openclient(fd)
	printI("Client fd[%d] connect gateway", fd)
	local session=1
	local ses=tostring("fd-"..fd..":session*"..session)
	local rep={SESSION=ses,ID="0"}
	local str1=sgoly_pack.encode(rep)
    driver.send(fd,str1)
    connection[fd] = {fd = fd}
end

function handler.disconnect(fd)
	local req1=cluster.call("cluster_game",".agent","errorexit",fd)
    printI("save 自动模式".." " ..req1)
	local req=cluster.call("cluster_game",".agent","close",fd)
	printI("save 普通模式".." " ..req)
	printI("Client fd[%d] disconnect gateway", fd)
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
		printI("name[%s] fd[%d] sleep end", name, fd)
		if  line==false then
			printI("line=false")
			break
		end
		local timeBetween = os.time() - line

		if(timeBetween > 20) then
			printI("HeartBeat name[%s] fd[%d] timeBetween[%d]", name, fd, timeBetween)
			local req={ID="13",TYPE="heart"}
			local req2_1=sgoly_pack.encode(req)
		    driver.send(fd,req2_1)
		    --printI("this is heart,fd[%d]",fd)
    	end

    	if(timeBetween > 50) then
    		break
    	end
    end
    gateserver.closeclient(fd)
    printI(">50s fd[%d]",fd)
end
function handler.command(cmd, source, ...)
	local f = assert(CMD[cmd])
	return f(...)
end

gateserver.start(handler)


        