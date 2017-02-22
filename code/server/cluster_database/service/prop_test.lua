--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is Test of prop
 * @DateTime:    2017-02-22 09:44:51
--]]

local skynet = require "skynet"
require "skynet.manager"
require "sgoly_printf"
local dat_ser = require "sgoly_dat_ser"

local test_dat_ser = {}

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function Tget_all_prop(uid)
	printD("test get_all_prop(%d)", uid)
	local status, res = dat_ser.get_all_prop(uid)
	if(true == status) then
		for k, v in pairs(res) do
			printD("type[%d], value = %d", k, v)
		end
	else
		printD("Err: %s", status)
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function Tset_prop(uid, type, value)
	printD("test set_prop(%d, %d, %d)", uid, type, value)
	local status, res = dat_ser.set_prop(uid, type, value)
	printD("status = %s, res = %s", status, res)
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function Tget_prop_att()
	for i = 1, 3 do
		printD("test get_prop_att(%d)", i)
	    local status, res = dat_ser.get_prop_att(i)
	    printD("%s, %s, %s", res._name, res._describe, res.img)
	end
end

skynet.start(function()
	Tget_prop_att()
	-- Tget_all_prop(40)
	-- Tset_prop(40, 1, 1)
	-- Tset_prop(40, 2, 1)
	-- Tset_prop(40, 3, 1)
	Tget_all_prop(40)
	skynet.exit()
end)