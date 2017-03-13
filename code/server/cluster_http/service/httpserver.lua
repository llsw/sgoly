
--[[
 * @brief:        httpserver.lua

 * @author:        kun si
 * @email:          627795061@qq.com
 * @date:        2017-03-01
--]]

local skynet = require "skynet"
local socket = require "socket"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local urllib = require "http.url"
local table = table
local string = string
local service_config = require "sgoly_service_config"
require "skynet.manager"
require "sgoly_printf"
local sgoly_union_query = require "sgoly_union_query"
package.cpath = "../luaclib/lib/lua/5.3/?.so;" .. package.cpath
local cjson = require "cjson"
local mode = ...
local data

local CMD = {}

function CMD.version(query)
    if query then
        local q = urllib.parse_query(query)
        for k, v in pairs(q) do
            skynet.error(k, v)
            if k == "getVersion" then
                local ok, result = sgoly_union_query.getApkVersion()
                if ok and result then
                    skynet.error("apk_version", apk_version)
                    data = {version = result[1].version, date=result[1].date, instruction = result[1].instruction}
                    data = cjson.encode(data) 
                    return data
                end
            end
        end
        return nil
    end
end

function CMD.download(query, pfile)
    --if pfile == "game.zip" then
    if pfile ~= "nil" then   
        -- local apk_version 
        -- local ok, result = sgoly_union_query.getApkVersion()
        -- if ok and result then
            -- apk_version = result[1].version
            -- skynet.error("apk_version", apk_version)
            local file = io.open("/tmp/apk/" .. pfile, "r");
            assert(file);
            data = file:read("*a");
            return data
        -- end
        -- return nil 
    end
    return nil 
end

if mode == "agent" then

local function response(id, code, data, ...)
  
    local ok, err = httpd.write_response(sockethelper.writefunc(id), code, data, ...)
    if not ok then
        skynet.error(string.format("fd = %d, %s", id, err))
    end
end

local function handlerRequest(id, code, url, method, header, body)
    if code then
        if code ~= 200 then
            response(id, code)
        else
            local path, query = urllib.parse(url)  
            if path then
                skynet.error("path", path)
                old_path = path
                path, pfile = string.match(path, "/([^/]+)/?")
                pfile = string.match(old_path, "/[^/]+/(.+)")
                skynet.error("subpath", path)
                skynet.error("pfile", pfile)
                if path ~= "favicon.ico" and path ~= "/favicon.ico" then
                    local f = assert(CMD[path], path .. " not found")
                    data = f(query, pfile)
                end
            end
            if data then
                response(id, code, data)
            else 
                response(id, code)
            end     
            
        end
    else
        if url == sockethelper.socket_error then
            skynet.error("socket closed")
        else
            skynet.error(url)
        end
    end
end

skynet.start(function()
    skynet.dispatch("lua", function (_,_,id)
        socket.start(id)  -- 开始接收一个 socket
        -- limit request body size to 8192 (you can pass nil to unlimit)
        -- 一般的业务不需要处理大量上行数据，为了防止攻击，做了一个 8K 限制。这个限制可以去掉。
        local code, url, method, header, body = httpd.read_request(sockethelper.readfunc(id), 8192)
        handlerRequest(id, code, url, method, header, body)
        socket.close(id)
    end)
end)

else

skynet.start(function()
    local agent = {}
    for i= 1, 10 do
        -- 启动 20 个代理服务用于处理 http 请求
        agent[i] = skynet.newservice("httpserver", "agent")  
        skynet.name(".httpserver_" .. i, agent[i])
    end
    local balance = 1
    -- 监听一个 web 端口
    local listenHost = service_config["httpserver"]["host"]
    local listenPort = service_config["httpserver"]["port"]
    local id = socket.listen(listenHost, listenPort)  
    printI("Http server listen on %s:%s", listenHost, listenPort)
    socket.start(id , function(id, addr)  
        -- 当一个 http 请求到达的时候, 把 socket id 分发到事先准备好的代理中去处理。
        skynet.error(string.format("%s connected, pass it to agent :%08x", addr, agent[balance]))
        skynet.send(agent[balance], "lua", id)
        balance = balance + 1
        if balance > #agent then
            balance = 1
        end
    end)
end)
    skynet.register(".httpserver_0")

end