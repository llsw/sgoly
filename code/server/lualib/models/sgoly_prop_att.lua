--[[
 * @Version:     1.0
 * @Author:      GitHubNull
 * @Email:       641570479@qq.com
 * @github:      GitHubNull
 * @Description: This is about...
 * @DateTime:    2017-02-22 09:12:52
--]]

require "sgoly_query"

local prop_att = {}

--[[
函数说明：
		函数作用： insert
		传入参数： name(prop name), describe(prop describe), img(prop img)
		返回参数： (true, true_msg) or (false, err_msg)
--]]
function prop_att.insert(name, describe, img)
	local sql = string.format([[insert into prop_att(id, name, describe, img) value(null, '%s', '%s', 
								'%s');]], name, describe, img)
  	local status = mysql_query(sql)
  	if(0 == status.warning_count) then
    	return true, "插入成功"
  	else
    	return false, "插入失败"
  	end
end

--[[
函数说明：
		函数作用： select name, describe, img
		传入参数： id(prop id)
		返回参数： (true, value) or (false, err_msg)
--]]
function prop_att.select(id)
	local sql = string.format([[SELECT _name, _describe, img FROM sgoly.prop_att
								 where id =  %d;]], id)
	local status = mysql_query(sql)
	local res = {}
	if(1 <= #status) then
		res._name = status[1]._name
		res._describe = status[1]._describe
		res.img = status[1].img
		return true, res
	else
	    return false, res
	end
end

return prop_att