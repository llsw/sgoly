local skynet = require "skynet"
local driver = require "socketdriver"
local gateserver = require "sgoly_gateserver"
local cluster = require"cluster"
local crypt = require"crypt"
local code = require"sgoly_cluster_code"
require "sgoly_printf"
local code =require "sgoly_cluster_code"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"



local handler = {}
session=0
sessionID={}
function handler.open(source, conf)
	printI("Gateway open source[%d]", source)
end

function handler.message(fd, msg)
	if msg then
		skynet.error("client"..fd, " says: ", msg)
		local str1 = crypt.base64decode(msg)
		local password
		local who="123456"
		password=crypt.aesdecode(str1,who,"")
		local mes = cjson.decode(password)
		skynet.error(mes)
		skynet.error(mes.SESSION,mes.CLUSTER,mes.SERVICE,mes.CMD,mes.ID,mes.NAME,mes.PASSWD)
		--sessionID[mes.NAME]=mes.SESSION
		local cnode=tonumber(mes.CLUSTER)
		local snode=tonumber(mes.SERVICE)
		local req =cluster.call(code[cnode],code[snode],mes.CMD,fd,mes)
		print(req,"thisi  is req")
		driver.send(fd,req)
    end
end


function handler.connect(fd, addr)
	gateserver.openclient(fd)
	printI("Client fd[%d] connect gateway", fd)
	session=session+1
	local ses=tostring(session)
	local rep={SESSION=ses,ID="0"}
	local json_text = cjson.encode(rep)
    local password 
    local who="123456"
    password =crypt.aesencode(json_text,who,"")
    local str1 = crypt.base64encode(password)
    driver.send(fd,str1.."\n")
end

function handler.disconnect(fd)
	--gateserver.closeclient(fd)
	printI("Client fd[%d] disconnect gateway", fd)
end

function handler.error(fd, msg)
	printE("Gateway error fd[%d] msg[%s]", fd, msg)
end

function handler.warning(fd, size)
	printE("Gateway warning fd[%d] size[%s]", fd, size)	
end

local CMD = {}

	

function handler.command(cmd, source, ...)
	local f = assert(CMD[cmd])
	return f(...)
end

gateserver.start(handler)