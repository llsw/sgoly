local skynet    = require "skynet"
local socket    = require "socket"
local crypt     = require "crypt"
local name = ... or ""
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local json = require "cjson"

function _read(id)
    while true do
        local str   = socket.readline(id)
        if str then
            skynet.error(id, "server says: ", str)
            -- socket.close(id)
            -- skynet.exit()
        else
            -- socket.close(id)
            -- skynet.error("disconn ected")
            -- skynet.exit()
        end
    end
end

skynet.start(function()
    --连接到服务器
    local addr  =  "192.168.100.77:7000"
    local id    = socket.open(addr)
    if not id then
        skynet.error("can't connect to "..addr)
        skynet.exit()
    end

    skynet.error("connected")

    --启动读协程
    skynet.fork(_read, id)

    -- socket.write(id, "1\n")

    -- socket.write(id, "hello2,\n")
    -- local lua_value = {ID="2",NAME="1234",PASSWD="123456"}
    for i=1,30 do
      
    local lua_value = {ID="3"}
    local json_text = json.encode(lua_value)
    local password 
    local who="123456"
    password =crypt.aesencode(json_text,who,"")
    local str1 = crypt.base64encode(password)
    socket.write(id,str1.."\n")
    end
end)
