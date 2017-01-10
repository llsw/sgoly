--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-01-10 11:57:27
 --]]

local sgoly_valid_conf = {}

sgoly_valid_conf.users_nickname = 
{
	maxlen = 35,
	minlen = 1
}
	
sgoly_valid_conf.users_pwd = 
{
	maxlen = 16,
	minlen = 6
}

return sgoly_valid_conf