local skynet = require "skynet"
require "skynet.manager"	-- import skynet.register
local users = require "sgoly_users"
require "sgoly_printf"

local nickname = "test_nickname"
local new_nickname = "new_nickname"
local pwd = "test_pwd"
local new_pwd = "new_pwd"
local times = 3

function test_users_register(nickname, pwd, times)
	printD("test_users_register(%s, %s, %d)", nickname, pwd, times)
	if((nil == nickname) or (nil == pwd) or (nil == times)) then
		return
	elseif(('' == nickname) or ('' == pwd) or (0 >= times)) then
		return
	else
		for i = 1, times do
			local tmp_nickname = nickname .. "_" .. i
			local tmp_pwd = pwd .. "_" .. i
			local res, msg = users.register(tmp_nickname, tmp_pwd)
			printD("test_users_register ... res: %s", msg)
		end
	end
end

function test_users_login(nickname, pwd, times)
	printD("test_users_login(%s, %s, %d)", nickname, pwd, times)
	if((nil == nickname) or (nil == pwd) or (nil == times)) then
		return
	elseif(('' == nickname) or ('' == pwd) or (0 >= times)) then
		return
	else
		for i = 1, times do
			local tmp_nickname = nickname .. "_" .. i
			local tmp_pwd = pwd .. "_" .. i
			local res, msg = users.login(tmp_nickname, tmp_pwd)
			printD("test_users_login ... res: %s", msg)
		end
	end	
end

function test_users_change_nickname(old_nickname, new_nickname, times)
	printD("test_users_change_nickname(%s, %s, %d", old_nickname, new_nickname, 
			times)
	if((nil == old_nickname) or (nil == new_nickname) or (nil == times)) then
		return
	elseif(('' == old_nickname) or ('' == new_nickname) or (0 >= times)) then
		return
	else
		for i = 1, times do
			local tmp_old_nickname = old_nickname .. "_" .. i
			local tmp_new_nickname = new_nickname .. "_" .. i
			local res, msg = users.change_nickname(tmp_old_nickname, 
				tmp_new_nickname)
			printD("test_users_change_nickname ... res: %s", msg)
		end
	end	
end

function test_users_change_pwd(nickname, old_pwd, new_pwd, times)
	printD("test_users_change_pwd(%s, %s, %s, %d)", nickname, old_pwd, new_pwd, 
			times)
	if((nil == old_pwd) or (nil == new_pwd) or (nil == times)) then
		return
	elseif(('' == old_pwd) or ('' == new_pwd) or (0 >= times)) then
		return
	else
		for i = 1, times do
			local tmp_nickname = nickname .. "_" .. i
			local tmp_old_pwd = old_pwd .. "_" .. i
			local tmp_new_pwd = new_pwd .. "_" .. i
			local res, msg = users.change_pwd(tmp_nickname,tmp_old_pwd, 
				tmp_new_pwd)
			printD("test_users_change_nickname ... res: %s", msg)
		end
	end	
end

function users_delete(nickname, pwd, times)
	printD("users_delete(%s, %s, %d)", nickname, pwd, times)
	if((nil == nickname) or (nil == pwd) or (nil == times)) then
		return
	elseif(('' == nickname) or ('' == pwd) or (0 >= times)) then
		return
	else
		for i = 1, times do
			local tmp_nickname = nickname .. "_" .. i
			local tmp_pwd = pwd .. "_" .. i
			local res, msg = users.delete_user(tmp_nickname, tmp_pwd)
			printD("users_delete ... res: %s", msg)
		end
	end	
end

function test_main(nickname, pwd, times, new_nickname, new_pwd)
	printD("test_main(%s, %s, %d, %s, %s)", nickname, pwd, times, new_nickname, 
			new_pwd)
	test_users_register(nickname, pwd, times)
	test_users_login(nickname, pwd, times)
	local old_nickname = nickname
	test_users_change_nickname(old_nickname, new_nickname, times)
	local old_pwd = pwd
	test_users_change_pwd(new_nickname, old_pwd, new_pwd, times)
	users_delete(new_nickname, new_pwd, times)
end



skynet.start(function()
	test_main(nickname, pwd, times, new_nickname, new_pwd)
	--users.login("tmp_nickname", "tmp_pwd")
	skynet.exit()
end)