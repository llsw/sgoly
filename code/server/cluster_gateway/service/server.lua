local skynet    = require "skynet"
local socket    = require "socket"
local cluster   = require "cluster"
require "skynet.manager"
local add=require "sgoly_service_config"

skynet.start(function()
    local fd = assert(socket.listen(add.gateway_server.host))
    socket.start(fd, function(fd, addr)
        skynet.error("client"..fd, " ["..addr.."]", "connected")
        local login= skynet.uniqueservice("login")
        skynet.call(login, "lua", "signin", fd,addr)
    end)
    skynet.register(".server")
end)