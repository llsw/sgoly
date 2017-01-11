local skynet = require "skynet"
local socket = require "socket"
local proxy = require "socket_proxy"
require "sgoly_printf"
local service = require "service"
require "skynet.manager"
local hub = {}
local data = { socket = {} }

local function auth_socket(fd)
	return (skynet.call(service.auth, "lua", "shakehand" , fd))
end

local function assign_agent(fd, userid)
	skynet.call(service.manager, "lua", "assign", fd, userid)
end

function new_socket(fd, addr)
	print("this is  new_socket")
	data.socket[fd] = "[AUTH]"
	proxy.subscribe(fd)
	local ok , userid =  pcall(auth_socket, fd)
	if ok then
		data.socket[fd] = userid
		if pcall(assign_agent, fd, userid) then
			return	-- succ
		else
			printI("Assign failed %s to %s", addr, userid)
		end
	else
		printI("Auth faild %s", addr)
	end
	proxy.close(fd)
	data.socket[fd] = nil
end

function hub.open(ip, port)
	assert(data.fd == nil, "Already open")
	data.fd = socket.listen(ip, port)
	data.ip = ip
	data.port = port
	print("Listendfsdfs %s:%d", ip, port)
	socket.start(data.fd,new_socket)
end

function hub.close()
	assert(data.fd)
	printI("Close %s:%d", data.ip, data.port)
	socket.close(data.fd)
	data.ip = nil
	data.port = nil
end

service.init {
	command = hub,
	info = data,
	require = {
		"auth",
		"manager",
	}
}
-- skynet.start(function()
-- 	skynet.dispatch("lua", function(session, source, cmd, ...)
-- 		local f = assert(hub[cmd])
-- 		if f then 
-- 			skynet.retpack(f(...))
-- 		else
-- 			f(...)
-- 		end	
-- 	end)

  skynet.register(".hub")
-- end)