--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: 测试数据节点相关服务
 * @DateTime:    2017-01-18 09:22:36
 --]]

local skynet = require "skynet"
require "skynet.manager"
require "sgoly_printf"
local dat_ser = require "sgoly_dat_ser"

local test_dat_ser = {}

--[[
函数说明：
		函数作用：测试注册功能
		传入参数：nickname(用户昵称), pwd(用户登录注册密码), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
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
		函数作用：测试登录功能
		传入参数：nickname(用户昵称), pwd(用户登录注册密码), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
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
		函数作用：测试用户账户初始化功能
		传入参数：nickname(用户昵称), money(金币数额), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.usr_init(nickname, money, cnt)
	printD("test usr_init(%s, %d, %d)", nickname, money, cnt)
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
		函数作用：测试获取用户金币数额功能
		传入参数：nickname(用户昵称), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.get_money(nickname, cnt)
	printD("test get_money(%s)", nickname)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tag, msg = dat_ser.get_money(tmpname)
		printD("test get_money. tag = %s, msg = %s", tag, msg)
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
		函数作用：测试更新用户账户金币数额功能
		传入参数：nickname(用户昵称), money(金币数额), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
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
		函数作用：测试 del_usr.del_usr
		传入参数：nickname(用户昵称), pwd(用户登录注册密码), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.del_usr(nickname, pwd, cnt)
	printD("test del_usr(%s, %s, %d)", nickname, pwd, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmppwd = pwd.."-"..i
		local tag, msg = dat_ser.del_usr(tmpname, tmppwd)
		printD("test del_usr.del_usr tag = %s, msg = %s", tag, msg)
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
		函数作用：测试 del_usr.seted_safe_pwd
		传入参数：nickname(用户昵称), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.seted_safe_pwd(nickname, cnt)
	printD("test seted_safe_pwd(%s, %d)", nickname, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tag, msg = dat_ser.seted_safe_pwd(tmpname)
		printD("test del_usr.seted_safe_pwd tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试 del_usr.seted_safe_pwd 通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试 del_usr.seted_safe_pwd 不通过"
	end
end

--[[
函数说明：
		函数作用：测试 dat_ser.set_safe_pwd
		传入参数：nickname(用户昵称), saf_pwd(用户保险柜密码), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.set_safe_pwd(nickname, saf_pwd, cnt)
	printD("test dat_ser.set_safe_pwd(%s, %s, %d)", nickname, saf_pwd, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmp_saf_pwd = saf_pwd.."-"..i
		local tag, msg = dat_ser.set_safe_pwd(tmpname, tmp_saf_pwd)
		printD("test dat_ser.set_safe_pwd tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试 dat_ser.set_safe_pwd 通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试 dat_ser.set_safe_pwd 不通过"
	end
end

--[[
函数说明：
		函数作用：测试 dat_ser.open_saf
		传入参数：nickname(用户昵称), saf_pwd(用户保险柜密码), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.open_saf(nickname, saf_pwd, cnt)
	printD("test dat_ser.open_saf(%s, %s, %d)", nickname, saf_pwd, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmp_saf_pwd = saf_pwd.."-"..i
		local tag, msg = dat_ser.open_saf(tmpname, tmp_saf_pwd)
		printD("test dat_ser.open_saf tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试 dat_ser.open_saf 通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试 dat_ser.open_saf 不通过"
	end
end

--[[
函数说明：
		函数作用：测试 dat_ser.query_saf_money
		传入参数：nickname(用户昵称), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.query_saf_money(nickname, cnt)
	printD("test dat_ser.query_saf_money(%s, %d)", nickname, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tag, msg = dat_ser.query_saf_money(tmpname)
		printD("test dat_ser.query_saf_money tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试 dat_ser.query_saf_money 通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试 dat_ser.query_saf_money 不通过"
	end
end

--[[
函数说明：
		函数作用：测试 dat_ser.save_money_2saf
		传入参数：nickname(用户昵称), saf_money(用户存入金币), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.save_money_2saf(nickname, saf_money, cnt)
	printD("test dat_ser.save_money_2saf(%s, %d, %d)", nickname, saf_money, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmp_money = saf_money + i
		local tag, msg = dat_ser.save_money_2saf(tmpname, tmp_money)
		printD("test dat_ser.save_money_2saf tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试 dat_ser.save_money_2saf 通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试 dat_ser.save_money_2saf 不通过"
	end
end

--[[
函数说明：
		函数作用：测试 dat_ser.get_saf_money
		传入参数：nickname(用户昵称), saf_money(用户金币), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.get_saf_money(nickname, saf_money, cnt)
	printD("test dat_ser.get_saf_money(%s, %d, %d)", nickname, saf_money, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local tmp_money = saf_money + i
		local tag, msg = dat_ser.get_saf_money(tmpname, tmp_money)
		if(true == tag) then
			printD("test dat_ser.get_saf_money tag = %s, msg = %d", tag, msg)
			tested_cnt = tested_cnt + 1
		else
			printD("test dat_ser.get_saf_money tag = %s, msg = %s", tag, msg)
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试 dat_ser.get_saf_money 通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试 dat_ser.get_saf_money 不通过"
	end
end

--[[
函数说明：
		函数作用：测试 dat_ser.cha_saf_pwd
		传入参数：nickname(用户昵称), saf_pwd(用户保险柜密码), cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.cha_saf_pwd(nickname, saf_pwd, cnt)
	printD("test_dat_ser.cha_saf_pwd(%s, %s, %d)", nickname, saf_pwd, cnt)
	local tested_cnt = 0
	for i = 1, cnt do
		local tmpname = nickname.."-"..i
		local old_pwd = saf_pwd.."-"..i
		local new_pwd = "new_"..saf_pwd.."-"..i
		local tag, msg = dat_ser.cha_saf_pwd(tmpname, old_pwd, new_pwd)
		printD("test dat_ser.cha_saf_pwd tag = %s, msg = %s", tag, msg)
		if(true == tag) then
			tested_cnt = tested_cnt + 1
		end
	end
	if(cnt == tested_cnt) then
		return true, "测试 dat_ser.cha_saf_pwd 通过"
	else
		printD("test_cnt = %d", tested_cnt)
		return false, "测试 dat_ser.cha_saf_pwd 不通过"
	end
end

--[[
函数说明：
		函数作用：检测各个子测试,汇总
		传入参数：nickname(用户昵称), pwd(用户注册登录密码), money(用户金币), 
				 saf_pwd(用户保险柜密码), saf_money(用户保险柜金币数额), 
				 cnt(测试次数)
		返回参数：(false, err_msg) or (true, true_msg)
--]]
function test_dat_ser.main(nickname, pwd, money, saf_pwd, saf_money, cnt)
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

	local tag7, msg7 = test_dat_ser.set_safe_pwd(nickname, saf_pwd, cnt)
	printD("tag7 =%s, msg7 = %s", tag7, msg7)

	local tag8, msg8 = test_dat_ser.seted_safe_pwd(nickname, cnt)
	printD("tag8 =%s, msg8 = %s", tag8, msg8)

	local tag9, msg9 = test_dat_ser.open_saf(nickname, saf_pwd, cnt)
	printD("tag9 =%s, msg9 = %s", tag9, msg9)

	local tag10, msg10 = test_dat_ser.save_money_2saf(nickname, saf_money, cnt)
	printD("tag10 =%s, msg10 = %s", tag10, msg10)

	local tag11, msg11 = test_dat_ser.query_saf_money(nickname, cnt)
	printD("tag11 =%s, msg11 = %s", tag11, msg11)

	local tmp_saf_money = 800
	local tag12, msg12 = test_dat_ser.get_saf_money(nickname, tmp_saf_money, cnt)
	printD("tag12 =%s, msg12 = %s", tag12, msg12)

	local tag13, msg13 = test_dat_ser.query_saf_money(nickname, cnt)
	printD("tag13 =%s, msg13 = %s", tag13, msg13)

	local tag14, msg14 = test_dat_ser.cha_saf_pwd(nickname, saf_pwd, cnt)
	printD("tag14 =%s, msg14 = %s", tag14, msg14)

	local new_pwd = "new_"..saf_pwd
	local tag15, msg15 = test_dat_ser.open_saf(nickname, new_pwd, cnt)
	printD("tag15 =%s, msg15 = %s", tag15, msg15)

	local tag6, msg6 = test_dat_ser.del_usr(nickname, pwd, cnt)
	printD("tag6 =%s, msg6 = %s", tag6, msg6)

	res_tag = (tag1 and tag2 and tag3 and tag4 and tag5 and tag6 and tag7 and 
			   tag8 and tag9 and tag10 and tag11 and tag12 and tag13 and tag14 
			   and tag15)
	if(res_tag) then
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
	local saf_pwd = "test_saf_pwd"
	local saf_money = 8888
	local cnt = 3
	test_dat_ser.main(nickname, pwd, money, saf_pwd, saf_money, cnt)
	skynet.exit()
end)