--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 
 * @DateTime:    2017-01-18 09:22:36
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
function test_dat_ser.register(nickname, pwd, cnt)
	printD("test register(%s, %s, %d)", nickname, pwd, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmppwd = pwd.."-"..i
		local tag, msg = dat_ser.register(tmpname, tmppwd)
		printD("test resgister. tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试不通过"
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function test_dat_ser.login(nickname, pwd, cnt)
	printD("test login(%s, %s, %d)", nickname, pwd, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmppwd = pwd.."-"..i
		local tag, msg = dat_ser.login(tmpname, tmppwd)
		printD("test login. tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试不通过"
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function test_dat_ser.usr_init(nickname, money, cnt)
	printD("test usr_init(%s, %d)", nickname, money)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tag, msg = dat_ser.usr_init(tmpname, money)
		printD("test usr_init. tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试不通过"
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function test_dat_ser.get_money(nickname, cnt)
	printD("test get_money(%s)", nickname)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tag, msg = dat_ser.get_money(tmpname)
		printD("test up_acc. tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试不通过"
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function test_dat_ser.upd_acc(nickname, money, cnt)
	printD("test_dat_ser.upd_acc(%s, %d)", nickname, money)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmp_money = 6668 + i
		local tag, msg = dat_ser.upd_acc(tmpname, tmp_money)
		printD("test upd_acc. tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试不通过"
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function test_dat_ser.del_acc(nickname,cnt)
	printD("test del_acc(%s, %d)", nickname, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tag, msg = dat_ser.del_acc(tmpname)
		printD("test del_acc. tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试不通过"
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function test_dat_ser.del_usr(nickname, pwd, cnt)
	printD("test del_usr(%s, %s, %d)", nickname, pwd, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmppwd = pwd.."-"..i
		local tag, msg = dat_ser.del_usr(tmpname, tmppwd)
		printD("test resgister. tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试不通过"
	end
end

--[[
函数说明：
		函数作用：
		传入参数：
		返回参数：
--]]
function test_dat_ser.main(nickname, pwd, money, cnt)
	printD("test_dat_ser.main(%s, %s, %d, %d)", nickname, pwd, money, cnt)

	local tag1, msg1 = test_dat_ser.register(nickname, pwd, cnt)
	printD("tag1 =%s, msg1 = %s", tag1, msg1)

	local tag2, msg2 = test_dat_ser.usr_init(nickname, money, cnt)
	printD("tag2 =%s, msg2 = %s", tag2, msg2)

	local tag3, msg3 = test_dat_ser.login(nickname, pwd, cnt)
	printD("tag3 =%s, msg3 = %s", tag3, msg3)

	local tag4, msg4 = test_dat_ser.get_money(nickname, cnt)
	printD("tag4 =%s, msg4 = %s", tag4, msg4)

	local tag5, msg5 = test_dat_ser.upd_acc(nickname, money, cnt)
	printD("tag5 =%s, msg5 = %s", tag5, msg5)

	local tag6, msg6 = test_dat_ser.del_acc(nickname,cnt)
	printD("tag6 =%s, msg6 = %s", tag6, msg6)

	local tag7, msg7 = test_dat_ser.del_usr(nickname, pwd, cnt)
	printD("tag7 =%s, msg7 = %s", tag7, msg7)

	if((true == tag1) and (true == tag2) 
		and (true == tag3) and (true == tag4) and (true == tag5)) then
		printD("%s", "测试全部通过")
		return true, "测试全部通过"
	else
		printD("%s", "测试 未 全部通过")
		return false, "测试 未 全部通过"
	end
end

skynet.start(function()
	local nickname = "test_nickname"
	local pwd = "test_pwd"
	local money = 6666
	local cnt = 3
	test_dat_ser.main(nickname, pwd, money, cnt)
	skynet.exit()
end)