local skynet    = require "skynet"
local socket    = require "socket"
local crypt     = require "crypt"
local name = ... or ""
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"

function _read(id)
    while true do
        local str   = socket.readline(id)
        print("read")
        if str then
            skynet.error(id, "server says: ", str)
            local str1 = crypt.base64decode(str)
            local password
            local who="123456"
            password=crypt.aesdecode(str1,who,"")
            local mes =cjson.decode(password)
            skynet.error("client echo",mes.ID,mes.SESSION)
        else
            socket.close(id)
            skynet.error("disconnected")
            skynet.exit()
        end
    end
end

skynet.start(function()
    --连接到服务器
    local addr  =  "192.168.100.13:7000"
    local id    = socket.open(addr)
    if not id then
        skynet.error("can't connect to "..addr)
        skynet.exit()
    end

    skynet.error("connected")

    --启动读协程
    skynet.fork(_read, id)
 
    -- for i=1, 10 do
    -- local lua_value = {ID="3",CLUSTER="4"}
    local lua_value = {ID="1",CLUSTER="4",SERVICE="140",CMD="signin",NAME="interface6",PASSWD=123456}
    local json_text = cjson.encode(lua_value)
    local password 
    local who="123456"
    password =crypt.aesencode(json_text,who,"")
    local str1 = crypt.base64encode(password)
    str1 = string.pack(">s2", str1)
    socket.write(id,str1)
    -- end
    -- skynet.sleep(100)
    --  local lua_value1 = {ID="4",BOTTOM=10,TIMES=10,COUNTS=1,MONEY=200,COST=100}
    -- local json_text1 = cjson.encode(lua_value1)
    --  password1 =crypt.aesencode(json_text1,who,"")
    -- local str11 = crypt.base64encode(password1)
    -- socket.write(id,str11.."\n")
end)
